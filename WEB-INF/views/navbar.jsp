<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .navbar {
        background-color: #1a1a2e;
        padding: 0 30px;
        margin: -8px -8px 20px -8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        gap: 0;
        height: 56px;
    }
    .navbar-brand {
        color: #ecf0f1;
        font-size: 18px;
        font-weight: bold;
        text-decoration: none;
        letter-spacing: 1px;
        margin-right: 32px;
    }
    .navbar-brand:hover {
        color: #e94560;
    }
    .navbar-link {
        color: rgba(255,255,255,0.65);
        text-decoration: none;
        padding: 16px 16px;
        font-size: 13.5px;
        font-weight: 500;
        transition: all 0.2s;
        border-bottom: 2px solid transparent;
    }
    .navbar-link:hover {
        color: #fff;
        border-bottom-color: #e94560;
    }
</style>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">BackOffice</a>
    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-link">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/reservation-form" class="navbar-link">📅 Réservation</a>
    <a href="${pageContext.request.contextPath}/assignation-form" class="navbar-link">🚗 Assignation</a>
</nav>
