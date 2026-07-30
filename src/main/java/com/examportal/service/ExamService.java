package com.examportal.service;

import java.sql.SQLException;
import java.util.List;
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

    public Candidate registerCandidate(String fullName, String rollNumber, String email) throws SQLException {
        if (fullName == null || fullName.isBlank() || rollNumber == null || rollNumber.isBlank()) {
            throw new IllegalArgumentException("Name and roll number are required.");
        }
        Optional<Candidate> existing = candidateDao.findByRollNumber(rollNumber);
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Roll number is already registered.");
        }
        Candidate candidate = new Candidate();
        candidate.setFullName(fullName.trim());
        candidate.setRollNumber(rollNumber.trim().toUpperCase());
        candidate.setEmail(email == null ? "" : email.trim());
        return candidateDao.save(candidate);
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
}
