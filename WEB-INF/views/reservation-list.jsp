<%@ page import="java.util.List" %>
<%@ page import="entity.Reservation" %>
<%@ page import="entity.Hotel" %>
<%
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Réservations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; margin: 0; padding: 0; }
        .container { margin-top: 40px; max-width: 900px; }
        h1 { color: #0d6efd; margin-bottom: 30px; font-weight: 600; }
        .table thead th { background-color: #0d6efd; color: #fff; vertical-align: middle; }
        .table-striped > tbody > tr:nth-of-type(odd) { background-color: #f2f6fc; }
        .table td, .table th { vertical-align: middle; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <jsp:include page="sidebar.jsp" />
    <div class="page-wrapper">
        <div class="container shadow rounded bg-white p-4">
            <h1 class="text-center mb-4">Liste des Réservations</h1>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <input type="text" class="form-control form-control-sm" id="searchInput" placeholder="Rechercher par client, hôtel ou date..." style="width: 260px; display: inline-block;">
                </div>
                <div>
                    <a href="reservation-form" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Nouvelle réservation</a>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle" id="reservationTable">
                    <thead class="table-primary">
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Client</th>
                            <th scope="col">Nb Passagers</th>
                            <th scope="col">Date/Heure</th>
                            <th scope="col">Hôtel</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Reservation r : reservations) { %>
                            <tr>
                                <td><%= r.getIdReservation() %></td>
                                <td><%= r.getIdClient() %></td>
                                <td><%= r.getNbPassager() %></td>
                                <td><%= r.getDateHeure() %></td>
                                <td>
                                    <% 
                                        String hotelName = "";
                                        if (hotels != null) {
                                            for (Hotel h : hotels) {
                                                if (h.getIdHotel() == r.getIdHotel()) {
                                                    hotelName = h.getNom();
                                                    break;
                                                }
                                            }
                                        }
                                    %>
                                    <%= hotelName %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/7c2e8e2c2a.js" crossorigin="anonymous"></script>
    <script>
        // Filtrage dynamique du tableau
        document.getElementById('searchInput').addEventListener('keyup', function() {
            var value = this.value.toLowerCase();
            var rows = document.querySelectorAll('#reservationTable tbody tr');
            rows.forEach(function(row) {
                var text = row.textContent.toLowerCase();
                row.style.display = text.indexOf(value) > -1 ? '' : 'none';
            });
        });
    </script>
</body>
</html>
