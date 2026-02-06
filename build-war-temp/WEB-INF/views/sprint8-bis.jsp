<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sprint 8-bis - Formulaire Étudiant</title>
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: #4CAF50;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="container">
        <h1>Sprint 8-bis - Création d'Étudiant</h1>
        
        <div class="info-box">
            <p><strong>Méthode :</strong> POST</p>
            <p><strong>URL :</strong> /sprint8-bissave</p>
            <p><strong>Paramètre :</strong> Etudiant etudiant (objet automatique)</p>
        </div>
        
        <form action="<%= request.getContextPath() %>/sprint8-bissave" method="POST">
            <div class="form-group">
                <label for="id">ID Étudiant</label>
                <input type="text" id="id" name="id" placeholder="Ex: ETU001" required>
            </div>
            
            <div class="form-group">
                <label for="nom">Nom</label>
                <input type="text" id="nom" name="nom" placeholder="Ex: Rakoto" required>
            </div>
            
            <div class="form-group">
                <label for="prenom">Prénom</label>
                <input type="text" id="prenom" name="prenom" placeholder="Ex: Jean" required>
            </div>
            
            <button type="submit">💾 Enregistrer l'Étudiant</button>
        </form>
        </div>
    </div>
</body>
</html>
