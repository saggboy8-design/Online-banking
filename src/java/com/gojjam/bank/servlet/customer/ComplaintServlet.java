package com.gojjam.bank.servlet.customer;

import com.gojjam.bank.dao.ComplaintDAO;
import com.gojjam.bank.dao.AccountDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.model.Complaint;
import com.gojjam.bank.service.ComplaintService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customer/complaint")
public class ComplaintServlet extends HttpServlet {

    private final ComplaintService complaintService = new ComplaintService();
    private final ComplaintDAO     complaintDAO     = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession(false).getAttribute("userId");
        try {
            List<Complaint> complaints = complaintDAO.getByUser(userId);
            req.setAttribute("complaints", complaints);
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/customer/complaint.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Could not load complaints.");
            req.getRequestDispatcher("/jsp/customer/complaint.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId      = (int) req.getSession().getAttribute("userId");
        String fullName = (String) req.getSession().getAttribute("fullName");
        String category = ValidationUtil.sanitize(req.getParameter("category"));
        String desc     = ValidationUtil.sanitize(req.getParameter("description"));

        try {
            complaintService.submitComplaint(userId, fullName, category, desc, req);
            req.setAttribute("success", "Complaint submitted successfully. We will respond soon.");
            doGet(req, resp);
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
            doGet(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
            doGet(req, resp);
        }
    }
}