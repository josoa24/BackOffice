package entity;

import java.time.LocalDateTime;

public class Assignation {
    private int idAssignation;
    private int idReservation;
    private int idVehicule;
    private int nbPassagersAssignes;
    private LocalDateTime heureDepart;
    private LocalDateTime heureArrivee;
    private double kilometrage;
    private int idHotel;
    private Reservation reservation;
    private Vehicule vehicule;

    public Assignation() {
    }

    public int getIdAssignation() {
        return idAssignation;
    }

    public void setIdAssignation(int idAssignation) {
        this.idAssignation = idAssignation;
    }

    public int getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(int idReservation) {
        this.idReservation = idReservation;
    }

    public int getIdVehicule() {
        return idVehicule;
    }

    public void setIdVehicule(int idVehicule) {
        this.idVehicule = idVehicule;
    }

    public int getNbPassagersAssignes() {
        return nbPassagersAssignes;
    }

    public void setNbPassagersAssignes(int nbPassagersAssignes) {
        this.nbPassagersAssignes = nbPassagersAssignes;
    }

    public LocalDateTime getHeureDepart() {
        return heureDepart;
    }

    public void setHeureDepart(LocalDateTime heureDepart) {
        this.heureDepart = heureDepart;
    }

    public LocalDateTime getHeureArrivee() {
        return heureArrivee;
    }

    public void setHeureArrivee(LocalDateTime heureArrivee) {
        this.heureArrivee = heureArrivee;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public Vehicule getVehicule() {
        return vehicule;
    }

    public void setVehicule(Vehicule vehicule) {
        this.vehicule = vehicule;
    }

    public double getKilometrage() {
        return kilometrage;
    }

    public void setKilometrage(double kilometrage) {
        this.kilometrage = kilometrage;
    }

    public int getIdHotel() {
        return idHotel;
    }

    public void setIdHotel(int idHotel) {
        this.idHotel = idHotel;
    }
}
