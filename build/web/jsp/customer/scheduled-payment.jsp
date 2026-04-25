<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.ScheduledPayment,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Scheduled Payments";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
    List<ScheduledPayment> payments =
        (List<ScheduledPayment>) request.getAttribute("payments");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-calendar-check"></i> Scheduled Payments</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle"><%= initials %></div>
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

    <div class="row g-3">

      <!-- Schedule Form -->
      <div class="col-md-4">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-clock-history"></i> New Scheduled Payment
          </div>
          <div class="bank-card-body">
            <div class="alert-bank alert-warning" style="font-size:0.82rem;">
              <i class="bi bi-exclamation-triangle"></i>
              Scheduled date must be in the future. Ensure sufficient balance at execution time.
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/customer/scheduled-payment"
                  id="schedForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>

              <div class="mb-3">
                <label class="form-label">
                  Payment Type <span class="required-star">*</span>
                </label>
                <select name="paymentType" class="form-select" required>
                  <option value="">-- Select Type --</option>
                  <option value="ELECTRICITY">⚡ Electricity</option>
                  <option value="WATER">💧 Water</option>
                  <option value="INTERNET">🌐 Internet</option>
                  <option value="MOBILE">📱 Mobile Recharge</option>
                  <option value="SCHOOL_FEES">🎓 School Fees</option>
                  <option value="TRANSFER">💸 Transfer</option>
                </select>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Recipient / Provider <span class="required-star">*</span>
                </label>
                <input type="text" name="recipient" class="form-control"
                       required maxlength="200"
                       placeholder="Provider or account number"/>
              </div>

              <div class="mb-3">
                <label class="form-label">Reference Number</label>
                <input type="text" name="referenceNumber" class="form-control"
                       maxlength="100" placeholder="Bill or reference number"/>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Amount (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="amount" class="form-control"
                       min="1" step="0.01" required placeholder="500.00"/>
                <div class="fee-display">
                  Service Fee: <strong>ETB 10.00</strong>
                </div>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Frequency <span class="required-star">*</span>
                </label>
                <select name="frequency" class="form-select" required>
                  <option value="ONE_TIME">One-Time</option>
                  <option value="WEEKLY">Weekly (Recurring)</option>
                  <option value="MONTHLY">Monthly (Recurring)</option>
                </select>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Scheduled Date & Time <span class="required-star">*</span>
                </label>
                <input type="datetime-local" name="scheduledDate"
                       class="form-control" required
                       min="<%= java.time.LocalDateTime.now()
                                    .format(java.time.format.DateTimeFormatter
                                    .ofPattern("yyyy-MM-dd'T'HH:mm")) %>"/>
                <small style="color:#6c757d;font-size:0.78rem;">
                  Must be in the future.
                </small>
              </div>

              <button type="submit" class="btn-bank">
                <i class="bi bi-calendar-plus"></i> Schedule Payment
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- Scheduled Payments List -->
      <div class="col-md-8">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-list-task"></i> My Scheduled Payments
            <span style="margin-left:auto;font-size:0.8rem;opacity:0.8;">
              <%= payments != null ? payments.size() : 0 %> total
            </span>
          </div>
          <div class="bank-card-body" style="padding:0;">
            <% if (payments == null || payments.isEmpty()) { %>
              <div style="padding:2rem;text-align:center;color:#6c757d;">
                <i class="bi bi-calendar-x" style="font-size:2.5rem;"></i>
                <p style="margin-top:0.5rem;">No scheduled payments.</p>
              </div>
            <% } else { %>
              <div class="table-responsive">
                <table class="bank-table">
                  <thead>
                    <tr>
                      <th>#</th><th>Type</th><th>Recipient</th>
                      <th>Amount (ETB)</th><th>Frequency</th>
                      <th>Next Run</th><th>Status</th><th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (ScheduledPayment sp : payments) { %>
                      <tr>
                        <td><%= sp.getId() %></td>
                        <td>
                          <span style="font-size:0.83rem;">
                            <%= sp.getPaymentType().replace("_"," ") %>
                          </span>
                        </td>
                        <td style="font-size:0.83rem;max-width:120px;
                                   overflow:hidden;text-overflow:ellipsis;">
                          <%= sp.getRecipient() %>
                        </td>
                        <td>
                          <strong>ETB <%= sp.getAmount().toPlainString() %></strong>
                          <br/>
                          <small style="color:#6c757d;">
                            +ETB <%= sp.getFee().toPlainString() %> fee
                          </small>
                        </td>
                        <td>
                          <span class="badge-status"
                                style="background:#e3f2fd;color:#0277bd;font-size:0.72rem;">
                            <%= sp.getFrequency().replace("_"," ") %>
                          </span>
                        </td>
                        <td style="font-size:0.78rem;">
                          <%= sp.getNextExecution() != null
                              ? sp.getNextExecution().format(fmt) : "—" %>
                        </td>
                        <td>
                          <span class="badge-status badge-<%= sp.getStatus().toLowerCase() %>">
                            <%= sp.getStatus() %>
                          </span>
                        </td>
                        <td>
                          <% if ("PENDING".equals(sp.getStatus())) { %>
                            <a href="${pageContext.request.contextPath}/customer/scheduled-payment?cancel=<%= sp.getId() %>"
                               class="btn-bank btn-danger-b"
                               style="width:auto;padding:3px 8px;font-size:0.75rem;
                                      text-decoration:none;display:inline-block;"
                               onclick="return confirm('Cancel this scheduled payment?')">
                              <i class="bi bi-x-circle"></i> Cancel
                            </a>
                          <% } else { %>
                            <span style="color:#6c757d;font-size:0.78rem;">—</span>
                          <% } %>
                        </td>
                      </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
            <% } %>
          </div>
        </div>
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
document.getElementById('schedForm').addEventListener('submit', function (e) {
  let ok = true;
  this.querySelectorAll('[required]').forEach(function (el) {
    if (!el.value.trim()) { el.classList.add('is-invalid'); ok = false; }
    else el.classList.remove('is-invalid');
  });
  const sd  = this.querySelector('[name="scheduledDate"]').value;
  const now = new Date();
  if (sd && new Date(sd) <= now) {
    alert('Scheduled date must be in the future.');
    ok = false;
  }
  if (!ok) e.preventDefault();
});
</script>
</body>
</html>