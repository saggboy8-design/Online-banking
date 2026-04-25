package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.ScheduledPaymentDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.ScheduledPayment;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.service.ScheduledPaymentService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customer/scheduled-payment")
public class ScheduledPaymentServlet extends HttpServlet {

    private final ScheduledPaymentService spService = new ScheduledPaymentService();
    private final ScheduledPaymentDAO     spDAO     = new ScheduledPaymentDAO();
    private final AccountDAO              accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath() + "/reauth?redirectTo="
                + req.getContextPath() + "/customer/scheduled-payment");
            return;
        }

        int userId = (int) req.getSession(false).getAttribute("userId");
        try {
            Account account = accountDAO.findByUserId(userId);
            List<ScheduledPayment> list = (account != null)
                ? spDAO.getByAccount(account.getId()) : List.of();

            // Cancel
            String cancelId = req.getParameter("cancel");
            if (cancelId != null) {
                spDAO.cancel(Integer.parseInt(cancelId));
                resp.sendRedirect(req.getContextPath() + "/customer/scheduled-payment");
                return;
            }

            req.setAttribute("payments", list);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/scheduled-payment.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
            req.getRequestDispatcher("/jsp/customer/scheduled-payment.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!AuthService.isReAuthValid(req)) {
            resp.sendRedirect(req.getContextPath() + "/reauth?redirectTo="
                + req.getContextPath() + "/customer/scheduled-payment");
            return;
        }

        int userId        = (int) req.getSession().getAttribute("userId");
        String type       = ValidationUtil.sanitize(req.getParameter("paymentType"));
        String amountStr  = req.getParameter("amount");
        String recipient  = ValidationUtil.sanitize(req.getParameter("recipient"));
        String refNum     = ValidationUtil.sanitize(req.getParameter("referenceNumber"));
        String frequency  = ValidationUtil.sanitize(req.getParameter("frequency"));
        String scheduledDate = req.getParameter("scheduledDate");  // datetime-local input

        try {
            BigDecimal amount = new BigDecimal(amountStr);
            spService.schedule(userId, type, amount, recipient, refNum, frequency, scheduledDate, req);
            req.setAttribute("success", "Payment scheduled successfully.");
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (Exception e) {
            req.setAttribute("error", "System error. Please try again.");
        }

        doGet(req, resp);
    }
}