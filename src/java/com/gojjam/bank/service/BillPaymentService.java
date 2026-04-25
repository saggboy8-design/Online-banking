package com.gojjam.bank.service;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.exception.InsufficientBalanceException;
import com.gojjam.bank.model.*;
import com.gojjam.bank.util.AuditLogUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.*;

public class BillPaymentService {

    private final AccountDAO      accountDAO  = new AccountDAO();
    private final TransactionDAO  txDAO       = new TransactionDAO();
    private final BillPaymentDAO  billDAO     = new BillPaymentDAO();
    private final SystemConfigDAO configDAO   = new SystemConfigDAO();

    public BillPayment pay(int userId, String billType, BigDecimal amount,
                           String referenceNumber, String providerName,
                           HttpServletRequest request) throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Amount must be greater than zero.");

        if (referenceNumber == null || referenceNumber.isBlank())
            throw new BankingException("Reference number is required.");

        Account account = accountDAO.findByUserId(userId);
        if (account == null) throw new BankingException("Account not found.");
        if (!"APPROVED".equals(account.getKycStatus()))
            throw new BankingException("KYC not approved.");

        // Duplicate check
        if (billDAO.isDuplicatePayment(account.getId(), billType, referenceNumber))
            throw new BankingException("Duplicate payment: this reference number has already been paid.");

        BigDecimal fee       = configDAO.getDecimalValue("bill_payment_fee", new BigDecimal("10"));
        BigDecimal totalDebit = amount.add(fee);

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            BigDecimal balance = accountDAO.getBalanceForUpdate(conn, account.getId());
            if (balance.compareTo(totalDebit) < 0) throw new InsufficientBalanceException();

            accountDAO.debitBalance(conn, account.getId(), totalDebit);
            BigDecimal balanceAfter = balance.subtract(totalDebit);

            BillPayment bill = new BillPayment();
            bill.setAccountId(account.getId());
            bill.setBillType(billType);
            bill.setAmount(amount);
            bill.setFee(fee);
            bill.setReferenceNumber(referenceNumber);
            bill.setProviderName(providerName);

            int billId = billDAO.insert(conn, bill);
            bill.setId(billId);
            bill.setAccountNumber(account.getAccountNumber());
            bill.setOwnerName(account.getOwnerFullName());
            bill.setCreatedAt(java.time.LocalDateTime.now());

            txDAO.insert(conn, account.getId(), "BILL_PAYMENT", amount, fee, balanceAfter,
                "Bill: " + billType + " | Ref: " + referenceNumber + " | Provider: " + providerName);

            conn.commit();

            AuditLogUtil.log(userId, "BILL PAYMENT: " + billType + " ETB " + amount
                + " | Ref: " + referenceNumber, request,
                "Balance: " + balance, "Balance: " + balanceAfter);

            return bill;

        } catch (BankingException | SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }
}