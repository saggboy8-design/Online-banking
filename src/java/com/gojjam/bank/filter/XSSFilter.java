package com.gojjam.bank.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebFilter("/*")
public class XSSFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
                         FilterChain chain) throws IOException, ServletException {
        chain.doFilter(new XSSRequestWrapper((HttpServletRequest) req), res);
    }

    /** Wrapper that sanitises parameter values. */
    public static class XSSRequestWrapper extends HttpServletRequestWrapper {

        public XSSRequestWrapper(HttpServletRequest request) {
            super(request);
        }

        @Override
        public String getParameter(String name) {
            return sanitize(super.getParameter(name));
        }

        @Override
        public String[] getParameterValues(String name) {
            String[] values = super.getParameterValues(name);
            if (values == null) return null;
            String[] sanitized = new String[values.length];
            for (int i = 0; i < values.length; i++) sanitized[i] = sanitize(values[i]);
            return sanitized;
        }

        @Override
        public Map<String, String[]> getParameterMap() {
            // Wrapping is handled per-parameter; return raw for iteration safety
            return super.getParameterMap();
        }

        private String sanitize(String value) {
            if (value == null) return null;
            return value.replaceAll("(?i)<script.*?>.*?</script.*?>", "")
                        .replaceAll("(?i)<.*?javascript:.*?>.*?</.*?>", "")
                        .replaceAll("(?i)<.*?\\s+on.*?>.*?</.*?>", "")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;");
        }
    }
}