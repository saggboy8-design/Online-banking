package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.LoanDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Loan;
import com.gojjam.bank.service.LoanService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manager/loans")
public class LoanApprovalServlet extends HttpServlet {

    private final LoanService loanService = new LoanService();
    private final LoanDAO     loanDAO     = new LoanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Loan> pending = loanDAO.getPending();
            req.setAttribute("loans", pending);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/manager/loan-approval.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId = (int) req.getSession().getAttribute("userId");
        int loanId    = Integer.parseInt(req.getParameter("loanId"));
        String action = req.getParameter("action");
        String reason = req.getParameter("rejectionReason");

        try {
            if ("APPROVE".equals(action)) {
                loanService.approveLoan(loanId, managerId, req);
                req.setAttribute("success", "Loan approved and amount disbursed to customer account.");
            } else {
                loanService.rejectLoan(loanId, managerId, reason, req);
                req.setAttribute("success", "Loan rejected.");
            }
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}