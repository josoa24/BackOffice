package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardService {

    // --- KPIs principaux ---

    public int getTotalReservations() throws SQLException {
        String query = "SELECT COUNT(*) FROM reservation";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getReservationsAujourdHui(LocalDate date) throws SQLException {
        String query = "SELECT COUNT(*) FROM reservation WHERE DATE(dateHeure) = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setDate(1, java.sql.Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTotalHotels() throws SQLException {
        String query = "SELECT COUNT(*) FROM hotel";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getTotalVehicules() throws SQLException {
        String query = "SELECT COUNT(*) FROM vehicule";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getTotalAssignations() throws SQLException {
        String query = "SELECT COUNT(*) FROM assignation";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getTotalPassagers() throws SQLException {
        String query = "SELECT COALESCE(SUM(nbPassager), 0) FROM reservation";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // --- Réservations par hôtel (pour graphique) ---

    public List<Map<String, Object>> getReservationsParHotel() throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT h.nom, COUNT(r.id_reservation) as nb_reservations, COALESCE(SUM(r.nbPassager), 0) as nb_passagers " +
                       "FROM hotel h LEFT JOIN reservation r ON h.id_hotel = r.id_hotel " +
                       "GROUP BY h.nom ORDER BY nb_reservations DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("hotel", rs.getString("nom"));
                row.put("reservations", rs.getInt("nb_reservations"));
                row.put("passagers", rs.getInt("nb_passagers"));
                result.add(row);
            }
        }
        return result;
    }

    // --- Réservations par jour (7 derniers jours) ---

    public List<Map<String, Object>> getReservationsParJour(int nbJours) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT DATE(dateHeure) as jour, COUNT(*) as nb, COALESCE(SUM(nbPassager), 0) as passagers " +
                       "FROM reservation " +
                       "WHERE DATE(dateHeure) >= CURRENT_DATE - INTERVAL '" + nbJours + " days' " +
                       "GROUP BY DATE(dateHeure) ORDER BY jour";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("jour", rs.getDate("jour").toString());
                row.put("reservations", rs.getInt("nb"));
                row.put("passagers", rs.getInt("passagers"));
                result.add(row);
            }
        }
        return result;
    }

    // --- Véhicules par carburant ---

    public Map<String, Integer> getVehiculesParCarburant() throws SQLException {
        Map<String, Integer> result = new HashMap<>();
        String query = "SELECT carburant, COUNT(*) as nb FROM vehicule GROUP BY carburant";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                result.put(rs.getString("carburant"), rs.getInt("nb"));
            }
        }
        return result;
    }

    // --- Taux d'assignation ---

    public double getTauxAssignation() throws SQLException {
        int totalRes = getTotalReservations();
        if (totalRes == 0) return 0;
        int totalAssign = getTotalAssignations();
        return Math.round((double) totalAssign / totalRes * 10000.0) / 100.0;
    }

    // --- Dernières réservations ---

    public List<Map<String, Object>> getDernieresReservations(int limit) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT r.id_reservation, r.id_client, r.nbPassager, r.dateHeure, h.nom as hotel_nom, " +
                       "CASE WHEN a.id_assignation IS NOT NULL THEN true ELSE false END as assignee " +
                       "FROM reservation r " +
                       "JOIN hotel h ON r.id_hotel = h.id_hotel " +
                       "LEFT JOIN assignation a ON r.id_reservation = a.id_reservation " +
                       "ORDER BY r.dateHeure DESC LIMIT " + limit;
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("idReservation", rs.getInt("id_reservation"));
                row.put("idClient", rs.getInt("id_client"));
                row.put("nbPassager", rs.getInt("nbPassager"));
                row.put("dateHeure", rs.getTimestamp("dateHeure").toLocalDateTime().toString());
                row.put("hotel", rs.getString("hotel_nom"));
                row.put("assignee", rs.getBoolean("assignee"));
                result.add(row);
            }
        }
        return result;
    }

    // --- Top véhicules utilisés ---

    public List<Map<String, Object>> getTopVehicules(int limit) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String query = "SELECT v.marque, v.modele, v.immatriculation, v.carburant, v.capacite, COUNT(a.id_assignation) as nb_missions " +
                       "FROM vehicule v LEFT JOIN assignation a ON v.id_vehicule = a.id_vehicule " +
                       "GROUP BY v.id_vehicule, v.marque, v.modele, v.immatriculation, v.carburant, v.capacite " +
                       "ORDER BY nb_missions DESC LIMIT " + limit;
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("marque", rs.getString("marque"));
                row.put("modele", rs.getString("modele"));
                row.put("immatriculation", rs.getString("immatriculation"));
                row.put("carburant", rs.getString("carburant"));
                row.put("capacite", rs.getInt("capacite"));
                row.put("missions", rs.getInt("nb_missions"));
                result.add(row);
            }
        }
        return result;
    }

    // --- Moyenne passagers par réservation ---

    public double getMoyennePassagers() throws SQLException {
        String query = "SELECT COALESCE(AVG(nbPassager), 0) FROM reservation";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) return Math.round(rs.getDouble(1) * 100.0) / 100.0;
        }
        return 0;
    }
}
