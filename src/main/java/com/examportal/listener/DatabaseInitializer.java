package com.examportal.listener;

import com.examportal.util.AuthUtil;
import com.examportal.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

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
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
                runStatements(stmt, sql);
                seedUsers(conn);
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

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DBConnection.close();
    }

    private void runStatements(Statement stmt, String sql) throws SQLException {
        for (String segment : sql.split(";")) {
            String cleaned = segment.trim();
            if (cleaned.isEmpty()) continue;
            try {
                stmt.execute(cleaned);
            } catch (SQLException e) {
                if (e.getErrorCode() == 1060) continue;
                throw e;
            }
        }
    }

    private void seedUsers(Connection conn) throws SQLException {
        int candidateId;
        try (PreparedStatement candidate = conn.prepareStatement(
                "SELECT candidate_id FROM candidates WHERE roll_number = ?")) {
            candidate.setString(1, "DEMO-STUDENT");
            try (var rs = candidate.executeQuery()) {
                if (rs.next()) {
                    candidateId = rs.getInt(1);
                } else {
                    try (PreparedStatement insert = conn.prepareStatement(
                            "INSERT INTO candidates (full_name, roll_number, email) VALUES (?, ?, ?)",
                            Statement.RETURN_GENERATED_KEYS)) {
                        insert.setString(1, "Demo Student");
                        insert.setString(2, "DEMO-STUDENT");
                        insert.setString(3, "student@exam.com");
                        insert.executeUpdate();
                        try (var keys = insert.getGeneratedKeys()) {
                            if (!keys.next()) throw new SQLException("Unable to create demo student");
                            candidateId = keys.getInt(1);
                        }
                    }
                }
            }
        }
        String sql = "INSERT IGNORE INTO users (email, password_hash, role_id, candidate_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "admin@exam.com");
            ps.setString(2, AuthUtil.hashPassword("password123"));
            ps.setInt(3, 1);
            ps.setNull(4, java.sql.Types.BIGINT);
            ps.executeUpdate();
            ps.setString(1, "student@exam.com");
            ps.setString(2, AuthUtil.hashPassword("password123"));
            ps.setInt(3, 2);
            ps.setInt(4, candidateId);
            ps.executeUpdate();
        }
        try (PreparedStatement update = conn.prepareStatement(
                "UPDATE users SET candidate_id = ? WHERE email = ? AND candidate_id IS NULL")) {
            update.setInt(1, candidateId);
            update.setString(2, "student@exam.com");
            update.executeUpdate();
        }
    }

    private String loadSchema() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("schema.sql")) {
            if (input == null) return null;
            return new String(input.readAllBytes(), StandardCharsets.UTF_8);
        } catch (Exception e) {
            System.err.println("DatabaseInitializer could not read schema.sql");
            return null;
        }
    }
}
