<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Résultats Sprint 8</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 700px;
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
        .success-badge {
            background-color: #4CAF50;
            color: white;
            padding: 12px 15px;
            border-radius: 5px;
            text-align: center;
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
        .info-box code {
            background: white;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: monospace;
            color: #d32f2f;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .data-table tr {
            border-bottom: 1px solid #ddd;
        }
        .data-table td {
            padding: 10px;
        }
        .data-table td:first-child {
            font-weight: bold;
            color: #2e7d32;
            width: 30%;
        }
        .btn-back {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
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
    <div class="container">
        <h1>Données Reçues - Sprint 8</h1>
        
        <div class="success-badge">
            Les données ont été traitées avec succès via Map&lt;String, Object&gt;
        </div>
        
        <div class="info-box">
            <p><strong>Type de paramètre reçu :</strong> <code>Map&lt;String, Object&gt; requestData</code></p>
            <p><strong>Nombre de champs :</strong> <%= ((Map<?, ?>) request.getAttribute("requestData")).size() %></p>
        </div>
        
        <table class="data-table">
            <% 
                Map<String, Object> requestData = (Map<String, Object>) request.getAttribute("requestData");
                if (requestData != null) {
                    for (Map.Entry<String, Object> entry : requestData.entrySet()) {
            %>
                <tr>
                    <td><%= entry.getKey() %></td>
                    <td><%= entry.getValue() %></td>
                </tr>
            <% 
                    }
                }
            %>
        </table>
        
        <div class="btn-container">
            <a href="<%= request.getContextPath() %>/sprint8form" class="btn-back">Retour au formulaire</a>
        </div>
    </div>
</body>
</html>
