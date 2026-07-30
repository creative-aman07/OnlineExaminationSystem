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
    <style>
        body { background: linear-gradient(135deg, #07111f 0%, #0d1b2a 40%, #15253f 100%); color: #f3f6ff; font-family: 'Inter', Arial, sans-serif; min-height: 100vh; display: flex; align-items: center; }
        .glass-card { background: rgba(255,255,255,0.06); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; box-shadow: 0 12px 40px rgba(0,0,0,0.3); }
        .form-control { background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.12); color: #f3f6ff; border-radius: 10px; }
        .form-control:focus { background: rgba(255,255,255,0.1); border-color: #4f7cff; color: #f3f6ff; box-shadow: 0 0 0 3px rgba(79,124,255,0.2); }
        .btn-cyber { background: linear-gradient(135deg, #4f7cff, #7a5cff); color: white; border: none; border-radius: 12px; padding: 12px 28px; font-weight: 600; width: 100%; transition: all 0.3s ease; }
        .btn-cyber:hover { color: white; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(79,124,255,0.4); }
        .form-label { color: rgba(255,255,255,0.7); font-weight: 500; font-size: 0.9rem; }
        .gradient-text { background: linear-gradient(135deg, #4f7cff, #00d9ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" style="text-decoration:none">
                    <h3 class="fw-bold text-white"><i class="fas fa-graduation-cap me-2" style="color:#4f7cff"></i>Exam<span class="gradient-text">Portal</span></h3>
                </a>
            </div>
            <div class="glass-card p-4 p-md-5">
                <h4 class="fw-bold mb-1">Welcome Back</h4>
                <p class="text-secondary small mb-4">Sign in to your account</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 small"><i class="fas fa-exclamation-triangle me-1"></i><%= request.getAttribute("error") %></div>
                <% } %>

                <form method="post" action="${pageContext.request.contextPath}/login">
                    <div class="mb-3">
                        <label class="form-label">Email address</label>
                        <input type="text" class="form-control" name="email" placeholder="your@email.com" required />
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" placeholder="••••••••" required />
                    </div>
                    <button type="submit" class="btn btn-cyber mb-3"><i class="fas fa-sign-in-alt me-2"></i>Sign In</button>
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none small"><i class="fas fa-arrow-left me-1"></i>Back to Home</a>
                    </div>
                </form>

                <hr style="border-color: rgba(255,255,255,0.1)" />
                <div class="text-center">
                    <p class="small text-secondary mb-1"><i class="fas fa-key me-1"></i>Demo Credentials:</p>
                    <p class="small mb-0">
                        <span class="badge bg-primary bg-opacity-25 text-primary-emphasis">Admin: admin@exam.com</span>
                        <span class="badge bg-success bg-opacity-25 text-success-emphasis">Student: student@exam.com</span>
                    </p>
                    <p class="small text-secondary mt-1">Password: <code>password123</code></p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
