package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
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
     * Sprint 3 : Trouver le meilleur véhicule pour un nombre de passagers
     * Règles :
     * 1. Capacité >= nbPassager
     * 2. Capacité la plus proche du nombre de passagers
     * 3. Priorité Diesel
     * 4. Si encore égalité Diesel : random (via ORDER BY RANDOM())
     */
    public Vehicule trouverMeilleurVehicule(int nbPassager) throws SQLException {
        String query = "SELECT id_vehicule, marque, modele, immatriculation, capacite, carburant " +
                "FROM vehicule " +
                "WHERE capacite >= ? " +
                "ORDER BY capacite ASC, " +
                "CASE WHEN carburant = 'diesel' THEN 0 ELSE 1 END ASC, " +
                "RANDOM() " +
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

        return null;
    }

    /**
     * Sprint 4 : Trouver le meilleur véhicule en tenant compte de la capacité
     * restante
     * Un véhicule peut avoir plusieurs réservations tant que la capacité n'est pas
     * dépassée
     */
    public Vehicule trouverMeilleurVehiculeDisponible(int nbPassager, LocalDate date) throws SQLException {
        String query = "SELECT v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant, " +
                "(v.capacite - COALESCE(SUM(r.nbPassager), 0)) as places_restantes " +
                "FROM vehicule v " +
                "LEFT JOIN assignation a ON v.id_vehicule = a.id_vehicule AND DATE(a.heure_depart) = ? " +
                "LEFT JOIN reservation r ON a.id_reservation = r.id_reservation " +
                "GROUP BY v.id_vehicule, v.marque, v.modele, v.immatriculation, v.capacite, v.carburant " +
                "HAVING (v.capacite - COALESCE(SUM(r.nbPassager), 0)) >= ? " +
                "ORDER BY (v.capacite - COALESCE(SUM(r.nbPassager), 0)) ASC, " +
                "CASE WHEN v.carburant = 'diesel' THEN 0 ELSE 1 END ASC, " +
                "RANDOM() " +
                "LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDate(1, java.sql.Date.valueOf(date));
            pstmt.setInt(2, nbPassager);

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
