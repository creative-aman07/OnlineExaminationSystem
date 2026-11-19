package com.examportal.controller;

import com.examportal.util.DatabaseHealthCheck;
import com.examportal.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/health")
public class HealthServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean ready = DatabaseHealthCheck.isReady();
        boolean usingFallback = DBConnection.isUsingH2Fallback();
        response.setStatus(ready ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"status\":\"" + (ready ? (usingFallback ? "degraded" : "ok") : "unavailable")
            + "\",\"db\":\"" + (usingFallback ? "h2-fallback" : ready ? "connected" : "unavailable") + "\"}");
    }
}
