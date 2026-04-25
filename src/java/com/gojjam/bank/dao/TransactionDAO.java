package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Transaction;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class TransactionDAO {

    private static final String JOIN_SQL =
        "SELECT t.*, a.account_number, u.full_name AS owner_name "
        + "FROM transactions t "
        + "JOIN accounts a ON t.account_id = a.id "
        + "JOIN users u ON a.user_id = u.id ";

    // ── Insert (inside existing connection/transaction) ───────────────────────────
    public int insert(Connection conn, int accountId, String type,
                      BigDecimal amount, BigDecimal fee,
                      BigDecimal balanceAfter, String description) throws SQLException {
        final String sql =
            "INSERT INTO transactions (account_id, transaction_type, amount, fee, "
            + "balance_after, description, reference_number, status) VALUES (?,?,?,?,?,?,?,?)";
        String refNum = "TXN" + UUID.randomUUID().toString().replace("-","").substring(0,12).toUpperCase();
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, accountId);
            ps.setString    (2, type);
            ps.setBigDecimal(3, amount);
            ps.setBigDecimal(4, fee);
            ps.setBigDecimal(5, balanceAfter);
            ps.setString    (6, description);
            ps.setString    (7, refNum);
            ps.setString    (8, "SUCCESS");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    // ── Find by ID ────────────────────────────────────────────────────────────────
    public Transaction findById(int id) throws SQLException {
        final String sql = JOIN_SQL + "WHERE t.id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapTransaction(rs) : null;
            }
        }
    }

    // ── Last N transactions by account ────────────────────────────────────────────
    public List<Transaction> getLastN(int accountId, int limit) throws SQLException {
        final String sql = JOIN_SQL + "WHERE t.account_id = ? ORDER BY t.created_at DESC LIMIT ?";
        List<Transaction> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    // ── All transactions by account ───────────────────────────────────────────────
    public List<Transaction> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL + "WHERE t.account_id = ? ORDER BY t.created_at DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    // ── Transactions in date range ────────────────────────────────────────────────
    public List<Transaction> getByAccountAndDateRange(int accountId,
                                                       String fromDate,
                                                       String toDate) throws SQLException {
        final String sql = JOIN_SQL
            + "WHERE t.account_id = ? AND DATE(t.created_at) BETWEEN ? AND ? "
            + "ORDER BY t.created_at DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt   (1, accountId);
            ps.setString(2, fromDate);
            ps.setString(3, toDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    // ── All transactions (admin) ──────────────────────────────────────────────────
    public List<Transaction> getAll() throws SQLException {
        final String sql = JOIN_SQL + "ORDER BY t.created_at DESC LIMIT 500";
        List<Transaction> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapTransaction(rs));
        }
        return list;
    }

    // ── Mark as reversed ──────────────────────────────────────────────────────────
    public void markReversed(Connection conn, int txId, int reversedBy) throws SQLException {
        final String sql = "UPDATE transactions SET status='REVERSED', reversed_by=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reversedBy);
            ps.setInt(2, txId);
            ps.executeUpdate();
        }
    }

    // ── Count today's transactions ────────────────────────────────────────────────
    public int countToday(int accountId) throws SQLException {
        final String sql =
            "SELECT COUNT(*) FROM transactions WHERE account_id=? AND DATE(created_at)=CURDATE()";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ── Total count (admin dashboard) ─────────────────────────────────────────────
    public int countAll() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM transactions");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── Eligible for reversal (SUCCESS status only) ───────────────────────────────
    public Transaction findEligibleForReversal(int txId) throws SQLException {
        final String sql = JOIN_SQL + "WHERE t.id = ? AND t.status = 'SUCCESS'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, txId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapTransaction(rs) : null;
            }
        }
    }

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setId(rs.getInt("id"));
        t.setAccountId(rs.getInt("account_id"));
        t.setTransactionType(rs.getString("transaction_type"));
        t.setAmount(rs.getBigDecimal("amount"));
        t.setFee(rs.getBigDecimal("fee"));
        t.setBalanceAfter(rs.getBigDecimal("balance_after"));
        t.setDescription(rs.getString("description"));
        t.setReferenceNumber(rs.getString("reference_number"));
        t.setStatus(rs.getString("status"));
        int rb = rs.getInt("reversed_by");
        if (!rs.wasNull()) t.setReversedBy(rb);
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) t.setCreatedAt(ts.toLocalDateTime());
        t.setAccountNumber(rs.getString("account_number"));
        t.setOwnerName(rs.getString("owner_name"));
        return t;
    }
}