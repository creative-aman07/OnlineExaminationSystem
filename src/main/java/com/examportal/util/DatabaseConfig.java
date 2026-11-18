package com.examportal.util;

import java.io.BufferedReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public final class DatabaseConfig {
    public record Config(String url, String username, String password, String driver,
                         int maxPoolSize, int minIdle, long connectionTimeoutMs,
                         long validationTimeoutMs) {}

    private static final Config INSTANCE = load();

    private DatabaseConfig() {}

    public static Config get() {
        return INSTANCE;
    }

    private static Config load() {
        String host = env("DB_HOST", "");
        String port = env("DB_PORT", "3306");
        String name = env("DB_NAME", env("MYSQL_DATABASE", env("MYSQLDATABASE", "")));
        String username = env("DB_USERNAME", env("DB_USER", env("MYSQLUSER", "")));
        String password = env("DB_PASSWORD", env("MYSQLPASSWORD", ""));
        String explicitUrl = env("JDBC_URL", "");
        String ssl = env("DB_SSL", "false");
        String timezone = env("DB_TIMEZONE", "UTC");
        String url;

        if (!explicitUrl.isBlank()) {
            url = explicitUrl;
        } else if (!host.isBlank() && !name.isBlank()) {
            url = "jdbc:mysql://" + host + ":" + port + "/" + name
                    + "?useSSL=" + ssl
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=" + timezone
                    + "&characterEncoding=UTF-8";
        } else {
            url = "jdbc:h2:mem:examdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
            username = "sa";
            password = "";
        }

        String driver = env("DB_DRIVER", url.startsWith("jdbc:mysql") ? "com.mysql.cj.jdbc.Driver" : "org.h2.Driver");
        int maxPool = integer("DB_POOL_MAX", 10);
        int minIdle = integer("DB_POOL_MIN", 2);
        long timeout = integer("DB_CONNECTION_TIMEOUT", 30000);
        long validation = integer("DB_QUERY_TIMEOUT", 30) * 1000L;
        return new Config(url, username, password, driver, maxPool, minIdle, timeout, validation);
    }

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        if (value != null && !value.isBlank()) return value.trim();
        return readDotEnv(key, fallback);
    }

    private static String readDotEnv(String key, String fallback) {
        Path path = Path.of(".env");
        if (!Files.isRegularFile(path)) return fallback;
        try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("#") || !trimmed.contains("=")) continue;
                int i = trimmed.indexOf('=');
                if (trimmed.substring(0, i).trim().equals(key)) {
                    String value = trimmed.substring(i + 1).trim();
                    if (value.length() >= 2 && ((value.startsWith("\"") && value.endsWith("\"")) || (value.startsWith("'") && value.endsWith("'")))) {
                        value = value.substring(1, value.length() - 1);
                    }
                    return value;
                }
            }
        } catch (Exception ignored) {
        }
        return fallback;
    }

    private static int integer(String key, int fallback) {
        try {
            String value = env(key, Integer.toString(fallback));
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : fallback;
        } catch (RuntimeException e) {
            return fallback;
        }
    }
}
