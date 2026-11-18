<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="glass p-4 p-lg-5">
                <h1 class="h2 fw-bold mb-3">Create your student account</h1>
                <p class="text-light-emphasis">Create your student account to take exams and view your results.</p>
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert"><%= request.getAttribute("error") %></div>
                <% } %>
                <form method="post" action="${pageContext.request.contextPath}/candidate">
                    <input type="hidden" name="_csrf" value="${csrfToken}" />
                    <input type="hidden" name="action" value="register" />
                    <div class="mb-3">
                        <label class="form-label" for="fullName">Full Name</label>
                        <input id="fullName" type="text" class="form-control" name="fullName" autocomplete="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="rollNumber">Roll Number</label>
                        <input id="rollNumber" type="text" class="form-control" name="rollNumber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="registrationEmail">Email</label>
                        <input id="registrationEmail" type="email" class="form-control" name="email" autocomplete="email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="registrationPassword">Password</label>
                        <input id="registrationPassword" type="password" class="form-control" name="password" autocomplete="new-password" minlength="8" placeholder="At least 8 characters" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Register & Continue</button>
                </form>
                <div class="mt-3 text-center">
                    <a href="${pageContext.request.contextPath}/login">Already have an account? Sign in</a>
                    <span class="mx-2">|</span>
                    <a href="${pageContext.request.contextPath}/">Home</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
