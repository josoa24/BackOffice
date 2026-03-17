<%@ page import="java.util.List,java.util.Map,entity.Reservation,entity.Vehicule,entity.Assignation,java.time.format.DateTimeFormatter" %>
<%
    String date = (String) request.getAttribute("date");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String info = (String) request.getAttribute("info");
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    List<Map<String, Object>> vehiculesInfo = (List<Map<String, Object>>) request.getAttribute("vehiculesInfo");
    List<Map<String, Object>> trajets = (List<Map<String, Object>>) request.getAttribute("trajets");
    List<Assignation> assignations = (List<Assignation>) request.getAttribute("assignations");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("currentPage", "assignation");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planification Vehicules - Sprint 5-6</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f4f6fb; font-family: 'Segoe UI', sans-serif; }
        .page-wrapper { margin-left: 270px; min-height: 100vh; }
        .content { padding: 28px 36px; }
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 28px 32px; border-radius: 16px; margin-bottom: 28px;
            box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);
        }
        .header-section h1 { margin: 0; font-weight: 800; font-size: 24px; display: flex; align-items: center; gap: 12px; }
        .header-section p { margin: 6px 0 0; opacity: 0.85; font-size: 14px; }

        .card { border: none; border-radius: 16px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 24px; overflow: hidden; }
        .card-header { background: #fff; border-bottom: 2px solid #f0f2f8; padding: 18px 24px; font-weight: 700; font-size: 15px; display: flex; align-items: center; justify-content: space-between; }
        .card-body { padding: 20px 24px; }

        .table { font-size: 13px; margin-bottom: 0; }
        .table thead th { background: #f8f9fd; font-size: 11px; text-transform: uppercase; letter-spacing: 0.8px; color: #7c8498; font-weight: 700; border-bottom: 2px solid #eef0f6; padding: 12px 14px; }
        .table tbody td { padding: 12px 14px; vertical-align: middle; border-bottom: 1px solid #f4f6fb; }
        .table tbody tr:hover { background: #f8f9fd; }

        .badge-hotel { background: #e8f4fd; color: #0066cc; padding: 5px 10px; border-radius: 8px; font-weight: 600; font-size: 11px; }
        .badge-passagers { background: #fff3e0; color: #e65100; padding: 5px 10px; border-radius: 8px; font-weight: 700; font-size: 12px; }
        .badge-diesel { background: #eef2ff; color: #4f46e5; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600; }
        .badge-essence { background: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600; }
        .badge-places { background: #d1fae5; color: #065f46; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600; }
        .badge-id { background: #f0f4ff; color: #667eea; font-weight: 700; font-size: 12px; padding: 4px 10px; border-radius: 6px; }

        .btn-planifier {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white; border: none; padding: 12px 28px; border-radius: 12px;
            font-weight: 700; font-size: 14px; transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.35);
        }
        .btn-planifier:hover { color: white; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(16, 185, 129, 0.5); }

        .btn-assign {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; padding: 6px 14px; border-radius: 8px;
            font-size: 12px; font-weight: 600; transition: all 0.2s;
        }
        .btn-assign:hover { color: white; transform: translateY(-1px); }

        .stat-card { text-align: center; padding: 20px; border-radius: 12px; }
        .stat-card .stat-value { font-size: 28px; font-weight: 900; line-height: 1; }
        .stat-card .stat-label { font-size: 12px; color: #7c8498; margin-top: 6px; font-weight: 500; }

        .trajet-card { background: #fff; border: 1px solid #eef0f6; border-radius: 12px; padding: 18px; margin-bottom: 16px; transition: all 0.2s; }
        .trajet-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .trajet-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; }
        .trajet-vehicule { font-weight: 700; font-size: 15px; color: #1e1e2d; }
        .trajet-detail { display: flex; gap: 20px; font-size: 13px; color: #5a6178; }
        .trajet-detail span { display: flex; align-items: center; gap: 6px; }

        .alert { border-radius: 12px; font-size: 14px; padding: 14px 20px; border: none; }
        .alert-success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
        .alert-danger { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-info { background: #eff6ff; color: #1e40af; border: 1px solid #bfdbfe; }

        .time-display { font-weight: 600; color: #1e1e2d; }
        .time-display i { margin-right: 4px; font-size: 11px; }

        .section-title { font-size: 13px; font-weight: 700; color: #667eea; margin-bottom: 4px; display: flex; align-items: center; gap: 8px; }
        .progress-bar-capacity { height: 8px; border-radius: 4px; }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp" />
    <div class="page-wrapper">
        <div class="content">
            <!-- Header -->
            <div class="header-section">
                <h1><i class="fas fa-route"></i> Planification des Vehicules</h1>
                <p>Sprint 5-6 : Regroupement par temps d'attente + priorite par nombre de trajets</p>
            </div>

            <!-- Etape 1 : Selection de la date -->
            <div class="card">
                <div class="card-header">
                    <span><i class="fas fa-calendar-alt me-2" style="color:#667eea"></i> Etape 1 : Selectionner une date</span>
                </div>
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/assignation-form" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label for="dateInput" class="form-label fw-bold">Date de planification :</label>
                            <input type="date" id="dateInput" name="date" class="form-control form-control-lg" value="<%= date != null && !date.isEmpty() ? date : "" %>" required>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary btn-lg w-100">
                                <i class="fas fa-search me-2"></i> Charger
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Messages -->
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i> <%= message %></div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i> <%= error %></div>
            <% } %>
            <% if (info != null && !info.isEmpty()) { %>
                <div class="alert alert-info"><i class="fas fa-info-circle me-2"></i> <%= info %></div>
            <% } %>

            <% if (date != null && !date.isEmpty()) { %>

                <!-- Stats rapides -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card">
                            <div class="stat-card" style="background: linear-gradient(135deg, #eff6ff, #dbeafe);">
                                <div class="stat-value" style="color: #2563eb;"><%= reservations != null ? reservations.size() : 0 %></div>
                                <div class="stat-label">A assigner</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="stat-card" style="background: linear-gradient(135deg, #ecfdf5, #d1fae5);">
                                <div class="stat-value" style="color: #059669;"><%= assignations != null ? assignations.size() : 0 %></div>
                                <div class="stat-label">Deja assignees</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="stat-card" style="background: linear-gradient(135deg, #fef3c7, #fde68a);">
                                <div class="stat-value" style="color: #d97706;"><%= trajets != null ? trajets.size() : 0 %></div>
                                <div class="stat-label">Trajets planifies</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="stat-card" style="background: linear-gradient(135deg, #fce7f3, #fbcfe8);">
                                <div class="stat-value" style="color: #be185d;"><%= vehiculesInfo != null ? vehiculesInfo.size() : 0 %></div>
                                <div class="stat-label">Vehicules disponibles</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Etape 2 : Reservations non assignees -->
                <% if (reservations != null && !reservations.isEmpty()) { %>
                <div class="card">
                    <div class="card-header">
                        <span><i class="fas fa-list me-2" style="color:#e65100"></i> Etape 2 : Reservations a assigner</span>
                        <span class="badge-passagers"><%= reservations.size() %> reservation(s)</span>
                    </div>
                    <div class="card-body">
                        <!-- Bouton Planification Automatique -->
                        <div class="mb-4 p-3" style="background: linear-gradient(135deg, #f0fdf4, #dcfce7); border-radius: 12px; border: 1px solid #86efac;">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="mb-1 fw-bold" style="color: #166534;"><i class="fas fa-magic me-2"></i> Planification Automatique</h6>
                                    <small style="color: #15803d;">
                                        Applique les regles Sprint 5-6 : fenetre de temps d'attente, disponibilite vehicule, compteur de trajets, priorite diesel en cas d'egalite
                                    </small>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/assignation-planifier">
                                    <input type="hidden" name="date" value="<%= date %>">
                                    <button type="submit" class="btn-planifier" onclick="return confirm('Lancer la planification automatique pour le <%= date %> ?')">
                                        <i class="fas fa-bolt me-2"></i> Planifier automatiquement
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Tableau des reservations -->
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Client</th>
                                        <th>Passagers</th>
                                        <th>Date/Heure</th>
                                        <th>Hotel (Destination)</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Reservation r : reservations) { %>
                                        <tr>
                                            <td><span class="badge-id">#<%= r.getIdReservation() %></span></td>
                                            <td><strong><%= r.getIdClient() %></strong></td>
                                            <td><span class="badge-passagers"><%= r.getNbPassager() %> <i class="fas fa-users" style="font-size:10px"></i></span></td>
                                            <td><%= r.getDateHeure().format(dateTimeFormatter) %></td>
                                            <td>
                                                <span class="badge-hotel">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    <%= r.getHotel() != null ? r.getHotel().getNom() : "Hotel #" + r.getIdHotel() %>
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn-assign" data-bs-toggle="modal" data-bs-target="#assignModal"
                                                    data-id="<%= r.getIdReservation() %>"
                                                    data-hotel="<%= r.getHotel() != null ? r.getHotel().getNom() : r.getIdHotel() %>"
                                                    data-passagers="<%= r.getNbPassager() %>">
                                                    <i class="fas fa-car me-1"></i> Assigner
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Etape 3 : Trajets planifies (Sprint 6) -->
                <% if (trajets != null && !trajets.isEmpty()) { %>
                <div class="card">
                    <div class="card-header">
                        <span><i class="fas fa-route me-2" style="color:#059669"></i> Trajets Planifies (Sprint 6)</span>
                        <span class="badge-places"><%= trajets.size() %> trajet(s)</span>
                    </div>
                    <div class="card-body">
                        <% for (Map<String, Object> t : trajets) {
                            int capacite = (int) t.get("capacite");
                            int totalP = (int) t.get("totalPassagers");
                            int placesRestantes = (int) t.get("placesRestantes");
                            int pourcentage = (capacite > 0) ? (totalP * 100 / capacite) : 0;
                            String barColor = pourcentage > 80 ? "#dc3545" : pourcentage > 50 ? "#ffc107" : "#28a745";
                        %>
                        <div class="trajet-card">
                            <div class="trajet-header">
                                <div>
                                    <span class="trajet-vehicule"><i class="fas fa-bus me-2" style="color:#667eea"></i> <%= t.get("vehicule") %></span>
                                    <span style="color:#9ba4b5; font-size:12px; margin-left:8px;"><%= t.get("immatriculation") %></span>
                                </div>
                                <span class="badge-<%= "diesel".equals(t.get("carburant")) ? "diesel" : "essence" %>">
                                    <i class="fas fa-gas-pump"></i> <%= t.get("carburant") %>
                                </span>
                            </div>
                            <div class="trajet-detail">
                                <span><i class="fas fa-clock" style="color:#059669"></i> Depart aeroport: <strong><%= ((java.time.LocalDateTime)t.get("heureDepart")).format(timeFormatter) %></strong></span>
                                <span><i class="fas fa-plane-arrival" style="color:#d97706"></i> Retour aeroport: <strong><%= ((java.time.LocalDateTime)t.get("heureRetourAeroport")).format(timeFormatter) %></strong></span>
                                <span><i class="fas fa-ticket-alt" style="color:#667eea"></i> <%= t.get("nbReservations") %> reservation(s)</span>
                                <span><i class="fas fa-users" style="color:#e65100"></i> <%= totalP %>/<%= capacite %> passagers</span>
                                <span><i class="fas fa-chair" style="color:#059669"></i> <%= placesRestantes %> places restantes</span>
                                <span><i class="fas fa-road" style="color:#7c3aed"></i> <%= String.format("%.1f", (Double)t.get("kilometrageParcouru")) %> km</span>
                                <span><i class="fas fa-repeat" style="color:#2563eb"></i> Trajet #<%= t.get("nbTrajetsVehicule") %></span>
                            </div>
                            <div class="mt-2">
                                <div class="progress" style="height:8px; border-radius:4px;">
                                    <div class="progress-bar" style="width:<%= pourcentage %>%; background:<%= barColor %>; border-radius:4px;"></div>
                                </div>
                                <small style="color:#9ba4b5; font-size:11px;">Remplissage : <%= pourcentage %>%</small>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>

                <!-- Detail des assignations existantes -->
                <% if (assignations != null && !assignations.isEmpty()) { %>
                <div class="card">
                    <div class="card-header">
                        <span><i class="fas fa-clipboard-check me-2" style="color:#764ba2"></i> Detail des Assignations</span>
                        <span class="badge-id"><%= assignations.size() %> assignation(s)</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Client</th>
                                        <th>Passagers</th>
                                        <th>Lieu (Hotel)</th>
                                        <th>Vehicule</th>
                                        <th>Carburant</th>
                                        <th>Heure Depart</th>
                                        <th>Heure Arrivee</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Assignation a : assignations) { %>
                                    <tr>
                                        <td><span class="badge-id">#<%= a.getIdAssignation() %></span></td>
                                        <td><strong><%= a.getReservation().getIdClient() %></strong></td>
                                        <td><span class="badge-passagers"><%= a.getReservation().getNbPassager() %></span></td>
                                        <td>
                                            <span class="badge-hotel">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <%= a.getReservation().getHotel() != null ? a.getReservation().getHotel().getNom() : a.getReservation().getIdHotel() %>
                                            </span>
                                        </td>
                                        <td>
                                            <strong><%= a.getVehicule().getMarque() %> <%= a.getVehicule().getModele() %></strong>
                                            <br><small style="color:#9ba4b5"><%= a.getVehicule().getImmatriculation() %> - <%= a.getVehicule().getCapacite() %> places</small>
                                        </td>
                                        <td>
                                            <span class="badge-<%= "diesel".equals(a.getVehicule().getCarburant()) ? "diesel" : "essence" %>">
                                                <i class="fas fa-gas-pump"></i> <%= a.getVehicule().getCarburant() %>
                                            </span>
                                        </td>
                                        <td><span class="time-display"><i class="fas fa-clock" style="color:#059669"></i> <%= a.getHeureDepart().format(timeFormatter) %></span></td>
                                        <td><span class="time-display"><i class="fas fa-flag-checkered" style="color:#d97706"></i> <%= a.getHeureArrivee().format(timeFormatter) %></span></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } %>

            <% } else { %>
                <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="fas fa-calendar-alt" style="font-size: 48px; color: #d1d5db; margin-bottom: 16px;"></i>
                        <p style="color:#7c8498; font-size: 15px;">Veuillez selectionner une date pour voir les reservations et planifier les trajets.</p>
                    </div>
                </div>
            <% } %>

        </div>
    </div>

    <!-- Modal: Assignation Manuelle -->
    <div class="modal fade" id="assignModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content" style="border-radius: 16px; border: none;">
                <div class="modal-header" style="border-bottom: 2px solid #f0f2f8;">
                    <h5 class="modal-title fw-bold"><i class="fas fa-car me-2" style="color:#667eea"></i> Assignation Manuelle</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/assignation-save">
                    <div class="modal-body">
                        <input type="hidden" name="idReservation" id="modalIdReservation">
                        <input type="hidden" name="date" value="<%= date %>">

                        <div class="mb-3 p-3" style="background: #f8f9fd; border-radius: 10px;">
                            <label class="form-label fw-bold" style="font-size:12px; color:#7c8498;">RESERVATION</label>
                            <div id="modalReservationInfo" style="font-weight:700; font-size:15px; color:#1e1e2d;"></div>
                        </div>

                        <div class="mb-3">
                            <label for="vehiculeSelect" class="form-label fw-bold">Vehicule :</label>
                            <select id="vehiculeSelect" name="idVehicule" class="form-select" required>
                                <option value="">-- Choisir un vehicule --</option>
                                <% if (vehiculesInfo != null) {
                                    for (Map<String, Object> vi : vehiculesInfo) {
                                        Vehicule v = (Vehicule) vi.get("vehicule");
                                        int placesRestantes = (int) vi.get("placesRestantes");
                                        if (placesRestantes > 0) {
                                %>
                                    <option value="<%= v.getIdVehicule() %>" data-places="<%= placesRestantes %>">
                                        <%= v.getMarque() %> <%= v.getModele() %> - <%= placesRestantes %> places restantes (<%= v.getCarburant() %>)
                                    </option>
                                <%      }
                                    }
                                } %>
                            </select>
                            <small class="text-danger" id="capaciteWarning" style="font-weight:600;"></small>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: 2px solid #f0f2f8;">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn-assign" style="padding: 10px 24px; font-size: 14px;">
                            <i class="fas fa-check me-2"></i> Assigner
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Gestion du modal d'assignation manuelle
        var assignModal = document.getElementById('assignModal');
        if (assignModal) {
            assignModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                var idReservation = button.getAttribute('data-id');
                var hotel = button.getAttribute('data-hotel');
                var passagers = button.getAttribute('data-passagers');

                document.getElementById('modalIdReservation').value = idReservation;
                document.getElementById('modalReservationInfo').innerHTML =
                    'Reservation #' + idReservation + ' <br><small style="color:#7c8498;font-weight:400">' +
                    passagers + ' passager(s) - ' + hotel + '</small>';

                // Validation capacite
                var vehiculeSelect = document.getElementById('vehiculeSelect');
                var capaciteWarning = document.getElementById('capaciteWarning');

                vehiculeSelect.onchange = function() {
                    var selectedOption = this.options[this.selectedIndex];
                    var places = selectedOption.getAttribute('data-places');
                    if (places && parseInt(places) < parseInt(passagers)) {
                        capaciteWarning.textContent = 'ATTENTION: Seulement ' + places + ' places restantes pour ' + passagers + ' passagers!';
                    } else {
                        capaciteWarning.textContent = '';
                    }
                };
            });
        }
    </script>
</body>
</html>
