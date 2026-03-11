package controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import entity.Assignation;
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
     * Formulaire pour choisir une date et lancer l'assignation
     */
    @GetMapping
    @UrlAnnotation(url = "/assignation-form")
    public ModelView afficherFormulaire() {
        ModelView mv = new ModelView();
        mv.setView("assignation-form.jsp");
        return mv;
    }

    /**
     * Lancer l'assignation automatique pour une date donnée
     */
    @PostMapping
    @UrlAnnotation(url = "/assignation-process")
    public ModelView processerAssignation(@RequestParam(paramName = "date") String dateStr) {
        ModelView mv = new ModelView();
        mv.setView("assignation-result.jsp");

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateStr, formatter);

            // Lancer l'assignation automatique
            List<Assignation> nouvellesAssignations = assignationService.assignerVehiculesParDate(date);

            // Récupérer toutes les assignations du jour (y compris celles déjà faites)
            List<Assignation> toutesAssignations = assignationService.getAssignationsByDate(date);

            mv.setData("assignations", toutesAssignations);
            mv.setData("nouvellesAssignations", nouvellesAssignations.size());
            mv.setData("date", dateStr);
            mv.setData("message", nouvellesAssignations.size() + " nouvelle(s) assignation(s) effectuée(s) pour le " + dateStr);

        } catch (Exception e) {
            mv.setData("error", "Erreur lors de l'assignation: " + e.getMessage());
            mv.setData("assignations", new ArrayList<Assignation>());
            mv.setData("date", dateStr);
        }

        return mv;
    }

    /**
     * API JSON : Récupérer les assignations par date
     */
    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/api/assignations")
    public ModelView getAssignationsApi(@RequestParam(paramName = "date") String dateStr) {
        ModelView mv = new ModelView();

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateStr, formatter);

            List<Assignation> assignations = assignationService.getAssignationsByDate(date);
            mv.setData("assignations", assignations);
            mv.setData("count", assignations.size());
            mv.setData("date", dateStr);
        } catch (Exception e) {
            mv.setData("error", "Erreur: " + e.getMessage());
            mv.setData("assignations", new ArrayList<Assignation>());
            mv.setData("count", 0);
        }

        return mv;
    }
}
