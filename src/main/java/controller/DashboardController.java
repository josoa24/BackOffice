package controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import service.DashboardService;
import main.annotation.ControllerAnnotation;
import main.annotation.UrlAnnotation;
import main.annotation.GetMapping;
import main.framework.ModelView;

@ControllerAnnotation
public class DashboardController {

    private DashboardService dashboardService = new DashboardService();

    @GetMapping
    @UrlAnnotation(url = "/dashboard")
    public ModelView afficherDashboard() {
        ModelView mv = new ModelView();
        mv.setView("dashboard.jsp");

        try {
            LocalDate today = LocalDate.now();

            // KPIs
            mv.setData("totalReservations", dashboardService.getTotalReservations());
            mv.setData("reservationsAujourdHui", dashboardService.getReservationsAujourdHui(today));
            mv.setData("totalHotels", dashboardService.getTotalHotels());
            mv.setData("totalVehicules", dashboardService.getTotalVehicules());
            mv.setData("totalAssignations", dashboardService.getTotalAssignations());
            mv.setData("totalPassagers", dashboardService.getTotalPassagers());
            mv.setData("tauxAssignation", dashboardService.getTauxAssignation());
            mv.setData("moyennePassagers", dashboardService.getMoyennePassagers());

            // Données pour graphiques
            mv.setData("reservationsParHotel", dashboardService.getReservationsParHotel());
            mv.setData("reservationsParJour", dashboardService.getReservationsParJour(30));
            mv.setData("vehiculesParCarburant", dashboardService.getVehiculesParCarburant());

            // Tableaux
            mv.setData("dernieresReservations", dashboardService.getDernieresReservations(10));
            mv.setData("topVehicules", dashboardService.getTopVehicules(5));

            mv.setData("dateAujourdHui", today.toString());

        } catch (Exception e) {
            mv.setData("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            e.printStackTrace();
        }

        return mv;
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/api/dashboard")
    public ModelView getDashboardApi() {
        ModelView mv = new ModelView();

        try {
            LocalDate today = LocalDate.now();

            Map<String, Object> kpis = new HashMap<>();
            kpis.put("totalReservations", dashboardService.getTotalReservations());
            kpis.put("reservationsAujourdHui", dashboardService.getReservationsAujourdHui(today));
            kpis.put("totalHotels", dashboardService.getTotalHotels());
            kpis.put("totalVehicules", dashboardService.getTotalVehicules());
            kpis.put("totalAssignations", dashboardService.getTotalAssignations());
            kpis.put("totalPassagers", dashboardService.getTotalPassagers());
            kpis.put("tauxAssignation", dashboardService.getTauxAssignation());
            kpis.put("moyennePassagers", dashboardService.getMoyennePassagers());

            mv.setData("kpis", kpis);
            mv.setData("reservationsParHotel", dashboardService.getReservationsParHotel());
            mv.setData("reservationsParJour", dashboardService.getReservationsParJour(30));
            mv.setData("vehiculesParCarburant", dashboardService.getVehiculesParCarburant());
            mv.setData("dernieresReservations", dashboardService.getDernieresReservations(10));
            mv.setData("topVehicules", dashboardService.getTopVehicules(5));

        } catch (Exception e) {
            mv.setData("error", e.getMessage());
        }

        return mv;
    }
}
