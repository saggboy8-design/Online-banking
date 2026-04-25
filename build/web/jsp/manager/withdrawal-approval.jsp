<%@page import="com.gojjam.bank.model.Withdrawal"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Withdrawal,java.util.List,
                 java.math.BigDecimal,java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Withdrawal Approvals";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
  List<Withdrawal> withdrawals = (List<Withdrawal>) request.getAttribute("withdrawals");
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
.wd-hero {
  background: linear-gradient(135deg, #1a3a6e, #7c3aed);
  border-radius: 16px; padding: 1.5rem 2rem; color: #fff;
  margin-bottom: 1.5rem; display: flex; align-items: center;
  justify-content: space-between; position: relative; overflow: hidden;
}
.wd-hero::before { content:''; position:absolute; width:200px; height:200px; border-radius:50%; background:rgba(255,255,255,0.05); right:-50px; top:-60px; }
.wd-hero h2 { font-size: 1.2rem; font-weight: 800; }
.wd-hero p  { font-size: 0.82rem; opacity: 0.7; margin-top: 4px; }

.cnt-pill { background:rgba(255,255,255,0.15); border:1px solid rgba(255,255,255,0.25); border-radius:14px; padding:0.8rem 1.5rem; text-align:center; position:relative; z-index:2; }
.cnt-pill .cn { font-size:2rem; font-weight:800; line-height:1; }
.cnt-pill .cl { font-size:0.72rem; opacity:0.8; }

.alrt { border-radius:10px; padding:0.9rem 1rem; margin-bottom:1.2rem; font-size:0.85rem; display:flex; align-items:flex-start; gap:8px; }
.alrt-warn { background:#fef3c7; border:1px solid #fde68a; border-left:4px solid #f59e0b; color:#92400e; }
.alrt-ok   { background:#f0fdf4; border:1px solid #bbf7d0; border-left:4px solid #10b981; color:#166534; }
.alrt-err  { background:#fef2f2; border:1px solid #fecaca; border-left:4px solid #ef4444; color:#991b1b; }

/* Withdrawal Cards */
.wd-card {
  background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.07);
  overflow: hidden; margin-bottom: 1.2rem; border: 1.5px solid #e2e8f0;
  transition: box-shadow 0.2s;
}
.wd-card:hover { box-shadow: 0 8px 32px rgba(0,0,0,0.12); }

.wd-card-head {
  padding: 1rem 1.5rem; display: flex; align-items: center;
  justify-content: space-between; gap: 1rem; border-bottom: 1px solid #f1f5f9;
  background: #f8fafc;
}
.wd-ref { font-size: 0.8rem; color: #94a3b8; font-weight: 600; }
.wd-method-badge {
  display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px;
  border-radius: 20px; font-size: 0.75rem; font-weight: 700;
  background: #f5f3ff; color: #7c3aed;
}
.wd-amount { font-size: 1.3rem; font-weight: 800; color: #0A1F44; }
.wd-amount small { font-size: 0.72rem; color: #94a3b8; font-weight: 400; }

.wd-card-body { padding: 1.2rem 1.5rem; }
.wd-info-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 0.8rem; }
.wi { }
.wi .wl { font-size:0.7rem; font-weight:700; color:#94a3b8; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:3px; }
.wi .wv { font-size:0.86rem; font-weight:600; color:#1e293b; }
.wi .wv code { background:#f1f5f9; padding:2px 6px; border-radius:6px; font-size:0.82rem; color:#7c3aed; }

/* Fee mini breakdown */
.fee-mini { background:#f8fafc; border-radius:10px; padding:0.8rem; display:flex; gap:0; margin-top:0.8rem; }
.fmi { flex:1; text-align:center; padding:0 0.5rem; border-right:1px solid #e2e8f0; }
.fmi:last-child { border-right:none; }
.fmi .fl { font-size:0.68rem; color:#94a3b8; font-weight:600; text-transform:uppercase; }
.fmi .fv { font-size:1rem; font-weight:800; color:#0A1F44; }
.fmi .fv.red { color:#ef4444; }
.fmi .fv.gold { color:#f59e0b; }

/* Actions */
.wd-actions { border-top:1px solid #f1f5f9; padding:1rem 1.5rem; display:flex; align-items:center; gap:0.8rem; flex-wrap:wrap; background:#fafafa; }
.btn-approve { display:inline-flex; align-items:center; gap:7px; background:linear-gradient(135deg,#10b981,#059669); color:#fff; border:none; border-radius:10px; padding:0.65rem 1.5rem; font-size:0.88rem; font-weight:700; cursor:pointer; font-family:inherit; transition:all 0.25s; }
.btn-approve:hover { transform:translateY(-2px); box-shadow:0 6px 18px rgba(16,185,129,0.35); }
.btn-rej-open { display:inline-flex; align-items:center; gap:7px; background:#fff; color:#ef4444; border:2px solid #fecaca; border-radius:10px; padding:0.63rem 1.4rem; font-size:0.88rem; font-weight:700; cursor:pointer; font-family:inherit; transition:all 0.25s; }
.btn-rej-open:hover { background:#fef2f2; border-color:#ef4444; transform:translateY(-2px); }
.sub-time { margin-left:auto; font-size:0.75rem; color:#94a3b8; display:flex; align-items:center; gap:5px; }

/* Reject panel */
.rej-panel { display:none; padding:1rem 1.5rem; border-top:2px dashed #fecaca; background:#fef2f2; }
.rej-panel.open { display:block; }
.rej-panel textarea { width:100%; border:1.5px solid #fecaca; border-radius:10px; padding:0.65rem 0.9rem; font-size:0.85rem; font-family:inherit; resize:vertical; outline:none; background:#fff; }
.rej-panel textarea:focus { border-color:#ef4444; box-shadow:0 0 0 3px rgba(239,68,68,0.1); }
.btn-conf-rej { display:inline-flex; align-items:center; gap:6px; background:#ef4444; color:#fff; border:none; border-radius:8px; padding:0.6rem 1.2rem; font-size:0.85rem; font-weight:700; cursor:pointer; font-family:inherit; margin-top:0.6rem; transition:all 0.2s; }
.btn-conf-rej:hover { background:#dc2626; }
.btn-cancel-rej { display:inline-flex; align-items:center; gap:6px; background:none; color:#94a3b8; border:none; padding:0.6rem 0.8rem; font-size:0.85rem; cursor:pointer; font-family:inherit; margin-top:0.6rem; margin-left:8px; }
.btn-cancel-rej:hover { color:#1e293b; }

.empty-state { padding:3rem; text-align:center; color:#94a3b8; background:#fff; border-radius:16px; box-shadow:0 2px 16px rgba(0,0,0,0.07); }
.empty-state i { font-size:3.5rem; color:#10b981; display:block; margin-bottom:1rem; }

@media(max-width:768px){ .wd-info-grid{grid-template-columns:1fr 1fr;} }
</style>

<div class="main-content">
  <header class="topbar" style="background:#fff;border-bottom:1px solid #e2e8f0;padding:0 1.5rem;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:900;">
    <div style="font-size:1rem;font-weight:800;color:#1a3a6e;">
      <i class="bi bi-cash-coin"></i> Withdrawal Approvals
    </div>
    <div style="display:flex;align-items:center;gap:8px;">
      <div style="width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,#1a3a6e,#7c3aed);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:0.85rem;"><%= initials %></div>
      <strong style="font-size:0.88rem;color:#1a3a6e;"><%= fullName %></strong>
    </div>
  </header>

  <div class="page-content">

    <% if (request.getAttribute("error") != null) { %>
      <div class="alrt alrt-err"><i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;"></i><div><%= request.getAttribute("error") %></div></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alrt alrt-ok"><i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;"></i><div><%= request.getAttribute("success") %></div></div>
    <% } %>

    <!-- Hero -->
    <div class="wd-hero">
      <div style="position:relative;z-index:2;">
        <h2><i class="bi bi-cash-stack"></i> Customer Withdrawal Requests</h2>
        <p>Approve or reject pending withdrawal requests. Funds are deducted only on approval.</p>
        <div style="margin-top:0.8rem;font-size:0.78rem;opacity:0.8;display:flex;gap:1.5rem;flex-wrap:wrap;">
          <span><i class="bi bi-check-circle-fill" style="color:#6ee7b7;"></i> Approve = Balance deducted immediately</span>
          <span><i class="bi bi-x-circle-fill" style="color:#fca5a5;"></i> Reject = No balance change</span>
        </div>
      </div>
      <div class="cnt-pill">
        <div class="cn"><%= withdrawals != null ? withdrawals.size() : 0 %></div>
        <div class="cl">Pending</div>
      </div>
    </div>

    <!-- Warning -->
    <div class="alrt alrt-warn">
      <i class="bi bi-shield-exclamation" style="flex-shrink:0;margin-top:1px;font-size:1.1rem;"></i>
      <div>
        <strong>Manager Policy:</strong>
        Customer balances are <strong>NOT</strong> deducted until you explicitly approve.
        On approval the system uses row-level database locking to atomically deduct the full amount + fee.
        Always verify the customer's identity and reason before approving large withdrawals.
      </div>
    </div>

    <% if (withdrawals == null || withdrawals.isEmpty()) { %>
      <div class="empty-state">
        <i class="bi bi-check-all"></i>
        <h3 style="color:#0A1F44;font-weight:800;margin-bottom:0.5rem;">All Clear!</h3>
        <p>No pending withdrawal requests to review.</p>
        <a href="${pageContext.request.contextPath}/manager/dashboard"
           style="display:inline-flex;align-items:center;gap:6px;margin-top:1rem;background:#1a3a6e;color:#fff;padding:0.6rem 1.5rem;border-radius:10px;text-decoration:none;font-weight:700;font-size:0.85rem;">
          <i class="bi bi-speedometer2"></i> Back to Dashboard
        </a>
      </div>
    <% } else { %>
      <% for (Withdrawal w : withdrawals) {
           BigDecimal total = w.getAmount().add(w.getFee());
      %>
        <div class="wd-card" id="wdCard<%= w.getId() %>">

          <!-- Card Header -->
          <div class="wd-card-head">
            <div>
              <div class="wd-ref">Withdrawal Request #<%= w.getId() %> · Ref: <%= w.getReferenceNumber() %></div>
              <div style="margin-top:4px;">
                <span class="wd-method-badge">
                  <i class="bi bi-<%= "BANK_COUNTER".equals(w.getWithdrawalMethod())?"building":"MOBILE_MONEY".equals(w.getWithdrawalMethod())?"phone":"credit-card" %>-fill"></i>
                  <%= w.getWithdrawalMethod().replace("_"," ") %>
                </span>
              </div>
            </div>
            <div style="text-align:right;">
              <div class="wd-amount">
                ETB <%= w.getAmount().toPlainString() %>
                <small>+ ETB <%= w.getFee().toPlainString() %> fee</small>
              </div>
              <div style="font-size:0.75rem;color:#94a3b8;margin-top:2px;">
                Account: <code style="background:#f1f5f9;padding:1px 6px;border-radius:4px;color:#7c3aed;">
                  <%= w.getAccountNumber() %>
                </code>
                &nbsp;·&nbsp;<strong style="color:#0A1F44;"><%= w.getOwnerName() %></strong>
              </div>
            </div>
          </div>

          <!-- Card Body -->
          <div class="wd-card-body">
            <div class="wd-info-grid">
              <div class="wi">
                <div class="wl"><i class="bi bi-person-fill"></i> Customer</div>
                <div class="wv"><%= w.getOwnerName() %></div>
              </div>
              <div class="wi">
                <div class="wl"><i class="bi bi-phone"></i> Phone</div>
                <div class="wv"><%= w.getOwnerPhone() != null ? w.getOwnerPhone() : "N/A" %></div>
              </div>
              <div class="wi">
                <div class="wl"><i class="bi bi-envelope"></i> Email</div>
                <div class="wv" style="font-size:0.8rem;"><%= w.getOwnerEmail() != null ? w.getOwnerEmail() : "N/A" %></div>
              </div>
              <div class="wi">
                <div class="wl"><i class="bi bi-chat-text"></i> Reason</div>
                <div class="wv" style="color:<%= (w.getReason()!=null&&!w.getReason().isBlank())?"#1e293b":"#94a3b8" %>;">
                  <%= (w.getReason()!=null&&!w.getReason().isBlank()) ? w.getReason() : "No reason provided" %>
                </div>
              </div>
            </div>

            <!-- Fee Breakdown -->
            <div class="fee-mini">
              <div class="fmi">
                <div class="fl">Requested Amount</div>
                <div class="fv">ETB <%= w.getAmount().toPlainString() %></div>
              </div>
              <div class="fmi">
                <div class="fl">Service Fee</div>
                <div class="fv gold">ETB <%= w.getFee().toPlainString() %></div>
              </div>
              <div class="fmi">
                <div class="fl">Total to Deduct</div>
                <div class="fv red">ETB <%= total.toPlainString() %></div>
              </div>
              <div class="fmi">
                <div class="fl">Method</div>
                <div class="fv" style="font-size:0.78rem;"><%= w.getWithdrawalMethod().replace("_"," ") %></div>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="wd-actions">
            <!-- Approve -->
            <form method="post"
                  action="${pageContext.request.contextPath}/manager/withdrawals"
                  style="display:inline;">
              <input type="hidden" name="csrfToken"      value="${csrfToken}"/>
              <input type="hidden" name="withdrawalId"   value="<%= w.getId() %>"/>
              <input type="hidden" name="action"         value="APPROVE"/>
              <input type="hidden" name="managerNote"    value="Approved by manager."/>
              <button type="submit" class="btn-approve"
                      onclick="return confirm('APPROVE withdrawal #<%= w.getId() %>?\n\nThis will deduct ETB <%= total.toPlainString() %> from <%= w.getOwnerName() %>\'s account immediately.\n\nThis action cannot be undone.')">
                <i class="bi bi-check-circle-fill"></i>
                Approve – Deduct ETB <%= total.toPlainString() %>
              </button>
            </form>

            <button type="button" class="btn-rej-open"
                    onclick="toggleRej(<%= w.getId() %>)">
              <i class="bi bi-x-circle-fill"></i>
              Reject Request
            </button>

            <div class="sub-time">
              <i class="bi bi-clock"></i>
              <%= w.getCreatedAt() != null ? w.getCreatedAt().format(fmt) : "N/A" %>
            </div>
          </div>

          <!-- Reject Panel -->
          <div class="rej-panel" id="rejPanel<%= w.getId() %>">
            <div style="font-size:0.85rem;font-weight:700;color:#dc2626;margin-bottom:0.6rem;">
              <i class="bi bi-x-circle-fill"></i> Reject Withdrawal #<%= w.getId() %> – Add Reason
            </div>
            <div style="font-size:0.78rem;color:#92400e;background:#fef3c7;border-radius:6px;padding:0.5rem 0.8rem;margin-bottom:0.6rem;">
              <i class="bi bi-info-circle"></i> No funds will be deducted. Customer balance stays unchanged.
            </div>
            <form method="post" action="${pageContext.request.contextPath}/manager/withdrawals">
              <input type="hidden" name="csrfToken"    value="${csrfToken}"/>
              <input type="hidden" name="withdrawalId" value="<%= w.getId() %>"/>
              <input type="hidden" name="action"       value="REJECT"/>
              <textarea name="managerNote" rows="3" required
                        placeholder="Reason for rejection (e.g. suspicious activity, incorrect details, account freeze)..."></textarea>
              <div>
                <button type="submit" class="btn-conf-rej">
                  <i class="bi bi-x-circle-fill"></i> Confirm Rejection
                </button>
                <button type="button" class="btn-cancel-rej" onclick="toggleRej(<%= w.getId() %>)">
                  <i class="bi bi-arrow-left"></i> Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      <% } %>
    <% } %>
  </div><!-- page-content -->
  <%@ include file="/jsp/includes/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function toggleRej(id) {
  const p = document.getElementById('rejPanel' + id);
  p.classList.toggle('open');
  if (p.classList.contains('open')) {
    p.scrollIntoView({ behavior:'smooth', block:'nearest' });
    p.querySelector('textarea').focus();
  }
}
</script>
</body>
</html>