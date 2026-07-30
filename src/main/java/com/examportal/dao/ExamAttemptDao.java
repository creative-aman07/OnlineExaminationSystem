package com.examportal.dao;

import com.examportal.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Tracks when a candidate started a test and when their time runs out.
 * All timestamps come from the database clock (NOW()) so the countdown and
 * the server-side deadline check can never disagree because of clock drift.
 *
 * SQL is written using TIMESTAMPADD / TIMESTAMPDIFF which work on both
 * MySQL 8.x and H2 (in MySQL compatibility mode).
 */
public class ExamAttemptDao {

    /**
     * Starts an attempt if none exists, then returns the remaining seconds for it.
     * Returns -1 if the attempt was already submitted, otherwise seconds remaining
     * (clamped at 0 when the deadline has passed).
     */
    public long startOrResume(int candidateId, int testId, int durationMinutes) throws SQLException {
        // MERGE works in both H2 (MySQL mode) and MySQL 8+
        // First try an INSERT; if the row already exists do nothing.
        String checkExisting = "SELECT attempt_id FROM exam_attempts WHERE candidate_id = ? AND test_id = ?";
        String insert = "INSERT INTO exam_attempts (candidate_id, test_id, started_at, deadline) " +
                "VALUES (?, ?, NOW(), TIMESTAMPADD(MINUTE, ?, NOW()))";
        String select = "SELECT submitted, GREATEST(0, TIMESTAMPDIFF(SECOND, NOW(), deadline)) AS remaining " +
                "FROM exam_attempts WHERE candidate_id = ? AND test_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            // Only insert if no row exists (idempotent)
            boolean exists;
            try (PreparedStatement ps = conn.prepareStatement(checkExisting)) {
                ps.setInt(1, candidateId);
                ps.setInt(2, testId);
                try (ResultSet rs = ps.executeQuery()) {
                    exists = rs.next();
                }
            }
            if (!exists) {
                try (PreparedStatement ps = conn.prepareStatement(insert)) {
                    ps.setInt(1, candidateId);
                    ps.setInt(2, testId);
                    ps.setInt(3, durationMinutes);
                    ps.executeUpdate();
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(select)) {
                ps.setInt(1, candidateId);
                ps.setInt(2, testId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        if (rs.getBoolean("submitted")) {
                            return -1;
                        }
                        return rs.getLong("remaining");
                    }
                }
            }
        }
        return 0;
    }

    /** Remaining seconds for an open attempt; -1 if already submitted; 0 if no attempt/expired. */
    public long getRemainingSeconds(int candidateId, int testId) throws SQLException {
        String sql = "SELECT submitted, GREATEST(0, TIMESTAMPDIFF(SECOND, NOW(), deadline)) AS remaining " +
                "FROM exam_attempts WHERE candidate_id = ? AND test_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            ps.setInt(2, testId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    if (rs.getBoolean("submitted")) {
                        return -1;
                    }
                    return rs.getLong("remaining");
                }
            }
        }
        return 0;
    }

    /**
     * Checks whether a submission arriving now is inside the deadline (with a small
     * grace window for network latency). Returns false when there is no open attempt.
     */
    public boolean isWithinDeadline(int candidateId, int testId, int graceSeconds) throws SQLException {
        String sql = "SELECT 1 FROM exam_attempts WHERE candidate_id = ? AND test_id = ? " +
                "AND submitted = FALSE AND NOW() <= TIMESTAMPADD(SECOND, ?, deadline)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            ps.setInt(2, testId);
            ps.setInt(3, graceSeconds);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void markSubmitted(int candidateId, int testId) throws SQLException {
        String sql = "UPDATE exam_attempts SET submitted = TRUE WHERE candidate_id = ? AND test_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            ps.setInt(2, testId);
            ps.executeUpdate();
        }
    }

    public boolean hasSubmitted(int candidateId, int testId) throws SQLException {
        String sql = "SELECT 1 FROM exam_attempts WHERE candidate_id = ? AND test_id = ? AND submitted = TRUE";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            ps.setInt(2, testId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
