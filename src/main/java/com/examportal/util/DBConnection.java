package com.examportal.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public final class DBConnection {
    private static final HikariDataSource DATA_SOURCE = createDataSource();

    private DBConnection() {}

    private static HikariDataSource createDataSource() {
        DatabaseConfig.Config config = DatabaseConfig.get();
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
        return new HikariDataSource(hikari);
    }

    public static Connection getConnection() throws SQLException {
        return DATA_SOURCE.getConnection();
    }

    public static boolean isMySQLConfigured() {
        return DatabaseConfig.get().url().startsWith("jdbc:mysql");
    }

    public static void close() {
        if (!DATA_SOURCE.isClosed()) DATA_SOURCE.close();
    }
}
