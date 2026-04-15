package service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/reservation_voiture";
    private static final String USER = "postgres";
    private static final String PASSWORD = "3198";

    /**
     * Retourne une connexion partagée (singleton).
     * IMPORTANT : Ne PAS fermer cette connexion via try-with-resources.
     * Utiliser directement : Connection conn = DatabaseConnection.getConnection();
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver PostgreSQL introuvable: " + e.getMessage());
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void closeConnection() {
        // Chaque connexion est fermée par try-with-resources, plus besoin de singleton
    }
}
