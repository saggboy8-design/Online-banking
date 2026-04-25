package com.gojjam.bank.servlet.auth;

import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.AuthService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username    = ValidationUtil.sanitize(req.getParameter("username"));
        String password    = req.getParameter("password");
        String confirmPwd  = req.getParameter("confirmPassword");
        String fullName    = ValidationUtil.sanitize(req.getParameter("fullName"));
        String email       = ValidationUtil.sanitize(req.getParameter("email"));
        String phone       = ValidationUtil.sanitize(req.getParameter("phone"));
        String dob         = ValidationUtil.sanitize(req.getParameter("dateOfBirth"));
        String nationalId  = ValidationUtil.sanitize(req.getParameter("nationalId"));
        String acceptedStr = req.getParameter("acceptTerms");

        boolean acceptedTerms = "on".equals(acceptedStr) || "true".equals(acceptedStr);

        // Frontend-mirrored backend validation
        if (ValidationUtil.isBlank(username) || ValidationUtil.isBlank(password)
            || ValidationUtil.isBlank(fullName) || ValidationUtil.isBlank(email)
            || ValidationUtil.isBlank(phone) || ValidationUtil.isBlank(dob)
            || ValidationUtil.isBlank(nationalId)) {
            setError(req, "All fields are required.", resp); return;
        }

        if (!password.equals(confirmPwd)) {
            setError(req, "Passwords do not match.", resp); return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            setError(req, "Please enter a valid email address.", resp); return;
        }

        if (!ValidationUtil.isValidPhone(phone)) {
            setError(req, "Please enter a valid phone number.", resp); return;
        }

        if (!ValidationUtil.isValidDate(dob) || !ValidationUtil.isPastDate(dob)) {
            setError(req, "Please enter a valid date of birth.", resp); return;
        }

        if (!ValidationUtil.isValidNationalId(nationalId)) {
            setError(req, "National ID must be 5-20 alphanumeric characters.", resp); return;
        }

        try {
            authService.register(username, password, fullName, email, phone,
                                 dob, nationalId, acceptedTerms);
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/pending-approval.jsp");

        } catch (BankingException e) {
            setError(req, e.getUserMessage(), resp);
        } catch (SQLException e) {
            setError(req, "Registration failed. Please try again.", resp);
        }
    }

    private void setError(HttpServletRequest req, String msg,
                           HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.setAttribute("csrfToken", CSRFUtil.getToken(req));
        req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
    }
}