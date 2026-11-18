<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.Candidate" %>
<%@ page import="com.examportal.model.TestItem" %>
<%@ page import="com.examportal.service.ExamService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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

    ExamService examService = new ExamService();
    Candidate candidate = (Candidate) session.getAttribute("candidate");
    if (candidate == null && userEmail != null) {
        candidate = examService.findOrCreateCandidateForUser(userEmail);
        if (candidate != null) {
            session.setAttribute("candidate", candidate);
            session.setAttribute("candidateId", candidate.getCandidateId());
        }
    }

    int candidateId = candidate != null ? candidate.getCandidateId() : 0;
    Map<String, Object> stats = examService.getStudentDashboardStats(candidateId);
    List<TestItem> availableTests = examService.listRunningTests();
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
                <h1 class="h4 fw-bold mb-0">Student Dashboard</h1>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-sm-block">
                    <div class="fw-semibold small"><%= candidate != null ? candidate.getFullName() : "Student" %></div>
                    <div class="small text-secondary"><%= userEmail %> (<%= candidate != null ? candidate.getRollNumber() : "DEMO" %>)</div>
                </div>
                <div class="avatar"><%= initials %></div>
            </div>
        </div>

        <!-- Welcome Banner -->
        <div class="glass welcome-banner mb-4">
            <div>
                <h3>Welcome back, <%= candidate != null ? candidate.getFullName() : "Student" %>! 👋</h3>
                <p>Browse available exams, take tests, and track your performance insights in real-time.</p>
            </div>
            <div class="welcome-icon"><i class="fas fa-user-graduate"></i></div>
        </div>

        <!-- Dynamic KPI Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-blue"><i class="fas fa-file-alt"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("availableExams") %></h3>
                        <p>Available Exams</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-green"><i class="fas fa-check-circle"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("completedExams") %></h3>
                        <p>Exams Completed</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-purple"><i class="fas fa-percentage"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("avgScore") %>%</h3>
                        <p>Avg Score</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="glass kpi-card">
                    <div class="kpi-icon kpi-cyan"><i class="fas fa-trophy"></i></div>
                    <div class="kpi-info">
                        <h3><%= stats.get("bestScore") %>%</h3>
                        <p>Best Score</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Available Exams & Quick Actions -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="glass p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-semibold mb-0"><i class="fas fa-clipboard-list me-2 text-primary"></i>Available Assessments</h5>
                        <a href="${pageContext.request.contextPath}/candidate/tests" class="small text-decoration-none">View All &rarr;</a>
                    </div>
                    <% if (availableTests == null || availableTests.isEmpty()) { %>
                    <div class="alert alert-info small mb-0">No active examinations at this moment.</div>
                    <% } else { %>
                    <div class="d-grid gap-3">
                        <% for (TestItem test : availableTests) { %>
                        <div class="p-3 border rounded-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div>
                                <h6 class="fw-bold mb-1"><%= test.getTestName() %></h6>
                                <div class="small text-secondary">
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle me-2"><%= test.getSubject() %></span>
                                    <i class="far fa-clock me-1"></i><%= test.getDurationMinutes() %> mins
                                    <span class="mx-1">&middot;</span>
                                    <i class="far fa-question-circle me-1"></i><%= test.getTotalQuestions() %> questions
                                </div>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/candidate/take?testId=<%= test.getTestId() %>" class="btn btn-sm btn-primary">
                                    <i class="fas fa-play me-1"></i>Start Exam
                                </a>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="glass p-4 h-100">
                    <h5 class="fw-semibold mb-3"><i class="fas fa-bolt me-2 text-warning"></i>Quick Actions</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/candidate/tests" class="action-card glass">
                            <i class="fas fa-play-circle action-icon"></i>
                            <div><h5>Take Exam</h5><p>Browse and start tests</p></div>
                        </a>
                        <a href="${pageContext.request.contextPath}/candidate/results" class="action-card glass">
                            <i class="fas fa-poll action-icon"></i>
                            <div><h5>View Results</h5><p>Scores & pass/fail status</p></div>
                        </a>
                        <a href="${pageContext.request.contextPath}/candidate/analysis" class="action-card glass">
                            <i class="fas fa-chart-line action-icon"></i>
                            <div><h5>Performance</h5><p>Overall progress insights</p></div>
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
