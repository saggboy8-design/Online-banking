package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.User;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ── Find by username ─────────────────────────────────────────────────────────
    public User findByUsername(String username) throws SQLException {
        final String sql = "SELECT u.*, r.role_name FROM users u "
                         + "JOIN roles r ON u.role_id = r.id WHERE u.username = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        }
    }

    // ── Find by ID ────────────────────────────────────────────────────────────────
    public User findById(int userId) throws SQLException {
        final String sql = "SELECT u.*, r.role_name FROM users u "
                         + "JOIN roles r ON u.role_id = r.id WHERE u.id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        }
    }

    // ── Insert new user ───────────────────────────────────────────────────────────
    public int insert(User user) throws SQLException {
        final String sql =
            "INSERT INTO users (username, password_hash, full_name, email, phone, "
            + "date_of_birth, national_id_number, role_id, status) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setDate  (6, Date.valueOf(user.getDateOfBirth()));
            ps.setString(7, user.getNationalIdNumber());
            ps.setInt   (8, user.getRoleId());
            ps.setString(9, user.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    // ── Update status ─────────────────────────────────────────────────────────────
    public void updateStatus(int userId, String status) throws SQLException {
        final String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, userId);
            ps.executeUpdate();
        }
    }

    // ── Update password ───────────────────────────────────────────────────────────
    public void updatePassword(int userId, String newHash) throws SQLException {
        final String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt   (2, userId);
            ps.executeUpdate();
        }
    }

    // ── Update session info ───────────────────────────────────────────────────────
    public void updateSession(int userId, boolean active, String sessionId) throws SQLException {
        final String sql =
            "UPDATE users SET is_session_active = ?, current_session_id = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setString (2, sessionId);
            ps.setInt    (3, userId);
            ps.executeUpdate();
        }
    }

    // ── Update user profile (manager edits) ──────────────────────────────────────
    public void updateProfile(User user) throws SQLException {
        final String sql =
            "UPDATE users SET full_name=?, email=?, phone=?, date_of_birth=?, "
            + "national_id_number=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setDate  (4, Date.valueOf(user.getDateOfBirth()));
            ps.setString(5, user.getNationalIdNumber());
            ps.setInt   (6, user.getId());
            ps.executeUpdate();
        }
    }

    // ── Get all customers ─────────────────────────────────────────────────────────
    public List<User> getAllCustomers() throws SQLException {
        final String sql = "SELECT u.*, r.role_name FROM users u "
                         + "JOIN roles r ON u.role_id = r.id "
                         + "WHERE r.role_name = 'CUSTOMER' ORDER BY u.created_at DESC";
        return queryList(sql);
    }

    // ── Get all managers ─────────────────────────────────────────────────────────
    public List<User> getAllManagers() throws SQLException {
        final String sql = "SELECT u.*, r.role_name FROM users u "
                         + "JOIN roles r ON u.role_id = r.id "
                         + "WHERE r.role_name = 'MANAGER' ORDER BY u.created_at DESC";
        return queryList(sql);
    }

    // ── Count failed login attempts in last hour ──────────────────────────────────
    public int countRecentFailedAttempts(String username) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM login_attempts "
                         + "WHERE username = ? AND success = FALSE "
                         + "AND attempt_time > DATE_SUB(NOW(), INTERVAL 1 HOUR)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ── Check uniqueness for registration ─────────────────────────────────────────
    public boolean existsByEmail(String email) throws SQLException {
        return countBy("email", email) > 0;
    }

    public boolean existsByNationalId(String nationalId) throws SQLException {
        return countBy("national_id_number", nationalId) > 0;
    }

    public boolean existsByUsername(String username) throws SQLException {
        return countBy("username", username) > 0;
    }

    private int countBy(String column, String value) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE " + column + " = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ── Admin: delete user ───────────────────────────────────────────────────────
    public void deleteById(int userId) throws SQLException {
        final String sql = "DELETE FROM users WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    // ── Insert manager (admin feature) ───────────────────────────────────────────
    public int insertManager(User user) throws SQLException {
        user.setStatus("ACTIVE");
        return insert(user);
    }

    // ── Verify forgot-password fields ─────────────────────────────────────────────
    public User verifyForgotPasswordFields(String username, String fullName, String email,
                                            String phone, String dob, String nationalId,
                                            String accountNumber) throws SQLException {
        final String sql =
            "SELECT u.*, r.role_name FROM users u "
            + "JOIN roles r ON u.role_id = r.id "
            + "JOIN accounts a ON a.user_id = u.id "
            + "WHERE u.username = ? AND u.full_name = ? AND u.email = ? "
            + "AND u.phone = ? AND u.date_of_birth = ? "
            + "AND u.national_id_number = ? AND a.account_number = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDate  (5, Date.valueOf(dob));
            ps.setString(6, nationalId);
            ps.setString(7, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        }
    }

    // ── Count password reset attempts ─────────────────────────────────────────────
    public int countPasswordResetAttempts(String username) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM password_reset_attempts WHERE username = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────────
    private List<User> queryList(String sql) throws SQLException {
        List<User> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapUser(rs));
        }
        return list;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) u.setDateOfBirth(dob.toLocalDate());
        u.setNationalIdNumber(rs.getString("national_id_number"));
        u.setRoleId(rs.getInt("role_id"));
        u.setRoleName(rs.getString("role_name"));
        u.setStatus(rs.getString("status"));
        u.setSessionActive(rs.getBoolean("is_session_active"));
        u.setCurrentSessionId(rs.getString("current_session_id"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }
}