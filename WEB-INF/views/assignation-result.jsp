<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.util.LinkedHashMap,java.util.ArrayList" %>
<%@ page import="entity.Assignation" %>
<%@ page import="entity.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultat Planification - BackOffice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6fb; color: #1e1e2d; min-height: 100vh; }
        .page-wrapper { margin-left: 270px; min-height: 100vh; }
        .content { padding: 28px 36px 40px; }

        .top-header {
            background: rgba(255,255,255,0.95); padding: 18px 36px;
            display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid #eef0f6; position: sticky; top: 0; z-index: 50;
        }
        .header-left h1 { font-size: 24px; font-weight: 800; display: flex; align-items: center; gap: 10px; }
        .header-left h1 .header-icon { width: 36px; height: 36px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; }
        .header-left .header-subtitle { font-size: 13px; color: #9ba4b5; margin-top: 3px; }
        .header-date { display: flex; align-items: center; gap: 8px; background: #f8f9fe; padding: 10px 18px; border-radius: 10px; font-size: 13px; color: #5a6178; font-weight: 600; border: 1px solid #e8eaf4; }
        .header-date i { color: #10b981; }

        .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .kpi-card { background: #fff; border-radius: 16px; padding: 24px; border: 1px solid #eef0f6; transition: all 0.3s; }
        .kpi-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.08); }
        .kpi-icon-wrap { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 20px; margin-bottom: 16px; }
        .kpi-icon-wrap.blue { background: linear-gradient(135deg, #dbeafe, #bfdbfe); color: #2563eb; }
        .kpi-icon-wrap.green { background: linear-gradient(135deg, #d1fae5, #a7f3d0); color: #059669; }
        .kpi-icon-wrap.amber { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; }
        .kpi-icon-wrap.red { background: linear-gradient(135deg, #fee2e2, #fecaca); color: #dc2626; }
        .kpi-value { font-size: 32px; font-weight: 900; color: #1e1e2d; line-height: 1; margin-bottom: 6px; }
        .kpi-label { font-size: 13px; color: #9ba4b5; font-weight: 500; }

        .alert-custom { border-radius: 12px; padding: 16px 22px; margin-bottom: 22px; display: flex; align-items: center; gap: 12px; font-size: 13.5px; font-weight: 500; }
        .alert-success-custom { background: linear-gradient(135deg, #ecfdf5, #d1fae5); border: 1px solid #a7f3d0; color: #065f46; }
        .alert-error-custom { background: linear-gradient(135deg, #fef2f2, #fff1f2); border: 1px solid #fecdd3; color: #be123c; }

        .card { background: #fff; border-radius: 16px; border: 1px solid #eef0f6; overflow: hidden; margin-bottom: 24px; }
        .card:hover { box-shadow: 0 8px 24px rgba(0,0,0,0.05); }
        .card-header-custom { padding: 22px 26px 0; display: flex; align-items: center; justify-content: space-between; }
        .card-title { font-size: 16px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .title-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
        .card-badge { background: #f4f6fb; padding: 5px 14px; border-radius: 20px; font-size: 11px; color: #7c8498; font-weight: 600; border: 1px solid #eef0f6; }
        .card-body-custom { padding: 20px 26px 26px; }

        .table-modern { width: 100%; border-collapse: separate; border-spacing: 0; }
        .table-modern thead th { background: #f8f9fd; padding: 12px 14px; font-size: 11px; font-weight: 700; color: #8a93a7; text-transform: uppercase; letter-spacing: 0.8px; border-bottom: 2px solid #eef0f6; }
        .table-modern thead th:first-child { border-radius: 10px 0 0 0; }
        .table-modern thead th:last-child { border-radius: 0 10px 0 0; }
        .table-modern tbody td { padding: 14px; font-size: 13px; color: #4a5068; border-bottom: 1px solid #f4f6fb; vertical-align: middle; }
        .table-modern tbody tr:hover { background: #f8f9fd; }

        .badge-custom { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 8px; font-size: 11.5px; font-weight: 600; }
        .badge-diesel { background: #eef2ff; color: #4f46e5; }
        .badge-essence { background: #fef3c7; color: #92400e; }
        .badge-id { background: #f0f4ff; color: #667eea; font-weight: 700; font-size: 12px; }
        .badge-hotel { background: #e8f4fd; color: #0066cc; padding: 5px 10px; border-radius: 8px; font-weight: 600; font-size: 11px; }

        .vehicle-cell { display: flex; flex-direction: column; gap: 2px; }
        .vehicle-name { font-weight: 600; color: #1e1e2d; font-size: 13px; }
        .vehicle-plate { font-size: 11px; color: #9ba4b5; }

        .trajet-group { margin-bottom: 24px; border: 1px solid #eef0f6; border-radius: 12px; overflow: hidden; }
        .trajet-group-header { background: linear-gradient(135deg, #f8f9fd, #eef0f8); padding: 16px 22px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #eef0f6; }
        .trajet-group-title { font-weight: 700; font-size: 14px; color: #1e1e2d; }
        .trajet-group-info { display: flex; gap: 16px; font-size: 12px; color: #5a6178; }
        .trajet-group-info span { display: flex; align-items: center; gap: 5px; }

        .btn-back {
            display: inline-flex; align-items: center; gap: 8px; margin-top: 24px;
            padding: 12px 24px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border-radius: 12px; font-size: 14px; font-weight: 700; text-decoration: none;
            transition: all 0.3s; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .btn-back:hover { color: white; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45); }

        .empty-state { text-align: center; padding: 48px 24px; color: #9ba4b5; }
        .empty-state i { font-size: 48px; margin-bottom: 16px; color: #d1d5db; }

        @keyframes slideUp { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: translateY(0); } }
        .anim { opacity: 0; animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .anim:nth-child(1) { animation-delay: 0.04s; }
        .anim:nth-child(2) { animation-delay: 0.08s; }
        .anim:nth-child(3) { animation-delay: 0.12s; }
        .anim:nth-child(4) { animation-delay: 0.16s; }
    </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "assignation");

    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String dateStr = (String) request.getAttribute("date");
    List<Assignation> assignations = (List<Assignation>) request.getAttribute("assignations");
    Integer nouvelles = (Integer) request.getAttribute("nouvellesAssignations");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    int totalAssignations = assignations != null ? assignations.size() : 0;
    int nouvellesCount = nouvelles != null ? nouvelles : 0;
    int existantes = totalAssignations - nouvellesCount;
    if (existantes < 0) existantes = 0;

    List<Reservation> reservationsNonAssignees = (List<Reservation>) request.getAttribute("reservationsNonAssignees");
    int nbNonAssignees = reservationsNonAssignees != null ? reservationsNonAssignees.size() : 0;
    int totalPassagersNonAssignes = 0;
    if (reservationsNonAssignees != null) {
        for (Reservation rna : reservationsNonAssignees) {
            totalPassagersNonAssignes += rna.getNbPassager();
        }
    }

    // Grouper les assignations par vehicule (pour affichage Sprint 4)
    Map<Integer, List<Assignation>> parVehicule = new LinkedHashMap<>();
    if (assignations != null) {
        for (Assignation a : assignations) {
            int vid = a.getIdVehicule();
            if (!parVehicule.containsKey(vid)) {
                parVehicule.put(vid, new ArrayList<>());
            }
            parVehicule.get(vid).add(a);
        }
    }
%>
<jsp:include page="sidebar.jsp" />

<div class="page-wrapper">
    <div class="top-header">
        <div class="header-left">
            <h1>
                <span class="header-icon"><i class="fas fa-clipboard-check"></i></span>
                Resultat de la Planification
            </h1>
            <span class="header-subtitle">Sprint 5-6 : Regroupement temporel et priorite par nombre de trajets</span>
        </div>
        <div style="display:flex;align-items:center;gap:12px;">
            <div class="header-date">
                <i class="fas fa-calendar-alt"></i>
                <%= dateStr != null ? dateStr : "" %>
            </div>
        </div>
    </div>

    <div class="content">

        <% if (error != null) { %>
        <div class="alert-custom alert-error-custom anim">
            <i class="fas fa-exclamation-circle" style="font-size:18px"></i>
            <span><strong>Erreur :</strong> <%= error %></span>
        </div>
        <% } %>

        <% if (message != null) { %>
        <div class="alert-custom alert-success-custom anim">
            <i class="fas fa-check-circle" style="font-size:18px;color:#059669"></i>
            <span><%= message %></span>
        </div>
        <% } %>

        <% if (assignations != null && !assignations.isEmpty()) { %>

        <!-- KPI -->
        <div class="kpi-grid anim">
            <div class="kpi-card">
                <div class="kpi-icon-wrap blue"><i class="fas fa-list-check"></i></div>
                <div class="kpi-value"><%= totalAssignations %></div>
                <div class="kpi-label">Total assignations</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon-wrap green"><i class="fas fa-plus-circle"></i></div>
                <div class="kpi-value"><%= nouvellesCount %></div>
                <div class="kpi-label">Nouvelles assignations</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon-wrap amber"><i class="fas fa-bus"></i></div>
                <div class="kpi-value"><%= parVehicule.size() %></div>
                <div class="kpi-label">Vehicules utilises</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon-wrap red"><i class="fas fa-user-xmark"></i></div>
                <div class="kpi-value"><%= nbNonAssignees %></div>
                <div class="kpi-label">Non assignees (<%= totalPassagersNonAssignes %> passagers)</div>
            </div>
        </div>

        <% if (nbNonAssignees > 0) { %>
        <!-- Reservations non assignees -->
        <div class="card anim" style="border-left: 4px solid #dc3545;">
            <div class="card-header-custom">
                <div class="card-title">
                    <span class="title-dot" style="background:#dc3545"></span>
                    Reservations Non Assignees
                </div>
                <span class="card-badge" style="background:#fef2f2; color:#dc3545; border-color:#fecdd3;"><%= nbNonAssignees %> reservation(s) - <%= totalPassagersNonAssignes %> passager(s)</span>
            </div>
            <div class="card-body-custom">
                <div class="alert-custom alert-error-custom" style="margin-bottom:16px;">
                    <i class="fas fa-exclamation-triangle" style="font-size:18px"></i>
                    <span><strong>Attention :</strong> Ces reservations n'ont pas pu etre assignees (capacite vehicules insuffisante).</span>
                </div>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Client</th>
                            <th>Passagers</th>
                            <th>Lieu (Hotel)</th>
                            <th>Date / Heure</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Reservation rna : reservationsNonAssignees) { %>
                        <tr>
                            <td><span class="badge-custom badge-id">#<%= rna.getIdReservation() %></span></td>
                            <td><strong><%= rna.getIdClient() %></strong></td>
                            <td><strong style="color:#dc3545;"><%= rna.getNbPassager() %></strong></td>
                            <td>
                                <span class="badge-hotel">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <%= rna.getHotel() != null ? rna.getHotel().getNom() : rna.getIdHotel() %>
                                </span>
                            </td>
                            <td><%= rna.getDateHeure().format(dateTimeFormatter) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>

        <!-- Regroupement par vehicule (Sprint 5-6) -->
        <div class="card anim">
            <div class="card-header-custom">
                <div class="card-title">
                    <span class="title-dot" style="background:#10b981"></span>
                    Trajets par Vehicule (Sprint 5-6)
                </div>
                <span class="card-badge"><%= parVehicule.size() %> vehicule(s)</span>
            </div>
            <div class="card-body-custom">
                <% for (Map.Entry<Integer, List<Assignation>> entry : parVehicule.entrySet()) {
                    List<Assignation> vehiculeAssignations = entry.getValue();
                    Assignation first = vehiculeAssignations.get(0);
                    int totalPassagers = 0;
                    for (Assignation a : vehiculeAssignations) {
                        totalPassagers += a.getReservation().getNbPassager();
                    }
                    int capacite = first.getVehicule().getCapacite();
                    int placesRestantes = capacite - totalPassagers;
                    int pourcentage = (capacite > 0) ? (totalPassagers * 100 / capacite) : 0;
                %>
                <div class="trajet-group">
                    <div class="trajet-group-header">
                        <div>
                            <span class="trajet-group-title">
                                <i class="fas fa-bus me-2" style="color:#667eea"></i>
                                <%= first.getVehicule().getMarque() %> <%= first.getVehicule().getModele() %>
                                <span style="color:#9ba4b5; font-weight:400; margin-left:8px;"><%= first.getVehicule().getImmatriculation() %></span>
                            </span>
                        </div>
                        <div class="trajet-group-info">
                            <span class="badge-custom badge-<%= "diesel".equals(first.getVehicule().getCarburant()) ? "diesel" : "essence" %>">
                                <i class="fas fa-gas-pump"></i> <%= first.getVehicule().getCarburant() %>
                            </span>
                            <span><i class="fas fa-users" style="color:#e65100"></i> <strong><%= totalPassagers %>/<%= capacite %></strong> passagers</span>
                            <span><i class="fas fa-chair" style="color:#059669"></i> <%= placesRestantes %> restantes</span>
                            <span><i class="fas fa-clock" style="color:#059669"></i> Depart aeroport: <strong><%= first.getHeureDepart().format(timeFormatter) %></strong></span>
                            <span><i class="fas fa-plane-arrival" style="color:#d97706"></i> Retour aeroport: <strong><%= first.getHeureArrivee().format(timeFormatter) %></strong></span>
                        </div>
                    </div>
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Client</th>
                                <th>Passagers</th>
                                <th>Lieu (Hotel)</th>
                                <th>Depart Aeroport</th>
                                <th>Retour Aeroport</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Assignation a : vehiculeAssignations) { %>
                            <tr>
                                <td><span class="badge-custom badge-id">#<%= a.getIdAssignation() %></span></td>
                                <td><strong><%= a.getReservation().getIdClient() %></strong></td>
                                <td><%= a.getReservation().getNbPassager() %></td>
                                <td>
                                    <span class="badge-hotel">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <%= a.getReservation().getHotel() != null ? a.getReservation().getHotel().getNom() : a.getReservation().getIdHotel() %>
                                    </span>
                                </td>
                                <td><span style="font-weight:600"><i class="fas fa-clock" style="color:#059669;margin-right:4px;font-size:11px"></i><%= a.getHeureDepart().format(timeFormatter) %></span></td>
                                <td><span style="font-weight:600"><i class="fas fa-flag-checkered" style="color:#d97706;margin-right:4px;font-size:11px"></i><%= a.getHeureArrivee().format(timeFormatter) %></span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <div style="padding:12px 22px;">
                        <div class="progress" style="height:8px; border-radius:4px;">
                            <div class="progress-bar" style="width:<%= pourcentage %>%; background:<%= pourcentage > 80 ? "#dc3545" : pourcentage > 50 ? "#ffc107" : "#28a745" %>; border-radius:4px;"></div>
                        </div>
                        <small style="color:#9ba4b5; font-size:11px;">Remplissage : <%= pourcentage %>%</small>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Tableau complet -->
        <div class="card anim">
            <div class="card-header-custom">
                <div class="card-title">
                    <span class="title-dot" style="background:#f59e0b"></span>
                    Detail Complet des Assignations
                </div>
                <span class="card-badge"><%= totalAssignations %> resultats</span>
            </div>
            <div class="card-body-custom">
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Client</th>
                            <th>Passagers</th>
                            <th>Lieu (Hotel)</th>
                            <th>Vehicule</th>
                            <th>Capacite</th>
                            <th>Carburant</th>
                            <th>Depart Aeroport</th>
                            <th>Retour Aeroport</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Assignation a : assignations) { %>
                        <tr>
                            <td><span class="badge-custom badge-id">#<%= a.getIdAssignation() %></span></td>
                            <td><strong><%= a.getReservation().getIdClient() %></strong></td>
                            <td><%= a.getReservation().getNbPassager() %></td>
                            <td>
                                <span class="badge-hotel">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <%= a.getReservation().getHotel() != null ? a.getReservation().getHotel().getNom() : a.getReservation().getIdHotel() %>
                                </span>
                            </td>
                            <td>
                                <div class="vehicle-cell">
                                    <span class="vehicle-name"><%= a.getVehicule().getMarque() %> <%= a.getVehicule().getModele() %></span>
                                    <span class="vehicle-plate"><%= a.getVehicule().getImmatriculation() %></span>
                                </div>
                            </td>
                            <td><%= a.getVehicule().getCapacite() %></td>
                            <td>
                                <span class="badge-custom <%= "diesel".equals(a.getVehicule().getCarburant()) ? "badge-diesel" : "badge-essence" %>">
                                    <i class="fas fa-gas-pump"></i> <%= a.getVehicule().getCarburant() %>
                                </span>
                            </td>
                            <td><span style="font-weight:600"><i class="fas fa-clock" style="color:#059669;margin-right:4px;font-size:11px"></i><%= a.getHeureDepart().format(timeFormatter) %></span></td>
                            <td><span style="font-weight:600"><i class="fas fa-flag-checkered" style="color:#d97706;margin-right:4px;font-size:11px"></i><%= a.getHeureArrivee().format(timeFormatter) %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <% } else if (error == null) { %>
        <div class="card anim">
            <div class="card-body-custom">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>Aucune reservation a assigner pour cette date.</p>
                </div>
            </div>
        </div>
        <% } %>

        <a href="${pageContext.request.contextPath}/assignation-form<%= dateStr != null ? "?date=" + dateStr : "" %>" class="btn-back anim">
            <i class="fas fa-arrow-left"></i> Retour a la planification
        </a>
    </div>
</div>
</body>
</html>
