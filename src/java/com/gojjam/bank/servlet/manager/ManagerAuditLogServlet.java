package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.AuditLogDAO;
import com.gojjam.bank.model.AuditLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manager/audit-logs")
public class ManagerAuditLogServlet extends HttpServlet {

    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<AuditLog> logs = auditLogDAO.getAll(200);
            req.setAttribute("logs", logs);
            req.getRequestDispatcher("/jsp/manager/audit-logs.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}