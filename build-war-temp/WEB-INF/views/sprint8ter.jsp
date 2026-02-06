<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sprint 8ter - Objets Imbriqués</title>
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
        .form-container {
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .section-title {
            color: #4CAF50;
            font-size: 18px;
            margin-top: 30px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #4CAF50;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        button:hover {
            background-color: #45a049;
        }
        .note {
            background-color: #e7f3fe;
            border-left: 4px solid #2196F3;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #555;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="form-container">
            <h2>Sprint 8ter - Test Objets Imbriqués</h2>
        <p class="subtitle">Formulaire avec objet Option imbriqué dans Etudiant</p>
        
        <div class="note">
            <strong>Note:</strong> Les champs avec la notation <code>option.nom</code> seront automatiquement mappés vers l'objet <code>Option</code> imbriqué dans <code>Etudiant</code>.
        </div>

        <form action="sprint8tersave" method="post">
            <div class="section-title">Informations Étudiant</div>
            
            <div class="form-group">
                <label for="id">ID Étudiant:</label>
                <input type="text" id="id" name="id" placeholder="Ex: ETU001" required>
            </div>
            
            <div class="form-group">
                <label for="nom">Nom:</label>
                <input type="text" id="nom" name="nom" placeholder="Ex: Rakoto" required>
            </div>
            
            <div class="form-group">
                <label for="prenom">Prénom:</label>
                <input type="text" id="prenom" name="prenom" placeholder="Ex: Jean" required>
            </div>

            <div class="section-title">Option (Objet Imbriqué)</div>
            
            <div class="form-group">
                <label for="option.code">Code Option:</label>
                <input type="text" id="option.code" name="option.code" placeholder="Ex: INFO" required>
            </div>
            
            <div class="form-group">
                <label for="option.nom">Nom Option:</label>
                <input type="text" id="option.nom" name="option.nom" placeholder="Ex: Informatique" required>
            </div>
            
            <button type="submit">Enregistrer</button>
        </form>
        </div>
    </div>
</body>
</html>
