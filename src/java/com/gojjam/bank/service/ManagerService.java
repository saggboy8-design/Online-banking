package com.gojjam.bank.service;

import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.*;
import com.gojjam.bank.util.AuditLogUtil;
import com.gojjam.bank.util.EmailUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.SQLException;

public class ManagerService {

    private final AccountDAO  accountDAO = new AccountDAO();
    private final UserDAO     userDAO    = new UserDAO();

    /** Approve KYC for a customer account. */
    public void approveKyc(int accountId, int managerId,
                            HttpServletRequest request) throws BankingException, SQLException {
        Account account = accountDAO.findById(accountId);
        if (account == null) throw new BankingException("Account not found.");
        if (!"PENDING".equals(account.getKycStatus()))
            throw new BankingException("Account KYC is not in PENDING state.");

        accountDAO.updateKycStatus(accountId, "APPROVED", managerId);
        userDAO.updateStatus(account.getUserId(), "ACTIVE");

        AuditLogUtil.log(managerId, "KYC APPROVED: Account ID=" + accountId
            + " | Owner: " + account.getOwnerFullName(), request,
            "KYC: PENDING", "KYC: APPROVED");

        // Send approval email
        Thread t = new Thread(() ->
            EmailUtil.sendApprovalEmail(account.getOwnerEmail(),
                account.getOwnerFullName(), account.getAccountNumber()));
        t.setDaemon(true);
        t.start();
    }

    /** Reject KYC for a customer account. */
    public void rejectKyc(int accountId, int managerId,
                           HttpServletRequest request) throws BankingException, SQLException {
        Account account = accountDAO.findById(accountId);
        if (account == null) throw new BankingException("Account not found.");

        accountDAO.updateKycStatus(accountId, "REJECTED", managerId);
        userDAO.updateStatus(account.getUserId(), "REJECTED");

        AuditLogUtil.log(managerId, "KYC REJECTED: Account ID=" + accountId, request,
            "KYC: PENDING", "KYC: REJECTED");

        Thread t = new Thread(() ->
            EmailUtil.sendRejectionEmail(account.getOwnerEmail(), account.getOwnerFullName()));
        t.setDaemon(true);
        t.start();
    }

    /** Manager manually sets (updates) customer account balance. */
    public void updateCustomerBalance(int accountId, BigDecimal newBalance,
                                       int managerId, HttpServletRequest request) throws BankingException, SQLException {
        if (newBalance == null || newBalance.compareTo(BigDecimal.ZERO) < 0)
            throw new BankingException("Balance cannot be negative.");

        Account account = accountDAO.findById(accountId);
        if (account == null) throw new BankingException("Account not found.");

        String oldBalance = account.getBalance().toPlainString();
        accountDAO.setBalance(accountId, newBalance);

        AuditLogUtil.log(managerId,
            "MANUAL BALANCE UPDATE: Account ID=" + accountId
            + " | Owner: " + account.getOwnerFullName(), request,
            "Balance: " + oldBalance, "Balance: " + newBalance.toPlainString());
    }

    /** Manager unlocks a locked customer account. */
    public void unlockAccount(int userId, int managerId,
                               HttpServletRequest request) throws BankingException, SQLException {
        User user = userDAO.findById(userId);
        if (user == null) throw new BankingException("User not found.");
        if (!"LOCKED".equals(user.getStatus())) throw new BankingException("Account is not locked.");
        userDAO.updateStatus(userId, "ACTIVE");
        AuditLogUtil.log(managerId, "ACCOUNT UNLOCKED by Manager: User ID=" + userId, request,
            "Status: LOCKED", "Status: ACTIVE");
    }

    /** Manager updates customer personal data. */
    public void updateCustomerData(User updatedUser, int managerId,
                                    HttpServletRequest request) throws BankingException, SQLException {
        userDAO.updateProfile(updatedUser);
        AuditLogUtil.log(managerId, "CUSTOMER DATA UPDATED: User ID=" + updatedUser.getId(), request);
    }
}