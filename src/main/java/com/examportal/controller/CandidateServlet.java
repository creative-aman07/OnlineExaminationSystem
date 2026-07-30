package com.examportal.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.examportal.model.Candidate;
import com.examportal.model.Question;
import com.examportal.model.Result;
import com.examportal.model.TestItem;
import com.examportal.service.ExamService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/candidate", "/candidate/*"})
public class CandidateServlet extends HttpServlet {
    private final ExamService examService = new ExamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path)) {
            req.getRequestDispatcher("/jsp/candidate/register.jsp").forward(req, resp);
            return;
        }
        if ("/register".equals(path)) {
            req.getRequestDispatcher("/jsp/candidate/register.jsp").forward(req, resp);
            return;
        }
        if ("/tests".equals(path)) {
            try {
                List<TestItem> tests = examService.listTests();
                req.setAttribute("tests", tests);
                req.getRequestDispatcher("/jsp/candidate/tests.jsp").forward(req, resp);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }
        if ("/take".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("candidate") == null) {
                resp.sendRedirect(req.getContextPath() + "/candidate/register");
                return;
            }
            Candidate candidate = (Candidate) session.getAttribute("candidate");
            int testId = Integer.parseInt(req.getParameter("testId"));
            try {
                TestItem selectedTest = examService.getTest(testId);
                if (selectedTest == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                // Only tests whose schedule window contains the DB's current time can be taken.
                if (!selectedTest.isRunning()) {
                    req.setAttribute("error", "UPCOMING".equals(selectedTest.getStatus())
                            ? "This test has not started yet. It opens at " + selectedTest.getStartTime() + "."
                            : "This test is closed. It ended at " + selectedTest.getEndTime() + ".");
                    List<TestItem> tests = examService.listTests();
                    req.setAttribute("tests", tests);
                    req.getRequestDispatcher("/jsp/candidate/tests.jsp").forward(req, resp);
                    return;
                }
                if (examService.hasSubmittedAttempt(candidate.getCandidateId(), testId)) {
                    resp.sendRedirect(req.getContextPath() + "/candidate/results");
                    return;
                }
                long remainingSeconds = examService.startOrResumeAttempt(candidate.getCandidateId(), selectedTest);
                if (remainingSeconds < 0) {
                    resp.sendRedirect(req.getContextPath() + "/candidate/results");
                    return;
                }
                List<Question> questions = examService.getQuestionsForTest(testId);
                req.setAttribute("test", selectedTest);
                req.setAttribute("questions", questions);
                req.setAttribute("remainingSeconds", remainingSeconds);
                req.getRequestDispatcher("/jsp/candidate/take.jsp").forward(req, resp);
            } catch (Exception e) {
                throw new ServletException(e);
            }
            return;
        }
        if ("/results".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("candidate") == null) {
                resp.sendRedirect(req.getContextPath() + "/candidate/register");
                return;
            }
            Candidate candidate = (Candidate) session.getAttribute("candidate");
            try {
                List<Result> results = examService.getResultsForCandidate(candidate.getCandidateId());
                req.setAttribute("results", results);
                req.getRequestDispatcher("/jsp/candidate/results.jsp").forward(req, resp);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }
        if ("/analysis".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("candidate") == null) {
                resp.sendRedirect(req.getContextPath() + "/candidate/register");
                return;
            }
            Candidate candidate = (Candidate) session.getAttribute("candidate");
            try {
                Result latest = examService.getLatestResult(candidate.getCandidateId());
                req.setAttribute("latestResult", latest);
                req.getRequestDispatcher("/jsp/candidate/analysis.jsp").forward(req, resp);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("register".equals(action)) {
            registerCandidate(req, resp);
            return;
        }
        if ("submit-test".equals(action)) {
            submitTest(req, resp);
            return;
        }
        if ("save-question".equals(action)) {
            saveQuestion(req, resp);
            return;
        }
        if ("delete-question".equals(action)) {
            deleteQuestion(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }

    private void registerCandidate(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String fullName = req.getParameter("fullName");
        String rollNumber = req.getParameter("rollNumber");
        String email = req.getParameter("email");
        try {
            Candidate candidate = examService.registerCandidate(fullName, rollNumber, email);
            HttpSession session = req.getSession(true);
            session.setAttribute("candidate", candidate);
            session.setAttribute("candidateId", candidate.getCandidateId());
            resp.sendRedirect(req.getContextPath() + "/candidate/tests");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/candidate/register.jsp").forward(req, resp);
        }
    }

    private void submitTest(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("candidate") == null) {
            resp.sendRedirect(req.getContextPath() + "/candidate/register");
            return;
        }
        Candidate candidate = (Candidate) session.getAttribute("candidate");
        int testId = Integer.parseInt(req.getParameter("testId"));
        String testName = req.getParameter("testName");
        try {
            // Duplicate-submission guard is DB-backed, so it survives session loss.
            if (examService.hasSubmittedAttempt(candidate.getCandidateId(), testId)) {
                resp.sendRedirect(req.getContextPath() + "/candidate/results");
                return;
            }
            // Server-side deadline check against the DB clock (with a short grace window);
            // an expired attempt is scored with whatever answers arrived.
            boolean onTime = examService.isSubmissionOnTime(candidate.getCandidateId(), testId);
            List<Question> questions = examService.getQuestionsForTest(testId);
            String[] answers = new String[questions.size()];
            if (onTime) {
                for (int i = 0; i < questions.size(); i++) {
                    answers[i] = req.getParameter("answer_" + questions.get(i).getQuestionId());
                }
            }
            Result result = examService.evaluate(candidate.getCandidateId(), testId, testName, questions, answers);
            examService.saveResult(result);
            examService.markAttemptSubmitted(candidate.getCandidateId(), testId);
            if (!onTime) {
                req.setAttribute("timeExpired", true);
            }
            req.setAttribute("result", result);
            req.getRequestDispatcher("/jsp/candidate/result.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void saveQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            Question question = new Question();
            question.setSubject(req.getParameter("subject"));
            question.setQuestionText(req.getParameter("questionText"));
            question.setOptionA(req.getParameter("optionA"));
            question.setOptionB(req.getParameter("optionB"));
            question.setOptionC(req.getParameter("optionC"));
            question.setOptionD(req.getParameter("optionD"));
            question.setCorrectAnswer(req.getParameter("correctAnswer"));
            question.setMarks(Integer.parseInt(req.getParameter("marks")));
            examService.saveQuestion(question);
            resp.sendRedirect(req.getContextPath() + "/question-bank");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void deleteQuestion(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            examService.deleteQuestion(Integer.parseInt(req.getParameter("questionId")));
            resp.sendRedirect(req.getContextPath() + "/question-bank");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
