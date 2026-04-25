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

@WebServlet("/customer/transactions")
public class TransactionHistoryServlet extends HttpServlet {

    private final AccountDAO     accountDAO = new AccountDAO();
    private final TransactionDAO txDAO      = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession(false).getAttribute("userId");

        try {
            Account account = accountDAO.findByUserId(userId);
            if (account == null) {
                req.setAttribute("error", "Account not found.");
                req.getRequestDispatcher("/jsp/customer/transaction-history.jsp").forward(req, resp);
                return;
            }

            String fromDate = req.getParameter("fromDate");
            String toDate   = req.getParameter("toDate");
            String pdf      = req.getParameter("pdf");

            List<Transaction> transactions;
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                transactions = txDAO.getByAccountAndDateRange(account.getId(), fromDate, toDate);
            } else {
                transactions = txDAO.getLastN(account.getId(), 5);
            }

            if ("true".equals(pdf)) {
                String from = (fromDate != null && !fromDate.isEmpty()) ? fromDate : "All";
                String to   = (toDate   != null && !toDate.isEmpty()  ) ? toDate   : "All";
                PDFUtil.generateAccountStatement(resp, account,
                    account.getOwnerFullName(), transactions, from, to);
                return;
            }

            req.setAttribute("account",      account);
            req.setAttribute("transactions", transactions);
            req.setAttribute("fromDate",     fromDate);
            req.setAttribute("toDate",       toDate);
            req.getRequestDispatcher("/jsp/customer/transaction-history.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Could not load transactions.");
            req.getRequestDispatcher("/jsp/customer/transaction-history.jsp").forward(req, resp);
        }
    }
}