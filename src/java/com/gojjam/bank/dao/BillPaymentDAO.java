package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.BillPayment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillPaymentDAO {

    private static final String JOIN_SQL =
        "SELECT bp.*, a.account_number, u.full_name AS owner_name "
        + "FROM bill_payments bp "
        + "JOIN accounts a ON bp.account_id = a.id "
        + "JOIN users u ON a.user_id = u.id ";

    public int insert(Connection conn, BillPayment bp) throws SQLException {
        final String sql =
            "INSERT INTO bill_payments (account_id, bill_type, amount, fee, "
            + "reference_number, provider_name, status) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, bp.getAccountId());
            ps.setString    (2, bp.getBillType());
            ps.setBigDecimal(3, bp.getAmount());
            ps.setBigDecimal(4, bp.getFee());
            ps.setString    (5, bp.getReferenceNumber());
            ps.setString    (6, bp.getProviderName());
            ps.setString    (7, "SUCCESS");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public boolean isDuplicatePayment(int accountId, String billType, String referenceNumber) throws SQLException {
        final String sql =
            "SELECT COUNT(*) FROM bill_payments WHERE account_id=? AND bill_type=? "
            + "AND reference_number=? AND status='SUCCESS'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt   (1, accountId);
            ps.setString(2, billType);
            ps.setString(3, referenceNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public BillPayment findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE bp.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapBill(rs) : null;
            }
        }
    }

    public List<BillPayment> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL + "WHERE bp.account_id = ? ORDER BY bp.created_at DESC";
        List<BillPayment> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapBill(rs));
            }
        }
        return list;
    }

    private BillPayment mapBill(ResultSet rs) throws SQLException {
        BillPayment bp = new BillPayment();
        bp.setId(rs.getInt("id"));
        bp.setAccountId(rs.getInt("account_id"));
        bp.setBillType(rs.getString("bill_type"));
        bp.setAmount(rs.getBigDecimal("amount"));
        bp.setFee(rs.getBigDecimal("fee"));
        bp.setReferenceNumber(rs.getString("reference_number"));
        bp.setProviderName(rs.getString("provider_name"));
        bp.setStatus(rs.getString("status"));
        bp.setAccountNumber(rs.getString("account_number"));
        bp.setOwnerName(rs.getString("owner_name"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) bp.setCreatedAt(ts.toLocalDateTime());
        return bp;
    }
}