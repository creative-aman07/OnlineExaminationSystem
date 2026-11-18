package com.examportal.util;

import java.io.BufferedReader;
import java.net.URI;
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
        // Multi-platform URL detection (Railway, Render, Heroku, AWS, local)
        String explicitUrl = env("JDBC_URL", env("DATABASE_URL", env("MYSQL_URL", env("JAWSDB_URL", env("CLEARDB_DATABASE_URL", "")))));
        
        String host = env("DB_HOST", env("MYSQLHOST", env("MYSQL_HOST", "")));
        String port = env("DB_PORT", env("MYSQLPORT", env("MYSQL_PORT", "3306")));
        String name = env("DB_NAME", env("MYSQLDATABASE", env("MYSQL_DATABASE", env("MYSQL_DB", ""))));
        String username = env("DB_USERNAME", env("DB_USER", env("MYSQLUSER", env("MYSQL_USER", ""))));
        String password = env("DB_PASSWORD", env("MYSQLPASSWORD", env("MYSQL_PASSWORD", "")));
        String ssl = env("DB_SSL", "false");
        String timezone = env("DB_TIMEZONE", "UTC");
        String url;

        if (!explicitUrl.isBlank()) {
            // Check if standard URI format mysql://user:pass@host:port/dbname
            if (explicitUrl.startsWith("mysql://") || explicitUrl.startsWith("mysqls://")) {
                try {
                    URI uri = URI.create(explicitUrl);
                    String parsedHost = uri.getHost();
                    int parsedPort = uri.getPort() > 0 ? uri.getPort() : 3306;
                    String parsedPath = uri.getPath() != null ? uri.getPath().replaceFirst("^/", "") : "";
                    String userInfo = uri.getUserInfo();
                    if (userInfo != null && !userInfo.isEmpty()) {
                        String[] parts = userInfo.split(":", 2);
                        if (username.isBlank()) username = parts[0];
                        if (password.isBlank() && parts.length > 1) password = parts[1];
                    }
                    url = "jdbc:mysql://" + parsedHost + ":" + parsedPort + "/" + parsedPath
                            + "?useSSL=" + ssl
                            + "&allowPublicKeyRetrieval=true"
                            + "&serverTimezone=" + timezone
                            + "&characterEncoding=UTF-8";
                } catch (Exception e) {
                    url = explicitUrl.replaceFirst("^mysql://", "jdbc:mysql://");
                }
            } else if (!explicitUrl.startsWith("jdbc:")) {
                url = "jdbc:" + explicitUrl;
            } else {
                url = explicitUrl;
            }
        } else if (!host.isBlank() && !name.isBlank()) {
            url = "jdbc:mysql://" + host + ":" + port + "/" + name
                    + "?useSSL=" + ssl
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=" + timezone
                    + "&characterEncoding=UTF-8";
        } else {
            // Resilient zero-config H2 embedded database fallback
            url = "jdbc:h2:mem:examdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
            username = "sa";
            password = "";
        }

        String driver = env("DB_DRIVER", url.startsWith("jdbc:mysql") ? "com.mysql.cj.jdbc.Driver" : "org.h2.Driver");
        int maxPool = integer("DB_POOL_MAX", 10);
        int minIdle = integer("DB_POOL_MIN", 2);
        long timeout = integer("DB_CONNECTION_TIMEOUT", 15000);
        long validation = integer("DB_QUERY_TIMEOUT", 15) * 1000L;
        return new Config(url, username, password, driver, maxPool, minIdle, timeout, validation);
    }

    public static Config getH2FallbackConfig() {
        return new Config("jdbc:h2:mem:examdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1",
                "sa", "", "org.h2.Driver", 10, 2, 10000, 10000);
    }

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        if (value != null && !value.isBlank()) return value.trim();
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.isBlank()) return sysProp.trim();
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
