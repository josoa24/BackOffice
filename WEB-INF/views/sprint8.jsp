<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulaire Sprint 8</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .info-box {
            background: #e8f5e9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #4CAF50;
        }
        .info-box p {
            margin: 5px 0;
            font-size: 14px;
            color: #2e7d32;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="email"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        button {
            width: 100%;
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Sprint 8 - Formulaire</h1>
        
        <div class="info-box">
            <p><strong>Méthode :</strong> POST | <strong>URL :</strong> /sprint8Post</p>
            <p><strong>Paramètre :</strong> Map&lt;String, Object&gt; requestData</p>
        </div>
        
        <form action="<%= request.getContextPath() %>/sprint8Post" method="POST">
            <div class="form-group">
                <label for="nom">Nom complet</label>
                <input type="text" id="nom" name="nom" placeholder="Ex: Jean Rakoto" required>
            </div>
            
            <div class="form-group">
                <label for="email">Adresse email</label>
                <input type="email" id="email" name="email" placeholder="exemple@email.com" required>
            </div>
            
            <div class="form-group">
                <label for="age">Âge</label>
                <input type="number" id="age" name="age" placeholder="25" min="1" max="120" required>
            </div>
            
            <div class="form-group">
                <label for="ville">Ville</label>
                <input type="text" id="ville" name="ville" placeholder="Ex: Antananarivo" required>
            </div>
            
            <div class="form-group">
                <label for="message">Message</label>
                <textarea id="message" name="message" placeholder="Écrivez votre message ici..." required></textarea>
            </div>
            
            <button type="submit">Envoyer les données</button>
        </form>
    </div>
</body>
</html>
