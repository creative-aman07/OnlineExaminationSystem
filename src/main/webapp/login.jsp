<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body class="auth-body py-4">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" style="text-decoration:none">
                    <h3 class="fw-bold mb-0 text-primary">
                        <i class="fas fa-graduation-cap me-2 text-primary"></i>Exam<span class="gradient-text">Portal</span>
                    </h3>
                </a>
            </div>

            <div class="glass-card p-4 p-md-5">
                <h1 class="h4 fw-bold mb-1">Welcome Back</h1>
                <p class="text-secondary small mb-3">Sign in to your account</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 small" role="alert">
                    <i class="fas fa-exclamation-triangle me-1"></i><%= request.getAttribute("error") %>
                </div>
                <% } %>

                <!-- Demo Credentials Quick Fill Banner -->
                <div class="p-3 mb-4 rounded-3 border bg-light-subtle">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="small fw-semibold text-secondary"><i class="fas fa-key me-1 text-warning"></i>Demo Credentials</span>
                        <span class="badge bg-secondary-subtle text-secondary small">Quick Fill</span>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-sm btn-outline-primary flex-fill" onclick="fillCredentials('admin@exam.com', 'password123')">
                            <i class="fas fa-user-shield me-1"></i>Admin
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-primary flex-fill" onclick="fillCredentials('student@exam.com', 'password123')">
                            <i class="fas fa-user-graduate me-1"></i>Student
                        </button>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/login">
                    <input type="hidden" name="_csrf" value="${csrfToken}" />
                    <div class="mb-3">
                        <label class="form-label" for="loginEmail">Email address</label>
                        <input id="loginEmail" type="email" class="form-control" name="email" autocomplete="username" placeholder="you@example.com" required />
                    </div>
                    <div class="mb-4">
                        <label class="form-label" for="loginPassword">Password</label>
                        <input id="loginPassword" type="password" class="form-control" name="password" autocomplete="current-password" placeholder="Enter your password" required />
                    </div>
                    <button type="submit" class="btn btn-cyber login-submit mb-3"><i class="fas fa-sign-in-alt me-2"></i>Sign In</button>
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none small"><i class="fas fa-arrow-left me-1"></i>Back to Home</a>
                    </div>
                </form>

                <hr class="my-4" style="border-color: var(--border)" />
                <div class="text-center">
                    <a class="small text-decoration-none fw-medium" href="${pageContext.request.contextPath}/candidate/register">
                        New student? Create an account &rarr;
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function fillCredentials(email, password) {
        document.getElementById('loginEmail').value = email;
        document.getElementById('loginPassword').value = password;
    }
</script>
</body>
</html>
