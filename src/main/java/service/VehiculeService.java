package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.Vehicule;

public class VehiculeService {

    public List<Vehicule> getAllVehicules() throws SQLException {
        List<Vehicule> vehicules = new ArrayList<>();
        String query = "SELECT id_vehicule, marque, modele, immatriculation, capacite, carburant FROM vehicule ORDER BY capacite";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Vehicule v = new Vehicule();
                v.setIdVehicule(rs.getInt("id_vehicule"));
                v.setMarque(rs.getString("marque"));
                v.setModele(rs.getString("modele"));
                v.setImmatriculation(rs.getString("immatriculation"));
                v.setCapacite(rs.getInt("capacite"));
                v.setCarburant(rs.getString("carburant"));
                vehicules.add(v);
            }
        }

        return vehicules;
    }

    /**
     * Trouver le meilleur véhicule pour une réservation selon les règles :
     * 1. Capacité >= nbPassager
     * 2. Si plusieurs : celui dont la capacité est la plus proche du nombre de passagers
     * 3. Si encore égalité : celui qui est diesel
     */
    public Vehicule trouverMeilleurVehicule(int nbPassager) throws SQLException {
        // Requête ordonnée : capacité >= nbPassager, trié par capacité ASC puis diesel en priorité
        String query = "SELECT id_vehicule, marque, modele, immatriculation, capacite, carburant " +
                       "FROM vehicule " +
                       "WHERE capacite >= ? " +
                       "ORDER BY capacite ASC, " +
                       "CASE WHEN carburant = 'diesel' THEN 0 ELSE 1 END ASC " +
                       "LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, nbPassager);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Vehicule v = new Vehicule();
                    v.setIdVehicule(rs.getInt("id_vehicule"));
                    v.setMarque(rs.getString("marque"));
                    v.setModele(rs.getString("modele"));
                    v.setImmatriculation(rs.getString("immatriculation"));
                    v.setCapacite(rs.getInt("capacite"));
                    v.setCarburant(rs.getString("carburant"));
                    return v;
                }
            }
        }

        return null; // Aucun véhicule disponible
    }

    /**
     * Trouver le meilleur véhicule disponible (non déjà assigné à cette heure)
     */
    public Vehicule trouverMeilleurVehiculeDisponible(int nbPassager, java.time.LocalDateTime dateHeure) throws SQLException {
        String query = "SELECT v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant " +
                       "FROM vehicule v " +
                       "WHERE v.capacite >= ? " +
                       "AND v.id_vehicule NOT IN (" +
                       "    SELECT a.id_vehicule FROM assignation a " +
                       "    JOIN reservation r ON a.id_reservation = r.id_reservation " +
                       "    WHERE DATE(r.dateHeure) = DATE(?) " +
                       ") " +
                       "ORDER BY v.capacite ASC, " +
                       "CASE WHEN v.carburant = 'diesel' THEN 0 ELSE 1 END ASC " +
                       "LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, nbPassager);
            pstmt.setTimestamp(2, java.sql.Timestamp.valueOf(dateHeure));

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Vehicule v = new Vehicule();
                    v.setIdVehicule(rs.getInt("id_vehicule"));
                    v.setMarque(rs.getString("marque"));
                    v.setModele(rs.getString("modele"));
                    v.setImmatriculation(rs.getString("immatriculation"));
                    v.setCapacite(rs.getInt("capacite"));
                    v.setCarburant(rs.getString("carburant"));
                    return v;
                }
            }
        }

        return null;
    }
}
