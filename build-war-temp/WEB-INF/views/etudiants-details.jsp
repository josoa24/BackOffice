<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="entity.Etudiant" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détails Étudiant</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 0;
            background-color: #f5f5f5;
        }
        .content-wrapper {
            padding: 20px;
            margin-top: 20px;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        .etudiant-info {
            background-color: #e8f5e9;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .info-row {
            margin-bottom: 15px;
        }
        .label {
            font-weight: bold;
            color: #2e7d32;
            display: inline-block;
            width: 150px;
        }
        .value {
            color: #1b5e20;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="container">
            <h1>Détails de l'Étudiant</h1>
        
        <div class="etudiant-info">
            <% Etudiant etudiant = (Etudiant) request.getAttribute("etudiant"); %>
            <% if (etudiant != null) { %>
                <div class="info-row">
                    <span class="label">ID :</span>
                    <span class="value"><%= etudiant.getId() %></span>
                </div>
                <div class="info-row">
                    <span class="label">Nom :</span>
                    <span class="value"><%= etudiant.getNom() %></span>
                </div>
                <div class="info-row">
                    <span class="label">Prénom :</span>
                    <span class="value"><%= etudiant.getPrenom() %></span>
                </div>
            <% } else { %>
                <p>Aucun étudiant trouvé.</p>
            <% } %>
        </div>
        
            <p style="margin-top: 30px;">
                <a href="/FrameWork-Test/sprint5" style="color: #4CAF50; text-decoration: none;">← Retour à la liste</a>
            </p>
        </div>
    </div>
</body>
</html>
