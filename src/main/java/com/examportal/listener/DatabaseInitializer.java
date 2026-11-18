package com.examportal.listener;

import com.examportal.util.AuthUtil;
import com.examportal.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Enumeration;

@WebListener
public class DatabaseInitializer implements ServletContextListener {
    private static final int MAX_RETRIES = 5;
    private static final long RETRY_DELAY_MS = 1500;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            String sql = loadSchema();
            for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
                try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
                    if (sql != null) {
                        runStatements(stmt, sql);
                    }
                    seedRoles(conn);
                    seedDemoQuestions(conn);
                    seedDemoTests(conn);
                    seedDemoUsersAndCandidates(conn);
                    seedDemoResults(conn);
                    System.out.println("DatabaseInitializer: schema and demo data initialized successfully");
                    return;
                } catch (Throwable e) {
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
            System.err.println("DatabaseInitializer: giving up after " + MAX_RETRIES + " attempts (application will still serve UI)");
        } catch (Throwable t) {
            // Never let listener throw to Tomcat, to prevent 'Context [] startup failed'
            System.err.println("DatabaseInitializer caught fatal error: " + t.getMessage());
            t.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            DBConnection.close();
        } catch (Throwable ignored) {}

        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Throwable ignored) {}

        try {
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                DriverManager.deregisterDriver(driver);
            }
        } catch (Throwable ignored) {}
    }

    private void runStatements(Statement stmt, String sql) throws SQLException {
        for (String segment : sql.split(";")) {
            String cleaned = segment.trim();
            if (cleaned.isEmpty()) continue;
            if (cleaned.startsWith("--") || cleaned.startsWith("/*")) {
                String[] lines = cleaned.split("\r?\n");
                StringBuilder sb = new StringBuilder();
                for (String line : lines) {
                    String t = line.trim();
                    if (!t.startsWith("--") && !t.startsWith("/*") && !t.isEmpty()) {
                        sb.append(line).append(" ");
                    }
                }
                cleaned = sb.toString().trim();
                if (cleaned.isEmpty()) continue;
            }
            try {
                stmt.execute(cleaned);
            } catch (SQLException e) {
                int code = e.getErrorCode();
                if (code == 1050 || code == 1060 || code == 1061 || code == 1062 || code == 23505) continue;
                String msg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
                if (msg.contains("already exists") || msg.contains("duplicate")) continue;
                System.err.println("DatabaseInitializer warning executing: " + cleaned + " => " + e.getMessage());
            }
        }
    }

    private void seedRoles(Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO roles (role_id, role_name) VALUES (?, ?)")) {
            ps.setInt(1, 1);
            ps.setString(2, "admin");
            try { ps.executeUpdate(); } catch (SQLException ignored) {}

            ps.setInt(1, 2);
            ps.setString(2, "student");
            try { ps.executeUpdate(); } catch (SQLException ignored) {}
        }
    }

    private void seedDemoQuestions(Connection conn) throws SQLException {
        String insertQ = "INSERT INTO questions (question_id, subject, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Object[][] questions = {
            // Java Assessment Questions (1 - 6)
            {1, "Java", "Which keyword is used to create a new object instance in Java?", "new", "class", "this", "create", "A", 1},
            {2, "Java", "Which of the following is NOT a primitive data type in Java?", "int", "boolean", "String", "double", "C", 1},
            {3, "Java", "Which collection class preserves insertion order and allows duplicate elements?", "HashSet", "ArrayList", "HashMap", "TreeSet", "B", 1},
            {4, "Java", "What does JVM stand for?", "Java Virtual Machine", "Java Verified Module", "Joint Virtual Machine", "Java Variable Method", "A", 1},
            {5, "Java", "Which keyword prevents a class method from being overridden in subclasses?", "static", "abstract", "final", "synchronized", "C", 1},
            {6, "Java", "What is the default value of an uninitialized boolean instance variable in Java?", "true", "false", "null", "0", "B", 1},

            // Web & Databases Questions (7 - 11)
            {7, "Web & Databases", "Which HTTP status code signifies a successful request?", "200 OK", "404 Not Found", "500 Internal Error", "301 Moved", "A", 1},
            {8, "Web & Databases", "In SQL, which clause is used to filter records returned by a SELECT query?", "ORDER BY", "GROUP BY", "WHERE", "HAVING", "C", 1},
            {9, "Web & Databases", "Which method of HttpServlet processes incoming HTTP POST requests?", "doGet", "doPost", "service", "init", "B", 1},
            {10, "Web & Databases", "What does the ACID acronym stand for in database transactions?", "Atomicity, Consistency, Isolation, Durability", "Access, Control, Identity, Data", "Auto, Concurrent, Indexed, Distributed", "Array, Cache, Index, Directory", "A", 1},
            {11, "Web & Databases", "Which SQL constraint uniquely identifies each record in a database table?", "Foreign Key", "Primary Key", "Check Constraint", "Unique Index", "B", 1},

            // Aptitude Questions (12 - 16)
            {12, "Aptitude", "If a train traveling at 60 km/h crosses a 300-meter platform in 30 seconds, what is the length of the train?", "150 meters", "200 meters", "250 meters", "300 meters", "B", 1},
            {13, "Aptitude", "Find the next number in the sequence: 2, 6, 12, 20, 30, ?", "40", "42", "44", "46", "B", 1},
            {14, "Aptitude", "If 5 workers complete a project in 12 days, how many days will 6 workers take at the same pace?", "8 days", "10 days", "11 days", "14 days", "B", 1},
            {15, "Aptitude", "Which of the following items does NOT belong with the others?", "Apple", "Orange", "Banana", "Potato", "D", 1},
            {16, "Aptitude", "An item was sold for $240 at a 20% profit. What was its original cost price?", "$190", "$200", "$210", "$220", "B", 1}
        };

        try (PreparedStatement ps = conn.prepareStatement(insertQ)) {
            for (Object[] q : questions) {
                ps.setInt(1, (Integer) q[0]);
                ps.setString(2, (String) q[1]);
                ps.setString(3, (String) q[2]);
                ps.setString(4, (String) q[3]);
                ps.setString(5, (String) q[4]);
                ps.setString(6, (String) q[5]);
                ps.setString(7, (String) q[6]);
                ps.setString(8, (String) q[7]);
                ps.setInt(9, (Integer) q[8]);
                try { ps.executeUpdate(); } catch (SQLException ignored) {}
            }
        }
    }

    private void seedDemoTests(Connection conn) throws SQLException {
        String insertTest = "INSERT INTO tests (test_id, test_name, subject, duration_minutes, total_questions, start_time, end_time) " +
                "VALUES (?, ?, ?, ?, ?, NULL, NULL)";
        
        Object[][] tests = {
            {1, "Java Full Stack & Core Programming", "Java", 20, 6},
            {2, "Web Technologies & Database Systems", "Web & Databases", 15, 5},
            {3, "General Aptitude & Logical Reasoning", "Aptitude", 15, 5}
        };

        try (PreparedStatement ps = conn.prepareStatement(insertTest)) {
            for (Object[] t : tests) {
                ps.setInt(1, (Integer) t[0]);
                ps.setString(2, (String) t[1]);
                ps.setString(3, (String) t[2]);
                ps.setInt(4, (Integer) t[3]);
                ps.setInt(5, (Integer) t[4]);
                try { ps.executeUpdate(); } catch (SQLException ignored) {}
            }
        }

        int[][] testQuestionLinks = {
            // Test 1: Questions 1 - 6
            {1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6},
            // Test 2: Questions 7 - 11
            {2, 7}, {2, 8}, {2, 9}, {2, 10}, {2, 11},
            // Test 3: Questions 12 - 16
            {3, 12}, {3, 13}, {3, 14}, {3, 15}, {3, 16}
        };

        String insertLink = "INSERT INTO test_questions (test_id, question_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertLink)) {
            for (int[] link : testQuestionLinks) {
                ps.setInt(1, link[0]);
                ps.setInt(2, link[1]);
                try { ps.executeUpdate(); } catch (SQLException ignored) {}
            }
        }
    }

    private void seedDemoUsersAndCandidates(Connection conn) throws SQLException {
        int demoCandidateId = 0;
        try (PreparedStatement check = conn.prepareStatement("SELECT candidate_id FROM candidates WHERE roll_number = ?")) {
            check.setString(1, "STUDENT001");
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) {
                    demoCandidateId = rs.getInt(1);
                }
            }
        }
        if (demoCandidateId == 0) {
            try (PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO candidates (full_name, roll_number, email) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                insert.setString(1, "Demo Student");
                insert.setString(2, "STUDENT001");
                insert.setString(3, "student@exam.com");
                insert.executeUpdate();
                try (ResultSet rs = insert.getGeneratedKeys()) {
                    if (rs.next()) demoCandidateId = rs.getInt(1);
                }
            }
        }

        // Admin user
        try (PreparedStatement check = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?")) {
            check.setString(1, "admin@exam.com");
            try (ResultSet rs = check.executeQuery()) {
                if (!rs.next()) {
                    try (PreparedStatement insert = conn.prepareStatement(
                            "INSERT INTO users (email, password_hash, role_id, candidate_id) VALUES (?, ?, 1, NULL)")) {
                        insert.setString(1, "admin@exam.com");
                        insert.setString(2, AuthUtil.hashPassword("password123"));
                        insert.executeUpdate();
                    }
                }
            }
        }

        // Student user
        try (PreparedStatement check = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?")) {
            check.setString(1, "student@exam.com");
            try (ResultSet rs = check.executeQuery()) {
                if (!rs.next()) {
                    try (PreparedStatement insert = conn.prepareStatement(
                            "INSERT INTO users (email, password_hash, role_id, candidate_id) VALUES (?, ?, 2, ?)")) {
                        insert.setString(1, "student@exam.com");
                        insert.setString(2, AuthUtil.hashPassword("password123"));
                        insert.setInt(3, demoCandidateId);
                        insert.executeUpdate();
                    }
                } else {
                    try (PreparedStatement update = conn.prepareStatement(
                            "UPDATE users SET candidate_id = ? WHERE email = ? AND (candidate_id IS NULL OR candidate_id <= 0)")) {
                        update.setInt(1, demoCandidateId);
                        update.setString(2, "student@exam.com");
                        update.executeUpdate();
                    }
                }
            }
        }

        // Link any unlinked student accounts
        try (PreparedStatement findOrphans = conn.prepareStatement(
                "SELECT user_id, email FROM users WHERE role_id = 2 AND (candidate_id IS NULL OR candidate_id <= 0)")) {
            try (ResultSet rs = findOrphans.executeQuery()) {
                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String userEmail = rs.getString("email");
                    String name = userEmail.contains("@") ? userEmail.substring(0, userEmail.indexOf('@')) : userEmail;
                    String roll = "STUDENT" + userId;

                    int newCandId = 0;
                    try (PreparedStatement checkCand = conn.prepareStatement("SELECT candidate_id FROM candidates WHERE email = ? OR roll_number = ?")) {
                        checkCand.setString(1, userEmail);
                        checkCand.setString(2, roll);
                        try (ResultSet rsCand = checkCand.executeQuery()) {
                            if (rsCand.next()) newCandId = rsCand.getInt(1);
                        }
                    }
                    if (newCandId == 0) {
                        try (PreparedStatement insCand = conn.prepareStatement(
                                "INSERT INTO candidates (full_name, roll_number, email) VALUES (?, ?, ?)",
                                Statement.RETURN_GENERATED_KEYS)) {
                            insCand.setString(1, Character.toUpperCase(name.charAt(0)) + (name.length() > 1 ? name.substring(1) : ""));
                            insCand.setString(2, roll);
                            insCand.setString(3, userEmail);
                            insCand.executeUpdate();
                            try (ResultSet keys = insCand.getGeneratedKeys()) {
                                if (keys.next()) newCandId = keys.getInt(1);
                            }
                        }
                    }
                    if (newCandId > 0) {
                        try (PreparedStatement updUser = conn.prepareStatement("UPDATE users SET candidate_id = ? WHERE user_id = ?")) {
                            updUser.setInt(1, newCandId);
                            updUser.setInt(2, userId);
                            updUser.executeUpdate();
                        }
                    }
                }
            }
        }
    }

    private void seedDemoResults(Connection conn) throws SQLException {
        int candidateId = 0;
        try (PreparedStatement check = conn.prepareStatement("SELECT candidate_id FROM candidates WHERE roll_number = ?")) {
            check.setString(1, "STUDENT001");
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) candidateId = rs.getInt(1);
            }
        }
        if (candidateId > 0) {
            try (PreparedStatement checkResult = conn.prepareStatement("SELECT result_id FROM results WHERE candidate_id = ? AND test_id = 1")) {
                checkResult.setInt(1, candidateId);
                try (ResultSet rs = checkResult.executeQuery()) {
                    if (!rs.next()) {
                        try (PreparedStatement insert = conn.prepareStatement(
                                "INSERT INTO results (candidate_id, test_id, test_name, total_questions, correct_answers, wrong_answers, score, percentage, passed) " +
                                "VALUES (?, 1, 'Java Full Stack & Core Programming', 6, 5, 1, 5, 83.33, TRUE)")) {
                            insert.setInt(1, candidateId);
                            insert.executeUpdate();
                        }
                    }
                }
            }
        }
    }

    private String loadSchema() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("schema.sql")) {
            if (input == null) return null;
            return new String(input.readAllBytes(), StandardCharsets.UTF_8);
        } catch (Exception e) {
            System.err.println("DatabaseInitializer could not read schema.sql: " + e.getMessage());
            return null;
        }
    }
}
