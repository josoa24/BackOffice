<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation Enregistrée - BackOffice</title>
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
        .header-left h1 .header-icon { width: 36px; height: 36px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; }
        .header-left .header-subtitle { font-size: 13px; color: #9ba4b5; margin-top: 3px; font-weight: 400; }

        .content { padding: 28px 36px 40px; }

        .success-banner {
            background: linear-gradient(135deg, #10b981 0%, #059669 50%, #34d399 100%);
            border-radius: 18px;
            padding: 36px;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
            color: white;
            text-align: center;
        }
        .success-banner::before { content: ''; position: absolute; right: -50px; top: -50px; width: 250px; height: 250px; background: rgba(255,255,255,0.08); border-radius: 50%; }
        .success-banner::after { content: ''; position: absolute; left: -30px; bottom: -60px; width: 200px; height: 200px; background: rgba(255,255,255,0.05); border-radius: 50%; }
        .success-banner .banner-content { position: relative; z-index: 2; }
        .success-icon { font-size: 56px; margin-bottom: 16px; display: inline-flex; width: 80px; height: 80px; align-items: center; justify-content: center; background: rgba(255,255,255,0.2); border-radius: 50%; }
        .success-banner h2 { font-size: 24px; font-weight: 800; margin-bottom: 8px; }
        .success-banner p { font-size: 15px; opacity: 0.9; font-weight: 400; }

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
        .title-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; background: #10b981; }
        .card-body { padding: 24px 26px 30px; }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0;
        }
        .detail-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 20px;
            border-bottom: 1px solid #f4f6fb;
            transition: background 0.2s;
        }
        .detail-item:hover { background: #f8f9fd; }
        .detail-item:nth-last-child(-n+2) { border-bottom: none; }
        .detail-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }
        .detail-icon.blue { background: linear-gradient(135deg, #dbeafe, #bfdbfe); color: #2563eb; }
        .detail-icon.green { background: linear-gradient(135deg, #d1fae5, #a7f3d0); color: #059669; }
        .detail-icon.purple { background: linear-gradient(135deg, #ede9fe, #ddd6fe); color: #7c3aed; }
        .detail-icon.amber { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; }
        .detail-icon.rose { background: linear-gradient(135deg, #fce7f3, #fbcfe8); color: #db2777; }
        .detail-info-label { font-size: 12px; color: #9ba4b5; font-weight: 500; margin-bottom: 2px; }
        .detail-info-value { font-size: 16px; font-weight: 700; color: #1e1e2d; }

        .buttons-row {
            display: flex;
            gap: 14px;
            margin-top: 28px;
        }
        .btn {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45); }
        .btn-secondary {
            background: #fff;
            color: #667eea;
            border: 2px solid #e8eaf4;
        }
        .btn-secondary:hover { background: #f4f6fb; border-color: #667eea; transform: translateY(-2px); }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .anim { opacity: 0; animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .anim:nth-child(1) { animation-delay: 0.04s; }
        .anim:nth-child(2) { animation-delay: 0.08s; }
        .anim:nth-child(3) { animation-delay: 0.12s; }

        @media (max-width: 768px) {
            .content { padding: 20px 16px; }
            .top-header { padding: 14px 16px; }
            .detail-grid { grid-template-columns: 1fr; }
            .buttons-row { flex-direction: column; }
        }
    </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "reservation");
    String message = (String) request.getAttribute("message");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
%>
<jsp:include page="sidebar.jsp" />

<div class="page-wrapper">
    <div class="top-header">
        <div class="header-left">
            <h1>
                <span class="header-icon"><i class="fas fa-check-circle"></i></span>
                Réservation Confirmée
            </h1>
            <span class="header-subtitle">La réservation a été enregistrée avec succès</span>
        </div>
    </div>

    <div class="content">
        <div class="success-banner anim">
            <div class="banner-content">
                <div class="success-icon"><i class="fas fa-check"></i></div>
                <h2>Réservation Enregistrée !</h2>
                <p><%= message != null ? message : "Votre réservation a été enregistrée avec succès." %></p>
            </div>
        </div>

        <% if (reservation != null) { %>
        <div class="card anim">
            <div class="card-header">
                <div class="card-title">
                    <span class="title-dot"></span>
                    Détails de la Réservation
                </div>
            </div>
            <div class="card-body">
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-icon blue"><i class="fas fa-hashtag"></i></div>
                        <div>
                            <div class="detail-info-label">ID Réservation</div>
                            <div class="detail-info-value"><%= reservation.getIdReservation() %></div>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon green"><i class="fas fa-id-badge"></i></div>
                        <div>
                            <div class="detail-info-label">ID Client</div>
                            <div class="detail-info-value"><%= reservation.getIdClient() %></div>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon purple"><i class="fas fa-users"></i></div>
                        <div>
                            <div class="detail-info-label">Nombre de Passagers</div>
                            <div class="detail-info-value"><%= reservation.getNbPassager() %></div>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon amber"><i class="fas fa-calendar-alt"></i></div>
                        <div>
                            <div class="detail-info-label">Date et Heure</div>
                            <div class="detail-info-value"><%= reservation.getDateHeure().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></div>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-icon rose"><i class="fas fa-hotel"></i></div>
                        <div>
                            <div class="detail-info-label">ID Hôtel</div>
                            <div class="detail-info-value"><%= reservation.getIdHotel() %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <div class="buttons-row anim">
            <a href="reservation-form" class="btn btn-primary"><i class="fas fa-plus-circle"></i> Nouvelle Réservation</a>
            <a href="assignation-form" class="btn btn-secondary"><i class="fas fa-route"></i> Assigner un Véhicule</a>
        </div>
    </div>
</div>
</body>
</html>
