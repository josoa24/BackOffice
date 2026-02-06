<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="entity.Etudiant" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sprint 8-bis - Résultat</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
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
        .success-badge {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            margin-bottom: 20px;
            font-size: 16px;
            font-weight: bold;
        }
        .info-box {
            background-color: #e8f5e9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #4CAF50;
        }
        .info-box p {
            margin: 5px 0;
            color: #2e7d32;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .data-table tr {
            border-bottom: 1px solid #e0e0e0;
        }
        .data-table td {
            padding: 12px;
        }
        .data-table td:first-child {
            font-weight: bold;
            color: #4CAF50;
            width: 40%;
        }
        .data-table td:last-child {
            color: #333;
        }
        .btn-back {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
        }
        .btn-back:hover {
            background-color: #45a049;
        }
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="container">
            <h1>✅ Étudiant Enregistré</h1>
        
        <div class="success-badge">
            L'objet Etudiant a été créé automatiquement à partir du formulaire !
        </div>
        
        <div class="info-box">
            <p><strong>Mapping automatique :</strong> Les champs du formulaire (id, nom, prenom) ont été automatiquement mappés aux propriétés de l'objet Etudiant</p>
        </div>
        
        <table class="data-table">
            <% 
                Etudiant etudiant = (Etudiant) request.getAttribute("etudiant");
                if (etudiant != null) {
            %>
                <tr>
                    <td>ID</td>
                    <td><%= etudiant.getId() %></td>
                </tr>
                <tr>
                    <td>Nom</td>
                    <td><%= etudiant.getNom() %></td>
                </tr>
                <tr>
                    <td>Prénom</td>
                    <td><%= etudiant.getPrenom() %></td>
                </tr>
            <% 
                } else {
            %>
                <tr>
                    <td colspan="2">Aucun étudiant trouvé</td>
                </tr>
            <% 
                }
            %>
        </table>
        
            <div class="btn-container">
                <a href="<%= request.getContextPath() %>/sprint8-bisform" class="btn-back">← Nouveau formulaire</a>
            </div>
        </div>
    </div>
</body>
</html>
