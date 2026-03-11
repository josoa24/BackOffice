<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignation de Véhicules - BackOffice</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f4f6fb;
            color: #1e1e2d;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        .top-header {
            background: rgba(255,255,255,0.95);
            padding: 18px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #eef0f6;
            position: sticky;
            top: 0;
            z-index: 50;
            backdrop-filter: blur(12px);
        }
        .header-left { display: flex; flex-direction: column; }
        .header-left h1 { font-size: 24px; font-weight: 800; color: #1e1e2d; display: flex; align-items: center; gap: 10px; }
        .header-left h1 .header-icon { width: 36px; height: 36px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; }
        .header-left .header-subtitle { font-size: 13px; color: #9ba4b5; margin-top: 3px; font-weight: 400; }

        .content { padding: 28px 36px 40px; }

        .form-banner {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #fbbf24 100%);
            border-radius: 18px;
            padding: 32px 36px;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
            color: white;
        }
        .form-banner::before { content: ''; position: absolute; right: -50px; top: -50px; width: 250px; height: 250px; background: rgba(255,255,255,0.08); border-radius: 50%; }
        .form-banner::after { content: ''; position: absolute; right: 60px; bottom: -80px; width: 200px; height: 200px; background: rgba(255,255,255,0.05); border-radius: 50%; }
        .form-banner .banner-content { position: relative; z-index: 2; }
        .form-banner h2 { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
        .form-banner p { font-size: 14px; opacity: 0.9; font-weight: 400; line-height: 1.5; }

        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }

        .card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #eef0f6;
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }
        .card:hover { box-shadow: 0 8px 24px rgba(0,0,0,0.05); }
        .card-header {
            padding: 22px 26px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-title { font-size: 16px; font-weight: 700; color: #1e1e2d; display: flex; align-items: center; gap: 10px; }
        .title-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
        .title-dot.amber { background: #f59e0b; }
        .title-dot.blue { background: #667eea; }
        .card-body { padding: 24px 26px 30px; }

        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #4a5068;
            font-weight: 600;
            font-size: 13px;
            letter-spacing: 0.3px;
        }
        .form-group label i { margin-right: 6px; color: #f59e0b; font-size: 13px; }
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #eef0f6;
            border-radius: 12px;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            color: #1e1e2d;
            background: #f8f9fd;
            transition: all 0.25s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: #f59e0b;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.1);
        }

        .btn-submit {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 14px 28px;
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.45);
        }

        .rules-list { list-style: none; padding: 0; }
        .rules-list li {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid #f4f6fb;
            font-size: 13.5px;
            color: #4a5068;
            line-height: 1.5;
        }
        .rules-list li:last-child { border-bottom: none; }
        .rule-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }
        .rule-icon.green { background: linear-gradient(135deg, #d1fae5, #a7f3d0); color: #059669; }
        .rule-icon.blue { background: linear-gradient(135deg, #dbeafe, #bfdbfe); color: #2563eb; }
        .rule-icon.amber { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; }

        .steps-indicator {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding: 16px 20px;
            background: linear-gradient(135deg, #f8f9fd, #eef2ff);
            border-radius: 12px;
            border: 1px solid #e8eaf4;
        }
        .step {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12.5px;
            font-weight: 600;
            color: #9ba4b5;
        }
        .step.active { color: #f59e0b; }
        .step-num {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 800;
            background: #eef0f6;
            color: #9ba4b5;
        }
        .step.active .step-num { background: linear-gradient(135deg, #f59e0b, #d97706); color: white; }
        .step-divider { flex: 1; height: 2px; background: #eef0f6; border-radius: 1px; }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .anim { opacity: 0; animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .anim:nth-child(1) { animation-delay: 0.04s; }
        .anim:nth-child(2) { animation-delay: 0.08s; }
        .anim:nth-child(3) { animation-delay: 0.12s; }

        @media (max-width: 1024px) {
            .two-col { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .content { padding: 20px 16px; }
            .top-header { padding: 14px 16px; }
        }
    </style>
</head>
<body>
<%
    request.setAttribute("currentPage", "assignation");
%>
<jsp:include page="sidebar.jsp" />

<div class="page-wrapper">
    <div class="top-header">
        <div class="header-left">
            <h1>
                <span class="header-icon"><i class="fas fa-route"></i></span>
                Assignation de Véhicules
            </h1>
            <span class="header-subtitle">Assignez automatiquement les véhicules aux réservations</span>
        </div>
    </div>

    <div class="content">
        <div class="form-banner anim">
            <div class="banner-content">
                <h2><i class="fas fa-shuttle-van"></i> Assignation Automatique</h2>
                <p>Sélectionnez une date pour lancer l'algorithme d'assignation optimale des véhicules aux réservations.</p>
            </div>
        </div>

        <div class="steps-indicator anim">
            <div class="step active">
                <span class="step-num">1</span>
                Choisir la date
            </div>
            <div class="step-divider"></div>
            <div class="step">
                <span class="step-num">2</span>
                Lancer l'assignation
            </div>
            <div class="step-divider"></div>
            <div class="step">
                <span class="step-num">3</span>
                Voir les résultats
            </div>
        </div>

        <div class="two-col">
            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot amber"></span>
                        Formulaire d'Assignation
                    </div>
                </div>
                <div class="card-body">
                    <form action="assignation-process" method="post">
                        <div class="form-group">
                            <label for="date"><i class="fas fa-calendar-alt"></i> Date des réservations</label>
                            <input type="date" id="date" name="date" required>
                        </div>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-cogs"></i> Lancer l'assignation automatique
                        </button>
                    </form>
                </div>
            </div>

            <div class="card anim">
                <div class="card-header">
                    <div class="card-title">
                        <span class="title-dot blue"></span>
                        Règles d'Assignation
                    </div>
                </div>
                <div class="card-body">
                    <ul class="rules-list">
                        <li>
                            <div class="rule-icon green"><i class="fas fa-check"></i></div>
                            <div>
                                <strong>Capacité suffisante</strong><br>
                                Le véhicule doit avoir une capacité ≥ nombre de passagers de la réservation
                            </div>
                        </li>
                        <li>
                            <div class="rule-icon blue"><i class="fas fa-arrows-alt-h"></i></div>
                            <div>
                                <strong>Capacité la plus proche</strong><br>
                                Si plusieurs véhicules sont disponibles, celui avec la capacité la plus proche est choisi
                            </div>
                        </li>
                        <li>
                            <div class="rule-icon amber"><i class="fas fa-gas-pump"></i></div>
                            <div>
                                <strong>Priorité diesel</strong><br>
                                En cas d'égalité de capacité, le véhicule diesel est prioritaire
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
