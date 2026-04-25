package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.TransactionDAO;
import com.gojjam.bank.model.Transaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manager/transactions")
public class ManagerTransactionHistoryServlet extends HttpServlet {

    private final TransactionDAO txDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Transaction> transactions = txDAO.getAll();
            req.setAttribute("transactions", transactions);
            req.getRequestDispatcher("/jsp/manager/transaction-history.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}