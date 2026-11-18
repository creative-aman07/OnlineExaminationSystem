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
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="small text-secondary mb-1">Your assessment history</p>
                <h1 class="h2 fw-bold mb-1">My Results</h1>
                <p class="text-secondary mb-0">Review your scores and examination outcomes.</p>
            </div>
            <% if (results != null && !results.isEmpty()) { %>
            <span class="badge rounded-pill text-bg-light border"><%= results.size() %> <%= results.size() == 1 ? "attempt" : "attempts" %></span>
            <% } %>
        </div>
        <% if (results == null || results.isEmpty()) { %>
        <div class="alert alert-info mb-4" role="status">No results yet. Your completed examinations will appear here.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                <tr>
                    <th scope="col">Examination</th>
                    <th scope="col">Date submitted</th>
                    <th scope="col">Correct</th>
                    <th scope="col">Incorrect</th>
                    <th scope="col">Unanswered</th>
                    <th scope="col">Marks</th>
                    <th scope="col">Percentage</th>
                    <th scope="col">Outcome</th>
                </tr>
                </thead>
                <tbody>
                <% for (Result result : results) { %>
                <tr>
                    <th scope="row"><%= result.getTestName() %></th>
                    <td><%= result.getSubmittedAt() != null ? result.getSubmittedAt() : "—" %></td>
                    <td><%= result.getCorrectAnswers() %></td>
                    <td><%= result.getWrongAnswers() %></td>
                    <td><%= Math.max(0, result.getTotalQuestions() - result.getCorrectAnswers() - result.getWrongAnswers()) %></td>
                    <td><%= result.getScore() %></td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-nowrap"><%= String.format("%.2f", result.getPercentage()) %>%</span>
                            <div class="score-progress flex-grow-1" role="img" aria-label="<%= String.format("%.2f", result.getPercentage()) %> percent">
                                <span style="--score:<%= Math.max(0, Math.min(100, result.getPercentage())) %>%"></span>
                            </div>
                        </div>
                    </td>
                    <td><span class="badge <%= result.isPassed() ? "text-bg-success" : "text-bg-danger" %>"><%= result.isPassed() ? "Passed" : "Not passed" %></span></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
        <div class="d-flex gap-2 mt-3">
            <a href="${pageContext.request.contextPath}/candidate/analysis" class="btn btn-primary">Performance Analysis</a>
            <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-outline-primary">Browse Exams</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">Sign out</a>
        </div>
    </div>
</div>
</body>
</html>
