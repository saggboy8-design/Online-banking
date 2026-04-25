package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.UserDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.User;
import com.gojjam.bank.service.ManagerService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/manager/unlock")
public class UnlockAccountServlet extends HttpServlet {

    private final ManagerService managerService = new ManagerService();
    private final UserDAO        userDAO        = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<User> locked = userDAO.getAllCustomers().stream()
                .filter(u -> "LOCKED".equals(u.getStatus()))
                .collect(Collectors.toList());
            req.setAttribute("lockedUsers", locked);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/manager/unlock-accounts.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId = (int) req.getSession().getAttribute("userId");
        int userId    = Integer.parseInt(req.getParameter("userId"));

        try {
            managerService.unlockAccount(userId, managerId, req);
            req.setAttribute("success", "Account unlocked successfully.");
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}