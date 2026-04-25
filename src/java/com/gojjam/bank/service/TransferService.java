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
import java.time.LocalDateTime;

public class TransferService {

    private final AccountDAO      accountDAO  = new AccountDAO();
    private final TransactionDAO  txDAO       = new TransactionDAO();
    private final TransferDAO     transferDAO = new TransferDAO();
    private final SystemConfigDAO configDAO   = new SystemConfigDAO();

    // ─────────────────────────────────────────────────────────────────────────
    // INTERNAL TRANSFER  →  immediate, atomic, ACID
    // ─────────────────────────────────────────────────────────────────────────
    public Transfer doInternalTransfer(int senderUserId,
                                       String receiverAccountNumber,
                                       BigDecimal amount,
                                       String description,
                                       HttpServletRequest request)
            throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Transfer amount must be greater than zero.");

        BigDecimal fee      = configDAO.getDecimalValue("internal_transfer_fee",
                                                        new BigDecimal("25"));
        BigDecimal maxLimit = configDAO.getDecimalValue("max_transfer_limit",
                                                        new BigDecimal("500000"));
        if (amount.compareTo(maxLimit) > 0)
            throw new BankingException("Amount exceeds maximum transfer limit of ETB "
                    + maxLimit.toPlainString());

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            // Validate sender
            Account sender = accountDAO.findByUserId(senderUserId);
            if (sender == null)
                throw new BankingException("Sender account not found.");
            if (!"APPROVED".equals(sender.getKycStatus()))
                throw new BankingException("Your KYC is not approved. Please contact the bank.");
            if (sender.getAccountNumber().equals(receiverAccountNumber))
                throw new BankingException("You cannot transfer to your own account.");

            // Lock sender row and verify balance
            BigDecimal senderBalance = accountDAO.getBalanceForUpdate(conn, sender.getId());
            BigDecimal totalDebit    = amount.add(fee);
            if (senderBalance.compareTo(totalDebit) < 0)
                throw new InsufficientBalanceException();

            // Validate receiver
            Account receiver = accountDAO.findByAccountNumber(receiverAccountNumber);
            if (receiver == null)
                throw new BankingException("Receiver account not found. Please check the account number.");
            if (!"APPROVED".equals(receiver.getKycStatus()))
                throw new BankingException("Receiver account is not active.");

            // Debit sender
            accountDAO.debitBalance(conn, sender.getId(), totalDebit);
            BigDecimal senderAfter = senderBalance.subtract(totalDebit);

            // Credit receiver
            accountDAO.creditBalance(conn, receiver.getId(), amount);
            BigDecimal receiverAfter = receiver.getBalance().add(amount);

            // Record transactions
            String desc = "Internal transfer to " + receiverAccountNumber
                    + (description != null && !description.isBlank() ? ": " + description : "");
            txDAO.insert(conn, sender.getId(),   "TRANSFER_OUT", amount, fee,
                    senderAfter,   desc);
            txDAO.insert(conn, receiver.getId(), "TRANSFER_IN",  amount,
                    BigDecimal.ZERO, receiverAfter,
                    "Internal transfer from " + sender.getAccountNumber());

            // Save transfer record
            Transfer transfer = new Transfer();
            transfer.setSenderAccountId(sender.getId());
            transfer.setReceiverAccount(receiverAccountNumber);
            transfer.setTransferType("INTERNAL");
            transfer.setAmount(amount);
            transfer.setFee(fee);
            transfer.setDescription(description);
            transfer.setStatus("SUCCESS");
            transfer.setSenderAccountNumber(sender.getAccountNumber());
            transfer.setSenderName(sender.getOwnerFullName());
            transfer.setCreatedAt(LocalDateTime.now());
            int transferId = transferDAO.insert(conn, transfer);
            transfer.setId(transferId);

            conn.commit();

            AuditLogUtil.log(senderUserId,
                    "INTERNAL TRANSFER: ETB " + amount
                            + " → " + receiverAccountNumber
                            + " | Fee: ETB " + fee,
                    request,
                    "Balance: " + senderBalance,
                    "Balance: " + senderAfter);

            return transfer;

        } catch (BankingException | SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (conn != null)
                try { conn.setAutoCommit(true); conn.close(); }
                catch (SQLException ignored) {}
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EXTERNAL / INTERNATIONAL TRANSFER
    // → Saved as PENDING with NO balance deduction.
    // → Manager must approve → then balance is deducted.
    // → Manager rejects    → balance untouched.
    // ─────────────────────────────────────────────────────────────────────────
    public Transfer submitExternalTransfer(int senderUserId,
                                           String receiverAccount,
                                           String type,
                                           BigDecimal amount,
                                           String description,
                                           String beneficiaryName,
                                           String bankName,
                                           String swiftCode,
                                           String country,
                                           HttpServletRequest request)
            throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Amount must be greater than zero.");

        String feeKey = "EXTERNAL".equals(type)
                ? "external_transfer_fee"
                : "international_transfer_fee";
        BigDecimal fee      = configDAO.getDecimalValue(feeKey, new BigDecimal("75"));
        BigDecimal maxLimit = configDAO.getDecimalValue("max_transfer_limit",
                                                        new BigDecimal("500000"));

        if (amount.compareTo(maxLimit) > 0)
            throw new BankingException("Amount exceeds maximum transfer limit of ETB "
                    + maxLimit.toPlainString());

        // Verify account exists and KYC is approved
        Account sender = accountDAO.findByUserId(senderUserId);
        if (sender == null)
            throw new BankingException("Account not found.");
        if (!"APPROVED".equals(sender.getKycStatus()))
            throw new BankingException("Your KYC is not approved. Please contact the bank.");

        // Pre-validate balance so customer knows upfront (no deduction yet)
        BigDecimal totalDebit = amount.add(fee);
        if (sender.getBalance().compareTo(totalDebit) < 0)
            throw new BankingException(
                    "Insufficient balance. Required: ETB " + totalDebit.toPlainString()
                    + " (amount + ETB " + fee.toPlainString() + " fee). "
                    + "Current balance: ETB " + sender.getBalance().toPlainString());

        // Save transfer request as PENDING — no deduction
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            Transfer transfer = new Transfer();
            transfer.setSenderAccountId(sender.getId());
            transfer.setReceiverAccount(receiverAccount);
            transfer.setTransferType(type);
            transfer.setAmount(amount);
            transfer.setFee(fee);
            transfer.setDescription(description);
            transfer.setBeneficiaryName(beneficiaryName);
            transfer.setBankName(bankName);
            transfer.setSwiftCode(swiftCode);
            transfer.setCountry(country);
            transfer.setStatus("PENDING");
            transfer.setSenderAccountNumber(sender.getAccountNumber());
            transfer.setSenderName(sender.getOwnerFullName());
            transfer.setCreatedAt(LocalDateTime.now());

            int transferId = transferDAO.insert(conn, transfer);
            transfer.setId(transferId);

            conn.commit();

            AuditLogUtil.log(senderUserId,
                    type + " TRANSFER REQUEST: ETB " + amount
                            + " → " + receiverAccount
                            + " | PENDING manager approval | ID: " + transferId,
                    request);

            return transfer;

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (conn != null)
                try { conn.setAutoCommit(true); conn.close(); }
                catch (SQLException ignored) {}
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MANAGER: APPROVE external/international transfer
    // → Deduct balance atomically with FOR UPDATE lock
    // ─────────────────────────────────────────────────────────────────────────
    public void approveExternalTransfer(int transferId,
                                        int managerId,
                                        HttpServletRequest request)
            throws BankingException, SQLException {

        Transfer transfer = transferDAO.findById(transferId);
        if (transfer == null)
            throw new BankingException("Transfer not found.");
        if (!"PENDING".equals(transfer.getStatus()))
            throw new BankingException("Transfer is not in PENDING state.");

        BigDecimal totalDebit = transfer.getAmount().add(transfer.getFee());

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            // Lock sender account row
            BigDecimal balance = accountDAO.getBalanceForUpdate(conn,
                    transfer.getSenderAccountId());

            // Re-validate balance at approval time
            if (balance.compareTo(totalDebit) < 0) {
                // Mark as failed — customer no longer has sufficient funds
                transferDAO.updateStatus(transferId, "FAILED", managerId);
                conn.commit();
                throw new BankingException(
                        "Transfer rejected: sender has insufficient balance at time of approval. "
                        + "Available: ETB " + balance.toPlainString()
                        + " | Required: ETB " + totalDebit.toPlainString());
            }

            // Deduct sender balance
            accountDAO.debitBalance(conn, transfer.getSenderAccountId(), totalDebit);
            BigDecimal balanceAfter = balance.subtract(totalDebit);

            // Record debit transaction
            String desc = transfer.getTransferType() + " transfer approved → "
                    + transfer.getReceiverAccount()
                    + (transfer.getBeneficiaryName() != null
                        ? " (" + transfer.getBeneficiaryName() + ")" : "")
                    + " | Approved by manager #" + managerId;

            txDAO.insert(conn, transfer.getSenderAccountId(),
                    "TRANSFER_OUT",
                    transfer.getAmount(),
                    transfer.getFee(),
                    balanceAfter,
                    desc);

            // Mark transfer SUCCESS with manager
            transferDAO.updateStatus(transferId, "SUCCESS", managerId);

            conn.commit();

            AuditLogUtil.log(managerId,
                    "APPROVED " + transfer.getTransferType()
                            + " TRANSFER #" + transferId
                            + " | ETB " + transfer.getAmount()
                            + " from account #" + transfer.getSenderAccountId(),
                    request,
                    "Status: PENDING | Balance: " + balance,
                    "Status: SUCCESS | Balance: " + balanceAfter);

        } catch (BankingException | SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (conn != null)
                try { conn.setAutoCommit(true); conn.close(); }
                catch (SQLException ignored) {}
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MANAGER: REJECT external/international transfer
    // → No balance change. Just mark REJECTED.
    // ─────────────────────────────────────────────────────────────────────────
    public void rejectExternalTransfer(int transferId,
                                       int managerId,
                                       String rejectionReason,
                                       HttpServletRequest request)
            throws BankingException, SQLException {

        Transfer transfer = transferDAO.findById(transferId);
        if (transfer == null)
            throw new BankingException("Transfer not found.");
        if (!"PENDING".equals(transfer.getStatus()))
            throw new BankingException("Transfer is not in PENDING state.");

        transferDAO.updateStatus(transferId, "REJECTED", managerId);

        AuditLogUtil.log(managerId,
                "REJECTED " + transfer.getTransferType()
                        + " TRANSFER #" + transferId
                        + " | Reason: " + rejectionReason,
                request,
                "Status: PENDING",
                "Status: REJECTED");
    }
}