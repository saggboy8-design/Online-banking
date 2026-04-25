package com.gojjam.bank.servlet.admin;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.UserDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.AdminService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/accounts")
public class ManageAccountsServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();
    private final AccountDAO   accountDAO   = new AccountDAO();
    private final UserDAO      userDAO      = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("accounts",  accountDAO.getAll());
            req.setAttribute("customers", userDAO.getAllCustomers());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/admin/manage-accounts.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int adminId  = (int) req.getSession().getAttribute("userId");
        String action= req.getParameter("action");
        int targetId = Integer.parseInt(req.getParameter("userId"));

        try {
            switch (action) {
                case "LOCK"   -> adminService.lockAccount(targetId, adminId, req);
                case "UNLOCK" -> adminService.unlockAccount(targetId, adminId, req);
                default       -> throw new BankingException("Unknown action.");
            }
            req.setAttribute("success", "Action completed: " + action);
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}