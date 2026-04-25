package com.gojjam.bank.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.UUID;

public class CSRFUtil {

    public static final String CSRF_TOKEN_ATTR = "csrfToken";

    private CSRFUtil() {}

    /** Creates (or returns existing) CSRF token for the session. */
    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) session = request.getSession(true);

        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute(CSRF_TOKEN_ATTR, token);
        }
        return token;
    }

    /** Validates that the submitted token matches the session token. */
    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        String submitted    = request.getParameter("csrfToken");

        return sessionToken != null && sessionToken.equals(submitted);
    }

    /** Rotates the CSRF token (call after sensitive operations). */
    public static String rotateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        String newToken = UUID.randomUUID().toString();
        session.setAttribute(CSRF_TOKEN_ATTR, newToken);
        return newToken;
    }
}