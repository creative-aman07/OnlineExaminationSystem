<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Protect: must be logged in as admin
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) userEmail = "Admin";
    String initials = String.valueOf(userEmail.charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="dashboardSidebar" aria-label="Admin navigation">
        <a href="${pageContext.request.contextPath}/" class="sidebar-logo">
            <i class="fas fa-graduation-cap"></i> Exam<span>Portal</span>
        </a>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/faculty/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/question-bank"><i class="fas fa-database"></i> Question Bank</a></li>
            <li><a href="${pageContext.request.contextPath}/candidate/tests"><i class="fas fa-file-alt"></i> View Tests</a></li>
            <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a></li>
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
                <h1 class="h4 fw-bold mb-0">Faculty Dashboard</h1>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="small text-secondary"><%= userEmail %></span>
                <div class="avatar"><%= initials %></div>
            </div>
        </div>

        <!-- Welcome -->
        <div class="glass welcome-banner mb-4">
            <div>
                <h3>Welcome, Admin! 👨‍🏫</h3>
                <p>Manage exams, questions, and review candidate performance</p>
            </div>
            <div class="welcome-icon"><i class="fas fa-chalkboard-teacher"></i></div>
        </div>

        <!-- KPI Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-blue"><i class="fas fa-file-alt"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Total Tests</p></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-green"><i class="fas fa-question-circle"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Questions</p></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-purple"><i class="fas fa-users"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Candidates</p></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-cyan"><i class="fas fa-check-circle"></i></div>
                    <div class="kpi-info"><h3>—</h3><p>Submissions</p></div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row g-4">
            <div class="col-lg-6">
                <div class="glass p-4">
                    <h5 class="fw-semibold mb-3"><i class="fas fa-bolt me-2" style="color:#ffaa00"></i>Quick Actions</h5>
                    <a href="${pageContext.request.contextPath}/question-bank" class="action-card glass">
                        <i class="fas fa-database action-icon"></i>
                        <div><h5>Manage Questions</h5><p>Add, view, delete questions in the question bank</p></div>
                    </a>
                    <a href="${pageContext.request.contextPath}/candidate/tests" class="action-card glass">
                        <i class="fas fa-clipboard-list action-icon"></i>
                        <div><h5>View All Tests</h5><p>See available tests and their status</p></div>
                    </a>
                    <a href="${pageContext.request.contextPath}/candidate/tests" class="action-card glass">
                        <i class="fas fa-eye action-icon"></i>
                        <div><h5>Preview Exams</h5><p>Check published exams as students see them</p></div>
                    </a>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="glass p-4">
                    <h5 class="fw-semibold mb-3"><i class="fas fa-info-circle me-2 text-primary"></i>System Info</h5>
                    <table class="table mb-0">
                        <tbody>
                            <tr><th class="ps-0">Platform</th><td>Java 21 + Jakarta EE 10</td></tr>
                            <tr><th class="ps-0">Server</th><td>Apache Tomcat 10.x</td></tr>
                            <tr><th class="ps-0">Database</th><td>MySQL 8.0</td></tr>
                            <tr><th class="ps-0">Build Tool</th><td>Apache Maven</td></tr>
                            <tr><th class="ps-0">Version</th><td>2.0.0</td></tr>
                        </tbody>
                    </table>
                </div>
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