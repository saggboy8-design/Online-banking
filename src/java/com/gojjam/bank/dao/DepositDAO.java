package com.gojjam.bank.dao;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.model.Deposit;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepositDAO {

    private static final String JOIN_SQL =
        "SELECT d.*, a.account_number, u.full_name AS owner_name, "
        + "m.full_name AS manager_name "
        + "FROM deposits d "
        + "JOIN accounts a ON d.account_id = a.id "
        + "JOIN users u ON a.user_id = u.id "
        + "LEFT JOIN users m ON d.manager_id = m.id ";

    public int insert(Deposit deposit) throws SQLException {
        final String sql =
            "INSERT INTO deposits (account_id, deposit_type, amount, fee, source_name, "
            + "source_account, swift_code, bank_name, country, iban, beneficiary_name, status) "
            + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, deposit.getAccountId());
            ps.setString    (2, deposit.getDepositType());
            ps.setBigDecimal(3, deposit.getAmount());
            ps.setBigDecimal(4, deposit.getFee());
            ps.setString    (5, deposit.getSourceName());
            ps.setString    (6, deposit.getSourceAccount());
            ps.setString    (7, deposit.getSwiftCode());
            ps.setString    (8, deposit.getBankName());
            ps.setString    (9, deposit.getCountry());
            ps.setString    (10, deposit.getIban());
            ps.setString    (11, deposit.getBeneficiaryName());
            ps.setString    (12, deposit.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public Deposit findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(JOIN_SQL + "WHERE d.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapDeposit(rs) : null;
            }
        }
    }

    public List<Deposit> getPending() throws SQLException {
        return queryList(JOIN_SQL + "WHERE d.status = 'PENDING' ORDER BY d.created_at DESC");
    }

    public List<Deposit> getByAccount(int accountId) throws SQLException {
        final String sql = JOIN_SQL + "WHERE d.account_id = ? ORDER BY d.created_at DESC";
        List<Deposit> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapDeposit(rs));
            }
        }
        return list;
    }

    public void updateStatus(int depositId, String status, int managerId, String notes) throws SQLException {
        final String sql =
            "UPDATE deposits SET status=?, manager_id=?, notes=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, managerId);
            ps.setString(3, notes);
            ps.setInt   (4, depositId);
            ps.executeUpdate();
        }
    }

    private List<Deposit> queryList(String sql) throws SQLException {
        List<Deposit> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapDeposit(rs));
        }
        return list;
    }

    private Deposit mapDeposit(ResultSet rs) throws SQLException {
        Deposit d = new Deposit();
        d.setId(rs.getInt("id"));
        d.setAccountId(rs.getInt("account_id"));
        d.setDepositType(rs.getString("deposit_type"));
        d.setAmount(rs.getBigDecimal("amount"));
        d.setFee(rs.getBigDecimal("fee"));
        d.setSourceName(rs.getString("source_name"));
        d.setSourceAccount(rs.getString("source_account"));
        d.setSwiftCode(rs.getString("swift_code"));
        d.setBankName(rs.getString("bank_name"));
        d.setCountry(rs.getString("country"));
        d.setIban(rs.getString("iban"));
        d.setBeneficiaryName(rs.getString("beneficiary_name"));
        d.setStatus(rs.getString("status"));
        int mid = rs.getInt("manager_id");
        if (!rs.wasNull()) d.setManagerId(mid);
        d.setManagerName(rs.getString("manager_name"));
        d.setNotes(rs.getString("notes"));
        d.setAccountNumber(rs.getString("account_number"));
        d.setOwnerName(rs.getString("owner_name"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) d.setCreatedAt(ts.toLocalDateTime());
        return d;
    }
}