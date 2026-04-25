package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.SystemConfigDAO;
import com.gojjam.bank.dao.WithdrawalDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.Withdrawal;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.service.WithdrawalService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customer/withdraw")
public class WithdrawalServlet extends HttpServlet {

    private final WithdrawalService withdrawalService = new WithdrawalService();
    private final WithdrawalDAO     withdrawalDAO     = new WithdrawalDAO();
    private final AccountDAO        accountDAO        = new AccountDAO();
    private final SystemConfigDAO   configDAO         = new SystemConfigDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Require re-authentication for every withdrawal
        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath()
                    + "/reauth?redirectTo="
                    + req.getContextPath() + "/customer/withdraw");
            return;
        }
        loadPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Double-check reauth still valid
        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath()
                    + "/reauth?redirectTo="
                    + req.getContextPath() + "/customer/withdraw");
            return;
        }

        int userId       = (int) req.getSession().getAttribute("userId");
        String amountStr = req.getParameter("amount");
        String method    = ValidationUtil.sanitize(req.getParameter("withdrawalMethod"));
        String reason    = ValidationUtil.sanitize(req.getParameter("reason"));

        if (ValidationUtil.isBlank(amountStr) || ValidationUtil.isBlank(method)) {
            req.setAttribute("error", "Amount and withdrawal method are required.");
            loadPage(req, resp);
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Please enter a valid numeric amount.");
            loadPage(req, resp);
            return;
        }

        try {
            Withdrawal w = withdrawalService.withdraw(userId, amount, method, reason, req);
            req.setAttribute("success",
                    "✔ Withdrawal successful! "
                    + "ETB " + amount.toPlainString() + " has been withdrawn. "
                    + "Reference: " + w.getReferenceNumber());
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
        }

        loadPage(req, resp);
    }

    private void loadPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int userId   = (int) req.getSession().getAttribute("userId");
            Account acct = accountDAO.findByUserId(userId);

            List<Withdrawal> history = null;
            if (acct != null) {
                history = withdrawalDAO.getByAccount(acct.getId());
            }

            req.setAttribute("account",          acct);
            req.setAttribute("withdrawalHistory", history);
            req.setAttribute("withdrawalFee",
                    configDAO.getValue("withdrawal_fee"));
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/withdraw.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "System error loading page.");
            try {
                req.getRequestDispatcher("/jsp/customer/withdraw.jsp")
                   .forward(req, resp);
            } catch (Exception ignored) {}
        }
    }
}