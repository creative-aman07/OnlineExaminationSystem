<%@ page import="com.examportal.model.Result" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Result result = (Result) request.getAttribute("result"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Examination Result | ExamPortal</title>
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
                <p class="small text-secondary mb-1">Assessment Evaluation</p>
                <h1 class="h2 fw-bold mb-0">Examination Result</h1>
            </div>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-outline-primary btn-sm">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
        </div>

        <% if (request.getAttribute("timeExpired") != null) { %>
        <div class="alert alert-warning mb-4" role="status">
            <i class="fas fa-clock me-2"></i>Time expired before manual submission — answers submitted up to the deadline have been scored automatically.
        </div>
        <% } %>

        <% if (result != null) { %>
        <% int unanswered = Math.max(0, result.getTotalQuestions() - result.getCorrectAnswers() - result.getWrongAnswers()); %>
        <div class="row g-4 align-items-stretch">
            <div class="col-lg-4">
                <div class="card h-100 p-4 text-center justify-content-center align-items-center border shadow-sm">
                    <div class="score-ring mb-3" style="--score:<%= Math.max(0, Math.min(100, result.getPercentage())) %>%">
                        <span><%= String.format("%.1f", result.getPercentage()) %>%</span>
                    </div>
                    <span class="badge <%= result.isPassed() ? "bg-success-subtle text-success border border-success-subtle" : "bg-danger-subtle text-danger border border-danger-subtle" %> px-3 py-2 mb-2 fs-6">
                        <i class="fas <%= result.isPassed() ? "fa-check-circle" : "fa-times-circle" %> me-1"></i>
                        <%= result.isPassed() ? "Passed" : "Not passed" %>
                    </span>
                    <h2 class="h6 fw-semibold text-secondary mb-0"><%= result.getTestName() %></h2>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card h-100 p-4 border shadow-sm">
                    <h2 class="h5 fw-bold mb-1">Answer Summary &amp; Breakdown</h2>
                    <p class="text-secondary small mb-4">Detailed marks and responses scored for this attempt.</p>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 border bg-light-subtle h-100">
                                <span class="small text-secondary d-block">Marks Obtained</span>
                                <strong class="fs-4"><%= result.getScore() %> <span class="fs-6 text-secondary fw-normal">/ <%= result.getTotalQuestions() %></span></strong>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 border bg-light-subtle h-100">
                                <span class="small text-secondary d-block">Total Questions</span>
                                <strong class="fs-4"><%= result.getTotalQuestions() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="p-3 rounded-3 border bg-light-subtle h-100">
                                <span class="small text-secondary d-block">Correct Answers</span>
                                <strong class="fs-4 text-success"><i class="fas fa-check me-1"></i><%= result.getCorrectAnswers() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="p-3 rounded-3 border bg-light-subtle h-100">
                                <span class="small text-secondary d-block">Incorrect Answers</span>
                                <strong class="fs-4 text-danger"><i class="fas fa-times me-1"></i><%= result.getWrongAnswers() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="p-3 rounded-3 border bg-light-subtle h-100">
                                <span class="small text-secondary d-block">Unanswered</span>
                                <strong class="fs-4 text-secondary"><i class="fas fa-minus me-1"></i><%= unanswered %></strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <div class="d-flex flex-wrap gap-2 mt-4 pt-3 border-top">
            <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-primary">
                <i class="fas fa-poll me-1"></i>View All Results
            </a>
            <a href="${pageContext.request.contextPath}/candidate/analysis" class="btn btn-outline-primary">
                <i class="fas fa-chart-line me-1"></i>Performance Analysis
            </a>
            <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-outline-light">
                <i class="fas fa-clipboard-list me-1"></i>Browse Available Exams
            </a>
        </div>
    </div>
</div>
</body>
</html>
