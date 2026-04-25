package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.UserDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.User;
import com.gojjam.bank.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/customer/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/customer/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId       = (int) req.getSession().getAttribute("userId");
        String current   = req.getParameter("currentPassword");
        String newPwd    = req.getParameter("newPassword");
        String confirmPwd= req.getParameter("confirmPassword");

        if (!newPwd.equals(confirmPwd)) {
            req.setAttribute("error", "New passwords do not match.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/change-password.jsp").forward(req, resp);
            return;
        }

        if (!PasswordUtil.isStrong(newPwd)) {
            req.setAttribute("error", "New password does not meet security requirements.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/change-password.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.findById(userId);
            if (user == null || !PasswordUtil.verify(current, user.getPasswordHash())) {
                req.setAttribute("error", "Current password is incorrect.");
                req.setAttribute("csrfToken", CSRFUtil.getToken(req));
                req.getRequestDispatcher("/jsp/customer/change-password.jsp").forward(req, resp);
                return;
            }
            userDAO.updatePassword(userId, PasswordUtil.hash(newPwd));
            AuditLogUtil.log(userId, "PASSWORD CHANGED by user", req);
            req.setAttribute("success", "Password changed successfully.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/change-password.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/change-password.jsp").forward(req, resp);
        }
    }
}