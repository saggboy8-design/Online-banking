package com.gojjam.bank.servlet.auth;

import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.User;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.util.AuditLogUtil;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If already logged in, redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            redirectDashboard(resp, (String) session.getAttribute("role"), req);
            return;
        }

        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = ValidationUtil.sanitize(req.getParameter("username"));
        String password = req.getParameter("password");  // raw – never sanitize passwords

        if (ValidationUtil.isBlank(username) || ValidationUtil.isBlank(password)) {
            req.setAttribute("error", "Username and password are required.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = authService.login(username, password, req);
            AuditLogUtil.log(user.getId(), "USER LOGIN: " + username, req);
            redirectDashboard(resp, user.getRoleName(), req);

        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
        }
    }

    private void redirectDashboard(HttpServletResponse resp, String role,
                                    HttpServletRequest req) throws IOException {
        String ctx = req.getContextPath();
        switch (role) {
            case "ADMIN"    -> resp.sendRedirect(ctx + "/admin/dashboard");
            case "MANAGER"  -> resp.sendRedirect(ctx + "/manager/dashboard");
            default         -> resp.sendRedirect(ctx + "/customer/dashboard");
        }
    }
}