package com.examportal.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Dual-database connection utility.
 * Priority order for resolving the JDBC URL:
 *   1. Environment variables  (JDBC_URL or MYSQLHOST+MYSQLPORT+MYSQL_DATABASE)
 *   2. .env file              (same keys)
 *   3. db.properties          (jdbc.url / jdbc.username / jdbc.password)
 *   4. H2 in-memory fallback  (zero-config local development)
 *
 * When MySQL is configured it will be used; otherwise H2 starts automatically.
 */
public class DBConnection {
    private static final Properties props = new Properties();
    private static final Properties envOverrides = new Properties();
    private static boolean usingMySQL = false;

    static {
        loadEnvironmentOverrides();
        loadProperties();
        // Try loading the MySQL driver first; fall back to H2
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            usingMySQL = true;
            System.out.println("DBConnection: MySQL driver loaded");
        } catch (ClassNotFoundException e) {
            System.out.println("DBConnection: MySQL driver not found, trying H2");
        }
        if (!usingMySQL) {
            try {
                Class.forName("org.h2.Driver");
                System.out.println("DBConnection: H2 driver loaded (fallback)");
            } catch (ClassNotFoundException e2) {
                throw new ExceptionInInitializerError("No JDBC driver found (tried MySQL and H2)");
            }
        }
    }

    private static void loadEnvironmentOverrides() {
        Path envPath = Paths.get(".env");
        if (!Files.exists(envPath)) {
            return;
        }
        try (BufferedReader reader = Files.newBufferedReader(envPath, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("#")) {
                    continue;
                }
                int separator = trimmed.indexOf('=');
                if (separator <= 0) {
                    continue;
                }
                String key = trimmed.substring(0, separator).trim();
                String value = trimmed.substring(separator + 1).trim();
                envOverrides.setProperty(key, stripQuotes(value));
            }
        } catch (IOException e) {
            System.err.println("Could not read .env file: " + e.getMessage());
        }
    }

    private static void loadProperties() {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = resolveUrl();
        String user = resolveUser();
        String pass = resolvePassword();

        try {
            Connection conn = DriverManager.getConnection(url, user, pass);
            return conn;
        } catch (SQLException e) {
            // If MySQL was configured but unreachable, fall back to H2 in dev mode
            if (url.startsWith("jdbc:mysql")) {
                String h2Url = "jdbc:h2:mem:examdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
                System.err.println("DBConnection: MySQL connection failed (" + e.getMessage() +
                        "), falling back to H2 in-memory database");
                try {
                    Class.forName("org.h2.Driver");
                } catch (ClassNotFoundException cnf) {
                    throw e; // No H2 either — rethrow original
                }
                return DriverManager.getConnection(h2Url, "sa", "");
            }
            throw e;
        }
    }

    /** Returns true when the resolved URL points at MySQL. */
    public static boolean isMySQLConfigured() {
        return resolveUrl().startsWith("jdbc:mysql");
    }

    private static String resolveUrl() {
        // 1. Direct JDBC_URL env var
        String envUrl = getEnv("JDBC_URL");
        if (!envUrl.isEmpty()) {
            return envUrl;
        }

        // 2. Railway-style individual MySQL env vars
        String mysqlHost = getEnv("MYSQLHOST");
        String mysqlPort = getEnv("MYSQLPORT");
        String mysqlDatabase = getEnv("MYSQL_DATABASE");
        if (!mysqlHost.isEmpty() && !mysqlPort.isEmpty() && !mysqlDatabase.isEmpty()) {
            return "jdbc:mysql://" + mysqlHost + ":" + mysqlPort + "/" + mysqlDatabase +
                    "?useSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC" +
                    "&characterEncoding=UTF-8&connectTimeout=15000&socketTimeout=60000";
        }

        // 3. db.properties
        String propUrl = resolvePropertyValue(props.getProperty("jdbc.url"));
        if (!propUrl.isEmpty()) {
            return propUrl;
        }

        // 4. Fallback
        return "jdbc:h2:mem:examdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
    }

    private static String resolveUser() {
        String envUser = getEnv("DB_USER");
        if (!envUser.isEmpty()) {
            return envUser;
        }
        String railwayUser = getEnv("MYSQLUSER");
        if (!railwayUser.isEmpty()) {
            return railwayUser;
        }
        return resolvePropertyValue(props.getProperty("jdbc.username"));
    }

    private static String resolvePassword() {
        String envPass = getEnv("DB_PASSWORD");
        if (!envPass.isEmpty()) {
            return envPass;
        }
        String railwayPass = getEnv("MYSQLPASSWORD");
        if (!railwayPass.isEmpty()) {
            return railwayPass;
        }
        return resolvePropertyValue(props.getProperty("jdbc.password"));
    }

    private static String resolvePropertyValue(String value) {
        if (value == null) {
            return "";
        }
        String resolved = value.trim();
        int start = resolved.indexOf("${");
        while (start >= 0) {
            int end = resolved.indexOf('}', start + 2);
            if (end < 0) {
                break;
            }
            String key = resolved.substring(start + 2, end);
            String envValue = getEnv(key);
            resolved = resolved.substring(0, start) + envValue + resolved.substring(end + 1);
            start = resolved.indexOf("${");
        }
        return resolved;
    }

    private static String getEnv(String key) {
        String value = trim(System.getenv(key));
        if (!value.isEmpty()) {
            return value;
        }
        return trim(envOverrides.getProperty(key));
    }

    private static String stripQuotes(String value) {
        String trimmed = value == null ? "" : value.trim();
        if (trimmed.length() >= 2 && ((trimmed.startsWith("\"") && trimmed.endsWith("\"")) || (trimmed.startsWith("'") && trimmed.endsWith("'")))) {
            return trimmed.substring(1, trimmed.length() - 1);
        }
        return trimmed;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
