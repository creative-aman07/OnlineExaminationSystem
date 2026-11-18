package com.examportal.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.examportal.model.Candidate;
import com.examportal.service.ExamService;

import com.examportal.util.AuthUtil;
import com.examportal.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        HttpSession session = req.getSession(false);
        if (session != null && "admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/faculty/dashboard.jsp");
            return;
        }
        if (session != null && "student".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String sql = "SELECT r.role_name, u.password_hash, u.candidate_id FROM users u " +
                "JOIN roles r ON r.role_id = u.role_id " +
                "WHERE u.email = ? AND u.active = TRUE";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email == null ? "" : email.trim().toLowerCase());
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next() && AuthUtil.verifyPassword(password, rs.getString("password_hash"))) {
                    HttpSession session = req.getSession(true);
                    session.invalidate();
                    session = req.getSession(true);
                    String role = rs.getString("role_name");
                    session.setAttribute("role", role);
                    session.setAttribute("userEmail", email.trim().toLowerCase());
                    int candidateId = rs.getInt("candidate_id");
                    if ("student".equals(role) && candidateId > 0) {
                        Candidate candidate = new ExamService().getCandidate(candidateId);
                        if (candidate != null) session.setAttribute("candidate", candidate);
                    }
                    resp.sendRedirect(req.getContextPath() + ("admin".equals(role)
                            ? "/faculty/dashboard.jsp" : "/student/dashboard.jsp"));
                    return;
                }
            }
        } catch (Exception e) {
            req.setAttribute("error", "Login is temporarily unavailable.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        req.setAttribute("error", "Invalid credentials");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
