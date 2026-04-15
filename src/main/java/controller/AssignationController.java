package controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import entity.Assignation;
import entity.Reservation;
import entity.Vehicule;
import service.AssignationService;
import main.annotation.ControllerAnnotation;
import main.annotation.UrlAnnotation;
import main.annotation.GetMapping;
import main.annotation.PostMapping;
import main.annotation.RequestParam;
import main.framework.ModelView;

@ControllerAnnotation
public class AssignationController {

    private AssignationService assignationService = new AssignationService();

    /**
     * Page de planification : date picker + réservations non assignées + trajets
     * planifiés
     */
    @GetMapping
    @UrlAnnotation(url = "/assignation-form")
    public ModelView afficherFormulaire(@RequestParam(paramName = "date") String dateStr) {
        ModelView mv = new ModelView();
        mv.setView("assignation-form.jsp");

        try {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                mv.setData("date", "");
                mv.setData("reservations", new ArrayList<Reservation>());
                mv.setData("vehiculesInfo", new ArrayList<Map>());
                mv.setData("trajets", new ArrayList<Map>());
                mv.setData("assignations", new ArrayList<Assignation>());
                return mv;
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateStr, formatter);

            // Réservations non assignées pour cette date
            List<Reservation> reservations = assignationService.getReservationsNonAssignees(date);

            // Véhicules avec capacité restante (Sprint 4)
            List<Map<String, Object>> vehiculesInfo = assignationService.getVehiculesAvecCapaciteRestante(date);

            // Trajets déjà planifiés
            List<Map<String, Object>> trajets = assignationService.getTrajets(date);

            // Assignations existantes pour cette date
            List<Assignation> assignations = assignationService.getAssignationsByDate(date);

            mv.setData("date", dateStr);
            mv.setData("reservations", reservations);
            mv.setData("vehiculesInfo", vehiculesInfo);
            mv.setData("trajets", trajets);
            mv.setData("assignations", assignations);

            if (reservations.isEmpty() && assignations.isEmpty()) {
                mv.setData("info", "Aucune réservation trouvée pour le " + dateStr);
            } else if (reservations.isEmpty()) {
                mv.setData("info", "Toutes les réservations sont déjà assignées pour le " + dateStr);
            } else {
                mv.setData("message", reservations.size() + " réservation(s) à assigner pour le " + dateStr);
            }

        } catch (Exception e) {
            mv.setData("error", "Erreur: " + e.getMessage());
            mv.setData("date", dateStr != null ? dateStr : "");
            mv.setData("reservations", new ArrayList<Reservation>());
            mv.setData("vehiculesInfo", new ArrayList<Map>());
            mv.setData("trajets", new ArrayList<Map>());
            mv.setData("assignations", new ArrayList<Assignation>());
        }

        return mv;
    }

    /**
     * Planification automatique - Sprint 3 + Sprint 4
     * Applique toutes les règles de gestion :
     * - Trajet le plus proche de l'aéroport en premier
     * - Clients inséparables (même hôtel) ensemble
     * - Véhicule avec capacité la plus proche
     * - Priorité diesel, random si égalité
     * - Un véhicule peut avoir plusieurs réservations (Sprint 4)
     */
    @PostMapping
    @UrlAnnotation(url = "/assignation-planifier")
    public ModelView planifierAutomatique(@RequestParam(paramName = "date") String dateStr) {
        ModelView mv = new ModelView();
        mv.setView("assignation-result.jsp");

        try {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                mv.setData("error", "Veuillez spécifier une date.");
                return mv;
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateStr, formatter);

            // Vérifier s'il y a des réservations à assigner
            List<Reservation> nonAssignees = assignationService.getReservationsNonAssignees(date);
            if (nonAssignees.isEmpty()) {
                mv.setData("error", "Aucune réservation à assigner pour le " + dateStr);
                mv.setData("date", dateStr);
                mv.setData("assignations", assignationService.getAssignationsByDate(date));
                mv.setData("nouvellesAssignations", 0);
                return mv;
            }

            // Lancer l'algorithme d'assignation automatique
            List<Assignation> nouvelles = assignationService.assignerVehiculesParDate(date);

            // Récupérer toutes les assignations (anciennes + nouvelles)
            List<Assignation> toutesAssignations = assignationService.getAssignationsByDate(date);

            // Récupérer les réservations non assignées (après planification)
            List<Reservation> restantes = assignationService.getReservationsNonAssignees(date);

            mv.setData("date", dateStr);
            mv.setData("assignations", toutesAssignations);
            mv.setData("nouvellesAssignations", nouvelles.size());
            mv.setData("reservationsNonAssignees", restantes);
            mv.setData("message", nouvelles.size() + " réservation(s) assignée(s) automatiquement avec succès!");

        } catch (Exception e) {
            mv.setData("error", "Erreur lors de la planification: " + e.getMessage());
            mv.setData("date", dateStr != null ? dateStr : "");
            mv.setData("assignations", new ArrayList<Assignation>());
            mv.setData("reservationsNonAssignees", new ArrayList<Reservation>());
            mv.setData("nouvellesAssignations", 0);
        }

        return mv;
    }

    /**
     * Assignation manuelle d'une réservation à un véhicule
     * Vérifie la capacité (Sprint 4)
     */
    @PostMapping
    @UrlAnnotation(url = "/assignation-save")
    public ModelView assignerManuel(
            @RequestParam(paramName = "idReservation") int idReservation,
            @RequestParam(paramName = "idVehicule") int idVehicule,
            @RequestParam(paramName = "date") String dateStr) {
        ModelView mv = new ModelView();
        mv.setView("assignation-form.jsp");

        try {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                mv.setData("error", "Veuillez spécifier une date.");
                return mv;
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateStr, formatter);

            // Assigner manuellement avec vérification de capacité (Sprint 4)
            assignationService.assignerReservationManuelle(idReservation, idVehicule, date);

            mv.setData("message", "Réservation #" + idReservation + " assignée avec succès!");

            // Recharger les données
            mv.setData("date", dateStr);
            mv.setData("reservations", assignationService.getReservationsNonAssignees(date));
            mv.setData("vehiculesInfo", assignationService.getVehiculesAvecCapaciteRestante(date));
            mv.setData("trajets", assignationService.getTrajets(date));
            mv.setData("assignations", assignationService.getAssignationsByDate(date));

        } catch (Exception e) {
            mv.setData("error", "Erreur: " + e.getMessage());
            try {
                if (dateStr != null && !dateStr.trim().isEmpty()) {
                    LocalDate dateReload = LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    mv.setData("date", dateStr);
                    mv.setData("reservations", assignationService.getReservationsNonAssignees(dateReload));
                    mv.setData("vehiculesInfo", assignationService.getVehiculesAvecCapaciteRestante(dateReload));
                    mv.setData("trajets", assignationService.getTrajets(dateReload));
                    mv.setData("assignations", assignationService.getAssignationsByDate(dateReload));
                }
            } catch (Exception ex) {
                mv.setData("reservations", new ArrayList<Reservation>());
                mv.setData("vehiculesInfo", new ArrayList<Map>());
                mv.setData("trajets", new ArrayList<Map>());
                mv.setData("assignations", new ArrayList<Assignation>());
            }
        }

        return mv;
    }
}
