package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.Hotel;

public class HotelService {
    
    public List<Hotel> getAllHotels() throws SQLException {
        List<Hotel> hotels = new ArrayList<>();
        String query = "SELECT id_hotel, nom FROM hotel ORDER BY id_hotel";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Hotel hotel = new Hotel();
                hotel.setIdHotel(rs.getInt("id_hotel"));
                hotel.setNom(rs.getString("nom"));
                hotels.add(hotel);
            }
        }
        
        return hotels;
    }
    
    public Hotel getHotelById(int idHotel) throws SQLException {
        String query = "SELECT id_hotel, nom FROM hotel WHERE id_hotel = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, idHotel);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setIdHotel(rs.getInt("id_hotel"));
                    hotel.setNom(rs.getString("nom"));
                    return hotel;
                }
            }
        }
        
        return null;
    }
    
    public void insertHotel(String nom) throws SQLException {
        String query = "INSERT INTO hotel (nom) VALUES (?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, nom);
            pstmt.executeUpdate();
            System.out.println("Hôtel ajouté avec succès: " + nom);
        }
    }
    
    public void updateHotel(int idHotel, String nom) throws SQLException {
        String query = "UPDATE hotel SET nom = ? WHERE id_hotel = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, nom);
            pstmt.setInt(2, idHotel);
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Hôtel mis à jour avec succès");
            } else {
                System.out.println("Aucun hôtel trouvé avec l'ID: " + idHotel);
            }
        }
    }
    
    public void deleteHotel(int idHotel) throws SQLException {
        String query = "DELETE FROM hotel WHERE id_hotel = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, idHotel);
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Hôtel supprimé avec succès");
            } else {
                System.out.println("Aucun hôtel trouvé avec l'ID: " + idHotel);
            }
        }
    }
}
