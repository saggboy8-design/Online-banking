package com.gojjam.bank.util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^\\+?[0-9]{9,15}$");
    private static final Pattern NATIONAL_ID_PATTERN =
        Pattern.compile("^[A-Z0-9\\-]{5,20}$");
    private static final Pattern ACCOUNT_NUMBER_PATTERN =
        Pattern.compile("^ACC[0-9]{10}$");

    private ValidationUtil() {}

    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidNationalId(String id) {
        return id != null && NATIONAL_ID_PATTERN.matcher(id.trim().toUpperCase()).matches();
    }

    public static boolean isValidAccountNumber(String accNum) {
        return accNum != null && ACCOUNT_NUMBER_PATTERN.matcher(accNum.trim()).matches();
    }

    public static boolean isValidDate(String dateStr) {
        try {
            LocalDate.parse(dateStr);           // expects yyyy-MM-dd (HTML date input)
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static boolean isPastDate(String dateStr) {
        try {
            return LocalDate.parse(dateStr).isBefore(LocalDate.now());
        } catch (Exception e) {
            return false;
        }
    }

    /** Sanitise string for XSS – strips HTML tags and encodes angle brackets. */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim()
                    .replace("&",  "&amp;")
                    .replace("<",  "&lt;")
                    .replace(">",  "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'",  "&#x27;");
    }
}