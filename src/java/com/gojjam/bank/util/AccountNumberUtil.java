package com.gojjam.bank.util;

import com.gojjam.bank.config.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.ThreadLocalRandom;

public class AccountNumberUtil {

    private static final String PREFIX = "ACC";

    private AccountNumberUtil() {}

    /**
     * Generates a unique 13-character account number: ACC + 10 digits.
     * Checks the database to guarantee uniqueness.
     */
    public static String generate() throws SQLException {
        String candidate;
        do {
            long number = ThreadLocalRandom.current().nextLong(1_000_000_000L, 9_999_999_999L);
            candidate = PREFIX + number;
        } while (exists(candidate));
        return candidate;
    }

    private static boolean exists(String accountNumber) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM accounts WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
}