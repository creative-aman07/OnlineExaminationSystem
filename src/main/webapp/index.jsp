<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Examination & Assessment Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-glass fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="fas fa-graduation-cap me-2 text-primary"></i>Exam<span class="gradient-text">Portal</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu" aria-controls="navMenu" aria-expanded="false" aria-label="Toggle navigation">
            <i class="fas fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto align-items-center gap-2">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/candidate/register"><i class="fas fa-user-plus me-1"></i>Register</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/candidate/tests"><i class="fas fa-file-alt me-1"></i>Available Tests</a></li>
                <li class="nav-item"><a class="btn btn-primary btn-sm ms-2" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt me-1"></i>Sign In</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="container hero" style="padding-top: 7rem">
    <div class="row align-items-center">
        <div class="col-lg-7">
            <div class="d-inline-flex align-items-center gap-2 px-3 py-1 mb-3 rounded-pill border bg-white shadow-sm small">
                <span class="badge bg-success rounded-pill">Active</span>
                <span class="text-secondary">Cloud-Ready Examination Platform</span>
            </div>
            <h1 class="display-4 fw-bold mb-3">Online Examination &amp; <span class="gradient-text">Assessment Management</span></h1>
            <p class="lead text-secondary mb-4" style="max-width: 540px">A secure, streamlined portal for candidate registration, real-time timed assessments, automated grading, instant results, and performance analysis.</p>
            <div class="d-flex flex-wrap gap-3 mb-4">
                <a href="${pageContext.request.contextPath}/candidate/register" class="btn btn-primary btn-lg px-4"><i class="fas fa-user-plus me-2"></i>Register Now</a>
                <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-outline-primary btn-lg px-4"><i class="fas fa-play me-2"></i>Browse Tests</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-lg px-4"><i class="fas fa-sign-in-alt me-2"></i>Sign In</a>
            </div>
            
            <!-- Quick Demo Credentials Callout -->
            <div class="p-3 rounded-3 border bg-white shadow-sm mb-4" style="max-width: 540px">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <i class="fas fa-info-circle text-primary"></i>
                    <strong class="small">Demo Accounts Available Out of the Box:</strong>
                </div>
                <div class="d-flex flex-wrap gap-3 small text-secondary">
                    <div><span class="fw-semibold text-dark">Admin:</span> admin@exam.com / password123</div>
                    <div><span class="fw-semibold text-dark">Student:</span> student@exam.com / password123</div>
                </div>
            </div>
        </div>

        <div class="col-lg-5 mt-4 mt-lg-0">
            <div class="glass p-4 p-md-5">
                <h5 class="mb-3 fw-bold"><i class="fas fa-shield-alt me-2 text-primary"></i>System Architecture</h5>
                <p class="mb-4 small text-secondary">Built on enterprise Jakarta EE 10, Servlet 6, JSP, and JDBC with HikariCP connection pooling and automatic multi-platform database failover.</p>
                
                <div class="d-grid gap-3 mb-4">
                    <div class="d-flex align-items-center gap-3">
                        <div class="p-2 rounded-2 bg-primary-subtle text-primary"><i class="fas fa-stopwatch fa-fw"></i></div>
                        <div>
                            <div class="fw-semibold small">Server-Side Timed Deadlines</div>
                            <div class="text-secondary small">Tamper-proof countdown enforced on the server</div>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="p-2 rounded-2 bg-success-subtle text-success"><i class="fas fa-check-double fa-fw"></i></div>
                        <div>
                            <div class="fw-semibold small">Instant Auto-Evaluation</div>
                            <div class="text-secondary small">Immediate results, score breakdowns, and pass/fail status</div>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div class="p-2 rounded-2 bg-info-subtle text-info"><i class="fas fa-cloud fa-fw"></i></div>
                        <div>
                            <div class="fw-semibold small">Universal Deployment</div>
                            <div class="text-secondary small">Zero configuration needed on Docker, Railway, Render, or Tomcat</div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2 flex-wrap">
                    <span class="badge badge-db bg-primary bg-opacity-10 text-primary">Java 21</span>
                    <span class="badge badge-db bg-success bg-opacity-10 text-success">Jakarta Servlet</span>
                    <span class="badge badge-db bg-info bg-opacity-10 text-info">JSP</span>
                    <span class="badge badge-db bg-warning bg-opacity-10 text-warning">MySQL 8 / H2</span>
                    <span class="badge badge-db bg-danger bg-opacity-10 text-danger">HikariCP</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Key Features -->
<div class="container py-5">
    <div class="text-center mb-5">
        <h2 class="h3 fw-bold mb-2">Key System Features</h2>
        <p class="text-secondary">Comprehensive features designed for administrators, faculty, and students</p>
    </div>
    <div class="row g-4">
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/candidate/register" class="feature-card">
                <div class="feature-icon icon-blue"><i class="fas fa-user-plus"></i></div>
                <h6 class="fw-bold mb-2">Candidate Registration</h6>
                <p class="small text-secondary mb-0">Quick student onboarding with roll number, secure password, and profile creation.</p>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/candidate/tests" class="feature-card">
                <div class="feature-icon icon-purple"><i class="fas fa-clipboard-check"></i></div>
                <h6 class="fw-bold mb-2">Online Examination</h6>
                <p class="small text-secondary mb-0">Timed MCQ assessments with question navigator, review flags, and auto-submit.</p>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/login" class="feature-card">
                <div class="feature-icon icon-green"><i class="fas fa-database"></i></div>
                <h6 class="fw-bold mb-2">Question Bank</h6>
                <p class="small text-secondary mb-0">Faculty repository to create, categorize, update, and manage multiple-choice questions.</p>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/candidate/results" class="feature-card">
                <div class="feature-icon icon-cyan"><i class="fas fa-poll"></i></div>
                <h6 class="fw-bold mb-2">Detailed Results</h6>
                <p class="small text-secondary mb-0">Score summaries, question breakdowns, percentages, and outcome certificates.</p>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/candidate/analysis" class="feature-card">
                <div class="feature-icon icon-orange"><i class="fas fa-chart-line"></i></div>
                <h6 class="fw-bold mb-2">Performance Analytics</h6>
                <p class="small text-secondary mb-0">Visual analytics ring, accuracy trends, and student progress metrics.</p>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/faculty/dashboard.jsp" class="feature-card">
                <div class="feature-icon icon-blue"><i class="fas fa-tachometer-alt"></i></div>
                <h6 class="fw-bold mb-2">Faculty Dashboard</h6>
                <p class="small text-secondary mb-0">Comprehensive administrative control with submission tracking and KPIs.</p>
            </a>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="py-4 mt-5 border-top bg-white">
    <div class="container text-center text-secondary small">
        <p class="mb-1">&copy; 2026 Online Examination &amp; Assessment Management System. All rights reserved.</p>
        <p class="mb-0">Powered by Java 21, Jakarta EE, and HikariCP</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
