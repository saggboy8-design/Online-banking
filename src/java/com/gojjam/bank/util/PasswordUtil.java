package com.gojjam.bank.util;

import org.mindrot.jbcrypt.BCrypt;
import java.util.regex.Pattern;

public class PasswordUtil {

    private static final int BCRYPT_ROUNDS = 10;

    private static final Pattern HAS_UPPERCASE   = Pattern.compile("[A-Z]");
    private static final Pattern HAS_LOWERCASE   = Pattern.compile("[a-z]");
    private static final Pattern HAS_DIGIT       = Pattern.compile("[0-9]");
    private static final Pattern HAS_SPECIAL     = Pattern.compile("[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]");
    private static final int     MIN_LENGTH       = 8;

    private PasswordUtil() {}

    /** Hash a plain-text password with BCrypt. */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /** Verify a plain-text password against a stored BCrypt hash. */
    public static boolean verify(String plainPassword, String hash) {
        if (plainPassword == null || hash == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hash);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Returns password strength score 0-4.
     *  0 = Very Weak, 1 = Weak, 2 = Fair, 3 = Strong, 4 = Very Strong
     */
    public static int strengthScore(String password) {
        if (password == null || password.isEmpty()) return 0;
        int score = 0;
        if (password.length() >= MIN_LENGTH)  score++;
        if (HAS_UPPERCASE.matcher(password).find()) score++;
        if (HAS_DIGIT.matcher(password).find())     score++;
        if (HAS_SPECIAL.matcher(password).find())   score++;
        return score;
    }

    /** Returns true if the password satisfies all minimum requirements. */
    public static boolean isStrong(String password) {
        if (password == null || password.length() < MIN_LENGTH) return false;
        return HAS_UPPERCASE.matcher(password).find()
            && HAS_LOWERCASE.matcher(password).find()
            && HAS_DIGIT.matcher(password).find()
            && HAS_SPECIAL.matcher(password).find();
    }

    /** Returns a human-readable label for a given strength score. */
    public static String strengthLabel(int score) {
        return switch (score) {
            case 0  -> "Very Weak";
            case 1  -> "Weak";
            case 2  -> "Fair";
            case 3  -> "Strong";
            default -> "Very Strong";
        };
    }
}