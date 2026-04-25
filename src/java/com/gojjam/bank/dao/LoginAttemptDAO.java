package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import java.sql.*;

public class LoginAttemptDAO {

    public void record(String username, String ip, boolean success) throws SQLException {
        final String sql =
            "INSERT INTO login_attempts (username, ip_address, success) VALUES (?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString (1, username);
            ps.setString (2, ip);
            ps.setBoolean(3, success);
            ps.executeUpdate();
        }
    }

    public void recordResetAttempt(String username, String ip, boolean success) throws SQLException {
        final String sql =
            "INSERT INTO password_reset_attempts (username, ip_address, success) VALUES (?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString (1, username);
            ps.setString (2, ip);
            ps.setBoolean(3, success);
            ps.executeUpdate();
        }
    }
}