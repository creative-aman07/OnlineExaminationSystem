<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.Result" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Result> results = (List<Result>) request.getAttribute("results"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #07111f, #15253f); color: #f3f6ff; font-family: Arial, sans-serif; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.25); }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <h2 class="mb-3">My Results</h2>
        <% if (results == null || results.isEmpty()) { %>
        <div class="alert alert-info">No results yet.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-dark table-striped align-middle">
                <thead>
                <tr>
                    <th>Test</th>
                    <th>Correct</th>
                    <th>Wrong</th>
                    <th>Score</th>
                    <th>Percentage</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <% for (Result result : results) { %>
                <tr>
                    <td><%= result.getTestName() %></td>
                    <td><%= result.getCorrectAnswers() %></td>
                    <td><%= result.getWrongAnswers() %></td>
                    <td><%= result.getScore() %></td>
                    <td><%= String.format("%.2f", result.getPercentage()) %>%</td>
                    <td><%= result.isPassed() ? "PASS" : "FAIL" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
        <a href="${pageContext.request.contextPath}/candidate/analysis" class="btn btn-primary mt-3">Performance Analysis</a>
    </div>
</div>
</body>
</html>
