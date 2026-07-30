<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Protect: must be logged in as student
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) userEmail = "Student";
    String initials = String.valueOf(userEmail.charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: linear-gradient(135deg, #07111f, #0d1b2a, #15253f); color: #f3f6ff; font-family: 'Inter', Arial, sans-serif; min-height: 100vh; }
        .sidebar { position: fixed; left: 0; top: 0; width: 260px; height: 100vh; background: rgba(7,17,31,0.95); backdrop-filter: blur(20px); border-right: 1px solid rgba(255,255,255,0.06); z-index: 100; padding: 1.5rem; display: flex; flex-direction: column; }
        .sidebar-logo { color: #fff; text-decoration: none; font-size: 1.3rem; font-weight: 700; display: flex; align-items: center; gap: 10px; margin-bottom: 2rem; }
        .sidebar-logo i { color: #4f7cff; font-size: 1.5rem; }
        .sidebar-logo span { background: linear-gradient(135deg, #4f7cff, #00d9ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .sidebar-menu { list-style: none; padding: 0; flex: 1; }
        .sidebar-menu li a { color: rgba(255,255,255,0.6); text-decoration: none; display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; font-weight: 500; font-size: 0.9rem; transition: all 0.3s; margin-bottom: 4px; }
        .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background: rgba(79,124,255,0.12); }
        .sidebar-menu li.active a { color: #4f7cff; }
        .sidebar-menu li a i { width: 20px; text-align: center; }
        .main { margin-left: 260px; padding: 2rem; }
        .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .avatar { width: 40px; height: 40px; border-radius: 12px; background: linear-gradient(135deg, #00d9ff, #00ff88); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1rem; color: #07111f; }
        .glass { background: rgba(255,255,255,0.06); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; }
        .kpi-card { padding: 1.5rem; display: flex; align-items: center; gap: 1rem; }
        .kpi-icon { width: 50px; height: 50px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; }
        .kpi-blue { background: rgba(79,124,255,0.15); color: #4f7cff; }
        .kpi-green { background: rgba(0,255,136,0.12); color: #00ff88; }
        .kpi-purple { background: rgba(122,92,255,0.15); color: #7a5cff; }
        .kpi-cyan { background: rgba(0,217,255,0.12); color: #00d9ff; }
        .kpi-info h3 { font-size: 1.6rem; font-weight: 700; margin-bottom: 0; }
        .kpi-info p { font-size: 0.8rem; color: rgba(255,255,255,0.5); margin-bottom: 0; }
        .welcome-banner { padding: 2rem; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(135deg, rgba(0,217,255,0.08), rgba(0,255,136,0.06)); }
        .welcome-banner h3 { font-weight: 700; margin-bottom: 0.3rem; }
        .welcome-banner p { color: rgba(255,255,255,0.6); margin-bottom: 0; }
        .welcome-icon i { font-size: 3rem; color: rgba(0,217,255,0.3); }
        .action-card { display: flex; align-items: center; gap: 1rem; padding: 1.5rem; text-decoration: none; color: #f3f6ff; transition: all 0.3s; }
        .action-card:hover { background: rgba(255,255,255,0.04); color: #fff; transform: translateY(-3px); }
        .action-icon { font-size: 2rem; width: 50px; text-align: center; }
        .action-card h5 { font-size: 1rem; font-weight: 600; margin-bottom: 2px; }
        .action-card p { font-size: 0.8rem; color: rgba(255,255,255,0.5); margin-bottom: 0; }
        @media (max-width: 768px) { .sidebar { display: none; } .main { margin-left: 0; } }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <a href="${pageContext.request.contextPath}/" class="sidebar-logo">
            <i class="fas fa-graduation-cap"></i> Exam<span>Portal</span>
        </a>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/student/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/tests"><i class="fas fa-file-alt"></i> Available Tests</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/results"><i class="fas fa-poll"></i> My Results</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/analysis"><i class="fas fa-chart-line"></i> Performance</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/register"><i class="fas fa-user"></i> Profile</a></li>
            <li style="margin-top: auto"><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </nav>

    <!-- Main -->
    <div class="main">
        <div class="topbar">
            <h4 class="fw-bold mb-0">Student Dashboard</h4>
            <div class="d-flex align-items-center gap-3">
                <span class="small text-secondary"><%= userEmail %></span>
                <div class="avatar"><%= initials %></div>
            </div>
        </div>

        <!-- Welcome -->
        <div class="glass welcome-banner mb-4">
            <div>
                <h3>Welcome back! 👋</h3>
                <p>Browse available exams, take tests, and track your performance</p>
            </div>
            <div class="welcome-icon"><i class="fas fa-user-graduate"></i></div>
        </div>

        <!-- KPI Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-blue"><i class="fas fa-file-alt"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Available Exams</p></div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-green"><i class="fas fa-check-circle"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Exams Completed</p></div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-purple"><i class="fas fa-percentage"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Avg Score</p></div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-cyan"><i class="fas fa-trophy"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Best Score</p></div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row g-4">
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/candidate/tests" class="action-card glass">
                    <i class="fas fa-play-circle action-icon" style="color:#4f7cff"></i>
                    <div><h5>Take Exam</h5><p>Browse and start available exams</p></div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/candidate/results" class="action-card glass">
                    <i class="fas fa-poll action-icon" style="color:#00ff88"></i>
                    <div><h5>View Results</h5><p>Check your scores and pass/fail status</p></div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/candidate/analysis" class="action-card glass">
                    <i class="fas fa-chart-line action-icon" style="color:#ffaa00"></i>
                    <div><h5>Performance</h5><p>Track your progress over time</p></div>
                </a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>