package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.ManagerService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/manager/update-balance")
public class UpdateCustomerBalanceServlet extends HttpServlet {

    private final ManagerService managerService = new ManagerService();
    private final AccountDAO     accountDAO     = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("accounts",  accountDAO.getAll());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/manager/update-balance.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId   = (int) req.getSession().getAttribute("userId");
        int accountId   = Integer.parseInt(req.getParameter("accountId"));
        String newBalStr= req.getParameter("newBalance");

        try {
            BigDecimal newBalance = new BigDecimal(newBalStr);
            managerService.updateCustomerBalance(accountId, newBalance, managerId, req);
            req.setAttribute("success", "Balance updated to ETB " + newBalance.toPlainString());
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (Exception e) {
            req.setAttribute("error", "Invalid input or system error.");
        }
        doGet(req, resp);
    }
}