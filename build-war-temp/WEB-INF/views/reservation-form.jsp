<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Hotel" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulaire de Réservation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="number"],
        input[type="datetime-local"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input:focus,
        select:focus {
            outline: none;
            border-color: #4CAF50;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background-color: #45a049;
        }
        .error {
            color: #d32f2f;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .info {
            color: #666;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>📅 Nouvelle Réservation</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="reservation-save" method="POST">
            <div class="form-group">
                <label for="idClient">ID Client *</label>
                <input type="number" 
                       id="idClient" 
                       name="idClient" 
                       min="1000" 
                       max="9999" 
                       required 
                       placeholder="Ex: 1234">
                <div class="info">Entrez un numéro à 4 chiffres (1000-9999)</div>
            </div>
            
            <div class="form-group">
                <label for="nbPassager">Nombre de Passagers *</label>
                <input type="number" 
                       id="nbPassager" 
                       name="nbPassager" 
                       min="1" 
                       required 
                       placeholder="Ex: 2">
            </div>
            
            <div class="form-group">
                <label for="dateHeure">Date et Heure *</label>
                <input type="datetime-local" 
                       id="dateHeure" 
                       name="dateHeure" 
                       required>
            </div>
            
            <div class="form-group">
                <label for="idHotel">Hôtel *</label>
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
            
            <button type="submit">Enregistrer la Réservation</button>
        </form>
    </div>
</body>
</html>
