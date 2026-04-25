package com.gojjam.bank.util;

import com.gojjam.bank.dao.AuditLogDAO;
import jakarta.servlet.http.HttpServletRequest;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuditLogUtil {

    private static final Logger LOGGER = Logger.getLogger(AuditLogUtil.class.getName());
    private static final AuditLogDAO auditLogDAO = new AuditLogDAO();

    private AuditLogUtil() {}

    public static void log(Integer userId, String action,
                           HttpServletRequest request,
                           String oldValue, String newValue) {
        try {
            String ip = getClientIP(request);
            auditLogDAO.insert(userId, action, ip, oldValue, newValue);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to write audit log: " + action, e);
        }
    }

    public static void log(Integer userId, String action, HttpServletRequest request) {
        log(userId, action, request, null, null);
    }

    private static String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        ip = request.getHeader("X-Real-IP");
        if (ip != null && !ip.isEmpty()) return ip;
        return request.getRemoteAddr();
    }
}