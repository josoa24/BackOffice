package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

import entity.Token;

public class TokenService {

    /**
     * Génère un nouveau token pour un client avec une durée de validité en minutes.
     */
    public Token generateToken(int idClient, int dureeMinutes) throws SQLException {
        String tokenValue = UUID.randomUUID().toString();
        LocalDateTime dateExpiration = LocalDateTime.now().plusMinutes(dureeMinutes);

        String query = "INSERT INTO token (token, date_expiration, id_client) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, tokenValue);
            pstmt.setTimestamp(2, Timestamp.valueOf(dateExpiration));
            pstmt.setInt(3, idClient);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        Token token = new Token();
                        token.setIdToken(generatedKeys.getInt(1));
                        token.setToken(tokenValue);
                        token.setDateExpiration(dateExpiration);
                        token.setIdClient(idClient);
                        System.out.println("Token généré avec succès pour le client: " + idClient);
                        return token;
                    }
                }
            }
        }

        throw new SQLException("Échec de la génération du token");
    }

    /**
     * Valide un token : vérifie s'il existe et s'il n'est pas expiré.
     * Retourne le Token si valide, null sinon.
     */
    public Token validateToken(String tokenValue) throws SQLException {
        String query = "SELECT id_token, token, date_expiration, id_client FROM token WHERE token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, tokenValue);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Token token = new Token();
                    token.setIdToken(rs.getInt("id_token"));
                    token.setToken(rs.getString("token"));
                    token.setDateExpiration(rs.getTimestamp("date_expiration").toLocalDateTime());
                    token.setIdClient(rs.getInt("id_client"));

                    // Vérifier si le token est expiré
                    if (token.isExpired()) {
                        System.out.println("Token expiré pour le client: " + token.getIdClient());
                        return null;
                    }

                    return token;
                }
            }
        }

        return null; // Token non trouvé
    }

    /**
     * Vérifie si un token est expiré (sans le valider complètement).
     * Retourne true si expiré ou non trouvé.
     */
    public boolean isTokenExpired(String tokenValue) throws SQLException {
        String query = "SELECT date_expiration FROM token WHERE token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, tokenValue);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    LocalDateTime dateExpiration = rs.getTimestamp("date_expiration").toLocalDateTime();
                    return LocalDateTime.now().isAfter(dateExpiration);
                }
            }
        }

        return true; // Token non trouvé = considéré comme expiré
    }

    /**
     * Supprime un token (logout).
     */
    public void deleteToken(String tokenValue) throws SQLException {
        String query = "DELETE FROM token WHERE token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, tokenValue);
            pstmt.executeUpdate();
        }
    }

    /**
     * Supprime tous les tokens expirés de la base de données.
     */
    public int cleanExpiredTokens() throws SQLException {
        String query = "DELETE FROM token WHERE date_expiration < NOW()";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            int deleted = stmt.executeUpdate(query);
            System.out.println(deleted + " token(s) expiré(s) supprimé(s)");
            return deleted;
        }
    }

    /**
     * Récupère un token par sa valeur.
     */
    public Token getTokenByValue(String tokenValue) throws SQLException {
        String query = "SELECT id_token, token, date_expiration, id_client FROM token WHERE token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, tokenValue);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Token token = new Token();
                    token.setIdToken(rs.getInt("id_token"));
                    token.setToken(rs.getString("token"));
                    token.setDateExpiration(rs.getTimestamp("date_expiration").toLocalDateTime());
                    token.setIdClient(rs.getInt("id_client"));
                    return token;
                }
            }
        }

        return null;
    }
}
