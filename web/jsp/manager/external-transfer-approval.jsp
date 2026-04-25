<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Transfer,java.util.List,
                 java.time.format.DateTimeFormatter,java.math.BigDecimal" %>
<%
  String pageTitle = "External Transfer Approvals";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
  List<Transfer> transfers = (List<Transfer>) request.getAttribute("transfers");
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
/* ── Transfer Approval Page ── */
.appr-hero {
  background: linear-gradient(135deg, #1a3a6e, #2563eb);
  border-radius: 16px; padding: 1.5rem 2rem; color: #fff;
  margin-bottom: 1.5rem; display: flex; align-items: center;
  justify-content: space-between; position: relative; overflow: hidden;
}
.appr-hero::before {
  content: ''; position: absolute; width: 200px; height: 200px;
  border-radius: 50%; background: rgba(255,255,255,0.05); right: -50px; top: -60px;
}
.appr-hero h2 { font-size: 1.2rem; font-weight: 800; margin-bottom: 4px; }
.appr-hero p  { font-size: 0.82rem; opacity: 0.7; }

.count-badge {
  background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.25);
  border-radius: 14px; padding: 0.8rem 1.5rem; text-align: center;
  position: relative; z-index: 2;
}
.count-badge .cb-num { font-size: 2.2rem; font-weight: 800; line-height: 1; }
.count-badge .cb-lbl { font-size: 0.72rem; opacity: 0.8; }

/* Alert */
.alrt {
  border-radius: 10px; padding: 0.9rem 1rem; margin-bottom: 1.2rem;
  font-size: 0.85rem; display: flex; align-items: flex-start; gap: 8px;
}
.alrt-warn { background: #fef3c7; border: 1px solid #fde68a; border-left: 4px solid #f59e0b; color: #92400e; }
.alrt-ok   { background: #f0fdf4; border: 1px solid #bbf7d0; border-left: 4px solid #10b981; color: #166534; }
.alrt-err  { background: #fef2f2; border: 1px solid #fecaca; border-left: 4px solid #ef4444; color: #991b1b; }

/* Transfer Card */
.tr-card {
  background: #fff; border-radius: 16px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.07);
  overflow: hidden; margin-bottom: 1.2rem;
  border: 1.5px solid #e2e8f0; transition: box-shadow 0.2s;
}
.tr-card:hover { box-shadow: 0 8px 32px rgba(0,0,0,0.12); }

.tr-card-head {
  padding: 1rem 1.5rem; display: flex; align-items: center;
  justify-content: space-between; gap: 1rem;
  border-bottom: 1px solid #f1f5f9; background: #f8fafc;
}
.tr-id { font-size: 0.8rem; color: #94a3b8; font-weight: 600; }
.tr-type-badge {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700;
}
.type-ext  { background: #dbeafe; color: #1d4ed8; }
.type-intl { background: #fdf4ff; color: #9333ea; }
.tr-amount { font-size: 1.3rem; font-weight: 800; color: #0A1F44; }
.tr-amount small { font-size: 0.72rem; color: #94a3b8; font-weight: 400; }

.tr-card-body { padding: 1.2rem 1.5rem; }
.tr-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 0.8rem; }
.tr-field { }
.tr-field .tf-label {
  font-size: 0.7rem; font-weight: 700; color: #94a3b8; text-transform: uppercase;
  letter-spacing: 0.5px; margin-bottom: 3px;
}
.tr-field .tf-value { font-size: 0.86rem; font-weight: 600; color: #1e293b; }
.tr-field .tf-value code {
  background: #f1f5f9; padding: 2px 8px; border-radius: 6px;
  font-size: 0.82rem; color: #2563eb;
}

/* Fee breakdown in card */
.fee-mini {
  background: #f8fafc; border-radius: 10px; padding: 0.8rem;
  display: flex; gap: 0; margin-top: 0.8rem;
}
.fee-mini-item {
  flex: 1; text-align: center; padding: 0 0.5rem;
  border-right: 1px solid #e2e8f0;
}
.fee-mini-item:last-child { border-right: none; }
.fmi-label { font-size: 0.68rem; color: #94a3b8; font-weight: 600; text-transform: uppercase; }
.fmi-val   { font-size: 1rem; font-weight: 800; color: #0A1F44; }
.fmi-val.total { color: #ef4444; }
.fmi-val.fee   { color: #f59e0b; }

/* Action Bar */
.tr-actions {
  border-top: 1px solid #f1f5f9; padding: 1rem 1.5rem;
  display: flex; align-items: center; gap: 0.8rem; flex-wrap: wrap; background: #fafafa;
}
.btn-approve {
  display: inline-flex; align-items: center; gap: 7px;
  background: linear-gradient(135deg, #10b981, #059669);
  color: #fff; border: none; border-radius: 10px;
  padding: 0.65rem 1.5rem; font-size: 0.88rem; font-weight: 700;
  cursor: pointer; font-family: inherit; transition: all 0.25s;
}
.btn-approve:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(16,185,129,0.35); }

.btn-reject-open {
  display: inline-flex; align-items: center; gap: 7px;
  background: #fff; color: #ef4444; border: 2px solid #fecaca;
  border-radius: 10px; padding: 0.63rem 1.4rem;
  font-size: 0.88rem; font-weight: 700; cursor: pointer;
  font-family: inherit; transition: all 0.25s;
}
.btn-reject-open:hover { background: #fef2f2; border-color: #ef4444; transform: translateY(-2px); }

.submit-time {
  margin-left: auto; font-size: 0.75rem; color: #94a3b8;
  display: flex; align-items: center; gap: 5px;
}

/* Inline Rejection Panel */
.reject-panel {
  display: none; padding: 1rem 1.5rem;
  border-top: 2px dashed #fecaca; background: #fef2f2;
}
.reject-panel.open { display: block; }
.reject-panel textarea {
  width: 100%; border: 1.5px solid #fecaca; border-radius: 10px;
  padding: 0.65rem 0.9rem; font-size: 0.85rem; font-family: inherit;
  resize: vertical; outline: none; background: #fff; color: #1e293b;
  transition: border-color 0.2s;
}
.reject-panel textarea:focus { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,0.1); }
.btn-confirm-reject {
  display: inline-flex; align-items: center; gap: 6px;
  background: #ef4444; color: #fff; border: none; border-radius: 8px;
  padding: 0.6rem 1.2rem; font-size: 0.85rem; font-weight: 700;
  cursor: pointer; font-family: inherit; margin-top: 0.6rem; transition: all 0.2s;
}
.btn-confirm-reject:hover { background: #dc2626; }
.btn-cancel-reject {
  display: inline-flex; align-items: center; gap: 6px;
  background: none; color: #94a3b8; border: none;
  padding: 0.6rem 0.8rem; font-size: 0.85rem; cursor: pointer;
  font-family: inherit; margin-top: 0.6rem; margin-left: 8px; transition: color 0.2s;
}
.btn-cancel-reject:hover { color: #1e293b; }

/* Empty state */
.empty-approvals {
  padding: 3rem; text-align: center; color: #94a3b8;
  background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.07);
}
.empty-approvals i { font-size: 3.5rem; color: #10b981; display: block; margin-bottom: 1rem; }

@media (max-width: 768px) {
  .tr-grid { grid-template-columns: 1fr 1fr; }
}
</style>

<div class="main-content">
  <header class="topbar" style="background:#fff;border-bottom:1px solid #e2e8f0;
         padding:0 1.5rem;height:64px;display:flex;align-items:center;
         justify-content:space-between;position:sticky;top:0;z-index:900;">
    <div style="font-size:1rem;font-weight:800;color:#1a3a6e;">
      <i class="bi bi-send-fill"></i> External Transfer Approvals
    </div>
    <div style="display:flex;align-items:center;gap:10px;">
      <span style="font-size:0.85rem;color:#94a3b8;">Manager:</span>
      <div style="width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,#1a3a6e,#2563eb);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:0.85rem;">
        <%= initials %>
      </div>
      <strong style="font-size:0.88rem;color:#1a3a6e;"><%= fullName %></strong>
    </div>
  </header>

  <div class="page-content">

    <!-- Alerts -->
    <% if (request.getAttribute("error") != null) { %>
      <div class="alrt alrt-err">
        <i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
        <div><%= request.getAttribute("error") %></div>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alrt alrt-ok">
        <i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
        <div><%= request.getAttribute("success") %></div>
      </div>
    <% } %>

    <!-- Hero -->
    <div class="appr-hero">
      <div style="position:relative;z-index:2;">
        <h2><i class="bi bi-hourglass-split"></i> Pending Transfer Requests</h2>
        <p>Review and approve or reject customer external / international transfer requests.</p>
        <div style="margin-top:0.8rem;font-size:0.78rem;opacity:0.8;display:flex;gap:1rem;flex-wrap:wrap;">
          <span><i class="bi bi-check-circle-fill" style="color:#10b981;"></i> Approve → Balance deducted immediately</span>
          <span><i class="bi bi-x-circle-fill" style="color:#fca5a5;"></i> Reject → No balance change</span>
        </div>
      </div>
      <div class="count-badge">
        <div class="cb-num"><%= transfers != null ? transfers.size() : 0 %></div>
        <div class="cb-lbl">Awaiting Review</div>
      </div>
    </div>

    <!-- Policy Warning -->
    <div class="alrt alrt-warn">
      <i class="bi bi-shield-exclamation" style="flex-shrink:0;margin-top:1px;font-size:1.1rem;"></i>
      <div>
        <strong>Important Policy:</strong>
        For these transfer requests, <strong>no funds have been deducted</strong> from customer accounts yet.
        On <strong style="color:#166534;">Approval</strong> → the total (amount + fee) is deducted atomically and locked via row-level DB locking.
        On <strong style="color:#dc2626;">Rejection</strong> → nothing happens; the customer's balance remains unchanged.
        Always verify the request details before approving.
      </div>
    </div>

    <!-- Transfer Cards -->
    <% if (transfers == null || transfers.isEmpty()) { %>
      <div class="empty-approvals">
        <i class="bi bi-check-all"></i>
        <h3 style="color:#0A1F44;font-weight:800;margin-bottom:0.5rem;">All Caught Up!</h3>
        <p>No pending external or international transfers require your review.</p>
        <a href="${pageContext.request.contextPath}/manager/dashboard"
           style="display:inline-flex;align-items:center;gap:6px;margin-top:1rem;
                  background:#1a3a6e;color:#fff;padding:0.6rem 1.5rem;border-radius:10px;
                  text-decoration:none;font-weight:700;font-size:0.85rem;">
          <i class="bi bi-speedometer2"></i> Back to Dashboard
        </a>
      </div>
    <% } else { %>
      <% for (Transfer tr : transfers) {
           BigDecimal total = tr.getAmount().add(tr.getFee());
      %>
        <div class="tr-card" id="trCard<%= tr.getId() %>">

          <!-- Card Header -->
          <div class="tr-card-head">
            <div>
              <div class="tr-id">Transfer Request #<%= tr.getId() %></div>
              <div style="margin-top:4px;">
                <span class="tr-type-badge <%= "EXTERNAL".equals(tr.getTransferType()) ? "type-ext" : "type-intl" %>">
                  <i class="bi bi-<%= "EXTERNAL".equals(tr.getTransferType()) ? "bank2" : "globe2" %>"></i>
                  <%= tr.getTransferType() %> Transfer
                </span>
              </div>
            </div>

            <div style="text-align:right;">
              <div class="tr-amount">
                ETB <%= tr.getAmount().toPlainString() %>
                <small>+ ETB <%= tr.getFee().toPlainString() %> fee</small>
              </div>
              <div style="font-size:0.75rem;color:#94a3b8;margin-top:2px;">
                From: <code style="background:#f1f5f9;padding:1px 6px;border-radius:4px;color:#2563eb;">
                  <%= tr.getSenderAccountNumber() %>
                </code>
                &nbsp;·&nbsp; <strong style="color:#0A1F44;"><%= tr.getSenderName() %></strong>
              </div>
            </div>
          </div>

          <!-- Card Body -->
          <div class="tr-card-body">
            <div class="tr-grid">
              <div class="tr-field">
                <div class="tf-label"><i class="bi bi-person-fill"></i> Beneficiary</div>
                <div class="tf-value">
                  <%= tr.getBeneficiaryName() != null ? tr.getBeneficiaryName() : "N/A" %>
                </div>
              </div>
              <div class="tr-field">
                <div class="tf-label"><i class="bi bi-credit-card"></i> Receiver Account</div>
                <div class="tf-value"><code><%= tr.getReceiverAccount() %></code></div>
              </div>
              <div class="tr-field">
                <div class="tf-label"><i class="bi bi-bank2"></i> Destination Bank</div>
                <div class="tf-value"><%= tr.getBankName() != null ? tr.getBankName() : "N/A" %></div>
              </div>
              <% if (tr.getSwiftCode() != null) { %>
              <div class="tr-field">
                <div class="tf-label"><i class="bi bi-broadcast"></i> SWIFT / BIC</div>
                <div class="tf-value"><code><%= tr.getSwiftCode() %></code></div>
              </div>
              <% } %>
              <% if (tr.getCountry() != null) { %>
              <div class="tr-field">
                <div class="tf-label"><i class="bi bi-geo-alt-fill"></i> Country</div>
                <div class="tf-value"><%= tr.getCountry() %></div>
              </div>
              <% } %>
              <div class="tr-field">
                <div class="tf-label"><i class="bi bi-chat-text"></i> Description</div>
                <div class="tf-value" style="color:#94a3b8;">
                  <%= tr.getDescription() != null && !tr.getDescription().isBlank()
                      ? tr.getDescription() : "—" %>
                </div>
              </div>
            </div>

            <!-- Fee Mini Breakdown -->
            <div class="fee-mini">
              <div class="fee-mini-item">
                <div class="fmi-label">Transfer Amount</div>
                <div class="fmi-val">ETB <%= tr.getAmount().toPlainString() %></div>
              </div>
              <div class="fee-mini-item">
                <div class="fmi-label">Service Fee</div>
                <div class="fmi-val fee">ETB <%= tr.getFee().toPlainString() %></div>
              </div>
              <div class="fee-mini-item">
                <div class="fmi-label">Total to Deduct</div>
                <div class="fmi-val total">ETB <%= total.toPlainString() %></div>
              </div>
              <div class="fee-mini-item">
                <div class="fmi-label">Transfer Type</div>
                <div class="fmi-val" style="font-size:0.82rem;"><%= tr.getTransferType() %></div>
              </div>
            </div>
          </div>

          <!-- Action Bar -->
          <div class="tr-actions">
            <!-- APPROVE Form -->
            <form method="post"
                  action="${pageContext.request.contextPath}/manager/external-transfers"
                  style="display:inline;">
              <input type="hidden" name="csrfToken"   value="${csrfToken}"/>
              <input type="hidden" name="transferId"  value="<%= tr.getId() %>"/>
              <input type="hidden" name="action"      value="APPROVE"/>
              <button type="submit" class="btn-approve"
                      onclick="return confirm('APPROVE transfer #<%= tr.getId() %> of ETB <%= total.toPlainString() %> (amount + fee)?\n\nThis will immediately deduct ETB <%= total.toPlainString() %> from the sender\'s account.\n\nThis action cannot be undone.')">
                <i class="bi bi-check-circle-fill"></i>
                Approve – Deduct ETB <%= total.toPlainString() %>
              </button>
            </form>

            <!-- REJECT Toggle -->
            <button type="button" class="btn-reject-open"
                    onclick="toggleReject(<%= tr.getId() %>)">
              <i class="bi bi-x-circle-fill"></i>
              Reject Request
            </button>

            <div class="submit-time">
              <i class="bi bi-clock"></i>
              Submitted: <%= tr.getCreatedAt() != null ? tr.getCreatedAt().format(fmt) : "N/A" %>
            </div>
          </div>

          <!-- Inline Reject Panel -->
          <div class="reject-panel" id="rejectPanel<%= tr.getId() %>">
            <div style="font-size:0.85rem;font-weight:700;color:#dc2626;margin-bottom:0.6rem;">
              <i class="bi bi-x-circle-fill"></i>
              Reject Transfer #<%= tr.getId() %> – Provide Reason
            </div>
            <div style="font-size:0.78rem;color:#92400e;background:#fef3c7;border-radius:6px;
                         padding:0.5rem 0.8rem;margin-bottom:0.6rem;">
              <i class="bi bi-info-circle"></i>
              No funds will be deducted. The customer will see this transfer as REJECTED.
            </div>
            <form method="post"
                  action="${pageContext.request.contextPath}/manager/external-transfers">
              <input type="hidden" name="csrfToken"        value="${csrfToken}"/>
              <input type="hidden" name="transferId"       value="<%= tr.getId() %>"/>
              <input type="hidden" name="action"           value="REJECT"/>
              <textarea name="rejectionReason"
                        placeholder="State the reason for rejection (e.g. suspicious activity, incomplete beneficiary info, compliance hold)..."
                        rows="3" required></textarea>
              <div>
                <button type="submit" class="btn-confirm-reject">
                  <i class="bi bi-x-circle-fill"></i> Confirm Rejection
                </button>
                <button type="button" class="btn-cancel-reject"
                        onclick="toggleReject(<%= tr.getId() %>)">
                  <i class="bi bi-arrow-left"></i> Cancel
                </button>
              </div>
            </form>
          </div>

        </div><!-- tr-card -->
      <% } %>
    <% } %>

  </div><!-- page-content -->

  <%@ include file="/jsp/includes/footer.jsp" %>
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function toggleReject(id) {
  const panel = document.getElementById('rejectPanel' + id);
  panel.classList.toggle('open');
  if (panel.classList.contains('open')) {
    panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    panel.querySelector('textarea').focus();
  }
}
</script>
</body>
</html>