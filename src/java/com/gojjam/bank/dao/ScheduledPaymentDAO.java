package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.ScheduledPayment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduledPaymentDAO {

    private static final String JOIN_SQL =
        "SELECT sp.*, a.account_number, u.full_name AS owner_name "
        + "FROM scheduled_payments sp "
        + "JOIN accounts a ON sp.account_id = a.id "
        + "JOIN users u ON a.user_id = u.id ";

    public int insert(ScheduledPayment sp) throws SQLException {
        final String sql =
            "INSERT INTO scheduled_payments (account_id, payment_type, amount, fee, "
            + "recipient, reference_number, frequency, scheduled_date, next_execution, status) "
            + "VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, sp.getAccountId());
            ps.setString    (2, sp.getPaymentType());
            ps.setBigDecimal(3, sp.getAmount());
            ps.setBigDecimal(4, sp.getFee());
            ps.setString    (5, sp.getRecipient());
            ps.setString    (6, sp.getReferenceNumber());
            ps.setString    (7, sp.getFrequency());
            ps.setTimestamp (8, Timestamp.valueOf(sp.getScheduledDate()));
            ps.setTimestamp (9, Timestamp.valueOf(sp.getScheduledDate()));
            ps.setString    (10, "PENDING");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public List<ScheduledPayment> getDue() throws SQLException {
        final String sql = JOIN_SQL
            + "WHERE sp.status='PENDING' AND sp.next_execution <= NOW() "
            + "ORDER BY sp.next_execution ASC";
        return queryList(sql);
    }

    public List<ScheduledPayment> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL
            + "WHERE sp.account_id = ? ORDER BY sp.scheduled_date DESC";
        List<ScheduledPayment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapPayment(rs));
            }
        }
        return list;
    }

    public void updateAfterExecution(int id, String status,
                                      Timestamp nextExecution) throws SQLException {
        final String sql =
            "UPDATE scheduled_payments SET status=?, last_executed=NOW(), "
            + "next_execution=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString   (1, status);
            ps.setTimestamp(2, nextExecution);
            ps.setInt      (3, id);
            ps.executeUpdate();
        }
    }

    public void cancel(int id) throws SQLException {
        final String sql = "UPDATE scheduled_payments SET status='CANCELLED' WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private List<ScheduledPayment> queryList(String sql) throws SQLException {
        List<ScheduledPayment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapPayment(rs));
        }
        return list;
    }

    private ScheduledPayment mapPayment(ResultSet rs) throws SQLException {
        ScheduledPayment sp = new ScheduledPayment();
        sp.setId(rs.getInt("id"));
        sp.setAccountId(rs.getInt("account_id"));
        sp.setPaymentType(rs.getString("payment_type"));
        sp.setAmount(rs.getBigDecimal("amount"));
        sp.setFee(rs.getBigDecimal("fee"));
        sp.setRecipient(rs.getString("recipient"));
        sp.setReferenceNumber(rs.getString("reference_number"));
        sp.setFrequency(rs.getString("frequency"));
        Timestamp sd = rs.getTimestamp("scheduled_date");
        if (sd != null) sp.setScheduledDate(sd.toLocalDateTime());
        Timestamp ne = rs.getTimestamp("next_execution");
        if (ne != null) sp.setNextExecution(ne.toLocalDateTime());
        Timestamp le = rs.getTimestamp("last_executed");
        if (le != null) sp.setLastExecuted(le.toLocalDateTime());
        sp.setStatus(rs.getString("status"));
        sp.setAccountNumber(rs.getString("account_number"));
        sp.setOwnerName(rs.getString("owner_name"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) sp.setCreatedAt(ts.toLocalDateTime());
        return sp;
    }
}