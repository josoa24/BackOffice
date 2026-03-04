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

import entity.Reservation;
import entity.Hotel;

public class ReservationService {
    
    public int enregistrerReservation(int idClient, int nbPassager, LocalDateTime dateHeure, int idHotel) throws SQLException {
        String query = "INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, idClient);
            pstmt.setInt(2, nbPassager);
            pstmt.setTimestamp(3, Timestamp.valueOf(dateHeure));
            pstmt.setInt(4, idHotel);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int idReservation = generatedKeys.getInt(1);
                        System.out.println("Réservation enregistrée avec succès. ID: " + idReservation);
                        return idReservation;
                    }
                }
            }
        }
        
        throw new SQLException("Échec de l'enregistrement de la réservation");
    }
    
    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, h.nom as hotel_nom " +
                      "FROM reservation r JOIN hotel h ON r.id_hotel = h.id_hotel ORDER BY r.dateHeure DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
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
                reservation.setHotel(hotel);
                
                reservations.add(reservation);
            }
        }
        
        return reservations;
    }
    
    public List<Reservation> getReservationsByDate(LocalDate date) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, h.nom as hotel_nom " +
                      "FROM reservation r JOIN hotel h ON r.id_hotel = h.id_hotel " +
                      "WHERE DATE(r.dateHeure) = ? " +
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
                    reservation.setHotel(hotel);
                    
                    reservations.add(reservation);
                }
            }
        }
        
        return reservations;
    }
    
    public Reservation getReservationById(int idReservation) throws SQLException {
        String query = "SELECT r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, r.id_hotel, h.nom as hotel_nom " +
                      "FROM reservation r JOIN hotel h ON r.id_hotel = h.id_hotel WHERE r.id_reservation = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, idReservation);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Reservation reservation = new Reservation();
                    reservation.setIdReservation(rs.getInt("id_reservation"));
                    reservation.setIdClient(rs.getInt("id_client"));
                    reservation.setNbPassager(rs.getInt("nbPassager"));
                    reservation.setDateHeure(rs.getTimestamp("dateHeure").toLocalDateTime());
                    reservation.setIdHotel(rs.getInt("id_hotel"));
                    
                    Hotel hotel = new Hotel();
                    hotel.setIdHotel(rs.getInt("id_hotel"));
                    hotel.setNom(rs.getString("hotel_nom"));
                    reservation.setHotel(hotel);
                    
                    return reservation;
                }
            }
        }
        
        return null;
    }
    
    public void updateReservation(int idReservation, int idClient, int nbPassager, LocalDateTime dateHeure, int idHotel) throws SQLException {
        String query = "UPDATE reservation SET id_client = ?, nbPassager = ?, dateHeure = ?, id_hotel = ? WHERE id_reservation = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, idClient);
            pstmt.setInt(2, nbPassager);
            pstmt.setTimestamp(3, Timestamp.valueOf(dateHeure));
            pstmt.setInt(4, idHotel);
            pstmt.setInt(5, idReservation);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Réservation mise à jour avec succès");
            } else {
                System.out.println("Aucune réservation trouvée avec l'ID: " + idReservation);
            }
        }
    }
    
    public void deleteReservation(int idReservation) throws SQLException {
        String query = "DELETE FROM reservation WHERE id_reservation = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, idReservation);
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Réservation supprimée avec succès");
            } else {
                System.out.println("Aucune réservation trouvée avec l'ID: " + idReservation);
            }
        }
    }
}
