package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.WithdrawalDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Withdrawal;
import com.gojjam.bank.service.WithdrawalService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manager/withdrawals")
public class WithdrawalApprovalServlet extends HttpServlet {

    private final WithdrawalDAO     withdrawalDAO     = new WithdrawalDAO();
    private final WithdrawalService withdrawalService = new WithdrawalService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Withdrawal> pending = withdrawalDAO.getPending();
            req.setAttribute("withdrawals", pending);
            req.setAttribute("csrfToken",  CSRFUtil.getToken(req));
            req.getRequestDispatcher(
                    "/jsp/manager/withdrawal-approval.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId  = (int) req.getSession().getAttribute("userId");
        String action  = req.getParameter("action");
        String widStr  = req.getParameter("withdrawalId");
        String note    = ValidationUtil.sanitize(req.getParameter("managerNote"));

        if (widStr == null || widStr.isBlank()) {
            req.setAttribute("error", "Withdrawal ID is required.");
            doGet(req, resp);
            return;
        }

        int withdrawalId;
        try {
            withdrawalId = Integer.parseInt(widStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid withdrawal ID.");
            doGet(req, resp);
            return;
        }

        try {
            if ("APPROVE".equals(action)) {
                withdrawalService.approve(withdrawalId, managerId, note, req);
                req.setAttribute("success",
                        "✔ Withdrawal #" + withdrawalId
                        + " approved. Funds have been deducted from the customer's account.");
            } else if ("REJECT".equals(action)) {
                if (note == null || note.isBlank())
                    note = "Rejected by manager.";
                withdrawalService.reject(withdrawalId, managerId, note, req);
                req.setAttribute("success",
                        "✖ Withdrawal #" + withdrawalId
                        + " rejected. No funds were deducted.");
            } else {
                req.setAttribute("error", "Unknown action.");
            }
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
        }

        doGet(req, resp);
    }
}