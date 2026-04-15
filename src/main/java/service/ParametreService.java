package service;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class ParametreService {

    /**
     * Récupère les paramètres du système
     */
    public Map<String, Integer> getParametres() throws SQLException {
        Map<String, Integer> params = new HashMap<>();
        String query = "SELECT vitesse_moyenne_vehicule, temps_attente FROM parametre LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                params.put("vitesse_moyenne", rs.getInt("vitesse_moyenne_vehicule"));
                params.put("temps_attente", rs.getInt("temps_attente"));
            } else {
                // Valeurs par défaut
                params.put("vitesse_moyenne", 60);
                params.put("temps_attente", 30);
            }
        }
        return params;
    }

    /**
     * Calcule la durée du trajet en minutes
     * durée = (distance_km / vitesse) * 60 + temps_attente
     */
    public int calculerDureeTrajet(double distanceKm) throws SQLException {
        Map<String, Integer> params = getParametres();
        int vitesse = params.get("vitesse_moyenne");
        int tempsAttente = params.get("temps_attente");

        // Temps de route en minutes
        int tempsRoute = (int) Math.ceil((distanceKm / vitesse) * 60);
        return tempsRoute + tempsAttente;
    }

    /**
     * Calcule l'heure d'arrivée
     */
    public LocalDateTime calculerHeureArrivee(LocalDateTime heureDepart, double distanceKm) throws SQLException {
        int dureeMinutes = calculerDureeTrajet(distanceKm);
        return heureDepart.plusMinutes(dureeMinutes);
    }
}
