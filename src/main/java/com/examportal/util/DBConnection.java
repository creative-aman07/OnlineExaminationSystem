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

            System.out.println("DBConnection : MySQL Driver Loaded Successfully");

        } catch (ClassNotFoundException e) {

            System.out.println("MySQL Driver Not Found.");
            System.out.println("Trying H2 Driver...");
        }

        // If MySQL Driver not found
        // then load H2 Driver
        if (!usingMySQL) {

            try {

                Class.forName("org.h2.Driver");

                System.out.println("H2 Driver Loaded Successfully");

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
