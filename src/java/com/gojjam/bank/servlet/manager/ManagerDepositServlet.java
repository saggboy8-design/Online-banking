package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.service.DepositService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manager/deposit")
public class ManagerDepositServlet extends HttpServlet {

    private final DepositService depositService = new DepositService();
    private final AccountDAO     accountDAO     = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("accounts", accountDAO.getAll());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/manager/deposit.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId    = (int) req.getSession().getAttribute("userId");
        String accountNum= ValidationUtil.sanitize(req.getParameter("accountNumber"));
        String amountStr = req.getParameter("amount");
        String notes     = ValidationUtil.sanitize(req.getParameter("notes"));

        try {
            Account acc = accountDAO.findByAccountNumber(accountNum);
            if (acc == null) throw new BankingException("Account not found: " + accountNum);

            BigDecimal amount = new BigDecimal(amountStr);
            // Manager does an internal deposit on behalf of customer
            depositService.submitDeposit(acc.getUserId(), "INTERNAL", amount,
                "Manager Deposit", null, null, null, null, null, null, req);

            req.setAttribute("success", "Deposit of ETB " + amount + " to " + accountNum + " successful.");
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (Exception e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}