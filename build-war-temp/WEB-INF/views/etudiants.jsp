<%@ page import="java.util.List" %>
<%@ page import="entity.Etudiant" %>
<%
    List<Etudiant> listeEtudiant = (List<Etudiant>) request.getAttribute("etudiants");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste Etudiants</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            margin-top: 40px;
            max-width: 700px;
        }
        h1 {
            color: #0d6efd;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .table thead th {
            background-color: #0d6efd;
            color: #fff;
            vertical-align: middle;
        }
        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: #f2f6fc;
        }
        .table td, .table th {
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="container shadow rounded bg-white p-4">
        <h1 class="text-center">Liste des Étudiants</h1>
        <table class="table table-striped table-hover align-middle">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Nom</th>
                    <th scope="col">Prénom</th>
                </tr>
            </thead>
            <tbody>
                <% for(Etudiant etudiant : listeEtudiant) { %>
                    <tr>
                        <td><%= etudiant.getId() %></td>
                        <td><%= etudiant.getNom() %></td>
                        <td><%= etudiant.getPrenom() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <!-- Bootstrap JS (optional, for interactivity) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>