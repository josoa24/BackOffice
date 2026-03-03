package entity;

import java.time.LocalDateTime;

public class Token {
    private int idToken;
    private String token;
    private LocalDateTime dateExpiration;
    private int idClient;

    public Token() {
    }

    public Token(int idToken, String token, LocalDateTime dateExpiration, int idClient) {
        this.idToken = idToken;
        this.token = token;
        this.dateExpiration = dateExpiration;
        this.idClient = idClient;
    }

    public int getIdToken() {
        return idToken;
    }

    public void setIdToken(int idToken) {
        this.idToken = idToken;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDateTime dateExpiration) {
        this.dateExpiration = dateExpiration;
    }

    public int getIdClient() {
        return idClient;
    }

    public void setIdClient(int idClient) {
        this.idClient = idClient;
    }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.dateExpiration);
    }

    @Override
    public String toString() {
        return "Token{" +
                "idToken=" + idToken +
                ", token='" + token + '\'' +
                ", dateExpiration=" + dateExpiration +
                ", idClient=" + idClient +
                '}';
    }
}
