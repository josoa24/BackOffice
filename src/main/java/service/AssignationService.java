package service;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import entity.Assignation;
import entity.Hotel;
import entity.Reservation;
import entity.Vehicule;

public class AssignationService {

    private VehiculeService vehiculeService = new VehiculeService();
    private DistanceService distanceService = new DistanceService();
    private ParametreService parametreService = new ParametreService();
    private HotelService hotelService = new HotelService();

    // ID de l'aéroport (point de départ de tous les trajets)
    private static final int ID_AEROPORT = 1;

    /**
     * Récupère les réservations NON ASSIGNÉES pour une date donnée
     * Avec les informations de l'hôtel
     */
    public List<Reservation> getReservationsNonAssignees(LocalDate date) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, " +
                "h.nom as hotel_nom, h.code as hotel_code, h.libelle as hotel_libelle " +
                "FROM reservation r " +
                "JOIN hotel h ON r.id_hotel = h.id_hotel " +
                "WHERE DATE(r.dateHeure) = ? " +
                "AND NOT EXISTS (SELECT 1 FROM assignation a WHERE a.id_reservation = r.id_reservation) " +
                "ORDER BY r.dateHeure ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setIdReservation(rs.getInt("id_reservation"));
                    r.setIdClient(rs.getInt("id_client"));
                    r.setNbPassager(rs.getInt("nbPassager"));
                    r.setDateHeure(rs.getTimestamp("dateHeure").toLocalDateTime());
                    r.setIdHotel(rs.getInt("id_hotel"));

                    Hotel hotel = new Hotel();
                    hotel.setIdHotel(rs.getInt("id_hotel"));
                    hotel.setNom(rs.getString("hotel_nom"));
                    hotel.setCode(rs.getString("hotel_code"));
                    hotel.setLibelle(rs.getString("hotel_libelle"));
                    r.setHotel(hotel);

                    reservations.add(r);
                }
            }
        }
        return reservations;
    }

    /**
     * Récupère les véhicules avec leur capacité restante pour une date donnée
     * (Sprint 4)
     * Un véhicule peut avoir plusieurs réservations tant que la capacité n'est pas
     * dépassée
     */
    public List<Map<String, Object>> getVehiculesAvecCapaciteRestante(LocalDate date) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant, " +
                "COALESCE(SUM(r.nbPassager), 0) as passagers_assignes " +
                "FROM vehicule v " +
                "LEFT JOIN assignation a ON v.id_vehicule = a.id_vehicule AND DATE(a.heure_depart) = ? " +
                "LEFT JOIN reservation r ON a.id_reservation = r.id_reservation " +
                "GROUP BY v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant " +
                "ORDER BY v.capacite ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> vInfo = new HashMap<>();
                    Vehicule v = new Vehicule();
                    v.setIdVehicule(rs.getInt("id_vehicule"));
                    v.setMarque(rs.getString("marque"));
                    v.setModele(rs.getString("modele"));
                    v.setImmatriculation(rs.getString("immatriculation"));
                    v.setCapacite(rs.getInt("capacite"));
                    v.setCarburant(rs.getString("carburant"));

                    int passagersAssignes = rs.getInt("passagers_assignes");
                    int placesRestantes = v.getCapacite() - passagersAssignes;

                    vInfo.put("vehicule", v);
                    vInfo.put("passagersAssignes", passagersAssignes);
                    vInfo.put("placesRestantes", placesRestantes);
                    result.add(vInfo);
                }
            }
        }
        return result;
    }

    /**
     * Pré-charger TOUTES les distances depuis l'aéroport en une seule requête
     * Evite les problèmes de connexion lors des appels multiples
     */
    private Map<Integer, Double> chargerDistancesDepuisAeroport() throws SQLException {
        Map<Integer, Double> distances = new HashMap<>();
        String query = "SELECT id_to, distance_km FROM distance WHERE id_from = ?";

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, ID_AEROPORT);
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            distances.put(rs.getInt("id_to"), rs.getDouble("distance_km"));
        }
        rs.close();
        pstmt.close();

        return distances;
    }

    /**
     * ALGORITHME PRINCIPAL - Sprint 3 + Sprint 4
     * Assigner automatiquement des véhicules aux réservations d'une date donnée
     *
     * Règles :
     * 1. Trajet vers la destination la plus proche de l'aéroport en premier
     * 2. Clients inséparables (même hôtel) doivent voyager ensemble
     * 3. Véhicule dont le nombre de places est le plus proche du nombre de clients
     * 4. Si plusieurs véhicules : priorité Diesel
     * 5. Si encore égalité Diesel : choix aléatoire (random)
     * 6. Sprint 4 : Un véhicule peut avoir plusieurs réservations pour le MÊME
     * hôtel
     */
    public List<Assignation> assignerVehiculesParDate(LocalDate date) throws SQLException {
        List<Assignation> nouvellesAssignations = new ArrayList<>();

        // 1. Récupérer les réservations non assignées
        List<Reservation> reservations = getReservationsNonAssignees(date);
        if (reservations.isEmpty()) {
            return nouvellesAssignations;
        }

        // 2. Pré-charger TOUTES les distances en une seule requête (évite les problèmes
        // de connexion)
        Map<Integer, Double> distancesMap = chargerDistancesDepuisAeroport();

        // 3. Charger les paramètres une seule fois
        Map<String, Integer> params = parametreService.getParametres();
        int vitesse = params.get("vitesse_moyenne");
        int tempsAttente = params.get("temps_attente");

        // 4. Grouper les réservations par hôtel (clients inséparables = même
        // destination)
        Map<Integer, List<Reservation>> groupesParHotel = new LinkedHashMap<>();
        for (Reservation r : reservations) {
            groupesParHotel.computeIfAbsent(r.getIdHotel(), k -> new ArrayList<>()).add(r);
        }

        // 5. Trier les groupes par distance depuis l'aéroport (le plus proche en
        // premier)
        List<Map.Entry<Integer, List<Reservation>>> groupesTries = new ArrayList<>(groupesParHotel.entrySet());
        groupesTries.sort((a, b) -> {
            double distA = distancesMap.getOrDefault(a.getKey(), 999999.0);
            double distB = distancesMap.getOrDefault(b.getKey(), 999999.0);
            return Double.compare(distA, distB);
        });

        // 6. Charger les véhicules disponibles (capacité totale, pas partagée entre
        // destinations)
        List<Vehicule> tousVehicules = vehiculeService.getAllVehicules();

        // Véhicules déjà utilisés aujourd'hui (par d'anciennes assignations)
        Set<Integer> vehiculesDejaUtilises = getVehiculesUtilises(date);

        // Ensemble pour tracker les véhicules assignés pendant cette exécution
        Set<Integer> vehiculesAssignesCetteExecution = new HashSet<>();

        // 7. Pour chaque groupe (par hôtel, trié par distance)
        for (Map.Entry<Integer, List<Reservation>> entry : groupesTries) {
            int idHotel = entry.getKey();
            List<Reservation> groupeReservations = entry.getValue();

            // Calculer le total de passagers pour ce groupe (Sprint 4 : inséparables)
            int totalPassagers = 0;
            for (Reservation r : groupeReservations) {
                totalPassagers += r.getNbPassager();
            }

            // 8. Trouver le meilleur véhicule DÉDIÉ à ce groupe
            Vehicule meilleurVehicule = trouverMeilleurVehicule(totalPassagers,
                    tousVehicules, vehiculesDejaUtilises, vehiculesAssignesCetteExecution);

            if (meilleurVehicule == null) {
                System.err.println("Aucun véhicule disponible pour " + totalPassagers +
                        " passagers vers l'hôtel " + idHotel);
                continue;
            }

            // Marquer ce véhicule comme utilisé (il ne sera plus disponible pour une autre
            // destination)
            vehiculesAssignesCetteExecution.add(meilleurVehicule.getIdVehicule());

            // 9. Calculer les heures de départ et d'arrivée
            double distanceKm = distancesMap.getOrDefault(idHotel, 0.0);

            // L'heure de départ = heure du premier client du groupe + temps d'attente
            LocalDateTime premiereDateHeure = groupeReservations.get(0).getDateHeure();
            for (Reservation r : groupeReservations) {
                if (r.getDateHeure().isBefore(premiereDateHeure)) {
                    premiereDateHeure = r.getDateHeure();
                }
            }
            LocalDateTime heureDepart = premiereDateHeure.plusMinutes(tempsAttente);

            // Temps de route = (distance / vitesse) * 60 minutes
            int tempsRouteMinutes = (int) Math.ceil((distanceKm / vitesse) * 60);
            LocalDateTime heureArrivee = heureDepart.plusMinutes(tempsRouteMinutes);

            // 10. Assigner toutes les réservations du groupe à ce véhicule
            for (Reservation r : groupeReservations) {
                Assignation assignation = enregistrerAssignation(
                        r.getIdReservation(),
                        meilleurVehicule.getIdVehicule(),
                        heureDepart,
                        heureArrivee);
                assignation.setReservation(r);
                assignation.setVehicule(meilleurVehicule);
                nouvellesAssignations.add(assignation);
            }
        }

        return nouvellesAssignations;
    }

    /**
     * Récupérer les IDs des véhicules déjà utilisés pour une date donnée
     */
    private Set<Integer> getVehiculesUtilises(LocalDate date) throws SQLException {
        Set<Integer> utilises = new HashSet<>();
        String query = "SELECT DISTINCT id_vehicule FROM assignation WHERE DATE(heure_depart) = ?";

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setDate(1, java.sql.Date.valueOf(date));
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            utilises.add(rs.getInt("id_vehicule"));
        }
        rs.close();
        pstmt.close();

        return utilises;
    }

    /**
     * Trouver le meilleur véhicule selon les règles Sprint 3 :
     * 1. Véhicule non encore utilisé pour cette date
     * 2. Capacité totale >= nbPassagers
     * 3. Capacité la plus proche du nombre de passagers
     * 4. Priorité Diesel
     * 5. Si encore égalité Diesel : choix aléatoire (random)
     */
    private Vehicule trouverMeilleurVehicule(int nbPassagers,
            List<Vehicule> tousVehicules,
            Set<Integer> vehiculesDejaUtilises,
            Set<Integer> vehiculesAssignesCetteExecution) {

        // Filtrer : non utilisé ET capacité suffisante
        List<Vehicule> candidats = new ArrayList<>();
        for (Vehicule v : tousVehicules) {
            if (!vehiculesDejaUtilises.contains(v.getIdVehicule())
                    && !vehiculesAssignesCetteExecution.contains(v.getIdVehicule())
                    && v.getCapacite() >= nbPassagers) {
                candidats.add(v);
            }
        }

        if (candidats.isEmpty()) {
            return null;
        }

        // Trier par : capacité la plus proche, puis diesel, puis random
        candidats.sort((a, b) -> {
            // Plus proche du nombre de passagers = différence la plus petite
            int diffA = a.getCapacite() - nbPassagers;
            int diffB = b.getCapacite() - nbPassagers;
            if (diffA != diffB)
                return Integer.compare(diffA, diffB);
            // Priorité diesel
            boolean dieselA = "diesel".equalsIgnoreCase(a.getCarburant());
            boolean dieselB = "diesel".equalsIgnoreCase(b.getCarburant());
            if (dieselA != dieselB)
                return dieselA ? -1 : 1;
            // Egalité totale
            return 0;
        });

        // Si les meilleurs candidats sont ex-aequo (même diff et même carburant),
        // choisir au hasard
        Vehicule premier = candidats.get(0);
        int premierDiff = premier.getCapacite() - nbPassagers;
        boolean premierDiesel = "diesel".equalsIgnoreCase(premier.getCarburant());

        List<Vehicule> exAequo = new ArrayList<>();
        for (Vehicule v : candidats) {
            int diff = v.getCapacite() - nbPassagers;
            boolean diesel = "diesel".equalsIgnoreCase(v.getCarburant());
            if (diff == premierDiff && diesel == premierDiesel) {
                exAequo.add(v);
            } else {
                break;
            }
        }

        // Choix aléatoire parmi les ex-aequo
        if (exAequo.size() > 1) {
            Random random = new Random();
            return exAequo.get(random.nextInt(exAequo.size()));
        }

        return premier;
    }

    /**
     * Enregistrer une assignation en base
     */
    public Assignation enregistrerAssignation(int idReservation, int idVehicule,
            LocalDateTime heureDepart, LocalDateTime heureArrivee) throws SQLException {
        String query = "INSERT INTO assignation (id_reservation, id_vehicule, heure_depart, heure_arrivee) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, idReservation);
            pstmt.setInt(2, idVehicule);
            pstmt.setTimestamp(3, Timestamp.valueOf(heureDepart));
            pstmt.setTimestamp(4, Timestamp.valueOf(heureArrivee));

            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                Assignation assignation = new Assignation();
                if (generatedKeys.next()) {
                    assignation.setIdAssignation(generatedKeys.getInt(1));
                }
                assignation.setIdReservation(idReservation);
                assignation.setIdVehicule(idVehicule);
                assignation.setHeureDepart(heureDepart);
                assignation.setHeureArrivee(heureArrivee);
                return assignation;
            }
        }
    }

    /**
     * Assigner manuellement une réservation à un véhicule
     * Vérifie que la capacité n'est pas dépassée (Sprint 4)
     */
    public void assignerReservationManuelle(int idReservation, int idVehicule, LocalDate date)
            throws SQLException {
        // Récupérer la réservation
        ReservationService reservationService = new ReservationService();
        Reservation reservation = reservationService.getReservationById(idReservation);
        if (reservation == null) {
            throw new SQLException("Réservation introuvable: " + idReservation);
        }

        // Vérifier la capacité restante du véhicule (Sprint 4)
        int capaciteRestante = getCapaciteRestante(idVehicule, date);
        if (capaciteRestante < reservation.getNbPassager()) {
            throw new SQLException("Capacité insuffisante! Le véhicule n'a que " +
                    capaciteRestante + " places restantes pour " +
                    reservation.getNbPassager() + " passagers.");
        }

        // Calculer les heures (pré-charger les distances pour éviter les problèmes de
        // connexion)
        Map<Integer, Double> distancesMap = chargerDistancesDepuisAeroport();
        double distanceKm = distancesMap.getOrDefault(reservation.getIdHotel(), 0.0);
        Map<String, Integer> params = parametreService.getParametres();
        LocalDateTime heureDepart = reservation.getDateHeure().plusMinutes(params.get("temps_attente"));
        int vitesse = params.get("vitesse_moyenne");
        int tempsRouteMinutes = (int) Math.ceil((distanceKm / vitesse) * 60);
        LocalDateTime heureArrivee = heureDepart.plusMinutes(tempsRouteMinutes);

        enregistrerAssignation(idReservation, idVehicule, heureDepart, heureArrivee);
    }

    /**
     * Récupère la capacité restante d'un véhicule pour une date
     */
    public int getCapaciteRestante(int idVehicule, LocalDate date) throws SQLException {
        String query = "SELECT v.capacite - COALESCE(SUM(r.nbPassager), 0) as places_restantes " +
                "FROM vehicule v " +
                "LEFT JOIN assignation a ON v.id_vehicule = a.id_vehicule AND DATE(a.heure_depart) = ? " +
                "LEFT JOIN reservation r ON a.id_reservation = r.id_reservation " +
                "WHERE v.id_vehicule = ? " +
                "GROUP BY v.capacite";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setDate(1, java.sql.Date.valueOf(date));
            pstmt.setInt(2, idVehicule);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("places_restantes");
                }
            }
        }
        return 0;
    }

    /**
     * Récupère les trajets planifiés pour une date donnée
     * Regroupe les réservations par véhicule (Sprint 4)
     */
    public List<Map<String, Object>> getTrajets(LocalDate date) throws SQLException {
        List<Map<String, Object>> trajets = new ArrayList<>();
        String query = "SELECT a.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant, " +
                "MIN(a.heure_depart) as heure_depart, MAX(a.heure_arrivee) as heure_arrivee, " +
                "COUNT(a.id_reservation) as nb_reservations, " +
                "SUM(r.nbPassager) as total_passagers " +
                "FROM assignation a " +
                "JOIN vehicule v ON a.id_vehicule = v.id_vehicule " +
                "JOIN reservation r ON a.id_reservation = r.id_reservation " +
                "WHERE DATE(a.heure_depart) = ? " +
                "GROUP BY a.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant " +
                "ORDER BY MIN(a.heure_depart) ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> trajet = new HashMap<>();
                    trajet.put("idVehicule", rs.getInt("id_vehicule"));
                    trajet.put("vehicule", rs.getString("marque") + " " + rs.getString("modele"));
                    trajet.put("immatriculation", rs.getString("immatriculation"));
                    trajet.put("capacite", rs.getInt("capacite"));
                    trajet.put("carburant", rs.getString("carburant"));
                    trajet.put("heureDepart", rs.getTimestamp("heure_depart").toLocalDateTime());
                    trajet.put("heureArrivee", rs.getTimestamp("heure_arrivee").toLocalDateTime());
                    trajet.put("nbReservations", rs.getInt("nb_reservations"));
                    trajet.put("totalPassagers", rs.getInt("total_passagers"));
                    int placesRestantes = rs.getInt("capacite") - rs.getInt("total_passagers");
                    trajet.put("placesRestantes", placesRestantes);
                    trajets.add(trajet);
                }
            }
        }
        return trajets;
    }

    /**
     * Récupérer toutes les assignations pour une date avec détails complets
     */
    public List<Assignation> getAssignationsByDate(LocalDate date) throws SQLException {
        List<Assignation> assignations = new ArrayList<>();
        String query = "SELECT a.id_assignation, a.id_reservation, a.id_vehicule, a.heure_depart, a.heure_arrivee, " +
                "r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, " +
                "h.nom as hotel_nom, h.code as hotel_code, h.libelle as hotel_libelle, " +
                "v.marque, v.modele, v.immatriculation, v.capacite, v.carburant " +
                "FROM assignation a " +
                "JOIN reservation r ON a.id_reservation = r.id_reservation " +
                "JOIN hotel h ON r.id_hotel = h.id_hotel " +
                "JOIN vehicule v ON a.id_vehicule = v.id_vehicule " +
                "WHERE DATE(a.heure_depart) = ? " +
                "ORDER BY a.heure_depart, h.nom";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Assignation assignation = new Assignation();
                    assignation.setIdAssignation(rs.getInt("id_assignation"));
                    assignation.setIdReservation(rs.getInt("id_reservation"));
                    assignation.setIdVehicule(rs.getInt("id_vehicule"));
                    assignation.setHeureDepart(rs.getTimestamp("heure_depart").toLocalDateTime());
                    assignation.setHeureArrivee(rs.getTimestamp("heure_arrivee").toLocalDateTime());

                    Reservation reservation = new Reservation();
                    reservation.setIdReservation(rs.getInt("id_reservation"));
                    reservation.setIdClient(rs.getInt("id_client"));
                    reservation.setNbPassager(rs.getInt("nbPassager"));
                    reservation.setDateHeure(rs.getTimestamp("dateHeure").toLocalDateTime());
                    reservation.setIdHotel(rs.getInt("id_hotel"));

                    Hotel hotel = new Hotel();
                    hotel.setIdHotel(rs.getInt("id_hotel"));
                    hotel.setNom(rs.getString("hotel_nom"));
                    hotel.setCode(rs.getString("hotel_code"));
                    hotel.setLibelle(rs.getString("hotel_libelle"));
                    reservation.setHotel(hotel);
                    assignation.setReservation(reservation);

                    Vehicule vehicule = new Vehicule();
                    vehicule.setIdVehicule(rs.getInt("id_vehicule"));
                    vehicule.setMarque(rs.getString("marque"));
                    vehicule.setModele(rs.getString("modele"));
                    vehicule.setImmatriculation(rs.getString("immatriculation"));
                    vehicule.setCapacite(rs.getInt("capacite"));
                    vehicule.setCarburant(rs.getString("carburant"));
                    assignation.setVehicule(vehicule);

                    assignations.add(assignation);
                }
            }
        }

        return assignations;
    }
}
