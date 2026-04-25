package com.gojjam.bank.service;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.*;
import com.gojjam.bank.util.AuditLogUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ScheduledPaymentService {

    private static final Logger LOGGER = Logger.getLogger(ScheduledPaymentService.class.getName());

    private final ScheduledPaymentDAO spDAO     = new ScheduledPaymentDAO();
    private final AccountDAO          accountDAO = new AccountDAO();
    private final TransactionDAO      txDAO      = new TransactionDAO();
    private final SystemConfigDAO     configDAO  = new SystemConfigDAO();

    public void schedule(int userId, String paymentType, BigDecimal amount,
                          String recipient, String referenceNumber,
                          String frequency, String scheduledDateStr,
                          HttpServletRequest request) throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Amount must be greater than zero.");

        LocalDateTime scheduledDate = LocalDateTime.parse(scheduledDateStr);
        if (!scheduledDate.isAfter(LocalDateTime.now()))
            throw new BankingException("Scheduled date must be in the future.");

        Account account = accountDAO.findByUserId(userId);
        if (account == null) throw new BankingException("Account not found.");
        if (!"APPROVED".equals(account.getKycStatus()))
            throw new BankingException("KYC not approved.");

        BigDecimal fee = configDAO.getDecimalValue("bill_payment_fee", new BigDecimal("10"));

        ScheduledPayment sp = new ScheduledPayment();
        sp.setAccountId(account.getId());
        sp.setPaymentType(paymentType);
        sp.setAmount(amount);
        sp.setFee(fee);
        sp.setRecipient(recipient);
        sp.setReferenceNumber(referenceNumber);
        sp.setFrequency(frequency);
        sp.setScheduledDate(scheduledDate);

        spDAO.insert(sp);
        AuditLogUtil.log(userId, "SCHEDULED PAYMENT: " + paymentType + " ETB " + amount
            + " | Frequency: " + frequency + " | Date: " + scheduledDateStr, request);
    }

    /** Called by the background timer to process due payments. */
    public void processDue() {
        try {
            List<ScheduledPayment> dueList = spDAO.getDue();
            for (ScheduledPayment sp : dueList) {
                processSingle(sp);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing scheduled payments", e);
        }
    }

    private void processSingle(ScheduledPayment sp) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            BigDecimal balance    = accountDAO.getBalanceForUpdate(conn, sp.getAccountId());
            BigDecimal totalDebit = sp.getAmount().add(sp.getFee());

            if (balance.compareTo(totalDebit) < 0) {
                conn.rollback();
                spDAO.updateAfterExecution(sp.getId(), "FAILED", null);
                LOGGER.warning("Scheduled payment FAILED (insufficient balance): ID=" + sp.getId());
                return;
            }

            accountDAO.debitBalance(conn, sp.getAccountId(), totalDebit);
            BigDecimal balanceAfter = balance.subtract(totalDebit);
            txDAO.insert(conn, sp.getAccountId(), "SCHEDULED", sp.getAmount(), sp.getFee(),
                balanceAfter, "Scheduled " + sp.getPaymentType() + " to " + sp.getRecipient());

            conn.commit();

            // Determine next execution
            Timestamp nextExec = null;
            if ("WEEKLY".equals(sp.getFrequency())) {
                nextExec = Timestamp.valueOf(sp.getNextExecution().plusWeeks(1));
                spDAO.updateAfterExecution(sp.getId(), "PENDING", nextExec);
            } else if ("MONTHLY".equals(sp.getFrequency())) {
                nextExec = Timestamp.valueOf(sp.getNextExecution().plusMonths(1));
                spDAO.updateAfterExecution(sp.getId(), "PENDING", nextExec);
            } else {
                // ONE_TIME
                spDAO.updateAfterExecution(sp.getId(), "SUCCESS", null);
            }

            LOGGER.info("Scheduled payment SUCCESS: ID=" + sp.getId());

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            try { spDAO.updateAfterExecution(sp.getId(), "FAILED", null); } catch (SQLException ignored) {}
            LOGGER.log(Level.WARNING, "Scheduled payment error ID=" + sp.getId(), e);
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }
}