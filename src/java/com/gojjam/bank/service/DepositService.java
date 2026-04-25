package com.gojjam.bank.service;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.*;
import com.gojjam.bank.util.AuditLogUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.*;

public class DepositService {

    private final AccountDAO      accountDAO = new AccountDAO();
    private final TransactionDAO  txDAO      = new TransactionDAO();
    private final DepositDAO      depositDAO = new DepositDAO();
    private final SystemConfigDAO configDAO  = new SystemConfigDAO();

    /** Customer submits a deposit request (internal = immediate, external/intl = PENDING). */
    public Deposit submitDeposit(int userId, String depositType, BigDecimal amount,
                                  String sourceName, String sourceAccount,
                                  String beneficiaryName, String bankName,
                                  String swiftCode, String country, String iban,
                                  HttpServletRequest request) throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Deposit amount must be greater than zero.");

        Account account = accountDAO.findByUserId(userId);
        if (account == null) throw new BankingException("Account not found.");
        if (!"APPROVED".equals(account.getKycStatus()))
            throw new BankingException("Your KYC is not approved. Contact the bank.");

        String feeKey = "INTERNAL".equals(depositType)
            ? "internal_deposit_fee" : "external_deposit_fee";
        BigDecimal fee = configDAO.getDecimalValue(feeKey, BigDecimal.ZERO);

        Deposit deposit = new Deposit();
        deposit.setAccountId(account.getId());
        deposit.setDepositType(depositType);
        deposit.setAmount(amount);
        deposit.setFee(fee);
        deposit.setSourceName(sourceName);
        deposit.setSourceAccount(sourceAccount);
        deposit.setBeneficiaryName(beneficiaryName);
        deposit.setBankName(bankName);
        deposit.setSwiftCode(swiftCode);
        deposit.setCountry(country);
        deposit.setIban(iban);

        if ("INTERNAL".equals(depositType)) {
            // Process immediately
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false);
                conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

                accountDAO.getBalanceForUpdate(conn, account.getId()); // lock row
                accountDAO.creditBalance(conn, account.getId(), amount);
                BigDecimal newBalance = account.getBalance().add(amount);
                txDAO.insert(conn, account.getId(), "DEPOSIT", amount, fee, newBalance,
                    "Internal deposit from " + sourceName);

                deposit.setStatus("SUCCESS");
                depositDAO.insert(deposit); // outside conn for simplicity (auto-commit reused)
                conn.commit();

                AuditLogUtil.log(userId, "DEPOSIT: ETB " + amount + " | Type: INTERNAL", request);

            } catch (Exception e) {
                if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
                throw new BankingException("Deposit failed: " + e.getMessage(), e);
            } finally {
                if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        } else {
            deposit.setStatus("PENDING");
            depositDAO.insert(deposit);
            AuditLogUtil.log(userId,
                depositType + " DEPOSIT requested: ETB " + amount + " | PENDING manager review", request);
        }

        return deposit;
    }

    /** Manager approves a deposit. */
    public void approveDeposit(int depositId, int managerId,
                                String notes, HttpServletRequest request) throws BankingException, SQLException {
        Deposit deposit = depositDAO.findById(depositId);
        if (deposit == null) throw new BankingException("Deposit record not found.");
        if (!"PENDING".equals(deposit.getStatus()))
            throw new BankingException("Deposit is not in PENDING state.");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            accountDAO.getBalanceForUpdate(conn, deposit.getAccountId());
            accountDAO.creditBalance(conn, deposit.getAccountId(), deposit.getAmount());

            Account acc = accountDAO.findById(deposit.getAccountId());
            BigDecimal newBalance = acc.getBalance().add(deposit.getAmount());
            txDAO.insert(conn, deposit.getAccountId(), "DEPOSIT", deposit.getAmount(),
                deposit.getFee(), newBalance, deposit.getDepositType() + " deposit approved by manager");

            depositDAO.updateStatus(depositId, "SUCCESS", managerId, notes);

            conn.commit();
            AuditLogUtil.log(managerId, "DEPOSIT APPROVED: ID=" + depositId
                + " | ETB " + deposit.getAmount(), request);

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw new BankingException("Approval failed: " + e.getMessage(), e);
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }

    /** Manager rejects a deposit. */
    public void rejectDeposit(int depositId, int managerId,
                               String notes, HttpServletRequest request) throws BankingException, SQLException {
        Deposit deposit = depositDAO.findById(depositId);
        if (deposit == null) throw new BankingException("Deposit not found.");
        if (!"PENDING".equals(deposit.getStatus()))
            throw new BankingException("Deposit is not in PENDING state.");

        depositDAO.updateStatus(depositId, "REJECTED", managerId, notes);
        AuditLogUtil.log(managerId, "DEPOSIT REJECTED: ID=" + depositId, request);
    }
}