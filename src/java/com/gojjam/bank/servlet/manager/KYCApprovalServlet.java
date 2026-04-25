package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.UserDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.User;
import com.gojjam.bank.service.ManagerService;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/manager/kyc")
public class KYCApprovalServlet extends HttpServlet {

    private final ManagerService managerService = new ManagerService();
    private final AccountDAO     accountDAO     = new AccountDAO();
    private final UserDAO        userDAO        = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Account> pending = accountDAO.getPendingKyc();
            // Attach full user info for national ID display
            List<User> users = new ArrayList<>();
            for (Account a : pending) {
                users.add(userDAO.findById(a.getUserId()));
            }
            req.setAttribute("pendingAccounts", pending);
            req.setAttribute("users", users);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/manager/kyc-approval.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int managerId = (int) req.getSession().getAttribute("userId");
        int accountId = Integer.parseInt(req.getParameter("accountId"));
        String action = req.getParameter("action");

        try {
            if ("APPROVE".equals(action)) {
                managerService.approveKyc(accountId, managerId, req);
                req.setAttribute("success", "KYC approved successfully.");
            } else {
                managerService.rejectKyc(accountId, managerId, req);
                req.setAttribute("success", "KYC rejected.");
            }
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}