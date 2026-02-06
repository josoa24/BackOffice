package entity;

import java.time.LocalDateTime;

public class Reservation {
    private int idReservation;
    private int idClient;
    private int nbPassager;
    private LocalDateTime dateHeure;
    private int idHotel;

    public Reservation() {
    }

    public Reservation(int idReservation, int idClient, int nbPassager, LocalDateTime dateHeure, int idHotel) {
        this.idReservation = idReservation;
        setIdClient(idClient);
        this.nbPassager = nbPassager;
        this.dateHeure = dateHeure;
        this.idHotel = idHotel;
    }

    public int getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(int idReservation) {
        this.idReservation = idReservation;
    }

    public int getIdClient() {
        return idClient;
    }

    public void setIdClient(int idClient) {
        if (idClient < 1000 || idClient > 9999) {
            throw new IllegalArgumentException("L'id_client doit être un nombre à 4 chiffres (1000-9999)");
        }
        this.idClient = idClient;
    }

    public int getNbPassager() {
        return nbPassager;
    }

    public void setNbPassager(int nbPassager) {
        this.nbPassager = nbPassager;
    }

    public LocalDateTime getDateHeure() {
        return dateHeure;
    }

    public void setDateHeure(LocalDateTime dateHeure) {
        this.dateHeure = dateHeure;
    }

    public int getIdHotel() {
        return idHotel;
    }

    public void setIdHotel(int idHotel) {
        this.idHotel = idHotel;
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "idReservation=" + idReservation +
                ", idClient=" + idClient +
                ", nbPassager=" + nbPassager +
                ", dateHeure=" + dateHeure +
                ", idHotel=" + idHotel +
                '}';
    }
}
