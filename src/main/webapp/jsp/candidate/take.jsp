<%@ page import="java.util.List" %>
<%@ page import="com.examportal.model.Question" %>
<%@ page import="com.examportal.model.TestItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% TestItem test = (TestItem) request.getAttribute("test");
   List<Question> questions = (List<Question>) request.getAttribute("questions");
   Long remainingSeconds = (Long) request.getAttribute("remainingSeconds");
   long remaining = remainingSeconds != null ? remainingSeconds : (test != null ? test.getDurationMinutes() * 60L : 0L); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= test != null ? test.getTestName() : "Take Test" %> | ExamPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/app-theme.css" rel="stylesheet">
</head>
<body>
<main class="container py-4 py-lg-5">
    <header class="exam-panel exam-header p-3 p-md-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <p class="small text-secondary mb-1"><i class="fas fa-edit me-1 text-primary"></i>Examination in progress</p>
                <h1 class="h3 fw-bold mb-1"><%= test != null ? test.getTestName() : "Test" %></h1>
                <p class="text-secondary mb-0">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle me-2"><%= test != null ? test.getSubject() : "" %></span>
                    <i class="far fa-clock me-1"></i><%= test != null ? test.getDurationMinutes() : 0 %> minutes
                </p>
            </div>
            <div class="text-md-end">
                <span class="small text-secondary d-block mb-1">Time Remaining</span>
                <div id="timer" class="badge bg-primary fs-5 px-3 py-2" role="timer" aria-live="off">--:--</div>
            </div>
        </div>
    </header>

    <% if (questions == null || questions.isEmpty()) { %>
    <div class="glass p-5 text-center">
        <i class="fas fa-exclamation-circle text-warning fs-1 mb-3"></i>
        <h4 class="fw-bold">No Questions in this Assessment</h4>
        <p class="text-secondary mb-4">This exam currently does not have any questions assigned. Please check back later or contact your administrator.</p>
        <a href="${pageContext.request.contextPath}/candidate/tests" class="btn btn-primary">Back to Available Tests</a>
    </div>
    <% } else { %>
    <form method="post" action="${pageContext.request.contextPath}/candidate" id="examForm">
        <input type="hidden" name="_csrf" value="${csrfToken}" />
        <input type="hidden" name="action" value="submit-test" />
        <input type="hidden" name="testId" value="<%= test != null ? test.getTestId() : 0 %>" />
        <input type="hidden" name="testName" value="<%= test != null ? test.getTestName() : "" %>" />

        <div class="exam-layout">
            <section class="exam-panel p-3 p-md-4" aria-label="Examination questions">
                <p class="small text-secondary mb-3">Select one answer for each question. You can review or change answers at any time before submitting.</p>
                <% for (int i = 0; i < questions.size(); i++) {
                    Question question = questions.get(i); %>
                <article class="exam-question <%= i == 0 ? "is-active" : "" %>" data-question-index="<%= i %>" aria-hidden="<%= i == 0 ? "false" : "true" %>">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="badge text-bg-light border px-2 py-1">Question <%= i + 1 %> of <%= questions.size() %></span>
                        <span class="small text-secondary fw-semibold"><%= question.getMarks() %> <%= question.getMarks() == 1 ? "mark" : "marks" %></span>
                    </div>
                    <h2 class="h5 fw-semibold mb-4"><%= question.getQuestionText() %></h2>
                    <fieldset class="border-0 p-0 m-0">
                        <legend class="visually-hidden">Answer options for question <%= i + 1 %></legend>
                        <div class="d-grid gap-2">
                            <div class="option-card exam-option">
                                <input id="answer_<%= question.getQuestionId() %>_A" type="radio" name="answer_<%= question.getQuestionId() %>" value="A">
                                <label for="answer_<%= question.getQuestionId() %>_A" class="w-100"><span class="fw-bold me-2">A.</span><%= question.getOptionA() %></label>
                            </div>
                            <div class="option-card exam-option">
                                <input id="answer_<%= question.getQuestionId() %>_B" type="radio" name="answer_<%= question.getQuestionId() %>" value="B">
                                <label for="answer_<%= question.getQuestionId() %>_B" class="w-100"><span class="fw-bold me-2">B.</span><%= question.getOptionB() %></label>
                            </div>
                            <div class="option-card exam-option">
                                <input id="answer_<%= question.getQuestionId() %>_C" type="radio" name="answer_<%= question.getQuestionId() %>" value="C">
                                <label for="answer_<%= question.getQuestionId() %>_C" class="w-100"><span class="fw-bold me-2">C.</span><%= question.getOptionC() %></label>
                            </div>
                            <div class="option-card exam-option">
                                <input id="answer_<%= question.getQuestionId() %>_D" type="radio" name="answer_<%= question.getQuestionId() %>" value="D">
                                <label for="answer_<%= question.getQuestionId() %>_D" class="w-100"><span class="fw-bold me-2">D.</span><%= question.getOptionD() %></label>
                            </div>
                        </div>
                    </fieldset>
                </article>
                <% } %>
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 border-top pt-3 mt-4">
                    <button class="btn btn-outline-primary" type="button" id="previousQuestion"><i class="fas fa-chevron-left me-1"></i>Previous</button>
                    <button class="btn btn-outline-warning" type="button" id="markForReview" aria-pressed="false"><i class="fas fa-bookmark me-1"></i>Mark for review</button>
                    <button class="btn btn-primary" type="button" id="nextQuestion">Next question<i class="fas fa-chevron-right ms-1"></i></button>
                </div>
            </section>

            <aside class="exam-panel exam-sidebar p-3 p-md-4" aria-label="Question navigation">
                <h2 class="h6 fw-bold mb-1">Question Navigator</h2>
                <p class="small text-secondary mb-3"><span id="answeredCount" class="fw-bold">0</span> of <%= questions.size() %> answered</p>
                <div class="question-nav mb-3">
                    <% for (int i = 0; i < questions.size(); i++) { %>
                    <button type="button" class="<%= i == 0 ? "is-current" : "" %>" data-go-question="<%= i %>" aria-label="Go to question <%= i + 1 %>" aria-current="<%= i == 0 ? "step" : "false" %>"><%= i + 1 %></button>
                    <% } %>
                </div>
                <div class="small d-grid gap-2 mb-4" aria-label="Question status legend">
                    <span><i class="d-inline-block rounded-circle bg-success me-2" style="width:9px;height:9px"></i>Answered</span>
                    <span><i class="d-inline-block rounded-circle border me-2" style="width:9px;height:9px;background:#fff"></i>Unanswered</span>
                    <span><i class="d-inline-block rounded-circle me-2" style="width:9px;height:9px;background:#F59E0B"></i>Marked for review</span>
                </div>
                <button class="btn btn-primary w-100" type="button" id="submitExam"><i class="fas fa-paper-plane me-2"></i>Submit Examination</button>
                <p class="small text-secondary mt-2 mb-0">Submissions are verified against the examination deadline on the server.</p>
            </aside>
        </div>
    </form>
    <% } %>
</main>

<dialog class="exam-dialog" id="submitDialog" aria-labelledby="submitDialogTitle">
    <h2 class="h5 fw-bold" id="submitDialogTitle">Submit Examination?</h2>
    <p class="text-secondary"><span id="submitWarning">You won’t be able to change your answers after submitting.</span></p>
    <div class="d-flex justify-content-end gap-2 mt-4">
        <button class="btn btn-outline-primary" type="button" id="cancelSubmit">Continue Examination</button>
        <button class="btn btn-primary" type="button" id="confirmSubmit">Submit Answers</button>
    </div>
</dialog>

<script>
    (function () {
        var remaining = <%= remaining %>;
        var timerEl = document.getElementById('timer');
        var form = document.getElementById('examForm');
        var questions = Array.prototype.slice.call(document.querySelectorAll('.exam-question'));
        var navButtons = Array.prototype.slice.call(document.querySelectorAll('[data-go-question]'));
        var dialog = document.getElementById('submitDialog');
        var current = 0;
        var submitted = false;
        var confirmed = false;
        var reviewed = {};
        var deadline = Date.now() + remaining * 1000;

        function updateNavigation() {
            var answered = 0;
            questions.forEach(function (question, index) {
                var hasAnswer = !!question.querySelector('input[type="radio"]:checked');
                if (hasAnswer) answered++;
                var button = navButtons[index];
                if (button) {
                    button.classList.toggle('is-answered', hasAnswer);
                    button.classList.toggle('is-review', !!reviewed[index]);
                    button.classList.toggle('is-current', index === current);
                    button.setAttribute('aria-current', index === current ? 'step' : 'false');
                    var status = hasAnswer ? 'answered' : 'unanswered';
                    if (reviewed[index]) status += ', marked for review';
                    button.setAttribute('aria-label', 'Go to question ' + (index + 1) + ', ' + status);
                }
            });
            var el = document.getElementById('answeredCount');
            if (el) el.textContent = answered;
            var unanswered = questions.length - answered;
            var warn = document.getElementById('submitWarning');
            if (warn) {
                warn.textContent = unanswered
                    ? 'You have ' + unanswered + ' unanswered ' + (unanswered === 1 ? 'question' : 'questions') + '. You won’t be able to change your answers after submitting.'
                    : 'You won’t be able to change your answers after submitting.';
            }
        }

        function showQuestion(index) {
            if (!questions.length) return;
            current = Math.max(0, Math.min(index, questions.length - 1));
            questions.forEach(function (question, questionIndex) {
                var active = questionIndex === current;
                question.classList.toggle('is-active', active);
                question.setAttribute('aria-hidden', active ? 'false' : 'true');
            });
            var prevBtn = document.getElementById('previousQuestion');
            var nextBtn = document.getElementById('nextQuestion');
            if (prevBtn) prevBtn.disabled = current === 0;
            if (nextBtn) nextBtn.disabled = current === questions.length - 1;
            var reviewButton = document.getElementById('markForReview');
            if (reviewButton) {
                reviewButton.setAttribute('aria-pressed', reviewed[current] ? 'true' : 'false');
                reviewButton.innerHTML = reviewed[current]
                    ? '<i class="fas fa-bookmark me-1"></i>Remove review mark'
                    : '<i class="far fa-bookmark me-1"></i>Mark for review';
            }
            updateNavigation();
        }

        if (form && questions.length > 0) {
            navButtons.forEach(function (button) {
                button.addEventListener('click', function () { showQuestion(Number(button.getAttribute('data-go-question'))); });
            });
            form.addEventListener('change', updateNavigation);
            var prevBtn = document.getElementById('previousQuestion');
            var nextBtn = document.getElementById('nextQuestion');
            var reviewBtn = document.getElementById('markForReview');
            var submitBtn = document.getElementById('submitExam');
            var cancelBtn = document.getElementById('cancelSubmit');
            var confirmBtn = document.getElementById('confirmSubmit');

            if (prevBtn) prevBtn.addEventListener('click', function () { showQuestion(current - 1); });
            if (nextBtn) nextBtn.addEventListener('click', function () { showQuestion(current + 1); });
            if (reviewBtn) reviewBtn.addEventListener('click', function () {
                reviewed[current] = !reviewed[current];
                showQuestion(current);
            });
            if (submitBtn && dialog) submitBtn.addEventListener('click', function () { dialog.showModal(); });
            if (cancelBtn && dialog) cancelBtn.addEventListener('click', function () { dialog.close(); });
            if (confirmBtn) confirmBtn.addEventListener('click', function () {
                confirmed = true;
                submitted = true;
                if (dialog) dialog.close();
                form.requestSubmit();
            });
            form.addEventListener('submit', function (event) {
                if (!confirmed) {
                    event.preventDefault();
                    if (dialog) dialog.showModal();
                }
            });

            function render(seconds) {
                var minutes = Math.floor(seconds / 60);
                var remainder = seconds % 60;
                if (timerEl) {
                    timerEl.textContent = (minutes < 10 ? '0' : '') + minutes + ':' + (remainder < 10 ? '0' : '') + remainder;
                    timerEl.classList.toggle('warning', seconds <= 300 && seconds > 60);
                    timerEl.classList.toggle('danger', seconds <= 60);
                }
            }

            function tick() {
                var seconds = Math.max(0, Math.round((deadline - Date.now()) / 1000));
                render(seconds);
                if (seconds <= 0 && !submitted) {
                    confirmed = true;
                    submitted = true;
                    form.requestSubmit();
                    return;
                }
                window.setTimeout(tick, 250);
            }

            showQuestion(0);
            render(remaining);
            tick();
        }
    })();
</script>
</body>
</html>
