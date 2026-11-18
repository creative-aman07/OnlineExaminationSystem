<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.TestItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<TestItem> tests = (List<TestItem>) request.getAttribute("tests"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Examinations | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <p class="small text-secondary mb-1">Assessment Catalog</p>
                <h1 class="h2 fw-bold mb-1">Available Examinations</h1>
                <p class="text-secondary mb-0">Select an assessment to start your timed examination.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <% if (session.getAttribute("candidate") == null) { %>
                <a href="${pageContext.request.contextPath}/candidate/register" class="btn btn-primary"><i class="fas fa-user-plus me-1"></i>Create student account</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary"><i class="fas fa-sign-in-alt me-1"></i>Sign in</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-primary"><i class="fas fa-tachometer-alt me-1"></i>Dashboard</a>
                <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-outline-primary"><i class="fas fa-poll me-1"></i>My results</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light"><i class="fas fa-home me-1"></i>Home</a>
            </div>
        </div>

        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
        <div class="alert alert-warning alert-dismissible fade show mb-4" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i><%= error %>
        </div>
        <% } %>

        <% if (tests == null || tests.isEmpty()) { %>
        <div class="alert alert-info" role="status">
            <i class="fas fa-info-circle me-2"></i>No examinations are currently scheduled.
        </div>
        <% } else { %>
        <div class="row g-4">
            <% for (TestItem test : tests) { %>
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 p-4 border shadow-sm d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                <%= test.getSubject() %>
                            </span>
                            <% if (test.isRunning()) { %>
                            <span class="badge bg-success-subtle text-success border border-success-subtle">
                                <i class="fas fa-circle fa-xs me-1"></i>Active
                            </span>
                            <% } else if ("UPCOMING".equals(test.getStatus())) { %>
                            <span class="badge bg-warning-subtle text-warning border border-warning-subtle">
                                Upcoming
                            </span>
                            <% } else { %>
                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">
                                Closed
                            </span>
                            <% } %>
                        </div>
                        <h5 class="fw-bold mb-3"><%= test.getTestName() %></h5>
                        <div class="small text-secondary mb-4 d-grid gap-2">
                            <div><i class="far fa-clock me-2 text-primary"></i>Duration: <strong><%= test.getDurationMinutes() %> minutes</strong></div>
                            <div><i class="far fa-question-circle me-2 text-primary"></i>Questions: <strong><%= test.getTotalQuestions() %> questions</strong></div>
                            <% if (test.getStartTime() != null || test.getEndTime() != null) { %>
                            <div><i class="far fa-calendar-alt me-2 text-primary"></i>Window: <%= test.getStartTime() != null ? test.getStartTime() : "Open" %> &ndash; <%= test.getEndTime() != null ? test.getEndTime() : "Open" %></div>
                            <% } %>
                        </div>
                    </div>
                    <div>
                        <% if (test.isRunning()) { %>
                            <% if (session.getAttribute("candidate") != null) { %>
                            <a href="${pageContext.request.contextPath}/candidate/take?testId=<%= test.getTestId() %>" class="btn btn-primary w-100">
                                <i class="fas fa-play me-2"></i>Start Examination
                            </a>
                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary w-100">
                                <i class="fas fa-sign-in-alt me-2"></i>Sign In to Start
                            </a>
                            <% } %>
                        <% } else { %>
                        <button class="btn btn-secondary w-100" disabled>
                            <%= "UPCOMING".equals(test.getStatus()) ? "Opens Soon" : "Examination Closed" %>
                        </button>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
