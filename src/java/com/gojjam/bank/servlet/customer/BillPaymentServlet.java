package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.BillPaymentDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.BillPayment;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.service.BillPaymentService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.PDFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/customer/bill-payment")
public class BillPaymentServlet extends HttpServlet {

    private final BillPaymentService billService  = new BillPaymentService();
    private final BillPaymentDAO     billDAO      = new BillPaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath() + "/reauth?redirectTo="
                + req.getContextPath() + "/customer/bill-payment");
            return;
        }
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/bill-payment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath() + "/reauth?redirectTo="
                + req.getContextPath() + "/customer/bill-payment");
            return;
        }

        int userId       = (int) req.getSession().getAttribute("userId");
        String billType  = ValidationUtil.sanitize(req.getParameter("billType"));
        String amountStr = req.getParameter("amount");
        String refNum    = ValidationUtil.sanitize(req.getParameter("referenceNumber"));
        String provider  = ValidationUtil.sanitize(req.getParameter("providerName"));

        if (ValidationUtil.isBlank(billType) || ValidationUtil.isBlank(amountStr)
            || ValidationUtil.isBlank(refNum) || ValidationUtil.isBlank(provider)) {
            setError(req, resp, "All fields are required."); return;
        }

        BigDecimal amount;
        try { amount = new BigDecimal(amountStr); }
        catch (Exception e) { setError(req, resp, "Invalid amount."); return; }

        try {
            BillPayment bill = billService.pay(userId, billType, amount, refNum, provider, req);

            if ("true".equals(req.getParameter("downloadPdf"))) {
                PDFUtil.generateBillReceipt(resp, bill, bill.getOwnerName(), bill.getAccountNumber());
                return;
            }

            req.setAttribute("success", "Bill paid successfully! Reference: " + refNum);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/bill-payment.jsp").forward(req, resp);

        } catch (BankingException e) {
            setError(req, resp, e.getUserMessage());
        } catch (SQLException e) {
            setError(req, resp, "System error. Please try again.");
        }
    }

    private void setError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/bill-payment.jsp").forward(req, resp);
    }
}