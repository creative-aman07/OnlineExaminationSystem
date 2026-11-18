<%@ page import="com.examportal.model.Result" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Result latestResult = (Result) request.getAttribute("latestResult"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Analysis</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <p class="small text-secondary mb-1">Your progress</p>
        <h1 class="h2 fw-bold mb-4">Performance analysis</h1>
        <% if (latestResult != null) { %>
        <div class="card p-4 p-md-5">
            <div class="row align-items-center g-4">
                <div class="col-md-auto">
                    <div class="score-ring mx-auto" style="--score:<%= Math.max(0, Math.min(100, latestResult.getPercentage())) %>%" role="img" aria-label="<%= String.format("%.2f", latestResult.getPercentage()) %> percent">
                        <span><%= String.format("%.1f", latestResult.getPercentage()) %>%</span>
                    </div>
                </div>
                <div class="col">
                    <p class="small text-secondary mb-1">Latest attempt</p>
                    <h2 class="h4 fw-bold mb-3"><%= latestResult.getTestName() %></h2>
                    <div class="d-flex flex-wrap gap-4">
                        <div><span class="small text-secondary d-block">Marks obtained</span><strong class="fs-5"><%= latestResult.getScore() %></strong></div>
                        <div><span class="small text-secondary d-block">Correct answers</span><strong class="fs-5"><%= latestResult.getCorrectAnswers() %> / <%= latestResult.getTotalQuestions() %></strong></div>
                        <div><span class="small text-secondary d-block">Outcome</span><strong class="fs-5 <%= latestResult.isPassed() ? "text-success" : "text-danger" %>"><%= latestResult.isPassed() ? "Passed" : "Not passed" %></strong></div>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-info" role="status">No performance data yet. Complete an examination to see your results here.</div>
        <% } %>
        <div class="d-flex gap-2 mt-3">
            <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-outline-primary">Back to Results</a>
            <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-primary">Browse Exams</a>
        </div>
    </div>
</div>
</body>
</html>
