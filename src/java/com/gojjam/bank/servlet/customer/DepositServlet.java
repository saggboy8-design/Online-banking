package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.DepositService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/customer/deposit")
public class DepositServlet extends HttpServlet {

    private final DepositService depositService = new DepositService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/deposit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId        = (int) req.getSession().getAttribute("userId");
        String type       = ValidationUtil.sanitize(req.getParameter("depositType"));
        String amountStr  = req.getParameter("amount");
        String source     = ValidationUtil.sanitize(req.getParameter("sourceName"));
        String srcAcct    = ValidationUtil.sanitize(req.getParameter("sourceAccount"));
        String beneficiary= ValidationUtil.sanitize(req.getParameter("beneficiaryName"));
        String bankName   = ValidationUtil.sanitize(req.getParameter("bankName"));
        String swift      = ValidationUtil.sanitize(req.getParameter("swiftCode"));
        String country    = ValidationUtil.sanitize(req.getParameter("country"));
        String iban       = ValidationUtil.sanitize(req.getParameter("iban"));

        if (ValidationUtil.isBlank(type) || ValidationUtil.isBlank(amountStr)) {
            setError(req, resp, "All required fields must be filled."); return;
        }

        BigDecimal amount;
        try { amount = new BigDecimal(amountStr); }
        catch (Exception e) { setError(req, resp, "Invalid amount."); return; }

        try {
            depositService.submitDeposit(userId, type, amount, source, srcAcct,
                beneficiary, bankName, swift, country, iban, req);

            req.setAttribute("success", "INTERNAL".equals(type)
                ? "Deposit completed successfully!"
                : "Deposit request submitted. Awaiting manager approval.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/deposit.jsp").forward(req, resp);

        } catch (BankingException e) {
            setError(req, resp, e.getUserMessage());
        } catch (SQLException e) {
            setError(req, resp, "System error. Please try again.");
        }
    }

    private void setError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/deposit.jsp").forward(req, resp);
    }
}