package com.examportal.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.examportal.dao.CandidateDao;
import com.examportal.dao.ExamAttemptDao;
import com.examportal.dao.QuestionDao;
import com.examportal.dao.ResultDao;
import com.examportal.dao.TestDao;
import com.examportal.model.Candidate;
import com.examportal.model.Question;
import com.examportal.model.Result;
import com.examportal.model.TestItem;

public class ExamService {
    private final CandidateDao candidateDao = new CandidateDao();
    private final QuestionDao questionDao = new QuestionDao();
    private final TestDao testDao = new TestDao();
    private final ResultDao resultDao = new ResultDao();
    private final ExamAttemptDao attemptDao = new ExamAttemptDao();

    public Candidate registerCandidate(String fullName, String rollNumber, String email, String password) throws SQLException {
        if (fullName == null || fullName.isBlank() || rollNumber == null || rollNumber.isBlank()) {
            throw new IllegalArgumentException("Name and roll number are required.");
        }
        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            throw new IllegalArgumentException("A valid email address is required.");
        }
        Optional<Candidate> existingRoll = candidateDao.findByRollNumber(rollNumber.trim().toUpperCase());
        if (existingRoll.isPresent()) throw new IllegalArgumentException("Roll number is already registered.");
        
        Optional<Candidate> existingEmail = candidateDao.findByEmail(email.trim().toLowerCase());
        if (existingEmail.isPresent()) throw new IllegalArgumentException("Email address is already registered. Please sign in.");

        if (password == null || password.length() < 8) throw new IllegalArgumentException("Password must be at least 8 characters.");
        Candidate candidate = new Candidate();
        candidate.setFullName(fullName.trim());
        candidate.setRollNumber(rollNumber.trim().toUpperCase());
        candidate.setEmail(email.trim().toLowerCase());
        return candidateDao.save(candidate, password);
    }

    public Candidate findOrCreateCandidateForUser(String email) throws SQLException {
        return candidateDao.findOrCreateForUser(email);
    }

    public List<Question> listQuestions() throws SQLException {
        return questionDao.findAll();
    }

    public Question saveQuestion(Question question) throws SQLException {
        return questionDao.save(question);
    }

    public Question updateQuestion(Question question) throws SQLException {
        questionDao.update(question);
        return question;
    }

    public void deleteQuestion(int questionId) throws SQLException {
        questionDao.delete(questionId);
    }

    public List<TestItem> listTests() throws SQLException {
        return testDao.findAllTests();
    }

    /** Only tests whose schedule window contains the current database time. */
    public List<TestItem> listRunningTests() throws SQLException {
        return testDao.findRunningTests();
    }

    public TestItem getTest(int testId) throws SQLException {
        return testDao.findById(testId);
    }

    /**
     * Starts (or resumes) a timed attempt and returns the remaining seconds,
     * computed by the database clock. -1 means the attempt was already submitted.
     */
    public long startOrResumeAttempt(int candidateId, TestItem test) throws SQLException {
        return attemptDao.startOrResume(candidateId, test.getTestId(), test.getDurationMinutes());
    }

    /** True if a submission arriving now is still inside the attempt's deadline. */
    public boolean isSubmissionOnTime(int candidateId, int testId) throws SQLException {
        return attemptDao.isWithinDeadline(candidateId, testId, 15);
    }

    public void markAttemptSubmitted(int candidateId, int testId) throws SQLException {
        attemptDao.markSubmitted(candidateId, testId);
    }

    public boolean hasSubmittedAttempt(int candidateId, int testId) throws SQLException {
        return attemptDao.hasSubmitted(candidateId, testId);
    }

    public List<Question> getQuestionsForTest(int testId) throws SQLException {
        return testDao.findQuestionsForTest(testId);
    }

    public Result evaluate(int candidateId, int testId, String testName, List<Question> questions, String[] answers) {
        int correct = 0;
        int wrong = 0;
        int score = 0;
        int totalMarks = 0;
        for (int i = 0; i < questions.size(); i++) {
            Question question = questions.get(i);
            totalMarks += question.getMarks();
            String selected = answers != null && i < answers.length ? answers[i] : "";
            if (selected != null && selected.equalsIgnoreCase(question.getCorrectAnswer())) {
                correct++;
                score += question.getMarks();
            } else if (selected != null && !selected.isBlank()) {
                wrong++;
            }
        }
        int totalQuestions = questions.size();
        double percentage = totalMarks == 0 ? 0 : ((double) score / totalMarks) * 100;
        Result result = new Result();
        result.setCandidateId(candidateId);
        result.setTestId(testId);
        result.setTestName(testName);
        result.setTotalQuestions(totalQuestions);
        result.setCorrectAnswers(correct);
        result.setWrongAnswers(wrong);
        result.setScore(score);
        result.setPercentage(percentage);
        result.setPassed(percentage >= 40.0);
        return result;
    }

    public void saveResult(Result result) throws SQLException {
        resultDao.save(result);
    }

    public List<Result> getResultsForCandidate(int candidateId) throws SQLException {
        return resultDao.findByCandidate(candidateId);
    }

    public Result getLatestResult(int candidateId) throws SQLException {
        return resultDao.findLatestByCandidate(candidateId);
    }

    public Optional<Candidate> findCandidateByRollNumber(String rollNumber) throws SQLException {
        return candidateDao.findByRollNumber(rollNumber);
    }

    public Candidate getCandidate(int candidateId) throws SQLException {
        return candidateDao.findById(candidateId);
    }

    // Dashboard Statistics helpers
    public int countTotalTests() throws SQLException {
        return testDao.countAll();
    }

    public int countTotalQuestions() throws SQLException {
        return questionDao.countAll();
    }

    public int countTotalCandidates() throws SQLException {
        return candidateDao.countAll();
    }

    public int countTotalSubmissions() throws SQLException {
        return resultDao.countAll();
    }

    public List<Result> listRecentSubmissions(int limit) throws SQLException {
        return resultDao.findAllRecent(limit);
    }

    public Map<String, Object> getStudentDashboardStats(int candidateId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        List<TestItem> runningTests = testDao.findRunningTests();
        List<Result> candidateResults = resultDao.findByCandidate(candidateId);
        
        int availableExams = runningTests.size();
        int completedExams = candidateResults.size();
        double avgScore = 0.0;
        double bestScore = 0.0;

        if (!candidateResults.isEmpty()) {
            double sum = 0.0;
            for (Result r : candidateResults) {
                sum += r.getPercentage();
                if (r.getPercentage() > bestScore) {
                    bestScore = r.getPercentage();
                }
            }
            avgScore = sum / candidateResults.size();
        }

        stats.put("availableExams", availableExams);
        stats.put("completedExams", completedExams);
        stats.put("avgScore", String.format("%.1f", avgScore));
        stats.put("bestScore", String.format("%.1f", bestScore));
        return stats;
    }

    public Map<String, Object> getFacultyDashboardStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalTests", testDao.countAll());
        stats.put("totalQuestions", questionDao.countAll());
        stats.put("totalCandidates", candidateDao.countAll());
        stats.put("totalSubmissions", resultDao.countAll());
        return stats;
    }
}
