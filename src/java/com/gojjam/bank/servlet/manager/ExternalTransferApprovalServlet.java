package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.TransferDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Transfer;
import com.gojjam.bank.service.TransferService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manager/external-transfers")
public class ExternalTransferApprovalServlet extends HttpServlet {

    private final TransferDAO     transferDAO     = new TransferDAO();
    private final TransferService transferService = new TransferService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Transfer> pending = transferDAO.getPendingExternal();
            req.setAttribute("transfers",  pending);
            req.setAttribute("csrfToken",  CSRFUtil.getToken(req));
            req.getRequestDispatcher(
                    "/jsp/manager/external-transfer-approval.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId = (int) req.getSession().getAttribute("userId");
        String action = req.getParameter("action");
        String tidStr = req.getParameter("transferId");

        if (tidStr == null || tidStr.isBlank()) {
            req.setAttribute("error", "Transfer ID is required.");
            doGet(req, resp);
            return;
        }

        int transferId;
        try {
            transferId = Integer.parseInt(tidStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid transfer ID.");
            doGet(req, resp);
            return;
        }

        try {
            if ("APPROVE".equals(action)) {
                transferService.approveExternalTransfer(transferId, managerId, req);
                req.setAttribute("success",
                        "✔ Transfer #" + transferId
                        + " approved successfully. Funds have been deducted from the sender's account.");
            } else if ("REJECT".equals(action)) {
                String reason = ValidationUtil.sanitize(req.getParameter("rejectionReason"));
                if (reason == null || reason.isBlank())
                    reason = "Rejected by manager (no reason provided).";
                transferService.rejectExternalTransfer(transferId, managerId, reason, req);
                req.setAttribute("success",
                        "✖ Transfer #" + transferId
                        + " rejected. No funds have been deducted from the sender's account.");
            } else {
                req.setAttribute("error", "Unknown action: " + action);
            }
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
        }

        doGet(req, resp);
    }
}