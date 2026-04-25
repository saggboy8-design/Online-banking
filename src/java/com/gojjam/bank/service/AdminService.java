package com.gojjam.bank.service;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.*;
import com.gojjam.bank.util.AuditLogUtil;
import com.gojjam.bank.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.*;

public class AdminService {

    private final UserDAO        userDAO     = new UserDAO();
    private final AccountDAO     accountDAO  = new AccountDAO();
    private final TransactionDAO txDAO       = new TransactionDAO();
    private final TransferDAO    transferDAO = new TransferDAO();

    /** Admin reverses a successful transaction. */
    public void reverseTransaction(int txId, int adminId,
                                    HttpServletRequest request) throws BankingException, SQLException {
        Transaction tx = txDAO.findEligibleForReversal(txId);
        if (tx == null)
            throw new BankingException("Transaction not found or is not eligible for reversal.");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            // Determine reversal direction
            BigDecimal amount = tx.getAmount();
            if ("TRANSFER_OUT".equals(tx.getTransactionType())
                || "BILL_PAYMENT".equals(tx.getTransactionType())
                || "SCHEDULED".equals(tx.getTransactionType())) {
                // Refund: credit the debited account
                BigDecimal balance = accountDAO.getBalanceForUpdate(conn, tx.getAccountId());
                accountDAO.creditBalance(conn, tx.getAccountId(), amount.add(tx.getFee()));
                BigDecimal newBal = balance.add(amount).add(tx.getFee());
                txDAO.insert(conn, tx.getAccountId(), "REVERSAL", amount, tx.getFee(), newBal,
                    "Reversal of transaction ID: " + txId + " by Admin ID: " + adminId);
            } else if ("TRANSFER_IN".equals(tx.getTransactionType())
                    || "DEPOSIT".equals(tx.getTransactionType())
                    || "LOAN_CREDIT".equals(tx.getTransactionType())) {
                // Debit back
                BigDecimal balance = accountDAO.getBalanceForUpdate(conn, tx.getAccountId());
                if (balance.compareTo(amount) < 0)
                    throw new BankingException("Cannot reverse: account has insufficient balance for debit-back.");
                accountDAO.debitBalance(conn, tx.getAccountId(), amount);
                BigDecimal newBal = balance.subtract(amount);
                txDAO.insert(conn, tx.getAccountId(), "REVERSAL", amount, BigDecimal.ZERO, newBal,
                    "Reversal of transaction ID: " + txId + " by Admin ID: " + adminId);
            }

            txDAO.markReversed(conn, txId, adminId);
            conn.commit();

            AuditLogUtil.log(adminId,
                "TRANSACTION REVERSED: ID=" + txId + " | Amount: ETB " + amount, request,
                "Status: SUCCESS", "Status: REVERSED");

        } catch (BankingException | SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }

    /** Admin adds a new manager account. */
    public void addManager(String username, String rawPassword, String fullName,
                            String email, String phone, String dobStr, String nationalId,
                            int adminId, HttpServletRequest request) throws BankingException, SQLException {

        if (!PasswordUtil.isStrong(rawPassword))
            throw new BankingException("Password does not meet security requirements.");
        if (userDAO.existsByUsername(username)) throw new BankingException("Username already taken.");
        if (userDAO.existsByEmail(email))       throw new BankingException("Email already registered.");

        int managerRoleId = getManagerRoleId();
        User manager = new User();
        manager.setUsername(username.trim());
        manager.setPasswordHash(PasswordUtil.hash(rawPassword));
        manager.setFullName(fullName.trim());
        manager.setEmail(email.trim().toLowerCase());
        manager.setPhone(phone.trim());
        manager.setDateOfBirth(java.time.LocalDate.parse(dobStr));
        manager.setNationalIdNumber(nationalId.trim().toUpperCase());
        manager.setRoleId(managerRoleId);
        manager.setStatus("ACTIVE");

        int managerId = userDAO.insertManager(manager);
        AuditLogUtil.log(adminId, "MANAGER CREATED: " + username + " | By Admin ID: " + adminId, request);
    }

    /** Admin deletes a manager account. */
    public void deleteManager(int managerId, int adminId,
                               HttpServletRequest request) throws BankingException, SQLException {
        User manager = userDAO.findById(managerId);
        if (manager == null) throw new BankingException("Manager not found.");
        if (!"MANAGER".equals(manager.getRoleName())) throw new BankingException("Target user is not a manager.");
        userDAO.deleteById(managerId);
        AuditLogUtil.log(adminId, "MANAGER DELETED: ID=" + managerId + " | " + manager.getUsername(), request,
            "Status: ACTIVE", "Status: DELETED");
    }

    /** Admin locks an account. */
    public void lockAccount(int targetUserId, int adminId,
                             HttpServletRequest request) throws BankingException, SQLException {
        userDAO.updateStatus(targetUserId, "LOCKED");
        AuditLogUtil.log(adminId, "ACCOUNT LOCKED: User ID=" + targetUserId, request,
            "Status: ACTIVE", "Status: LOCKED");
    }

    /** Admin unlocks an account. */
    public void unlockAccount(int targetUserId, int adminId,
                               HttpServletRequest request) throws BankingException, SQLException {
        userDAO.updateStatus(targetUserId, "ACTIVE");
        AuditLogUtil.log(adminId, "ACCOUNT UNLOCKED: User ID=" + targetUserId, request,
            "Status: LOCKED", "Status: ACTIVE");
    }

    private int getManagerRoleId() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT id FROM roles WHERE role_name='MANAGER'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 2;
        }
    }
}