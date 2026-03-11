<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Hotel" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Réservation - BackOffice</title>
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
        .header-left h1 .header-icon { width: 36px; height: 36px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; }
        .header-left .header-subtitle { font-size: 13px; color: #9ba4b5; margin-top: 3px; font-weight: 400; }

        .content { padding: 28px 36px 40px; }

        .form-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            border-radius: 18px;
            padding: 32px 36px;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
            color: white;
        }
        .form-banner::before { content: ''; position: absolute; right: -50px; top: -50px; width: 250px; height: 250px; background: rgba(255,255,255,0.08); border-radius: 50%; }
        .form-banner::after { content: ''; position: absolute; right: 60px; bottom: -80px; width: 200px; height: 200px; background: rgba(255,255,255,0.05); border-radius: 50%; }
        .form-banner .banner-content { position: relative; z-index: 2; }
        .form-banner h2 { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
        .form-banner p { font-size: 14px; opacity: 0.85; font-weight: 400; line-height: 1.5; }

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
        .title-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; background: #667eea; }
        .card-body { padding: 24px 26px 30px; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-grid .full-width { grid-column: 1 / -1; }

        .form-group { margin-bottom: 0; }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #4a5068;
            font-weight: 600;
            font-size: 13px;
            letter-spacing: 0.3px;
        }
        .form-group label i { margin-right: 6px; color: #667eea; font-size: 13px; }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #eef0f6;
            border-radius: 12px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            color: #1e1e2d;
            background: #f8f9fd;
            transition: all 0.25s ease;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        .form-group .form-hint {
            font-size: 11.5px;
            color: #9ba4b5;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .form-group .form-hint i { font-size: 10px; }

        .btn-submit {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 14px 28px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            margin-top: 8px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45);
        }
        .btn-submit:active { transform: translateY(0); }

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

        .info-card {
            background: linear-gradient(135deg, #eff6ff, #eef2ff);
            border: 1px solid #c7d2fe;
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 24px;
        }
        .info-card h4 { color: #4338ca; font-size: 14px; font-weight: 700; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }
        .info-card ul { margin: 0; padding-left: 20px; color: #4a5068; font-size: 13px; line-height: 1.8; }

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
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "reservation");
%>
<jsp:include page="sidebar.jsp" />

<div class="page-wrapper">
    <div class="top-header">
        <div class="header-left">
            <h1>
                <span class="header-icon"><i class="fas fa-calendar-plus"></i></span>
                Nouvelle Réservation
            </h1>
            <span class="header-subtitle">Créez une nouvelle réservation pour un client</span>
        </div>
    </div>

    <div class="content">
        <div class="form-banner anim">
            <div class="banner-content">
                <h2><i class="fas fa-concierge-bell"></i> Formulaire de Réservation</h2>
                <p>Remplissez les informations ci-dessous pour enregistrer une nouvelle réservation dans le système.</p>
            </div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="error-alert anim">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <div class="card anim">
            <div class="card-header">
                <div class="card-title">
                    <span class="title-dot"></span>
                    Informations de la Réservation
                </div>
            </div>
            <div class="card-body">
                <div class="info-card">
                    <h4><i class="fas fa-info-circle"></i> Instructions</h4>
                    <ul>
                        <li>L'ID Client doit être un numéro à 4 chiffres (1000-9999)</li>
                        <li>Sélectionnez l'hôtel de destination du client</li>
                        <li>L'assignation de véhicule se fait automatiquement après</li>
                    </ul>
                </div>

                <form action="reservation-save" method="POST">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="idClient"><i class="fas fa-id-badge"></i> ID Client *</label>
                            <input type="number" id="idClient" name="idClient" min="1000" max="9999" required placeholder="Ex: 1234">
                            <div class="form-hint"><i class="fas fa-info-circle"></i> Numéro à 4 chiffres (1000-9999)</div>
                        </div>

                        <div class="form-group">
                            <label for="nbPassager"><i class="fas fa-users"></i> Nombre de Passagers *</label>
                            <input type="number" id="nbPassager" name="nbPassager" min="1" required placeholder="Ex: 2">
                        </div>

                        <div class="form-group">
                            <label for="dateHeure"><i class="fas fa-clock"></i> Date et Heure *</label>
                            <input type="datetime-local" id="dateHeure" name="dateHeure" required>
                        </div>

                        <div class="form-group">
                            <label for="idHotel"><i class="fas fa-hotel"></i> Hôtel *</label>
                            <select id="idHotel" name="idHotel" required>
                                <option value="">-- Sélectionnez un hôtel --</option>
                                <%
                                    List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
                                    if (hotels != null) {
                                        for (Hotel hotel : hotels) {
                                %>
                                    <option value="<%= hotel.getIdHotel() %>"><%= hotel.getNom() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <button type="submit" class="btn-submit">
                                <i class="fas fa-paper-plane"></i> Enregistrer la Réservation
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
