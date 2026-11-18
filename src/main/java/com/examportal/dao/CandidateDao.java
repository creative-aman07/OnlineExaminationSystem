package com.examportal.dao;

import com.examportal.model.Candidate;
import com.examportal.util.AuthUtil;
import com.examportal.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CandidateDao {
    public Candidate save(Candidate candidate, String password) throws SQLException {
        String insertCandidate = "INSERT INTO candidates (full_name, roll_number, email) VALUES (?, ?, ?)";
        String insertUser = "INSERT INTO users (email, password_hash, role_id, candidate_id) VALUES (?, ?, 2, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(insertCandidate, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement user = conn.prepareStatement(insertUser)) {
                ps.setString(1, candidate.getFullName());
                ps.setString(2, candidate.getRollNumber());
                ps.setString(3, candidate.getEmail());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) candidate.setCandidateId(keys.getInt(1));
                }
                if (!candidate.getEmail().isBlank()) {
                    user.setString(1, candidate.getEmail().trim().toLowerCase());
                    user.setString(2, AuthUtil.hashPassword(password));
                    user.setInt(3, candidate.getCandidateId());
                    user.executeUpdate();
                }
                conn.commit();
                return candidate;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public Optional<Candidate> findByRollNumber(String rollNumber) throws SQLException {
        String sql = "SELECT * FROM candidates WHERE roll_number = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rollNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        }
        return Optional.empty();
    }

    public Candidate findById(int candidateId) throws SQLException {
        String sql = "SELECT * FROM candidates WHERE candidate_id = ?";
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

    public List<Candidate> findAll() throws SQLException {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT * FROM candidates ORDER BY candidate_id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                candidates.add(map(rs));
            }
        }
        return candidates;
    }

    private Candidate map(ResultSet rs) throws SQLException {
        Candidate candidate = new Candidate();
        candidate.setCandidateId(rs.getInt("candidate_id"));
        candidate.setFullName(rs.getString("full_name"));
        candidate.setRollNumber(rs.getString("roll_number"));
        candidate.setEmail(rs.getString("email"));
        candidate.setCreatedAt(rs.getString("created_at"));
        return candidate;
    }
}
