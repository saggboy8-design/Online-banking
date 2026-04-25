package com.gojjam.bank.servlet.auth;

import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reauth")
public class ReAuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.setAttribute("redirectTo", req.getParameter("redirectTo"));
        req.getRequestDispatcher("/jsp/customer/reauth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username   = (String) req.getSession(false).getAttribute("username");
        String password   = req.getParameter("password");
        String redirectTo = req.getParameter("redirectTo");

        if (redirectTo == null || redirectTo.isBlank()) redirectTo = req.getContextPath() + "/customer/dashboard";

        try {
            boolean ok = authService.reAuthenticate(username, password, req);
            if (ok) {
                resp.sendRedirect(redirectTo);
            } else {
                req.setAttribute("error", "Invalid credentials. Please try again.");
                req.setAttribute("csrfToken", CSRFUtil.getToken(req));
                req.setAttribute("redirectTo", redirectTo);
                req.getRequestDispatcher("/jsp/customer/reauth.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            req.setAttribute("error", "System error. Please try again.");
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/reauth.jsp").forward(req, resp);
        }
    }
}