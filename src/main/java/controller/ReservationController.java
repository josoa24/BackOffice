package controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import entity.Reservation;
import entity.Hotel;
import entity.Token;
import service.HotelService;
import service.ReservationService;
import service.TokenService;
import main.annotation.ControllerAnnotation;
import main.annotation.UrlAnnotation;
import main.annotation.GetMapping;
import main.annotation.PostMapping;
import main.annotation.RequestParam;
import main.framework.ModelView;

@ControllerAnnotation
public class ReservationController {
    
    private HotelService hotelService = new HotelService();
    private ReservationService reservationService = new ReservationService();
    private TokenService tokenService = new TokenService();

    @GetMapping
    @UrlAnnotation(url = "/reservation-form")
    public ModelView afficherFormulaireReservation() {
        ModelView mv = new ModelView();
        mv.setView("reservation-form.jsp");
        
        try {
            List<Hotel> hotels = hotelService.getAllHotels();
            mv.setData("hotels", hotels);
        } catch (Exception e) {
            mv.setData("error", "Erreur lors du chargement des hôtels: " + e.getMessage());
            mv.setData("hotels", new ArrayList<Hotel>());
        }
        
        return mv;
    }

    @PostMapping
    @UrlAnnotation(url = "/reservation-save")
    public ModelView enregistrerReservation(
            @RequestParam(paramName = "idClient") int idClient,
            @RequestParam(paramName = "nbPassager") int nbPassager,
            @RequestParam(paramName = "dateHeure") String dateHeure,
            @RequestParam(paramName = "idHotel") int idHotel) {
        
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime dateTime = LocalDateTime.parse(dateHeure, formatter);
            int idReservation = reservationService.enregistrerReservation(idClient, nbPassager, dateTime, idHotel);
            Reservation reservation = reservationService.getReservationById(idReservation);
            ModelView mv = new ModelView();
            mv.setView("reservation-success.jsp");
            mv.setData("reservation", reservation);
            mv.setData("message", "Réservation enregistrée avec succès!");
            return mv;
        } catch (IllegalArgumentException e) {
            ModelView mv = new ModelView();
            mv.setView("reservation-form.jsp");
            mv.setData("error", e.getMessage());
            try {
                mv.setData("hotels", hotelService.getAllHotels());
            } catch (Exception ex) {
                mv.setData("hotels", new ArrayList<Hotel>());
            }
            return mv;
        } catch (Exception e) {
            ModelView mv = new ModelView();
            mv.setView("reservation-form.jsp");
            mv.setData("error", "Erreur lors de l'enregistrement: " + e.getMessage());
            try {
                mv.setData("hotels", hotelService.getAllHotels());
            } catch (Exception ex) {
                mv.setData("hotels", new ArrayList<Hotel>());
            }
            return mv;
        }
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/api/reservations")
    public ModelView getAllReservations(@RequestParam(paramName = "token") String token) {
        ModelView mv = new ModelView();
        
        try {
            // Vérification du token
            Token validToken = tokenService.validateToken(token);
            if (validToken == null) {
                if (tokenService.isTokenExpired(token)) {
                    mv.setData("error", "Token expiré. Veuillez vous reconnecter.");
                } else {
                    mv.setData("error", "Token invalide. Accès refusé.");
                }
                mv.setData("reservations", new ArrayList<Reservation>());
                mv.setData("count", 0);
                return mv;
            }

            List<Reservation> reservations = reservationService.getAllReservations();
            mv.setData("reservations", reservations);
            mv.setData("count", reservations.size());
        } catch (Exception e) {
            mv.setData("error", "Erreur lors de la récupération des réservations: " + e.getMessage());
            mv.setData("reservations", new ArrayList<Reservation>());
            mv.setData("count", 0);
        }
        
        return mv;
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/api/reservations/date")
    public ModelView getReservationsByDate(
            @RequestParam(paramName = "date") String date,
            @RequestParam(paramName = "token") String token) {
        ModelView mv = new ModelView();
        
        try {
            // Vérification du token
            Token validToken = tokenService.validateToken(token);
            if (validToken == null) {
                if (tokenService.isTokenExpired(token)) {
                    mv.setData("error", "Token expiré. Veuillez vous reconnecter.");
                } else {
                    mv.setData("error", "Token invalide. Accès refusé.");
                }
                mv.setData("reservations", new ArrayList<Reservation>());
                mv.setData("count", 0);
                return mv;
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate localDate = LocalDate.parse(date, formatter);
            List<Reservation> reservations = reservationService.getReservationsByDate(localDate);
            mv.setData("reservations", reservations);
            mv.setData("date", date);
            mv.setData("count", reservations.size());
        } catch (Exception e) {
            mv.setData("error", "Erreur: " + e.getMessage());
            mv.setData("reservations", new ArrayList<Reservation>());
            mv.setData("count", 0);
        }
        
        return mv;
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/api/token/generate")
    public ModelView generateToken(@RequestParam(paramName = "idClient") int idClient) {
        ModelView mv = new ModelView();
        
        try {
            // Génère un token valide pendant 30 minutes
            Token token = tokenService.generateToken(idClient, 30);
            mv.setData("token", token.getToken());
            mv.setData("expiration", token.getDateExpiration().toString());
            mv.setData("idClient", token.getIdClient());
            mv.setData("message", "Token généré avec succès");
        } catch (Exception e) {
            mv.setData("error", "Erreur lors de la génération du token: " + e.getMessage());
        }
        
        return mv;
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/api/token/validate")
    public ModelView validateToken(@RequestParam(paramName = "token") String tokenValue) {
        ModelView mv = new ModelView();
        
        try {
            Token token = tokenService.validateToken(tokenValue);
            if (token != null) {
                mv.setData("valid", true);
                mv.setData("idClient", token.getIdClient());
                mv.setData("expiration", token.getDateExpiration().toString());
            } else {
                mv.setData("valid", false);
                if (tokenService.isTokenExpired(tokenValue)) {
                    mv.setData("message", "Token expiré");
                } else {
                    mv.setData("message", "Token invalide");
                }
            }
        } catch (Exception e) {
            mv.setData("error", "Erreur: " + e.getMessage());
            mv.setData("valid", false);
        }
        
        return mv;
    }
}
