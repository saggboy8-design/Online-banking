package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.SystemConfigDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Transfer;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.service.TransferService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.PDFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/customer/transfer")
public class TransferServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TransferServlet.class.getName());

    private final TransferService  transferService = new TransferService();
    private final SystemConfigDAO  configDAO       = new SystemConfigDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath()
                    + "/reauth?redirectTo="
                    + req.getContextPath() + "/customer/transfer");
            return;
        }
        loadConfig(req);
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/transfer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath()
                    + "/reauth?redirectTo="
                    + req.getContextPath() + "/customer/transfer");
            return;
        }

        int    userId       = (int) req.getSession().getAttribute("userId");
        String type         = ValidationUtil.sanitize(req.getParameter("transferType"));
        String receiver     = ValidationUtil.sanitize(req.getParameter("receiverAccount"));
        String amountStr    = req.getParameter("amount");   // comes from hidden field now
        String description  = ValidationUtil.sanitize(req.getParameter("description"));
        String beneficiary  = ValidationUtil.sanitize(req.getParameter("beneficiaryName"));
        String bankName     = ValidationUtil.sanitize(req.getParameter("bankName"));
        String swift        = ValidationUtil.sanitize(req.getParameter("swiftCode"));
        String country      = ValidationUtil.sanitize(req.getParameter("country"));
        String pdfFlag      = req.getParameter("downloadPdf");

        // ── Validate amount ──────────────────────────────────────────────────
        if (ValidationUtil.isBlank(amountStr)) {
            setError(req, resp, "Amount is required."); return;
        }
        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr.trim());
            if (amount.compareTo(BigDecimal.ZERO) <= 0)
                throw new NumberFormatException("non-positive");
        } catch (NumberFormatException e) {
            setError(req, resp, "Please enter a valid transfer amount greater than zero."); return;
        }

        // ── Validate transfer type ───────────────────────────────────────────
        if (ValidationUtil.isBlank(type) ||
            (!type.equals("INTERNAL") && !type.equals("EXTERNAL")
             && !type.equals("INTERNATIONAL"))) {
            setError(req, resp, "Invalid transfer type."); return;
        }

        // ── Validate receiver ────────────────────────────────────────────────
        if (ValidationUtil.isBlank(receiver)) {
            setError(req, resp, "Receiver account / IBAN is required."); return;
        }

        try {
            Transfer transfer;

            if ("INTERNAL".equals(type)) {
                // Basic account number format check
                if (!receiver.matches("^ACC[0-9]{10}$")) {
                    setError(req, resp,
                        "Invalid account number format. Must be ACC followed by 10 digits.");
                    return;
                }
                transfer = transferService.doInternalTransfer(
                        userId, receiver, amount, description, req);

                if ("true".equals(pdfFlag) && "SUCCESS".equals(transfer.getStatus())) {
                    String senderName = (String) req.getSession().getAttribute("fullName");
                    PDFUtil.generateTransferReceipt(resp, transfer, senderName);
                    return;
                }

                req.setAttribute("success",
                        "✔ Internal transfer completed successfully! "
                        + "ETB " + amount.toPlainString()
                        + " sent to " + receiver + " | Ref: #" + transfer.getId());

            } else {
                // EXTERNAL or INTERNATIONAL
                if (ValidationUtil.isBlank(beneficiary)) {
                    setError(req, resp, "Beneficiary name is required."); return;
                }
                if (ValidationUtil.isBlank(bankName)) {
                    setError(req, resp, "Bank name is required."); return;
                }
                if ("INTERNATIONAL".equals(type)) {
                    if (ValidationUtil.isBlank(swift)) {
                        setError(req, resp, "SWIFT/BIC code is required for international transfers."); return;
                    }
                    if (swift.length() != 8 && swift.length() != 11) {
                        setError(req, resp, "SWIFT/BIC code must be 8 or 11 characters."); return;
                    }
                    if (ValidationUtil.isBlank(country)) {
                        setError(req, resp, "Country is required for international transfers."); return;
                    }
                }

                transfer = transferService.submitExternalTransfer(
                        userId, receiver, type, amount, description,
                        beneficiary, bankName, swift, country, req);

                req.setAttribute("success",
                        "✔ " + type + " transfer request submitted successfully! "
                        + "Reference: #" + transfer.getId()
                        + " | ETB " + amount.toPlainString()
                        + " | Awaiting manager approval.");
            }

            loadConfig(req);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/transfer.jsp").forward(req, resp);

        } catch (BankingException e) {
            setError(req, resp, e.getUserMessage());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Transfer error", e);
            setError(req, resp, "System error. Please try again.");
        }
    }

    // ── helpers ───────────────────────────────────────────────────────────────
    private void setError(HttpServletRequest req, HttpServletResponse resp,
                          String msg) throws ServletException, IOException {
        req.setAttribute("error", msg);
        loadConfig(req);
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/transfer.jsp").forward(req, resp);
    }

    private void loadConfig(HttpServletRequest req) {
        try {
            req.setAttribute("internalFee", configDAO.getValue("internal_transfer_fee"));
            req.setAttribute("externalFee", configDAO.getValue("external_transfer_fee"));
            req.setAttribute("intlFee",     configDAO.getValue("international_transfer_fee"));
            req.setAttribute("maxLimit",    configDAO.getValue("max_transfer_limit"));
        } catch (Exception ignored) {}
    }
}