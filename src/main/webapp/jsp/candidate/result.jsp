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
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <p class="small text-secondary mb-1">Examination complete</p>
        <h1 class="h2 fw-bold mb-4">Your result</h1>
        <% if (request.getAttribute("timeExpired") != null) { %>
        <div class="alert alert-warning" role="status">Time expired before submission — answers received after the deadline were not counted.</div>
        <% } %>
        <% if (result != null) { %>
        <% int unanswered = Math.max(0, result.getTotalQuestions() - result.getCorrectAnswers() - result.getWrongAnswers()); %>
        <div class="row g-4 align-items-stretch">
            <div class="col-lg-4">
                <section class="card h-100 p-4 text-center justify-content-center align-items-center" aria-label="Overall result">
                    <div class="score-ring mb-3" style="--score:<%= Math.max(0, Math.min(100, result.getPercentage())) %>%">
                        <span><%= String.format("%.1f", result.getPercentage()) %>%</span>
                    </div>
                    <h2 class="h5 fw-bold mb-1"><%= result.isPassed() ? "Passed" : "Not passed" %></h2>
                    <p class="text-secondary mb-0"><%= result.getTestName() %></p>
                </section>
            </div>
            <div class="col-lg-8">
                <section class="card h-100 p-4">
                    <h2 class="h5 fw-bold mb-1">Answer summary</h2>
                    <p class="text-secondary mb-4">Your score and responses for this attempt.</p>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 border h-100">
                                <span class="small text-secondary d-block">Marks obtained</span>
                                <strong class="fs-4"><%= result.getScore() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 border h-100">
                                <span class="small text-secondary d-block">Questions</span>
                                <strong class="fs-4"><%= result.getTotalQuestions() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="p-3 rounded-3 border h-100">
                                <span class="small text-secondary d-block">Correct</span>
                                <strong class="fs-4 text-success"><%= result.getCorrectAnswers() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="p-3 rounded-3 border h-100">
                                <span class="small text-secondary d-block">Incorrect</span>
                                <strong class="fs-4 text-danger"><%= result.getWrongAnswers() %></strong>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="p-3 rounded-3 border h-100">
                                <span class="small text-secondary d-block">Unanswered</span>
                                <strong class="fs-4"><%= unanswered %></strong>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
        <% } %>
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/candidate/results" class="btn btn-outline-primary me-2">View Results</a>
            <a href="${pageContext.request.contextPath}/candidate/analysis" class="btn btn-primary">Performance Analysis</a>
            <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-outline-primary">Browse Exams</a>
        </div>
    </div>
</div>
</body>
</html>
