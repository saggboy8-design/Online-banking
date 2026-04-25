package com.gojjam.bank.servlet.admin;

import com.gojjam.bank.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AccountDAO     accountDAO  = new AccountDAO();
    private final UserDAO        userDAO     = new UserDAO();
    private final TransactionDAO txDAO       = new TransactionDAO();
    private final LoanDAO        loanDAO     = new LoanDAO();
    private final ComplaintDAO   complaintDAO= new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalAccounts",    accountDAO.countAll());
            req.setAttribute("totalBalance",     accountDAO.totalBalance());
            req.setAttribute("totalUsers",       userDAO.getAllCustomers().size());
            req.setAttribute("totalManagers",    userDAO.getAllManagers().size());
            req.setAttribute("totalTx",          txDAO.countAll());
            req.setAttribute("pendingLoans",     loanDAO.countPending());
            req.setAttribute("openComplaints",   complaintDAO.countOpen());
            req.setAttribute("pendingKyc",       accountDAO.getPendingKyc().size());
            req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}