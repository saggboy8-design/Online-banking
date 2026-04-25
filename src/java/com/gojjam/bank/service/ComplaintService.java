package com.gojjam.bank.service;

import com.gojjam.bank.dao.ComplaintDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Complaint;
import com.gojjam.bank.model.User;
import com.gojjam.bank.util.AuditLogUtil;
import com.gojjam.bank.util.EmailUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.sql.SQLException;

public class ComplaintService {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    public void submitComplaint(int userId, String userFullName,
                                 String category, String description,
                                 HttpServletRequest request) throws BankingException, SQLException {

        if (category == null || category.isBlank()) throw new BankingException("Category is required.");
        if (description == null || description.isBlank()) throw new BankingException("Description is required.");

        Complaint complaint = new Complaint();
        complaint.setUserId(userId);
        complaint.setCategory(category);
        complaint.setDescription(description);

        complaintDAO.insert(complaint);
        AuditLogUtil.log(userId, "COMPLAINT SUBMITTED: " + category, request);

        // Send notification email (async-style, non-blocking)
        Thread emailThread = new Thread(() ->
            EmailUtil.notifyNewComplaint(userFullName, category, description));
        emailThread.setDaemon(true);
        emailThread.start();
    }

    public void respondToComplaint(int complaintId, int responderId,
                                    String response, String status,
                                    HttpServletRequest request) throws BankingException, SQLException {
        if (response == null || response.isBlank()) throw new BankingException("Response cannot be empty.");
        complaintDAO.respond(complaintId, responderId, response, status);
        AuditLogUtil.log(responderId, "COMPLAINT RESPONDED: ID=" + complaintId + " | Status: " + status, request);
    }
}