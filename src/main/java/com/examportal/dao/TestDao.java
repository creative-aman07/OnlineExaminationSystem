package com.examportal.dao;

import com.examportal.model.Question;
import com.examportal.model.TestItem;
import com.examportal.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TestDao {
    // Status is computed against the database clock (NOW()) so scheduling is
    // consistent even when the app server clock drifts from the DB clock.
    private static final String STATUS_EXPR =
            "CASE WHEN start_time IS NOT NULL AND NOW() < start_time THEN 'UPCOMING' " +
            "WHEN end_time IS NOT NULL AND NOW() > end_time THEN 'CLOSED' " +
            "ELSE 'RUNNING' END AS status";

    public List<TestItem> findAllTests() throws SQLException {
        List<TestItem> tests = new ArrayList<>();
        String sql = "SELECT *, " + STATUS_EXPR + " FROM tests ORDER BY test_id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tests.add(map(rs));
            }
        }
        return tests;
    }

    /** Tests whose schedule window contains the current DB time (or that have no window). */
    public List<TestItem> findRunningTests() throws SQLException {
        List<TestItem> tests = new ArrayList<>();
        String sql = "SELECT *, " + STATUS_EXPR + " FROM tests " +
                "WHERE (start_time IS NULL OR start_time <= NOW()) " +
                "AND (end_time IS NULL OR end_time >= NOW()) " +
                "ORDER BY test_id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tests.add(map(rs));
            }
        }
        return tests;
    }

    public TestItem findById(int testId) throws SQLException {
        String sql = "SELECT *, " + STATUS_EXPR + " FROM tests WHERE test_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public List<Question> findQuestionsForTest(int testId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.* FROM questions q JOIN test_questions tq ON q.question_id = tq.question_id WHERE tq.test_id = ? ORDER BY tq.id";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    questions.add(new Question(rs.getInt("question_id"), rs.getString("subject"), rs.getString("question_text"), rs.getString("option_a"), rs.getString("option_b"), rs.getString("option_c"), rs.getString("option_d"), rs.getString("correct_answer"), rs.getInt("marks")));
                }
            }
        }
        return questions;
    }

    private TestItem map(ResultSet rs) throws SQLException {
        TestItem test = new TestItem(rs.getInt("test_id"), rs.getString("test_name"), rs.getString("subject"), rs.getInt("duration_minutes"), rs.getInt("total_questions"));
        test.setStartTime(rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toString() : null);
        test.setEndTime(rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toString() : null);
        test.setStatus(rs.getString("status"));
        return test;
    }
}
