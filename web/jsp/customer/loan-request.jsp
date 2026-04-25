<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Loan,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Loan Request";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
    List<Loan> loans = (List<Loan>) request.getAttribute("loans");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-bank"></i> Loan Request</div>
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

      <!-- Application Form -->
      <div class="col-md-5">
        <div class="bank-card h-100">
          <div class="bank-card-header">
            <i class="bi bi-file-earmark-plus"></i> Apply for a Loan
          </div>
          <div class="bank-card-body">
            <div class="alert-bank alert-info" style="font-size:0.83rem;">
              <i class="bi bi-info-circle"></i>
              Interest rate: <strong>12.50% per annum</strong> (set by admin).
              EMI is auto-calculated on approval.
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/customer/loan"
                  id="loanForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>

              <div class="mb-3">
                <label class="form-label">
                  Loan Amount (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="amount" id="loanAmount"
                       class="form-control" min="1000" max="2000000"
                       step="100" placeholder="50000.00" required/>
                <small style="color:#6c757d;font-size:0.78rem;">
                  Minimum: ETB 1,000 | Maximum: ETB 2,000,000
                </small>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Duration (Months) <span class="required-star">*</span>
                </label>
                <select name="duration" id="loanDuration"
                        class="form-select" required>
                  <option value="">-- Select Duration --</option>
                  <option value="6">6 Months</option>
                  <option value="12">12 Months (1 Year)</option>
                  <option value="24">24 Months (2 Years)</option>
                  <option value="36">36 Months (3 Years)</option>
                  <option value="48">48 Months (4 Years)</option>
                  <option value="60">60 Months (5 Years)</option>
                  <option value="84">84 Months (7 Years)</option>
                  <option value="120">120 Months (10 Years)</option>
                </select>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Loan Purpose <span class="required-star">*</span>
                </label>
                <textarea name="purpose" class="form-control" rows="3"
                          maxlength="500" required
                          placeholder="Describe the purpose of this loan..."></textarea>
              </div>

              <!-- Live EMI Estimate -->
              <div id="emiEstimate" style="display:none;background:#f4f6f9;
                   border-radius:8px;padding:0.8rem;margin-bottom:1rem;
                   border-left:3px solid #0A1F44;">
                <div style="font-size:0.82rem;color:#6c757d;">Estimated Monthly EMI</div>
                <div id="emiAmount" style="font-size:1.4rem;font-weight:700;color:#0A1F44;">ETB 0.00</div>
                <div id="totalPayable" style="font-size:0.82rem;color:#6c757d;">Total payable: ETB 0.00</div>
              </div>

              <button type="submit" class="btn-bank">
                <i class="bi bi-send"></i> Submit Loan Application
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- Loan History -->
      <div class="col-md-7">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-clock-history"></i> My Loan Applications
          </div>
          <div class="bank-card-body" style="padding:0;">
            <% if (loans == null || loans.isEmpty()) { %>
              <div style="padding:2rem;text-align:center;color:#6c757d;">
                <i class="bi bi-inbox" style="font-size:2.5rem;"></i>
                <p style="margin-top:0.5rem;">No loan applications yet.</p>
              </div>
            <% } else { %>
              <div class="table-responsive">
                <table class="bank-table">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Amount (ETB)</th>
                      <th>Duration</th>
                      <th>EMI (ETB)</th>
                      <th>Status</th>
                      <th>Date</th>
                      <th>PDF</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (Loan loan : loans) { %>
                      <tr>
                        <td><%= loan.getId() %></td>
                        <td><strong><%= loan.getAmount().toPlainString() %></strong></td>
                        <td><%= loan.getDurationMonths() %> mo.</td>
                        <td>
                          <% if (loan.getMonthlyEmi() != null) { %>
                            ETB <%= loan.getMonthlyEmi().toPlainString() %>
                          <% } else { %>
                            <span style="color:#6c757d;">Pending</span>
                          <% } %>
                        </td>
                        <td>
                          <span class="badge-status badge-<%= loan.getStatus().toLowerCase() %>">
                            <%= loan.getStatus() %>
                          </span>
                        </td>
                        <td style="font-size:0.82rem;">
                          <%= loan.getCreatedAt() != null
                              ? loan.getCreatedAt().format(fmt) : "" %>
                        </td>
                        <td>
                          <% if ("APPROVED".equals(loan.getStatus())
                              || "DISBURSED".equals(loan.getStatus())) { %>
                            <a href="${pageContext.request.contextPath}/customer/loan?download=<%= loan.getId() %>"
                               style="color:#0A1F44;font-size:0.82rem;text-decoration:none;">
                              <i class="bi bi-file-pdf"></i> Schedule
                            </a>
                          <% } else { %>
                            <span style="color:#6c757d;font-size:0.78rem;">—</span>
                          <% } %>
                        </td>
                      </tr>
                      <% if (loan.getRejectionReason() != null
                             && !loan.getRejectionReason().isBlank()) { %>
                        <tr>
                          <td colspan="7"
                              style="background:#fff3cd;font-size:0.8rem;color:#856404;padding:0.4rem 0.9rem;">
                            <i class="bi bi-info-circle"></i>
                            <strong>Rejection Reason:</strong> <%= loan.getRejectionReason() %>
                          </td>
                        </tr>
                      <% } %>
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
/* Live EMI estimator */
function calcEmi() {
  const P = parseFloat(document.getElementById('loanAmount').value)   || 0;
  const n = parseInt(document.getElementById('loanDuration').value)   || 0;
  const r = 12.50 / 100 / 12;
  const box = document.getElementById('emiEstimate');
  if (P <= 0 || n <= 0) { box.style.display='none'; return; }
  const power = Math.pow(1 + r, n);
  const emi   = P * r * power / (power - 1);
  const total = emi * n;
  document.getElementById('emiAmount').textContent    = 'ETB ' + emi.toFixed(2);
  document.getElementById('totalPayable').textContent = 'Total payable: ETB ' + total.toFixed(2);
  box.style.display = 'block';
}
document.getElementById('loanAmount')  ?.addEventListener('input',  calcEmi);
document.getElementById('loanDuration')?.addEventListener('change', calcEmi);

document.getElementById('loanForm').addEventListener('submit', function (e) {
  let ok = true;
  this.querySelectorAll('[required]').forEach(function (el) {
    if (!el.value.trim()) { el.classList.add('is-invalid'); ok = false; }
    else el.classList.remove('is-invalid');
  });
  if (!ok) e.preventDefault();
});
</script>
</body>
</html>