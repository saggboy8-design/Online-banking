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
  int userId = (int) session.getAttribute("userId");

  AccountDAO  accountDAO  = new AccountDAO();
  TransferDAO transferDAO = new TransferDAO();
  Account     account     = null;
  List<Transfer> myTransfers = null;
  try {
      account     = accountDAO.findByUserId(userId);
      if (account != null)
          myTransfers = transferDAO.getByAccount(account.getId());
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
  double curBalance = account != null ? account.getBalance().doubleValue() : 0.0;
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
.tr-hero {
  background: linear-gradient(135deg,#0A1F44 0%,#1a3a6e 60%,#2563eb 100%);
  border-radius:16px;padding:1.5rem 2rem;color:#fff;
  margin-bottom:1.5rem;display:flex;align-items:center;
  justify-content:space-between;position:relative;overflow:hidden;
  box-shadow:0 8px 32px rgba(10,31,68,0.25);
}
.tr-hero::before{content:'';position:absolute;width:220px;height:220px;
  border-radius:50%;background:rgba(255,255,255,0.05);right:-50px;top:-70px;}
.tr-hero h2{font-size:1.2rem;font-weight:800;margin-bottom:4px;}
.tr-hero p {font-size:0.82rem;opacity:0.7;}
.bal-pill{background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.2);
  border-radius:12px;padding:0.7rem 1.2rem;text-align:right;position:relative;z-index:2;}
.bal-pill .bl{font-size:0.7rem;opacity:0.7;}
.bal-pill .bv{font-size:1.3rem;font-weight:800;}

.type-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:0.8rem;margin-bottom:1.5rem;}
.tc{border:2px solid #e2e8f0;border-radius:14px;padding:1rem;
  cursor:pointer;transition:all 0.25s;background:#fff;text-align:center;position:relative;}
.tc:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,0.1);}
.tc.sel{box-shadow:0 0 0 3px rgba(37,99,235,0.15);}
.tc-badge{position:absolute;top:7px;right:7px;font-size:0.65rem;font-weight:700;
  padding:2px 8px;border-radius:10px;background:#2563eb;color:#fff;display:none;}
.tc.sel .tc-badge{display:block;}
.tc-ico{width:46px;height:46px;border-radius:12px;margin:0 auto 0.5rem;
  display:flex;align-items:center;justify-content:center;font-size:1.2rem;transition:transform 0.2s;}
.tc:hover .tc-ico,.tc.sel .tc-ico{transform:scale(1.1);}
.tc h4{font-size:0.86rem;font-weight:800;color:#0A1F44;margin-bottom:2px;}
.tc p {font-size:0.72rem;color:#94a3b8;}
.tc-fee{font-size:0.7rem;font-weight:700;margin-top:5px;padding:2px 8px;border-radius:10px;display:inline-block;}
.tc-speed{font-size:0.7rem;font-weight:700;margin-top:4px;}
.tc-int{border-color:#dcfce7;} .tc-int.sel{border-color:#10b981;background:#f0fdf4;}
.tc-int .tc-ico{background:#dcfce7;color:#16a34a;}
.tc-ext{border-color:#dbeafe;} .tc-ext.sel{border-color:#2563eb;background:#eff6ff;}
.tc-ext .tc-ico{background:#dbeafe;color:#2563eb;}
.tc-itl{border-color:#fdf4ff;} .tc-itl.sel{border-color:#9333ea;background:#fdf4ff;}
.tc-itl .tc-ico{background:#fdf4ff;color:#9333ea;}

.frm-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,0.07);
  overflow:hidden;margin-bottom:1.5rem;}
.frm-head{background:#0A1F44;color:#fff;padding:1rem 1.5rem;
  font-weight:700;font-size:0.92rem;display:flex;align-items:center;gap:8px;}
.frm-head .sn{width:24px;height:24px;border-radius:50%;background:rgba(255,255,255,0.2);
  display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:800;flex-shrink:0;}
.frm-body{padding:1.5rem;}

.g2{display:grid;grid-template-columns:1fr 1fr;gap:1rem;}
.sp2{grid-column:span 2;}

.fg{display:flex;flex-direction:column;margin-bottom:0;}
.fg label{font-size:0.8rem;font-weight:700;color:#0A1F44;margin-bottom:5px;
  display:flex;align-items:center;gap:5px;}
.req{color:#ef4444;}
.iw{position:relative;}
.iw .fi{position:absolute;left:11px;top:50%;transform:translateY(-50%);
  color:#94a3b8;font-size:0.95rem;pointer-events:none;}
.inp{width:100%;padding:0.68rem 0.9rem 0.68rem 2.3rem;border:1.5px solid #e2e8f0;
  border-radius:10px;font-size:0.88rem;font-family:inherit;color:#1e293b;
  outline:none;transition:all 0.2s;background:#fff;}
.inp:focus{border-color:#2563eb;box-shadow:0 0 0 3px rgba(37,99,235,0.1);}
.inp.ok {border-color:#10b981;background:#f0fdf4;}
.inp.er {border-color:#ef4444;background:#fef2f2;}
.hint{font-size:0.72rem;color:#94a3b8;margin-top:3px;}
.err-msg{font-size:0.72rem;color:#ef4444;font-weight:600;margin-top:4px;
  padding:3px 8px;background:#fef2f2;border-radius:6px;display:none;}
.ok-msg{font-size:0.72rem;color:#10b981;font-weight:600;margin-top:4px;
  padding:3px 8px;background:#f0fdf4;border-radius:6px;display:none;}

.pend-notice{background:#fef3c7;border:1px solid #fde68a;border-left:4px solid #f59e0b;
  border-radius:10px;padding:0.8rem 1rem;font-size:0.83rem;color:#92400e;
  display:flex;align-items:flex-start;gap:8px;margin-bottom:1.2rem;}

.sample-box{background:linear-gradient(135deg,#f0fdf4,#dcfce7);border:1px solid #bbf7d0;
  border-radius:12px;padding:1rem;margin-bottom:1rem;}
.sample-box h5{font-size:0.8rem;font-weight:800;color:#15803d;margin-bottom:0.5rem;
  display:flex;align-items:center;gap:6px;}
.sample-row{display:flex;justify-content:space-between;align-items:center;
  font-size:0.78rem;padding:3px 0;border-bottom:1px solid rgba(0,0,0,0.05);}
.sample-row:last-child{border-bottom:none;}
.sample-row .sk{color:#475569;font-weight:600;}
.sample-row .sv{color:#15803d;font-weight:700;}
.sample-fill-btn{background:#10b981;color:#fff;border:none;border-radius:8px;
  padding:5px 12px;font-size:0.75rem;font-weight:700;cursor:pointer;font-family:inherit;
  margin-top:0.5rem;display:inline-flex;align-items:center;gap:5px;transition:all 0.2s;}
.sample-fill-btn:hover{background:#059669;transform:translateY(-1px);}

.fee-box{background:linear-gradient(135deg,#f8fafc,#eff6ff);
  border:1px solid #bfdbfe;border-radius:12px;padding:1rem 1.2rem;margin-top:0.5rem;}
.fee-row{display:flex;justify-content:space-between;font-size:0.84rem;padding:4px 0;}
.fee-row .fl{color:#475569;display:flex;align-items:center;gap:5px;}
.fee-row .fv{font-weight:700;color:#0A1F44;}
.fee-div{height:1px;background:#bfdbfe;margin:6px 0;}
.fee-tot .fl{font-weight:700;color:#0A1F44;}
.fee-tot .fv{color:#ef4444;font-size:1rem;font-weight:800;}
.fee-aft .fv{color:#10b981;font-weight:700;}

.bal-warn{background:#fef2f2;border:1px solid #fecaca;border-left:3px solid #ef4444;
  border-radius:8px;padding:0.7rem;font-size:0.8rem;color:#991b1b;
  margin-top:0.5rem;display:none;align-items:center;gap:6px;}

.btn-sub{display:flex;align-items:center;justify-content:center;gap:8px;
  padding:0.85rem 2rem;border:none;border-radius:12px;font-size:0.95rem;
  font-weight:800;cursor:pointer;font-family:inherit;transition:all 0.3s;width:100%;}
.btn-blue{background:linear-gradient(135deg,#0A1F44,#2563eb);color:#fff;
  box-shadow:0 4px 15px rgba(10,31,68,0.25);}
.btn-blue:hover{transform:translateY(-2px);box-shadow:0 10px 28px rgba(10,31,68,0.35);}
.btn-green{background:linear-gradient(135deg,#10b981,#059669);color:#fff;
  box-shadow:0 4px 12px rgba(16,185,129,0.25);}
.btn-green:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(16,185,129,0.35);}

.ald{border-radius:10px;padding:0.9rem 1rem;margin-bottom:1.2rem;
  font-size:0.88rem;display:flex;align-items:flex-start;gap:8px;}
.ald-ok {background:#f0fdf4;border:1px solid #bbf7d0;border-left:4px solid #10b981;color:#166534;}
.ald-err{background:#fef2f2;border:1px solid #fecaca;border-left:4px solid #ef4444;color:#991b1b;}

.notice-instant{margin-top:0.8rem;font-size:0.78rem;color:#10b981;font-weight:600;}
.notice-approval{display:none;margin-top:0.8rem;background:#fef3c7;border:1px solid #fde68a;
  border-left:3px solid #f59e0b;border-radius:8px;padding:0.7rem;font-size:0.78rem;color:#92400e;}

/* Debug indicator (remove in production) */
.type-indicator{background:#0A1F44;color:#fff;font-size:0.72rem;font-weight:600;
  padding:4px 12px;border-radius:20px;display:inline-flex;align-items:center;gap:5px;margin-bottom:0.8rem;}

.hist-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,0.07);overflow:hidden;}
.hist-head{background:#0A1F44;color:#fff;padding:1rem 1.5rem;font-weight:700;
  font-size:0.92rem;display:flex;align-items:center;gap:8px;}
.hist-head a{margin-left:auto;color:rgba(255,255,255,0.7);font-size:0.78rem;text-decoration:none;}
.t-tbl{width:100%;border-collapse:collapse;}
.t-tbl thead tr{background:#f8fafc;}
.t-tbl th{padding:0.6rem 0.8rem;font-size:0.72rem;font-weight:700;color:#94a3b8;
  text-transform:uppercase;letter-spacing:0.5px;border-bottom:2px solid #f1f5f9;}
.t-tbl td{padding:0.7rem 0.8rem;font-size:0.83rem;border-bottom:1px solid #f8fafc;vertical-align:middle;}
.t-tbl tbody tr:hover{background:#f8fafc;}
.t-tbl tbody tr:last-child td{border-bottom:none;}
.spill{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;
  border-radius:20px;font-size:0.7rem;font-weight:700;}
.sp-ok{background:#dcfce7;color:#15803d;}
.sp-pend{background:#fef3c7;color:#92400e;}
.sp-rej{background:#fef2f2;color:#dc2626;}
.sp-fail{background:#f3f4f6;color:#6b7280;}

@media(max-width:768px){
  .type-grid,.g2{grid-template-columns:1fr;}
  .sp2{grid-column:span 1;}
}
</style>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title">
      <i class="bi bi-arrow-left-right"></i> Transfer Funds
    </div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">

    <% if (request.getAttribute("error") != null) { %>
      <div class="ald ald-err">
        <i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;font-size:1.1rem;"></i>
        <div><strong>Error:</strong> <%= request.getAttribute("error") %></div>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="ald ald-ok">
        <i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;font-size:1.1rem;"></i>
        <div><%= request.getAttribute("success") %></div>
      </div>
    <% } %>

    <!-- Hero -->
    <div class="tr-hero">
      <div style="position:relative;z-index:2;">
        <h2><i class="bi bi-arrow-left-right"></i> Transfer Funds</h2>
        <p>Internal: instant &nbsp;·&nbsp; External &amp; SWIFT: manager approval required</p>
      </div>
      <% if (account != null) { %>
      <div class="bal-pill">
        <div class="bl">AVAILABLE BALANCE</div>
        <div class="bv">ETB <%= account.getBalance().toPlainString() %></div>
        <div style="font-size:0.68rem;opacity:0.6;margin-top:2px;">
          <i class="bi bi-credit-card"></i> <%= account.getAccountNumber() %>
        </div>
      </div>
      <% } %>
    </div>

    <!-- Step 1: Choose Type -->
    <div class="frm-card">
      <div class="frm-head">
        <span class="sn">1</span> Choose Transfer Type
      </div>
      <div class="frm-body">
        <!--
          FIX: onclick calls switchType() NOT selType()
          Variable is named activeType, function is named switchType — no conflict
        -->
        <div class="type-grid">
          <div class="tc tc-int sel" id="card-INTERNAL"
               onclick="switchType('INTERNAL')">
            <span class="tc-badge" id="badge-INTERNAL">✓ Selected</span>
            <div class="tc-ico"><i class="bi bi-building-fill"></i></div>
            <h4>Internal Transfer</h4>
            <p>Between Gojjam Bank accounts</p>
            <div class="tc-fee" style="background:#dcfce7;color:#15803d;">
              Fee: ETB <%= internalFee %>
            </div>
            <div class="tc-speed" style="color:#10b981;">
              <i class="bi bi-lightning-fill"></i> Instant processing
            </div>
          </div>

          <div class="tc tc-ext" id="card-EXTERNAL"
               onclick="switchType('EXTERNAL')">
            <span class="tc-badge" id="badge-EXTERNAL">✓ Selected</span>
            <div class="tc-ico"><i class="bi bi-bank2"></i></div>
            <h4>External Bank</h4>
            <p>To other Ethiopian banks</p>
            <div class="tc-fee" style="background:#dbeafe;color:#1d4ed8;">
              Fee: ETB <%= externalFee %>
            </div>
            <div class="tc-speed" style="color:#f59e0b;">
              <i class="bi bi-clock"></i> Manager approval
            </div>
          </div>

          <div class="tc tc-itl" id="card-INTERNATIONAL"
               onclick="switchType('INTERNATIONAL')">
            <span class="tc-badge" id="badge-INTERNATIONAL">✓ Selected</span>
            <div class="tc-ico"><i class="bi bi-globe2"></i></div>
            <h4>SWIFT International</h4>
            <p>Worldwide wire transfer</p>
            <div class="tc-fee" style="background:#fdf4ff;color:#9333ea;">
              Fee: ETB <%= intlFee %>
            </div>
            <div class="tc-speed" style="color:#f59e0b;">
              <i class="bi bi-clock"></i> Manager approval
            </div>
          </div>
        </div>

        <!-- Active type indicator (helps user confirm selection) -->
        <div class="type-indicator">
          <i class="bi bi-arrow-right-circle-fill"></i>
          Active: <span id="activeTypeLabel">Internal Transfer</span>
        </div>
      </div>
    </div>

    <!--
      ═══════════════════════════════════════════════════════════
      FORM
      ALL visible inputs have NO name attribute.
      All hidden inputs carry the POST data.
      JavaScript copies values before submit.
      ═══════════════════════════════════════════════════════════
    -->
    <form method="post"
          action="${pageContext.request.contextPath}/customer/transfer"
          id="tForm" novalidate>

      <!-- ══ HIDDEN FIELDS — these are the only ones submitted ══ -->
      <input type="hidden" name="csrfToken"       value="${csrfToken}"/>
      <input type="hidden" name="transferType"    id="h_type"        value="INTERNAL"/>
      <input type="hidden" name="receiverAccount" id="h_receiver"    value=""/>
      <input type="hidden" name="amount"          id="h_amount"      value=""/>
      <input type="hidden" name="description"     id="h_description" value=""/>
      <input type="hidden" name="beneficiaryName" id="h_beneficiary" value=""/>
      <input type="hidden" name="bankName"        id="h_bankName"    value=""/>
      <input type="hidden" name="swiftCode"       id="h_swift"       value=""/>
      <input type="hidden" name="country"         id="h_country"     value=""/>
      <input type="hidden" name="downloadPdf"     id="h_pdf"         value="false"/>

      <!-- Step 2: Details -->
      <div class="frm-card">
        <div class="frm-head">
          <span class="sn">2</span>
          <span id="step2Title">Recipient Details – Internal Transfer</span>
        </div>
        <div class="frm-body">

          <!-- ══ INTERNAL ══════════════════════════════════════ -->
          <div id="sec-INTERNAL">
            <div class="g2">
              <div class="fg sp2">
                <label>
                  <i class="bi bi-credit-card" style="color:#2563eb;"></i>
                  Receiver Account Number <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-credit-card fi"></i>
                  <input type="text" id="v_int_receiver" class="inp"
                         placeholder="e.g. ACC1234567890"
                         maxlength="13"
                         oninput="this.value=this.value.toUpperCase();liveValidate()"/>
                </div>
                <div class="hint">Format: ACC followed by exactly 10 digits</div>
                <div class="err-msg" id="e_int_receiver"></div>
                <div class="ok-msg"  id="ok_int_receiver"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-cash-coin" style="color:#10b981;"></i>
                  Amount (ETB) <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-currency-exchange fi"></i>
                  <input type="number" id="v_int_amount" class="inp"
                         placeholder="e.g. 500.00"
                         min="1" step="0.01" max="<%= maxLimit %>"
                         oninput="recalcFees();liveValidate()"/>
                </div>
                <div class="err-msg" id="e_int_amount"></div>
                <div class="ok-msg"  id="ok_int_amount"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-chat-text" style="color:#94a3b8;"></i>
                  Description
                  <small style="color:#94a3b8;font-weight:400;">(optional)</small>
                </label>
                <div class="iw">
                  <i class="bi bi-chat-text fi"></i>
                  <input type="text" id="v_int_desc" class="inp"
                         placeholder="e.g. Rent payment for March" maxlength="200"/>
                </div>
              </div>
            </div>
          </div>

          <!-- ══ EXTERNAL ═══════════════════════════════════════ -->
          <div id="sec-EXTERNAL" style="display:none;">
            <div class="pend-notice">
              <i class="bi bi-info-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
              <div>
                <strong>Manager Approval Required.</strong>
                Balance deducted <strong>only after</strong> a manager approves.
                Rejected = zero balance change.
              </div>
            </div>

            <!-- Sample data -->
            <div class="sample-box">
              <h5><i class="bi bi-lightbulb-fill"></i> Sample Test Data</h5>
              <div class="sample-row">
                <span class="sk">Receiver Account</span>
                <span class="sv">EXT9876543210</span>
              </div>
              <div class="sample-row">
                <span class="sk">Beneficiary</span>
                <span class="sv">Abebe Girma Kebede</span>
              </div>
              <div class="sample-row">
                <span class="sk">Bank</span>
                <span class="sv">Commercial Bank of Ethiopia</span>
              </div>
              <div class="sample-row">
                <span class="sk">Amount</span>
                <span class="sv">ETB 2,000.00</span>
              </div>
              <button type="button" class="sample-fill-btn" onclick="fillExtSample()">
                <i class="bi bi-lightning-fill"></i> Auto-fill Sample Data
              </button>
            </div>

            <div class="g2">
              <div class="fg">
                <label>
                  <i class="bi bi-credit-card" style="color:#2563eb;"></i>
                  Receiver Account Number <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-credit-card fi"></i>
                  <input type="text" id="v_ext_receiver" class="inp"
                         placeholder="e.g. EXT9876543210"
                         oninput="liveValidate()"/>
                </div>
                <div class="err-msg" id="e_ext_receiver"></div>
                <div class="ok-msg"  id="ok_ext_receiver"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-person-fill" style="color:#2563eb;"></i>
                  Beneficiary Full Name <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-person-fill fi"></i>
                  <input type="text" id="v_ext_benef" class="inp"
                         placeholder="e.g. Abebe Girma Kebede" maxlength="200"
                         oninput="liveValidate()"/>
                </div>
                <div class="err-msg" id="e_ext_benef"></div>
                <div class="ok-msg"  id="ok_ext_benef"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-bank2" style="color:#2563eb;"></i>
                  Destination Bank Name <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-bank2 fi"></i>
                  <input type="text" id="v_ext_bank" class="inp"
                         placeholder="e.g. Commercial Bank of Ethiopia" maxlength="200"
                         oninput="liveValidate()"/>
                </div>
                <div class="err-msg" id="e_ext_bank"></div>
                <div class="ok-msg"  id="ok_ext_bank"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-cash-coin" style="color:#10b981;"></i>
                  Amount (ETB) <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-currency-exchange fi"></i>
                  <input type="number" id="v_ext_amount" class="inp"
                         placeholder="e.g. 2000.00"
                         min="1" step="0.01" max="<%= maxLimit %>"
                         oninput="recalcFees();liveValidate()"/>
                </div>
                <div class="err-msg" id="e_ext_amount"></div>
                <div class="ok-msg"  id="ok_ext_amount"></div>
              </div>

              <div class="fg sp2">
                <label>
                  <i class="bi bi-chat-text" style="color:#94a3b8;"></i>
                  Description <small style="color:#94a3b8;font-weight:400;">(optional)</small>
                </label>
                <div class="iw">
                  <i class="bi bi-chat-text fi"></i>
                  <input type="text" id="v_ext_desc" class="inp"
                         placeholder="e.g. Payment for services" maxlength="200"/>
                </div>
              </div>
            </div>
          </div>

          <!-- ══ INTERNATIONAL (SWIFT) ══════════════════════════ -->
          <div id="sec-INTERNATIONAL" style="display:none;">
            <div class="pend-notice">
              <i class="bi bi-globe2" style="flex-shrink:0;margin-top:1px;color:#9333ea;"></i>
              <div>
                <strong>SWIFT International Transfer — Manager Approval Required.</strong>
                Balance deducted <strong>only after</strong> manager approves.
                Rejected = zero balance change.
              </div>
            </div>

            <!-- Sample data -->
            <div class="sample-box">
              <h5><i class="bi bi-lightbulb-fill"></i> Sample SWIFT Test Data</h5>
              <div class="sample-row">
                <span class="sk">Beneficiary</span>
                <span class="sv">John Michael Smith</span>
              </div>
              <div class="sample-row">
                <span class="sk">IBAN</span>
                <span class="sv">GB29NWBK60161331926819</span>
              </div>
              <div class="sample-row">
                <span class="sk">SWIFT/BIC</span>
                <span class="sv">HBUKGB4B (8 chars)</span>
              </div>
              <div class="sample-row">
                <span class="sk">Bank</span>
                <span class="sv">HSBC London</span>
              </div>
              <div class="sample-row">
                <span class="sk">Country</span>
                <span class="sv">United Kingdom</span>
              </div>
              <div class="sample-row">
                <span class="sk">Amount</span>
                <span class="sv">ETB 5,000.00</span>
              </div>
              <button type="button" class="sample-fill-btn" onclick="fillIntlSample()">
                <i class="bi bi-lightning-fill"></i> Auto-fill Sample Data
              </button>
            </div>

            <div class="g2">
              <div class="fg">
                <label>
                  <i class="bi bi-person-fill" style="color:#9333ea;"></i>
                  Beneficiary Full Name <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-person-fill fi"></i>
                  <input type="text" id="v_itl_benef" class="inp"
                         placeholder="e.g. John Michael Smith" maxlength="200"
                         oninput="liveValidate()"/>
                </div>
                <div class="err-msg" id="e_itl_benef"></div>
                <div class="ok-msg"  id="ok_itl_benef"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-123" style="color:#9333ea;"></i>
                  IBAN / Account Number <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-123 fi"></i>
                  <input type="text" id="v_itl_iban" class="inp"
                         placeholder="e.g. GB29NWBK60161331926819"
                         style="text-transform:uppercase;letter-spacing:1px;"
                         oninput="this.value=this.value.toUpperCase();liveValidate()"/>
                </div>
                <div class="err-msg" id="e_itl_iban"></div>
                <div class="ok-msg"  id="ok_itl_iban"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-broadcast" style="color:#9333ea;"></i>
                  SWIFT / BIC Code <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-broadcast fi"></i>
                  <input type="text" id="v_itl_swift" class="inp"
                         placeholder="e.g. HBUKGB4B" maxlength="11"
                         style="text-transform:uppercase;letter-spacing:2px;font-weight:700;"
                         oninput="this.value=this.value.toUpperCase();liveValidate()"/>
                </div>
                <div class="hint">Must be exactly 8 or 11 characters (e.g. HBUKGB4B)</div>
                <div class="err-msg" id="e_itl_swift"></div>
                <div class="ok-msg"  id="ok_itl_swift"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-bank2" style="color:#9333ea;"></i>
                  Destination Bank Name <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-bank2 fi"></i>
                  <input type="text" id="v_itl_bank" class="inp"
                         placeholder="e.g. HSBC London" maxlength="200"
                         oninput="liveValidate()"/>
                </div>
                <div class="err-msg" id="e_itl_bank"></div>
                <div class="ok-msg"  id="ok_itl_bank"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-geo-alt-fill" style="color:#9333ea;"></i>
                  Destination Country <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-geo-alt-fill fi"></i>
                  <input type="text" id="v_itl_country" class="inp"
                         placeholder="e.g. United Kingdom" maxlength="100"
                         oninput="liveValidate()"/>
                </div>
                <div class="err-msg" id="e_itl_country"></div>
                <div class="ok-msg"  id="ok_itl_country"></div>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-cash-coin" style="color:#10b981;"></i>
                  Amount (ETB) <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-currency-exchange fi"></i>
                  <input type="number" id="v_itl_amount" class="inp"
                         placeholder="e.g. 5000.00"
                         min="1" step="0.01" max="<%= maxLimit %>"
                         oninput="recalcFees();liveValidate()"/>
                </div>
                <div class="err-msg" id="e_itl_amount"></div>
                <div class="ok-msg"  id="ok_itl_amount"></div>
              </div>

              <div class="fg sp2">
                <label>
                  <i class="bi bi-chat-text" style="color:#94a3b8;"></i>
                  Description <small style="color:#94a3b8;font-weight:400;">(optional)</small>
                </label>
                <div class="iw">
                  <i class="bi bi-chat-text fi"></i>
                  <input type="text" id="v_itl_desc" class="inp"
                         placeholder="e.g. Business payment for contract #2024-001"
                         maxlength="200"/>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>

      <!-- Step 3: Fee & Submit -->
      <div class="frm-card">
        <div class="frm-head">
          <span class="sn">3</span> Fee Summary &amp; Confirm
        </div>
        <div class="frm-body">
          <div class="g2">
            <div>
              <div class="fee-box">
                <div class="fee-row">
                  <span class="fl"><i class="bi bi-cash"></i> Transfer Amount</span>
                  <span class="fv">ETB <span id="fs-amt">0.00</span></span>
                </div>
                <div class="fee-row">
                  <span class="fl"><i class="bi bi-tag"></i> Service Fee</span>
                  <span class="fv" style="color:#f59e0b;">
                    ETB <span id="fs-fee"><%= internalFee %></span>
                  </span>
                </div>
                <div class="fee-div"></div>
                <div class="fee-row fee-tot">
                  <span class="fl"><i class="bi bi-calculator"></i> Total Deduction</span>
                  <span class="fv">ETB <span id="fs-total">0.00</span></span>
                </div>
                <% if (account != null) { %>
                <div class="fee-div"></div>
                <div class="fee-row fee-aft">
                  <span class="fl" style="color:#10b981;font-weight:600;">
                    <i class="bi bi-wallet2"></i> Balance After
                  </span>
                  <span class="fv" id="fs-after">ETB <%= account.getBalance().toPlainString() %></span>
                </div>
                <% } %>
              </div>

              <div class="bal-warn" id="balWarn">
                <i class="bi bi-exclamation-triangle-fill"></i>
                &nbsp;Insufficient balance. Need ETB <span id="bw-need">0</span>.
              </div>

              <div class="notice-instant" id="notice-instant">
                <i class="bi bi-lightning-fill"></i> Processed <strong>instantly</strong>.
              </div>
              <div class="notice-approval" id="notice-approval">
                <i class="bi bi-clock-fill"></i>
                Balance deducted <strong>only after manager approves</strong>.
                Rejection = zero change.
              </div>
            </div>

            <div style="display:flex;flex-direction:column;justify-content:flex-end;gap:0.8rem;">
              <button type="button" class="btn-sub btn-blue" onclick="doSubmit(false)">
                <i class="bi bi-send-fill"></i>
                <span id="submitLabel">Submit Transfer</span>
              </button>
              <button type="button" id="pdfBtn"
                      class="btn-sub btn-green"
                      onclick="doSubmit(true)"
                      style="display:none;">
                <i class="bi bi-file-earmark-pdf-fill"></i>
                Submit &amp; Get PDF Receipt
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

    <!-- History -->
    <div class="hist-card">
      <div class="hist-head">
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
          <table class="t-tbl">
            <thead>
              <tr>
                <th>#</th><th>Type</th><th>Receiver</th><th>Beneficiary</th>
                <th>Bank</th><th>Amount (ETB)</th><th>Fee</th><th>Status</th><th>Date</th>
              </tr>
            </thead>
            <tbody>
              <% for (Transfer tr : myTransfers) { %>
                <tr>
                  <td><code style="font-size:0.75rem;background:#f1f5f9;padding:2px 6px;border-radius:4px;">
                    #<%= tr.getId() %></code></td>
                  <td>
                    <span style="font-size:0.72rem;font-weight:700;padding:2px 8px;border-radius:10px;
                          background:<%= "INTERNAL".equals(tr.getTransferType())?"#dcfce7":"EXTERNAL".equals(tr.getTransferType())?"#dbeafe":"#fdf4ff" %>;
                          color:<%= "INTERNAL".equals(tr.getTransferType())?"#15803d":"EXTERNAL".equals(tr.getTransferType())?"#1d4ed8":"#9333ea" %>;">
                      <%= tr.getTransferType() %>
                    </span>
                  </td>
                  <td><code style="font-size:0.78rem;"><%= tr.getReceiverAccount() %></code></td>
                  <td style="font-size:0.82rem;"><%= tr.getBeneficiaryName()!=null?tr.getBeneficiaryName():"—" %></td>
                  <td style="font-size:0.78rem;color:#475569;"><%= tr.getBankName()!=null?tr.getBankName():"—" %></td>
                  <td style="font-weight:700;color:#0A1F44;">ETB <%= tr.getAmount().toPlainString() %></td>
                  <td style="color:#f59e0b;font-size:0.82rem;">ETB <%= tr.getFee().toPlainString() %></td>
                  <td>
                    <span class="spill
                      <%= "SUCCESS".equals(tr.getStatus())?"sp-ok":"PENDING".equals(tr.getStatus())?"sp-pend":"REJECTED".equals(tr.getStatus())?"sp-rej":"sp-fail" %>">
                      <i class="bi bi-<%= "SUCCESS".equals(tr.getStatus())?"check-circle-fill":"PENDING".equals(tr.getStatus())?"clock-fill":"x-circle-fill" %>"
                         style="font-size:0.65rem;"></i>
                      <%= tr.getStatus() %>
                    </span>
                    <% if ("PENDING".equals(tr.getStatus())) { %>
                      <div style="font-size:0.68rem;color:#f59e0b;margin-top:2px;">Awaiting approval</div>
                    <% } %>
                    <% if ("REJECTED".equals(tr.getStatus())) { %>
                      <div style="font-size:0.68rem;color:#ef4444;margin-top:2px;">No funds deducted</div>
                    <% } %>
                  </td>
                  <td style="font-size:0.78rem;color:#94a3b8;white-space:nowrap;">
                    <%= tr.getCreatedAt()!=null?tr.getCreatedAt().format(fmt):"" %>
                  </td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>

  </div>
  <%@ include file="/jsp/includes/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
/* ═══════════════════════════════════════════════════════════════
   CRITICAL FIX:
   Variable = activeType  (string, tracks current selection)
   Function = switchType  (different name — NO conflict!)
═══════════════════════════════════════════════════════════════ */

const TR_FEES = {
  INTERNAL:      parseFloat('<%= internalFee %>'),
  EXTERNAL:      parseFloat('<%= externalFee %>'),
  INTERNATIONAL: parseFloat('<%= intlFee %>')
};
const TR_MAX = parseFloat('<%= maxLimit %>');
const TR_BAL = parseFloat('<%= curBalance %>');

/* activeType = the currently selected transfer type (string) */
var activeType = 'INTERNAL';

/* ── Switch transfer type ─────────────────────────────────── */
function switchType(type) {
  /* 1. Update the global variable */
  activeType = type;

  /* 2. Update card highlights */
  ['INTERNAL','EXTERNAL','INTERNATIONAL'].forEach(function(t) {
    var card  = document.getElementById('card-'  + t);
    var badge = document.getElementById('badge-' + t);
    var sec   = document.getElementById('sec-'   + t);
    if (card)  { if (t === type) card.classList.add('sel');    else card.classList.remove('sel'); }
    if (badge) badge.style.display = (t === type) ? 'block' : 'none';
    if (sec)   sec.style.display   = (t === type) ? 'block' : 'none';
  });

  /* 3. Update title */
  var titles = {
    INTERNAL:      'Recipient Details – Internal Transfer',
    EXTERNAL:      'Recipient Details – External Bank Transfer',
    INTERNATIONAL: 'Recipient Details – SWIFT International Transfer'
  };
  var el = document.getElementById('step2Title');
  if (el) el.textContent = titles[type];

  /* 4. Update active type label */
  var lbl = document.getElementById('activeTypeLabel');
  if (lbl) lbl.textContent = titles[type].replace('Recipient Details – ', '');

  /* 5. PDF / notice */
  var isInternal = (type === 'INTERNAL');
  var pdfBtn     = document.getElementById('pdfBtn');
  var noticeInst = document.getElementById('notice-instant');
  var noticeAppr = document.getElementById('notice-approval');
  if (pdfBtn)     pdfBtn.style.display     = isInternal ? 'flex'  : 'none';
  if (noticeInst) noticeInst.style.display = isInternal ? 'block' : 'none';
  if (noticeAppr) noticeAppr.style.display = isInternal ? 'none'  : 'block';

  /* 6. Submit label */
  var labels = {
    INTERNAL:      '<i class="bi bi-send-fill"></i>&nbsp; Transfer Now',
    EXTERNAL:      '<i class="bi bi-send"></i>&nbsp; Submit for Manager Approval',
    INTERNATIONAL: '<i class="bi bi-globe2"></i>&nbsp; Submit SWIFT Request'
  };
  var lel = document.getElementById('submitLabel');
  if (lel) lel.innerHTML = labels[type];

  /* 7. Update fee display */
  var feeEl = document.getElementById('fs-fee');
  if (feeEl) feeEl.textContent = TR_FEES[type].toFixed(2);

  recalcFees();
}

/* ── Get active amount value ─────────────────────────────── */
function getActiveAmt() {
  var ids = {
    INTERNAL:      'v_int_amount',
    EXTERNAL:      'v_ext_amount',
    INTERNATIONAL: 'v_itl_amount'
  };
  var el = document.getElementById(ids[activeType]);
  return el ? (parseFloat(el.value) || 0) : 0;
}

/* ── Recalculate fees live ───────────────────────────────── */
function recalcFees() {
  var amt   = getActiveAmt();
  var fee   = TR_FEES[activeType] || 0;
  var total = amt + fee;
  var after = TR_BAL - total;

  var amtEl   = document.getElementById('fs-amt');
  var totEl   = document.getElementById('fs-total');
  var afterEl = document.getElementById('fs-after');
  var warnEl  = document.getElementById('balWarn');
  var needEl  = document.getElementById('bw-need');

  if (amtEl)  amtEl.textContent  = amt.toFixed(2);
  if (totEl)  totEl.textContent  = total.toFixed(2);
  if (afterEl) {
    afterEl.textContent = 'ETB ' + Math.max(0, after).toFixed(2);
    afterEl.style.color = after < 0 ? '#ef4444' : '#10b981';
  }
  if (warnEl) {
    if (amt > 0 && total > TR_BAL) {
      if (needEl) needEl.textContent = total.toFixed(2);
      warnEl.style.display = 'flex';
    } else {
      warnEl.style.display = 'none';
    }
  }
}

/* ── Field helpers ────────────────────────────────────────── */
function fieldVal(id) {
  var el = document.getElementById(id);
  return el ? el.value.trim() : '';
}
function hasVal(id) { return fieldVal(id).length > 0; }

function markOk(inputId, errId, okId, msg) {
  var el = document.getElementById(inputId);
  var em = document.getElementById(errId);
  var om = document.getElementById(okId);
  if (el) { el.classList.add('ok'); el.classList.remove('er'); }
  if (em) em.style.display = 'none';
  if (om) { om.textContent = msg; om.style.display = 'block'; }
}
function markErr(inputId, errId, okId, msg) {
  var el = document.getElementById(inputId);
  var em = document.getElementById(errId);
  var om = document.getElementById(okId);
  if (el) { el.classList.add('er'); el.classList.remove('ok'); }
  if (em) { em.textContent = msg; em.style.display = 'block'; }
  if (om) om.style.display = 'none';
}
function clearField(inputId, errId, okId) {
  var el = document.getElementById(inputId);
  var em = document.getElementById(errId);
  var om = document.getElementById(okId);
  if (el) { el.classList.remove('ok','er'); }
  if (em) em.style.display = 'none';
  if (om) om.style.display = 'none';
}

/* ── Live validation (called on input events) ────────────── */
function liveValidate() {
  if      (activeType === 'INTERNAL')      runValidateInternal(false);
  else if (activeType === 'EXTERNAL')      runValidateExternal(false);
  else if (activeType === 'INTERNATIONAL') runValidateIntl(false);
}

/* ── Validate Internal (returns true/false) ──────────────── */
function runValidateInternal(strict) {
  var ok = true;
  var rec = fieldVal('v_int_receiver');

  if (!rec) {
    if (strict) markErr('v_int_receiver','e_int_receiver','ok_int_receiver','⚠ Account number is required');
    ok = false;
  } else if (!/^ACC[0-9]{10}$/.test(rec)) {
    markErr('v_int_receiver','e_int_receiver','ok_int_receiver',
      '⚠ Format must be ACC + 10 digits (e.g. ACC1234567890). You entered: ' + rec);
    ok = false;
  } else {
    markOk('v_int_receiver','e_int_receiver','ok_int_receiver','✔ Account number is valid');
  }

  var amt = getActiveAmt();
  if (amt <= 0) {
    if (strict) markErr('v_int_amount','e_int_amount','ok_int_amount','⚠ Enter a valid amount (min ETB 1)');
    ok = false;
  } else if (amt > TR_MAX) {
    markErr('v_int_amount','e_int_amount','ok_int_amount','⚠ Exceeds max limit of ETB ' + TR_MAX);
    ok = false;
  } else if (amt + TR_FEES.INTERNAL > TR_BAL) {
    markErr('v_int_amount','e_int_amount','ok_int_amount',
      '⚠ Insufficient balance. Need ETB ' + (amt + TR_FEES.INTERNAL).toFixed(2)
      + ' (amount + ETB ' + TR_FEES.INTERNAL + ' fee)');
    ok = false;
  } else {
    markOk('v_int_amount','e_int_amount','ok_int_amount',
      '✔ ETB ' + amt.toFixed(2) + ' + ETB ' + TR_FEES.INTERNAL.toFixed(2)
      + ' fee = ETB ' + (amt + TR_FEES.INTERNAL).toFixed(2));
  }
  return ok;
}

/* ── Validate External ───────────────────────────────────── */
function runValidateExternal(strict) {
  var ok = true;

  if (!hasVal('v_ext_receiver')) {
    if (strict) markErr('v_ext_receiver','e_ext_receiver','ok_ext_receiver','⚠ Receiver account is required');
    ok = false;
  } else { markOk('v_ext_receiver','e_ext_receiver','ok_ext_receiver','✔ Receiver account entered'); }

  if (!hasVal('v_ext_benef')) {
    if (strict) markErr('v_ext_benef','e_ext_benef','ok_ext_benef','⚠ Beneficiary name is required');
    ok = false;
  } else { markOk('v_ext_benef','e_ext_benef','ok_ext_benef','✔ Beneficiary entered'); }

  if (!hasVal('v_ext_bank')) {
    if (strict) markErr('v_ext_bank','e_ext_bank','ok_ext_bank','⚠ Bank name is required');
    ok = false;
  } else { markOk('v_ext_bank','e_ext_bank','ok_ext_bank','✔ Bank name entered'); }

  var amt = getActiveAmt();
  if (amt <= 0) {
    if (strict) markErr('v_ext_amount','e_ext_amount','ok_ext_amount','⚠ Enter a valid amount (min ETB 1)');
    ok = false;
  } else if (amt > TR_MAX) {
    markErr('v_ext_amount','e_ext_amount','ok_ext_amount','⚠ Exceeds maximum limit');
    ok = false;
  } else if (amt + TR_FEES.EXTERNAL > TR_BAL) {
    markErr('v_ext_amount','e_ext_amount','ok_ext_amount',
      '⚠ Insufficient balance. Need ETB ' + (amt + TR_FEES.EXTERNAL).toFixed(2));
    ok = false;
  } else {
    markOk('v_ext_amount','e_ext_amount','ok_ext_amount',
      '✔ ETB ' + amt.toFixed(2) + ' + ETB ' + TR_FEES.EXTERNAL + ' fee = ETB '
      + (amt + TR_FEES.EXTERNAL).toFixed(2));
  }
  return ok;
}

/* ── Validate International ──────────────────────────────── */
function runValidateIntl(strict) {
  var ok = true;

  if (!hasVal('v_itl_benef')) {
    if (strict) markErr('v_itl_benef','e_itl_benef','ok_itl_benef','⚠ Beneficiary name is required');
    ok = false;
  } else { markOk('v_itl_benef','e_itl_benef','ok_itl_benef','✔ Beneficiary entered'); }

  if (!hasVal('v_itl_iban')) {
    if (strict) markErr('v_itl_iban','e_itl_iban','ok_itl_iban','⚠ IBAN or account number is required');
    ok = false;
  } else { markOk('v_itl_iban','e_itl_iban','ok_itl_iban','✔ IBAN entered'); }

  var swift = fieldVal('v_itl_swift');
  if (!swift) {
    if (strict) markErr('v_itl_swift','e_itl_swift','ok_itl_swift','⚠ SWIFT/BIC code is required');
    ok = false;
  } else if (swift.length !== 8 && swift.length !== 11) {
    markErr('v_itl_swift','e_itl_swift','ok_itl_swift',
      '⚠ SWIFT/BIC must be 8 or 11 characters. You entered ' + swift.length + ' characters: "' + swift + '"');
    ok = false;
  } else {
    markOk('v_itl_swift','e_itl_swift','ok_itl_swift','✔ SWIFT/BIC valid (' + swift.length + ' chars)');
  }

  if (!hasVal('v_itl_bank')) {
    if (strict) markErr('v_itl_bank','e_itl_bank','ok_itl_bank','⚠ Bank name is required');
    ok = false;
  } else { markOk('v_itl_bank','e_itl_bank','ok_itl_bank','✔ Bank name entered'); }

  if (!hasVal('v_itl_country')) {
    if (strict) markErr('v_itl_country','e_itl_country','ok_itl_country','⚠ Country is required');
    ok = false;
  } else { markOk('v_itl_country','e_itl_country','ok_itl_country','✔ Country entered'); }

  var amt = getActiveAmt();
  if (amt <= 0) {
    if (strict) markErr('v_itl_amount','e_itl_amount','ok_itl_amount','⚠ Enter a valid amount (min ETB 1)');
    ok = false;
  } else if (amt > TR_MAX) {
    markErr('v_itl_amount','e_itl_amount','ok_itl_amount','⚠ Exceeds maximum transfer limit');
    ok = false;
  } else if (amt + TR_FEES.INTERNATIONAL > TR_BAL) {
    markErr('v_itl_amount','e_itl_amount','ok_itl_amount',
      '⚠ Insufficient balance. Need ETB ' + (amt + TR_FEES.INTERNATIONAL).toFixed(2));
    ok = false;
  } else {
    markOk('v_itl_amount','e_itl_amount','ok_itl_amount',
      '✔ ETB ' + amt.toFixed(2) + ' + ETB ' + TR_FEES.INTERNATIONAL + ' fee = ETB '
      + (amt + TR_FEES.INTERNATIONAL).toFixed(2));
  }
  return ok;
}

/* ═══════════════════════════════════════════════════════════
   COPY TO HIDDEN  — THE CRITICAL FUNCTION
   Reads from visible inputs, writes to hidden POST fields.
═══════════════════════════════════════════════════════════ */
function copyAllToHidden() {
  /* Always set type and amount */
  document.getElementById('h_type').value   = activeType;
  document.getElementById('h_amount').value = getActiveAmt().toFixed(2);

  if (activeType === 'INTERNAL') {
    document.getElementById('h_receiver').value    = fieldVal('v_int_receiver');
    document.getElementById('h_description').value = fieldVal('v_int_desc');
    document.getElementById('h_beneficiary').value = '';
    document.getElementById('h_bankName').value    = '';
    document.getElementById('h_swift').value       = '';
    document.getElementById('h_country').value     = '';
  }
  else if (activeType === 'EXTERNAL') {
    document.getElementById('h_receiver').value    = fieldVal('v_ext_receiver');
    document.getElementById('h_beneficiary').value = fieldVal('v_ext_benef');
    document.getElementById('h_bankName').value    = fieldVal('v_ext_bank');
    document.getElementById('h_description').value = fieldVal('v_ext_desc');
    document.getElementById('h_swift').value       = '';
    document.getElementById('h_country').value     = '';
  }
  else if (activeType === 'INTERNATIONAL') {
    /* h_receiver gets the IBAN */
    document.getElementById('h_receiver').value    = fieldVal('v_itl_iban');
    document.getElementById('h_beneficiary').value = fieldVal('v_itl_benef');
    document.getElementById('h_bankName').value    = fieldVal('v_itl_bank');
    document.getElementById('h_swift').value       = fieldVal('v_itl_swift');
    document.getElementById('h_country').value     = fieldVal('v_itl_country');
    document.getElementById('h_description').value = fieldVal('v_itl_desc');
  }
}

/* ═══════════════════════════════════════════════════════════
   MAIN SUBMIT  — validates → copies → confirms → submits
═══════════════════════════════════════════════════════════ */
function doSubmit(pdf) {
  /* Step 1: validate with strict=true (show all errors) */
  var valid = false;
  if      (activeType === 'INTERNAL')      valid = runValidateInternal(true);
  else if (activeType === 'EXTERNAL')      valid = runValidateExternal(true);
  else if (activeType === 'INTERNATIONAL') valid = runValidateIntl(true);

  if (!valid) {
    var firstErr = document.querySelector('.er');
    if (firstErr) firstErr.scrollIntoView({behavior:'smooth', block:'center'});
    return;
  }

  /* Step 2: copy all values to hidden fields */
  copyAllToHidden();

  /* Step 3: verify the copy worked (safety check) */
  var hReceiver = document.getElementById('h_receiver').value;
  var hAmount   = document.getElementById('h_amount').value;
  if (!hReceiver || !hAmount || parseFloat(hAmount) <= 0) {
    alert('Error: Could not prepare form data. Please refresh the page and try again.');
    return;
  }

  /* Step 4: confirmation dialog */
  var amt   = parseFloat(hAmount);
  var fee   = TR_FEES[activeType];
  var total = (amt + fee).toFixed(2);

  var msg;
  if (activeType === 'INTERNAL') {
    msg = '✅ Confirm Internal Transfer:\n\n'
        + '  To:     ' + hReceiver + '\n'
        + '  Amount: ETB ' + amt.toFixed(2) + '\n'
        + '  Fee:    ETB ' + fee.toFixed(2) + '\n'
        + '  Total:  ETB ' + total + '\n\n'
        + '⚡ This transfers IMMEDIATELY and cannot be reversed.\nProceed?';
  } else if (activeType === 'EXTERNAL') {
    msg = '📤 Confirm External Transfer Request:\n\n'
        + '  Beneficiary: ' + document.getElementById('h_beneficiary').value + '\n'
        + '  To Account:  ' + hReceiver + '\n'
        + '  Bank:        ' + document.getElementById('h_bankName').value + '\n'
        + '  Amount:      ETB ' + amt.toFixed(2) + '\n'
        + '  Fee:         ETB ' + fee.toFixed(2) + '\n\n'
        + '⏳ Balance deducted ONLY after manager approval.\n'
        + '   Rejected = zero balance change.\nProceed?';
  } else {
    msg = '🌍 Confirm SWIFT Transfer Request:\n\n'
        + '  Beneficiary: ' + document.getElementById('h_beneficiary').value + '\n'
        + '  IBAN:        ' + hReceiver + '\n'
        + '  SWIFT/BIC:   ' + document.getElementById('h_swift').value + '\n'
        + '  Bank:        ' + document.getElementById('h_bankName').value + '\n'
        + '  Country:     ' + document.getElementById('h_country').value + '\n'
        + '  Amount:      ETB ' + amt.toFixed(2) + '\n'
        + '  Fee:         ETB ' + fee.toFixed(2) + '\n\n'
        + '⏳ Balance deducted ONLY after manager approval.\n'
        + '   Rejected = zero balance change.\nProceed?';
  }

  if (!confirm(msg)) return;

  /* Step 5: set PDF flag and submit */
  document.getElementById('h_pdf').value = pdf ? 'true' : 'false';
  document.getElementById('tForm').submit();
}

/* ── Sample data auto-fill ───────────────────────────────── */
function fillExtSample() {
  setField('v_ext_receiver', 'EXT9876543210');
  setField('v_ext_benef',    'Abebe Girma Kebede');
  setField('v_ext_bank',     'Commercial Bank of Ethiopia');
  setField('v_ext_amount',   '2000');
  setField('v_ext_desc',     'Payment for services rendered');
  recalcFees();
  runValidateExternal(false);
}

function fillIntlSample() {
  setField('v_itl_benef',   'John Michael Smith');
  setField('v_itl_iban',    'GB29NWBK60161331926819');
  setField('v_itl_swift',   'HBUKGB4B');
  setField('v_itl_bank',    'HSBC London');
  setField('v_itl_country', 'United Kingdom');
  setField('v_itl_amount',  '5000');
  setField('v_itl_desc',    'Business payment for contract #2024-001');
  recalcFees();
  runValidateIntl(false);
}

function setField(id, val) {
  var el = document.getElementById(id);
  if (el) {
    el.value = val;
    el.classList.remove('er', 'ok');
  }
}
</script>
</body>
</html>