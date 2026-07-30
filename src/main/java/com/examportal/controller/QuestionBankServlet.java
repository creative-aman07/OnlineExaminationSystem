package com.examportal.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.examportal.model.Question;
import com.examportal.service.ExamService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/question-bank")
public class QuestionBankServlet extends HttpServlet {
    private final ExamService examService = new ExamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Question> questions = examService.listQuestions();
            req.setAttribute("questions", questions);
            req.getRequestDispatcher("/questionBank.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
