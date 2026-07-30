package com.examportal.dao;

import com.examportal.model.Result;
import com.examportal.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultDao {
    public void save(Result result) throws SQLException {
        String sql = "INSERT INTO results (candidate_id, test_id, test_name, total_questions, correct_answers, wrong_answers, score, percentage, passed) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, result.getCandidateId());
            ps.setInt(2, result.getTestId());
            ps.setString(3, result.getTestName());
            ps.setInt(4, result.getTotalQuestions());
            ps.setInt(5, result.getCorrectAnswers());
            ps.setInt(6, result.getWrongAnswers());
            ps.setInt(7, result.getScore());
            ps.setDouble(8, result.getPercentage());
            ps.setBoolean(9, result.isPassed());
            ps.executeUpdate();
        }
    }

    public List<Result> findByCandidate(int candidateId) throws SQLException {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT * FROM results WHERE candidate_id = ? ORDER BY result_id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(map(rs));
                }
            }
        }
        return results;
    }

    public Result findLatestByCandidate(int candidateId) throws SQLException {
        String sql = "SELECT * FROM results WHERE candidate_id = ? ORDER BY result_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    private Result map(ResultSet rs) throws SQLException {
        Result result = new Result();
        result.setResultId(rs.getInt("result_id"));
        result.setCandidateId(rs.getInt("candidate_id"));
        result.setTestId(rs.getInt("test_id"));
        result.setTestName(rs.getString("test_name"));
        result.setTotalQuestions(rs.getInt("total_questions"));
        result.setCorrectAnswers(rs.getInt("correct_answers"));
        result.setWrongAnswers(rs.getInt("wrong_answers"));
        result.setScore(rs.getInt("score"));
        result.setPercentage(rs.getDouble("percentage"));
        result.setPassed(rs.getBoolean("passed"));
        result.setSubmittedAt(rs.getTimestamp("submitted_at") != null ? rs.getTimestamp("submitted_at").toString() : null);
        return result;
    }
}
