package com.gojjam.bank.servlet.auth;

import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.util.AuditLogUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            String  name   = (String)  session.getAttribute("username");
            if (userId != null) {
                AuditLogUtil.log(userId, "USER LOGOUT: " + name, req);
            }
        }

        authService.logout(req);
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}