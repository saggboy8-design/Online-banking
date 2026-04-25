package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.TransactionDAO;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.Transaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CustomerDashboardServlet.class.getName());
    private final AccountDAO     accountDAO     = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession(false).getAttribute("userId");

        try {
            Account account = accountDAO.findByUserId(userId);
            List<Transaction> recent = (account != null)
                ? transactionDAO.getLastN(account.getId(), 5)
                : List.of();

            req.setAttribute("account", account);
            req.setAttribute("transactions", recent);
            req.getRequestDispatcher("/jsp/customer/dashboard.jsp").forward(req, resp);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Dashboard load error", e);
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}