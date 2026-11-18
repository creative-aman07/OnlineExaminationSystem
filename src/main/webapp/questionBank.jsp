<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.Question" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Question> questions = (List<Question>) request.getAttribute("questions"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Bank Management | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <div class="glass p-4 p-lg-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <p class="small text-secondary mb-1">Administrative Question Repository</p>
                <h1 class="h2 fw-bold mb-1">Question Bank</h1>
                <p class="text-secondary mb-0">Create, view, and manage multiple-choice questions for assessments.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/faculty/dashboard.jsp" class="btn btn-outline-primary"><i class="fas fa-tachometer-alt me-1"></i>Dashboard</a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light"><i class="fas fa-home me-1"></i>Home</a>
            </div>
        </div>

        <!-- Add Question Card -->
        <div class="card p-4 border shadow-sm mb-5">
            <h5 class="fw-bold mb-3"><i class="fas fa-plus-circle me-2 text-primary"></i>Add New Question</h5>
            <form method="post" action="${pageContext.request.contextPath}/candidate">
                <input type="hidden" name="_csrf" value="${csrfToken}" />
                <input type="hidden" name="action" value="save-question" />
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label" for="questionSubject">Subject / Category</label>
                        <input id="questionSubject" class="form-control" name="subject" placeholder="e.g. Java, Web, Aptitude" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="questionMarks">Marks</label>
                        <input id="questionMarks" class="form-control" name="marks" type="number" value="1" min="1" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label" for="questionText">Question Statement</label>
                        <textarea id="questionText" class="form-control" name="questionText" rows="2" placeholder="Enter question description..." required></textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="optionA">Option A</label>
                        <input id="optionA" class="form-control" name="optionA" placeholder="First option" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="optionB">Option B</label>
                        <input id="optionB" class="form-control" name="optionB" placeholder="Second option" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="optionC">Option C</label>
                        <input id="optionC" class="form-control" name="optionC" placeholder="Third option" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="optionD">Option D</label>
                        <input id="optionD" class="form-control" name="optionD" placeholder="Fourth option" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="correctAnswer">Correct Option</label>
                        <select id="correctAnswer" class="form-select" name="correctAnswer" required>
                            <option value="" disabled selected>Select correct answer</option>
                            <option value="A">Option A</option>
                            <option value="B">Option B</option>
                            <option value="C">Option C</option>
                            <option value="D">Option D</option>
                        </select>
                    </div>
                    <div class="col-12 pt-2">
                        <button class="btn btn-primary px-4" type="submit">
                            <i class="fas fa-save me-1"></i>Save Question
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Questions List Table -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold mb-0">Existing Questions (<%= questions != null ? questions.size() : 0 %>)</h5>
        </div>

        <% if (questions == null || questions.isEmpty()) { %>
        <div class="alert alert-info">No questions in the repository yet.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th style="width: 140px">Subject</th>
                        <th>Question</th>
                        <th style="width: 100px">Correct</th>
                        <th style="width: 80px">Marks</th>
                        <th style="width: 100px">Action</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Question question : questions) { %>
                <tr>
                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><%= question.getSubject() %></span></td>
                    <td class="fw-medium"><%= question.getQuestionText() %></td>
                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">Option <%= question.getCorrectAnswer() %></span></td>
                    <td><strong><%= question.getMarks() %></strong></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/candidate" class="d-inline" onsubmit="return confirm('Delete this question permanently?');">
                            <input type="hidden" name="_csrf" value="${csrfToken}" />
                            <input type="hidden" name="action" value="delete-question" />
                            <input type="hidden" name="questionId" value="<%= question.getQuestionId() %>" />
                            <button class="btn btn-sm btn-outline-danger" type="submit">
                                <i class="fas fa-trash-alt me-1"></i>Delete
                            </button>
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
