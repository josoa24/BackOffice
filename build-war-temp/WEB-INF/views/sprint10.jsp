<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sprint 10 - Upload de Fichiers</title>
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
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 2px dashed #4CAF50;
            border-radius: 4px;
            background-color: #f9f9f9;
            cursor: pointer;
        }
        input[type="file"]:hover {
            background-color: #e8f5e9;
        }
        textarea {
            resize: vertical;
            min-height: 100px;
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
        .file-info {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 10px;
            margin-top: 20px;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content-wrapper">
        <div class="form-container">
            <h2>Sprint 10 - Upload de Fichiers</h2>
            <p class="subtitle">Testez l'upload de fichiers avec le framework</p>
            
            <div class="note">
                <strong>Note:</strong> Le framework utilise l'annotation <code>@FileUpload</code> pour extraire automatiquement les fichiers uploadés et les mapper vers des objets <code>FileUploadData</code>.
            </div>

            <form action="sprint10upload" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="fichier">📁 Sélectionner un fichier:</label>
                    <input type="file" id="fichier" name="fichier" required>
                </div>
                
                <div class="form-group">
                    <label for="description">📝 Description:</label>
                    <textarea id="description" name="description" placeholder="Entrez une description du fichier..." required></textarea>
                </div>
                
                <button type="submit">📤 Uploader le Fichier</button>
            </form>

            <div class="file-info">
                <strong>ℹ️ Informations:</strong>
                <ul style="margin: 5px 0 0 20px;">
                    <li>Taille maximale par fichier: 10 MB</li>
                    <li>Taille maximale de la requête: 50 MB</li>
                    <li>Tous types de fichiers acceptés</li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>
