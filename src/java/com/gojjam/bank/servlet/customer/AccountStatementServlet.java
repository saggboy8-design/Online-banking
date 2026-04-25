package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.TransactionDAO;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.Transaction;
import com.gojjam.bank.util.PDFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/customer/statement")
public class AccountStatementServlet extends HttpServlet {

    private static final Logger  LOGGER     = Logger.getLogger(AccountStatementServlet.class.getName());
    private final AccountDAO     accountDAO = new AccountDAO();
    private final TransactionDAO txDAO      = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession(false).getAttribute("userId");

        String fromDate = req.getParameter("fromDate");
        String toDate   = req.getParameter("toDate");

        try {
            Account account = accountDAO.findByUserId(userId);
            if (account == null) {
                resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
                return;
            }

            List<Transaction> transactions;
            String from, to;

            if (fromDate != null && !fromDate.isBlank()
                    && toDate != null && !toDate.isBlank()) {
                transactions = txDAO.getByAccountAndDateRange(account.getId(), fromDate, toDate);
                from = fromDate;
                to   = toDate;
            } else {
                transactions = txDAO.getByAccount(account.getId());
                from = "All";
                to   = "All";
            }

            PDFUtil.generateAccountStatement(resp, account,
                    account.getOwnerFullName(), transactions, from, to);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Statement generation error", e);
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}