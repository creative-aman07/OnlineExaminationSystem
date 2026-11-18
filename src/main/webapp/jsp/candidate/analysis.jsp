<%@ page import="com.examportal.model.Result" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Result latestResult = (Result) request.getAttribute("latestResult"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Analysis | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <p class="small text-secondary mb-1">Performance Overview</p>
                <h1 class="h2 fw-bold mb-0">Performance Analysis</h1>
            </div>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-outline-primary btn-sm">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
        </div>

        <% if (latestResult != null) { %>
        <div class="card p-4 p-md-5 border shadow-sm mb-4">
            <div class="row align-items-center g-4">
                <div class="col-md-auto text-center">
                    <div class="score-ring mx-auto mb-2" style="--score:<%= Math.max(0, Math.min(100, latestResult.getPercentage())) %>%" role="img" aria-label="<%= String.format("%.2f", latestResult.getPercentage()) %> percent">
                        <span><%= String.format("%.1f", latestResult.getPercentage()) %>%</span>
                    </div>
                    <span class="small text-secondary fw-medium">Accuracy Score</span>
                </div>
                <div class="col">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle mb-2">Latest Completed Attempt</span>
                    <h2 class="h4 fw-bold mb-3"><%= latestResult.getTestName() %></h2>
                    <div class="row g-3">
                        <div class="col-6 col-md-4">
                            <span class="small text-secondary d-block">Marks Scored</span>
                            <strong class="fs-5"><%= latestResult.getScore() %> / <%= latestResult.getTotalQuestions() %></strong>
                        </div>
                        <div class="col-6 col-md-4">
                            <span class="small text-secondary d-block">Correct Answers</span>
                            <strong class="fs-5 text-success"><%= latestResult.getCorrectAnswers() %></strong>
                        </div>
                        <div class="col-6 col-md-4">
                            <span class="small text-secondary d-block">Assessment Status</span>
                            <strong class="fs-5 <%= latestResult.isPassed() ? "text-success" : "text-danger" %>">
                                <%= latestResult.isPassed() ? "Passed" : "Not passed" %>
                            </strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-info mb-4" role="status">
            <i class="fas fa-info-circle me-2"></i>No performance data yet. Complete an examination to see your detailed performance metrics here.
        </div>
        <% } %>

        <div class="d-flex flex-wrap gap-2 pt-3 border-top">
            <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-outline-primary">
                <i class="fas fa-poll me-1"></i>Back to Results
            </a>
            <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-primary">
                <i class="fas fa-clipboard-list me-1"></i>Browse Available Exams
            </a>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-outline-light">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
        </div>
    </div>
</div>
</body>
</html>
