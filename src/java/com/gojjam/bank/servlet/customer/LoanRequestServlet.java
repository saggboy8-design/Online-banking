package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.LoanDAO;
import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.Loan;
import com.gojjam.bank.service.LoanService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.PDFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customer/loan")
public class LoanRequestServlet extends HttpServlet {

    private final LoanService loanService = new LoanService();
    private final LoanDAO     loanDAO     = new LoanDAO();
    private final AccountDAO  accountDAO  = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession(false).getAttribute("userId");
        try {
            Account account = accountDAO.findByUserId(userId);
            List<Loan> loans = (account != null) ? loanDAO.getByAccount(account.getId()) : List.of();

            // Download amortization for an approved loan
            String downloadId = req.getParameter("download");
            if (downloadId != null) {
                Loan loan = loanDAO.findById(Integer.parseInt(downloadId));
                if (loan != null && loan.getAccountId() == account.getId()) {
                    PDFUtil.generateLoanSchedule(resp, loan);
                    return;
                }
            }

            req.setAttribute("loans", loans);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/loan-request.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
            req.getRequestDispatcher("/jsp/customer/loan-request.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId       = (int) req.getSession().getAttribute("userId");
        String amountStr = req.getParameter("amount");
        String purpose   = ValidationUtil.sanitize(req.getParameter("purpose"));
        String durStr    = req.getParameter("duration");

        BigDecimal amount;
        int duration;
        try {
            amount   = new BigDecimal(amountStr);
            duration = Integer.parseInt(durStr);
        } catch (Exception e) {
            req.setAttribute("error", "Invalid amount or duration.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/loan-request.jsp").forward(req, resp);
            return;
        }

        try {
            loanService.submitLoanRequest(userId, amount, purpose, duration, req);
            req.setAttribute("success", "Loan request submitted successfully. Awaiting manager review.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/loan-request.jsp").forward(req, resp);

        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/loan-request.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/loan-request.jsp").forward(req, resp);
        }
    }
}