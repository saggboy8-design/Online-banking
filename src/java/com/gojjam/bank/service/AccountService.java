package com.gojjam.bank.service;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.TransactionDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.Transaction;
import java.sql.SQLException;
import java.util.List;

public class AccountService {

    private final AccountDAO     accountDAO     = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    /** Get account by user ID. */
    public Account getAccountByUserId(int userId) throws BankingException, SQLException {
        Account account = accountDAO.findByUserId(userId);
        if (account == null) throw new BankingException("Account not found for user ID: " + userId);
        return account;
    }

    /** Get account by account number. */
    public Account getAccountByNumber(String accountNumber) throws BankingException, SQLException {
        Account account = accountDAO.findByAccountNumber(accountNumber);
        if (account == null) throw new BankingException("Account not found: " + accountNumber);
        return account;
    }

    /** Get account by account ID. */
    public Account getAccountById(int accountId) throws BankingException, SQLException {
        Account account = accountDAO.findById(accountId);
        if (account == null) throw new BankingException("Account not found: " + accountId);
        return account;
    }

    /** Get last 5 transactions for customer dashboard. */
    public List<Transaction> getRecentTransactions(int accountId) throws SQLException {
        return transactionDAO.getLastN(accountId, 5);
    }

    /** Get all transactions for account (manager/admin view). */
    public List<Transaction> getAllTransactions(int accountId) throws SQLException {
        return transactionDAO.getByAccount(accountId);
    }

    /** Get transactions within a date range. */
    public List<Transaction> getTransactionsByDateRange(int accountId,
                                                         String fromDate,
                                                         String toDate) throws SQLException {
        return transactionDAO.getByAccountAndDateRange(accountId, fromDate, toDate);
    }

    /** Get all accounts (admin). */
    public List<Account> getAllAccounts() throws SQLException {
        return accountDAO.getAll();
    }

    /** Get pending KYC accounts (manager). */
    public List<Account> getPendingKycAccounts() throws SQLException {
        return accountDAO.getPendingKyc();
    }

    /** System-wide total balance (admin dashboard). */
    public java.math.BigDecimal getTotalSystemBalance() throws SQLException {
        return accountDAO.totalBalance();
    }

    /** Count all accounts (admin dashboard). */
    public int countAllAccounts() throws SQLException {
        return accountDAO.countAll();
    }
}