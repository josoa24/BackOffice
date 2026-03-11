package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import entity.Distance;
import entity.Hotel;

public class DistanceService {

    /**
     * Récupérer la distance entre deux hôtels/aéroports
     */
    public double getDistance(int idFrom, int idTo) throws SQLException {
        if (idFrom == idTo) return 0;

        String query = "SELECT distance_km FROM distance WHERE id_from = ? AND id_to = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, idFrom);
            pstmt.setInt(2, idTo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("distance_km");
                }
            }
        }

        return 0; // Distance non trouvée
    }

    /**
     * Récupérer toutes les distances
     */
    public List<Distance> getAllDistances() throws SQLException {
        List<Distance> distances = new ArrayList<>();
        String query = "SELECT d.id_distance, d.id_from, d.id_to, d.distance_km, " +
                       "hf.nom as from_nom, hf.code as from_code, " +
                       "ht.nom as to_nom, ht.code as to_code " +
                       "FROM distance d " +
                       "JOIN hotel hf ON d.id_from = hf.id_hotel " +
                       "JOIN hotel ht ON d.id_to = ht.id_hotel " +
                       "ORDER BY d.id_distance";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Distance dist = new Distance();
                dist.setIdDistance(rs.getInt("id_distance"));
                dist.setIdFrom(rs.getInt("id_from"));
                dist.setIdTo(rs.getInt("id_to"));
                dist.setDistanceKm(rs.getDouble("distance_km"));

                Hotel from = new Hotel();
                from.setIdHotel(rs.getInt("id_from"));
                from.setNom(rs.getString("from_nom"));
                from.setCode(rs.getString("from_code"));
                dist.setHotelFrom(from);

                Hotel to = new Hotel();
                to.setIdHotel(rs.getInt("id_to"));
                to.setNom(rs.getString("to_nom"));
                to.setCode(rs.getString("to_code"));
                dist.setHotelTo(to);

                distances.add(dist);
            }
        }

        return distances;
    }

    /**
     * Ajouter une distance
     */
    public void addDistance(int idFrom, int idTo, double distanceKm) throws SQLException {
        String query = "INSERT INTO distance (id_from, id_to, distance_km) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, idFrom);
            pstmt.setInt(2, idTo);
            pstmt.setDouble(3, distanceKm);
            pstmt.executeUpdate();
        }
    }
}
