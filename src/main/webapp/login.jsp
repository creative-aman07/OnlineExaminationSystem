<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body class="auth-body">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" style="text-decoration:none">
                    <h3 class="fw-bold text-white"><i class="fas fa-graduation-cap me-2 text-primary"></i>Exam<span class="gradient-text">Portal</span></h3>
                </a>
            </div>
            <div class="glass-card p-4 p-md-5">
                <h1 class="h4 fw-bold mb-1">Welcome Back</h1>
                <p class="text-secondary small mb-4">Sign in to your account</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 small" role="alert"><i class="fas fa-exclamation-triangle me-1"></i><%= request.getAttribute("error") %></div>
                <% } %>

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

                <hr style="border-color: rgba(255,255,255,0.1)" />
                <div class="text-center">
                    <a class="small" href="${pageContext.request.contextPath}/candidate/register">New student? Create an account</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
