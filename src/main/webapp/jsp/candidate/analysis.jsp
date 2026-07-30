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
    <style>
        body { background: linear-gradient(135deg, #07111f, #15253f); color: #f3f6ff; font-family: Arial, sans-serif; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.25); }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <h2 class="mb-3">Performance Analysis</h2>
        <% if (latestResult != null) { %>
        <div class="card bg-dark text-light">
            <div class="card-body">
                <h5 class="card-title">Latest Attempt</h5>
                <p class="mb-2">Test: <%= latestResult.getTestName() %></p>
                <p class="mb-2">Highest Score: <%= latestResult.getScore() %></p>
                <p class="mb-2">Average Score: <%= String.format("%.2f", latestResult.getPercentage()) %>%</p>
                <p class="mb-0">Status: <%= latestResult.isPassed() ? "PASS" : "FAIL" %></p>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-info">No performance data yet.</div>
        <% } %>
        <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-outline-light mt-3">Back to Results</a>
    </div>
</div>
</body>
</html>
