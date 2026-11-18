<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body class="auth-body py-4">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" style="text-decoration:none">
                    <h3 class="fw-bold mb-0 text-primary">
                        <i class="fas fa-graduation-cap me-2 text-primary"></i>Exam<span class="gradient-text">Portal</span>
                    </h3>
                </a>
            </div>

            <div class="glass-card p-4 p-md-5">
                <h1 class="h4 fw-bold mb-1">Create Student Account</h1>
                <p class="text-secondary small mb-4">Register your account to access scheduled examinations and view test performance.</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 small" role="alert">
                    <i class="fas fa-exclamation-triangle me-1"></i><%= request.getAttribute("error") %>
                </div>
                <% } %>

                <form method="post" action="${pageContext.request.contextPath}/candidate">
                    <input type="hidden" name="_csrf" value="${csrfToken}" />
                    <input type="hidden" name="action" value="register" />
                    
                    <div class="mb-3">
                        <label class="form-label" for="fullName">Full Name</label>
                        <input id="fullName" type="text" class="form-control" name="fullName" autocomplete="name" placeholder="John Doe" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label" for="rollNumber">Roll / Student ID Number</label>
                        <input id="rollNumber" type="text" class="form-control" name="rollNumber" placeholder="e.g. STU202601" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="registrationEmail">Email Address</label>
                        <input id="registrationEmail" type="email" class="form-control" name="email" autocomplete="email" placeholder="john@example.com" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="registrationPassword">Password</label>
                        <input id="registrationPassword" type="password" class="form-control" name="password" autocomplete="new-password" minlength="8" placeholder="At least 8 characters" required>
                    </div>

                    <button type="submit" class="btn btn-cyber login-submit mb-3">
                        <i class="fas fa-user-plus me-2"></i>Register &amp; Proceed
                    </button>
                </form>

                <hr class="my-4" style="border-color: var(--border)" />
                <div class="text-center small">
                    <span class="text-secondary">Already have an account?</span>
                    <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-decoration-none ms-1">Sign In</a>
                    <span class="mx-2 text-secondary">&middot;</span>
                    <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none">Home</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
