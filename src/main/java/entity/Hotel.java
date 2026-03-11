package entity;

public class Hotel {
    private int idHotel;
    private String nom;
    private String code;
    private String libelle;

    public Hotel() {
    }

    public Hotel(int idHotel, String nom) {
        this.idHotel = idHotel;
        this.nom = nom;
    }

    public Hotel(int idHotel, String nom, String code, String libelle) {
        this.idHotel = idHotel;
        this.nom = nom;
        this.code = code;
        this.libelle = libelle;
    }

    public int getIdHotel() {
        return idHotel;
    }

    public void setIdHotel(int idHotel) {
        this.idHotel = idHotel;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "Hotel{" +
                "idHotel=" + idHotel +
                ", nom='" + nom + '\'' +
                ", code='" + code + '\'' +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}
