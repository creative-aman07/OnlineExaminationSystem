<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #07111f, #15253f); color: #f3f6ff; font-family: Arial, sans-serif; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.25); }
        .form-control { background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.16); color: #fff; }
        .form-control::placeholder { color: #cfd8ff; }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="glass p-4 p-lg-5">
                <h2 class="mb-3">Candidate Registration</h2>
                <p class="text-light-emphasis">Register to access available tests and view your results.</p>
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                <% } %>
                <form method="post" action="${pageContext.request.contextPath}/candidate">
                    <input type="hidden" name="action" value="register" />
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Roll Number</label>
                        <input type="text" class="form-control" name="rollNumber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" placeholder="optional">
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Register & Continue</button>
                </form>
                <div class="mt-3 text-center">
                    <a href="${pageContext.request.contextPath}/" class="text-light">Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
