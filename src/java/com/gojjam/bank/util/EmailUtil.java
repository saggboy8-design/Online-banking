package com.gojjam.bank.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtil {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    // ── Configure your SMTP server ─────────────────────────────────────────────
    private static final String SMTP_HOST     = "smtp.gmail.com";
    private static final String SMTP_PORT     = "587";
    private static final String SMTP_USER     = "leamilak22@gmail.com";
    private static final String SMTP_PASSWORD = "!yeneworK3333";  // Update this
    private static final String FROM_NAME     = "Gojjam International Bank";
    private static final String COMPLAINT_EMAIL = "leamilak11@gmail.com";
    // ──────────────────────────────────────────────────────────────────────────

    private EmailUtil() {}

    public static void sendEmail(String toEmail, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });
        
        // Optional: Enable debugging
        // session.setDebug(true);

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, FROM_NAME));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(message);
            LOGGER.info("Email sent to: " + toEmail);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send email to " + toEmail, e);
        }
    }

    // Rest of your methods remain the same...
    public static void notifyNewComplaint(String customerName, String category, String description) {
        String subject = "New Customer Complaint – Gojjam International Bank";
        String body = "<div style='font-family:Arial;'>"
            + "<h2 style='color:#0A1F44;'>New Complaint Received</h2>"
            + "<p><strong>Customer:</strong> " + customerName + "</p>"
            + "<p><strong>Category:</strong> " + category + "</p>"
            + "<p><strong>Description:</strong></p>"
            + "<p>" + description + "</p>"
            + "<hr><p style='color:#888;'>Gojjam International Bank – Automated Notification</p>"
            + "</div>";
        sendEmail(COMPLAINT_EMAIL, subject, body);
    }
    
    public static void sendApprovalEmail(String toEmail, String fullName, String accountNumber) {
        String subject = "Your Account Has Been Approved – Gojjam International Bank";
        String body = "<div style='font-family:Arial;'>"
            + "<h2 style='color:#0A1F44;'>Welcome, " + fullName + "!</h2>"
            + "<p>Your account has been approved by our team.</p>"
            + "<p><strong>Account Number:</strong> " + accountNumber + "</p>"
            + "<p>You may now log in and access all banking services.</p>"
            + "<hr><p style='color:#888;'>Gojjam International Bank</p>"
            + "</div>";
        sendEmail(toEmail, subject, body);
    }

    public static void sendRejectionEmail(String toEmail, String fullName) {
        String subject = "Account Registration Status – Gojjam International Bank";
        String body = "<div style='font-family:Arial;'>"
            + "<h2 style='color:#0A1F44;'>Account Review Update</h2>"
            + "<p>Dear " + fullName + ",</p>"
            + "<p>After reviewing your submitted information, we are unable to approve your registration at this time.</p>"
            + "<p>Please contact our support team for further assistance.</p>"
            + "<hr><p style='color:#888;'>Gojjam International Bank</p>"
            + "</div>";
        sendEmail(toEmail, subject, body);
    }
}