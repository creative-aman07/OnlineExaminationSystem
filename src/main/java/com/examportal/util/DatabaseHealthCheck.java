package com.examportal.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

public final class DatabaseHealthCheck {
    private DatabaseHealthCheck() {}

    public static boolean isReady() {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT 1")) {
            return statement.executeQuery().next();
        } catch (Exception e) {
            return false;
        }
    }
}
