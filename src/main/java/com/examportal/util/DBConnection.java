package com.examportal.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public final class DBConnection {
    private static volatile HikariDataSource dataSource = createDataSource();

    private DBConnection() {}

    private static HikariDataSource createDataSource() {
        DatabaseConfig.Config config = DatabaseConfig.get();
        try {
            HikariConfig hikari = new HikariConfig();
            hikari.setJdbcUrl(config.url());
            hikari.setUsername(config.username());
            hikari.setPassword(config.password());
            hikari.setDriverClassName(config.driver());
            hikari.setMaximumPoolSize(config.maxPoolSize());
            hikari.setMinimumIdle(config.minIdle());
            hikari.setConnectionTimeout(config.connectionTimeoutMs());
            hikari.setValidationTimeout(config.validationTimeoutMs());
            hikari.setConnectionTestQuery("SELECT 1");
            hikari.setPoolName("examportal-pool");
            
            HikariDataSource ds = new HikariDataSource(hikari);
            // Verify connection works immediately
            try (Connection conn = ds.getConnection()) {
                System.out.println("DBConnection: Connected successfully to database [" + config.url() + "]");
            }
            return ds;
        } catch (Exception e) {
            System.err.println("DBConnection: Could not connect to primary database [" + config.url() + "]: " + e.getMessage());
            if (!config.url().startsWith("jdbc:h2:")) {
                System.out.println("DBConnection: Falling back to resilient embedded H2 database to ensure zero downtime.");
                DatabaseConfig.Config fallback = DatabaseConfig.getH2FallbackConfig();
                HikariConfig h2Config = new HikariConfig();
                h2Config.setJdbcUrl(fallback.url());
                h2Config.setUsername(fallback.username());
                h2Config.setPassword(fallback.password());
                h2Config.setDriverClassName(fallback.driver());
                h2Config.setMaximumPoolSize(fallback.maxPoolSize());
                h2Config.setMinimumIdle(fallback.minIdle());
                h2Config.setPoolName("examportal-h2-fallback-pool");
                return new HikariDataSource(h2Config);
            }
            throw new RuntimeException("DBConnection: Failed to initialize any data source", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null || dataSource.isClosed()) {
            synchronized (DBConnection.class) {
                if (dataSource == null || dataSource.isClosed()) {
                    dataSource = createDataSource();
                }
            }
        }
        return dataSource.getConnection();
    }

    public static boolean isMySQLConfigured() {
        return dataSource != null && dataSource.getJdbcUrl() != null && dataSource.getJdbcUrl().startsWith("jdbc:mysql");
    }

    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
