<%@ page import="com.examportal.model.Result" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Result result = (Result) request.getAttribute("result"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #07111f, #15253f); color: #f3f6ff; font-family: Arial, sans-serif; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.25); }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <h2 class="mb-3">Result Generated</h2>
        <% if (request.getAttribute("timeExpired") != null) { %>
        <div class="alert alert-warning">Time expired before submission — answers received after the deadline were not counted.</div>
        <% } %>
        <% if (result != null) { %>
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card bg-dark text-light h-100">
                    <div class="card-body">
                        <h5 class="card-title">Test: <%= result.getTestName() %></h5>
                        <p class="mb-2">Total Questions: <%= result.getTotalQuestions() %></p>
                        <p class="mb-2">Correct Answers: <%= result.getCorrectAnswers() %></p>
                        <p class="mb-2">Wrong Answers: <%= result.getWrongAnswers() %></p>
                        <p class="mb-2">Score: <%= result.getScore() %></p>
                        <p class="mb-2">Percentage: <%= String.format("%.2f", result.getPercentage()) %>%</p>
                        <p class="mb-0">Status: <%= result.isPassed() ? "PASS" : "FAIL" %></p>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-outline-light me-2">View Results</a>
            <a href="${pageContext.request.contextPath}/candidate/analysis" class="btn btn-primary">Performance Analysis</a>
        </div>
    </div>
</div>
</body>
</html>
