<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="admin-sidebar" id="sidebar">

  <!-- ═══════════════════════════════════════
       BRAND / LOGO AREA
       ═══════════════════════════════════════ -->
  <div class="asb-brand">

    <!-- Gold-ring logo -->
    <div class="asb-logo-ring">
      <img src="${pageContext.request.contextPath}/images/logo.png"
           alt="Gojjam Bank Logo"
           class="asb-logo-img"
           onerror="this.style.display='none';
                    this.parentElement.querySelector('.asb-logo-fallback').style.display='flex';">
      <div class="asb-logo-fallback" style="display:none;">
        <i class="bi bi-bank2"></i>
      </div>
    </div>

    <!-- Name block -->
    <div class="asb-brand-name">
      <span class="asb-bank-name">Gojjam Bank</span>
      <span class="asb-bank-sub">Admin Portal</span>
    </div>

    <!-- Decorative rule -->
    <div class="asb-brand-rule">
      <span></span><i class="bi bi-shield-lock-fill"></i><span></span>
    </div>

  </div>

  <!-- ═══════════════════════════════════════
       NAVIGATION
       ═══════════════════════════════════════ -->
  <nav class="asb-nav">

    <!-- Overview -->
    <div class="asb-section-label">Overview</div>

    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="asb-link <%= request.getRequestURI().contains("dashboard") ? "active" : "" %>"
       style="--d:0.05s">
      <span class="asb-icon"><i class="bi bi-speedometer2"></i></span>
      <span class="asb-txt">Dashboard</span>
      <% if (request.getRequestURI().contains("dashboard")) { %><span class="asb-pip"></span><% } %>
    </a>

    <!-- Management -->
    <div class="asb-section-label">Management</div>

    <a href="${pageContext.request.contextPath}/admin/accounts"
       class="asb-link <%= request.getRequestURI().contains("accounts") ? "active" : "" %>"
       style="--d:0.10s">
      <span class="asb-icon"><i class="bi bi-people"></i></span>
      <span class="asb-txt">Customer Accounts</span>
      <% if (request.getRequestURI().contains("accounts")) { %><span class="asb-pip"></span><% } %>
    </a>

    <a href="${pageContext.request.contextPath}/admin/managers"
       class="asb-link <%= request.getRequestURI().contains("managers") ? "active" : "" %>"
       style="--d:0.15s">
      <span class="asb-icon"><i class="bi bi-person-badge"></i></span>
      <span class="asb-txt">Manage Managers</span>
      <% if (request.getRequestURI().contains("managers")) { %><span class="asb-pip"></span><% } %>
    </a>

    <!-- System -->
    <div class="asb-section-label">System</div>

    <a href="${pageContext.request.contextPath}/admin/config"
       class="asb-link <%= request.getRequestURI().contains("config") ? "active" : "" %>"
       style="--d:0.20s">
      <span class="asb-icon"><i class="bi bi-gear"></i></span>
      <span class="asb-txt">System Config</span>
      <% if (request.getRequestURI().contains("config")) { %><span class="asb-pip"></span><% } %>
    </a>

    <a href="${pageContext.request.contextPath}/admin/reversal"
       class="asb-link <%= request.getRequestURI().contains("reversal") ? "active" : "" %>"
       style="--d:0.25s">
      <span class="asb-icon"><i class="bi bi-arrow-counterclockwise"></i></span>
      <span class="asb-txt">Reverse Transactions</span>
      <% if (request.getRequestURI().contains("reversal")) { %><span class="asb-pip"></span><% } %>
    </a>

    <a href="${pageContext.request.contextPath}/admin/audit-logs"
       class="asb-link <%= request.getRequestURI().contains("audit") ? "active" : "" %>"
       style="--d:0.30s">
      <span class="asb-icon"><i class="bi bi-journal-text"></i></span>
      <span class="asb-txt">Audit Logs</span>
      <% if (request.getRequestURI().contains("audit")) { %><span class="asb-pip"></span><% } %>
    </a>

  </nav>

  <!-- ═══════════════════════════════════════
       FOOTER
       ═══════════════════════════════════════ -->
  <div class="asb-footer">
    <div class="asb-status-row">
      <span class="asb-status-dot"></span>
      <span class="asb-status-txt">Admin Session Active</span>
    </div>
    <a href="${pageContext.request.contextPath}/logout"
       class="asb-link asb-logout"
       onclick="return confirm('Are you sure you want to log out?')">
      <span class="asb-icon"><i class="bi bi-box-arrow-right"></i></span>
      <span class="asb-txt">Logout</span>
    </a>
  </div>

</aside>

<!-- ═══════════════════════════════════════════════════════════
     ADMIN SIDEBAR STYLES — Luxury Banking UI
     ═══════════════════════════════════════════════════════════ -->
<style>
  /* ── Variables ───────────────────────────────────── */
  :root {
    --asb-w          : 240px;
    --asb-bg-top     : #06122b;
    --asb-bg-btm     : #040d1e;
    --asb-gold       : #d4a843;
    --asb-gold-lt    : #f0c96a;
    --asb-gold-dim   : rgba(212,168,67,0.14);
    --asb-purple     : #7c3aed;
    --asb-purple-dim : rgba(124,58,237,0.15);
    --asb-text       : rgba(255,255,255,0.60);
    --asb-text-h     : #ffffff;
    --asb-border     : rgba(255,255,255,0.07);
    --asb-radius     : 10px;
    --asb-ease       : 0.22s cubic-bezier(0.4,0,0.2,1);
  }

  /* ── Sidebar Shell ───────────────────────────────── */
  .admin-sidebar {
    width: var(--asb-w);
    background: linear-gradient(180deg, var(--asb-bg-top) 0%, var(--asb-bg-btm) 100%);
    position: fixed;
    left: 0; top: 0;
    height: 100vh;
    display: flex;
    flex-direction: column;
    z-index: 1000;
    overflow: hidden;
    box-shadow: 4px 0 32px rgba(0,0,0,0.6);
    /* Subtle cross-hatch texture */
    background-image:
      linear-gradient(180deg, #06122b 0%, #040d1e 100%),
      repeating-linear-gradient(
        135deg,
        transparent,
        transparent 30px,
        rgba(255,255,255,0.011) 30px,
        rgba(255,255,255,0.011) 31px
      );
    background-blend-mode: normal;
  }

  /* Top gold accent line */
  .admin-sidebar::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 2px;
    background: linear-gradient(90deg,
      transparent 0%,
      var(--asb-purple) 30%,
      var(--asb-gold) 60%,
      transparent 100%
    );
    opacity: 0.75;
    z-index: 2;
  }

  /* Bottom glow orb */
  .admin-sidebar::after {
    content: '';
    position: absolute;
    bottom: -90px; right: -90px;
    width: 240px; height: 240px;
    border-radius: 50%;
    background: radial-gradient(circle,
      rgba(124,58,237,0.09) 0%,
      transparent 70%
    );
    pointer-events: none;
  }

  /* Scrollbar */
  .admin-sidebar::-webkit-scrollbar { width: 4px; }
  .admin-sidebar::-webkit-scrollbar-track { background: transparent; }
  .admin-sidebar::-webkit-scrollbar-thumb {
    background: rgba(212,168,67,0.28);
    border-radius: 4px;
  }

  /* ── Brand / Logo ────────────────────────────────── */
  .asb-brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    /* Exact padding: top 20px, sides 16px, bottom 16px */
    padding: 20px 16px 16px;
    border-bottom: 1px solid var(--asb-border);
    flex-shrink: 0;
    animation: asbFadeDown 0.45s ease both;
  }

  /* ── Logo Ring (sized for 80×80 logo) ───────────── */
  .asb-logo-ring {
    width: 84px;
    height: 84px;
    border-radius: 50%;
    /* 3px padding inside the conic ring = logo shows at 78px effective */
    padding: 3px;
    background: conic-gradient(
      var(--asb-purple)   0deg,
      var(--asb-gold)     90deg,
      var(--asb-gold-lt) 180deg,
      var(--asb-purple)  270deg,
      var(--asb-purple)  360deg
    );
    margin-bottom: 12px;
    flex-shrink: 0;
    /* Keep the ring perfectly centred */
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow:
      0 0 0 1px rgba(124,58,237,0.25),
      0 0 22px rgba(124,58,237,0.20),
      0 0 10px rgba(212,168,67,0.18);
    animation: ringRotate 12s linear infinite;
  }

  @keyframes ringRotate {
    0%   { filter: hue-rotate(0deg);   }
    50%  { filter: hue-rotate(20deg);  }
    100% { filter: hue-rotate(0deg);   }
  }

  /* Logo image — fills the ring interior */
  .asb-logo-img {
    width: 78px;
    height: 78px;
    object-fit: contain;
    border-radius: 50%;
    display: block;
    background: var(--asb-bg-top);
    /* No extra gap; image sits flush inside the 3px ring */
  }

  /* Fallback icon when image fails */
  .asb-logo-fallback {
    width: 78px;
    height: 78px;
    border-radius: 50%;
    background: linear-gradient(135deg, #1a1a4e, #0A1F44);
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .asb-logo-fallback i {
    font-size: 32px;
    color: var(--asb-gold);
  }

  /* ── Bank name ───────────────────────────────────── */
  .asb-brand-name {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 2px;
  }
  .asb-bank-name {
    font-family: 'Georgia', 'Times New Roman', serif;
    font-size: 0.9rem;
    font-weight: 700;
    color: #fff;
    letter-spacing: 0.9px;
    text-transform: uppercase;
    line-height: 1.2;
  }
  /* "Admin Portal" badge — purple accent to distinguish from customer sidebar */
  .asb-bank-sub {
    font-size: 0.58rem;
    font-weight: 700;
    letter-spacing: 2.2px;
    text-transform: uppercase;
    color: var(--asb-gold-lt);
    background: var(--asb-purple-dim);
    border: 1px solid rgba(124,58,237,0.3);
    border-radius: 20px;
    padding: 2px 10px;
    margin-top: 4px;
  }

  /* Decorative rule with shield icon */
  .asb-brand-rule {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 12px;
    width: 100%;
  }
  .asb-brand-rule span {
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(124,58,237,0.35));
  }
  .asb-brand-rule span:last-child {
    background: linear-gradient(90deg, rgba(124,58,237,0.35), transparent);
  }
  .asb-brand-rule i {
    font-size: 0.42rem;
    color: var(--asb-purple);
    opacity: 0.75;
  }

  /* ── Navigation Area ─────────────────────────────── */
  .asb-nav {
    flex: 1;
    padding: 6px 12px 16px;
    overflow-y: auto;
    overflow-x: hidden;
  }
  .asb-nav::-webkit-scrollbar { width: 3px; }
  .asb-nav::-webkit-scrollbar-thumb {
    background: rgba(124,58,237,0.2);
    border-radius: 3px;
  }

  /* Section labels */
  .asb-section-label {
    font-size: 0.58rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.8px;
    color: rgba(124,58,237,0.55);
    padding: 13px 10px 5px;
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .asb-section-label::after {
    content: '';
    flex: 1;
    height: 1px;
    background: rgba(124,58,237,0.14);
  }

  /* ── Nav Links ───────────────────────────────────── */
  .asb-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 9px 12px;
    margin: 2px 0;
    color: var(--asb-text);
    text-decoration: none;
    border-radius: var(--asb-radius);
    font-size: 0.8rem;
    font-weight: 500;
    letter-spacing: 0.15px;
    transition: all var(--asb-ease);
    position: relative;
    border: 1px solid transparent;
    animation: asbSlideIn 0.4s ease both;
    animation-delay: var(--d, 0s);
  }

  @keyframes asbSlideIn {
    from { opacity: 0; transform: translateX(-10px); }
    to   { opacity: 1; transform: translateX(0); }
  }

  /* Icon box */
  .asb-icon {
    width: 30px; height: 30px;
    border-radius: 7px;
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.05);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.95rem;
    flex-shrink: 0;
    transition: all var(--asb-ease);
  }

  .asb-txt {
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* Active pip */
  .asb-pip {
    width: 5px; height: 5px;
    border-radius: 50%;
    background: var(--asb-gold);
    box-shadow: 0 0 7px var(--asb-gold);
    flex-shrink: 0;
  }

  /* Hover */
  .asb-link:hover {
    color: var(--asb-text-h);
    background: rgba(255,255,255,0.055);
    border-color: rgba(255,255,255,0.06);
    transform: translateX(3px);
  }
  .asb-link:hover .asb-icon {
    background: var(--asb-purple-dim);
    border-color: rgba(124,58,237,0.25);
    color: #a78bfa;
  }

  /* Active */
  .asb-link.active {
    color: var(--asb-gold-lt);
    background: var(--asb-gold-dim);
    border-color: rgba(212,168,67,0.18);
    font-weight: 600;
    box-shadow: 0 2px 14px rgba(212,168,67,0.07);
  }
  .asb-link.active::before {
    content: '';
    position: absolute;
    left: 0; top: 22%; bottom: 22%;
    width: 3px;
    border-radius: 0 3px 3px 0;
    background: linear-gradient(180deg, var(--asb-gold-lt), var(--asb-gold));
    box-shadow: 0 0 10px rgba(212,168,67,0.55);
  }
  .asb-link.active .asb-icon {
    background: rgba(212,168,67,0.14);
    border-color: rgba(212,168,67,0.28);
    color: var(--asb-gold);
    box-shadow: 0 0 10px rgba(212,168,67,0.12);
  }

  /* ── Footer ──────────────────────────────────────── */
  .asb-footer {
    padding: 12px;
    border-top: 1px solid var(--asb-border);
    flex-shrink: 0;
    background: linear-gradient(0deg, rgba(0,0,0,0.28), transparent);
  }

  /* Status row */
  .asb-status-row {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 0 10px 8px;
  }
  .asb-status-dot {
    width: 7px; height: 7px;
    border-radius: 50%;
    background: #7c3aed;
    box-shadow: 0 0 7px #7c3aed;
    animation: asbPulse 1.8s infinite;
    flex-shrink: 0;
  }
  @keyframes asbPulse { 0%,100%{opacity:1;} 50%{opacity:0.25;} }
  .asb-status-txt {
    font-size: 0.6rem;
    color: rgba(255,255,255,0.3);
    letter-spacing: 0.3px;
    white-space: nowrap;
  }

  /* Logout */
  .asb-logout {
    color: rgba(255,255,255,0.48);
    margin: 0;
    animation: none;
  }
  .asb-logout:hover {
    background: rgba(239,68,68,0.12);
    border-color: rgba(239,68,68,0.15);
    color: #f87171;
    transform: translateX(3px);
  }
  .asb-logout:hover .asb-icon {
    background: rgba(239,68,68,0.14);
    border-color: rgba(239,68,68,0.22);
    color: #f87171;
  }

  /* ── Entrance animation ──────────────────────────── */
  @keyframes asbFadeDown {
    from { opacity: 0; transform: translateY(-8px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── Responsive: icon-only on mobile ────────────── */
  @media (max-width: 768px) {
    .admin-sidebar { width: 62px; overflow: visible; }
    .asb-bank-name, .asb-bank-sub, .asb-brand-rule,
    .asb-txt, .asb-pip, .asb-section-label,
    .asb-status-row { display: none; }
    .asb-icon { margin: 0 auto; }
    .asb-link { padding: 10px; justify-content: center; border-radius: 8px; }
    .asb-link.active::before { display: none; }
    .asb-brand { padding: 14px 8px; }
    /* Ring shrinks but stays proportional */
    .asb-logo-ring { width: 46px; height: 46px; }
    .asb-logo-img, .asb-logo-fallback { width: 40px; height: 40px; }
  }
</style>
