package com.examportal.util;

import org.mindrot.jbcrypt.BCrypt;

public final class AuthUtil {
    private AuthUtil() {}

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static boolean verifyPassword(String password, String hash) {
        if (password == null || hash == null || hash.isBlank()) return false;
        try {
            return BCrypt.checkpw(password, hash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
