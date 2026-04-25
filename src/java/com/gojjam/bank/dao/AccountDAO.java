package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Account;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {

    // ── Find by user ID ───────────────────────────────────────────────────────────
    public Account findByUserId(int userId) throws SQLException {
        final String sql =
            "SELECT a.*, u.full_name AS owner_full_name, u.email AS owner_email, "
            + "u.phone AS owner_phone, m.full_name AS approved_by_name "
            + "FROM accounts a JOIN users u ON a.user_id = u.id "
            + "LEFT JOIN users m ON a.approved_by = m.id "
            + "WHERE a.user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapAccount(rs) : null;
            }
        }
    }

    // ── Find by account number ────────────────────────────────────────────────────
    public Account findByAccountNumber(String accountNumber) throws SQLException {
        final String sql =
            "SELECT a.*, u.full_name AS owner_full_name, u.email AS owner_email, "
            + "u.phone AS owner_phone, m.full_name AS approved_by_name "
            + "FROM accounts a JOIN users u ON a.user_id = u.id "
            + "LEFT JOIN users m ON a.approved_by = m.id "
            + "WHERE a.account_number = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapAccount(rs) : null;
            }
        }
    }

    // ── Find by account ID ────────────────────────────────────────────────────────
    public Account findById(int id) throws SQLException {
        final String sql =
            "SELECT a.*, u.full_name AS owner_full_name, u.email AS owner_email, "
            + "u.phone AS owner_phone, m.full_name AS approved_by_name "
            + "FROM accounts a JOIN users u ON a.user_id = u.id "
            + "LEFT JOIN users m ON a.approved_by = m.id "
            + "WHERE a.id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapAccount(rs) : null;
            }
        }
    }

    // ── Insert new account ────────────────────────────────────────────────────────
    public int insert(Account account) throws SQLException {
        final String sql =
            "INSERT INTO accounts (user_id, account_number, balance, account_type, kyc_status) "
            + "VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, account.getUserId());
            ps.setString    (2, account.getAccountNumber());
            ps.setBigDecimal(3, account.getBalance());
            ps.setString    (4, account.getAccountType());
            ps.setString    (5, account.getKycStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    // ── Lock balance for UPDATE (must be called inside a transaction) ─────────────
    public BigDecimal getBalanceForUpdate(Connection conn, int accountId) throws SQLException {
        final String sql = "SELECT balance FROM accounts WHERE id = ? FOR UPDATE";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("balance");
                throw new SQLException("Account not found for id: " + accountId);
            }
        }
    }

    // ── Debit balance (inside existing transaction) ────────────────────────────────
    public void debitBalance(Connection conn, int accountId, BigDecimal amount) throws SQLException {
        final String sql = "UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt       (2, accountId);
            ps.setBigDecimal(3, amount);
            int rows = ps.executeUpdate();
            if (rows == 0) throw new SQLException("Insufficient balance – debit aborted.");
        }
    }

    // ── Credit balance (inside existing transaction) ───────────────────────────────
    public void creditBalance(Connection conn, int accountId, BigDecimal amount) throws SQLException {
        final String sql = "UPDATE accounts SET balance = balance + ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt       (2, accountId);
            ps.executeUpdate();
        }
    }

    // ── Update KYC status ─────────────────────────────────────────────────────────
    public void updateKycStatus(int accountId, String status, int managerId) throws SQLException {
        final String sql = "UPDATE accounts SET kyc_status = ?, approved_by = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, managerId);
            ps.setInt   (3, accountId);
            ps.executeUpdate();
        }
    }

    // ── Admin: manually set balance ───────────────────────────────────────────────
    public void setBalance(int accountId, BigDecimal newBalance) throws SQLException {
        final String sql = "UPDATE accounts SET balance = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBigDecimal(1, newBalance);
            ps.setInt       (2, accountId);
            ps.executeUpdate();
        }
    }

    // ── Get all accounts ──────────────────────────────────────────────────────────
    public List<Account> getAll() throws SQLException {
        final String sql =
            "SELECT a.*, u.full_name AS owner_full_name, u.email AS owner_email, "
            + "u.phone AS owner_phone, m.full_name AS approved_by_name "
            + "FROM accounts a JOIN users u ON a.user_id = u.id "
            + "LEFT JOIN users m ON a.approved_by = m.id ORDER BY a.created_at DESC";
        List<Account> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapAccount(rs));
        }
        return list;
    }

    // ── Get pending KYC ───────────────────────────────────────────────────────────
    public List<Account> getPendingKyc() throws SQLException {
        final String sql =
            "SELECT a.*, u.full_name AS owner_full_name, u.email AS owner_email, "
            + "u.phone AS owner_phone, m.full_name AS approved_by_name "
            + "FROM accounts a JOIN users u ON a.user_id = u.id "
            + "LEFT JOIN users m ON a.approved_by = m.id "
            + "WHERE a.kyc_status = 'PENDING' ORDER BY a.created_at DESC";
        List<Account> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapAccount(rs));
        }
        return list;
    }

    // ── Count all accounts ────────────────────────────────────────────────────────
    public int countAll() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM accounts");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── Total deposits in system ──────────────────────────────────────────────────
    public BigDecimal totalBalance() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COALESCE(SUM(balance),0) FROM accounts");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    // ── Map ResultSet to Account ──────────────────────────────────────────────────
    private Account mapAccount(ResultSet rs) throws SQLException {
        Account a = new Account();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setAccountNumber(rs.getString("account_number"));
        a.setBalance(rs.getBigDecimal("balance"));
        a.setAccountType(rs.getString("account_type"));
        a.setKycStatus(rs.getString("kyc_status"));
        int approvedBy = rs.getInt("approved_by");
        if (!rs.wasNull()) a.setApprovedBy(approvedBy);
        a.setApprovedByName(rs.getString("approved_by_name"));
        a.setOwnerFullName(rs.getString("owner_full_name"));
        a.setOwnerEmail(rs.getString("owner_email"));
        a.setOwnerPhone(rs.getString("owner_phone"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) a.setCreatedAt(ts.toLocalDateTime());
        return a;
    }
}