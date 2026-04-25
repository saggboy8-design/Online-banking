package com.gojjam.bank.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        // ── Public paths (no auth required) ──────────────────────────────────
        boolean isPublic =
            uri.equals(ctx + "/login")          ||
            uri.equals(ctx + "/register")       ||
            uri.equals(ctx + "/forgot-password")||
            uri.startsWith(ctx + "/css/")       ||
            uri.startsWith(ctx + "/js/")        ||
            uri.startsWith(ctx + "/images/")    ||
            uri.startsWith(ctx + "/error/");

        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(ctx + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ── Role-based path protection ────────────────────────────────────────
        if (uri.startsWith(ctx + "/admin/") && !"ADMIN".equals(role)) {
            response.sendRedirect(ctx + "/login");
            return;
        }
        if (uri.startsWith(ctx + "/manager/") && !"MANAGER".equals(role) && !"ADMIN".equals(role)) {
            response.sendRedirect(ctx + "/login");
            return;
        }
        if (uri.startsWith(ctx + "/customer/") && !"CUSTOMER".equals(role)) {
            response.sendRedirect(ctx + "/login");
            return;
        }

        // ── Security headers ──────────────────────────────────────────────────
        response.setHeader("X-Frame-Options",           "DENY");
        response.setHeader("X-Content-Type-Options",    "nosniff");
        response.setHeader("X-XSS-Protection",          "1; mode=block");
        response.setHeader("Referrer-Policy",           "no-referrer");
        response.setHeader("Cache-Control",             "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma",                    "no-cache");

        chain.doFilter(req, res);
    }
}