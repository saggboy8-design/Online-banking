package com.gojjam.bank.service;

import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.dao.LoginAttemptDAO;
import com.gojjam.bank.dao.UserDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Account;
import com.gojjam.bank.model.User;
import com.gojjam.bank.util.AccountNumberUtil;
import com.gojjam.bank.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;

public class AuthService {

    private static final int MAX_FAILED_ATTEMPTS = 3;
    private static final int MAX_RESET_ATTEMPTS  = 5;

    private final UserDAO         userDAO         = new UserDAO();
    private final AccountDAO      accountDAO      = new AccountDAO();
    private final LoginAttemptDAO loginAttemptDAO = new LoginAttemptDAO();

    /** Authenticate user and bind session. */
    public User login(String username, String rawPassword,
                      HttpServletRequest request) throws BankingException, SQLException {

        String ip = getClientIP(request);

        // Fetch user
        User user = userDAO.findByUsername(username);

        // Record attempt and check failed count
        if (user == null) {
            loginAttemptDAO.record(username, ip, false);
            throw new BankingException("Invalid username or password.");
        }

        // Check if already locked
        if ("LOCKED".equals(user.getStatus())) {
            throw new BankingException("Your account is locked. Please contact the bank.");
        }

        if ("PENDING".equals(user.getStatus())) {
            throw new BankingException("Your account is pending approval by a manager.");
        }

        if ("REJECTED".equals(user.getStatus())) {
            throw new BankingException("Your registration has been rejected. Please contact support.");
        }

        // Check failed attempts
        int failedCount = userDAO.countRecentFailedAttempts(username);
        if (failedCount >= MAX_FAILED_ATTEMPTS) {
            userDAO.updateStatus(user.getId(), "LOCKED");
            loginAttemptDAO.record(username, ip, false);
            throw new BankingException("Account locked due to too many failed attempts. Contact admin.");
        }

        // Verify password
        if (!PasswordUtil.verify(rawPassword, user.getPasswordHash())) {
            loginAttemptDAO.record(username, ip, false);
            int remaining = MAX_FAILED_ATTEMPTS - failedCount - 1;
            throw new BankingException("Invalid username or password. " + remaining + " attempt(s) remaining.");
        }

        // Invalidate any previous session
        if (user.isSessionActive() && user.getCurrentSessionId() != null) {
            // Mark old session invalid (best effort)
            userDAO.updateSession(user.getId(), false, null);
        }

        // Create new session
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) oldSession.invalidate();

        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(15 * 60);   // 15 minutes

        session.setAttribute("userId",   user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("role",     user.getRoleName());
        session.setAttribute("email",    user.getEmail());

        // Update DB with new session ID
        userDAO.updateSession(user.getId(), true, session.getId());

        // Record successful attempt
        loginAttemptDAO.record(username, ip, true);

        return user;
    }

    /** Register a new customer. */
    public void register(String username, String rawPassword, String fullName,
                         String email, String phone, String dobStr,
                         String nationalId, boolean acceptedTerms) throws BankingException, SQLException {

        if (!acceptedTerms)
            throw new BankingException("You must accept the Privacy Policy and Terms of Use to register.");

        if (!PasswordUtil.isStrong(rawPassword))
            throw new BankingException("Password does not meet minimum security requirements.");

        if (userDAO.existsByUsername(username))
            throw new BankingException("Username is already taken.");

        if (userDAO.existsByEmail(email))
            throw new BankingException("An account with this email already exists.");

        if (userDAO.existsByNationalId(nationalId))
            throw new BankingException("National ID number is already registered.");

        // Get CUSTOMER role id (assume id=1; fetch dynamically)
        int customerRoleId = getCustomerRoleId();

        User user = new User();
        user.setUsername(username.trim());
        user.setPasswordHash(PasswordUtil.hash(rawPassword));
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPhone(phone.trim());
        user.setDateOfBirth(LocalDate.parse(dobStr));
        user.setNationalIdNumber(nationalId.trim().toUpperCase());
        user.setRoleId(customerRoleId);
        user.setStatus("PENDING");

        int userId = userDAO.insert(user);
        if (userId < 0) throw new BankingException("Registration failed. Please try again.");

        // Create account
        Account account = new Account();
        account.setUserId(userId);
        account.setAccountNumber(AccountNumberUtil.generate());
        account.setBalance(BigDecimal.ZERO);
        account.setAccountType("SAVINGS");
        account.setKycStatus("PENDING");
        accountDAO.insert(account);
    }

    /** Logout – clear session and update DB. */
    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                try { userDAO.updateSession(userId, false, null); }
                catch (SQLException ignored) {}
            }
            session.invalidate();
        }
    }

    /** Verify re-authentication credentials. Returns true if valid. */
    public boolean reAuthenticate(String username, String rawPassword,
                                   HttpServletRequest request) throws SQLException {
        User user = userDAO.findByUsername(username);
        if (user == null) return false;
        if (!"ACTIVE".equals(user.getStatus())) return false;

        Integer sessionUserId = (Integer) request.getSession(false).getAttribute("userId");
        if (sessionUserId == null || sessionUserId != user.getId()) return false;

        boolean valid = PasswordUtil.verify(rawPassword, user.getPasswordHash());
        if (valid) {
            request.getSession().setAttribute("reAuthTime", System.currentTimeMillis());
        }
        return valid;
    }

    /** Check if re-auth is still valid (within 10 minutes). */
    public static boolean isReAuthValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Long reAuthTime = (Long) session.getAttribute("reAuthTime");
        if (reAuthTime == null) return false;
        return (System.currentTimeMillis() - reAuthTime) < 10 * 60 * 1000L;
    }

    /** Reset password after verification. */
    public void resetPassword(String username, String fullName, String email,
                               String phone, String dob, String nationalId,
                               String accountNumber, String newPassword,
                               String ip) throws BankingException, SQLException {

        int attempts = userDAO.countPasswordResetAttempts(username);
        if (attempts >= MAX_RESET_ATTEMPTS) {
            loginAttemptDAO.recordResetAttempt(username, ip, false);
            throw new BankingException("Provided information does not match our records.");
        }

        User user = userDAO.verifyForgotPasswordFields(
            username, fullName, email, phone, dob, nationalId, accountNumber);

        if (user == null) {
            loginAttemptDAO.recordResetAttempt(username, ip, false);
            throw new BankingException("Provided information does not match our records.");
        }

        if (!PasswordUtil.isStrong(newPassword))
            throw new BankingException("New password does not meet minimum security requirements.");

        userDAO.updatePassword(user.getId(), PasswordUtil.hash(newPassword));
        loginAttemptDAO.recordResetAttempt(username, ip, true);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────────
    private int getCustomerRoleId() throws SQLException {
        try (java.sql.Connection c = com.gojjam.bank.config.DBConnection.getConnection();
             java.sql.PreparedStatement ps = c.prepareStatement(
                 "SELECT id FROM roles WHERE role_name='CUSTOMER'");
             java.sql.ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 1;
        }
    }

    public static String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip))
            return ip.split(",")[0].trim();
        ip = request.getHeader("X-Real-IP");
        if (ip != null && !ip.isEmpty()) return ip;
        return request.getRemoteAddr();
    }
}