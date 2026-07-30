<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.Question" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Question> questions = (List<Question>) request.getAttribute("questions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #07111f, #15253f); color: #f3f6ff; font-family: Arial, sans-serif; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.25); }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">Question Bank</h2>
                <p class="text-light-emphasis mb-0">Manage multiple-choice questions and answers.</p>
            </div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light">Home</a>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/candidate" class="card bg-dark text-light p-3 mb-4">
            <input type="hidden" name="action" value="save-question" />
            <div class="row g-3">
                <div class="col-md-6"><input class="form-control" name="subject" placeholder="Subject" required></div>
                <div class="col-md-6"><input class="form-control" name="marks" type="number" value="1" min="1" required></div>
                <div class="col-12"><textarea class="form-control" name="questionText" placeholder="Question" rows="2" required></textarea></div>
                <div class="col-md-6"><input class="form-control" name="optionA" placeholder="Option A" required></div>
                <div class="col-md-6"><input class="form-control" name="optionB" placeholder="Option B" required></div>
                <div class="col-md-6"><input class="form-control" name="optionC" placeholder="Option C" required></div>
                <div class="col-md-6"><input class="form-control" name="optionD" placeholder="Option D" required></div>
                <div class="col-md-6"><input class="form-control" name="correctAnswer" placeholder="Correct Answer (A-D)" required></div>
                <div class="col-12"><button class="btn btn-primary" type="submit">Add Question</button></div>
            </div>
        </form>
        <% if (questions == null || questions.isEmpty()) { %>
        <div class="alert alert-info">No questions yet.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-dark table-striped align-middle">
                <thead><tr><th>Subject</th><th>Question</th><th>Correct</th><th>Marks</th><th>Action</th></tr></thead>
                <tbody>
                <% for (Question question : questions) { %>
                <tr>
                    <td><%= question.getSubject() %></td>
                    <td><%= question.getQuestionText() %></td>
                    <td><%= question.getCorrectAnswer() %></td>
                    <td><%= question.getMarks() %></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/candidate" class="d-inline">
                            <input type="hidden" name="action" value="delete-question" />
                            <input type="hidden" name="questionId" value="<%= question.getQuestionId() %>" />
                            <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
