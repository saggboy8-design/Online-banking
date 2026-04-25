package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Complaint;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private static final String JOIN_SQL =
        "SELECT c.*, u.full_name AS user_name, r.full_name AS responded_by_name "
        + "FROM complaints c JOIN users u ON c.user_id = u.id "
        + "LEFT JOIN users r ON c.responded_by = r.id ";

    public int insert(Complaint complaint) throws SQLException {
        final String sql =
            "INSERT INTO complaints (user_id, category, description, status) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt   (1, complaint.getUserId());
            ps.setString(2, complaint.getCategory());
            ps.setString(3, complaint.getDescription());
            ps.setString(4, "OPEN");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public List<Complaint> getAll() throws SQLException {
        return queryList(JOIN_SQL + "ORDER BY c.created_at DESC");
    }

    public List<Complaint> getByUser(int userId) throws SQLException {
        final String sql = JOIN_SQL + "WHERE c.user_id = ? ORDER BY c.created_at DESC";
        List<Complaint> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapComplaint(rs));
            }
        }
        return list;
    }

    public void respond(int complaintId, int responderId, String response, String status) throws SQLException {
        final String sql =
            "UPDATE complaints SET response=?, responded_by=?, status=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, response);
            ps.setInt   (2, responderId);
            ps.setString(3, status);
            ps.setInt   (4, complaintId);
            ps.executeUpdate();
        }
    }

    public int countOpen() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT COUNT(*) FROM complaints WHERE status='OPEN'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Complaint> queryList(String sql) throws SQLException {
        List<Complaint> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapComplaint(rs));
        }
        return list;
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint cmp = new Complaint();
        cmp.setId(rs.getInt("id"));
        cmp.setUserId(rs.getInt("user_id"));
        cmp.setUserName(rs.getString("user_name"));
        cmp.setCategory(rs.getString("category"));
        cmp.setDescription(rs.getString("description"));
        cmp.setStatus(rs.getString("status"));
        cmp.setResponse(rs.getString("response"));
        int rb = rs.getInt("responded_by");
        if (!rs.wasNull()) cmp.setRespondedBy(rb);
        cmp.setRespondedByName(rs.getString("responded_by_name"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) cmp.setCreatedAt(ts.toLocalDateTime());
        Timestamp us = rs.getTimestamp("updated_at");
        if (us != null) cmp.setUpdatedAt(us.toLocalDateTime());
        return cmp;
    }
}