<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="main.framework.FileUploadData" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sprint 10 - Résultat Upload</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 700px;
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
            word-break: break-all;
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
        .file-icon {
            font-size: 48px;
            text-align: center;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="result-container">
            <h2>Sprint 10 - Résultat de l'Upload</h2>
            <p class="subtitle">Informations sur le fichier uploadé</p>

            <%
                FileUploadData file = (FileUploadData) request.getAttribute("file");
                String description = (String) request.getAttribute("description");
                
                if (file != null) {
            %>
                <div class="success-message">
                    <strong>✓ Succès!</strong> Le fichier a été uploadé avec succès.
                </div>

                <div class="file-icon">
                    📄
                </div>

                <div class="info-section">
                    <div class="section-title">Informations du Fichier</div>
                    <div class="info-row">
                        <span class="info-label">Nom du fichier:</span>
                        <span class="info-value"><%= file.getFileName() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Type MIME:</span>
                        <span class="info-value"><%= file.getContentType() != null ? file.getContentType() : "Non défini" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Extension:</span>
                        <span class="info-value"><%= file.getExtension() != null && !file.getExtension().isEmpty() ? file.getExtension() : "Aucune" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Taille:</span>
                        <span class="info-value"><%= String.format("%.2f KB (%d bytes)", file.getSize() / 1024.0, file.getSize()) %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Description:</span>
                        <span class="info-value"><%= description != null ? description : "Aucune description" %></span>
                    </div>
                </div>

                <div class="info-section">
                    <div class="section-title">Détails Techniques</div>
                    <div class="info-row">
                        <span class="info-label">Classe Java:</span>
                        <span class="info-value"><code>FileUploadData</code></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Annotation utilisée:</span>
                        <span class="info-value"><code>@FileUpload(name = "fichier")</code></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Données en mémoire:</span>
                        <span class="info-value"><%= file.getBytes() != null ? "Oui (" + file.getBytes().length + " bytes)" : "Non" %></span>
                    </div>
                </div>
            <%
                } else {
            %>
                <div class="error-message">
                    <strong>✗ Erreur!</strong> Aucun fichier n'a été uploadé ou une erreur s'est produite.
                </div>
            <%
                }
            %>

            <a href="sprint10form" class="back-link">← Uploader un autre fichier</a>
        </div>
    </div>
</body>
</html>
