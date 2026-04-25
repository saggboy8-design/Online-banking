package com.gojjam.bank.servlet.auth;

import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username     = ValidationUtil.sanitize(req.getParameter("username"));
        String fullName     = ValidationUtil.sanitize(req.getParameter("fullName"));
        String email        = ValidationUtil.sanitize(req.getParameter("email"));
        String phone        = ValidationUtil.sanitize(req.getParameter("phone"));
        String dob          = ValidationUtil.sanitize(req.getParameter("dateOfBirth"));
        String nationalId   = ValidationUtil.sanitize(req.getParameter("nationalId"));
        String accountNumber= ValidationUtil.sanitize(req.getParameter("accountNumber"));
        String newPassword  = req.getParameter("newPassword");
        String confirmPwd   = req.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPwd)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        String ip = AuthService.getClientIP(req);

        try {
            authService.resetPassword(username, fullName, email, phone, dob,
                                      nationalId, accountNumber, newPassword, ip);
            req.setAttribute("success", "Password reset successfully. You may now log in.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(req, resp);

        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(req, resp);
        }
    }
}