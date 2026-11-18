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
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="dashboardSidebar" aria-label="Student navigation">
        <a href="${pageContext.request.contextPath}/" class="sidebar-logo">
            <i class="fas fa-graduation-cap"></i> Exam<span>Portal</span>
        </a>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/student/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/tests"><i class="fas fa-file-alt"></i> Available Tests</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/results"><i class="fas fa-poll"></i> My Results</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/analysis"><i class="fas fa-chart-line"></i> Performance</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/tests"><i class="fas fa-user"></i> Browse Exams</a></li>
            <li style="margin-top: auto"><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </nav>

    <!-- Main -->
    <div class="main">
        <div class="topbar">
            <div class="d-flex align-items-center gap-2">
                <button class="btn btn-outline-primary mobile-menu-toggle" id="menuToggle" type="button" aria-controls="dashboardSidebar" aria-expanded="false">
                    <span class="visually-hidden">Toggle navigation</span><i class="fas fa-bars" aria-hidden="true"></i>
                </button>
                <h1 class="h4 fw-bold mb-0">Student Dashboard</h1>
            </div>
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
                    <i class="fas fa-play-circle action-icon"></i>
                    <div><h5>Take Exam</h5><p>Browse and start available exams</p></div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/candidate/results" class="action-card glass">
                    <i class="fas fa-poll action-icon"></i>
                    <div><h5>View Results</h5><p>Check your scores and pass/fail status</p></div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/candidate/analysis" class="action-card glass">
                    <i class="fas fa-chart-line action-icon"></i>
                    <div><h5>Performance</h5><p>Track your progress over time</p></div>
                </a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            var sidebar = document.getElementById('dashboardSidebar');
            var toggle = document.getElementById('menuToggle');
            var mobile = window.matchMedia('(max-width: 767.98px)');
            sidebar.inert = mobile.matches;
            toggle.addEventListener('click', function () {
                var open = sidebar.classList.toggle('is-open');
                sidebar.inert = mobile.matches && !open;
                toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
            });
            sidebar.addEventListener('click', function (event) {
                if (mobile.matches && event.target.closest('a')) {
                    sidebar.classList.remove('is-open');
                    sidebar.inert = true;
                    toggle.setAttribute('aria-expanded', 'false');
                }
            });
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape' && mobile.matches) {
                    sidebar.classList.remove('is-open');
                    sidebar.inert = true;
                    toggle.setAttribute('aria-expanded', 'false');
                }
            });
            mobile.addEventListener('change', function (event) {
                if (!event.matches) sidebar.classList.remove('is-open');
                sidebar.inert = event.matches && !sidebar.classList.contains('is-open');
                if (!event.matches) toggle.setAttribute('aria-expanded', 'false');
            });
        })();
    </script>
</body>
</html>