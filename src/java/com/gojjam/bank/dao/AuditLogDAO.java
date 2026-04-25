package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.AuditLog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    public void insert(Integer userId, String action, String ip,
                       String oldValue, String newValue) throws SQLException {
        final String sql =
            "INSERT INTO audit_logs (user_id, action, ip_address, old_value, new_value) "
            + "VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (userId != null) ps.setInt(1, userId); else ps.setNull(1, Types.INTEGER);
            ps.setString(2, action);
            ps.setString(3, ip);
            ps.setString(4, oldValue);
            ps.setString(5, newValue);
            ps.executeUpdate();
        }
    }

    public List<AuditLog> getAll(int limit) throws SQLException {
        final String sql =
            "SELECT al.*, u.full_name AS user_full_name FROM audit_logs al "
            + "LEFT JOIN users u ON al.user_id = u.id "
            + "ORDER BY al.created_at DESC LIMIT ?";
        List<AuditLog> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapLog(rs));
            }
        }
        return list;
    }

    public List<AuditLog> getByUser(int userId, int limit) throws SQLException {
        final String sql =
            "SELECT al.*, u.full_name AS user_full_name FROM audit_logs al "
            + "LEFT JOIN users u ON al.user_id = u.id "
            + "WHERE al.user_id = ? ORDER BY al.created_at DESC LIMIT ?";
        List<AuditLog> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapLog(rs));
            }
        }
        return list;
    }

    private AuditLog mapLog(ResultSet rs) throws SQLException {
        AuditLog log = new AuditLog();
        log.setId(rs.getLong("id"));
        int uid = rs.getInt("user_id");
        if (!rs.wasNull()) log.setUserId(uid);
        log.setUserFullName(rs.getString("user_full_name"));
        log.setAction(rs.getString("action"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setOldValue(rs.getString("old_value"));
        log.setNewValue(rs.getString("new_value"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) log.setCreatedAt(ts.toLocalDateTime());
        return log;
    }
}