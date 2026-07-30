<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.TestItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<TestItem> tests = (List<TestItem>) request.getAttribute("tests"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Tests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #07111f, #15253f); color: #f3f6ff; font-family: Arial, sans-serif; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.25); }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">Available Tests</h2>
                <p class="text-light-emphasis mb-0">Choose a test to begin your assessment.</p>
            </div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light">Home</a>
        </div>
        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
        <div class="alert alert-warning"><%= error %></div>
        <% } %>
        <% if (tests == null || tests.isEmpty()) { %>
        <div class="alert alert-info">No tests are available yet.</div>
        <% } else { %>
        <div class="row g-4">
            <% for (TestItem test : tests) { %>
            <div class="col-md-6">
                <div class="card h-100 border-0 bg-dark text-light">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <h5 class="card-title"><%= test.getTestName() %></h5>
                            <% if (test.isRunning()) { %>
                            <span class="badge bg-success">Running</span>
                            <% } else if ("UPCOMING".equals(test.getStatus())) { %>
                            <span class="badge bg-warning text-dark">Upcoming</span>
                            <% } else { %>
                            <span class="badge bg-secondary">Closed</span>
                            <% } %>
                        </div>
                        <p class="card-text mb-2">Subject: <%= test.getSubject() %></p>
                        <p class="card-text mb-2">Duration: <%= test.getDurationMinutes() %> mins</p>
                        <p class="card-text mb-2">Questions: <%= test.getTotalQuestions() %></p>
                        <% if (test.getStartTime() != null || test.getEndTime() != null) { %>
                        <p class="card-text mb-3 small text-light-emphasis">
                            <% if (test.getStartTime() != null) { %>Opens: <%= test.getStartTime() %><br><% } %>
                            <% if (test.getEndTime() != null) { %>Closes: <%= test.getEndTime() %><% } %>
                        </p>
                        <% } %>
                        <% if (test.isRunning()) { %>
                        <a href="${pageContext.request.contextPath}/candidate/take?testId=<%= test.getTestId() %>" class="btn btn-primary">Start Test</a>
                        <% } else { %>
                        <button class="btn btn-secondary" disabled><%= "UPCOMING".equals(test.getStatus()) ? "Not Started Yet" : "Closed" %></button>
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
