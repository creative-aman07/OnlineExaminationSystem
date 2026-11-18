<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.Result" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Result> results = (List<Result>) request.getAttribute("results"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Results | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="small text-secondary mb-1">Assessment History</p>
                <h1 class="h2 fw-bold mb-1">My Results</h1>
                <p class="text-secondary mb-0">Review your past scores, percentages, and performance outcomes.</p>
            </div>
            <div class="d-flex gap-2">
                <% if (results != null && !results.isEmpty()) { %>
                <span class="badge rounded-pill text-bg-light border px-3 py-2"><%= results.size() %> <%= results.size() == 1 ? "attempt" : "attempts" %></span>
                <% } %>
                <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-outline-primary btn-sm"><i class="fas fa-tachometer-alt me-1"></i>Dashboard</a>
            </div>
        </div>

        <% if (results == null || results.isEmpty()) { %>
        <div class="alert alert-info mb-4" role="status">
            <i class="fas fa-info-circle me-2"></i>No results recorded yet. Completed examinations will appear here.
        </div>
        <% } else { %>
        <div class="table-responsive mb-4">
            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th scope="col">Examination</th>
                    <th scope="col">Date Submitted</th>
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
                    <th scope="row" class="fw-semibold"><%= result.getTestName() %></th>
                    <td><%= result.getSubmittedAt() != null ? result.getSubmittedAt() : "—" %></td>
                    <td class="text-success fw-bold"><%= result.getCorrectAnswers() %></td>
                    <td class="text-danger fw-bold"><%= result.getWrongAnswers() %></td>
                    <td><%= Math.max(0, result.getTotalQuestions() - result.getCorrectAnswers() - result.getWrongAnswers()) %></td>
                    <td><strong><%= result.getScore() %></strong> / <%= result.getTotalQuestions() %></td>
                    <td>
                        <div class="d-flex align-items-center gap-2" style="min-width: 140px">
                            <span class="text-nowrap small fw-bold"><%= String.format("%.1f", result.getPercentage()) %>%</span>
                            <div class="score-progress flex-grow-1" role="img" aria-label="<%= String.format("%.2f", result.getPercentage()) %> percent">
                                <span style="--score:<%= Math.max(0, Math.min(100, result.getPercentage())) %>%"></span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span class="badge <%= result.isPassed() ? "bg-success-subtle text-success border border-success-subtle" : "bg-danger-subtle text-danger border border-danger-subtle" %> px-2 py-1">
                            <%= result.isPassed() ? "Passed" : "Not passed" %>
                        </span>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <div class="d-flex flex-wrap gap-2 mt-4 pt-3 border-top">
            <a href="${pageContext.request.contextPath}/candidate/analysis" class="btn btn-primary"><i class="fas fa-chart-line me-1"></i>Performance Analysis</a>
            <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-outline-primary"><i class="fas fa-clipboard-list me-1"></i>Browse Available Exams</a>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-outline-light"><i class="fas fa-tachometer-alt me-1"></i>Back to Dashboard</a>
        </div>
    </div>
</div>
</body>
</html>
