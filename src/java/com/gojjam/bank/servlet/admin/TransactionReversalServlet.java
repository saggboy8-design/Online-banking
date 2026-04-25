package com.gojjam.bank.servlet.admin;

import com.gojjam.bank.dao.TransactionDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Transaction;
import com.gojjam.bank.service.AdminService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/reversal")
public class TransactionReversalServlet extends HttpServlet {

    private final AdminService   adminService = new AdminService();
    private final TransactionDAO txDAO        = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Transaction> txList = txDAO.getAll();
            req.setAttribute("transactions", txList);
            req.setAttribute("csrfToken",    CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/admin/transaction-reversal.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int adminId = (int) req.getSession().getAttribute("userId");
        int txId    = Integer.parseInt(req.getParameter("transactionId"));

        try {
            adminService.reverseTransaction(txId, adminId, req);
            req.setAttribute("success", "Transaction #" + txId + " reversed successfully.");
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}