<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
%>
<style>
    /* ===== SIDEBAR ===== */
    .sidebar {
        position: fixed;
        left: 0;
        top: 0;
        bottom: 0;
        width: 270px;
        background: linear-gradient(180deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
        z-index: 1000;
        overflow-y: auto;
        overflow-x: hidden;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 4px 0 24px rgba(0,0,0,0.15);
    }

    .sidebar::-webkit-scrollbar { width: 4px; }
    .sidebar::-webkit-scrollbar-track { background: transparent; }
    .sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

    .sidebar-header {
        padding: 28px 22px 24px;
        border-bottom: 1px solid rgba(255,255,255,0.06);
        display: flex;
        align-items: center;
        gap: 14px;
    }

    .sidebar-logo {
        width: 44px;
        height: 44px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        color: white;
        flex-shrink: 0;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .sidebar-brand {
        display: flex;
        flex-direction: column;
    }

    .sidebar-brand h2 {
        color: #fff;
        font-size: 19px;
        font-weight: 800;
        letter-spacing: 0.3px;
        line-height: 1.2;
    }

    .sidebar-brand span {
        color: rgba(255,255,255,0.4);
        font-size: 11px;
        font-weight: 500;
        margin-top: 3px;
        letter-spacing: 0.5px;
    }

    .sidebar-nav {
        padding: 20px 14px;
    }

    .nav-section {
        margin-bottom: 8px;
    }

    .nav-section-label {
        color: rgba(255,255,255,0.25);
        font-size: 10px;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 2px;
        padding: 18px 14px 10px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .nav-section-label::after {
        content: '';
        flex: 1;
        height: 1px;
        background: rgba(255,255,255,0.06);
    }

    .nav-link {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 12px 16px;
        color: rgba(255,255,255,0.55);
        text-decoration: none;
        border-radius: 10px;
        font-size: 13.5px;
        font-weight: 500;
        transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        margin-bottom: 3px;
        position: relative;
        overflow: hidden;
    }

    .nav-link::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 0;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border-radius: 10px;
        transition: width 0.3s ease;
        z-index: -1;
    }

    .nav-link:hover {
        color: rgba(255,255,255,0.95);
        transform: translateX(4px);
    }

    .nav-link:hover::before {
        width: 100%;
        opacity: 0.15;
    }

    .nav-link.active {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: #fff;
        box-shadow: 0 4px 18px rgba(102, 126, 234, 0.35);
        font-weight: 600;
    }

    .nav-link.active::before {
        display: none;
    }

    .nav-link .nav-icon {
        width: 22px;
        height: 22px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 15px;
        flex-shrink: 0;
    }

    .nav-link .nav-text {
        flex: 1;
    }

    .nav-link .nav-badge {
        background: rgba(255,255,255,0.15);
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 10px;
        font-weight: 700;
        color: rgba(255,255,255,0.8);
    }

    .nav-link.active .nav-badge {
        background: rgba(255,255,255,0.25);
        color: #fff;
    }

    /* Sidebar footer */
    .sidebar-footer {
        padding: 16px 22px 24px;
        border-top: 1px solid rgba(255,255,255,0.06);
        margin-top: auto;
    }

    .sidebar-footer-info {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 14px;
        border-radius: 10px;
        background: rgba(255,255,255,0.04);
    }

    .sidebar-avatar {
        width: 36px;
        height: 36px;
        border-radius: 10px;
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        font-weight: 700;
        color: white;
        flex-shrink: 0;
    }

    .sidebar-user-info {
        flex: 1;
        min-width: 0;
    }

    .sidebar-user-name {
        color: rgba(255,255,255,0.85);
        font-size: 12.5px;
        font-weight: 600;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .sidebar-user-role {
        color: rgba(255,255,255,0.35);
        font-size: 10.5px;
        font-weight: 500;
    }

    /* Mobile toggle */
    .sidebar-toggle {
        display: none;
        position: fixed;
        top: 14px;
        left: 14px;
        z-index: 1100;
        width: 42px;
        height: 42px;
        border-radius: 10px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border: none;
        color: white;
        font-size: 18px;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        align-items: center;
        justify-content: center;
    }

    .sidebar-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.5);
        z-index: 999;
        backdrop-filter: blur(4px);
    }

    /* Main content offset */
    .page-wrapper {
        margin-left: 270px;
        min-height: 100vh;
        transition: margin-left 0.3s ease;
    }

    @media (max-width: 1024px) {
        .sidebar {
            transform: translateX(-100%);
        }
        .sidebar.open {
            transform: translateX(0);
        }
        .sidebar-toggle {
            display: flex;
        }
        .sidebar-overlay.show {
            display: block;
        }
        .page-wrapper {
            margin-left: 0;
        }
    }
</style>

<!-- Sidebar Toggle (Mobile) -->
<button class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">
    <i class="fas fa-bars"></i>
</button>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <i class="fas fa-plane-departure"></i>
        </div>
        <div class="sidebar-brand">
            <h2>BackOffice</h2>
            <span>Gestion Hôtelière</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-section-label">Menu principal</div>
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                <span class="nav-icon"><i class="fas fa-th-large"></i></span>
                <span class="nav-text">Tableau de Bord</span>
            </a>
            <a href="${pageContext.request.contextPath}/reservation-form" class="nav-link <%= "reservation".equals(currentPage) ? "active" : "" %>">
                <span class="nav-icon"><i class="fas fa-calendar-check"></i></span>
                <span class="nav-text">Réservations</span>
                <span class="nav-badge">Nouveau</span>
            </a>
            <a href="${pageContext.request.contextPath}/assignation-form" class="nav-link <%= "assignation".equals(currentPage) ? "active" : "" %>">
                <span class="nav-icon"><i class="fas fa-route"></i></span>
                <span class="nav-text">Assignation Véhicules</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-label">Données</div>
            <a href="${pageContext.request.contextPath}/api/reservations?token=" class="nav-link" target="_blank">
                <span class="nav-icon"><i class="fas fa-database"></i></span>
                <span class="nav-text">API Réservations</span>
                <span class="nav-badge">API</span>
            </a>
            <a href="${pageContext.request.contextPath}/api/dashboard" class="nav-link" target="_blank">
                <span class="nav-icon"><i class="fas fa-chart-bar"></i></span>
                <span class="nav-text">API Dashboard</span>
                <span class="nav-badge">JSON</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-section-label">Système</div>
            <a href="${pageContext.request.contextPath}/api/token/generate?idClient=1001" class="nav-link" target="_blank">
                <span class="nav-icon"><i class="fas fa-key"></i></span>
                <span class="nav-text">Générer Token</span>
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <div class="sidebar-footer-info">
            <div class="sidebar-avatar">AD</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">Administrateur</div>
                <div class="sidebar-user-role">Gestionnaire Hôtelier</div>
            </div>
        </div>
    </div>
</aside>

<script>
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('open');
        document.getElementById('sidebarOverlay').classList.toggle('show');
    }
</script>
