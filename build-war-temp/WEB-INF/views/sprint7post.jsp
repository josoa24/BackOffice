<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test POST - Sprint 7</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #2196F3;
            padding-bottom: 10px;
        }
        form {
            margin-top: 20px;
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
            font-size: 16px;
            box-sizing: border-box;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: #2196F3;
        }
        button {
            background-color: #2196F3;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #1976D2;
        }
        .info {
            background-color: #E3F2FD;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #2196F3;
        }
        .info p {
            margin: 5px 0;
            color: #1565C0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Test Méthode POST - Sprint 7</h1>
        
        <div class="info">
            <p><strong>Méthode :</strong> POST</p>
            <p><strong>URL :</strong> /sprint7post</p>
            <p><strong>Annotation :</strong> @PostMapping</p>
        </div>
        
        <form action="<%= request.getContextPath() %>/sprint7post" method="POST">
            <div class="form-group">
                <label for="exemple">Entrez une valeur :</label>
                <input type="text" id="exemple" name="exemple" 
                       placeholder="Tapez quelque chose..." 
                       value="Bonjour Sprint 7!" required>
            </div>
            
            <button type="submit">Envoyer (POST)</button>
        </form>
        
        <p style="margin-top: 30px;">
            <a href="<%= request.getContextPath() %>/sprint7get" 
               style="color: #2196F3; text-decoration: none;">
               → Tester la méthode GET
            </a>
        </p>
    </div>
</body>
</html>
