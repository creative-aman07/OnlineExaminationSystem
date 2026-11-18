package com.examportal;

import com.examportal.listener.DatabaseInitializer;
import com.examportal.model.Candidate;
import com.examportal.model.Question;
import com.examportal.model.Result;
import com.examportal.model.TestItem;
import com.examportal.service.ExamService;
import com.examportal.util.AuthUtil;
import com.examportal.util.DBConnection;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

public class ExamSystemTest {
    private static ExamService examService;

    @BeforeAll
    public static void setUp() {
        // Initialize database with schema and demo data
        DatabaseInitializer initializer = new DatabaseInitializer();
        initializer.contextInitialized(null);
        examService = new ExamService();
    }

    @Test
    public void testDatabaseConnection() throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            assertNotNull(conn, "Connection should not be null");
            assertFalse(conn.isClosed(), "Connection should be open");
        }
    }

    @Test
    public void testDemoAccountsCreated() throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            // Check Admin user
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE email = ?")) {
                ps.setString(1, "admin@exam.com");
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next(), "Admin user must exist");
                    assertEquals(1, rs.getInt("role_id"), "Admin role_id must be 1");
                    assertTrue(AuthUtil.verifyPassword("password123", rs.getString("password_hash")), "Admin password must verify");
                }
            }

            // Check Student user
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE email = ?")) {
                ps.setString(1, "student@exam.com");
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next(), "Student user must exist");
                    assertEquals(2, rs.getInt("role_id"), "Student role_id must be 2");
                    assertTrue(rs.getInt("candidate_id") > 0, "Student must have a linked candidate_id");
                    assertTrue(AuthUtil.verifyPassword("password123", rs.getString("password_hash")), "Student password must verify");
                }
            }
        }
    }

    @Test
    public void testDemoExamsAndQuestionsExist() throws Exception {
        List<TestItem> tests = examService.listTests();
        assertNotNull(tests);
        assertTrue(tests.size() >= 3, "At least 3 demo tests should exist");

        // Verify Test 1 (Java)
        TestItem javaTest = examService.getTest(1);
        assertNotNull(javaTest);
        assertEquals("Java Full Stack & Core Programming", javaTest.getTestName());
        assertTrue(javaTest.isRunning(), "Demo test should be currently RUNNING");

        List<Question> javaQuestions = examService.getQuestionsForTest(1);
        assertEquals(6, javaQuestions.size(), "Java test must have 6 questions");

        // Verify Test 2 (Web & Databases)
        TestItem webTest = examService.getTest(2);
        assertNotNull(webTest);
        assertEquals("Web Technologies & Database Systems", webTest.getTestName());
        assertTrue(webTest.isRunning());

        List<Question> webQuestions = examService.getQuestionsForTest(2);
        assertEquals(5, webQuestions.size(), "Web test must have 5 questions");

        // Verify Test 3 (Aptitude)
        TestItem aptTest = examService.getTest(3);
        assertNotNull(aptTest);
        assertEquals("General Aptitude & Logical Reasoning", aptTest.getTestName());
        assertTrue(aptTest.isRunning());

        List<Question> aptQuestions = examService.getQuestionsForTest(3);
        assertEquals(5, aptQuestions.size(), "Aptitude test must have 5 questions");
    }

    @Test
    public void testExamEvaluationAndScoring() throws Exception {
        List<Question> questions = examService.getQuestionsForTest(1);
        assertNotNull(questions);
        assertEquals(6, questions.size());

        // Correct answers for Test 1: A, C, B, A, C, B
        String[] allCorrect = {"A", "C", "B", "A", "C", "B"};
        Result perfectResult = examService.evaluate(999, 1, "Java Test", questions, allCorrect);
        assertEquals(6, perfectResult.getScore());
        assertEquals(6, perfectResult.getCorrectAnswers());
        assertEquals(0, perfectResult.getWrongAnswers());
        assertEquals(100.0, perfectResult.getPercentage());
        assertTrue(perfectResult.isPassed());

        // 3 correct, 3 wrong
        String[] halfCorrect = {"A", "C", "B", "D", "D", "D"};
        Result halfResult = examService.evaluate(999, 1, "Java Test", questions, halfCorrect);
        assertEquals(3, halfResult.getScore());
        assertEquals(3, halfResult.getCorrectAnswers());
        assertEquals(3, halfResult.getWrongAnswers());
        assertEquals(50.0, halfResult.getPercentage());
        assertTrue(halfResult.isPassed());

        // All wrong
        String[] allWrong = {"D", "D", "D", "D", "D", "D"};
        Result failResult = examService.evaluate(999, 1, "Java Test", questions, allWrong);
        assertEquals(0, failResult.getScore());
        assertEquals(0, failResult.getCorrectAnswers());
        assertEquals(6, failResult.getWrongAnswers());
        assertEquals(0.0, failResult.getPercentage());
        assertFalse(failResult.isPassed());
    }

    @Test
    public void testCandidateRegistrationAndDuplicatePrevention() throws Exception {
        String testRoll = "TEST-ROLL-" + System.currentTimeMillis();
        String testEmail = "testuser" + System.currentTimeMillis() + "@example.com";
        
        Candidate registered = examService.registerCandidate("Test User", testRoll, testEmail, "SecurePass123");
        assertNotNull(registered);
        assertTrue(registered.getCandidateId() > 0);

        // Attempt duplicate roll number
        assertThrows(IllegalArgumentException.class, () -> {
            examService.registerCandidate("Duplicate Roll", testRoll, "other" + System.currentTimeMillis() + "@example.com", "SecurePass123");
        });

        // Attempt duplicate email
        assertThrows(IllegalArgumentException.class, () -> {
            examService.registerCandidate("Duplicate Email", "OTHER-ROLL-" + System.currentTimeMillis(), testEmail, "SecurePass123");
        });
    }

    @Test
    public void testDashboardStatistics() throws Exception {
        // Faculty stats
        Map<String, Object> facultyStats = examService.getFacultyDashboardStats();
        assertNotNull(facultyStats);
        assertTrue((Integer) facultyStats.get("totalTests") >= 3);
        assertTrue((Integer) facultyStats.get("totalQuestions") >= 16);
        assertTrue((Integer) facultyStats.get("totalCandidates") >= 1);

        // Student stats for demo candidate (STUDENT001)
        Optional<Candidate> demoCandidate = examService.findCandidateByRollNumber("STUDENT001");
        assertTrue(demoCandidate.isPresent());

        Map<String, Object> studentStats = examService.getStudentDashboardStats(demoCandidate.get().getCandidateId());
        assertNotNull(studentStats);
        assertTrue((Integer) studentStats.get("availableExams") >= 3);
    }
}
