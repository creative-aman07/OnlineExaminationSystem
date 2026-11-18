<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Examination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-glass fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold text-white" href="${pageContext.request.contextPath}/">
            <i class="fas fa-graduation-cap me-2 text-primary"></i>Exam<span class="gradient-text">Portal</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <i class="fas fa-bars text-white"></i>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto align-items-center gap-2">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/candidate/register"><i class="fas fa-user-plus me-1"></i>Register</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/candidate/tests"><i class="fas fa-file-alt me-1"></i>Tests</a></li>
                <li class="nav-item"><a class="btn btn-cyber btn-sm ms-2" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt me-1"></i>Login</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero -->
<div class="container hero" style="padding-top: 7rem">
    <div class="row align-items-center">
        <div class="col-lg-7">
            <h1 class="display-4 fw-bold mb-3">Online Examination &<br><span class="gradient-text">Assessment Management</span></h1>
            <p class="lead text-light-emphasis mb-4" style="max-width: 540px">A streamlined portal for candidate registration, online testing, automatic evaluation, result generation, and performance insights.</p>
            <div class="d-flex flex-wrap gap-3 mb-3">
                <a href="${pageContext.request.contextPath}/candidate/register" class="btn btn-cyber btn-lg"><i class="fas fa-user-plus me-2"></i>Register Now</a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-outline-cyber btn-lg"><i class="fas fa-play me-2"></i>Start Test</a>
            </div>
            <p class="small text-secondary mt-2"><i class="fas fa-info-circle me-1"></i>Students can register or sign in to take an exam and track their results.</p>
        </div>
        <div class="col-lg-5 mt-4 mt-lg-0">
            <div class="glass p-4">
                <h5 class="mb-3"><i class="fas fa-shield-alt me-2 text-primary"></i>About System</h5>
                <p class="mb-3 small text-light-emphasis">The platform supports question bank management, secure timed assessments, instant grading, result reporting, and candidate-wise performance analysis.</p>
                <div class="d-flex gap-2 flex-wrap">
                    <span class="badge badge-db bg-primary bg-opacity-25 text-primary-emphasis">Java</span>
                    <span class="badge badge-db bg-success bg-opacity-25 text-success-emphasis">JSP</span>
                    <span class="badge badge-db bg-info bg-opacity-25 text-info-emphasis">Servlets</span>
                    <span class="badge badge-db bg-warning bg-opacity-25 text-warning-emphasis">MySQL</span>
                    <span class="badge badge-db bg-danger bg-opacity-25 text-danger-emphasis">Maven</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Feature Cards -->
<div class="container pb-5">
    <h4 class="text-center mb-4 fw-semibold">Key Features</h4>
    <div class="row g-4">
        <div class="col-md-4 animate-in">
            <a href="${pageContext.request.contextPath}/candidate/register" class="feature-card">
                <div class="feature-icon icon-blue"><i class="fas fa-user-plus"></i></div>
                <h6 class="fw-semibold mb-1">Candidate Registration</h6>
                <p class="small text-light-emphasis mb-0">Register candidates with name, roll number and email</p>
            </a>
        </div>
        <div class="col-md-4 animate-in">
            <a href="${pageContext.request.contextPath}/login" class="feature-card">
                <div class="feature-icon icon-green"><i class="fas fa-database"></i></div>
                <h6 class="fw-semibold mb-1">Question Bank</h6>
                <p class="small text-light-emphasis mb-0">Add, view and manage MCQ questions for exams</p>
            </a>
        </div>
        <div class="col-md-4 animate-in">
            <a href="${pageContext.request.contextPath}/candidate/tests" class="feature-card">
                <div class="feature-icon icon-purple"><i class="fas fa-clipboard-check"></i></div>
                <h6 class="fw-semibold mb-1">Online Test</h6>
                <p class="small text-light-emphasis mb-0">Take timed exams with auto-submit and countdown timer</p>
            </a>
        </div>
        <div class="col-md-4 animate-in">
            <a href="${pageContext.request.contextPath}/candidate/register" class="feature-card">
                <div class="feature-icon icon-cyan"><i class="fas fa-chart-bar"></i></div>
                <h6 class="fw-semibold mb-1">Student Sign In</h6>
                <p class="small text-light-emphasis mb-0">Sign in to review your results and assessment history</p>
            </a>
        </div>
        <div class="col-md-4 animate-in">
            <a href="${pageContext.request.contextPath}/login" class="feature-card">
                <div class="feature-icon icon-orange"><i class="fas fa-chart-line"></i></div>
                <h6 class="fw-semibold mb-1">Performance Analysis</h6>
                <p class="small text-light-emphasis mb-0">Sign in to track your scores and assessment history</p>
            </a>
        </div>
        <div class="col-md-4 animate-in">
            <a href="${pageContext.request.contextPath}/login" class="feature-card">
                <div class="feature-icon icon-pink"><i class="fas fa-tachometer-alt"></i></div>
                <h6 class="fw-semibold mb-1">Admin Dashboard</h6>
                <p class="small text-light-emphasis mb-0">Faculty and student dashboards with examination reports</p>
            </a>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="text-center py-4" style="border-top: 1px solid rgba(255,255,255,0.06)">
    <p class="small text-secondary mb-0">&copy; 2026 ExamPortal — Online Examination &amp; Assessment Management System</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
