package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Transfer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransferDAO {

    private static final String JOIN_SQL =
        "SELECT tr.*, a.account_number AS sender_account_number, "
        + "u.full_name AS sender_name, m.full_name AS manager_name "
        + "FROM transfers tr "
        + "JOIN accounts a ON tr.sender_account_id = a.id "
        + "JOIN users u ON a.user_id = u.id "
        + "LEFT JOIN users m ON tr.manager_id = m.id ";

    /** Insert a new transfer record (inside existing connection/transaction). */
    public int insert(Connection conn, Transfer transfer) throws SQLException {
        final String sql =
            "INSERT INTO transfers (sender_account_id, receiver_account, transfer_type, "
            + "amount, fee, description, swift_code, bank_name, country, "
            + "beneficiary_name, status) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql,
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1,  transfer.getSenderAccountId());
            ps.setString    (2,  transfer.getReceiverAccount());
            ps.setString    (3,  transfer.getTransferType());
            ps.setBigDecimal(4,  transfer.getAmount());
            ps.setBigDecimal(5,  transfer.getFee());
            ps.setString    (6,  transfer.getDescription());
            ps.setString    (7,  transfer.getSwiftCode());
            ps.setString    (8,  transfer.getBankName());
            ps.setString    (9,  transfer.getCountry());
            ps.setString    (10, transfer.getBeneficiaryName());
            ps.setString    (11, transfer.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    /** Find by primary key. */
    public Transfer findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE tr.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapTransfer(rs) : null;
            }
        }
    }

    /** All PENDING external / international transfers (for manager). */
    public List<Transfer> getPendingExternal() throws SQLException {
        final String sql = JOIN_SQL
            + "WHERE tr.status = 'PENDING' "
            + "AND tr.transfer_type IN ('EXTERNAL','INTERNATIONAL') "
            + "ORDER BY tr.created_at ASC";
        return queryList(sql);
    }

    /** All transfers by sender account. */
    public List<Transfer> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL
            + "WHERE tr.sender_account_id = ? ORDER BY tr.created_at DESC";
        List<Transfer> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTransfer(rs));
            }
        }
        return list;
    }

    /** All transfers (manager / admin view). */
    public List<Transfer> getAll() throws SQLException {
        return queryList(JOIN_SQL + "ORDER BY tr.created_at DESC LIMIT 500");
    }

    /** Update status (and optionally set manager). */
    public void updateStatus(int transferId, String status,
                             int managerId) throws SQLException {
        final String sql =
            "UPDATE transfers SET status = ?, manager_id = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, managerId);
            ps.setInt   (3, transferId);
            ps.executeUpdate();
        }
    }

    /** Count pending external transfers (manager dashboard badge). */
    public int countPendingExternal() throws SQLException {
        final String sql =
            "SELECT COUNT(*) FROM transfers "
            + "WHERE status='PENDING' AND transfer_type IN ('EXTERNAL','INTERNATIONAL')";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── private helpers ───────────────────────────────────────────────────────
    private List<Transfer> queryList(String sql) throws SQLException {
        List<Transfer> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapTransfer(rs));
        }
        return list;
    }

    private Transfer mapTransfer(ResultSet rs) throws SQLException {
        Transfer t = new Transfer();
        t.setId(rs.getInt("id"));
        t.setSenderAccountId(rs.getInt("sender_account_id"));
        t.setReceiverAccount(rs.getString("receiver_account"));
        t.setTransferType(rs.getString("transfer_type"));
        t.setAmount(rs.getBigDecimal("amount"));
        t.setFee(rs.getBigDecimal("fee"));
        t.setDescription(rs.getString("description"));
        t.setSwiftCode(rs.getString("swift_code"));
        t.setBankName(rs.getString("bank_name"));
        t.setCountry(rs.getString("country"));
        t.setBeneficiaryName(rs.getString("beneficiary_name"));
        t.setStatus(rs.getString("status"));
        int mid = rs.getInt("manager_id");
        if (!rs.wasNull()) t.setManagerId(mid);
        t.setManagerName(rs.getString("manager_name"));
        t.setSenderAccountNumber(rs.getString("sender_account_number"));
        t.setSenderName(rs.getString("sender_name"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) t.setCreatedAt(ts.toLocalDateTime());
        return t;
    }
}