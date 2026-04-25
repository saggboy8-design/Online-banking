package com.gojjam.bank.servlet.admin;

import com.gojjam.bank.dao.SystemConfigDAO;
import com.gojjam.bank.util.AuditLogUtil;
import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/config")
public class SystemConfigServlet extends HttpServlet {

    private final SystemConfigDAO configDAO = new SystemConfigDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("configs",   configDAO.getAll());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/admin/system-config.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int adminId   = (int) req.getSession().getAttribute("userId");
        String key    = req.getParameter("configKey");
        String value  = req.getParameter("configValue");

        try {
            String oldValue = configDAO.getValue(key);
            configDAO.update(key, value, adminId);
            AuditLogUtil.log(adminId, "CONFIG UPDATED: " + key + " = " + value, req,
                key + "=" + oldValue, key + "=" + value);
            req.setAttribute("success", "Configuration updated successfully.");
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}