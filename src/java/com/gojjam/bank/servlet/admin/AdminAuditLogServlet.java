package com.gojjam.bank.servlet.admin;

import com.gojjam.bank.dao.AuditLogDAO;
import com.gojjam.bank.model.AuditLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/audit-logs")
public class AdminAuditLogServlet extends HttpServlet {

    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<AuditLog> logs = auditLogDAO.getAll(500);
            req.setAttribute("logs", logs);
            req.getRequestDispatcher("/jsp/admin/audit-logs.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }
}