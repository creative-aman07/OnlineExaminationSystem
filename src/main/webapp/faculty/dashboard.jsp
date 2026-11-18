<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.service.ExamService" %>
<%@ page import="com.examportal.model.Result" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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

    ExamService examService = new ExamService();
    Map<String, Object> stats = examService.getFacultyDashboardStats();
    List<Result> recentResults = examService.listRecentSubmissions(5);
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
                <span class="small text-secondary"><%= userEmail %> (Administrator)</span>
                <div class="avatar"><%= initials %></div>
            </div>
        </div>

        <!-- Welcome Banner -->
        <div class="glass welcome-banner mb-4">
            <div>
                <h3>Welcome, Administrator! 👨‍🏫</h3>
                <p>Manage examinations, question bank items, and review candidate assessment submissions.</p>
            </div>
            <div class="welcome-icon"><i class="fas fa-chalkboard-teacher"></i></div>
        </div>

        <!-- Dynamic KPI Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-blue"><i class="fas fa-file-alt"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("totalTests") %></h3>
                        <p>Total Exams</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-green"><i class="fas fa-question-circle"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("totalQuestions") %></h3>
                        <p>Question Bank</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-purple"><i class="fas fa-users"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("totalCandidates") %></h3>
                        <p>Registered Students</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-cyan"><i class="fas fa-check-circle"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("totalSubmissions") %></h3>
                        <p>Submissions</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Submissions & Management -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="glass p-4 h-100">
                    <h5 class="fw-semibold mb-3"><i class="fas fa-history me-2 text-primary"></i>Recent Exam Submissions</h5>
                    <% if (recentResults == null || recentResults.isEmpty()) { %>
                    <div class="alert alert-info small mb-0">No submissions recorded yet.</div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Candidate ID</th>
                                    <th>Exam Name</th>
                                    <th>Score</th>
                                    <th>Percentage</th>
                                    <th>Outcome</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Result r : recentResults) { %>
                                <tr>
                                    <td><span class="badge text-bg-light border">#<%= r.getCandidateId() %></span></td>
                                    <td class="fw-medium"><%= r.getTestName() %></td>
                                    <td><%= r.getScore() %> / <%= r.getTotalQuestions() %></td>
                                    <td><strong><%= String.format("%.1f", r.getPercentage()) %>%</strong></td>
                                    <td>
                                        <span class="badge <%= r.isPassed() ? "bg-success-subtle text-success border border-success-subtle" : "bg-danger-subtle text-danger border border-danger-subtle" %>">
                                            <%= r.isPassed() ? "Passed" : "Failed" %>
                                        </span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="glass p-4 h-100">
                    <h5 class="fw-semibold mb-3"><i class="fas fa-bolt me-2 text-warning"></i>Management Actions</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/question-bank" class="action-card glass">
                            <i class="fas fa-database action-icon"></i>
                            <div><h5>Question Bank</h5><p>Add & manage MCQs</p></div>
                        </a>
                        <a href="${pageContext.request.contextPath}/candidate/tests" class="action-card glass">
                            <i class="fas fa-file-alt action-icon"></i>
                            <div><h5>View Tests</h5><p>Inspect scheduled exams</p></div>
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="action-card glass">
                            <i class="fas fa-globe action-icon"></i>
                            <div><h5>Public Portal</h5><p>Visit homepage</p></div>
                        </a>
                    </div>
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
            if (sidebar && toggle) {
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
            }
        })();
    </script>
</body>
</html>
