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
 * ==========================================================
 *                 DBConnection Utility Class
 * ==========================================================
 *
 * This class is responsible for creating a database connection.
 *
 * Connection priority:
 *
 * 1. Railway Environment Variables
 * 2. .env File
 * 3. db.properties File
 * 4. H2 In-Memory Database (Fallback)
 *
 * Supported Databases:
 * --------------------
 *  MySQL (Railway)
 *  Local MySQL
 *  H2 (Development)
 *
 */

public class DBConnection {

    // Stores values from db.properties
    private static final Properties props = new Properties();

    // Stores values from .env file
    private static final Properties envOverrides = new Properties();

    // Checks whether MySQL driver is available
    private static boolean usingMySQL = false;

    /**
     * Static block executes only once when
     * the class is loaded.
     */
    static {

        // Load variables from .env
        loadEnvironmentOverrides();

        // Load db.properties
        loadProperties();

        // Try loading MySQL Driver
        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            usingMySQL = true;

            System.out.println("DBConnection : MySQL Driver Loaded Successfully (driver present)");

        } catch (ClassNotFoundException e) {

            System.out.println("MySQL Driver Not Found.");
            System.out.println("Trying H2 Driver...");
        }

        // If MySQL Driver not found
        // then load H2 Driver
        if (!usingMySQL) {

            try {

                Class.forName("org.h2.Driver");

                System.out.println("DBConnection : H2 Driver Loaded Successfully (driver present)");

            } catch (ClassNotFoundException e) {

                throw new ExceptionInInitializerError(
                        "No JDBC Driver Found (MySQL/H2)");
            }
        }
    }

    /**
     * Reads the .env file
     * and stores all values
     * inside envOverrides.
     */
    private static void loadEnvironmentOverrides() {

        Path envPath = Paths.get(".env");

        // If .env doesn't exist
        if (!Files.exists(envPath)) {
            return;
        }

        try (BufferedReader reader =
                     Files.newBufferedReader(
                             envPath,
                             StandardCharsets.UTF_8)) {

            String line;

            while ((line = reader.readLine()) != null) {

                String trimmed = line.trim();

                // Ignore empty lines
                if (trimmed.isEmpty()) {
                    continue;
                }

                // Ignore comments
                if (trimmed.startsWith("#")) {
                    continue;
                }

                int separator = trimmed.indexOf('=');

                if (separator <= 0) {
                    continue;
                }

                String key =
                        trimmed.substring(0, separator).trim();

                String value =
                        trimmed.substring(separator + 1).trim();

                envOverrides.setProperty(
                        key,
                        stripQuotes(value));
            }

        } catch (IOException e) {

            System.err.println(
                    "Unable to read .env file : "
                            + e.getMessage());
        }
    }

    /**
     * Reads db.properties file.
     */
    private static void loadProperties() {

        try (InputStream input =
                     DBConnection.class
                             .getClassLoader()
                             .getResourceAsStream("db.properties")) {

            if (input != null) {

                props.load(input);

            }

        } catch (IOException e) {

            throw new ExceptionInInitializerError(e);
        }
    }

    /**
     * Creates and returns a database connection.
     *
     * First tries MySQL.
     * If MySQL fails, automatically switches
     * to H2 database.
     */
    public static Connection getConnection() throws SQLException {

        String url = resolveUrl();

        String user = resolveUser();

        String password = resolvePassword();

        try {

            Connection connection =
                    DriverManager.getConnection(
                            url,
                            user,
                            password);

            return connection;

        } catch (SQLException e) {

            // If MySQL connection fails,
            // use H2 database instead.
            if (url.startsWith("jdbc:mysql")) {

                String h2Url =
                        "jdbc:h2:mem:examdb;"
                                + "MODE=MySQL;"
                                + "DATABASE_TO_LOWER=TRUE;"
                                + "DB_CLOSE_DELAY=-1";

                System.err.println(
                        "MySQL Connection Failed : "
                                + e.getMessage());

                System.err.println(
                        "Switching to H2 Database...");

                try {

                    Class.forName("org.h2.Driver");

                    // Make the fallback explicit in logs so it's clear H2 is being used
                    System.out.println("DBConnection : H2 Driver Loaded Successfully (fallback)");

                } catch (ClassNotFoundException ex) {

                    throw e;
                }

                return DriverManager.getConnection(
                        h2Url,
                        "sa",
                        "");
            }

            throw e;
        }
    }

    /**
     * Returns true if MySQL
     * is being used.
     */
    public static boolean isMySQLConfigured() {

        return resolveUrl().startsWith("jdbc:mysql");
    }

    /**
     * Resolves the JDBC URL.
     *
     * Priority:
     * 1. JDBC_URL
     * 2. Railway Variables
     * 3. db.properties
     * 4. H2 Database
     */
    private static String resolveUrl() {

        // ===============================
        // Option 1 : JDBC_URL
        // ===============================

        String jdbcUrl = getEnv("JDBC_URL");

        if (!jdbcUrl.isEmpty()) {

            return jdbcUrl;
        }

        // ===============================
        // Option 2 : Railway Variables
        // ===============================

        String host = getEnv("MYSQLHOST");

        String port = getEnv("MYSQLPORT");

        // Railway sometimes uses
        // MYSQL_DATABASE
        // and sometimes MYSQLDATABASE

        String database = getEnv("MYSQL_DATABASE");

        if (database.isEmpty()) {

            database = getEnv("MYSQLDATABASE");
        }

        if (!host.isEmpty()
                && !port.isEmpty()
                && !database.isEmpty()) {

            return "jdbc:mysql://"
                    + host
                    + ":"
                    + port
                    + "/"
                    + database
                    + "?useSSL=false"
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=UTC"
                    + "&characterEncoding=UTF-8";
        }

        // ===============================
        // Option 3 : db.properties
        // ===============================

        String propertyUrl =
                resolvePropertyValue(
                        props.getProperty("jdbc.url"));

        if (!propertyUrl.isEmpty()) {

            return propertyUrl;
        }

        // ===============================
        // Option 4 : H2 Database
        // ===============================

        return "jdbc:h2:mem:examdb;"
                + "MODE=MySQL;"
                + "DATABASE_TO_LOWER=TRUE;"
                + "DB_CLOSE_DELAY=-1";
    }

    /**
     * Returns database username.
     */
    private static String resolveUser() {

        String user = getEnv("DB_USER");

        if (!user.isEmpty()) {

            return user;
        }

        user = getEnv("MYSQLUSER");

        if (!user.isEmpty()) {

            return user;
        }

        return resolvePropertyValue(
                props.getProperty("jdbc.username"));
    }

    /**
     * Returns database password.
     */
    private static String resolvePassword() {

        String password = getEnv("DB_PASSWORD");

        if (!password.isEmpty()) {

            return password;
        }

        password = getEnv("MYSQLPASSWORD");

        if (!password.isEmpty()) {

            return password;
        }

        return resolvePropertyValue(
                props.getProperty("jdbc.password"));
    }

    /**
     * Replaces placeholders like
     * ${MYSQLHOST}
     * with their actual values.
     */
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

            resolved =
                    resolved.substring(0, start)
                    + envValue
                    + resolved.substring(end + 1);

            start = resolved.indexOf("${");
        }

        return resolved;
    }

    /**
     * Reads environment variables.
     *
     * Priority:
     * 1. System Environment Variables
     * 2. .env File
     */
    private static String getEnv(String key) {

        String value = trim(System.getenv(key));

        if (!value.isEmpty()) {
            return value;
        }

        return trim(envOverrides.getProperty(key));
    }

    /**
     * Removes quotes from values.
     *
     * Example:
     *
     * "root"
     * becomes
     * root
     */
    private static String stripQuotes(String value) {

        String trimmed =
                value == null
                        ? ""
                        : value.trim();

        if (trimmed.length() >= 2
                &&
                (
                        (trimmed.startsWith("\"")
                                && trimmed.endsWith("\""))
                                ||
                        (trimmed.startsWith("'")
                                && trimmed.endsWith("'"))
                )) {

            return trimmed.substring(
                    1,
                    trimmed.length() - 1);
        }

        return trimmed;
    }

    /**
     * Removes leading
     * and trailing spaces.
     */
    private static String trim(String value) {

        return value == null
                ? ""
                : value.trim();
    }

}
