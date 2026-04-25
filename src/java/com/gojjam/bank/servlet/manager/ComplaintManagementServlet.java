package com.gojjam.bank.servlet.manager;

import com.gojjam.bank.dao.ComplaintDAO;
import com.gojjam.bank.exception.BankingException;
import com.gojjam.bank.service.ComplaintService;
import com.gojjam.bank.util.CSRFUtil;
import com.gojjam.bank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/manager/complaints")
public class ComplaintManagementServlet extends HttpServlet {

    private final ComplaintService complaintService = new ComplaintService();
    private final ComplaintDAO     complaintDAO     = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("complaints", complaintDAO.getAll());
            req.setAttribute("csrfToken", CSRFUtil.getToken(req));
            req.getRequestDispatcher("/jsp/manager/complaints.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/error/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int responderId   = (int) req.getSession().getAttribute("userId");
        int complaintId   = Integer.parseInt(req.getParameter("complaintId"));
        String response   = ValidationUtil.sanitize(req.getParameter("response"));
        String status     = req.getParameter("status");

        try {
            complaintService.respondToComplaint(complaintId, responderId, response, status, req);
            req.setAttribute("success", "Response submitted.");
        } catch (BankingException e) {
            req.setAttribute("error", e.getUserMessage());
        } catch (SQLException e) {
            req.setAttribute("error", "System error.");
        }
        doGet(req, resp);
    }
}