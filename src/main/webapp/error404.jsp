<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body class="auth-body py-5">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5 text-center">
            <div class="glass-card p-4 p-md-5">
                <div class="mb-3 text-primary">
                    <i class="fas fa-exclamation-circle fa-4x text-warning"></i>
                </div>
                <h1 class="display-4 fw-bold mb-1">404</h1>
                <h2 class="h5 fw-semibold mb-2">Page Not Found</h2>
                <p class="text-secondary small mb-4">The page you requested does not exist or may have been relocated.</p>
                <div class="d-flex justify-content-center gap-2">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary px-4">
                        <i class="fas fa-home me-1"></i>Back to Home
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary px-4">
                        <i class="fas fa-sign-in-alt me-1"></i>Sign In
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
