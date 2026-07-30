package com.examportal.listener;

import com.examportal.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

@WebListener
public class DatabaseInitializer implements ServletContextListener {
    private static final int MAX_RETRIES = 5;
    private static final long RETRY_DELAY_MS = 3000;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String sql = loadSchema();
        if (sql == null) {
            System.err.println("DatabaseInitializer: schema.sql not found on classpath");
            return;
        }
        // Retry a few times so the app survives the DB container starting slower than Tomcat.
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
                runStatements(stmt, sql);
                System.out.println("DatabaseInitializer: schema initialized");
                return;
            } catch (SQLException e) {
                System.err.println("DatabaseInitializer attempt " + attempt + "/" + MAX_RETRIES + " failed: " + e.getMessage());
                if (attempt < MAX_RETRIES) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        return;
                    }
                }
            }
        }
        System.err.println("DatabaseInitializer: giving up after " + MAX_RETRIES + " attempts");
    }

    private void runStatements(Statement stmt, String sql) throws SQLException {
        for (String segment : sql.split(";")) {
            String cleaned = segment.trim();
            if (cleaned.isEmpty()) {
                continue;
            }
            try {
                stmt.execute(cleaned);
            } catch (SQLException e) {
                // Idempotent migrations: adding a column that already exists (1060) is fine.
                if (e.getErrorCode() == 1060) {
                    continue;
                }
                throw e;
            }
        }
    }

    private String loadSchema() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("schema.sql")) {
            if (input == null) {
                return null;
            }
            return new String(input.readAllBytes(), StandardCharsets.UTF_8);
        } catch (Exception e) {
            System.err.println("DatabaseInitializer could not read schema.sql: " + e.getMessage());
            return null;
        }
    }
}
