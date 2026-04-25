<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Withdraw Funds";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
  Account account          = (Account)     request.getAttribute("account");
  List<Withdrawal> history = (List<Withdrawal>) request.getAttribute("withdrawalHistory");
  String wFee              = (String)      request.getAttribute("withdrawalFee");
  if (wFee == null) wFee   = "15.00";
  DateTimeFormatter fmt    = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
  double feeVal            = Double.parseDouble(wFee);
  double balance           = account != null ? account.getBalance().doubleValue() : 0.0;
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
:root {
  --wd-purple: #7c3aed;
  --wd-purple-light: #fdf4ff;
  --wd-blue: #2563eb;
  --wd-green: #10b981;
  --wd-red: #ef4444;
  --wd-gold: #f59e0b;
}

/* Hero */
.wd-hero {
  background: linear-gradient(135deg, #0A1F44 0%, #1a3a6e 50%, var(--wd-purple) 100%);
  border-radius: 18px; padding: 2rem; color: #fff;
  margin-bottom: 1.5rem; display: flex; align-items: center;
  justify-content: space-between; position: relative; overflow: hidden;
  box-shadow: 0 12px 40px rgba(10,31,68,0.3);
}
.wd-hero::before {
  content: ''; position: absolute; width: 280px; height: 280px;
  border-radius: 50%; background: rgba(255,255,255,0.04); right: -70px; top: -80px;
}
.wd-hero::after {
  content: ''; position: absolute; width: 160px; height: 160px;
  border-radius: 50%; background: rgba(245,158,11,0.08); bottom: -40px; left: 40%;
}
.wd-hero-left { position: relative; z-index: 2; }
.wd-hero-left h2 { font-size: 1.3rem; font-weight: 800; margin-bottom: 5px; }
.wd-hero-left p  { font-size: 0.83rem; opacity: 0.7; margin-bottom: 0.8rem; }

.instant-badge {
  display: inline-flex; align-items: center; gap: 6px;
  background: rgba(16,185,129,0.2); border: 1px solid rgba(16,185,129,0.35);
  border-radius: 20px; padding: 4px 14px; font-size: 0.73rem; font-weight: 700; color: #6ee7b7;
}
.instant-badge::before {
  content: ''; width: 7px; height: 7px; border-radius: 50%;
  background: #10b981; animation: pulse 1.4s infinite;
}
@keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }

.wd-balance-pill {
  background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2);
  border-radius: 14px; padding: 1rem 1.5rem; text-align: right;
  position: relative; z-index: 2;
}
.wd-balance-pill .bp-lbl { font-size: 0.7rem; opacity: 0.7; letter-spacing: 0.5px; }
.wd-balance-pill .bp-val { font-size: 1.5rem; font-weight: 800; }
.wd-balance-pill .bp-acc { font-size: 0.68rem; opacity: 0.6; margin-top: 2px; }

/* How it works bar */
.how-bar {
  background: #fff; border-radius: 12px; padding: 1rem 1.5rem;
  margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}
.hw-step { display: flex; align-items: center; gap: 8px; flex: 1; }
.hw-num {
  width: 28px; height: 28px; border-radius: 50%; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.72rem; font-weight: 800; color: #fff;
}
.hw-txt { font-size: 0.78rem; font-weight: 600; color: #475569; }
.hw-arr { color: #e2e8f0; font-size: 1rem; margin: 0 0.5rem; }

/* Method cards */
.method-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 0.8rem; margin-bottom: 1.2rem; }
.method-card {
  border: 2px solid #e2e8f0; border-radius: 14px; padding: 1rem;
  cursor: pointer; transition: all 0.25s; background: #fff; text-align: center;
  position: relative;
}
.method-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
.method-card.selected { box-shadow: 0 0 0 3px rgba(124,58,237,0.15); }
.mc-check {
  position: absolute; top: 8px; right: 8px; width: 18px; height: 18px;
  border-radius: 50%; display: flex; align-items: center; justify-content: center;
  font-size: 0.65rem; display: none;
}
.method-card.selected .mc-check { display: flex; }
.mc-icon { width: 46px; height: 46px; border-radius: 12px; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; transition: transform 0.2s; }
.method-card:hover .mc-icon, .method-card.selected .mc-icon { transform: scale(1.1); }
.mc-title { font-size: 0.82rem; font-weight: 800; color: #0A1F44; margin-bottom: 2px; }
.mc-sub   { font-size: 0.7rem; color: #94a3b8; }
.mc-speed { font-size: 0.68rem; font-weight: 700; margin-top: 5px; padding: 2px 8px; border-radius: 10px; display: inline-block; }

.mc-bank   .mc-icon { background: #dbeafe; color: #2563eb; }
.mc-mobile .mc-icon { background: #dcfce7; color: #16a34a; }
.mc-atm    .mc-icon { background: #fef3c7; color: #d97706; }
.mc-bank.selected   { border-color: #2563eb; background: #eff6ff; }
.mc-mobile.selected { border-color: #10b981; background: #f0fdf4; }
.mc-atm.selected    { border-color: #d97706; background: #fef9ec; }
.mc-bank.selected   .mc-check { background: #2563eb; color: #fff; }
.mc-mobile.selected .mc-check { background: #10b981; color: #fff; }
.mc-atm.selected    .mc-check { background: #d97706; color: #fff; }

/* Form elements */
.wd-form-card { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.07); overflow: hidden; }
.wd-form-head { background: #0A1F44; color: #fff; padding: 1rem 1.5rem; font-weight: 700; font-size: 0.92rem; display: flex; align-items: center; gap: 8px; }
.wd-form-body { padding: 1.5rem; }

.fg { display: flex; flex-direction: column; margin-bottom: 1rem; }
.fg label { font-size: 0.8rem; font-weight: 700; color: #0A1F44; margin-bottom: 5px; display: flex; align-items: center; gap: 5px; }
.req { color: #ef4444; }
.iw  { position: relative; }
.iw .fi { position: absolute; left: 11px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 0.95rem; pointer-events: none; }
.inp {
  width: 100%; padding: 0.7rem 0.9rem 0.7rem 2.3rem;
  border: 1.5px solid #e2e8f0; border-radius: 10px;
  font-size: 0.9rem; font-family: inherit; color: #1e293b;
  outline: none; transition: all 0.25s; background: #fff;
}
.inp:focus { border-color: var(--wd-purple); box-shadow: 0 0 0 3px rgba(124,58,237,0.1); }
.inp.valid   { border-color: var(--wd-green); background: #f0fdf4; }
.inp.invalid { border-color: var(--wd-red);   background: #fef2f2; }
.inp-hint  { font-size: 0.72rem; color: #94a3b8; margin-top: 3px; display: flex; align-items: center; gap: 4px; }
.inp-error { font-size: 0.72rem; color: var(--wd-red); margin-top: 4px; font-weight: 600; display: none; padding: 4px 8px; background: #fef2f2; border-radius: 6px; }
.inp-ok    { font-size: 0.72rem; color: var(--wd-green); margin-top: 4px; font-weight: 600; display: none; padding: 4px 8px; background: #f0fdf4; border-radius: 6px; }

/* Amount slider */
.amount-slider {
  width: 100%; -webkit-appearance: none; height: 6px;
  border-radius: 3px; background: #e2e8f0; outline: none; margin-top: 6px;
  cursor: pointer;
}
.amount-slider::-webkit-slider-thumb {
  -webkit-appearance: none; appearance: none;
  width: 18px; height: 18px; border-radius: 50%;
  background: var(--wd-purple); cursor: pointer; border: 2px solid #fff;
  box-shadow: 0 2px 6px rgba(124,58,237,0.4);
}

/* Quick amount buttons */
.quick-amounts { display: flex; gap: 0.4rem; flex-wrap: wrap; margin-top: 0.5rem; }
.qa-btn {
  padding: 4px 12px; border: 1.5px solid #e2e8f0; border-radius: 8px;
  font-size: 0.75rem; font-weight: 700; cursor: pointer; background: #fff;
  color: #475569; font-family: inherit; transition: all 0.2s;
}
.qa-btn:hover { border-color: var(--wd-purple); color: var(--wd-purple); background: var(--wd-purple-light); }

/* Fee summary */
.fee-summary {
  background: linear-gradient(135deg, #fdf4ff, #f5f3ff);
  border: 1px solid #e9d5ff; border-radius: 12px; padding: 1rem 1.2rem; margin-bottom: 1rem;
}
.fee-row { display: flex; justify-content: space-between; align-items: center; font-size: 0.84rem; padding: 4px 0; }
.fee-row .fl { color: #475569; display: flex; align-items: center; gap: 5px; }
.fee-row .fv { font-weight: 700; color: #0A1F44; }
.fee-divider { height: 1px; background: #e9d5ff; margin: 6px 0; }
.fee-total .fl { font-weight: 700; color: #0A1F44; }
.fee-total .fv { color: var(--wd-red); font-size: 1rem; font-weight: 800; }
.fee-after .fv { color: var(--wd-green); font-weight: 700; }

/* Balance progress bar */
.balance-usage {
  margin-top: 0.8rem;
}
.bu-label { display: flex; justify-content: space-between; font-size: 0.72rem; color: #94a3b8; margin-bottom: 4px; }
.bu-bar { height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden; }
.bu-fill { height: 100%; border-radius: 4px; transition: all 0.3s; background: linear-gradient(90deg, var(--wd-green), var(--wd-purple)); }

/* Submit button */
.btn-wd {
  width: 100%; padding: 0.9rem; border: none; border-radius: 12px;
  font-size: 1rem; font-weight: 800; cursor: pointer; font-family: inherit;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  background: linear-gradient(135deg, #7c3aed, #2563eb);
  color: #fff; transition: all 0.3s; position: relative; overflow: hidden;
  box-shadow: 0 4px 15px rgba(124,58,237,0.3);
}
.btn-wd::before {
  content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
  transition: left 0.5s;
}
.btn-wd:hover::before { left: 100%; }
.btn-wd:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(124,58,237,0.4); }
.btn-wd:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }

/* Reauth notice */
.reauth-notice {
  background: #eff6ff; border: 1px solid #bfdbfe; border-left: 4px solid #2563eb;
  border-radius: 10px; padding: 0.7rem 1rem; margin-bottom: 1rem;
  font-size: 0.8rem; color: #1e40af; display: flex; align-items: center; gap: 8px;
}

/* Alert banners */
.wd-alert { border-radius: 10px; padding: 0.9rem 1rem; margin-bottom: 1.2rem; font-size: 0.88rem; display: flex; align-items: flex-start; gap: 8px; }
.wd-ok  { background: #f0fdf4; border: 1px solid #bbf7d0; border-left: 4px solid #10b981; color: #166534; }
.wd-err { background: #fef2f2; border: 1px solid #fecaca; border-left: 4px solid #ef4444; color: #991b1b; }

/* History table */
.hist-card { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.07); overflow: hidden; margin-top: 1.5rem; }
.hist-head { background: #0A1F44; color: #fff; padding: 1rem 1.5rem; font-weight: 700; font-size: 0.92rem; display: flex; align-items: center; gap: 8px; }
.h-table { width: 100%; border-collapse: collapse; }
.h-table thead tr { background: #f8fafc; }
.h-table th { padding: 0.6rem 0.8rem; font-size: 0.72rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #f1f5f9; }
.h-table td { padding: 0.7rem 0.8rem; font-size: 0.83rem; border-bottom: 1px solid #f8fafc; vertical-align: middle; }
.h-table tbody tr:hover { background: #f8fafc; }
.h-table tbody tr:last-child td { border-bottom: none; }
.sp { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
.sp-ok { background: #dcfce7; color: #15803d; }

@media(max-width:640px){ .method-grid{grid-template-columns:1fr;} .how-bar{flex-direction:column;gap:0.5rem;} }
</style>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-cash-coin"></i> Withdraw Funds</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle" style="background:linear-gradient(135deg,#7c3aed,#2563eb);"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">

    <% if (request.getAttribute("error") != null) { %>
      <div class="wd-alert wd-err">
        <i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;font-size:1.1rem;"></i>
        <div><strong>Transaction Failed.</strong> <%= request.getAttribute("error") %></div>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="wd-alert wd-ok">
        <i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;font-size:1.1rem;"></i>
        <div><%= request.getAttribute("success") %></div>
      </div>
    <% } %>

    <!-- Hero -->
    <div class="wd-hero">
      <div class="wd-hero-left">
        <h2><i class="bi bi-cash-coin"></i> Instant Withdrawal</h2>
        <p>Withdraw funds securely — processed immediately after verification</p>
        <div class="instant-badge">Instant Processing</div>
      </div>
      <% if (account != null) { %>
      <div class="wd-balance-pill">
        <div class="bp-lbl">AVAILABLE BALANCE</div>
        <div class="bp-val">ETB <%= account.getBalance().toPlainString() %></div>
        <div class="bp-acc"><i class="bi bi-credit-card"></i> <%= account.getAccountNumber() %></div>
      </div>
      <% } %>
    </div>

    <!-- How it works -->
    <div class="how-bar">
      <div class="hw-step">
        <div class="hw-num" style="background:#7c3aed;">1</div>
        <div class="hw-txt">Re-authenticate identity</div>
      </div>
      <div class="hw-arr"><i class="bi bi-chevron-right"></i></div>
      <div class="hw-step">
        <div class="hw-num" style="background:#2563eb;">2</div>
        <div class="hw-txt">Choose method &amp; amount</div>
      </div>
      <div class="hw-arr"><i class="bi bi-chevron-right"></i></div>
      <div class="hw-step">
        <div class="hw-num" style="background:#10b981;">3</div>
        <div class="hw-txt">System checks balance</div>
      </div>
      <div class="hw-arr"><i class="bi bi-chevron-right"></i></div>
      <div class="hw-step">
        <div class="hw-num" style="background:#f59e0b;">4</div>
        <div class="hw-txt">Funds withdrawn instantly</div>
      </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1.1fr;gap:1.5rem;">

      <!-- Form -->
      <div>
        <div class="wd-form-card">
          <div class="wd-form-head">
            <i class="bi bi-cash-stack"></i> New Withdrawal
            <span style="margin-left:auto;font-size:0.75rem;background:rgba(255,255,255,0.15);padding:2px 10px;border-radius:10px;">
              <i class="bi bi-shield-check"></i> Re-auth Active
            </span>
          </div>
          <div class="wd-form-body">

            <!-- Reauth notice -->
            <div class="reauth-notice">
              <i class="bi bi-shield-lock-fill"></i>
              Identity verified. Authorization valid for 10 minutes.
            </div>

            <!-- Method selection -->
            <div style="font-size:0.8rem;font-weight:800;color:#0A1F44;margin-bottom:0.7rem;">
              <i class="bi bi-grid-3x3-gap" style="color:#7c3aed;"></i>
              Step 1 — Choose Withdrawal Method
            </div>

            <div class="method-grid">
              <div class="method-card mc-bank selected" id="mc-BANK_COUNTER"
                   onclick="selMethod('BANK_COUNTER')">
                <div class="mc-check"><i class="bi bi-check-lg"></i></div>
                <div class="mc-icon"><i class="bi bi-building-fill"></i></div>
                <div class="mc-title">Bank Counter</div>
                <div class="mc-sub">Collect cash at branch</div>
                <div class="mc-speed" style="background:#dbeafe;color:#2563eb;">Immediate</div>
              </div>
              <div class="method-card mc-mobile" id="mc-MOBILE_MONEY"
                   onclick="selMethod('MOBILE_MONEY')">
                <div class="mc-check"><i class="bi bi-check-lg"></i></div>
                <div class="mc-icon"><i class="bi bi-phone-fill"></i></div>
                <div class="mc-title">Mobile Money</div>
                <div class="mc-sub">Telebirr / M-PESA</div>
                <div class="mc-speed" style="background:#dcfce7;color:#16a34a;">Immediate</div>
              </div>
              <div class="method-card mc-atm" id="mc-ATM_REQUEST"
                   onclick="selMethod('ATM_REQUEST')">
                <div class="mc-check"><i class="bi bi-check-lg"></i></div>
                <div class="mc-icon"><i class="bi bi-credit-card-2-back-fill"></i></div>
                <div class="mc-title">ATM Withdrawal</div>
                <div class="mc-sub">Use your card at ATM</div>
                <div class="mc-speed" style="background:#fef3c7;color:#d97706;">Immediate</div>
              </div>
            </div>

            <!-- Amount -->
            <div style="font-size:0.8rem;font-weight:800;color:#0A1F44;margin-bottom:0.7rem;margin-top:0.3rem;">
              <i class="bi bi-cash" style="color:#7c3aed;"></i>
              Step 2 — Enter Amount
            </div>

            <form method="post" action="${pageContext.request.contextPath}/customer/withdraw"
                  id="wdForm" novalidate>
              <input type="hidden" name="csrfToken"        value="${csrfToken}"/>
              <input type="hidden" name="withdrawalMethod" id="methodInput" value="BANK_COUNTER"/>

              <div class="fg">
                <label>
                  <i class="bi bi-currency-exchange" style="color:#7c3aed;"></i>
                  Withdrawal Amount (ETB) <span class="req">*</span>
                </label>
                <div class="iw">
                  <i class="bi bi-cash fi"></i>
                  <input type="number" name="amount" id="wdAmount" class="inp"
                         placeholder="Enter amount (min ETB 50)"
                         min="50" step="0.01"
                         max="<%= account != null ? String.format("%.2f", balance - feeVal) : "0" %>"
                         oninput="onAmountChange(this.value)"/>
                </div>
                <div class="inp-hint">
                  <i class="bi bi-info-circle"></i>
                  Min: ETB 50.00 &nbsp;|&nbsp;
                  Max: ETB <%= account != null ? String.format("%.2f", balance - feeVal) : "N/A" %>
                  (balance − fee)
                </div>
                <div class="inp-error" id="amtErr"></div>
                <div class="inp-ok"    id="amtOk"></div>

                <!-- Quick amount buttons -->
                <div class="quick-amounts">
                  <% double[] quickAmts = {100, 250, 500, 1000, 2500, 5000}; %>
                  <% for (double qa : quickAmts) { %>
                    <% if (qa + feeVal <= balance) { %>
                      <button type="button" class="qa-btn"
                              onclick="setAmount(<%= (int)qa %>)">
                        ETB <%= (int)qa %>
                      </button>
                    <% } %>
                  <% } %>
                </div>

                <!-- Slider -->
                <input type="range" class="amount-slider" id="amtSlider"
                       min="50" max="<%= account != null ? Math.max(50, balance - feeVal) : 50 %>"
                       value="50" step="50"
                       oninput="setAmount(parseFloat(this.value))"/>
              </div>

              <div class="fg">
                <label>
                  <i class="bi bi-chat-text" style="color:#94a3b8;"></i>
                  Withdrawal Reason
                  <small style="color:#94a3b8;font-weight:400;">(optional)</small>
                </label>
                <div class="iw">
                  <i class="bi bi-chat-text fi"></i>
                  <input type="text" name="reason" class="inp"
                         placeholder="e.g. Emergency, rent, medical..." maxlength="200"/>
                </div>
              </div>

              <!-- Fee Summary -->
              <div class="fee-summary" id="feeSummary">
                <div class="fee-row">
                  <span class="fl"><i class="bi bi-cash"></i> Withdrawal Amount</span>
                  <span class="fv">ETB <span id="fs-amount">0.00</span></span>
                </div>
                <div class="fee-row">
                  <span class="fl"><i class="bi bi-tag"></i> Processing Fee</span>
                  <span class="fv" style="color:#f59e0b;">ETB <%= wFee %></span>
                </div>
                <div class="fee-divider"></div>
                <div class="fee-row fee-total">
                  <span class="fl"><i class="bi bi-calculator"></i> Total Deducted</span>
                  <span class="fv">ETB <span id="fs-total">0.00</span></span>
                </div>
                <div class="fee-divider"></div>
                <div class="fee-row fee-after">
                  <span class="fl" style="color:#10b981;font-weight:600;">
                    <i class="bi bi-wallet2"></i> Balance After
                  </span>
                  <span class="fv" id="fs-after">
                    ETB <%= account != null ? account.getBalance().toPlainString() : "0.00" %>
                  </span>
                </div>
                <!-- Balance usage bar -->
                <div class="balance-usage">
                  <div class="bu-label">
                    <span>Balance Usage</span>
                    <span id="bu-pct">0%</span>
                  </div>
                  <div class="bu-bar">
                    <div class="bu-fill" id="bu-fill" style="width:0%;"></div>
                  </div>
                </div>
              </div>

              <!-- Insufficient balance alert (hidden by default) -->
              <div id="insufficientAlert" style="display:none;background:#fef2f2;border:1px solid #fecaca;
                   border-left:4px solid #ef4444;border-radius:10px;padding:0.8rem;
                   margin-bottom:1rem;font-size:0.83rem;color:#991b1b;">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <strong>Insufficient Balance!</strong>
                You need <strong>ETB <span id="needed">0</span></strong> (amount + ETB <%= wFee %> fee),
                but your balance is only <strong>ETB <%= account != null ? account.getBalance().toPlainString() : "0" %></strong>.
              </div>

              <button type="button" class="btn-wd" id="submitBtn" onclick="submitWd()">
                <i class="bi bi-cash-coin"></i> Withdraw Now
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- Right Panel: Info -->
      <div style="display:flex;flex-direction:column;gap:1rem;">

        <!-- Security Guarantee -->
        <div style="background:linear-gradient(135deg,#0A1F44,#1a3a6e);border-radius:14px;padding:1.3rem;color:#fff;">
          <div style="font-size:0.88rem;font-weight:800;margin-bottom:0.8rem;">
            <i class="bi bi-shield-check-fill" style="color:#6ee7b7;"></i>
            Security Guarantee
          </div>
          <ul style="list-style:none;font-size:0.8rem;line-height:2;">
            <li style="display:flex;align-items:center;gap:8px;">
              <i class="bi bi-check-circle-fill" style="color:#6ee7b7;flex-shrink:0;"></i>
              Identity verified via re-authentication
            </li>
            <li style="display:flex;align-items:center;gap:8px;">
              <i class="bi bi-check-circle-fill" style="color:#6ee7b7;flex-shrink:0;"></i>
              Balance locked at transaction level (FOR UPDATE)
            </li>
            <li style="display:flex;align-items:center;gap:8px;">
              <i class="bi bi-check-circle-fill" style="color:#6ee7b7;flex-shrink:0;"></i>
              Full ACID compliance — rollback on any failure
            </li>
            <li style="display:flex;align-items:center;gap:8px;">
              <i class="bi bi-check-circle-fill" style="color:#6ee7b7;flex-shrink:0;"></i>
              All actions logged in audit trail
            </li>
          </ul>
        </div>

        <!-- Method Details -->
        <div style="background:#fff;border-radius:14px;box-shadow:0 2px 12px rgba(0,0,0,0.07);overflow:hidden;">
          <div style="background:#7c3aed;color:#fff;padding:0.8rem 1.2rem;font-weight:700;font-size:0.85rem;">
            <i class="bi bi-info-circle-fill"></i> Method Details
          </div>
          <div style="padding:1rem 1.2rem;" id="methodInfo">
            <!-- Bank Counter default -->
            <div id="info-BANK_COUNTER">
              <div style="font-weight:800;color:#0A1F44;margin-bottom:0.6rem;font-size:0.88rem;">
                <i class="bi bi-building-fill" style="color:#2563eb;"></i> Bank Counter
              </div>
              <ul style="list-style:none;font-size:0.8rem;color:#475569;line-height:2;">
                <li><i class="bi bi-chevron-right" style="color:#2563eb;margin-right:4px;"></i> Visit any Gojjam Bank branch</li>
                <li><i class="bi bi-chevron-right" style="color:#2563eb;margin-right:4px;"></i> Show your National ID at counter</li>
                <li><i class="bi bi-chevron-right" style="color:#2563eb;margin-right:4px;"></i> Receive cash immediately</li>
                <li><i class="bi bi-clock" style="color:#f59e0b;margin-right:4px;"></i> Hours: Mon–Fri 08:30–17:30, Sat 08:30–13:00</li>
              </ul>
            </div>
            <div id="info-MOBILE_MONEY" style="display:none;">
              <div style="font-weight:800;color:#0A1F44;margin-bottom:0.6rem;font-size:0.88rem;">
                <i class="bi bi-phone-fill" style="color:#16a34a;"></i> Mobile Money
              </div>
              <ul style="list-style:none;font-size:0.8rem;color:#475569;line-height:2;">
                <li><i class="bi bi-chevron-right" style="color:#10b981;margin-right:4px;"></i> Transferred to your Telebirr / M-PESA</li>
                <li><i class="bi bi-chevron-right" style="color:#10b981;margin-right:4px;"></i> Phone number must match your profile</li>
                <li><i class="bi bi-chevron-right" style="color:#10b981;margin-right:4px;"></i> Funds appear within 30 seconds</li>
                <li><i class="bi bi-exclamation-triangle" style="color:#f59e0b;margin-right:4px;"></i> Ensure mobile wallet is active</li>
              </ul>
            </div>
            <div id="info-ATM_REQUEST" style="display:none;">
              <div style="font-weight:800;color:#0A1F44;margin-bottom:0.6rem;font-size:0.88rem;">
                <i class="bi bi-credit-card-2-back-fill" style="color:#d97706;"></i> ATM Withdrawal
              </div>
              <ul style="list-style:none;font-size:0.8rem;color:#475569;line-height:2;">
                <li><i class="bi bi-chevron-right" style="color:#d97706;margin-right:4px;"></i> Use your Gojjam ATM card</li>
                <li><i class="bi bi-chevron-right" style="color:#d97706;margin-right:4px;"></i> Withdraw from any CBE or Gojjam ATM</li>
                <li><i class="bi bi-chevron-right" style="color:#d97706;margin-right:4px;"></i> Daily ATM limit: ETB 20,000</li>
                <li><i class="bi bi-info-circle" style="color:#f59e0b;margin-right:4px;"></i> Keep your PIN confidential</li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Important Notes -->
        <div style="background:#fef9ec;border:1px solid #fde68a;border-radius:12px;padding:1rem;font-size:0.8rem;color:#92400e;">
          <div style="font-weight:800;margin-bottom:0.5rem;">
            <i class="bi bi-exclamation-triangle-fill"></i> Important Notes
          </div>
          <ul style="list-style:none;line-height:1.9;">
            <li><i class="bi bi-dot" style="font-size:1.2rem;margin-right:2px;"></i> Minimum withdrawal: ETB 50.00</li>
            <li><i class="bi bi-dot" style="font-size:1.2rem;margin-right:2px;"></i> Service fee: ETB <%= wFee %> per transaction</li>
            <li><i class="bi bi-dot" style="font-size:1.2rem;margin-right:2px;"></i> Balance must cover amount + fee</li>
            <li><i class="bi bi-dot" style="font-size:1.2rem;margin-right:2px;"></i> Transactions cannot be reversed after processing</li>
          </ul>
        </div>

      </div>
    </div>

    <!-- Withdrawal History -->
    <div class="hist-card">
      <div class="hist-head">
        <i class="bi bi-clock-history"></i> Withdrawal History
        <span style="margin-left:auto;font-size:0.78rem;opacity:0.8;">
          <%= history != null ? history.size() : 0 %> records
        </span>
      </div>
      <% if (history == null || history.isEmpty()) { %>
        <div style="padding:2rem;text-align:center;color:#94a3b8;">
          <i class="bi bi-inbox" style="font-size:2.5rem;display:block;margin-bottom:0.5rem;"></i>
          No withdrawal history yet.
        </div>
      <% } else { %>
        <div style="overflow-x:auto;">
          <table class="h-table">
            <thead>
              <tr>
                <th>Reference</th><th>Method</th><th>Amount (ETB)</th>
                <th>Fee (ETB)</th><th>Reason</th><th>Status</th><th>Date</th>
              </tr>
            </thead>
            <tbody>
              <% for (Withdrawal w : history) { %>
                <tr>
                  <td>
                    <code style="font-size:0.75rem;background:#f5f3ff;padding:2px 8px;border-radius:6px;color:#7c3aed;">
                      <%= w.getReferenceNumber() %>
                    </code>
                  </td>
                  <td>
                    <span style="font-size:0.75rem;font-weight:700;padding:3px 10px;border-radius:12px;
                          background:#f5f3ff;color:#7c3aed;display:inline-flex;align-items:center;gap:4px;">
                      <i class="bi bi-<%= "BANK_COUNTER".equals(w.getWithdrawalMethod())?"building":"MOBILE_MONEY".equals(w.getWithdrawalMethod())?"phone":"credit-card" %>-fill"></i>
                      <%= w.getWithdrawalMethod().replace("_"," ") %>
                    </span>
                  </td>
                  <td><strong style="color:#0A1F44;">ETB <%= w.getAmount().toPlainString() %></strong></td>
                  <td style="color:#f59e0b;font-weight:600;">ETB <%= w.getFee().toPlainString() %></td>
                  <td style="font-size:0.78rem;color:#94a3b8;max-width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                    <%= w.getReason() != null && !w.getReason().isBlank() ? w.getReason() : "—" %>
                  </td>
                  <td>
                    <span class="sp sp-ok">
                      <i class="bi bi-check-circle-fill" style="font-size:0.65rem;"></i>
                      SUCCESS
                    </span>
                  </td>
                  <td style="font-size:0.78rem;color:#94a3b8;white-space:nowrap;">
                    <%= w.getCreatedAt() != null ? w.getCreatedAt().format(fmt) : "" %>
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
<script>
const FEE     = <%= feeVal %>;
const BALANCE = <%= balance %>;
let selM      = 'BANK_COUNTER';

function selMethod(m) {
  selM = m;
  document.getElementById('methodInput').value = m;
  ['BANK_COUNTER','MOBILE_MONEY','ATM_REQUEST'].forEach(function(t) {
    const card = document.getElementById('mc-' + t);
    card.classList.toggle('selected', t === m);
    const info = document.getElementById('info-' + t);
    if (info) info.style.display = t === m ? 'block' : 'none';
  });
}

function setAmount(val) {
  val = parseFloat(val) || 0;
  document.getElementById('wdAmount').value = val.toFixed(2);
  document.getElementById('amtSlider').value = val;
  onAmountChange(val);
}

function onAmountChange(val) {
  val = parseFloat(val) || 0;
  const total = val + FEE;
  const after = BALANCE - total;
  const pct   = Math.min(100, (total / BALANCE) * 100);

  document.getElementById('fs-amount').textContent = val.toFixed(2);
  document.getElementById('fs-total').textContent  = total.toFixed(2);

  const afterEl = document.getElementById('fs-after');
  afterEl.textContent  = 'ETB ' + Math.max(0, after).toFixed(2);
  afterEl.style.color  = after < 0 ? '#ef4444' : '#10b981';

  document.getElementById('bu-fill').style.width = pct + '%';
  document.getElementById('bu-fill').style.background =
    pct > 80 ? 'linear-gradient(90deg,#ef4444,#dc2626)' :
    pct > 60 ? 'linear-gradient(90deg,#f59e0b,#d97706)' :
               'linear-gradient(90deg,#10b981,#7c3aed)';
  document.getElementById('bu-pct').textContent = pct.toFixed(1) + '%';
  document.getElementById('bu-pct').style.color = pct > 80 ? '#ef4444' : '#94a3b8';

  document.getElementById('amtSlider').value = val;

  const amtEl = document.getElementById('wdAmount');
  const errEl = document.getElementById('amtErr');
  const okEl  = document.getElementById('amtOk');
  const insuf = document.getElementById('insufficientAlert');
  const btn   = document.getElementById('submitBtn');

  if (val <= 0) {
    amtEl.classList.remove('valid','invalid');
    errEl.style.display = 'none'; okEl.style.display = 'none';
    insuf.style.display = 'none';
    btn.disabled = false;
  } else if (val < 50) {
    setIn(amtEl, errEl, okEl, 'Minimum withdrawal amount is ETB 50.00');
    insuf.style.display = 'none'; btn.disabled = true;
  } else if (total > BALANCE) {
    setIn(amtEl, errEl, okEl, 'Insufficient balance for this amount.');
    document.getElementById('needed').textContent = total.toFixed(2);
    insuf.style.display = 'flex'; btn.disabled = true;
  } else {
    setOk(amtEl, errEl, okEl, '✔ ETB ' + val.toFixed(2) + ' + ETB ' + FEE.toFixed(2) + ' fee = ETB ' + total.toFixed(2) + ' total');
    insuf.style.display = 'none'; btn.disabled = false;
  }
}

function setIn(el, err, ok, msg) {
  el.classList.add('invalid'); el.classList.remove('valid');
  err.textContent = msg; err.style.display = 'block'; ok.style.display = 'none';
}
function setOk(el, err, ok, msg) {
  el.classList.add('valid'); el.classList.remove('invalid');
  err.style.display = 'none'; ok.textContent = msg; ok.style.display = 'block';
}

function submitWd() {
  const val   = parseFloat(document.getElementById('wdAmount').value) || 0;
  const total = val + FEE;
  if (val < 50) {
    document.getElementById('wdAmount').focus();
    return;
  }
  if (total > BALANCE) {
    document.getElementById('insufficientAlert').style.display = 'flex';
    document.getElementById('wdAmount').focus();
    return;
  }

  const methods = { BANK_COUNTER:'Bank Counter', MOBILE_MONEY:'Mobile Money', ATM_REQUEST:'ATM Withdrawal' };
  if (confirm(
    '⚠ Confirm Withdrawal:\n\n'
    + '• Method: ' + methods[selM] + '\n'
    + '• Amount: ETB ' + val.toFixed(2) + '\n'
    + '• Fee:    ETB ' + FEE.toFixed(2) + '\n'
    + '• Total:  ETB ' + total.toFixed(2) + '\n'
    + '• Balance after: ETB ' + (BALANCE - total).toFixed(2) + '\n\n'
    + 'This will be processed IMMEDIATELY and cannot be reversed.\nProceed?'
  )) {
    document.getElementById('wdForm').submit();
  }
}
</script>
</body>
</html>