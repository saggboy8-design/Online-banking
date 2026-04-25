<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Manager Dashboard";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
  List<Deposit> pendingDeposits = (List<Deposit>) request.getAttribute("pendingDeposits");
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
/* Manager Dashboard Styles */
.mgr-topbar {
  background:#fff;border-bottom:1px solid #e2e8f0;
  padding:0 1.5rem;height:64px;
  display:flex;align-items:center;justify-content:space-between;
  position:sticky;top:0;z-index:900;
  box-shadow:0 2px 8px rgba(0,0,0,0.05);
}

.hero-bar {
  background:linear-gradient(135deg,#1a3a6e 0%,#2d5a9e 60%,#1e40af 100%);
  border-radius:16px;padding:1.8rem 2rem;color:#fff;
  display:flex;align-items:center;justify-content:space-between;
  position:relative;overflow:hidden;margin-bottom:1rem;
}
.hero-bar::before {
  content:'';position:absolute;width:200px;height:200px;border-radius:50%;
  background:rgba(255,255,255,0.05);right:-50px;top:-50px;
}
.hero-greeting h2 { font-size:1.4rem;font-weight:800;margin-bottom:4px; }
.hero-greeting p  { font-size:0.85rem;opacity:0.7; }
.hero-date {
  background:rgba(255,255,255,0.1);border-radius:10px;
  padding:0.6rem 1rem;font-size:0.82rem;text-align:right;opacity:0.9;
}

/* Metric Cards */
.metrics-grid {
  display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1rem;
}
.metric-card {
  background:#fff;border-radius:14px;padding:1.2rem;
  box-shadow:0 2px 12px rgba(0,0,0,0.07);
  display:flex;align-items:center;gap:1rem;
  border-left:4px solid;cursor:pointer;transition:all 0.2s;text-decoration:none;
}
.metric-card:hover { transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,0.12); }
.metric-icon {
  width:50px;height:50px;border-radius:12px;
  display:flex;align-items:center;justify-content:center;font-size:1.3rem;flex-shrink:0;
}
.metric-val  { font-size:1.8rem;font-weight:800;color:#0A1F44;line-height:1; }
.metric-lbl  { font-size:0.75rem;color:#94a3b8;margin-top:2px;font-weight:500; }
.metric-badge {
  margin-left:auto;font-size:0.68rem;font-weight:700;
  padding:3px 8px;border-radius:10px;white-space:nowrap;
}

.mc-kyc  { border-color:#f59e0b; }
.mc-kyc  .metric-icon { background:#fef3c7;color:#d97706; }
.mc-loan { border-color:#8b5cf6; }
.mc-loan .metric-icon { background:#f5f3ff;color:#7c3aed; }
.mc-comp { border-color:#ef4444; }
.mc-comp .metric-icon { background:#fef2f2;color:#dc2626; }
.mc-dep  { border-color:#10b981; }
.mc-dep  .metric-icon { background:#dcfce7;color:#059669; }

/* Quick Actions */
.mgr-actions {
  display:grid;grid-template-columns:repeat(3,1fr);gap:0.8rem;margin-bottom:1rem;
}
.mgr-action-btn {
  display:flex;align-items:center;gap:10px;
  background:#fff;border-radius:12px;padding:0.9rem 1.2rem;
  text-decoration:none;color:#0A1F44;font-weight:700;font-size:0.85rem;
  box-shadow:0 2px 8px rgba(0,0,0,0.06);border:1.5px solid #e2e8f0;
  transition:all 0.2s;
}
.mgr-action-btn:hover {
  border-color:#bfdbfe;background:#eff6ff;
  transform:translateY(-2px);box-shadow:0 6px 16px rgba(37,99,235,0.12);
}
.mgr-action-btn .ab-icon {
  width:36px;height:36px;border-radius:10px;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;font-size:1rem;
}
.ab-count {
  margin-left:auto;font-size:0.72rem;font-weight:800;
  padding:2px 8px;border-radius:10px;
}

/* Table */
.mgr-card { background:#fff;border-radius:14px;box-shadow:0 2px 12px rgba(0,0,0,0.07);overflow:hidden; }
.mgr-card-head {
  background:#1a3a6e;color:#fff;padding:1rem 1.2rem;
  font-weight:700;font-size:0.92rem;display:flex;align-items:center;gap:8px;
}
.mgr-card-head a { margin-left:auto;color:rgba(255,255,255,0.75);font-size:0.78rem;text-decoration:none; }
.mgr-card-head a:hover { color:#fff; }

.data-table { width:100%;border-collapse:collapse; }
.data-table thead tr { background:#f8fafc; }
.data-table th { padding:0.65rem 0.9rem;font-size:0.75rem;font-weight:700;color:#94a3b8;text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #f1f5f9; }
.data-table td { padding:0.7rem 0.9rem;font-size:0.85rem;border-bottom:1px solid #f8fafc;vertical-align:middle; }
.data-table tbody tr:hover { background:#f8fafc; }
.data-table tbody tr:last-child td { border-bottom:none; }

.act-approve {
  display:inline-flex;align-items:center;gap:4px;
  background:#dcfce7;color:#15803d;border:none;border-radius:6px;
  padding:4px 10px;font-size:0.75rem;font-weight:700;cursor:pointer;
  text-decoration:none;transition:all 0.2s;
}
.act-approve:hover { background:#16a34a;color:#fff; }
.act-reject {
  display:inline-flex;align-items:center;gap:4px;
  background:#fef2f2;color:#dc2626;border:none;border-radius:6px;
  padding:4px 10px;font-size:0.75rem;font-weight:700;cursor:pointer;
  text-decoration:none;transition:all 0.2s;margin-left:4px;
}
.act-reject:hover { background:#dc2626;color:#fff; }

@media(max-width:900px){
  .metrics-grid{grid-template-columns:repeat(2,1fr);}
  .mgr-actions{grid-template-columns:1fr 1fr;}
}
</style>

<div class="main-content">

  <!-- Topbar -->
  <header class="mgr-topbar">
    <div style="display:flex;align-items:center;gap:10px;">
      <div style="font-size:1rem;font-weight:800;color:#1a3a6e;">Manager Portal</div>
    </div>
    <div style="display:flex;align-items:center;gap:12px;">
      <a href="${pageContext.request.contextPath}/manager/audit-logs"
         style="background:#f1f5f9;border-radius:8px;padding:6px 12px;text-decoration:none;
                color:#1a3a6e;font-size:0.8rem;font-weight:600;">
        <i class="bi bi-journal-text"></i> Audit Logs
      </a>
      <div style="display:flex;align-items:center;gap:8px;">
        <div style="width:36px;height:36px;border-radius:50%;
                    background:linear-gradient(135deg,#1a3a6e,#2563eb);
                    color:#fff;display:flex;align-items:center;justify-content:center;
                    font-weight:800;font-size:0.85rem;">
          <%= initials %>
        </div>
        <div>
          <div style="font-size:0.82rem;font-weight:700;color:#1a3a6e;"><%= fullName %></div>
          <div style="font-size:0.7rem;color:#94a3b8;">Branch Manager</div>
        </div>
      </div>
    </div>
  </header>

  <div class="page-content">

    <!-- Hero Bar -->
    <div class="hero-bar">
      <div class="hero-greeting">
        <h2>Welcome back, <%= fullName != null ? fullName.split(" ")[0] : "Manager" %>! 🏦</h2>
        <p>Here's what needs your attention today</p>
      </div>
      <div class="hero-date">
        <div style="font-weight:700;font-size:0.9rem;">
          <%= java.time.LocalDate.now().format(DateTimeFormatter.ofPattern("EEEE")) %>
        </div>
        <div><%= java.time.LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMMM yyyy")) %></div>
      </div>
    </div>

    <!-- Metric Cards -->
    <div class="metrics-grid">
      <a href="${pageContext.request.contextPath}/manager/kyc" class="metric-card mc-kyc">
        <div class="metric-icon"><i class="bi bi-person-check-fill"></i></div>
        <div>
          <div class="metric-val"><%= request.getAttribute("pendingKycCount") %></div>
          <div class="metric-lbl">Pending KYC</div>
        </div>
        <span class="metric-badge" style="background:#fef3c7;color:#92400e;">Review</span>
      </a>
      <a href="${pageContext.request.contextPath}/manager/loans" class="metric-card mc-loan">
        <div class="metric-icon"><i class="bi bi-bank2"></i></div>
        <div>
          <div class="metric-val"><%= request.getAttribute("pendingLoanCount") %></div>
          <div class="metric-lbl">Loan Requests</div>
        </div>
        <span class="metric-badge" style="background:#f5f3ff;color:#6d28d9;">Approve</span>
      </a>
      <a href="${pageContext.request.contextPath}/manager/complaints" class="metric-card mc-comp">
        <div class="metric-icon"><i class="bi bi-chat-dots-fill"></i></div>
        <div>
          <div class="metric-val"><%= request.getAttribute("openComplaintCount") %></div>
          <div class="metric-lbl">Open Complaints</div>
        </div>
        <span class="metric-badge" style="background:#fef2f2;color:#dc2626;">Respond</span>
      </a>
      <a href="${pageContext.request.contextPath}/manager/external-transfers" class="metric-card mc-dep">
        <div class="metric-icon"><i class="bi bi-arrow-down-circle-fill"></i></div>
        <div>
          <div class="metric-val"><%= pendingDeposits != null ? pendingDeposits.size() : 0 %></div>
          <div class="metric-lbl">Pending Deposits</div>
        </div>
        <span class="metric-badge" style="background:#dcfce7;color:#15803d;">Verify</span>
      </a>
    </div>

    <!-- Quick Action Buttons -->
    <div class="mgr-actions">
      <a href="${pageContext.request.contextPath}/manager/kyc" class="mgr-action-btn">
        <div class="ab-icon" style="background:#fef3c7;color:#d97706;">
          <i class="bi bi-person-badge"></i>
        </div>
        KYC Approvals
        <span class="ab-count" style="background:#fef3c7;color:#92400e;">
          <%= request.getAttribute("pendingKycCount") %>
        </span>
      </a>
      <a href="${pageContext.request.contextPath}/manager/loans" class="mgr-action-btn">
        <div class="ab-icon" style="background:#f5f3ff;color:#7c3aed;">
          <i class="bi bi-bank2"></i>
        </div>
        Loan Approvals
        <span class="ab-count" style="background:#f5f3ff;color:#6d28d9;">
          <%= request.getAttribute("pendingLoanCount") %>
        </span>
      </a>
      <a href="${pageContext.request.contextPath}/manager/deposit" class="mgr-action-btn">
        <div class="ab-icon" style="background:#dcfce7;color:#059669;">
          <i class="bi bi-plus-circle-fill"></i>
        </div>
        Make Deposit
        <span class="ab-count" style="background:#dcfce7;color:#059669;">New</span>
      </a>
      <a href="${pageContext.request.contextPath}/manager/update-balance" class="mgr-action-btn">
        <div class="ab-icon" style="background:#dbeafe;color:#2563eb;">
          <i class="bi bi-pencil-square"></i>
        </div>
        Update Balance
      </a>
      <a href="${pageContext.request.contextPath}/manager/unlock" class="mgr-action-btn">
        <div class="ab-icon" style="background:#fff1f2;color:#e11d48;">
          <i class="bi bi-unlock-fill"></i>
        </div>
        Unlock Accounts
      </a>
      <a href="${pageContext.request.contextPath}/manager/transactions" class="mgr-action-btn">
        <div class="ab-icon" style="background:#f0fdf4;color:#16a34a;">
          <i class="bi bi-table"></i>
        </div>
        All Transactions
      </a>
    </div>

    <!-- Pending Deposits Table -->
    <div class="mgr-card">
      <div class="mgr-card-head">
        <i class="bi bi-hourglass-split"></i>
        Pending Deposit Approvals
        <span style="background:rgba(255,255,255,0.15);padding:2px 10px;border-radius:12px;font-size:0.72rem;margin-left:8px;">
          <%= pendingDeposits != null ? pendingDeposits.size() : 0 %> waiting
        </span>
        <a href="${pageContext.request.contextPath}/manager/external-transfers">
          View All <i class="bi bi-arrow-right"></i>
        </a>
      </div>
      <% if (pendingDeposits == null || pendingDeposits.isEmpty()) { %>
        <div style="padding:2.5rem;text-align:center;color:#94a3b8;">
          <i class="bi bi-check-circle-fill" style="font-size:3rem;color:#10b981;display:block;margin-bottom:0.7rem;"></i>
          <strong>All caught up!</strong> No pending deposits require your review.
        </div>
      <% } else { %>
        <div style="overflow-x:auto;">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th><th>Account</th><th>Customer</th>
                <th>Type</th><th>Amount (ETB)</th><th>Submitted</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% for (Deposit d : pendingDeposits) { %>
                <tr>
                  <td><code style="font-size:0.78rem;background:#f1f5f9;padding:2px 6px;border-radius:4px;">#<%= d.getId() %></code></td>
                  <td><code style="font-size:0.82rem;color:#2563eb;"><%= d.getAccountNumber() %></code></td>
                  <td><strong><%= d.getOwnerName() %></strong></td>
                  <td>
                    <span style="background:#e0f2fe;color:#0277bd;padding:3px 10px;border-radius:12px;font-size:0.72rem;font-weight:700;">
                      <%= d.getDepositType() %>
                    </span>
                  </td>
                  <td>
                    <strong style="color:#0A1F44;font-size:0.95rem;">
                      ETB <%= d.getAmount().toPlainString() %>
                    </strong>
                  </td>
                  <td style="font-size:0.78rem;color:#94a3b8;">
                    <%= d.getCreatedAt() != null ? d.getCreatedAt().format(fmt) : "" %>
                  </td>
                  <td>
                    <a href="${pageContext.request.contextPath}/manager/external-transfers"
                       class="act-approve">
                      <i class="bi bi-eye"></i> Review
                    </a>
                  </td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>

  </div><!-- page-content -->

  <%@ include file="/jsp/includes/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>