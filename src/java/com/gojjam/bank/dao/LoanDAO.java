package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Loan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanDAO {

    private static final String JOIN_SQL =
        "SELECT l.*, a.account_number, u.full_name AS owner_name, "
        + "u.email AS owner_email, u.phone AS owner_phone, "
        + "u.national_id_number AS owner_national_id, "
        + "m.full_name AS manager_name "
        + "FROM loans l "
        + "JOIN accounts a ON l.account_id = a.id "
        + "JOIN users u ON a.user_id = u.id "
        + "LEFT JOIN users m ON l.manager_id = m.id ";

    public int insert(Loan loan) throws SQLException {
        final String sql =
            "INSERT INTO loans (account_id, amount, purpose, duration_months, "
            + "interest_rate, status) VALUES (?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, loan.getAccountId());
            ps.setBigDecimal(2, loan.getAmount());
            ps.setString    (3, loan.getPurpose());
            ps.setInt       (4, loan.getDurationMonths());
            ps.setBigDecimal(5, loan.getInterestRate());
            ps.setString    (6, "PENDING");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public Loan findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE l.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapLoan(rs) : null;
            }
        }
    }

    public List<Loan> getPending() throws SQLException {
        return queryList(JOIN_SQL + "WHERE l.status='PENDING' ORDER BY l.created_at DESC");
    }

    public List<Loan> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL + "WHERE l.account_id = ? ORDER BY l.created_at DESC";
        List<Loan> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapLoan(rs));
            }
        }
        return list;
    }

    public List<Loan> getAll() throws SQLException {
        return queryList(JOIN_SQL + "ORDER BY l.created_at DESC");
    }

    public void approve(int loanId, int managerId,
                        java.math.BigDecimal emi, java.math.BigDecimal totalPayable) throws SQLException {
        final String sql =
            "UPDATE loans SET status='APPROVED', manager_id=?, monthly_emi=?, "
            + "total_payable=?, outstanding_balance=?, approved_at=NOW() WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt       (1, managerId);
            ps.setBigDecimal(2, emi);
            ps.setBigDecimal(3, totalPayable);
            ps.setBigDecimal(4, totalPayable);
            ps.setInt       (5, loanId);
            ps.executeUpdate();
        }
    }

    public void reject(int loanId, int managerId, String reason) throws SQLException {
        final String sql =
            "UPDATE loans SET status='REJECTED', manager_id=?, rejection_reason=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt   (1, managerId);
            ps.setString(2, reason);
            ps.setInt   (3, loanId);
            ps.executeUpdate();
        }
    }

    public void markDisbursed(Connection conn, int loanId) throws SQLException {
        final String sql = "UPDATE loans SET status='DISBURSED' WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loanId);
            ps.executeUpdate();
        }
    }

    public int countPending() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT COUNT(*) FROM loans WHERE status='PENDING'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Loan> queryList(String sql) throws SQLException {
        List<Loan> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapLoan(rs));
        }
        return list;
    }

    private Loan mapLoan(ResultSet rs) throws SQLException {
        Loan l = new Loan();
        l.setId(rs.getInt("id"));
        l.setAccountId(rs.getInt("account_id"));
        l.setAmount(rs.getBigDecimal("amount"));
        l.setPurpose(rs.getString("purpose"));
        l.setDurationMonths(rs.getInt("duration_months"));
        l.setInterestRate(rs.getBigDecimal("interest_rate"));
        l.setMonthlyEmi(rs.getBigDecimal("monthly_emi"));
        l.setTotalPayable(rs.getBigDecimal("total_payable"));
        l.setOutstandingBalance(rs.getBigDecimal("outstanding_balance"));
        l.setStatus(rs.getString("status"));
        int mid = rs.getInt("manager_id");
        if (!rs.wasNull()) l.setManagerId(mid);
        l.setManagerName(rs.getString("manager_name"));
        l.setRejectionReason(rs.getString("rejection_reason"));
        l.setAccountNumber(rs.getString("account_number"));
        l.setOwnerName(rs.getString("owner_name"));
        l.setOwnerEmail(rs.getString("owner_email"));
        l.setOwnerPhone(rs.getString("owner_phone"));
        l.setOwnerNationalId(rs.getString("owner_national_id"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) l.setCreatedAt(ts.toLocalDateTime());
        Timestamp approvedAt = rs.getTimestamp("approved_at");
        if (approvedAt != null) l.setApprovedAt(approvedAt.toLocalDateTime());
        return l;
    }
}