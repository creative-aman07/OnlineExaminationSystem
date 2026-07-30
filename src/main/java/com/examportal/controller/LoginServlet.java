package com.examportal.controller;

import java.io.IOException;

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
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Demo credentials
        if ("admin@exam.com".equalsIgnoreCase(email) && "password123".equals(password)) {
            HttpSession s = req.getSession(true);
            s.setAttribute("role", "admin");
            s.setAttribute("userEmail", email);
            resp.sendRedirect(req.getContextPath() + "/faculty/dashboard.jsp");
            return;
        }
        if ("student@exam.com".equalsIgnoreCase(email) && "password123".equals(password)) {
            HttpSession s = req.getSession(true);
            s.setAttribute("role", "student");
            s.setAttribute("userEmail", email);
            resp.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");
            return;
        }

        // Fallback: invalid credentials
        req.setAttribute("error", "Invalid credentials");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
