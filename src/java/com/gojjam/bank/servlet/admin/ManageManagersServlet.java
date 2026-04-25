package com.gojjam.bank.servlet.admin;

import com.gojjam.bank.dao.UserDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.AdminService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/managers")
public class ManageManagersServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();
    private final UserDAO      userDAO      = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("managers",  userDAO.getAllManagers());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/admin/manage-managers.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int adminId  = (int) req.getSession().getAttribute("userId");
        String action= req.getParameter("action");

        try {
            if ("ADD".equals(action)) {
                adminService.addManager(
                    ValidationUtil.sanitize(req.getParameter("username")),
                    req.getParameter("password"),
                    ValidationUtil.sanitize(req.getParameter("fullName")),
                    ValidationUtil.sanitize(req.getParameter("email")),
                    ValidationUtil.sanitize(req.getParameter("phone")),
                    req.getParameter("dateOfBirth"),
                    ValidationUtil.sanitize(req.getParameter("nationalId")),
                    adminId, req);
                req.setAttribute("success", "Manager account created successfully.");
            } else if ("DELETE".equals(action)) {
                int managerId = Integer.parseInt(req.getParameter("managerId"));
                adminService.deleteManager(managerId, adminId, req);
                req.setAttribute("success", "Manager account deleted.");
            }
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}