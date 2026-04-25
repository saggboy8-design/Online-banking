package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private final AccountDAO     accountDAO  = new AccountDAO();
    private final LoanDAO        loanDAO     = new LoanDAO();
    private final ComplaintDAO   complaintDAO= new ComplaintDAO();
    private final DepositDAO     depositDAO  = new DepositDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("pendingKycCount",       accountDAO.getPendingKyc().size());
            req.setAttribute("pendingLoanCount",      loanDAO.countPending());
            req.setAttribute("openComplaintCount",    complaintDAO.countOpen());
            req.setAttribute("pendingDeposits",       depositDAO.getPending());
            req.getRequestDispatcher("/jsp/manager/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}