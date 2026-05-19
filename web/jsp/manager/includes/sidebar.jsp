<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="sidebar" id="sidebar">

  <!-- ═══════════════════════════════════════
       BRAND / LOGO AREA
       ═══════════════════════════════════════ -->
  <div class="sidebar-brand">

    <!-- Gold-ring logo — 84×84 ring, 78×78 image, flex-centred (matches customer sidebar) -->
    <div class="logo-ring">
      <img src="${pageContext.request.contextPath}/images/logo.png"
           alt="Gojjam Bank Logo"
           class="sidebar-logo-img"
           onerror="this.style.display='none';
                    this.parentElement.querySelector('.sidebar-logo-fallback').style.display='flex';">
      <div class="sidebar-logo-fallback" style="display:none;">
        <i class="bi bi-bank2"></i>
      </div>
    </div>

    <!-- Bank name -->
    <div class="brand-name">
      <span class="bank-name">Gojjam Bank</span>
      <span class="bank-subtitle">Manager Portal</span>
    </div>

    <!-- Decorative divider -->
    <div class="brand-divider">
      <span></span><i class="bi bi-diamond-fill"></i><span></span>
    </div>

  </div>

  <!-- ═══════════════════════════════════════
       NAVIGATION
       ═══════════════════════════════════════ -->
  <nav class="sidebar-nav">

    <!-- Overview -->
    <div class="nav-section-label">Overview</div>

    <a href="${pageContext.request.contextPath}/manager/dashboard"
       class="sidebar-link <%= request.getRequestURI().contains("dashboard") ? "active" : "" %>"
       style="--delay:0.05s">
      <span class="sl-icon"><i class="bi bi-speedometer2"></i></span>
      <span class="sl-text">Dashboard</span>
      <% if (request.getRequestURI().contains("dashboard")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <!-- KYC & Accounts -->
    <div class="nav-section-label">KYC &amp; Accounts</div>

    <a href="${pageContext.request.contextPath}/manager/kyc"
       class="sidebar-link <%= request.getRequestURI().contains("kyc") ? "active" : "" %>"
       style="--delay:0.10s">
      <span class="sl-icon"><i class="bi bi-person-check"></i></span>
      <span class="sl-text">KYC Approvals</span>
      <% if (request.getRequestURI().contains("kyc")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <a href="${pageContext.request.contextPath}/manager/unlock"
       class="sidebar-link <%= request.getRequestURI().contains("unlock") ? "active" : "" %>"
       style="--delay:0.15s">
      <span class="sl-icon"><i class="bi bi-unlock"></i></span>
      <span class="sl-text">Unlock Accounts</span>
      <% if (request.getRequestURI().contains("unlock")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <a href="${pageContext.request.contextPath}/manager/update-balance"
       class="sidebar-link <%= request.getRequestURI().contains("update-balance") ? "active" : "" %>"
       style="--delay:0.20s">
      <span class="sl-icon"><i class="bi bi-pencil-square"></i></span>
      <span class="sl-text">Update Balance</span>
      <% if (request.getRequestURI().contains("update-balance")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <!-- Transactions -->
    <div class="nav-section-label">Transactions</div>

    <a href="${pageContext.request.contextPath}/manager/deposit"
       class="sidebar-link <%= request.getRequestURI().contains("deposit") ? "active" : "" %>"
       style="--delay:0.25s">
      <span class="sl-icon"><i class="bi bi-arrow-down-circle"></i></span>
      <span class="sl-text">Make Deposit</span>
      <% if (request.getRequestURI().contains("deposit")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <a href="${pageContext.request.contextPath}/manager/external-transfers"
       class="sidebar-link <%= request.getRequestURI().contains("external-transfer") ? "active" : "" %>"
       style="--delay:0.30s">
      <span class="sl-icon"><i class="bi bi-send"></i></span>
      <span class="sl-text">External Transfers</span>
      <% if (request.getRequestURI().contains("external-transfer")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <a href="${pageContext.request.contextPath}/manager/transactions"
       class="sidebar-link <%= request.getRequestURI().contains("/manager/transactions") ? "active" : "" %>"
       style="--delay:0.35s">
      <span class="sl-icon"><i class="bi bi-table"></i></span>
      <span class="sl-text">All Transactions</span>
      <% if (request.getRequestURI().contains("/manager/transactions")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <!-- Services -->
    <div class="nav-section-label">Services</div>

    <a href="${pageContext.request.contextPath}/manager/loans"
       class="sidebar-link <%= request.getRequestURI().contains("loans") ? "active" : "" %>"
       style="--delay:0.40s">
      <span class="sl-icon"><i class="bi bi-bank"></i></span>
      <span class="sl-text">Loan Approvals</span>
      <% if (request.getRequestURI().contains("loans")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <a href="${pageContext.request.contextPath}/manager/withdrawals"
       class="sidebar-link <%= request.getRequestURI().contains("withdrawals") ? "active" : "" %>"
       style="--delay:0.45s">
      <span class="sl-icon"><i class="bi bi-cash-coin"></i></span>
      <span class="sl-text">Withdrawal Approvals</span>
      <% if (request.getRequestURI().contains("withdrawals")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

    <a href="${pageContext.request.contextPath}/manager/audit-logs"
       class="sidebar-link <%= request.getRequestURI().contains("audit") ? "active" : "" %>"
       style="--delay:0.50s">
      <span class="sl-icon"><i class="bi bi-journal-text"></i></span>
      <span class="sl-text">Audit Logs</span>
      <% if (request.getRequestURI().contains("audit")) { %>
        <span class="sl-pip"></span>
      <% } %>
    </a>

  </nav>

  <!-- ═══════════════════════════════════════
       FOOTER / LOGOUT
       ═══════════════════════════════════════ -->
  <div class="sidebar-footer">
    <div class="footer-system-status">
      <span class="status-dot"></span>
      <span class="status-text">All Systems Operational</span>
    </div>
    <a href="${pageContext.request.contextPath}/logout"
       class="sidebar-link logout-link"
       onclick="return confirm('Are you sure you want to log out?')">
      <span class="sl-icon"><i class="bi bi-box-arrow-right"></i></span>
      <span class="sl-text">Logout</span>
    </a>
  </div>

</aside>

<!-- ═══════════════════════════════════════════════════════════
     SIDEBAR STYLES — Premium Banking UI (Manager Portal)
     Identical structure to customer sidebar.jsp
     ═══════════════════════════════════════════════════════════ -->
<style>
  /* ── CSS Variables ─────────────────────────── */
  :root {
    --sb-width      : 240px;
    --sb-bg-top     : #06122b;
    --sb-bg-btm     : #040d1e;
    --sb-gold       : #d4a843;
    --sb-gold-light : #f0c96a;
    --sb-gold-dim   : rgba(212,168,67,0.18);
    --sb-text       : rgba(255,255,255,0.62);
    --sb-text-hover : #ffffff;
    --sb-border     : rgba(255,255,255,0.07);
    --sb-active-bg  : rgba(212,168,67,0.11);
    --sb-radius     : 10px;
    --sb-transition : 0.22s cubic-bezier(0.4,0,0.2,1);
  }

  /* ── Sidebar Shell ─────────────────────────── */
  .sidebar {
    width: var(--sb-width);
    background: linear-gradient(180deg, var(--sb-bg-top) 0%, var(--sb-bg-btm) 100%);
    position: fixed;
    left: 0; top: 0;
    height: 100vh;
    display: flex;
    flex-direction: column;
    z-index: 1000;
    overflow: hidden;
    box-shadow: 4px 0 28px rgba(0,0,0,0.55);
    background-image:
      linear-gradient(180deg, #06122b 0%, #040d1e 100%),
      repeating-linear-gradient(
        135deg,
        transparent,
        transparent 28px,
        rgba(255,255,255,0.012) 28px,
        rgba(255,255,255,0.012) 29px
      );
    background-blend-mode: normal;
  }

  /* Gold top accent line */
  .sidebar::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 2px;
    background: linear-gradient(90deg, transparent, var(--sb-gold), transparent);
    opacity: 0.7;
  }

  /* Bottom glow orb */
  .sidebar::after {
    content: '';
    position: absolute;
    bottom: -80px; right: -80px;
    width: 220px; height: 220px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(212,168,67,0.07), transparent 70%);
    pointer-events: none;
  }

  /* Scrollbar */
  .sidebar::-webkit-scrollbar { width: 4px; }
  .sidebar::-webkit-scrollbar-track { background: transparent; }
  .sidebar::-webkit-scrollbar-thumb { background: rgba(212,168,67,0.3); border-radius: 4px; }

  /* ── Brand / Logo Area ─────────────────────── */
  .sidebar-brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px 16px 16px;
    border-bottom: 1px solid var(--sb-border);
    flex-shrink: 0;
    animation: sbFadeDown 0.45s ease both;
  }

  /* ══════════════════════════════════════════════
     LOGO RING — Identical to customer sidebar
     Ring:  84 × 84 px, perfectly square
     Inner: 78 × 78 px logo, border-radius 50%
     3px padding = visible conic ring border
     Uses flex centering — NO position:absolute
  */
  .logo-ring {
    width: 84px;
    height: 84px;
    border-radius: 50%;
    padding: 3px;
    background: conic-gradient(
      var(--sb-gold)       0deg,
      var(--sb-gold-light) 90deg,
      rgba(212,168,67,0.3) 180deg,
      var(--sb-gold-light) 270deg,
      var(--sb-gold)       360deg
    );
    margin-bottom: 11px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    box-shadow: 0 0 18px rgba(212,168,67,0.25);
    animation: rotateBorder 10s linear infinite;
  }

  @keyframes rotateBorder {
    from { filter: hue-rotate(0deg);  }
    to   { filter: hue-rotate(30deg); }
  }

  /* Logo image — 78px fills ring interior */
  .sidebar-logo-img {
    width: 78px;
    height: 78px;
    object-fit: contain;
    border-radius: 50%;
    display: block;
    background: var(--sb-bg-top);
  }

  /* Fallback icon */
  .sidebar-logo-fallback {
    width: 78px;
    height: 78px;
    border-radius: 50%;
    background: linear-gradient(135deg, #1a3a6e, #0A1F44);
    align-items: center;
    justify-content: center;
  }
  .sidebar-logo-fallback i {
    font-size: 28px;
    color: var(--sb-gold);
  }

  /* ── Bank name ─────────────────────────────── */
  .brand-name {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1px;
  }
  .bank-name {
    font-family: 'Georgia', 'Times New Roman', serif;
    font-size: 0.92rem;
    font-weight: 700;
    color: #fff;
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }
  /* "Manager Portal" — teal/emerald accent to distinguish from customer (gold) and admin (purple) */
  .bank-subtitle {
    font-size: 0.6rem;
    font-weight: 700;
    letter-spacing: 2.2px;
    text-transform: uppercase;
    color: #6ee7b7;
    background: rgba(16,185,129,0.12);
    border: 1px solid rgba(16,185,129,0.25);
    border-radius: 20px;
    padding: 2px 10px;
    margin-top: 4px;
  }

  /* Decorative divider */
  .brand-divider {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 12px;
    width: 100%;
  }
  .brand-divider span {
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(212,168,67,0.4));
  }
  .brand-divider span:last-child {
    background: linear-gradient(90deg, rgba(212,168,67,0.4), transparent);
  }
  .brand-divider i {
    font-size: 0.4rem;
    color: var(--sb-gold);
    opacity: 0.7;
  }

  /* ── Navigation Area ───────────────────────── */
  .sidebar-nav {
    flex: 1;
    padding: 8px 12px 16px;
    overflow-y: auto;
    overflow-x: hidden;
  }
  .sidebar-nav::-webkit-scrollbar { width: 3px; }
  .sidebar-nav::-webkit-scrollbar-thumb { background: rgba(212,168,67,0.2); border-radius: 3px; }

  /* Section labels */
  .nav-section-label {
    font-size: 0.58rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.8px;
    color: rgba(212,168,67,0.45);
    padding: 14px 10px 5px;
    margin-top: 2px;
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .nav-section-label::after {
    content: '';
    flex: 1;
    height: 1px;
    background: rgba(212,168,67,0.12);
  }

  /* ── Sidebar Links ─────────────────────────── */
  .sidebar-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 9px 12px;
    margin: 2px 0;
    color: var(--sb-text);
    text-decoration: none;
    border-radius: var(--sb-radius);
    font-size: 0.8rem;
    font-weight: 500;
    font-family: 'Segoe UI', sans-serif;
    letter-spacing: 0.2px;
    transition: all var(--sb-transition);
    position: relative;
    border: 1px solid transparent;
    animation: sbSlideIn 0.4s ease both;
    animation-delay: var(--delay, 0s);
  }

  @keyframes sbSlideIn {
    from { opacity: 0; transform: translateX(-12px); }
    to   { opacity: 1; transform: translateX(0); }
  }

  /* Icon box */
  .sl-icon {
    width: 30px; height: 30px;
    border-radius: 7px;
    background: rgba(255,255,255,0.04);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.95rem;
    flex-shrink: 0;
    transition: all var(--sb-transition);
    border: 1px solid rgba(255,255,255,0.05);
  }

  .sl-text {
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* Active pip */
  .sl-pip {
    width: 5px; height: 5px;
    border-radius: 50%;
    background: var(--sb-gold);
    box-shadow: 0 0 6px var(--sb-gold);
    flex-shrink: 0;
  }

  /* Hover */
  .sidebar-link:hover {
    color: var(--sb-text-hover);
    background: rgba(255,255,255,0.06);
    border-color: rgba(255,255,255,0.06);
    transform: translateX(3px);
  }
  .sidebar-link:hover .sl-icon {
    background: rgba(212,168,67,0.12);
    border-color: rgba(212,168,67,0.2);
    color: var(--sb-gold);
  }

  /* Active */
  .sidebar-link.active {
    color: var(--sb-gold-light);
    background: var(--sb-active-bg);
    border-color: rgba(212,168,67,0.18);
    font-weight: 600;
    box-shadow: 0 2px 12px rgba(212,168,67,0.08);
  }
  .sidebar-link.active::before {
    content: '';
    position: absolute;
    left: 0; top: 20%; bottom: 20%;
    width: 3px;
    border-radius: 0 3px 3px 0;
    background: linear-gradient(180deg, var(--sb-gold-light), var(--sb-gold));
    box-shadow: 0 0 10px rgba(212,168,67,0.6);
  }
  .sidebar-link.active .sl-icon {
    background: rgba(212,168,67,0.15);
    border-color: rgba(212,168,67,0.3);
    color: var(--sb-gold);
    box-shadow: 0 0 10px rgba(212,168,67,0.15);
  }

  /* ── Footer ────────────────────────────────── */
  .sidebar-footer {
    padding: 12px;
    border-top: 1px solid var(--sb-border);
    flex-shrink: 0;
    background: linear-gradient(0deg, rgba(0,0,0,0.25), transparent);
  }

  .footer-system-status {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 0 10px 8px;
  }
  .status-dot {
    width: 7px; height: 7px;
    border-radius: 50%;
    background: #10b981;
    box-shadow: 0 0 6px #10b981;
    animation: pulse 1.8s infinite;
    flex-shrink: 0;
  }
  @keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }
  .status-text {
    font-size: 0.62rem;
    color: rgba(255,255,255,0.35);
    letter-spacing: 0.3px;
    white-space: nowrap;
  }

  /* Logout */
  .logout-link {
    color: rgba(255,255,255,0.5);
    margin: 0;
    animation: none;
  }
  .logout-link:hover {
    background: rgba(239,68,68,0.12);
    border-color: rgba(239,68,68,0.15);
    color: #f87171;
    transform: translateX(3px);
  }
  .logout-link:hover .sl-icon {
    background: rgba(239,68,68,0.15);
    border-color: rgba(239,68,68,0.2);
    color: #f87171;
  }

  /* ── Entrance animation ────────────────────── */
  @keyframes sbFadeDown {
    from { opacity: 0; transform: translateY(-10px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── Responsive: icon-only on mobile ──────── */
  @media (max-width: 768px) {
    .sidebar { width: 62px; overflow: visible; }
    .bank-name, .bank-subtitle, .brand-divider,
    .sl-text, .sl-pip, .nav-section-label,
    .footer-system-status { display: none; }
    .sl-icon { margin: 0 auto; }
    .sidebar-link { padding: 10px; justify-content: center; border-radius: 8px; }
    .sidebar-link.active::before { display: none; }
    .sidebar-brand { padding: 14px 8px; }
    /* Proportional shrink — same as customer & admin */
    .logo-ring { width: 46px; height: 46px; }
    .sidebar-logo-img,
    .sidebar-logo-fallback { width: 40px; height: 40px; }
  }
</style>
