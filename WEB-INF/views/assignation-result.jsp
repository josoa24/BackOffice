<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Assignation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultat Assignation - BackOffice</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f4f6fb;
            color: #1e1e2d;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        .top-header {
            background: rgba(255,255,255,0.95);
            padding: 18px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #eef0f6;
            position: sticky;
            top: 0;
            z-index: 50;
            backdrop-filter: blur(12px);
        }
        .header-left { display: flex; flex-direction: column; }
        .header-left h1 { font-size: 24px; font-weight: 800; color: #1e1e2d; display: flex; align-items: center; gap: 10px; }
        .header-left h1 .header-icon { width: 36px; height: 36px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; }
        .header-left .header-subtitle { font-size: 13px; color: #9ba4b5; margin-top: 3px; font-weight: 400; }
        .header-right { display: flex; align-items: center; gap: 12px; }
        .header-date { display: flex; align-items: center; gap: 8px; background: linear-gradient(135deg, #f8f9fe, #eef0f8); padding: 10px 18px; border-radius: 10px; font-size: 13px; color: #5a6178; font-weight: 600; border: 1px solid #e8eaf4; }
        .header-date i { color: #f59e0b; font-size: 14px; }

        .content { padding: 28px 36px 40px; }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }
        .kpi-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            position: relative;
            overflow: hidden;
            border: 1px solid #eef0f6;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .kpi-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.08); border-color: transparent; }
        .kpi-top { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 16px; }
        .kpi-icon-wrap { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .kpi-icon-wrap.blue { background: linear-gradient(135deg, #dbeafe, #bfdbfe); color: #2563eb; }
        .kpi-icon-wrap.green { background: linear-gradient(135deg, #d1fae5, #a7f3d0); color: #059669; }
        .kpi-icon-wrap.amber { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; }
        .kpi-value { font-size: 32px; font-weight: 900; color: #1e1e2d; line-height: 1; margin-bottom: 6px; }
        .kpi-label { font-size: 13px; color: #9ba4b5; font-weight: 500; }

        .success-alert {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 1px solid #a7f3d0;
            border-radius: 12px;
            padding: 16px 22px;
            margin-bottom: 22px;
            color: #065f46;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13.5px;
            font-weight: 500;
        }
        .success-alert i { font-size: 18px; color: #059669; }

        .error-alert {
            background: linear-gradient(135deg, #fef2f2, #fff1f2);
            border: 1px solid #fecdd3;
            border-radius: 12px;
            padding: 16px 22px;
            margin-bottom: 22px;
            color: #be123c;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13.5px;
            font-weight: 500;
        }
        .error-alert i { font-size: 18px; }

        .card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #eef0f6;
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }
        .card:hover { box-shadow: 0 8px 24px rgba(0,0,0,0.05); }
        .card-header {
            padding: 22px 26px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-title { font-size: 16px; font-weight: 700; color: #1e1e2d; display: flex; align-items: center; gap: 10px; }
        .title-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; background: #f59e0b; }
        .card-badge { background: #f4f6fb; padding: 5px 14px; border-radius: 20px; font-size: 11px; color: #7c8498; font-weight: 600; border: 1px solid #eef0f6; }
        .card-body { padding: 20px 26px 26px; }

        .table-modern { width: 100%; border-collapse: separate; border-spacing: 0; }
        .table-modern thead th {
            background: #f8f9fd;
            padding: 12px 14px;
            font-size: 11px;
            font-weight: 700;
            color: #8a93a7;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            text-align: left;
            border-bottom: 2px solid #eef0f6;
        }
        .table-modern thead th:first-child { border-radius: 10px 0 0 0; }
        .table-modern thead th:last-child { border-radius: 0 10px 0 0; }
        .table-modern tbody td {
            padding: 14px;
            font-size: 13px;
            color: #4a5068;
            border-bottom: 1px solid #f4f6fb;
            vertical-align: middle;
        }
        .table-modern tbody tr { transition: background 0.15s; }
        .table-modern tbody tr:hover { background: #f8f9fd; }
        .table-modern tbody tr:last-child td { border-bottom: none; }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 11.5px;
            font-weight: 600;
            white-space: nowrap;
        }
        .badge-diesel { background: #eef2ff; color: #4f46e5; }
        .badge-essence { background: #fef3c7; color: #92400e; }
        .badge-id { background: #f0f4ff; color: #667eea; font-weight: 700; font-size: 12px; }

        .vehicle-cell { display: flex; flex-direction: column; gap: 2px; }
        .vehicle-name { font-weight: 600; color: #1e1e2d; font-size: 13px; }
        .vehicle-plate { font-size: 11px; color: #9ba4b5; }

        .time-cell { font-weight: 600; color: #1e1e2d; font-size: 13px; }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 24px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .btn-back:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45); }

        .empty-state {
            text-align: center;
            padding: 48px 24px;
            color: #9ba4b5;
        }
        .empty-state i { font-size: 48px; margin-bottom: 16px; color: #d1d5db; }
        .empty-state p { font-size: 15px; font-weight: 500; }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .anim { opacity: 0; animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .anim:nth-child(1) { animation-delay: 0.04s; }
        .anim:nth-child(2) { animation-delay: 0.08s; }
        .anim:nth-child(3) { animation-delay: 0.12s; }
        .anim:nth-child(4) { animation-delay: 0.16s; }

        @media (max-width: 1200px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .content { padding: 20px 16px; }
            .top-header { padding: 14px 16px; flex-wrap: wrap; gap: 12px; }
            .kpi-grid { grid-template-columns: 1fr; }
            .table-modern { font-size: 12px; }
            .header-right { width: 100%; justify-content: flex-end; }
        }
    </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "assignation");

    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    List<Assignation> assignations = (List<Assignation>) request.getAttribute("assignations");
    Integer nouvelles = (Integer) request.getAttribute("nouvellesAssignations");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    int totalAssignations = assignations != null ? assignations.size() : 0;
    int nouvellesCount = nouvelles != null ? nouvelles : 0;
    int existantes = totalAssignations - nouvellesCount;
    if (existantes < 0) existantes = 0;
%>
<jsp:include page="sidebar.jsp" />

<div class="page-wrapper">
    <div class="top-header">
        <div class="header-left">
            <h1>
                <span class="header-icon"><i class="fas fa-clipboard-check"></i></span>
                Résultat de l'Assignation
            </h1>
            <span class="header-subtitle">Détail des véhicules assignés aux réservations</span>
        </div>
        <div class="header-right">
            <div class="header-date">
                <i class="fas fa-calendar-alt"></i>
                <%= request.getAttribute("date") %>
            </div>
        </div>
    </div>

    <div class="content">

        <% if (error != null) { %>
        <div class="error-alert anim">
            <i class="fas fa-exclamation-circle"></i>
            <strong>Erreur :</strong> <%= error %>
        </div>
        <% } %>

        <% if (message != null) { %>
        <div class="success-alert anim">
            <i class="fas fa-check-circle"></i>
            <%= message %>
        </div>
        <% } %>

        <% if (assignations != null && !assignations.isEmpty()) { %>

        <div class="kpi-grid anim">
            <div class="kpi-card">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap blue"><i class="fas fa-list-check"></i></div>
                </div>
                <div class="kpi-value"><%= totalAssignations %></div>
                <div class="kpi-label">Total assignations</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap green"><i class="fas fa-plus-circle"></i></div>
                </div>
                <div class="kpi-value"><%= nouvellesCount %></div>
                <div class="kpi-label">Nouvelles assignations</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap amber"><i class="fas fa-history"></i></div>
                </div>
                <div class="kpi-value"><%= existantes %></div>
                <div class="kpi-label">Déjà existantes</div>
            </div>
        </div>

        <div class="card anim">
            <div class="card-header">
                <div class="card-title">
                    <span class="title-dot"></span>
                    Détail des Assignations
                </div>
                <span class="card-badge"><%= totalAssignations %> résultats</span>
            </div>
            <div class="card-body">
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Client</th>
                            <th>Passagers</th>
                            <th>Hôtel</th>
                            <th>Véhicule</th>
                            <th>Capacité</th>
                            <th>Carburant</th>
                            <th>Départ</th>
                            <th>Arrivée</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Assignation a : assignations) { %>
                        <tr>
                            <td><span class="badge badge-id">#<%= a.getIdAssignation() %></span></td>
                            <td><strong><%= a.getReservation().getIdClient() %></strong></td>
                            <td><%= a.getReservation().getNbPassager() %></td>
                            <td><%= a.getReservation().getHotel() != null ? a.getReservation().getHotel().getNom() : a.getReservation().getIdHotel() %></td>
                            <td>
                                <div class="vehicle-cell">
                                    <span class="vehicle-name"><%= a.getVehicule().getMarque() %> <%= a.getVehicule().getModele() %></span>
                                    <span class="vehicle-plate"><%= a.getVehicule().getImmatriculation() %></span>
                                </div>
                            </td>
                            <td><%= a.getVehicule().getCapacite() %></td>
                            <td>
                                <span class="badge <%= a.getVehicule().getCarburant().equals("diesel") ? "badge-diesel" : "badge-essence" %>">
                                    <i class="fas fa-gas-pump"></i> <%= a.getVehicule().getCarburant() %>
                                </span>
                            </td>
                            <td><span class="time-cell"><i class="fas fa-clock" style="color:#059669;margin-right:4px;font-size:11px;"></i><%= a.getHeureDepart().format(timeFormatter) %></span></td>
                            <td><span class="time-cell"><i class="fas fa-flag-checkered" style="color:#d97706;margin-right:4px;font-size:11px;"></i><%= a.getHeureArrivee().format(timeFormatter) %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <% } else if (error == null) { %>
        <div class="card anim">
            <div class="card-body">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>Aucune réservation à assigner pour cette date.</p>
                </div>
            </div>
        </div>
        <% } %>

        <a href="assignation-form" class="btn-back anim">
            <i class="fas fa-arrow-left"></i> Retour au formulaire
        </a>
    </div>
</div>
</body>
</html>
