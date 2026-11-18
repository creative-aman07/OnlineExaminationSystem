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

        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String sent = req.getParameter("_csrf");
            Object token = session.getAttribute("csrfToken");
            if (sent == null || token == null || !sent.equals(token.toString())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
        }

        String path = req.getServletPath();
        if (path.equals("/health") || path.equals("/login") || path.equals("/") || path.isEmpty()
                || path.equals("/index.jsp") || path.equals("/jsp/candidate/register.jsp")
                || (("GET".equalsIgnoreCase(req.getMethod()))
                    && (path.equals("/candidate") || path.equals("/candidate/register") || path.equals("/candidate/tests")))
                || path.startsWith("/css/")
                || path.startsWith("/js/") || path.endsWith(".css") || path.endsWith(".js")) {
            chain.doFilter(request, response);
            return;
        }

        Object role = session.getAttribute("role");
        if ("/candidate".equals(path) && "POST".equalsIgnoreCase(req.getMethod())) {
            String action = req.getParameter("action");
            if ("register".equals(action) && role == null) {
                chain.doFilter(request, response);
                return;
            }
            if (("save-question".equals(action) || "delete-question".equals(action)) && "admin".equals(role)) {
                chain.doFilter(request, response);
                return;
            }
            if ("submit-test".equals(action) && "student".equals(role)
                    && session.getAttribute("candidate") != null) {
                chain.doFilter(request, response);
                return;
            }
            res.sendError(role == null ? HttpServletResponse.SC_UNAUTHORIZED : HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/candidate/") && !"student".equals(role)) {
            if (role == null) {
                res.sendRedirect(req.getContextPath() + "/candidate/register");
            } else {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
            }
            return;
        }
        if (path.startsWith("/candidate/") && session.getAttribute("candidate") == null) {
            res.sendRedirect(req.getContextPath() + "/candidate/register");
            return;
        }

        if (role == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (path.startsWith("/faculty/") || "/question-bank".equals(path)) {
            if (!"admin".equals(role)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }
        chain.doFilter(request, response);
    }
}
