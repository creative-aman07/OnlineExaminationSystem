package com.examportal.dao;

import com.examportal.model.Question;
import com.examportal.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDao {
    public List<Question> findAll() throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions ORDER BY question_id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                questions.add(map(rs));
            }
        }
        return questions;
    }

    public Question save(Question question) throws SQLException {
        String sql = "INSERT INTO questions (subject, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, question.getSubject());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getOptionA());
            ps.setString(4, question.getOptionB());
            ps.setString(5, question.getOptionC());
            ps.setString(6, question.getOptionD());
            ps.setString(7, question.getCorrectAnswer());
            ps.setInt(8, question.getMarks());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    question.setQuestionId(keys.getInt(1));
                }
            }
            return question;
        }
    }

    public Question findById(int questionId) throws SQLException {
        String sql = "SELECT * FROM questions WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public void update(Question question) throws SQLException {
        String sql = "UPDATE questions SET subject = ?, question_text = ?, option_a = ?, option_b = ?, option_c = ?, option_d = ?, correct_answer = ?, marks = ? WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, question.getSubject());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getOptionA());
            ps.setString(4, question.getOptionB());
            ps.setString(5, question.getOptionC());
            ps.setString(6, question.getOptionD());
            ps.setString(7, question.getCorrectAnswer());
            ps.setInt(8, question.getMarks());
            ps.setInt(9, question.getQuestionId());
            ps.executeUpdate();
        }
    }

    public void delete(int questionId) throws SQLException {
        String sql = "DELETE FROM questions WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.executeUpdate();
        }
    }

    private Question map(ResultSet rs) throws SQLException {
        Question question = new Question();
        question.setQuestionId(rs.getInt("question_id"));
        question.setSubject(rs.getString("subject"));
        question.setQuestionText(rs.getString("question_text"));
        question.setOptionA(rs.getString("option_a"));
        question.setOptionB(rs.getString("option_b"));
        question.setOptionC(rs.getString("option_c"));
        question.setOptionD(rs.getString("option_d"));
        question.setCorrectAnswer(rs.getString("correct_answer"));
        question.setMarks(rs.getInt("marks"));
        return question;
    }
}
