package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Withdrawal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class WithdrawalDAO {

    private static final String JOIN_SQL =
        "SELECT w.*, a.account_number, u.full_name AS owner_name, "
        + "u.phone AS owner_phone, u.email AS owner_email, "
        + "m.full_name AS manager_name "
        + "FROM withdrawals w "
        + "JOIN accounts a ON w.account_id = a.id "
        + "JOIN users u ON a.user_id = u.id "
        + "LEFT JOIN users m ON w.manager_id = m.id ";

    /**
     * Insert using an existing connection (inside an active transaction).
     */
    public int insertWithConn(Connection conn, Withdrawal w) throws SQLException {
        final String sql =
            "INSERT INTO withdrawals (account_id, amount, fee, withdrawal_method, "
            + "reason, status, reference_number) VALUES (?,?,?,?,?,?,?)";
        String ref = "WDR" + UUID.randomUUID().toString()
                             .replace("-","").substring(0,10).toUpperCase();
        w.setReferenceNumber(ref);
        try (PreparedStatement ps = conn.prepareStatement(sql,
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, w.getAccountId());
            ps.setBigDecimal(2, w.getAmount());
            ps.setBigDecimal(3, w.getFee());
            ps.setString    (4, w.getWithdrawalMethod());
            ps.setString    (5, w.getReason());
            ps.setString    (6, "SUCCESS");  // immediate
            ps.setString    (7, ref);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    /** Insert using a new connection (standalone). */
    public int insert(Withdrawal w) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            return insertWithConn(c, w);
        }
    }

    public Withdrawal findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE w.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Withdrawal> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL
            + "WHERE w.account_id = ? ORDER BY w.created_at DESC";
        List<Withdrawal> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Withdrawal> getAll() throws SQLException {
        return queryList(JOIN_SQL + "ORDER BY w.created_at DESC LIMIT 300");
    }

    public int countAll() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM withdrawals");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Withdrawal> queryList(String sql) throws SQLException {
        List<Withdrawal> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    private Withdrawal map(ResultSet rs) throws SQLException {
        Withdrawal w = new Withdrawal();
        w.setId(rs.getInt("id"));
        w.setAccountId(rs.getInt("account_id"));
        w.setAmount(rs.getBigDecimal("amount"));
        w.setFee(rs.getBigDecimal("fee"));
        w.setWithdrawalMethod(rs.getString("withdrawal_method"));
        w.setReason(rs.getString("reason"));
        w.setStatus(rs.getString("status"));
        int mid = rs.getInt("manager_id");
        if (!rs.wasNull()) w.setManagerId(mid);
        w.setManagerName(rs.getString("manager_name"));
        w.setManagerNote(rs.getString("manager_note"));
        w.setReferenceNumber(rs.getString("reference_number"));
        w.setAccountNumber(rs.getString("account_number"));
        w.setOwnerName(rs.getString("owner_name"));
        w.setOwnerPhone(rs.getString("owner_phone"));
        w.setOwnerEmail(rs.getString("owner_email"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) w.setCreatedAt(ts.toLocalDateTime());
        return w;
    }
}