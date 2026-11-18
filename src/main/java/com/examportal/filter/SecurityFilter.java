package com.examportal.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        res.setHeader("X-Content-Type-Options", "nosniff");
        res.setHeader("X-Frame-Options", "DENY");
        res.setHeader("Referrer-Policy", "no-referrer");
        res.setHeader("Content-Security-Policy", "default-src 'self'; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; img-src 'self' data:");

        HttpSession session = req.getSession(true);
        if (session.getAttribute("csrfToken") == null) {
            byte[] bytes = new byte[32];
            new SecureRandom().nextBytes(bytes);
            session.setAttribute("csrfToken", Base64.getUrlEncoder().withoutPadding().encodeToString(bytes));
        }

        String servletPath = req.getServletPath() != null ? req.getServletPath() : "";
        String pathInfo = req.getPathInfo() != null ? req.getPathInfo() : "";
        String fullPath = servletPath + pathInfo;

        // Static files bypass
        if (fullPath.startsWith("/css/") || fullPath.startsWith("/js/")
                || fullPath.endsWith(".css") || fullPath.endsWith(".js")
                || fullPath.endsWith(".png") || fullPath.endsWith(".jpg")
                || fullPath.endsWith(".ico") || fullPath.endsWith(".svg")) {
            chain.doFilter(request, response);
            return;
        }

        // CSRF validation on all state-changing POST requests
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String sent = req.getParameter("_csrf");
            Object token = session.getAttribute("csrfToken");
            if (sent == null || token == null || !sent.equals(token.toString())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
                return;
            }
        }

        // Public GET / POST pages
        if (fullPath.equals("/health") || fullPath.equals("/login") || fullPath.equals("/logout")
                || fullPath.equals("/") || fullPath.isEmpty()
                || fullPath.equals("/index.jsp") || fullPath.equals("/jsp/candidate/register.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Candidate registration or test list viewing (GET)
        if ("GET".equalsIgnoreCase(req.getMethod())
                && (fullPath.equals("/candidate") || fullPath.equals("/candidate/register") || fullPath.equals("/candidate/tests"))) {
            chain.doFilter(request, response);
            return;
        }

        Object role = session.getAttribute("role");

        // Action dispatcher for /candidate POST endpoints
        if (servletPath.equals("/candidate") && "POST".equalsIgnoreCase(req.getMethod())) {
            String action = req.getParameter("action");
            if ("register".equals(action)) {
                chain.doFilter(request, response);
                return;
            }
            if (("save-question".equals(action) || "delete-question".equals(action)) && "admin".equals(role)) {
                chain.doFilter(request, response);
                return;
            }
            if ("submit-test".equals(action) && "student".equals(role) && session.getAttribute("candidate") != null) {
                chain.doFilter(request, response);
                return;
            }
            res.sendError(role == null ? HttpServletResponse.SC_UNAUTHORIZED : HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Protected student exam flows
        if (fullPath.startsWith("/candidate/take") || fullPath.startsWith("/candidate/results")
                || fullPath.startsWith("/candidate/analysis") || fullPath.startsWith("/student/")) {
            if (!"student".equals(role)) {
                if (role == null) {
                    res.sendRedirect(req.getContextPath() + "/login");
                } else {
                    res.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                return;
            }
            if (session.getAttribute("candidate") == null) {
                res.sendRedirect(req.getContextPath() + "/candidate/register");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Protected faculty/admin paths
        if (fullPath.startsWith("/faculty/") || fullPath.equals("/question-bank")) {
            if (!"admin".equals(role)) {
                if (role == null) {
                    res.sendRedirect(req.getContextPath() + "/login");
                } else {
                    res.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        chain.doFilter(request, response);
    }
}
