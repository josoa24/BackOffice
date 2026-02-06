<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Réservation Enregistrée</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .success-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #4CAF50;
            text-align: center;
            margin-bottom: 20px;
        }
        .success-icon {
            text-align: center;
            font-size: 60px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        .message {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 18px;
        }
        .details {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: bold;
            color: #555;
        }
        .detail-value {
            color: #333;
        }
        .buttons {
            display: flex;
            gap: 10px;
        }
        button, a {
            flex: 1;
            padding: 12px;
            text-align: center;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            border: none;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .btn-secondary {
            background-color: #2196F3;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✓</div>
        <h1>Réservation Enregistrée!</h1>
        
        <% 
            String message = (String) request.getAttribute("message");
            Reservation reservation = (Reservation) request.getAttribute("reservation");
        %>
        
        <div class="message">
            <%= message != null ? message : "Votre réservation a été enregistrée avec succès." %>
        </div>
        
        <% if (reservation != null) { %>
            <div class="details">
                <h3>Détails de la Réservation</h3>
                <div class="detail-row">
                    <span class="detail-label">ID Réservation:</span>
                    <span class="detail-value"><%= reservation.getIdReservation() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">ID Client:</span>
                    <span class="detail-value"><%= reservation.getIdClient() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Nombre de Passagers:</span>
                    <span class="detail-value"><%= reservation.getNbPassager() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Date et Heure:</span>
                    <span class="detail-value">
                        <%= reservation.getDateHeure().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">ID Hôtel:</span>
                    <span class="detail-value"><%= reservation.getIdHotel() %></span>
                </div>
            </div>
        <% } %>
        
        <div class="buttons">
            <a href="reservation-form" class="btn-primary">Nouvelle Réservation</a>
            <a href="api/reservations" class="btn-secondary">Voir Toutes les Réservations</a>
        </div>
    </div>
</body>
</html>
