<%@page import="com.gojjam.bank.model.Transaction"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Dashboard";
  Account account  = (Account) request.getAttribute("account");
  List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
  String fullName  = (String) session.getAttribute("fullName");
  String email     = (String) session.getAttribute("email");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
/* ── Dashboard-specific styles ── */
.topbar { position:sticky;top:0;z-index:900; }
.kpi-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:1rem; }

.balance-panel {
  background:linear-gradient(135deg,#0A1F44 0%,#1a3a6e 60%,#2563eb 100%);
  border-radius:18px; padding:2rem;
  color:#fff; position:relative; overflow:hidden;
  box-shadow:0 12px 40px rgba(10,31,68,0.35);
}
.balance-panel::before {
  content:'';position:absolute;width:220px;height:220px;border-radius:50%;
  background:rgba(255,255,255,0.05);top:-60px;right:-60px;
}
.balance-panel::after {
  content:'';position:absolute;width:140px;height:140px;border-radius:50%;
  background:rgba(245,158,11,0.1);bottom:-40px;left:20px;
}
.balance-chip {
  display:inline-flex;align-items:center;gap:6px;
  background:rgba(255,255,255,0.12);border-radius:20px;
  padding:4px 12px;font-size:0.72rem;font-weight:600;
  margin-bottom:1rem;letter-spacing:0.5px;
}
.balance-label { font-size:0.8rem;opacity:0.7;letter-spacing:0.5px; }
.balance-amount {
  font-size:2.6rem;font-weight:800;letter-spacing:1px;
  margin:0.3rem 0;line-height:1;
}
.balance-acc { font-size:0.82rem;opacity:0.65;margin-top:4px; }

.toggle-btn {
  display:inline-flex;align-items:center;gap:6px;
  background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.2);
  border-radius:8px;color:#fff;padding:6px 14px;
  font-size:0.8rem;cursor:pointer;border:none;margin-top:0.8rem;
  transition:all 0.2s;font-family:inherit;font-weight:600;
}
.toggle-btn:hover { background:rgba(255,255,255,0.22); }

.stmt-btn {
  display:inline-flex;align-items:center;gap:6px;
  background:rgba(245,158,11,0.25);border:1px solid rgba(245,158,11,0.4);
  border-radius:8px;color:#f59e0b;padding:6px 14px;
  font-size:0.8rem;cursor:pointer;margin-top:0.8rem;margin-left:8px;
  text-decoration:none;font-weight:600;transition:all 0.2s;
}
.stmt-btn:hover { background:rgba(245,158,11,0.4); }

/* KYC Badge */
.kyc-badge {
  position:absolute;top:1.2rem;right:1.2rem;z-index:2;
  display:inline-flex;align-items:center;gap:5px;
  background:rgba(16,185,129,0.2);border:1px solid rgba(16,185,129,0.4);
  border-radius:20px;padding:4px 12px;font-size:0.72rem;font-weight:700;color:#6ee7b7;
}
.kyc-badge.pending { background:rgba(245,158,11,0.2);border-color:rgba(245,158,11,0.4);color:#fcd34d; }

/* Quick Actions */
.quick-actions { display:grid;grid-template-columns:repeat(4,1fr);gap:1rem; }
.qa-card {
  background:#fff;border-radius:14px;padding:1.2rem;text-align:center;
  cursor:pointer;transition:all 0.25s;border:1.5px solid #e2e8f0;
  text-decoration:none;display:flex;flex-direction:column;align-items:center;gap:8px;
}
.qa-card:hover { transform:translateY(-4px);box-shadow:0 10px 28px rgba(10,31,68,0.14); border-color:#bfdbfe; }
.qa-icon {
  width:52px;height:52px;border-radius:14px;
  display:flex;align-items:center;justify-content:center;
  font-size:1.4rem;margin:0 auto;transition:transform 0.2s;
}
.qa-card:hover .qa-icon { transform:scale(1.1); }
.qa-label { font-size:0.82rem;font-weight:700;color:#0A1F44; }
.qa-sub   { font-size:0.72rem;color:#94a3b8; }

.qa-withdraw  .qa-icon { background:#fee2e2;color:#dc2626; }
.qa-transfer  .qa-icon { background:#dbeafe;color:#2563eb; }
.qa-bill      .qa-icon { background:#fef3c7;color:#d97706; }
.qa-loan      .qa-icon { background:#f3e8ff;color:#9333ea; }
.qa-schedule  .qa-icon { background:#fff1f2;color:#e11d48; }
.qa-complaint .qa-icon { background:#f0fdf4;color:#16a34a; }
.qa-history   .qa-icon { background:#e0f2fe;color:#0284c7; }
.qa-change    .qa-icon { background:#fdf4ff;color:#a21caf; }

/* Mini Stat Cards */
.mini-stat {
  background:#fff;border-radius:12px;padding:1.1rem;
  border-left:4px solid;box-shadow:0 2px 12px rgba(0,0,0,0.06);
  display:flex;align-items:center;gap:0.8rem;
  transition:all 0.2s;
}
.mini-stat:hover { transform:translateY(-2px);box-shadow:0 6px 20px rgba(0,0,0,0.1); }
.mini-stat .ms-icon {
  width:42px;height:42px;border-radius:10px;
  display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;
}
.mini-stat h4 { font-size:1.2rem;font-weight:800;color:#0A1F44;margin:0; }
.mini-stat p  { font-size:0.75rem;color:#94a3b8;margin:0; }

/* Transaction Table */
.tx-table-wrap { border-radius:12px;overflow:hidden; }
.tx-table { width:100%;border-collapse:collapse; }
.tx-table thead tr { background:#0A1F44;color:#fff; }
.tx-table th { padding:0.7rem 0.9rem;font-size:0.75rem;font-weight:700;text-transform:uppercase;letter-spacing:0.5px; }
.tx-table td { padding:0.7rem 0.9rem;font-size:0.84rem;border-bottom:1px solid #f1f5f9;vertical-align:middle; }
.tx-table tbody tr { transition:background 0.15s; }
.tx-table tbody tr:hover { background:#f8fafc; }
.tx-table tbody tr:last-child td { border-bottom:none; }

.tx-type-badge {
  display:inline-flex;align-items:center;gap:4px;
  padding:3px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;
}
.tx-credit { background:#dcfce7;color:#15803d; }
.tx-debit  { background:#fef2f2;color:#dc2626; }

/* Card wrapper */
.dash-card {
  background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,0.07);
  overflow:hidden;
}
.dash-card-head {
  background:#0A1F44;color:#fff;padding:0.9rem 1.2rem;
  font-weight:700;font-size:0.92rem;display:flex;align-items:center;gap:8px;
}
.dash-card-head a { margin-left:auto;color:rgba(255,255,255,0.75);font-size:0.78rem;text-decoration:none; }
.dash-card-head a:hover { color:#fff; }

/* Empty state */
.empty-state {
  padding:2.5rem;text-align:center;color:#94a3b8;
}
.empty-state i { font-size:3rem;display:block;margin-bottom:0.7rem; }

/* User greeting */
.greeting-text { font-size:1.4rem;font-weight:800;color:#0A1F44; }
.greeting-sub  { font-size:0.85rem;color:#94a3b8;margin-top:2px; }

/* Footer */
.dash-footer { background:#0A1F44; }

@media(max-width:768px){
  .quick-actions{grid-template-columns:repeat(2,1fr);}
  .balance-amount{font-size:1.8rem;}
}
</style>

<div class="main-content">

  <!-- Topbar -->
  <header class="topbar">
    <div style="display:flex;align-items:center;gap:10px;">
      <button onclick="document.getElementById('sidebar').classList.toggle('open')"
              style="background:none;border:none;font-size:1.2rem;cursor:pointer;color:#0A1F44;display:none;"
              id="menuToggle">
        <i class="bi bi-list"></i>
      </button>
      <div>
        <div class="greeting-text">Good day, <%= fullName != null ? fullName.split(" ")[0] : "Customer" %>! 👋</div>
        <div class="greeting-sub">
          <%= java.time.LocalDate.now().format(DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy")) %>
        </div>
      </div>
    </div>
    <div style="display:flex;align-items:center;gap:12px;">
      <a href="${pageContext.request.contextPath}/customer/transactions"
         style="background:#f1f5f9;border-radius:10px;padding:8px 12px;text-decoration:none;color:#0A1F44;font-size:0.82rem;font-weight:600;display:flex;align-items:center;gap:6px;">
        <i class="bi bi-list-columns-reverse"></i> History
      </a>
      <div style="display:flex;align-items:center;gap:8px;">
        <div style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#0A1F44,#2563eb);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:0.9rem;">
          <%= initials %>
        </div>
        <div style="display:none;" class="user-meta">
          <div style="font-size:0.82rem;font-weight:700;color:#0A1F44;"><%= fullName %></div>
          <div style="font-size:0.72rem;color:#94a3b8;"><%= email != null ? email : "" %></div>
        </div>
      </div>
    </div>
  </header>

  <div class="page-content">

    <% if (request.getAttribute("error") != null) { %>
      <div style="background:#fef2f2;border:1px solid #fecaca;border-left:4px solid #ef4444;
                  border-radius:10px;padding:12px 1rem;margin-bottom:1rem;
                  font-size:0.88rem;color:#991b1b;display:flex;gap:8px;align-items:center;">
        <i class="bi bi-exclamation-circle-fill"></i>
        <%= request.getAttribute("error") %>
      </div>
    <% } %>

    <% if (account == null) { %>
      <!-- KYC Pending State -->
      <div style="text-align:center;padding:3rem;background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,0.07);">
        <div style="font-size:4rem;margin-bottom:1rem;">⏳</div>
        <h2 style="color:#0A1F44;font-weight:800;margin-bottom:0.5rem;">Account Pending Approval</h2>
        <p style="color:#94a3b8;max-width:400px;margin:0 auto 1rem;">
          Your KYC verification is under review by our team. You will receive an email
          notification once your account is approved.
        </p>
        <div style="display:inline-flex;align-items:center;gap:6px;background:#fef3c7;border:1px solid #fde68a;border-radius:10px;padding:8px 16px;font-size:0.85rem;color:#92400e;font-weight:600;">
          <i class="bi bi-clock-history"></i> Awaiting manager review
        </div>
      </div>
    <% } else { %>

    <!-- ── Row 1: Balance + Quick Actions ── -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:1rem;">

      <!-- Balance Panel -->
      <div class="balance-panel">
        <div class="balance-chip">
          <i class="bi bi-wifi" style="font-size:0.65rem;"></i> Online Banking
        </div>
        <% if ("APPROVED".equals(account.getKycStatus())) { %>
          <div class="kyc-badge"><i class="bi bi-patch-check-fill"></i> Verified</div>
        <% } else { %>
          <div class="kyc-badge pending"><i class="bi bi-clock"></i> KYC Pending</div>
        <% } %>

        <div class="balance-label">TOTAL AVAILABLE BALANCE</div>
        <div class="balance-amount" id="balanceDisplay" data-balance="<%= account.getBalance().toPlainString() %>">
          ••••••••
        </div>
        <div class="balance-acc">
          <i class="bi bi-credit-card"></i>
          &nbsp;<%= account.getAccountNumber() %>
          &nbsp;|&nbsp; <%= account.getAccountType() %> Account
        </div>
        <div>
          <button class="toggle-btn" id="balanceToggle" onclick="toggleBalance()">
            <i class="bi bi-eye" id="toggleIcon"></i>
            <span id="toggleLabel">Show Balance</span>
          </button>
          <a href="${pageContext.request.contextPath}/customer/statement"
             class="stmt-btn">
            <i class="bi bi-file-earmark-arrow-down"></i> Statement
          </a>
        </div>
      </div>

      <!-- Mini Stats -->
      <div style="display:flex;flex-direction:column;gap:1rem;">
        <div class="mini-stat" style="border-color:#10b981;">
          <div class="ms-icon" style="background:#dcfce7;color:#16a34a;">
            <i class="bi bi-arrow-down-circle-fill"></i>
          </div>
          <div>
            <h4>ETB <%= account.getBalance().toPlainString() %></h4>
            <p>Current Balance</p>
          </div>
        </div>
        <div class="mini-stat" style="border-color:#2563eb;">
          <div class="ms-icon" style="background:#dbeafe;color:#2563eb;">
            <i class="bi bi-shield-check-fill"></i>
          </div>
          <div>
            <h4><%= account.getKycStatus() %></h4>
            <p>KYC Status</p>
          </div>
        </div>
        <div class="mini-stat" style="border-color:#f59e0b;">
          <div class="ms-icon" style="background:#fef3c7;color:#d97706;">
            <i class="bi bi-calendar-check"></i>
          </div>
          <div>
            <h4><%= account.getCreatedAt() != null
                    ? account.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "N/A" %></h4>
            <p>Account Opened</p>
          </div>
        </div>
      </div>
    </div>

    <!-- ── Row 2: Quick Actions (Deposit replaced with Withdraw) ── -->
    <div class="dash-card mb-3" style="margin-bottom:1rem;">
      <div class="dash-card-head">
        <i class="bi bi-lightning-charge-fill"></i> Quick Actions
      </div>
      <div style="padding:1.2rem;">
        <div class="quick-actions">
          <!-- WITHDRAW button - replaced Deposit -->
          <a href="${pageContext.request.contextPath}/customer/withdraw"
             class="qa-card qa-withdraw">
            <div class="qa-icon"><i class="bi bi-arrow-up-circle-fill"></i></div>
            <div class="qa-label">Withdraw</div>
            <div class="qa-sub">Cash out</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/transfer"
             class="qa-card qa-transfer">
            <div class="qa-icon"><i class="bi bi-arrow-left-right"></i></div>
            <div class="qa-label">Transfer</div>
            <div class="qa-sub">Send money</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/bill-payment"
             class="qa-card qa-bill">
            <div class="qa-icon"><i class="bi bi-receipt-cutoff"></i></div>
            <div class="qa-label">Pay Bills</div>
            <div class="qa-sub">Utilities & more</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/loan"
             class="qa-card qa-loan">
            <div class="qa-icon"><i class="bi bi-bank2"></i></div>
            <div class="qa-label">Loan</div>
            <div class="qa-sub">Apply now</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/scheduled-payment"
             class="qa-card qa-schedule">
            <div class="qa-icon"><i class="bi bi-calendar-check-fill"></i></div>
            <div class="qa-label">Schedule</div>
            <div class="qa-sub">Auto payments</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/complaint"
             class="qa-card qa-complaint">
            <div class="qa-icon"><i class="bi bi-chat-dots-fill"></i></div>
            <div class="qa-label">Support</div>
            <div class="qa-sub">Get help</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/transactions"
             class="qa-card qa-history">
            <div class="qa-icon"><i class="bi bi-clock-history"></i></div>
            <div class="qa-label">History</div>
            <div class="qa-sub">View all</div>
          </a>
          <a href="${pageContext.request.contextPath}/customer/change-password"
             class="qa-card qa-change">
            <div class="qa-icon"><i class="bi bi-key-fill"></i></div>
            <div class="qa-label">Security</div>
            <div class="qa-sub">Change password</div>
          </a>
        </div>
      </div>
    </div>

    <!-- ── Row 3: Recent Transactions ── -->
    <div class="dash-card">
      <div class="dash-card-head">
        <i class="bi bi-clock-history"></i> Recent Transactions
        <span style="background:rgba(255,255,255,0.15);padding:2px 10px;border-radius:12px;font-size:0.72rem;margin-left:8px;">
          Last 5
        </span>
        <a href="${pageContext.request.contextPath}/customer/transactions">
          View All <i class="bi bi-arrow-right"></i>
        </a>
      </div>
      <% if (transactions == null || transactions.isEmpty()) { %>
        <div class="empty-state">
          <i class="bi bi-inbox"></i>
          <p>No transactions yet. Make your first withdrawal or transfer to get started!</p>
          <a href="${pageContext.request.contextPath}/customer/withdraw"
             style="display:inline-block;margin-top:0.8rem;padding:8px 20px;
                    background:#0A1F44;color:#fff;border-radius:8px;text-decoration:none;
                    font-size:0.85rem;font-weight:700;">
            <i class="bi bi-arrow-up-circle"></i> Withdraw Funds
          </a>
        </div>
      <% } else { %>
        <div class="tx-table-wrap">
          <table class="tx-table">
            <thead>
              <tr>
                <th>Reference</th><th>Type</th>
                <th>Amount (ETB)</th><th>Balance After</th>
                <th>Status</th><th>Date</th>
              </tr>
            </thead>
            <tbody>
              <% for (Transaction tx : transactions) {
                   String t = tx.getTransactionType();
                   boolean credit = "TRANSFER_IN".equals(t)||"DEPOSIT".equals(t)||"LOAN_CREDIT".equals(t);
              %>
                <tr>
                  <td>
                    <code style="font-size:0.75rem;background:#f1f5f9;padding:2px 6px;border-radius:4px;">
                      <%= tx.getReferenceNumber() != null ? tx.getReferenceNumber().substring(0,Math.min(12,tx.getReferenceNumber().length()))+"..." : "#"+tx.getId() %>
                    </code>
                   </td>
                  <td>
                    <span class="tx-type-badge <%= credit?"tx-credit":"tx-debit" %>">
                      <i class="bi <%= credit?"bi-arrow-down":"bi-arrow-up" %>"></i>
                      <%= t.replace("_"," ") %>
                    </span>
                   </td>
                  <td style="font-weight:700;color:<%= credit?"#16a34a":"#dc2626" %>;">
                    <%= credit?"+":"−" %> ETB <%= tx.getAmount().toPlainString() %>
                   </td>
                  <td style="font-size:0.82rem;color:#475569;">
                    ETB <%= tx.getBalanceAfter().toPlainString() %>
                   </td>
                  <td>
                    <span style="display:inline-flex;align-items:center;gap:4px;
                          padding:3px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;
                          background:<%= "SUCCESS".equals(tx.getStatus())?"#dcfce7":"FAILED".equals(tx.getStatus())?"#fef2f2":"#fef3c7" %>;
                          color:<%= "SUCCESS".equals(tx.getStatus())?"#15803d":"FAILED".equals(tx.getStatus())?"#dc2626":"#92400e" %>;">
                      <i class="bi bi-<%= "SUCCESS".equals(tx.getStatus())?"check":"x" %>-circle-fill"
                         style="font-size:0.65rem;"></i>
                      <%= tx.getStatus() %>
                    </span>
                   </td>
                  <td style="font-size:0.78rem;color:#94a3b8;white-space:nowrap;">
                    <%= tx.getCreatedAt() != null ? tx.getCreatedAt().format(fmt) : "" %>
                   </td>
                 </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>
    <% } %>
  </div><!-- page-content -->

  <!-- ── FOOTER ── -->
  <%@ include file="/jsp/includes/footer.jsp" %>

</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
let balanceShown = false;
const rawBalance = document.getElementById('balanceDisplay')?.getAttribute('data-balance') || '0';

function toggleBalance() {
  balanceShown = !balanceShown;
  const disp  = document.getElementById('balanceDisplay');
  const icon  = document.getElementById('toggleIcon');
  const label = document.getElementById('toggleLabel');
  if (disp) {
    if (balanceShown) {
      disp.textContent  = 'ETB ' + parseFloat(rawBalance).toLocaleString('en-ET',{minimumFractionDigits:2,maximumFractionDigits:2});
      icon.className    = 'bi bi-eye-slash';
      label.textContent = 'Hide Balance';
    } else {
      disp.textContent  = '••••••••';
      icon.className    = 'bi bi-eye';
      label.textContent = 'Show Balance';
    }
  }
}
</script>
</body>
</html>
