<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Account,
                 com.gojjam.bank.dao.AccountDAO,
                 com.gojjam.bank.dao.TransferDAO,
                 com.gojjam.bank.model.Transfer,
                 java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Transfer Funds";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
  int userId       = (int) session.getAttribute("userId");

  AccountDAO  accountDAO  = new AccountDAO();
  TransferDAO transferDAO = new TransferDAO();
  Account     account     = null;
  List<Transfer> myTransfers = null;
  try {
      account     = accountDAO.findByUserId(userId);
      if (account != null) {
          myTransfers = transferDAO.getByAccount(account.getId());
      }
  } catch (Exception ignored) {}

  String internalFee = (String) request.getAttribute("internalFee");
  String externalFee = (String) request.getAttribute("externalFee");
  String intlFee     = (String) request.getAttribute("intlFee");
  String maxLimit    = (String) request.getAttribute("maxLimit");
  if (internalFee == null) internalFee = "25.00";
  if (externalFee == null) externalFee = "75.00";
  if (intlFee     == null) intlFee     = "200.00";
  if (maxLimit    == null) maxLimit    = "500000.00";

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
.transfer-hero {
  background: linear-gradient(135deg, #0A1F44 0%, #1a3a6e 60%, #2563eb 100%);
  border-radius: 16px; padding: 1.5rem 2rem; color: #fff;
  margin-bottom: 1.5rem; display: flex;
  align-items: center; justify-content: space-between;
  position: relative; overflow: hidden;
}
.transfer-hero::before {
  content: ''; position: absolute; width: 200px; height: 200px;
  border-radius: 50%; background: rgba(255,255,255,0.05);
  right: -40px; top: -60px;
}
.transfer-hero h2 { font-size: 1.2rem; font-weight: 800; margin-bottom: 4px; }
.transfer-hero p  { font-size: 0.82rem; opacity: 0.7; }
.balance-pill {
  background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
  border-radius: 12px; padding: 0.6rem 1rem; text-align: right; position: relative; z-index: 2;
}
.balance-pill .bp-label { font-size: 0.7rem; opacity: 0.7; }
.balance-pill .bp-amount { font-size: 1.2rem; font-weight: 800; }

/* Type selector */
.type-selector { display: grid; grid-template-columns: repeat(3,1fr); gap: 0.8rem; margin-bottom: 1.5rem; }
.type-card {
  border: 2px solid #e2e8f0; border-radius: 14px; padding: 1rem;
  cursor: pointer; transition: all 0.25s; background: #fff; text-align: center;
  position: relative;
}
.type-card:hover { border-color: #bfdbfe; background: #f8fafc; transform: translateY(-2px); }
.type-card.selected { border-color: #2563eb; background: #eff6ff; box-shadow: 0 0 0 3px rgba(37,99,235,0.12); }
.type-card .tc-icon {
  width: 48px; height: 48px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  font-size: 1.3rem; margin: 0 auto 0.6rem;
}
.type-card.tc-internal .tc-icon { background: #dcfce7; color: #16a34a; }
.type-card.tc-external .tc-icon { background: #dbeafe; color: #2563eb; }
.type-card.tc-intl     .tc-icon { background: #fdf4ff; color: #9333ea; }
.type-card h4 { font-size: 0.88rem; font-weight: 800; color: #0A1F44; margin-bottom: 2px; }
.type-card p  { font-size: 0.72rem; color: #94a3b8; }
.tc-fee {
  font-size: 0.7rem; font-weight: 700; margin-top: 6px;
  padding: 2px 8px; border-radius: 10px; display: inline-block;
}
.tc-badge {
  position: absolute; top: 8px; right: 8px; font-size: 0.65rem;
  font-weight: 700; padding: 2px 8px; border-radius: 10px;
}
.type-card.selected .tc-badge { background: #2563eb; color: #fff; }

/* Form section */
.form-section {
  background: #fff; border-radius: 16px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.07); overflow: hidden; margin-bottom: 1.5rem;
}
.form-section-head {
  background: #0A1F44; color: #fff; padding: 1rem 1.5rem;
  font-weight: 700; font-size: 0.92rem; display: flex; align-items: center; gap: 8px;
}
.form-section-head .step-num {
  width: 24px; height: 24px; border-radius: 50%;
  background: rgba(255,255,255,0.2); display: flex; align-items: center;
  justify-content: center; font-size: 0.75rem; font-weight: 800; flex-shrink: 0;
}
.form-section-body { padding: 1.5rem; }

.form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
.form-grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; }
.col-span-2  { grid-column: span 2; }
.col-span-3  { grid-column: span 3; }

/* Form inputs */
.form-group { display: flex; flex-direction: column; }
.form-group label {
  font-size: 0.8rem; font-weight: 700; color: #0A1F44; margin-bottom: 5px;
  display: flex; align-items: center; gap: 6px;
}
.req { color: #ef4444; }
.inp-wrap { position: relative; }
.inp-wrap .fi {
  position: absolute; left: 11px; top: 50%; transform: translateY(-50%);
  color: #94a3b8; font-size: 0.95rem; pointer-events: none; z-index: 1;
}
.inp {
  width: 100%; padding: 0.65rem 0.9rem 0.65rem 2.3rem;
  border: 1.5px solid #e2e8f0; border-radius: 10px;
  font-size: 0.88rem; font-family: inherit;
  color: #1e293b; transition: all 0.2s; outline: none; background: #fff;
}
.inp:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
.inp.valid   { border-color: #10b981; background: #f0fdf4; }
.inp.invalid { border-color: #ef4444; background: #fef2f2; }
.inp-hint  { font-size: 0.72rem; color: #94a3b8; margin-top: 3px; }
.inp-error { font-size: 0.72rem; color: #ef4444; margin-top: 3px; font-weight: 600;
             display: none; padding: 3px 8px; background: #fef2f2; border-radius: 6px; }

/* Fee summary */
.fee-summary {
  background: linear-gradient(135deg, #f8fafc, #eff6ff);
  border: 1px solid #bfdbfe; border-radius: 12px; padding: 1rem 1.2rem; margin-top: 0.5rem;
}
.fee-row { display: flex; justify-content: space-between; align-items: center; padding: 4px 0; font-size: 0.83rem; }
.fee-row .fr-label { color: #475569; }
.fee-row .fr-value { font-weight: 700; color: #0A1F44; }
.fee-divider { height: 1px; background: #bfdbfe; margin: 6px 0; }
.fee-total .fr-label { color: #0A1F44; font-weight: 700; }
.fee-total .fr-value { color: #ef4444; font-size: 1rem; font-weight: 800; }

/* Pending notice */
.pending-notice {
  background: #fef3c7; border: 1px solid #fde68a;
  border-left: 4px solid #f59e0b; border-radius: 10px;
  padding: 0.8rem 1rem; font-size: 0.83rem; color: #92400e;
  display: flex; align-items: flex-start; gap: 8px; margin-bottom: 1rem;
}

/* Submit buttons */
.btn-transfer {
  display: flex; align-items: center; justify-content: center; gap: 8px;
  padding: 0.8rem 2rem; border: none; border-radius: 12px;
  font-size: 0.95rem; font-weight: 800; cursor: pointer;
  font-family: inherit; transition: all 0.3s; position: relative; overflow: hidden;
}
.btn-primary-t {
  background: linear-gradient(135deg, #0A1F44, #2563eb);
  color: #fff;
}
.btn-primary-t:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(10,31,68,0.3); }
.btn-pdf-t {
  background: linear-gradient(135deg, #10b981, #059669);
  color: #fff;
}
.btn-pdf-t:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16,185,129,0.3); }

/* Alerts */
.alert-s { border-radius: 10px; padding: 0.9rem 1rem; margin-bottom: 1.2rem;
           font-size: 0.88rem; display: flex; align-items: flex-start; gap: 8px; }
.alert-success-s { background: #f0fdf4; border: 1px solid #bbf7d0; border-left: 4px solid #10b981; color: #166534; }
.alert-error-s   { background: #fef2f2; border: 1px solid #fecaca; border-left: 4px solid #ef4444; color: #991b1b; }

/* Transfer history */
.history-section { background: #fff; border-radius: 16px;
                   box-shadow: 0 2px 16px rgba(0,0,0,0.07); overflow: hidden; }
.history-head {
  background: #0A1F44; color: #fff; padding: 1rem 1.5rem;
  font-weight: 700; font-size: 0.92rem; display: flex; align-items: center; gap: 8px;
}
.history-head a { margin-left: auto; color: rgba(255,255,255,0.7);
                  font-size: 0.78rem; text-decoration: none; }
.history-head a:hover { color: #fff; }
.t-table { width: 100%; border-collapse: collapse; }
.t-table thead tr { background: #f8fafc; }
.t-table th { padding: 0.6rem 0.8rem; font-size: 0.72rem; font-weight: 700;
              color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px;
              border-bottom: 2px solid #f1f5f9; }
.t-table td { padding: 0.7rem 0.8rem; font-size: 0.83rem;
              border-bottom: 1px solid #f8fafc; vertical-align: middle; }
.t-table tbody tr:hover { background: #f8fafc; }
.t-table tbody tr:last-child td { border-bottom: none; }
.status-pill {
  display: inline-flex; align-items: center; gap: 4px;
  padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700;
}
.sp-success  { background: #dcfce7; color: #15803d; }
.sp-pending  { background: #fef3c7; color: #92400e; }
.sp-rejected { background: #fef2f2; color: #dc2626; }
.sp-failed   { background: #f3f4f6; color: #6b7280; }

@media (max-width: 768px) {
  .type-selector { grid-template-columns: 1fr; }
  .form-grid-2, .form-grid-3 { grid-template-columns: 1fr; }
  .col-span-2, .col-span-3 { grid-column: span 1; }
}
</style>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-arrow-left-right"></i> Transfer Funds</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">

    <!-- Alerts -->
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-s alert-error-s">
        <i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
        <div><%= request.getAttribute("error") %></div>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert-s alert-success-s">
        <i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
        <div><%= request.getAttribute("success") %></div>
      </div>
    <% } %>

    <!-- Hero Bar -->
    <div class="transfer-hero">
      <div style="position:relative;z-index:2;">
        <h2><i class="bi bi-arrow-left-right"></i> Transfer Funds</h2>
        <p>Internal transfers are instant · External &amp; SWIFT require manager approval</p>
      </div>
      <% if (account != null) { %>
      <div class="balance-pill">
        <div class="bp-label">Available Balance</div>
        <div class="bp-amount">ETB <%= account.getBalance().toPlainString() %></div>
        <div style="font-size:0.68rem;opacity:0.6;margin-top:2px;">
          <i class="bi bi-credit-card"></i> <%= account.getAccountNumber() %>
        </div>
      </div>
      <% } %>
    </div>

    <!-- Step 1: Choose Transfer Type -->
    <div class="form-section">
      <div class="form-section-head">
        <span class="step-num">1</span> Choose Transfer Type
      </div>
      <div class="form-section-body">
        <div class="type-selector">
          <div class="type-card tc-internal selected" id="card-INTERNAL"
               onclick="selectType('INTERNAL',this)">
            <span class="tc-badge" id="badge-INTERNAL"
                  style="background:#2563eb;color:#fff;">Selected</span>
            <div class="tc-icon"><i class="bi bi-building-fill"></i></div>
            <h4>Internal Transfer</h4>
            <p>Between Gojjam Bank accounts</p>
            <div class="tc-fee" style="background:#dcfce7;color:#15803d;">
              Fee: ETB <%= internalFee %>
            </div>
            <div style="margin-top:4px;font-size:0.7rem;color:#10b981;font-weight:600;">
              <i class="bi bi-lightning-fill"></i> Instant
            </div>
          </div>

          <div class="type-card tc-external" id="card-EXTERNAL"
               onclick="selectType('EXTERNAL',this)">
            <span class="tc-badge" id="badge-EXTERNAL"
                  style="display:none;background:#2563eb;color:#fff;">Selected</span>
            <div class="tc-icon"><i class="bi bi-bank2"></i></div>
            <h4>External Bank</h4>
            <p>To other Ethiopian banks</p>
            <div class="tc-fee" style="background:#dbeafe;color:#1d4ed8;">
              Fee: ETB <%= externalFee %>
            </div>
            <div style="margin-top:4px;font-size:0.7rem;color:#f59e0b;font-weight:600;">
              <i class="bi bi-clock"></i> Manager Approval
            </div>
          </div>

          <div class="type-card tc-intl" id="card-INTERNATIONAL"
               onclick="selectType('INTERNATIONAL',this)">
            <span class="tc-badge" id="badge-INTERNATIONAL"
                  style="display:none;background:#2563eb;color:#fff;">Selected</span>
            <div class="tc-icon"><i class="bi bi-globe2"></i></div>
            <h4>SWIFT International</h4>
            <p>Worldwide wire transfer</p>
            <div class="tc-fee" style="background:#fdf4ff;color:#9333ea;">
              Fee: ETB <%= intlFee %>
            </div>
            <div style="margin-top:4px;font-size:0.7rem;color:#f59e0b;font-weight:600;">
              <i class="bi bi-clock"></i> Manager Approval
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ─────────────────────────────────────────────────────── -->
    <!--  THE FORM  –  ONE hidden "amount" field only           -->
    <!-- ─────────────────────────────────────────────────────── -->
    <form method="post" action="${pageContext.request.contextPath}/customer/transfer"
          id="transferForm" novalidate>
      <input type="hidden" name="csrfToken"     value="${csrfToken}"/>
      <input type="hidden" name="transferType"  id="transferTypeInput" value="INTERNAL"/>

      <!-- KEY FIX: Single hidden amount field -->
      <input type="hidden" name="amount"        id="hiddenAmount"/>
      <input type="hidden" name="downloadPdf"   id="pdfFlag" value="false"/>

      <!-- Step 2 – Transfer Details -->
      <div class="form-section">
        <div class="form-section-head">
          <span class="step-num">2</span>
          <span id="step2Title">Recipient Details – Internal Transfer</span>
        </div>
        <div class="form-section-body">

          <!-- ── INTERNAL FIELDS ─────────────────────────── -->
          <div id="internalSection">
            <div class="form-grid-2">
              <div class="form-group col-span-2">
                <label>
                  <i class="bi bi-credit-card" style="color:#2563eb;"></i>
                  Receiver Account Number <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-credit-card fi"></i>
                  <input type="text" name="receiverAccount" id="intReceiver" class="inp"
                         placeholder="ACC1234567890"
                         maxlength="13"
                         style="text-transform:uppercase;letter-spacing:1px;font-weight:600;"/>
                </div>
                <div class="inp-hint">Format: ACC + 10 digits</div>
                <div class="inp-error" id="intReceiverErr">
                  Valid account number required (format: ACC + 10 digits).
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-cash-coin" style="color:#10b981;"></i>
                  Amount (ETB) <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-currency-exchange fi"></i>
                  <input type="number" id="intAmountInput" class="inp"
                         placeholder="100.00" min="1"
                         max="<%= maxLimit %>" step="0.01"
                         oninput="recalcFee()"/>
                </div>
                <div class="inp-error" id="intAmountErr">
                  Enter a valid amount (minimum ETB 1).
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-chat-text" style="color:#94a3b8;"></i>
                  Description <small style="color:#94a3b8;">(optional)</small>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-chat-text fi"></i>
                  <input type="text" name="description" class="inp"
                         placeholder="Payment description..." maxlength="200"/>
                </div>
              </div>
            </div>
          </div>

          <!-- ── EXTERNAL FIELDS ──────────────────────────── -->
          <div id="externalSection" style="display:none;">
            <div class="pending-notice">
              <i class="bi bi-info-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
              <div>
                <strong>Requires Manager Approval.</strong>
                Your balance will only be deducted <strong>after</strong>
                a manager approves this request. You can track the status below.
              </div>
            </div>
            <div class="form-grid-2">
              <div class="form-group">
                <label>
                  <i class="bi bi-credit-card" style="color:#2563eb;"></i>
                  Receiver Account Number <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-credit-card fi"></i>
                  <input type="text" name="receiverAccount" id="extReceiver" class="inp"
                         placeholder="Account number at external bank"/>
                </div>
                <div class="inp-error" id="extReceiverErr">
                  Receiver account number is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-person-fill" style="color:#2563eb;"></i>
                  Beneficiary Full Name <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-person-fill fi"></i>
                  <input type="text" name="beneficiaryName" id="extBenef" class="inp"
                         placeholder="Full name of recipient" maxlength="200"/>
                </div>
                <div class="inp-error" id="extBenefErr">
                  Beneficiary name is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-bank2" style="color:#2563eb;"></i>
                  Destination Bank Name <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-bank2 fi"></i>
                  <input type="text" name="bankName" id="extBankName" class="inp"
                         placeholder="Commercial Bank of Ethiopia..." maxlength="200"/>
                </div>
                <div class="inp-error" id="extBankErr">
                  Bank name is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-cash-coin" style="color:#10b981;"></i>
                  Amount (ETB) <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-currency-exchange fi"></i>
                  <input type="number" id="extAmountInput" class="inp"
                         placeholder="1000.00" min="1"
                         max="<%= maxLimit %>" step="0.01"
                         oninput="recalcFee()"/>
                </div>
                <div class="inp-error" id="extAmountErr">
                  Enter a valid amount (minimum ETB 1).
                </div>
              </div>

              <div class="form-group col-span-2">
                <label>
                  <i class="bi bi-chat-text" style="color:#94a3b8;"></i>
                  Description <small style="color:#94a3b8;">(optional)</small>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-chat-text fi"></i>
                  <input type="text" name="description" class="inp"
                         placeholder="Purpose of transfer..." maxlength="200"/>
                </div>
              </div>
            </div>
          </div>

          <!-- ── INTERNATIONAL / SWIFT FIELDS ─────────────── -->
          <div id="intlSection" style="display:none;">
            <div class="pending-notice">
              <i class="bi bi-globe2" style="flex-shrink:0;margin-top:1px;color:#9333ea;"></i>
              <div>
                <strong>SWIFT International Transfer – Requires Manager Approval.</strong>
                Your balance will only be deducted <strong>after</strong> a manager approves.
                Provide accurate SWIFT/BIC details to avoid delays.
              </div>
            </div>
            <div class="form-grid-2">
              <div class="form-group">
                <label>
                  <i class="bi bi-person-fill" style="color:#9333ea;"></i>
                  Beneficiary Full Name <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-person-fill fi"></i>
                  <input type="text" name="beneficiaryName" id="intlBenef" class="inp"
                         placeholder="Full legal name of recipient" maxlength="200"/>
                </div>
                <div class="inp-error" id="intlBenefErr">
                  Beneficiary name is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-123" style="color:#9333ea;"></i>
                  IBAN / Account Number <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-123 fi"></i>
                  <input type="text" name="receiverAccount" id="intlIban" class="inp"
                         placeholder="GB29NWBK60161331926819"
                         style="text-transform:uppercase;letter-spacing:1px;"/>
                </div>
                <div class="inp-error" id="intlIbanErr">
                  IBAN or account number is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-broadcast" style="color:#9333ea;"></i>
                  SWIFT / BIC Code <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-broadcast fi"></i>
                  <input type="text" name="swiftCode" id="intlSwift" class="inp"
                         placeholder="CBETETAA" maxlength="11"
                         style="text-transform:uppercase;letter-spacing:2px;font-weight:700;"/>
                </div>
                <div class="inp-hint">8 or 11 character BIC code</div>
                <div class="inp-error" id="intlSwiftErr">
                  SWIFT/BIC code must be 8 or 11 characters.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-bank2" style="color:#9333ea;"></i>
                  Destination Bank Name <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-bank2 fi"></i>
                  <input type="text" name="bankName" id="intlBankName" class="inp"
                         placeholder="HSBC, Deutsche Bank..." maxlength="200"/>
                </div>
                <div class="inp-error" id="intlBankErr">
                  Bank name is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-geo-alt-fill" style="color:#9333ea;"></i>
                  Country <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-geo-alt-fill fi"></i>
                  <input type="text" name="country" id="intlCountry" class="inp"
                         placeholder="United Kingdom, USA..." maxlength="100"/>
                </div>
                <div class="inp-error" id="intlCountryErr">
                  Country is required.
                </div>
              </div>

              <div class="form-group">
                <label>
                  <i class="bi bi-cash-coin" style="color:#10b981;"></i>
                  Amount (ETB) <span class="req">*</span>
                </label>
                <div class="inp-wrap">
                  <i class="bi bi-currency-exchange fi"></i>
                  <input type="number" id="intlAmountInput" class="inp"
                         placeholder="5000.00" min="1"
                         max="<%= maxLimit %>" step="0.01"
                         oninput="recalcFee()"/>
                </div>
                <div class="inp-error" id="intlAmountErr">
                  Enter a valid amount (minimum ETB 1).
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>

      <!-- Step 3 – Fee Summary & Confirm -->
      <div class="form-section">
        <div class="form-section-head">
          <span class="step-num">3</span>
          Fee Summary &amp; Confirm
        </div>
        <div class="form-section-body">
          <div class="form-grid-2">

            <!-- Fee breakdown -->
            <div>
              <div class="fee-summary">
                <div class="fee-row">
                  <span class="fr-label"><i class="bi bi-cash"></i> Transfer Amount</span>
                  <span class="fr-value">
                    ETB <span id="summaryAmount">0.00</span>
                  </span>
                </div>
                <div class="fee-row">
                  <span class="fr-label"><i class="bi bi-tag"></i> Service Fee</span>
                  <span class="fr-value" style="color:#f59e0b;">
                    ETB <span id="summaryFee"><%= internalFee %></span>
                  </span>
                </div>
                <div class="fee-divider"></div>
                <div class="fee-row fee-total">
                  <span class="fr-label">
                    <i class="bi bi-calculator"></i> Total Deduction
                  </span>
                  <span class="fr-value">
                    ETB <span id="summaryTotal">0.00</span>
                  </span>
                </div>
                <% if (account != null) { %>
                <div class="fee-divider"></div>
                <div class="fee-row">
                  <span class="fr-label" style="color:#10b981;font-weight:600;">
                    <i class="bi bi-wallet2"></i> Balance After
                  </span>
                  <span class="fr-value" id="summaryBalAfter"
                        style="color:#10b981;">
                    ETB <%= account.getBalance().toPlainString() %>
                  </span>
                </div>
                <% } %>
              </div>

              <div id="instantNotice"
                   style="margin-top:0.8rem;font-size:0.78rem;color:#10b981;font-weight:600;">
                <i class="bi bi-lightning-fill"></i>
                This transfer will be processed instantly.
              </div>
              <div id="approvalNotice" style="display:none;margin-top:0.8rem;">
                <div style="background:#fef3c7;border:1px solid #fde68a;
                             border-left:3px solid #f59e0b;border-radius:8px;
                             padding:0.7rem;font-size:0.78rem;color:#92400e;">
                  <i class="bi bi-clock-fill"></i>
                  <strong>Pending approval.</strong>
                  Balance deducted only <strong>after</strong> manager approves.
                </div>
              </div>
            </div>

            <!-- Submit buttons -->
            <div style="display:flex;flex-direction:column;justify-content:flex-end;gap:0.8rem;">
              <button type="button" class="btn-transfer btn-primary-t"
                      onclick="submitTransfer(false)">
                <i class="bi bi-send-fill"></i>
                <span id="submitLabel">Submit Transfer</span>
              </button>
              <button type="button" id="pdfBtn"
                      class="btn-transfer btn-pdf-t"
                      onclick="submitTransfer(true)"
                      style="display:none;">
                <i class="bi bi-file-earmark-pdf-fill"></i>
                Submit &amp; Download Receipt
              </button>
              <a href="${pageContext.request.contextPath}/customer/dashboard"
                 style="text-align:center;color:#94a3b8;font-size:0.82rem;text-decoration:none;">
                <i class="bi bi-arrow-left"></i> Cancel
              </a>
            </div>
          </div>
        </div>
      </div>
    </form>

    <!-- Transfer History -->
    <div class="history-section">
      <div class="history-head">
        <i class="bi bi-clock-history"></i> My Transfer History
        <a href="${pageContext.request.contextPath}/customer/transactions">
          View All <i class="bi bi-arrow-right"></i>
        </a>
      </div>
      <% if (myTransfers == null || myTransfers.isEmpty()) { %>
        <div style="padding:2rem;text-align:center;color:#94a3b8;">
          <i class="bi bi-inbox" style="font-size:2.5rem;display:block;margin-bottom:0.5rem;"></i>
          No transfers yet.
        </div>
      <% } else { %>
        <div style="overflow-x:auto;">
          <table class="t-table">
            <thead>
              <tr>
                <th>#</th><th>Type</th><th>Receiver</th>
                <th>Beneficiary</th><th>Bank</th>
                <th>Amount (ETB)</th><th>Fee (ETB)</th>
                <th>Status</th><th>Date</th>
              </tr>
            </thead>
            <tbody>
              <% for (Transfer tr : myTransfers) { %>
                <tr>
                  <td>
                    <code style="font-size:0.75rem;background:#f1f5f9;
                                 padding:2px 6px;border-radius:4px;">
                      #<%= tr.getId() %>
                    </code>
                   </td>
                  <td>
                    <span style="font-size:0.75rem;font-weight:700;padding:2px 8px;border-radius:10px;
                          background:<%= "INTERNAL".equals(tr.getTransferType())?"#dcfce7":"EXTERNAL".equals(tr.getTransferType())?"#dbeafe":"#fdf4ff" %>;
                          color:<%= "INTERNAL".equals(tr.getTransferType())?"#15803d":"EXTERNAL".equals(tr.getTransferType())?"#1d4ed8":"#9333ea" %>;">
                      <i class="bi bi-<%= "INTERNAL".equals(tr.getTransferType())?"building":"EXTERNAL".equals(tr.getTransferType())?"bank2":"globe2" %>"></i>
                      <%= tr.getTransferType() %>
                    </span>
                   </td>
                  <td>
                    <code style="font-size:0.78rem;">
                      <%= tr.getReceiverAccount() %>
                    </code>
                   </td>
                  <td style="font-size:0.82rem;">
                    <%= tr.getBeneficiaryName() != null ? tr.getBeneficiaryName() : "—" %>
                   </td>
                  <td style="font-size:0.78rem;color:#475569;">
                    <%= tr.getBankName() != null ? tr.getBankName() : "—" %>
                   </td>
                  <td style="font-weight:700;color:#0A1F44;">
                    ETB <%= tr.getAmount().toPlainString() %>
                   </td>
                  <td style="font-size:0.82rem;color:#94a3b8;">
                    ETB <%= tr.getFee().toPlainString() %>
                   </td>
                  <td>
                    <span class="status-pill
                      <%= "SUCCESS".equals(tr.getStatus())?"sp-success":"PENDING".equals(tr.getStatus())?"sp-pending":"REJECTED".equals(tr.getStatus())?"sp-rejected":"sp-failed" %>">
                      <i class="bi bi-<%= "SUCCESS".equals(tr.getStatus())?"check-circle-fill":"PENDING".equals(tr.getStatus())?"clock-fill":"REJECTED".equals(tr.getStatus())?"x-circle-fill":"dash-circle-fill" %>"
                         style="font-size:0.65rem;"></i>
                      <%= tr.getStatus() %>
                    </span>
                    <% if ("PENDING".equals(tr.getStatus())) { %>
                      <div style="font-size:0.68rem;color:#f59e0b;margin-top:2px;">
                        Awaiting manager approval
                      </div>
                    <% } %>
                    <% if ("REJECTED".equals(tr.getStatus())) { %>
                      <div style="font-size:0.68rem;color:#ef4444;margin-top:2px;">
                        No funds deducted
                      </div>
                    <% } %>
                   </td>
                  <td style="font-size:0.78rem;color:#94a3b8;white-space:nowrap;">
                    <%= tr.getCreatedAt() != null
                        ? tr.getCreatedAt().format(fmt) : "" %>
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
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
// ── Configuration ─────────────────────────────────────────────────────────────
const FEES = {
  INTERNAL:      parseFloat('<%= internalFee %>'),
  EXTERNAL:      parseFloat('<%= externalFee %>'),
  INTERNATIONAL: parseFloat('<%= intlFee %>')
};
const MAX_LIMIT   = parseFloat('<%= maxLimit %>');
const CUR_BALANCE = parseFloat('<%= account != null ? account.getBalance().toPlainString() : "0" %>');
let selectedType  = 'INTERNAL';

// ── Type selector ─────────────────────────────────────────────────────────────
function selectType(type, el) {
  selectedType = type;
  document.getElementById('transferTypeInput').value = type;

  // Update card highlights
  ['INTERNAL','EXTERNAL','INTERNATIONAL'].forEach(function(t) {
    const card  = document.getElementById('card-' + t);
    const badge = document.getElementById('badge-' + t);
    if (card)  card.classList.toggle('selected', t === type);
    if (badge) badge.style.display = t === type ? 'block' : 'none';
  });

  // Show / hide form sections
  document.getElementById('internalSection').style.display =
      type === 'INTERNAL'      ? 'block' : 'none';
  document.getElementById('externalSection').style.display =
      type === 'EXTERNAL'      ? 'block' : 'none';
  document.getElementById('intlSection').style.display     =
      type === 'INTERNATIONAL' ? 'block' : 'none';

  // Update header title
  const titles = {
    INTERNAL:      'Recipient Details – Internal Transfer',
    EXTERNAL:      'Recipient Details – External Bank Transfer',
    INTERNATIONAL: 'Recipient Details – SWIFT International Transfer'
  };
  document.getElementById('step2Title').textContent = titles[type];

  // PDF button only for internal (instant)
  const isInternal = type === 'INTERNAL';
  document.getElementById('pdfBtn').style.display          = isInternal ? 'flex'  : 'none';
  document.getElementById('instantNotice').style.display   = isInternal ? 'block' : 'none';
  document.getElementById('approvalNotice').style.display  = isInternal ? 'none'  : 'block';

  const labels = {
    INTERNAL:      '<i class="bi bi-send-fill"></i> Transfer Now',
    EXTERNAL:      '<i class="bi bi-send"></i> Submit for Approval',
    INTERNATIONAL: '<i class="bi bi-globe2"></i> Submit SWIFT Request'
  };
  document.getElementById('submitLabel').innerHTML = labels[type];

  // Update fee display
  document.getElementById('summaryFee').textContent = FEES[type].toFixed(2);
  recalcFee();
}

// ── Get active amount field value ─────────────────────────────────────────────
function getActiveAmount() {
  const ids = {
    INTERNAL:      'intAmountInput',
    EXTERNAL:      'extAmountInput',
    INTERNATIONAL: 'intlAmountInput'
  };
  const el = document.getElementById(ids[selectedType]);
  return el ? (parseFloat(el.value) || 0) : 0;
}

// ── Live fee recalculator ─────────────────────────────────────────────────────
function recalcFee() {
  const amount = getActiveAmount();
  const fee    = FEES[selectedType] || 0;
  const total  = amount + fee;
  const after  = CUR_BALANCE - total;

  document.getElementById('summaryAmount').textContent = amount.toFixed(2);
  document.getElementById('summaryFee').textContent    = fee.toFixed(2);
  document.getElementById('summaryTotal').textContent  = total.toFixed(2);

  const balEl = document.getElementById('summaryBalAfter');
  if (balEl) {
    balEl.textContent = 'ETB ' + Math.max(0, after).toFixed(2);
    balEl.style.color = after < 0 ? '#ef4444' : '#10b981';
  }
}

// ── Field helpers ──────────────────────────────────────────────────────────────
function markValid(id)    { const el = document.getElementById(id); if(el){ el.classList.add('valid');   el.classList.remove('invalid'); } }
function markInvalid(id)  { const el = document.getElementById(id); if(el){ el.classList.add('invalid'); el.classList.remove('valid');   } }
function showErr(id, show){ const el = document.getElementById(id); if(el) el.style.display = show ? 'block' : 'none'; }
function notBlank(id)     { const el = document.getElementById(id); return el && el.value.trim().length > 0; }
function getVal(id)       { const el = document.getElementById(id); return el ? el.value.trim() : ''; }

// ── Validate each transfer type ───────────────────────────────────────────────
function validateInternal() {
  let ok = true;
  const acc = getVal('intReceiver');
  if (!acc || !/^ACC[0-9]{10}$/.test(acc.toUpperCase())) {
    markInvalid('intReceiver'); showErr('intReceiverErr', true); ok = false;
  } else { markValid('intReceiver'); showErr('intReceiverErr', false); }

  const a = getActiveAmount();
  const errMsg = a <= 0 ? 'Amount must be greater than zero.' :
                 a > MAX_LIMIT ? 'Amount exceeds maximum limit.' :
                 (a + FEES.INTERNAL) > CUR_BALANCE
                    ? 'Insufficient balance. Need ETB ' + (a + FEES.INTERNAL).toFixed(2) : '';
  if (errMsg) {
    markInvalid('intAmountInput');
    document.getElementById('intAmountErr').textContent = errMsg;
    showErr('intAmountErr', true); ok = false;
  } else { markValid('intAmountInput'); showErr('intAmountErr', false); }

  return ok;
}

function validateExternal() {
  let ok = true;
  if (!notBlank('extReceiver'))  { markInvalid('extReceiver');  showErr('extReceiverErr', true); ok=false; }
  else                            { markValid('extReceiver');    showErr('extReceiverErr',false); }
  if (!notBlank('extBenef'))     { markInvalid('extBenef');     showErr('extBenefErr', true);    ok=false; }
  else                            { markValid('extBenef');       showErr('extBenefErr',false);    }
  if (!notBlank('extBankName'))  { markInvalid('extBankName');  showErr('extBankErr', true);     ok=false; }
  else                            { markValid('extBankName');    showErr('extBankErr',false);     }

  const a = getActiveAmount();
  const errMsg = a <= 0 ? 'Amount must be greater than zero.' :
                 a > MAX_LIMIT ? 'Amount exceeds maximum limit.' :
                 (a + FEES.EXTERNAL) > CUR_BALANCE
                    ? 'Insufficient balance. Need ETB ' + (a + FEES.EXTERNAL).toFixed(2) : '';
  if (errMsg) {
    markInvalid('extAmountInput');
    document.getElementById('extAmountErr').textContent = errMsg;
    showErr('extAmountErr', true); ok = false;
  } else { markValid('extAmountInput'); showErr('extAmountErr', false); }

  return ok;
}

function validateIntl() {
  let ok = true;
  if (!notBlank('intlBenef'))    { markInvalid('intlBenef');    showErr('intlBenefErr',true);   ok=false; }
  else                            { markValid('intlBenef');      showErr('intlBenefErr',false);  }
  if (!notBlank('intlIban'))     { markInvalid('intlIban');     showErr('intlIbanErr',true);    ok=false; }
  else                            { markValid('intlIban');       showErr('intlIbanErr',false);   }
  if (!notBlank('intlBankName')) { markInvalid('intlBankName'); showErr('intlBankErr',true);    ok=false; }
  else                            { markValid('intlBankName');   showErr('intlBankErr',false);   }
  if (!notBlank('intlCountry'))  { markInvalid('intlCountry');  showErr('intlCountryErr',true); ok=false; }
  else                            { markValid('intlCountry');    showErr('intlCountryErr',false);}

  const swift = getVal('intlSwift');
  if (!swift || ![8,11].includes(swift.length)) {
    markInvalid('intlSwift'); showErr('intlSwiftErr', true); ok = false;
  } else { markValid('intlSwift'); showErr('intlSwiftErr', false); }

  const a = getActiveAmount();
  const errMsg = a <= 0 ? 'Amount must be greater than zero.' :
                 a > MAX_LIMIT ? 'Amount exceeds maximum limit.' :
                 (a + FEES.INTERNATIONAL) > CUR_BALANCE
                    ? 'Insufficient balance. Need ETB ' + (a + FEES.INTERNATIONAL).toFixed(2) : '';
  if (errMsg) {
    markInvalid('intlAmountInput');
    document.getElementById('intlAmountErr').textContent = errMsg;
    showErr('intlAmountErr', true); ok = false;
  } else { markValid('intlAmountInput'); showErr('intlAmountErr', false); }

  return ok;
}

// ── Main submit function ──────────────────────────────────────────────────────
function submitTransfer(pdf) {
  let valid = false;
  if      (selectedType === 'INTERNAL')      valid = validateInternal();
  else if (selectedType === 'EXTERNAL')      valid = validateExternal();
  else if (selectedType === 'INTERNATIONAL') valid = validateIntl();

  if (!valid) {
    const firstInvalid = document.querySelector('.invalid');
    if (firstInvalid) firstInvalid.scrollIntoView({ behavior:'smooth', block:'center' });
    return;
  }

  // ── CRITICAL FIX: copy active amount into the hidden amount field ──────────
  const amount = getActiveAmount();
  document.getElementById('hiddenAmount').value = amount.toFixed(2);

  // Set PDF flag
  document.getElementById('pdfFlag').value = pdf ? 'true' : 'false';

  // Confirmation dialog
  const fee   = FEES[selectedType];
  const total = (amount + fee).toFixed(2);
  const msgs  = {
    INTERNAL:
      'Confirm transfer:\n\n'
      + '• Amount: ETB ' + amount.toFixed(2) + '\n'
      + '• Fee:    ETB ' + fee.toFixed(2) + '\n'
      + '• Total:  ETB ' + total + '\n\n'
      + 'Balance will be deducted IMMEDIATELY. Proceed?',
    EXTERNAL:
      'Submit external transfer request?\n\n'
      + '• Amount: ETB ' + amount.toFixed(2) + '\n'
      + '• Fee:    ETB ' + fee.toFixed(2) + '\n\n'
      + 'Balance deducted ONLY after manager approval.\nProceed?',
    INTERNATIONAL:
      'Submit SWIFT transfer request?\n\n'
      + '• Amount: ETB ' + amount.toFixed(2) + '\n'
      + '• Fee:    ETB ' + fee.toFixed(2) + '\n\n'
      + 'Balance deducted ONLY after manager approval.\nProceed?'
  };

  if (confirm(msgs[selectedType])) {
    document.getElementById('transferForm').submit();
  }
}

// ── Auto-uppercase helpers ────────────────────────────────────────────────────
['intReceiver','intlIban','intlSwift'].forEach(function(id) {
  const el = document.getElementById(id);
  if (el) el.addEventListener('input', function() {
    this.value = this.value.toUpperCase();
  });
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  recalcFee();
});
</script>
</body>
</html>