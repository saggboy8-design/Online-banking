package com.gojjam.bank.filter;

import com.gojjam.bank.util.CSRFUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class CSRFFilter implements Filter {

    private static final Set<String> PROTECTED_METHODS = Set.of("POST", "PUT", "DELETE", "PATCH");

    // Paths that do NOT need CSRF (e.g. read-only endpoints)
    private static final Set<String> EXCLUDED_PATHS = Set.of(
        "/login", "/logout", "/register", "/forgot-password"
    );

    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String method = request.getMethod().toUpperCase();
        String uri    = request.getRequestURI();
        String ctx    = request.getContextPath();
        String path   = uri.substring(ctx.length());

        if (PROTECTED_METHODS.contains(method) && !EXCLUDED_PATHS.contains(path)) {
            if (!CSRFUtil.isValid(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Invalid or missing CSRF token.");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}