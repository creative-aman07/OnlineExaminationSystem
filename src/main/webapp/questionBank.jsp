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
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 fw-bold mb-1">Question Bank</h1>
                <p class="text-light-emphasis mb-0">Manage multiple-choice questions and answers.</p>
            </div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light">Home</a>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/candidate" class="card bg-dark text-light p-3 mb-4">
            <input type="hidden" name="_csrf" value="${csrfToken}" />
            <input type="hidden" name="action" value="save-question" />
            <div class="row g-3">
                <div class="col-md-6"><label class="form-label" for="questionSubject">Subject</label><input id="questionSubject" class="form-control" name="subject" required></div>
                <div class="col-md-6"><label class="form-label" for="questionMarks">Marks</label><input id="questionMarks" class="form-control" name="marks" type="number" value="1" min="1" required></div>
                <div class="col-12"><label class="form-label" for="questionText">Question</label><textarea id="questionText" class="form-control" name="questionText" rows="2" required></textarea></div>
                <div class="col-md-6"><label class="form-label" for="optionA">Option A</label><input id="optionA" class="form-control" name="optionA" required></div>
                <div class="col-md-6"><label class="form-label" for="optionB">Option B</label><input id="optionB" class="form-control" name="optionB" required></div>
                <div class="col-md-6"><label class="form-label" for="optionC">Option C</label><input id="optionC" class="form-control" name="optionC" required></div>
                <div class="col-md-6"><label class="form-label" for="optionD">Option D</label><input id="optionD" class="form-control" name="optionD" required></div>
                <div class="col-md-6"><label class="form-label" for="correctAnswer">Correct answer (A–D)</label><input id="correctAnswer" class="form-control" name="correctAnswer" placeholder="A, B, C, or D" required></div>
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
                            <input type="hidden" name="_csrf" value="${csrfToken}" />
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
