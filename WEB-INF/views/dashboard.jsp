<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - BackOffice</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f4f6fb;
            color: #1e1e2d;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        /* ===== TOP HEADER ===== */
        .top-header {
            background: #fff;
            padding: 18px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #eef0f6;
            position: sticky;
            top: 0;
            z-index: 50;
            backdrop-filter: blur(12px);
            background: rgba(255,255,255,0.95);
        }

        .header-left {
            display: flex;
            flex-direction: column;
        }

        .header-left h1 {
            font-size: 24px;
            font-weight: 800;
            color: #1e1e2d;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-left h1 .header-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .header-left .header-subtitle {
            font-size: 13px;
            color: #9ba4b5;
            margin-top: 3px;
            font-weight: 400;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-date {
            display: flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #f8f9fe, #eef0f8);
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 13px;
            color: #5a6178;
            font-weight: 600;
            border: 1px solid #e8eaf4;
        }

        .header-date i { color: #667eea; font-size: 14px; }

        .btn-refresh {
            display: flex;
            align-items: center;
            gap: 7px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-refresh:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45);
        }

        /* ===== CONTENT ===== */
        .content {
            padding: 28px 36px 40px;
        }

        /* ===== WELCOME BANNER ===== */
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            border-radius: 18px;
            padding: 32px 36px;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .welcome-banner::before {
            content: '';
            position: absolute;
            right: -50px;
            top: -50px;
            width: 250px;
            height: 250px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
        }

        .welcome-banner::after {
            content: '';
            position: absolute;
            right: 60px;
            bottom: -80px;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }

        .welcome-content {
            position: relative;
            z-index: 2;
        }

        .welcome-content h2 {
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .welcome-content p {
            font-size: 14px;
            opacity: 0.85;
            font-weight: 400;
            max-width: 550px;
            line-height: 1.5;
        }

        .welcome-stats {
            display: flex;
            gap: 40px;
            margin-top: 20px;
        }

        .welcome-stat-value {
            font-size: 28px;
            font-weight: 900;
        }

        .welcome-stat-label {
            font-size: 12px;
            opacity: 0.7;
            font-weight: 500;
            margin-top: 2px;
        }

        /* ===== KPI GRID ===== */
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
            cursor: default;
        }

        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.08);
            border-color: transparent;
        }

        .kpi-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .kpi-icon-wrap {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .kpi-icon-wrap.blue { background: linear-gradient(135deg, #dbeafe, #bfdbfe); color: #2563eb; }
        .kpi-icon-wrap.green { background: linear-gradient(135deg, #d1fae5, #a7f3d0); color: #059669; }
        .kpi-icon-wrap.purple { background: linear-gradient(135deg, #ede9fe, #ddd6fe); color: #7c3aed; }
        .kpi-icon-wrap.amber { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; }
        .kpi-icon-wrap.rose { background: linear-gradient(135deg, #fce7f3, #fbcfe8); color: #db2777; }
        .kpi-icon-wrap.cyan { background: linear-gradient(135deg, #cffafe, #a5f3fc); color: #0891b2; }

        .kpi-trend {
            display: flex;
            align-items: center;
            gap: 3px;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 8px;
        }

        .kpi-trend.up { background: #ecfdf5; color: #059669; }
        .kpi-trend.neutral { background: #f0f4ff; color: #667eea; }

        .kpi-value {
            font-size: 32px;
            font-weight: 900;
            color: #1e1e2d;
            line-height: 1;
            margin-bottom: 6px;
            letter-spacing: -0.5px;
        }

        .kpi-label {
            font-size: 13px;
            color: #9ba4b5;
            font-weight: 500;
        }

        .kpi-footer {
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid #f4f6fb;
            font-size: 12px;
            color: #a1aab8;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .kpi-footer i { font-size: 11px; }

        /* ===== CARDS ===== */
        .charts-row {
            display: grid;
            grid-template-columns: 5fr 3fr;
            gap: 18px;
            margin-bottom: 28px;
        }

        .charts-row-equal {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-bottom: 28px;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #eef0f6;
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
        }

        .card-header {
            padding: 22px 26px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: #1e1e2d;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .title-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .title-dot.blue { background: #667eea; }
        .title-dot.purple { background: #764ba2; }
        .title-dot.green { background: #10b981; }
        .title-dot.amber { background: #f59e0b; }

        .card-badge {
            background: #f4f6fb;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 11px;
            color: #7c8498;
            font-weight: 600;
            border: 1px solid #eef0f6;
        }

        .card-body {
            padding: 20px 26px 26px;
        }

        .chart-wrap {
            position: relative;
            height: 300px;
        }

        /* ===== TABLES ===== */
        .tables-row {
            display: grid;
            grid-template-columns: 3fr 2fr;
            gap: 18px;
            margin-bottom: 28px;
        }

        .table-modern {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table-modern thead th {
            background: #f8f9fd;
            padding: 12px 16px;
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
            padding: 14px 16px;
            font-size: 13px;
            color: #4a5068;
            border-bottom: 1px solid #f4f6fb;
            vertical-align: middle;
        }

        .table-modern tbody tr {
            transition: background 0.15s;
        }

        .table-modern tbody tr:hover { background: #f8f9fd; }
        .table-modern tbody tr:last-child td { border-bottom: none; }

        /* Badges */
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

        .badge-success { background: #ecfdf5; color: #059669; }
        .badge-warning { background: #fffbeb; color: #d97706; }
        .badge-info { background: #eff6ff; color: #2563eb; }
        .badge-diesel { background: #eef2ff; color: #4f46e5; }
        .badge-essence { background: #fef3c7; color: #92400e; }

        /* Vehicle list */
        .vehicle-list { list-style: none; }

        .vehicle-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid #f4f6fb;
            transition: all 0.2s;
        }

        .vehicle-item:last-child { border-bottom: none; }
        .vehicle-item:hover { padding-left: 6px; }

        .rank-badge {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
            color: white;
            flex-shrink: 0;
        }

        .rank-badge.gold { background: linear-gradient(135deg, #f59e0b, #fbbf24); box-shadow: 0 3px 10px rgba(245,158,11,0.3); }
        .rank-badge.silver { background: linear-gradient(135deg, #94a3b8, #cbd5e1); }
        .rank-badge.bronze { background: linear-gradient(135deg, #b45309, #d97706); }
        .rank-badge.default { background: #e2e8f0; color: #64748b; }

        .vehicle-info { flex: 1; min-width: 0; }
        .vehicle-name { font-size: 13.5px; font-weight: 600; color: #1e1e2d; }
        .vehicle-meta { font-size: 11.5px; color: #9ba4b5; margin-top: 2px; display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }

        .vehicle-count { text-align: right; }
        .vehicle-count-value { font-size: 20px; font-weight: 800; color: #1e1e2d; line-height: 1; }
        .vehicle-count-label { font-size: 10px; color: #a1aab8; font-weight: 500; }

        /* Progress ring */
        .progress-ring-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 16px 0;
        }

        .progress-ring-container {
            position: relative;
            width: 160px;
            height: 160px;
            margin-bottom: 16px;
        }

        .progress-ring-container svg { transform: rotate(-90deg); }

        .progress-ring-value {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }

        .progress-ring-number { font-size: 32px; font-weight: 900; color: #1e1e2d; line-height: 1; }
        .progress-ring-unit { font-size: 14px; color: #9ba4b5; font-weight: 600; }
        .progress-ring-label { font-size: 13px; color: #7c8498; font-weight: 500; }
        .progress-ring-sub { font-size: 12px; color: #a1aab8; margin-top: 4px; }

        /* Error */
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

        /* Animation */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .anim {
            opacity: 0;
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .anim:nth-child(1) { animation-delay: 0.04s; }
        .anim:nth-child(2) { animation-delay: 0.08s; }
        .anim:nth-child(3) { animation-delay: 0.12s; }
        .anim:nth-child(4) { animation-delay: 0.16s; }
        .anim:nth-child(5) { animation-delay: 0.20s; }
        .anim:nth-child(6) { animation-delay: 0.24s; }

        /* Responsive */
        @media (max-width: 1200px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .charts-row, .charts-row-equal, .tables-row { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .content { padding: 20px 16px; }
            .top-header { padding: 14px 16px; flex-wrap: wrap; gap: 12px; }
            .kpi-grid { grid-template-columns: 1fr; }
            .welcome-stats { flex-wrap: wrap; gap: 20px; }
            .header-right { width: 100%; justify-content: flex-end; }
        }
    </style>
</head>
<body>

<%
    request.setAttribute("currentPage", "dashboard");

    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    Integer reservationsAujourdHui = (Integer) request.getAttribute("reservationsAujourdHui");
    Integer totalHotels = (Integer) request.getAttribute("totalHotels");
    Integer totalVehicules = (Integer) request.getAttribute("totalVehicules");
    Integer totalAssignations = (Integer) request.getAttribute("totalAssignations");
    Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
    Double tauxAssignation = (Double) request.getAttribute("tauxAssignation");
    Double moyennePassagers = (Double) request.getAttribute("moyennePassagers");
    String dateAujourdHui = (String) request.getAttribute("dateAujourdHui");
    String error = (String) request.getAttribute("error");

    List<Map<String, Object>> reservationsParHotel = (List<Map<String, Object>>) request.getAttribute("reservationsParHotel");
    List<Map<String, Object>> reservationsParJour = (List<Map<String, Object>>) request.getAttribute("reservationsParJour");
    Map<String, Integer> vehiculesParCarburant = (Map<String, Integer>) request.getAttribute("vehiculesParCarburant");
    List<Map<String, Object>> dernieresReservations = (List<Map<String, Object>>) request.getAttribute("dernieresReservations");
    List<Map<String, Object>> topVehicules = (List<Map<String, Object>>) request.getAttribute("topVehicules");

    if (totalReservations == null) totalReservations = 0;
    if (reservationsAujourdHui == null) reservationsAujourdHui = 0;
    if (totalHotels == null) totalHotels = 0;
    if (totalVehicules == null) totalVehicules = 0;
    if (totalAssignations == null) totalAssignations = 0;
    if (totalPassagers == null) totalPassagers = 0;
    if (tauxAssignation == null) tauxAssignation = 0.0;
    if (moyennePassagers == null) moyennePassagers = 0.0;
    if (dateAujourdHui == null) dateAujourdHui = "";

    int nbDiesel = 0, nbEssence = 0;
    if (vehiculesParCarburant != null) {
        if (vehiculesParCarburant.get("diesel") != null) nbDiesel = vehiculesParCarburant.get("diesel");
        if (vehiculesParCarburant.get("essence") != null) nbEssence = vehiculesParCarburant.get("essence");
    }

    int nonAssignees = totalReservations - totalAssignations;
    if (nonAssignees < 0) nonAssignees = 0;
%>

<!-- SIDEBAR (include réutilisable) -->
<jsp:include page="sidebar.jsp" />

<!-- PAGE WRAPPER -->
<div class="page-wrapper">
    <!-- TOP HEADER -->
    <div class="top-header">
        <div class="header-left">
            <h1>
                <span class="header-icon"><i class="fas fa-th-large"></i></span>
                Tableau de Bord
            </h1>
            <span class="header-subtitle">Vue d'ensemble de votre système de réservation hôtelière</span>
        </div>
        <div class="header-right">
            <div class="header-date">
                <i class="fas fa-calendar-alt"></i>
                <%= dateAujourdHui %>
            </div>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-refresh">
                <i class="fas fa-sync-alt"></i> Actualiser
            </a>
        </div>
    </div>

    <!-- CONTENT -->
    <div class="content">

        <% if (error != null) { %>
        <div class="error-alert">
            <i class="fas fa-exclamation-circle"></i>
            <%= error %>
        </div>
        <% } %>

        <!-- WELCOME BANNER -->
        <div class="welcome-banner anim">
            <div class="welcome-content">
                <h2>Bienvenue sur votre Dashboard</h2>
                <p>Suivez en temps réel vos réservations, assignations de véhicules et performances de votre réseau hôtelier.</p>
                <div class="welcome-stats">
                    <div class="welcome-stat">
                        <div class="welcome-stat-value"><%= totalReservations %></div>
                        <div class="welcome-stat-label">Réservations totales</div>
                    </div>
                    <div class="welcome-stat">
                        <div class="welcome-stat-value"><%= totalAssignations %></div>
                        <div class="welcome-stat-label">Véhicules assignés</div>
                    </div>
                    <div class="welcome-stat">
                        <div class="welcome-stat-value"><%= tauxAssignation %>%</div>
                        <div class="welcome-stat-label">Taux d'assignation</div>
                    </div>
                    <div class="welcome-stat">
                        <div class="welcome-stat-value"><%= reservationsAujourdHui %></div>
                        <div class="welcome-stat-label">Aujourd'hui</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- KPI CARDS -->
        <div class="kpi-grid">
            <div class="kpi-card anim">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap blue"><i class="fas fa-ticket-alt"></i></div>
                    <div class="kpi-trend neutral"><i class="fas fa-chart-line"></i> Total</div>
                </div>
                <div class="kpi-value"><%= totalReservations %></div>
                <div class="kpi-label">Réservations</div>
                <div class="kpi-footer"><i class="fas fa-calendar-check"></i> <%= reservationsAujourdHui %> nouvelle(s) aujourd'hui</div>
            </div>

            <div class="kpi-card anim">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap green"><i class="fas fa-users"></i></div>
                    <div class="kpi-trend up"><i class="fas fa-arrow-up"></i> ~<%= moyennePassagers %>/rés</div>
                </div>
                <div class="kpi-value"><%= totalPassagers %></div>
                <div class="kpi-label">Passagers transportés</div>
                <div class="kpi-footer"><i class="fas fa-user-friends"></i> Moyenne de <%= moyennePassagers %> par réservation</div>
            </div>

            <div class="kpi-card anim">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap purple"><i class="fas fa-building"></i></div>
                    <div class="kpi-trend neutral"><i class="fas fa-handshake"></i> Actifs</div>
                </div>
                <div class="kpi-value"><%= totalHotels %></div>
                <div class="kpi-label">Hôtels partenaires</div>
                <div class="kpi-footer"><i class="fas fa-map-marker-alt"></i> Réseau d'hôtels actif</div>
            </div>

            <div class="kpi-card anim">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap amber"><i class="fas fa-shuttle-van"></i></div>
                    <div class="kpi-trend neutral"><i class="fas fa-gas-pump"></i> Flotte</div>
                </div>
                <div class="kpi-value"><%= totalVehicules %></div>
                <div class="kpi-label">Véhicules disponibles</div>
                <div class="kpi-footer"><i class="fas fa-gas-pump"></i> <%= nbDiesel %> diesel · <%= nbEssence %> essence</div>
            </div>

            <div class="kpi-card anim">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap rose"><i class="fas fa-check-double"></i></div>
                    <div class="kpi-trend <%= tauxAssignation >= 50 ? "up" : "neutral" %>">
                        <i class="fas fa-percentage"></i> <%= tauxAssignation %>%
                    </div>
                </div>
                <div class="kpi-value"><%= totalAssignations %></div>
                <div class="kpi-label">Assignations effectuées</div>
                <div class="kpi-footer"><i class="fas fa-clock"></i> <%= nonAssignees %> en attente d'assignation</div>
            </div>

            <div class="kpi-card anim">
                <div class="kpi-top">
                    <div class="kpi-icon-wrap cyan"><i class="fas fa-clock"></i></div>
                    <div class="kpi-trend neutral"><i class="fas fa-calendar-day"></i> Live</div>
                </div>
                <div class="kpi-value"><%= reservationsAujourdHui %></div>
                <div class="kpi-label">Réservations du jour</div>
                <div class="kpi-footer"><i class="fas fa-bolt"></i> À traiter aujourd'hui</div>
            </div>
        </div>

        <!-- CHARTS ROW 1 -->
        <div class="charts-row">
            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot blue"></span>
                        Évolution des Réservations
                    </div>
                    <span class="card-badge"><i class="fas fa-chart-area"></i>&nbsp; 30 jours</span>
                </div>
                <div class="card-body">
                    <div class="chart-wrap">
                        <canvas id="chartEvolution"></canvas>
                    </div>
                </div>
            </div>

            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot purple"></span>
                        Répartition par Hôtel
                    </div>
                    <span class="card-badge"><i class="fas fa-chart-pie"></i>&nbsp; Global</span>
                </div>
                <div class="card-body">
                    <div class="chart-wrap">
                        <canvas id="chartHotel"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- CHARTS ROW 2 -->
        <div class="charts-row-equal">
            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot green"></span>
                        Véhicules par Carburant
                    </div>
                    <span class="card-badge"><i class="fas fa-gas-pump"></i>&nbsp; Flotte</span>
                </div>
                <div class="card-body">
                    <div class="chart-wrap" style="height: 260px;">
                        <canvas id="chartCarburant"></canvas>
                    </div>
                </div>
            </div>

            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot amber"></span>
                        Taux d'Assignation
                    </div>
                    <span class="card-badge"><%= tauxAssignation >= 70 ? "✅ Bon" : tauxAssignation >= 40 ? "⚠️ Moyen" : "🔴 Faible" %></span>
                </div>
                <div class="card-body">
                    <div class="progress-ring-wrap">
                        <%
                            double circumference = 2 * Math.PI * 60;
                            double dashOffset = circumference - (tauxAssignation / 100.0 * circumference);
                            String ringColor = tauxAssignation >= 70 ? "#10b981" : tauxAssignation >= 40 ? "#667eea" : "#ef4444";
                        %>
                        <div class="progress-ring-container">
                            <svg width="160" height="160" viewBox="0 0 160 160">
                                <circle cx="80" cy="80" r="60" fill="none" stroke="#f4f6fb" stroke-width="12"/>
                                <circle cx="80" cy="80" r="60" fill="none" stroke="<%= ringColor %>" stroke-width="12"
                                        stroke-dasharray="<%= circumference %>" stroke-dashoffset="<%= dashOffset %>"
                                        stroke-linecap="round" style="transition: stroke-dashoffset 1.5s ease;"/>
                            </svg>
                            <div class="progress-ring-value">
                                <div class="progress-ring-number"><%= tauxAssignation %></div>
                                <div class="progress-ring-unit">%</div>
                            </div>
                        </div>
                        <div class="progress-ring-label">Taux d'assignation global</div>
                        <div class="progress-ring-sub"><%= totalAssignations %> assignées sur <%= totalReservations %> réservations</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- TABLES -->
        <div class="tables-row">
            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot blue"></span>
                        Dernières Réservations
                    </div>
                    <span class="card-badge"><%= totalReservations %> au total</span>
                </div>
                <div class="card-body" style="padding-top: 12px;">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Réservation</th>
                                <th>Client</th>
                                <th>Hôtel</th>
                                <th>Passagers</th>
                                <th>Date</th>
                                <th>Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (dernieresReservations != null) {
                                for (Map<String, Object> res : dernieresReservations) {
                                    String dateStr = (String) res.get("dateHeure");
                                    if (dateStr != null) dateStr = dateStr.replace("T", " ");
                                    boolean isAssigned = (Boolean) res.get("assignee");
                            %>
                            <tr>
                                <td><strong style="color: #667eea;">#<%= res.get("idReservation") %></strong></td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 6px;">
                                        <div style="width: 28px; height: 28px; border-radius: 8px; background: linear-gradient(135deg, #667eea, #764ba2); display: flex; align-items: center; justify-content: center; color: white; font-size: 11px; font-weight: 700;"><%= String.valueOf(res.get("idClient")).substring(0, 2) %></div>
                                        <span><%= res.get("idClient") %></span>
                                    </div>
                                </td>
                                <td><%= res.get("hotel") %></td>
                                <td><span class="badge badge-info"><i class="fas fa-users"></i> <%= res.get("nbPassager") %></span></td>
                                <td style="font-size: 12px; color: #7c8498;"><%= dateStr %></td>
                                <td>
                                    <% if (isAssigned) { %>
                                        <span class="badge badge-success"><i class="fas fa-check-circle"></i> Assignée</span>
                                    <% } else { %>
                                        <span class="badge badge-warning"><i class="fas fa-hourglass-half"></i> En attente</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot amber"></span>
                        Top Véhicules
                    </div>
                    <span class="card-badge"><i class="fas fa-trophy"></i>&nbsp; Classement</span>
                </div>
                <div class="card-body" style="padding-top: 8px;">
                    <ul class="vehicle-list">
                        <% if (topVehicules != null) {
                            int rank = 0;
                            String[] rankClasses = {"gold", "silver", "bronze", "default", "default"};
                            for (Map<String, Object> v : topVehicules) {
                                rank++;
                                String rankClass = rank <= 3 ? rankClasses[rank - 1] : "default";
                        %>
                        <li class="vehicle-item">
                            <div class="rank-badge <%= rankClass %>"><%= rank %></div>
                            <div class="vehicle-info">
                                <div class="vehicle-name"><%= v.get("marque") %> <%= v.get("modele") %></div>
                                <div class="vehicle-meta">
                                    <span><%= v.get("immatriculation") %></span>
                                    <span>&middot;</span>
                                    <span class="badge <%= "diesel".equals(v.get("carburant")) ? "badge-diesel" : "badge-essence" %>">
                                        <i class="fas fa-gas-pump"></i> <%= v.get("carburant") %>
                                    </span>
                                    <span>&middot;</span>
                                    <span><%= v.get("capacite") %> places</span>
                                </div>
                            </div>
                            <div class="vehicle-count">
                                <div class="vehicle-count-value"><%= v.get("missions") %></div>
                                <div class="vehicle-count-label">missions</div>
                            </div>
                        </li>
                        <% } } %>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- ===== CHART.JS ===== -->
<script>
    Chart.defaults.font.family = 'Inter';

    const palette = {
        blue: '#667eea', purple: '#764ba2', green: '#10b981',
        amber: '#f59e0b', rose: '#f43f5e', cyan: '#06b6d4',
        indigo: '#6366f1', pink: '#ec4899'
    };

    const gradientColors = [palette.blue, palette.purple, palette.rose, palette.green, palette.amber, palette.pink, palette.cyan, palette.indigo];

    // --- Evolution chart ---
    <%
        StringBuilder lblJ = new StringBuilder("[");
        StringBuilder dtJ = new StringBuilder("[");
        StringBuilder dtP = new StringBuilder("[");
        if (reservationsParJour != null) {
            for (int i = 0; i < reservationsParJour.size(); i++) {
                Map<String, Object> row = reservationsParJour.get(i);
                if (i > 0) { lblJ.append(","); dtJ.append(","); dtP.append(","); }
                lblJ.append("'").append(row.get("jour")).append("'");
                dtJ.append(row.get("reservations"));
                dtP.append(row.get("passagers"));
            }
        }
        lblJ.append("]"); dtJ.append("]"); dtP.append("]");
    %>

    (function() {
        const ctx = document.getElementById('chartEvolution').getContext('2d');
        const g1 = ctx.createLinearGradient(0, 0, 0, 300);
        g1.addColorStop(0, 'rgba(102, 126, 234, 0.2)');
        g1.addColorStop(1, 'rgba(102, 126, 234, 0.01)');
        const g2 = ctx.createLinearGradient(0, 0, 0, 300);
        g2.addColorStop(0, 'rgba(118, 75, 162, 0.15)');
        g2.addColorStop(1, 'rgba(118, 75, 162, 0.01)');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: <%= lblJ.toString() %>,
                datasets: [
                    {
                        label: 'Réservations',
                        data: <%= dtJ.toString() %>,
                        borderColor: palette.blue,
                        backgroundColor: g1,
                        borderWidth: 2.5,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 3,
                        pointHoverRadius: 7,
                        pointBackgroundColor: '#fff',
                        pointBorderColor: palette.blue,
                        pointBorderWidth: 2,
                        pointHoverBackgroundColor: palette.blue
                    },
                    {
                        label: 'Passagers',
                        data: <%= dtP.toString() %>,
                        borderColor: palette.purple,
                        backgroundColor: g2,
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4,
                        pointRadius: 2,
                        pointHoverRadius: 6,
                        pointBackgroundColor: '#fff',
                        pointBorderColor: palette.purple,
                        pointBorderWidth: 2,
                        borderDash: [6, 4]
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'top', labels: { usePointStyle: true, padding: 20, font: { size: 12, weight: '600' } } },
                    tooltip: { backgroundColor: '#1e1e2d', titleFont: { size: 13, weight: '700' }, bodyFont: { size: 12 }, padding: 14, cornerRadius: 10 }
                },
                scales: {
                    x: { grid: { display: false }, ticks: { font: { size: 10 }, maxRotation: 45, color: '#9ba4b5' } },
                    y: { beginAtZero: true, grid: { color: '#f4f6fb', drawBorder: false }, ticks: { font: { size: 11 }, stepSize: 1, color: '#9ba4b5' } }
                },
                interaction: { intersect: false, mode: 'index' }
            }
        });
    })();

    // --- Doughnut hôtels ---
    <%
        StringBuilder lblH = new StringBuilder("[");
        StringBuilder dtH = new StringBuilder("[");
        if (reservationsParHotel != null) {
            for (int i = 0; i < reservationsParHotel.size(); i++) {
                Map<String, Object> row = reservationsParHotel.get(i);
                if (i > 0) { lblH.append(","); dtH.append(","); }
                lblH.append("'").append(((String)row.get("hotel")).replace("'", "\\'")).append("'");
                dtH.append(row.get("reservations"));
            }
        }
        lblH.append("]"); dtH.append("]");
    %>

    (function() {
        const ctx = document.getElementById('chartHotel').getContext('2d');
        const n = <%= reservationsParHotel != null ? reservationsParHotel.size() : 0 %>;
        const bg = [];
        for (let i = 0; i < n; i++) bg.push(gradientColors[i % gradientColors.length]);

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: <%= lblH.toString() %>,
                datasets: [{
                    data: <%= dtH.toString() %>,
                    backgroundColor: bg,
                    borderWidth: 3,
                    borderColor: '#fff',
                    hoverOffset: 8,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '68%',
                plugins: {
                    legend: { position: 'bottom', labels: { usePointStyle: true, padding: 16, font: { size: 11, weight: '500' } } },
                    tooltip: { backgroundColor: '#1e1e2d', padding: 12, cornerRadius: 10 }
                }
            }
        });
    })();

    // --- Bar chart carburant ---
    (function() {
        const ctx = document.getElementById('chartCarburant').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Diesel', 'Essence'],
                datasets: [{
                    label: 'Véhicules',
                    data: [<%= nbDiesel %>, <%= nbEssence %>],
                    backgroundColor: ['rgba(79, 70, 229, 0.85)', 'rgba(245, 158, 11, 0.85)'],
                    borderColor: ['#4f46e5', '#f59e0b'],
                    borderWidth: 2,
                    borderRadius: 10,
                    borderSkipped: false,
                    barThickness: 60
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { backgroundColor: '#1e1e2d', padding: 12, cornerRadius: 10 }
                },
                scales: {
                    x: { grid: { display: false }, ticks: { font: { size: 13, weight: '600' }, color: '#4a5068' } },
                    y: { beginAtZero: true, grid: { color: '#f4f6fb', drawBorder: false }, ticks: { stepSize: 1, font: { size: 11 }, color: '#9ba4b5' } }
                }
            }
        });
    })();
</script>

</body>
</html>
