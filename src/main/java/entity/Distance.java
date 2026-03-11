package entity;

public class Distance {
    private int idDistance;
    private int idFrom;
    private int idTo;
    private double distanceKm;
    private Hotel hotelFrom;
    private Hotel hotelTo;

    public Distance() {
    }

    public Distance(int idDistance, int idFrom, int idTo, double distanceKm) {
        this.idDistance = idDistance;
        this.idFrom = idFrom;
        this.idTo = idTo;
        this.distanceKm = distanceKm;
    }

    public int getIdDistance() {
        return idDistance;
    }

    public void setIdDistance(int idDistance) {
        this.idDistance = idDistance;
    }

    public int getIdFrom() {
        return idFrom;
    }

    public void setIdFrom(int idFrom) {
        this.idFrom = idFrom;
    }

    public int getIdTo() {
        return idTo;
    }

    public void setIdTo(int idTo) {
        this.idTo = idTo;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public Hotel getHotelFrom() {
        return hotelFrom;
    }

    public void setHotelFrom(Hotel hotelFrom) {
        this.hotelFrom = hotelFrom;
    }

    public Hotel getHotelTo() {
        return hotelTo;
    }

    public void setHotelTo(Hotel hotelTo) {
        this.hotelTo = hotelTo;
    }
}
