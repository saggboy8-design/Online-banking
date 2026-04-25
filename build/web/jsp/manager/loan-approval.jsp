<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Loan,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Loan Approvals";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
    List<Loan> loans = (List<Loan>) request.getAttribute("loans");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-bank"></i> Loan Approvals</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;">Manager: <strong><%= fullName %></strong></span>
      <div class="avatar-circle" style="background:#1a3a6e;"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-bank alert-error">
        <i class="bi bi-exclamation-circle-fill"></i>
        <%= request.getAttribute("error") %>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert-bank alert-success">
        <i class="bi bi-check-circle-fill"></i>
        <%= request.getAttribute("success") %>
      </div>
    <% } %>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-hourglass-split"></i> Pending Loan Applications
        <span style="margin-left:auto;background:rgba(255,255,255,0.2);
                     padding:2px 10px;border-radius:12px;font-size:0.8rem;">
          <%= loans != null ? loans.size() : 0 %> pending
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <% if (loans == null || loans.isEmpty()) { %>
          <div style="padding:2rem;text-align:center;color:#6c757d;">
            <i class="bi bi-check-all" style="font-size:2.5rem;color:#28a745;"></i>
            <p style="margin-top:0.5rem;">No pending loan applications.</p>
          </div>
        <% } else { %>
          <div class="table-responsive">
            <table class="bank-table">
              <thead>
                <tr>
                  <th>#</th><th>Applicant</th><th>Account No.</th>
                  <th>National ID</th><th>Phone</th>
                  <th>Amount (ETB)</th><th>Duration</th>
                  <th>Purpose</th><th>Applied</th><th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <% for (Loan loan : loans) { %>
                  <tr>
                    <td><%= loan.getId() %></td>
                    <td>
                      <strong><%= loan.getOwnerName() %></strong><br/>
                      <small style="color:#6c757d;font-size:0.78rem;">
                        <%= loan.getOwnerEmail() %>
                      </small>
                    </td>
                    <td><code><%= loan.getAccountNumber() %></code></td>
                    <td>
                      <code style="background:#fff3cd;padding:2px 6px;border-radius:4px;font-size:0.8rem;">
                        <%= loan.getOwnerNationalId() %>
                      </code>
                    </td>
                    <td style="font-size:0.83rem;"><%= loan.getOwnerPhone() %></td>
                    <td>
                      <strong style="color:#0A1F44;">
                        ETB <%= loan.getAmount().toPlainString() %>
                      </strong>
                    </td>
                    <td><%= loan.getDurationMonths() %> months</td>
                    <td style="max-width:140px;font-size:0.82rem;
                               overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
                        title="<%= loan.getPurpose() %>">
                      <%= loan.getPurpose() %>
                    </td>
                    <td style="font-size:0.82rem;">
                      <%= loan.getCreatedAt() != null
                          ? loan.getCreatedAt().format(fmt) : "" %>
                    </td>
                    <td>
                      <!-- Approve -->
                      <form method="post"
                            action="${pageContext.request.contextPath}/manager/loans"
                            style="display:inline;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                        <input type="hidden" name="loanId"   value="<%= loan.getId() %>"/>
                        <input type="hidden" name="action"   value="APPROVE"/>
                        <button type="submit" class="btn-bank btn-accent"
                                style="width:auto;padding:3px 10px;font-size:0.78rem;"
                                data-confirm="Approve loan of ETB <%= loan.getAmount().toPlainString() %> for <%= loan.getOwnerName() %>? Amount will be credited immediately.">
                          <i class="bi bi-check"></i> Approve
                        </button>
                      </form>

                      <!-- Reject Modal Trigger -->
                      <button type="button"
                              class="btn-bank btn-danger-b"
                              style="width:auto;padding:3px 10px;font-size:0.78rem;margin-top:3px;"
                              onclick="openRejectModal(<%= loan.getId() %>,'<%= loan.getOwnerName().replace("'","") %>')">
                        <i class="bi bi-x"></i> Reject
                      </button>
                    </td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        <% } %>
      </div>
    </div>

    <!-- Reject Modal -->
    <div id="rejectModal" style="display:none;position:fixed;top:0;left:0;
         width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;
         align-items:center;justify-content:center;">
      <div style="background:#fff;border-radius:12px;padding:1.5rem;
                  width:100%;max-width:440px;margin:auto;box-shadow:0 8px 32px rgba(0,0,0,0.2);">
        <h5 style="color:#0A1F44;font-weight:700;margin-bottom:1rem;">
          <i class="bi bi-x-circle"></i> Reject Loan Application
        </h5>
        <p id="rejectModalLabel" style="color:#6c757d;font-size:0.88rem;"></p>
        <form method="post" action="${pageContext.request.contextPath}/manager/loans">
          <input type="hidden" name="csrfToken" value="${csrfToken}"/>
          <input type="hidden" name="action"    value="REJECT"/>
          <input type="hidden" name="loanId"    id="rejectLoanId"/>
          <div class="mb-3">
            <label class="form-label">Rejection Reason <span class="required-star">*</span></label>
            <textarea name="rejectionReason" class="form-control"
                      rows="3" required maxlength="500"
                      placeholder="Explain reason for rejection..."></textarea>
          </div>
          <div style="display:flex;gap:8px;">
            <button type="submit" class="btn-bank btn-danger-b" style="max-width:140px;">
              <i class="bi bi-x-circle"></i> Reject
            </button>
            <button type="button" onclick="closeRejectModal()"
                    class="btn-bank" style="max-width:120px;background:#6c757d;">
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>

  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function openRejectModal(loanId, name) {
  document.getElementById('rejectLoanId').value    = loanId;
  document.getElementById('rejectModalLabel').textContent =
      'Rejecting loan #' + loanId + ' for ' + name;
  const m = document.getElementById('rejectModal');
  m.style.display = 'flex';
}
function closeRejectModal() {
  document.getElementById('rejectModal').style.display = 'none';
}
</script>
</body>
</html>