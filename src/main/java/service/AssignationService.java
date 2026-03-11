package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import entity.Assignation;
import entity.Hotel;
import entity.Reservation;
import entity.Vehicule;

public class AssignationService {

    private VehiculeService vehiculeService = new VehiculeService();
    private DistanceService distanceService = new DistanceService();

    // Vitesse moyenne en km/h
    private static final double VITESSE_MOYENNE = 60.0;
    // Temps d'attente en minutes
    private static final int TEMPS_ATTENTE_MINUTES = 15;

    /**
     * Assigner automatiquement des véhicules aux réservations d'une date donnée
     */
    public List<Assignation> assignerVehiculesParDate(LocalDate date) throws SQLException {
        List<Assignation> assignations = new ArrayList<>();
        // Récupérer les réservations du jour qui ne sont pas encore assignées
        List<Reservation> reservations = getReservationsNonAssignees(date);

        for (Reservation reservation : reservations) {
            // Trouver le meilleur véhicule disponible
            Vehicule vehicule = vehiculeService.trouverMeilleurVehiculeDisponible(
                reservation.getNbPassager(), reservation.getDateHeure()
            );

            if (vehicule != null) {
                // Calculer la distance entre l'aéroport et l'hôtel
                double distanceKm = distanceService.getDistance(1, reservation.getIdHotel());
                
                // Calculer le temps de trajet en minutes
                double tempsTrajetMinutes = (distanceKm / VITESSE_MOYENNE) * 60;
                
                // Heure de départ = heure de la réservation + temps d'attente
                LocalDateTime heureDepart = reservation.getDateHeure()
                    .plusMinutes(TEMPS_ATTENTE_MINUTES);
                
                // Heure d'arrivée = heure de départ + temps de trajet
                LocalDateTime heureArrivee = heureDepart
                    .plusMinutes((long) Math.ceil(tempsTrajetMinutes));

                // Enregistrer l'assignation
                Assignation assignation = enregistrerAssignation(
                    reservation.getIdReservation(),
                    vehicule.getIdVehicule(),
                    heureDepart,
                    heureArrivee
                );

                assignation.setReservation(reservation);
                assignation.setVehicule(vehicule);
                assignations.add(assignation);
            }
        }

        return assignations;
    }

    /**
     * Récupérer les réservations non encore assignées pour une date
     */
    private List<Reservation> getReservationsNonAssignees(LocalDate date) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, " +
                       "h.nom as hotel_nom, h.code as hotel_code, h.libelle as hotel_libelle " +
                       "FROM reservation r " +
                       "JOIN hotel h ON r.id_hotel = h.id_hotel " +
                       "WHERE DATE(r.dateHeure) = ? " +
                       "AND r.id_reservation NOT IN (SELECT id_reservation FROM assignation) " +
                       "ORDER BY r.dateHeure";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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

                    reservations.add(reservation);
                }
            }
        }

        return reservations;
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
     * Récupérer toutes les assignations pour une date
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
                       "WHERE DATE(r.dateHeure) = ? " +
                       "ORDER BY a.heure_depart";

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

                    // Reservation
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

                    // Vehicule
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
