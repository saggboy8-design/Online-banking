package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.SystemConfig;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SystemConfigDAO {

    public String getValue(String key) throws SQLException {
        final String sql = "SELECT config_value FROM system_config WHERE config_key = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("config_value") : null;
            }
        }
    }

    public BigDecimal getDecimalValue(String key, BigDecimal defaultValue) {
        try {
            String val = getValue(key);
            return val != null ? new BigDecimal(val) : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public int getIntValue(String key, int defaultValue) {
        try {
            String val = getValue(key);
            return val != null ? Integer.parseInt(val) : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    public List<SystemConfig> getAll() throws SQLException {
        final String sql =
            "SELECT sc.*, u.full_name AS updated_by_name FROM system_config sc "
            + "LEFT JOIN users u ON sc.updated_by = u.id ORDER BY sc.config_key";
        List<SystemConfig> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SystemConfig cfg = new SystemConfig();
                cfg.setId(rs.getInt("id"));
                cfg.setConfigKey(rs.getString("config_key"));
                cfg.setConfigValue(rs.getString("config_value"));
                cfg.setDescription(rs.getString("description"));
                int ub = rs.getInt("updated_by");
                if (!rs.wasNull()) cfg.setUpdatedBy(ub);
                cfg.setUpdatedByName(rs.getString("updated_by_name"));
                list.add(cfg);
            }
        }
        return list;
    }

    public void update(String key, String value, int updatedBy) throws SQLException {
        final String sql =
            "UPDATE system_config SET config_value=?, updated_by=? WHERE config_key=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setInt   (2, updatedBy);
            ps.setString(3, key);
            ps.executeUpdate();
        }
    }
}