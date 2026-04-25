package com.gojjam.bank.service;

import com.gojjam.bank.config.DBConnection;
import com.gojjam.bank.dao.*;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Loan;
import com.gojjam.bank.util.AuditLogUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.sql.*;

public class LoanService {

    private final LoanDAO         loanDAO    = new LoanDAO();
    private final AccountDAO      accountDAO = new AccountDAO();
    private final TransactionDAO  txDAO      = new TransactionDAO();
    private final SystemConfigDAO configDAO  = new SystemConfigDAO();

    public void submitLoanRequest(int userId, BigDecimal amount, String purpose,
                                   int durationMonths, HttpServletRequest request) throws BankingException, SQLException {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new BankingException("Loan amount must be greater than zero.");
        if (durationMonths < 1 || durationMonths > 120)
            throw new BankingException("Loan duration must be between 1 and 120 months.");
        if (purpose == null || purpose.isBlank())
            throw new BankingException("Loan purpose is required.");

        var account = accountDAO.findByUserId(userId);
        if (account == null) throw new BankingException("Account not found.");
        if (!"APPROVED".equals(account.getKycStatus()))
            throw new BankingException("KYC not approved.");

        BigDecimal interestRate = configDAO.getDecimalValue("loan_interest_rate", new BigDecimal("12.50"));

        Loan loan = new Loan();
        loan.setAccountId(account.getId());
        loan.setAmount(amount);
        loan.setPurpose(purpose);
        loan.setDurationMonths(durationMonths);
        loan.setInterestRate(interestRate);

        loanDAO.insert(loan);
        AuditLogUtil.log(userId, "LOAN REQUEST: ETB " + amount + " for " + durationMonths + " months", request);
    }

    public void approveLoan(int loanId, int managerId,
                             HttpServletRequest request) throws BankingException, SQLException {

        Loan loan = loanDAO.findById(loanId);
        if (loan == null)        throw new BankingException("Loan not found.");
        if (!"PENDING".equals(loan.getStatus()))
            throw new BankingException("Loan is not in PENDING state.");

        // Calculate EMI using compound interest formula
        BigDecimal annualRate  = loan.getInterestRate().divide(BigDecimal.valueOf(100), 10, RoundingMode.HALF_UP);
        BigDecimal monthlyRate = annualRate.divide(BigDecimal.valueOf(12), 10, RoundingMode.HALF_UP);
        int n = loan.getDurationMonths();
        // EMI = P * r(1+r)^n / ((1+r)^n - 1)
        BigDecimal onePlusR = BigDecimal.ONE.add(monthlyRate);
        BigDecimal power    = onePlusR.pow(n, new MathContext(15));
        BigDecimal emi      = loan.getAmount()
                                  .multiply(monthlyRate.multiply(power))
                                  .divide(power.subtract(BigDecimal.ONE), 2, RoundingMode.HALF_UP);
        BigDecimal totalPayable = emi.multiply(BigDecimal.valueOf(n)).setScale(2, RoundingMode.HALF_UP);

        loanDAO.approve(loanId, managerId, emi, totalPayable);

        // Disburse: credit customer account
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            accountDAO.getBalanceForUpdate(conn, loan.getAccountId());
            accountDAO.creditBalance(conn, loan.getAccountId(), loan.getAmount());

            var account = accountDAO.findById(loan.getAccountId());
            BigDecimal newBalance = account.getBalance().add(loan.getAmount());
            txDAO.insert(conn, loan.getAccountId(), "LOAN_CREDIT", loan.getAmount(),
                BigDecimal.ZERO, newBalance, "Loan approved & disbursed | Loan ID: " + loanId);

            loanDAO.markDisbursed(conn, loanId);
            conn.commit();

            AuditLogUtil.log(managerId, "LOAN APPROVED: ID=" + loanId
                + " | ETB " + loan.getAmount() + " | EMI: ETB " + emi, request);

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw new BankingException("Loan approval failed: " + e.getMessage(), e);
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }

    public void rejectLoan(int loanId, int managerId, String reason,
                            HttpServletRequest request) throws BankingException, SQLException {
        Loan loan = loanDAO.findById(loanId);
        if (loan == null) throw new BankingException("Loan not found.");
        if (!"PENDING".equals(loan.getStatus())) throw new BankingException("Loan is not PENDING.");

        loanDAO.reject(loanId, managerId, reason);
        AuditLogUtil.log(managerId, "LOAN REJECTED: ID=" + loanId + " | Reason: " + reason, request);
    }
}