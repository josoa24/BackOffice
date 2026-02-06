<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Etudiant" %>
<%@ page import="entity.Option" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sprint 8ter - Résultat</title>
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
        .result-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 20px;
        }
        .info-section {
            margin-bottom: 30px;
        }
        .section-title {
            color: #4CAF50;
            font-size: 18px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #4CAF50;
        }
        .info-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .info-label {
            font-weight: bold;
            color: #555;
            min-width: 150px;
        }
        .info-value {
            color: #333;
        }
        .success-message {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .success-message strong {
            color: #155724;
        }
        .error-message {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .error-message strong {
            color: #721c24;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #4CAF50;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="result-container">
            <h2>Sprint 8ter - Résultat du Mapping</h2>
        <p class="subtitle">Objet Etudiant avec Option imbriquée</p>

        <%
            Etudiant etudiant = (Etudiant) request.getAttribute("etudiant");
            if (etudiant != null) {
        %>
            <div class="success-message">
                <strong>✓ Succès!</strong> L'objet Etudiant a été créé avec succès.
            </div>

            <div class="info-section">
                <div class="section-title">Informations Étudiant</div>
                <div class="info-row">
                    <span class="info-label">ID:</span>
                    <span class="info-value"><%= etudiant.getId() != null ? etudiant.getId() : "Non défini" %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Nom:</span>
                    <span class="info-value"><%= etudiant.getNom() != null ? etudiant.getNom() : "Non défini" %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Prénom:</span>
                    <span class="info-value"><%= etudiant.getPrenom() != null ? etudiant.getPrenom() : "Non défini" %></span>
                </div>
            </div>

            <%
                Option option = etudiant.getOption();
                if (option != null) {
            %>
                <div class="info-section">
                    <div class="section-title">Option (Objet Imbriqué)</div>
                    <div class="info-row">
                        <span class="info-label">Code:</span>
                        <span class="info-value"><%= option.getCode() != null ? option.getCode() : "Non défini" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Nom:</span>
                        <span class="info-value"><%= option.getNom() != null ? option.getNom() : "Non défini" %></span>
                    </div>
                </div>
            <%
                } else {
            %>
                <div class="error-message">
                    <strong>⚠ Attention!</strong> L'objet Option n'a pas été créé. Vérifiez que les champs option.code et option.nom sont bien remplis.
                </div>
            <%
                }
            %>
        <%
            } else {
        %>
            <div class="error-message">
                <strong>✗ Erreur!</strong> Aucun étudiant trouvé.
            </div>
        <%
            }
        %>

            <a href="sprint8terform" class="back-link">← Retour au formulaire</a>
        </div>
    </div>
</body>
</html>
