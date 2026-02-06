package controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;
import entity.Etudiant;
import entity.Option;
import main.annotation.ControllerAnnotation;
import main.annotation.UrlAnnotation;
import main.annotation.UrlParam;
import main.annotation.RequestParam;
import main.annotation.GetMapping;
import main.annotation.PostMapping;
import main.framework.ModelView;

@ControllerAnnotation
public class ExempleController {

    @UrlAnnotation(url = "/sprint4")
    public String exempleMethod() {
        return ("Exemple method executed.");
    }

    @UrlAnnotation(url = "/sprint4-modelview")
    public ModelView viewMethod() {
        ModelView view = new ModelView();
        view.setView("test.jsp");
        return view;
    }

    @UrlAnnotation(url = "/sprint5")
    public ModelView listEtudiants() {
        Etudiant[] etudiants = {
                new Etudiant("ETU001", "Rakoto", "Jean"),
                new Etudiant("ETU002", "Rabe", "Marie"),
                new Etudiant("ETU003", "Rasoa", "Paul")
        };
        ModelView mv = new ModelView();
        mv.setView("etudiants.jsp");
        mv.setData("etudiants", new ArrayList<>(Arrays.asList(etudiants)));

        return mv;
    }

    @UrlAnnotation(url = "/sprint6")
    public ModelView detailsModelView(String id) {
        Etudiant etudiant = new Etudiant(id, "Rakoto", "Jean");

        ModelView mv = new ModelView();
        mv.setView("etudiants-details.jsp");
        mv.setData("etudiant", etudiant);
        return mv;
    }

    @UrlAnnotation(url = "/sprint6bis")
    public ModelView detailsWithRequestParam(
            @RequestParam(paramName = "id") String numeroEtudiant) {
        Etudiant etudiant = new Etudiant(numeroEtudiant, "Andriamampianina", "Soa");

        ModelView mv = new ModelView();
        mv.setView("etudiants-details.jsp");
        mv.setData("etudiant", etudiant);
        return mv;
    }

    @UrlAnnotation(url = "/sprint6ter/{idEtudiant}")
    public ModelView testUrlVariable(@UrlParam(name = "idEtudiant") String idEtu) {
        Etudiant etudiant = new Etudiant(idEtu, "Razafy", "Hery");

        ModelView mv = new ModelView();
        mv.setView("etudiants-details.jsp");
        mv.setData("etudiant", etudiant);
        return mv;
    }

    @GetMapping
    @UrlAnnotation(url = "/sprint7post")
    public ModelView afficherFormulaire() {
        ModelView mv = new ModelView();
        mv.setView("sprint7post.jsp");
        return mv;
    }

    @PostMapping
    @UrlAnnotation(url = "/sprint7post")
    public String formTraitement(String exemple) {
        return "Données reçues via POST : " + exemple;
    }

    @GetMapping
    @UrlAnnotation(url = "/sprint8form")
    public ModelView sprint8Form() {
        ModelView modelView = new ModelView();
        modelView.setView("sprint8.jsp");
        return modelView;
    }

    @PostMapping
    @UrlAnnotation(url = "/sprint8Post")
    public ModelView sprint8Post(Map<String, Object> requestData) {
        ModelView modelView = new ModelView();
        modelView.setView("sprint8result.jsp");
        modelView.setData("requestData", requestData);
        return modelView;
    }

    @GetMapping
    @UrlAnnotation(url = "/sprint8-bisform")
    public ModelView sprint8BisForm() {
        ModelView mv = new ModelView();
        mv.setView("sprint8-bis.jsp");
        return mv;
    }

    @PostMapping
    @UrlAnnotation(url = "/sprint8-bissave")
    public ModelView saveEtudiant(Etudiant etudiant) {
        ModelView mv = new ModelView();
        mv.setView("sprint8-bisresult.jsp");
        mv.setData("etudiant", etudiant);
        return mv;
    }

    @GetMapping
    @UrlAnnotation(url = "/sprint8terform")
    public ModelView sprint8TerForm() {
        ModelView mv = new ModelView();
        mv.setView("sprint8ter.jsp");
        return mv;
    }

    @PostMapping
    @UrlAnnotation(url = "/sprint8tersave")
    public ModelView saveEtudiantWithOption(Etudiant etudiant) {
        ModelView mv = new ModelView();
        mv.setView("sprint8terresult.jsp");
        mv.setData("etudiant", etudiant);
        return mv;
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/sprint9json")
    public ModelView getEtudiantJson() {
        Etudiant etudiant = new Etudiant("ETU001", "Rakoto", "Jean");
        Option option = new Option("INFO", "Informatique");
        etudiant.setOption(option);

        ModelView mv = new ModelView();
        mv.setData("etudiant", etudiant);
        mv.setData("message", "Données de l'étudiant en JSON");
        return mv;
    }

    @main.annotation.Json
    @GetMapping
    @UrlAnnotation(url = "/sprint9list")
    public ModelView getEtudiantsListJson() {
        Etudiant[] etudiants = new Etudiant[3];
        
        Etudiant e1 = new Etudiant("ETU001", "Rakoto", "Jean");
        e1.setOption(new Option("INFO", "Informatique"));
        etudiants[0] = e1;
        
        Etudiant e2 = new Etudiant("ETU002", "Rasoa", "Marie");
        e2.setOption(new Option("MATH", "Mathématiques"));
        etudiants[1] = e2;
        
        Etudiant e3 = new Etudiant("ETU003", "Rabe", "Paul");
        e3.setOption(new Option("PHYS", "Physique"));
        etudiants[2] = e3;

        ModelView mv = new ModelView();
        mv.setData("etudiants", etudiants);
        mv.setData("count", 3);
        return mv;
    }

    @GetMapping
    @UrlAnnotation(url = "/sprint10form")
    public ModelView sprint10Form() {
        ModelView mv = new ModelView();
        mv.setView("sprint10.jsp");
        return mv;
    }

    @PostMapping
    @UrlAnnotation(url = "/sprint10upload")
    public ModelView sprint10Upload(@main.annotation.FileUpload(name = "fichier") main.framework.FileUploadData file, String description) {
        ModelView mv = new ModelView();
        mv.setView("sprint10result.jsp");
        mv.setData("file", file);
        mv.setData("description", description);
        return mv;
    }
}
