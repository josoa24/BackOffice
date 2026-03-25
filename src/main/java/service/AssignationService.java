package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

import entity.Assignation;
import entity.Hotel;
import entity.Reservation;
import entity.Vehicule;

public class AssignationService {

    private VehiculeService vehiculeService = new VehiculeService();
    private ParametreService parametreService = new ParametreService();

    // ID aeroport par defaut si le code AER n'est pas trouve
    private static final int ID_AEROPORT_PAR_DEFAUT = 1;

    private static class GroupeAttente {
        private LocalDateTime heureDebutFenetre;
        private LocalDateTime heureFinFenetre;
        private LocalDateTime heureDepartGroupe;
        private List<Reservation> reservations;

        GroupeAttente(LocalDateTime heureDebutFenetre, LocalDateTime heureFinFenetre, List<Reservation> reservations) {
            this.heureDebutFenetre = heureDebutFenetre;
            this.heureFinFenetre = heureFinFenetre;
            this.reservations = reservations;
        }
    }

    private static class TrajetVehicule {
        private LocalDateTime heureDepart;
        private LocalDateTime heureRetourAeroport;

        TrajetVehicule(LocalDateTime heureDepart, LocalDateTime heureRetourAeroport) {
            this.heureDepart = heureDepart;
            this.heureRetourAeroport = heureRetourAeroport;
        }

        boolean estEnTrajet(LocalDateTime instant) {
            return (instant.isEqual(heureDepart) || instant.isAfter(heureDepart))
                    && (instant.isEqual(heureRetourAeroport) || instant.isBefore(heureRetourAeroport));
        }

        boolean estEffectueAvantOuA(LocalDateTime instant) {
            return heureDepart.isBefore(instant) || heureDepart.isEqual(instant);
        }
    }

    private static class EtatVehicule {
        private Vehicule vehicule;
        private List<TrajetVehicule> trajets;

        EtatVehicule(Vehicule vehicule) {
            this.vehicule = vehicule;
            this.trajets = new ArrayList<>();
        }

        boolean estDisponibleA(LocalDateTime heureDepart) {
            LocalTime heureDebutDisponibilite = vehicule.getHeureDebutDisponibilite();
            if (heureDebutDisponibilite != null && heureDepart.toLocalTime().isBefore(heureDebutDisponibilite)) {
                return false;
            }

            for (TrajetVehicule t : trajets) {
                // Disponible seulement APRES l'heure de retour (retour + 1 minute gere par le
                // caller)
                if (t.estEnTrajet(heureDepart)) {
                    return false;
                }
            }
            return true;
        }

        int getNombreTrajetsEffectuesA(LocalDateTime heureDepart) {
            int count = 0;
            for (TrajetVehicule t : trajets) {
                if (t.estEffectueAvantOuA(heureDepart)) {
                    count++;
                }
            }
            return count;
        }

        void ajouterTrajet(LocalDateTime heureDepart, LocalDateTime heureRetourAeroport) {
            trajets.add(new TrajetVehicule(heureDepart, heureRetourAeroport));
        }
    }

    private static class DemandeReservation {
        private Reservation reservation;
        private int passagersRestants;
        private int prioriteInitiale;
        private LocalDateTime heureVol;
        private boolean reportPrioritaire;

        DemandeReservation(Reservation reservation, boolean reportPrioritaire) {
            this.reservation = reservation;
            this.passagersRestants = reservation.getNbPassager();
            this.prioriteInitiale = reservation.getNbPassager();
            this.heureVol = reservation.getDateHeure();
            this.reportPrioritaire = reportPrioritaire;
        }
    }

    private static class AllocationPartielle {
        private Reservation reservation;
        private int nbPassagersAssignes;

        AllocationPartielle(Reservation reservation, int nbPassagersAssignes) {
            this.reservation = reservation;
            this.nbPassagersAssignes = nbPassagersAssignes;
        }
    }

    /**
     * Recupere les reservations NON ASSIGNEES pour une date donnee
     * Avec les informations de l'hotel
     */
    public List<Reservation> getReservationsNonAssignees(LocalDate date) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT r.id_reservation, r.id_client, " +
                "(r.nbPassager - COALESCE(SUM(a.nb_passagers_assignes), 0)) as nbPassager, " +
                "r.dateHeure, r.id_hotel, " +
                "h.nom as hotel_nom, h.code as hotel_code, h.libelle as hotel_libelle " +
                "FROM reservation r " +
                "JOIN hotel h ON r.id_hotel = h.id_hotel " +
                "LEFT JOIN assignation a ON a.id_reservation = r.id_reservation " +
                "WHERE DATE(r.dateHeure) = ? " +
                "GROUP BY r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, h.nom, h.code, h.libelle "
                +
                "HAVING (r.nbPassager - COALESCE(SUM(a.nb_passagers_assignes), 0)) > 0 " +
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
     * Recupere les vehicules avec leur capacite restante pour une date donnee
     */
    public List<Map<String, Object>> getVehiculesAvecCapaciteRestante(LocalDate date) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant, v.heure_debut_disponibilite, "
                +
                "COALESCE(SUM(a.nb_passagers_assignes), 0) as passagers_assignes " +
                "FROM vehicule v " +
                "LEFT JOIN assignation a ON v.id_vehicule = a.id_vehicule AND DATE(a.heure_depart) = ? " +
                "GROUP BY v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant, v.heure_debut_disponibilite "
                +
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
                    java.sql.Time heureDisponibiliteSql = rs.getTime("heure_debut_disponibilite");
                    LocalTime heureDisponibilite = heureDisponibiliteSql != null
                            ? heureDisponibiliteSql.toLocalTime()
                            : LocalTime.MIN;
                    v.setHeureDebutDisponibilite(heureDisponibilite);

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
     * Pre-charge toutes les distances depuis l'aeroport en une seule requete
     */
    private int getIdAeroport(Connection conn) throws SQLException {
        String query = "SELECT id_hotel FROM hotel WHERE UPPER(code) = 'AER' ORDER BY id_hotel LIMIT 1";
        try (PreparedStatement pstmt = conn.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("id_hotel");
            }
        }
        return ID_AEROPORT_PAR_DEFAUT;
    }

    private Map<Integer, Double> chargerDistancesDepuisAeroport() throws SQLException {
        Map<Integer, Double> distances = new HashMap<>();
        String query = "SELECT id_from, id_to, distance_km FROM distance WHERE id_from = ? OR id_to = ?";

        Connection conn = DatabaseConnection.getConnection();
        int idAeroport = getIdAeroport(conn);
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, idAeroport);
        pstmt.setInt(2, idAeroport);
        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            int idFrom = rs.getInt("id_from");
            int idTo = rs.getInt("id_to");
            double distance = rs.getDouble("distance_km");

            if (idFrom == idAeroport && idTo != idAeroport) {
                distances.put(idTo, distance);
            } else if (idTo == idAeroport && idFrom != idAeroport) {
                distances.putIfAbsent(idFrom, distance);
            }
        }

        rs.close();
        pstmt.close();

        return distances;
    }

    private double getDistanceAllerKm(int idHotel, Map<Integer, Double> distancesMap) throws SQLException {
        Double distance = distancesMap.get(idHotel);
        if (distance == null || distance <= 0.0) {
            throw new SQLException(
                    "Distance aeroport-hotel introuvable ou invalide pour id_hotel=" + idHotel
                            + ". Verifiez la table distance.");
        }
        return distance;
    }

    /**
     * Sprint 5 + Sprint 6
     * Sprint 5: regroupement des reservations par fenetre temporelle (temps
     * d'attente TA)
     * Sprint 6: choix du vehicule selon nombre de trajets et disponibilite reelle
     */
    public List<Assignation> assignerVehiculesParDate(LocalDate date) throws SQLException {
        List<Assignation> nouvellesAssignations = new ArrayList<>();

        List<Reservation> reservations = getReservationsNonAssignees(date);
        if (reservations.isEmpty()) {
            return nouvellesAssignations;
        }

        Map<Integer, Double> distancesMap = chargerDistancesDepuisAeroport();
        Map<String, Integer> params = parametreService.getParametres();
        int vitesse = params.get("vitesse_moyenne");
        int tempsAttente = params.get("temps_attente");

        List<Vehicule> tousVehicules = vehiculeService.getAllVehicules();
        Map<Integer, EtatVehicule> etatsVehicules = chargerEtatVehicules(date, tousVehicules);

        List<GroupeAttente> groupesAttente = construireGroupesAttente(reservations, tempsAttente);
        Map<Integer, List<DemandeReservation>> reportsParHotel = new HashMap<>();

        for (GroupeAttente groupeAttente : groupesAttente) {
            Map<Integer, List<Reservation>> groupesParHotel = new LinkedHashMap<>();
            for (Reservation r : groupeAttente.reservations) {
                groupesParHotel.computeIfAbsent(r.getIdHotel(), k -> new ArrayList<>()).add(r);
            }

            // Conserver l'ordre par proximite aeroport pour rester coherent avec Sprint 3
            List<Map.Entry<Integer, List<Reservation>>> groupesTries = new ArrayList<>(groupesParHotel.entrySet());
            groupesTries.sort((a, b) -> Double.compare(
                    distancesMap.getOrDefault(a.getKey(), 999999.0),
                    distancesMap.getOrDefault(b.getKey(), 999999.0)));

            for (Map.Entry<Integer, List<Reservation>> entry : groupesTries) {
                int idHotel = entry.getKey();
                List<Reservation> groupeReservations = entry.getValue();

                double distanceAllerKm = getDistanceAllerKm(idHotel, distancesMap);
                int tempsRouteAllerMinutes = (int) Math.ceil((distanceAllerKm / vitesse) * 60);
                LocalDateTime heureDepart = groupeAttente.heureDepartGroupe;
                LocalDateTime heureRetourAeroport = heureDepart.plusMinutes(tempsRouteAllerMinutes * 2L);

                List<DemandeReservation> demandes = new ArrayList<>();
                List<DemandeReservation> reports = reportsParHotel.remove(idHotel);
                if (reports != null && !reports.isEmpty()) {
                    demandes.addAll(reports);
                }
                for (Reservation r : groupeReservations) {
                    demandes.add(new DemandeReservation(r, false));
                }

                while (!demandes.isEmpty()) {
                    EtatVehicule etat = choisirVehiculePourCapacite(
                            1,
                            heureDepart,
                            etatsVehicules,
                            false);

                    if (etat == null) {
                        int passagersNonAssignes = 0;
                        for (DemandeReservation d : demandes) {
                            passagersNonAssignes += d.passagersRestants;
                        }
                        System.err.println("Capacite insuffisante pour le groupe hotel " + idHotel +
                                " a " + heureDepart + ". Passagers reportes: " + passagersNonAssignes);
                        // Sprint 7: report vers le prochain regroupement/vol du meme hotel
                        for (DemandeReservation d : demandes) {
                            d.reportPrioritaire = true;
                        }
                        reportsParHotel.computeIfAbsent(idHotel, k -> new ArrayList<>()).addAll(demandes);
                        break;
                    }

                    int capaciteVehicule = etat.vehicule.getCapacite();
                    int capaciteRestanteVehicule = capaciteVehicule;
                    List<AllocationPartielle> allocations = new ArrayList<>();

                    while (!demandes.isEmpty() && capaciteRestanteVehicule > 0) {
                        DemandeReservation d = choisirDemandePlusProcheDuLibre(demandes, capaciteRestanteVehicule);
                        if (d == null) {
                            break;
                        }

                        int nbAffectes = Math.min(d.passagersRestants, capaciteRestanteVehicule);
                        if (nbAffectes <= 0) {
                            demandes.remove(d);
                            continue;
                        }

                        allocations.add(new AllocationPartielle(d.reservation, nbAffectes));
                        d.passagersRestants -= nbAffectes;
                        capaciteRestanteVehicule -= nbAffectes;

                        if (d.passagersRestants == 0) {
                            demandes.remove(d);
                        }
                    }

                    if (allocations.isEmpty()) {
                        break;
                    }

                    double kilometrage = distanceAllerKm * 2.0;
                    enregistrerBatchAssignationsPartielles(
                            allocations,
                            etat,
                            heureDepart,
                            heureRetourAeroport,
                            kilometrage,
                            idHotel,
                            nouvellesAssignations);
                }
            }
        }

        return nouvellesAssignations;
    }

    /**
     * Selection dynamique de la demande la plus proche des places libres du
     * vehicule.
     * Priorites:
     * 1) reports en attente
     * 2) proximite avec la capacite libre (valeur absolue)
     * 3) heure de vol la plus ancienne
     * 4) id_reservation croissant
     */
    private DemandeReservation choisirDemandePlusProcheDuLibre(
            List<DemandeReservation> demandes,
            int capaciteRestanteVehicule) {
        if (demandes == null || demandes.isEmpty()) {
            return null;
        }

        DemandeReservation meilleure = null;
        int meilleurEcart = Integer.MAX_VALUE;

        for (DemandeReservation d : demandes) {
            if (d.passagersRestants <= 0) {
                continue;
            }

            if (meilleure == null) {
                meilleure = d;
                meilleurEcart = Math.abs(d.passagersRestants - capaciteRestanteVehicule);
                continue;
            }

            if (d.reportPrioritaire && !meilleure.reportPrioritaire) {
                meilleure = d;
                meilleurEcart = Math.abs(d.passagersRestants - capaciteRestanteVehicule);
                continue;
            }
            if (!d.reportPrioritaire && meilleure.reportPrioritaire) {
                continue;
            }

            int ecart = Math.abs(d.passagersRestants - capaciteRestanteVehicule);
            if (ecart < meilleurEcart) {
                meilleure = d;
                meilleurEcart = ecart;
                continue;
            }
            if (ecart > meilleurEcart) {
                continue;
            }

            int cmpHeure = d.heureVol.compareTo(meilleure.heureVol);
            if (cmpHeure < 0) {
                meilleure = d;
                continue;
            }
            if (cmpHeure > 0) {
                continue;
            }

            if (d.reservation.getIdReservation() < meilleure.reservation.getIdReservation()) {
                meilleure = d;
            }
        }

        return meilleure;
    }

    private List<GroupeAttente> construireGroupesAttente(List<Reservation> reservations, int tempsAttenteMinutes) {
        List<GroupeAttente> groupes = new ArrayList<>();
        if (reservations.isEmpty()) {
            return groupes;
        }

        reservations.sort(Comparator.comparing(Reservation::getDateHeure));

        List<Reservation> courant = new ArrayList<>();
        LocalDateTime debutFenetre = reservations.get(0).getDateHeure();
        LocalDateTime finFenetre = debutFenetre.plusMinutes(tempsAttenteMinutes);
        courant.add(reservations.get(0));

        for (int i = 1; i < reservations.size(); i++) {
            Reservation r = reservations.get(i);
            LocalDateTime heureVol = r.getDateHeure();

            if (heureVol.isBefore(finFenetre) || heureVol.isEqual(finFenetre)) {
                courant.add(r);
            } else {
                groupes.add(creerGroupeAttente(debutFenetre, finFenetre, courant));

                courant = new ArrayList<>();
                debutFenetre = heureVol;
                finFenetre = debutFenetre.plusMinutes(tempsAttenteMinutes);
                courant.add(r);
            }
        }

        groupes.add(creerGroupeAttente(debutFenetre, finFenetre, courant));
        return groupes;
    }

    private GroupeAttente creerGroupeAttente(LocalDateTime debutFenetre, LocalDateTime finFenetre,
            List<Reservation> reservations) {
        List<Reservation> copie = new ArrayList<>(reservations);
        LocalDateTime departGroupe = copie.get(0).getDateHeure();

        for (Reservation r : copie) {
            if (r.getDateHeure().isAfter(departGroupe)) {
                departGroupe = r.getDateHeure();
            }
        }

        GroupeAttente g = new GroupeAttente(debutFenetre, finFenetre, copie);
        g.heureDepartGroupe = departGroupe;
        return g;
    }

    private Map<Integer, EtatVehicule> chargerEtatVehicules(LocalDate date, List<Vehicule> tousVehicules)
            throws SQLException {
        Map<Integer, EtatVehicule> etats = new HashMap<>();
        for (Vehicule v : tousVehicules) {
            etats.put(v.getIdVehicule(), new EtatVehicule(v));
        }

        String query = "SELECT id_vehicule, heure_depart, heure_arrivee " +
                "FROM assignation " +
                "WHERE DATE(heure_depart) = ? " +
                "GROUP BY id_vehicule, heure_depart, heure_arrivee";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int idVehicule = rs.getInt("id_vehicule");
                    EtatVehicule etat = etats.get(idVehicule);
                    if (etat != null) {
                        LocalDateTime heureDepart = rs.getTimestamp("heure_depart").toLocalDateTime();
                        LocalDateTime heureRetourAeroport = rs.getTimestamp("heure_arrivee").toLocalDateTime();
                        etat.ajouterTrajet(heureDepart, heureRetourAeroport);
                    }
                }
            }
        }

        return etats;
    }

    /**
     * Si capaciteExacte=true, capacite >= nbPassagers.
     * Sinon, on cherche juste le plus grand vehicule disponible (utile pour remplir
     * en plusieurs voyages).
     */
    private EtatVehicule choisirVehiculePourCapacite(
            int nbPassagers,
            LocalDateTime heureDepart,
            Map<Integer, EtatVehicule> etatsVehicules,
            boolean capaciteExacte) {

        List<EtatVehicule> candidats = new ArrayList<>();
        for (EtatVehicule etat : etatsVehicules.values()) {
            if (!etat.estDisponibleA(heureDepart)) {
                continue;
            }
            if (capaciteExacte && etat.vehicule.getCapacite() < nbPassagers) {
                continue;
            }
            candidats.add(etat);
        }

        if (candidats.isEmpty()) {
            return null;
        }

        // Sprint 6 (ordre exige par la regle):
        // 1) plus grande capacite par rapport au nombre de trajets effectues (ratio
        // capacite/(trajets+1))
        // 2) ensuite le moins de trajets (meme si essence)
        // 3) si meme nombre de trajets: diesel prioritaire
        // 4) si encore egalite complete: choix aleatoire

        // Etape 1: meilleur ratio capacite/trajets
        double meilleurRatio = Double.NEGATIVE_INFINITY;
        List<EtatVehicule> meilleursRatio = new ArrayList<>();
        for (EtatVehicule etat : candidats) {
            int trajets = etat.getNombreTrajetsEffectuesA(heureDepart);
            double ratio = etat.vehicule.getCapacite() / (double) (trajets + 1);

            if (ratio > meilleurRatio) {
                meilleurRatio = ratio;
                meilleursRatio.clear();
                meilleursRatio.add(etat);
            } else if (Double.compare(ratio, meilleurRatio) == 0) {
                meilleursRatio.add(etat);
            }
        }

        // Etape 2: moins de trajets
        int minTrajets = Integer.MAX_VALUE;
        List<EtatVehicule> meilleursTrajets = new ArrayList<>();
        for (EtatVehicule etat : meilleursRatio) {
            int trajets = etat.getNombreTrajetsEffectuesA(heureDepart);
            if (trajets < minTrajets) {
                minTrajets = trajets;
                meilleursTrajets.clear();
                meilleursTrajets.add(etat);
            } else if (trajets == minTrajets) {
                meilleursTrajets.add(etat);
            }
        }

        // Etape 3: diesel prioritaire si meme nb trajets
        List<EtatVehicule> dieselCandidats = new ArrayList<>();
        for (EtatVehicule etat : meilleursTrajets) {
            if ("diesel".equalsIgnoreCase(etat.vehicule.getCarburant())) {
                dieselCandidats.add(etat);
            }
        }
        List<EtatVehicule> finalistes = dieselCandidats.isEmpty() ? meilleursTrajets : dieselCandidats;

        // Etape 4: aleatoire si encore egalite
        int idx = ThreadLocalRandom.current().nextInt(finalistes.size());
        return finalistes.get(idx);
    }

    private void enregistrerBatchAssignationsPartielles(
            List<AllocationPartielle> allocations,
            EtatVehicule etatVehicule,
            LocalDateTime heureDepart,
            LocalDateTime heureRetourAeroport,
            double kilometrage,
            int idHotel,
            List<Assignation> nouvellesAssignations) throws SQLException {

        etatVehicule.ajouterTrajet(heureDepart, heureRetourAeroport);

        for (AllocationPartielle allocation : allocations) {
            Assignation assignation = enregistrerAssignation(
                    allocation.reservation.getIdReservation(),
                    etatVehicule.vehicule.getIdVehicule(),
                    heureDepart,
                    heureRetourAeroport,
                    kilometrage,
                    idHotel,
                    allocation.nbPassagersAssignes);
            assignation.setReservation(allocation.reservation);
            assignation.setVehicule(etatVehicule.vehicule);
            assignation.setNbPassagersAssignes(allocation.nbPassagersAssignes);
            nouvellesAssignations.add(assignation);
        }
    }

    /**
     * Enregistrer une assignation en base avec kilométrage et hôtel
     */
    public Assignation enregistrerAssignation(int idReservation, int idVehicule,
            LocalDateTime heureDepart, LocalDateTime heureArrivee, double kilometrage, int idHotel,
            int nbPassagersAssignes)
            throws SQLException {
        String query = "INSERT INTO assignation (id_reservation, id_vehicule, heure_depart, heure_arrivee, kilometrage, id_hotel, nb_passagers_assignes) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, idReservation);
            pstmt.setInt(2, idVehicule);
            pstmt.setTimestamp(3, Timestamp.valueOf(heureDepart));
            pstmt.setTimestamp(4, Timestamp.valueOf(heureArrivee));
            pstmt.setDouble(5, kilometrage);
            pstmt.setInt(6, idHotel);
            pstmt.setInt(7, nbPassagersAssignes);

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
                assignation.setKilometrage(kilometrage);
                assignation.setIdHotel(idHotel);
                assignation.setNbPassagersAssignes(nbPassagersAssignes);
                return assignation;
            }
        }
    }

    private int getPassagersRestantsReservation(int idReservation) throws SQLException {
        String query = "SELECT r.nbPassager - COALESCE(SUM(a.nb_passagers_assignes), 0) as restants " +
                "FROM reservation r " +
                "LEFT JOIN assignation a ON a.id_reservation = r.id_reservation " +
                "WHERE r.id_reservation = ? " +
                "GROUP BY r.nbPassager";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, idReservation);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return Math.max(rs.getInt("restants"), 0);
                }
            }
        }
        return 0;
    }

    /**
     * Assignation manuelle d'une reservation a un vehicule
     * Verifie capacite et disponibilite du vehicule
     */
    public void assignerReservationManuelle(int idReservation, int idVehicule, LocalDate date)
            throws SQLException {
        ReservationService reservationService = new ReservationService();
        Reservation reservation = reservationService.getReservationById(idReservation);
        if (reservation == null) {
            throw new SQLException("Reservation introuvable: " + idReservation);
        }

        int passagersRestants = getPassagersRestantsReservation(idReservation);
        if (passagersRestants <= 0) {
            throw new SQLException("Tous les passagers de la reservation sont deja assignes.");
        }

        int capaciteRestante = getCapaciteRestante(idVehicule, date);
        if (capaciteRestante < passagersRestants) {
            throw new SQLException("Capacite insuffisante! Le vehicule n'a que " +
                    capaciteRestante + " places restantes pour " +
                    passagersRestants + " passagers restants.");
        }

        Map<Integer, Double> distancesMap = chargerDistancesDepuisAeroport();
        double distanceKm = getDistanceAllerKm(reservation.getIdHotel(), distancesMap);
        Map<String, Integer> params = parametreService.getParametres();
        int vitesse = params.get("vitesse_moyenne");

        int tempsRouteAllerMinutes = (int) Math.ceil((distanceKm / vitesse) * 60);
        LocalDateTime heureDepart = reservation.getDateHeure();
        LocalDateTime heureRetourAeroport = heureDepart.plusMinutes(tempsRouteAllerMinutes * 2L);

        List<Vehicule> tousVehicules = vehiculeService.getAllVehicules();
        Map<Integer, EtatVehicule> etatsVehicules = chargerEtatVehicules(date, tousVehicules);
        EtatVehicule etat = etatsVehicules.get(idVehicule);

        if (etat != null && !etat.estDisponibleA(heureDepart)) {
            throw new SQLException("Le vehicule est deja en trajet a l'heure demandee.");
        }

        double kilometrage = distanceKm * 2.0;
        int idHotel = reservation.getIdHotel();
        enregistrerAssignation(idReservation, idVehicule, heureDepart, heureRetourAeroport, kilometrage, idHotel,
                passagersRestants);
    }

    /**
     * Recupere la capacite restante d'un vehicule pour une date
     */
    public int getCapaciteRestante(int idVehicule, LocalDate date) throws SQLException {
        String query = "SELECT v.capacite - COALESCE(SUM(a.nb_passagers_assignes), 0) as places_restantes " +
                "FROM vehicule v " +
                "LEFT JOIN assignation a ON v.id_vehicule = a.id_vehicule AND DATE(a.heure_depart) = ? " +
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
     * Recupere les trajets planifies pour une date donnee
     * Vue metier Sprint 5/6:
     * - un trajet = un groupe de depart (meme heure de depart aeroport)
     * - contient la liste des reservations et les vehicules utilises
     */
    public List<Map<String, Object>> getTrajets(LocalDate date) throws SQLException {
        List<Map<String, Object>> trajets = new ArrayList<>();
        String query = "SELECT a.heure_depart as heure_depart, " +
                "MAX(a.heure_arrivee) as heure_retour_aeroport, " +
                "COALESCE(MAX(a.kilometrage), 0) as kilometrage_parcouru, " +
                "COUNT(DISTINCT a.id_reservation) as nb_reservations, " +
                "SUM(a.nb_passagers_assignes) as total_passagers, " +
                "COALESCE(a.id_hotel, r.id_hotel) as id_hotel, " +
                "h.nom as hotel_nom, " +
                "COUNT(DISTINCT a.id_vehicule) as nb_vehicules, " +
                "STRING_AGG(DISTINCT (v.marque || ' ' || v.modele), ', ') as vehicules_utilises, " +
                "STRING_AGG( " +
                "  ('Res ' || r.id_reservation || ' (client ' || r.id_client || ', ' || a.nb_passagers_assignes || ' pax assignes, vol ' || TO_CHAR(r.dateHeure, 'HH24:MI') || ')'), "
                +
                "  ' | ' ORDER BY r.dateHeure, r.id_reservation " +
                ") as details_reservations " +
                "FROM assignation a " +
                "JOIN reservation r ON a.id_reservation = r.id_reservation " +
                "JOIN vehicule v ON a.id_vehicule = v.id_vehicule " +
                "JOIN hotel h ON h.id_hotel = COALESCE(a.id_hotel, r.id_hotel) " +
                "WHERE DATE(a.heure_depart) = ? " +
                "GROUP BY a.heure_depart, COALESCE(a.id_hotel, r.id_hotel), h.nom " +
                "ORDER BY a.heure_depart ASC";

        int indexTrajet = 0;

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> trajet = new HashMap<>();

                    int totalPassagers = rs.getInt("total_passagers");
                    double kilometrageParcouru = rs.getDouble("kilometrage_parcouru");

                    LocalDateTime heureDepart = rs.getTimestamp("heure_depart").toLocalDateTime();
                    LocalDateTime heureRetourAeroport = rs.getTimestamp("heure_retour_aeroport").toLocalDateTime();

                    indexTrajet++;

                    trajet.put("heureDepart", heureDepart);
                    trajet.put("heureRetourAeroport", heureRetourAeroport);
                    trajet.put("nbReservations", rs.getInt("nb_reservations"));
                    trajet.put("totalPassagers", totalPassagers);
                    trajet.put("kilometrageParcouru", kilometrageParcouru);
                    trajet.put("idHotel", rs.getInt("id_hotel"));
                    trajet.put("hotel", rs.getString("hotel_nom"));
                    trajet.put("nbVehicules", rs.getInt("nb_vehicules"));
                    trajet.put("vehiculesUtilises", rs.getString("vehicules_utilises"));
                    trajet.put("detailsReservations", rs.getString("details_reservations"));
                    trajet.put("numeroTrajet", indexTrajet);

                    trajets.add(trajet);
                }
            }
        }

        return trajets;
    }

    /**
     * Recuperer toutes les assignations pour une date avec details complets
     */
    public List<Assignation> getAssignationsByDate(LocalDate date) throws SQLException {
        List<Assignation> assignations = new ArrayList<>();
        String query = "SELECT a.id_assignation, a.id_reservation, a.id_vehicule, a.nb_passagers_assignes, a.heure_depart, a.heure_arrivee, a.kilometrage, a.id_hotel, "
                +
                "r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, " +
                "h.nom as hotel_nom, h.code as hotel_code, h.libelle as hotel_libelle, " +
                "v.marque, v.modele, v.immatriculation, v.capacite, v.carburant, v.heure_debut_disponibilite " +
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
                    assignation.setNbPassagersAssignes(rs.getInt("nb_passagers_assignes"));
                    assignation.setHeureDepart(rs.getTimestamp("heure_depart").toLocalDateTime());
                    assignation.setHeureArrivee(rs.getTimestamp("heure_arrivee").toLocalDateTime());
                    assignation.setKilometrage(rs.getDouble("kilometrage"));
                    assignation.setIdHotel(rs.getInt("id_hotel"));

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
                    java.sql.Time heureDisponibiliteSql = rs.getTime("heure_debut_disponibilite");
                    LocalTime heureDisponibilite = heureDisponibiliteSql != null
                            ? heureDisponibiliteSql.toLocalTime()
                            : LocalTime.MIN;
                    vehicule.setHeureDebutDisponibilite(heureDisponibilite);
                    assignation.setVehicule(vehicule);

                    assignations.add(assignation);
                }
            }
        }

        return assignations;
    }
}
