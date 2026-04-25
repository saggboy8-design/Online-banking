package com.gojjam.bank.service;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.exception.InsufficientBalanceException;
import com.gojjam.bank.model.*;
import com.gojjam.bank.util.AuditLogUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.*;

public class WithdrawalService {

    private final WithdrawalDAO   withdrawalDAO = new WithdrawalDAO();
    private final AccountDAO      accountDAO    = new AccountDAO();
    private final TransactionDAO  txDAO         = new TransactionDAO();
    private final SystemConfigDAO configDAO     = new SystemConfigDAO();

    /**
     * Immediate withdrawal – no manager approval needed.
     * Requires re-authentication to have been completed before calling.
     * Uses SELECT ... FOR UPDATE for concurrency safety.
     */
    public Withdrawal withdraw(int userId,
                               BigDecimal amount,
                               String method,
                               String reason,
                               HttpServletRequest request)
            throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Withdrawal amount must be greater than zero.");

        if (amount.compareTo(new BigDecimal("50")) < 0)
            throw new BankingException("Minimum withdrawal amount is ETB 50.00.");

        if (ValidationUtil.isBlank(method))
            throw new BankingException("Withdrawal method is required.");

        BigDecimal fee = configDAO.getDecimalValue("withdrawal_fee", new BigDecimal("15"));

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            // Validate account
            Account account = accountDAO.findByUserId(userId);
            if (account == null) throw new BankingException("Account not found.");
            if (!"APPROVED".equals(account.getKycStatus()))
                throw new BankingException("Your KYC is not approved. Please contact the bank.");

            // Lock balance row – FOR UPDATE
            BigDecimal balance    = accountDAO.getBalanceForUpdate(conn, account.getId());
            BigDecimal totalDebit = amount.add(fee);

            // Strict balance check
            if (balance.compareTo(totalDebit) < 0)
                throw new InsufficientBalanceException();

            // Deduct balance atomically
            accountDAO.debitBalance(conn, account.getId(), totalDebit);
            BigDecimal balanceAfter = balance.subtract(totalDebit);

            // Create withdrawal record
            Withdrawal w = new Withdrawal();
            w.setAccountId(account.getId());
            w.setAmount(amount);
            w.setFee(fee);
            w.setWithdrawalMethod(method);
            w.setReason(reason != null ? reason.trim() : "");

            int wdId = withdrawalDAO.insertWithConn(conn, w);
            w.setId(wdId);
            w.setAccountNumber(account.getAccountNumber());
            w.setOwnerName(account.getOwnerFullName());

            // Record transaction
            txDAO.insert(conn, account.getId(), "WITHDRAWAL", amount, fee, balanceAfter,
                    "Withdrawal via " + method
                    + (reason != null && !reason.isBlank() ? " | " + reason : "")
                    + " | Ref: " + w.getReferenceNumber());

            conn.commit();

            AuditLogUtil.log(userId,
                    "WITHDRAWAL SUCCESS: ETB " + amount
                    + " | Method: " + method
                    + " | Fee: ETB " + fee
                    + " | Ref: " + w.getReferenceNumber(),
                    request,
                    "Balance: " + balance,
                    "Balance: " + balanceAfter);

            return w;

        } catch (BankingException | SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (conn != null)
                try { conn.setAutoCommit(true); conn.close(); }
                catch (SQLException ignored) {}
        }
    }
}