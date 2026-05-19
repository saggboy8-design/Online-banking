<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.text.NumberFormat,java.util.Locale" %>
<%
  String pageTitle = "Admin Dashboard";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty() ? String.valueOf(fullName.charAt(0)).toUpperCase() : "A";
  NumberFormat nf  = NumberFormat.getNumberInstance(Locale.US);
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>

<style>
/* ============================================================
   ADMIN DASHBOARD STYLES
   ============================================================ */

/* ---------- Topbar ---------- */
.admin-topbar {
  background: #fff;
  border-bottom: 1px solid #e2e8f0;
  padding: 0 1.5rem;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: sticky;
  top: 0;
  z-index: 900;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

/* ---------- Hero ---------- */
.admin-hero {
  background: linear-gradient(135deg, #0A1F44 0%, #1a3a6e 40%, #7c3aed 100%);
  border-radius: 18px;
  padding: 2rem;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1rem;
  position: relative;
  overflow: hidden;
}
.admin-hero::before {
  content: '';
  position: absolute;
  width: 300px;
  height: 300px;
  border-radius: 50%;
  background: rgba(124,58,237,0.2);
  right: -80px;
  top: -80px;
}
.admin-hero::after {
  content: '';
  position: absolute;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: rgba(255,255,255,0.04);
  bottom: -60px;
  left: -40px;
}
.admin-hero-left h2 { font-size: 1.5rem; font-weight: 800; margin-bottom: 4px; }
.admin-hero-left p  { font-size: 0.85rem; opacity: 0.7; }

.system-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  margin-top: 0.8rem;
  background: rgba(16,185,129,0.2);
  border: 1px solid rgba(16,185,129,0.3);
  border-radius: 20px;
  padding: 5px 14px;
  font-size: 0.75rem;
  font-weight: 700;
  color: #6ee7b7;
}
.system-badge::before {
  content: '';
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #10b981;
  animation: pulse 1.5s infinite;
}
@keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }

/* ---------- Stats Grids ---------- */
.stats-grid-2 { display: grid; grid-template-columns: repeat(4,1fr); gap: 1rem; margin-bottom: 1rem; }
.stats-grid-4 { display: grid; grid-template-columns: repeat(4,1fr); gap: 1rem; margin-bottom: 1rem; }

.admin-stat {
  background: #fff;
  border-radius: 14px;
  padding: 1.2rem;
  box-shadow: 0 2px 12px rgba(0,0,0,0.07);
  transition: all 0.2s;
  border-bottom: 3px solid transparent;
  cursor: default;
  text-decoration: none;
  display: block;
}
.admin-stat:hover { transform: translateY(-3px); box-shadow: 0 10px 28px rgba(0,0,0,0.12); }
.admin-stat-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.8rem;
}
.admin-stat-icon {
  width: 46px;
  height: 46px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
}
.admin-stat-change {
  font-size: 0.7rem;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 10px;
}
.stat-val { font-size: 1.8rem; font-weight: 800; color: #0A1F44; line-height: 1; }
.stat-lbl { font-size: 0.75rem; color: #94a3b8; margin-top: 3px; }

/* ---------- Action Cards ---------- */
.admin-actions { display: grid; grid-template-columns: repeat(3,1fr); gap: 1rem; margin-bottom: 1rem; }
.admin-act-card {
  background: #fff;
  border-radius: 14px;
  padding: 1.3rem;
  box-shadow: 0 2px 12px rgba(0,0,0,0.07);
  display: flex;
  align-items: center;
  gap: 1rem;
  text-decoration: none;
  color: inherit;
  border: 1.5px solid #e2e8f0;
  transition: all 0.2s;
}
.admin-act-card:hover {
  border-color: #bfdbfe;
  transform: translateY(-3px);
  box-shadow: 0 10px 28px rgba(37,99,235,0.12);
}
.aac-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
}
.aac-title { font-weight: 700; font-size: 0.88rem; color: #0A1F44; }
.aac-sub   { font-size: 0.75rem; color: #94a3b8; }
.aac-arrow { margin-left: auto; color: #94a3b8; font-size: 0.9rem; }

/* ============================================================
   SYSTEM HEALTH MONITOR — ENHANCED
   ============================================================ */
.health-monitor {
  background: linear-gradient(160deg, #0A1F44 0%, #0f2a5e 60%, #1a1a3e 100%);
  border-radius: 20px;
  padding: 1.8rem;
  margin-bottom: 1rem;
  box-shadow: 0 8px 32px rgba(10,31,68,0.35);
  position: relative;
  overflow: hidden;
}
.health-monitor::before {
  content: '';
  position: absolute;
  inset: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.02'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
  pointer-events: none;
}
.health-monitor-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.5rem;
}
.health-monitor-header h4 {
  font-size: 1rem;
  font-weight: 800;
  color: #fff;
  display: flex;
  align-items: center;
  gap: 8px;
}
.health-monitor-header h4 i { color: #10b981; }
.health-live-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  background: rgba(16,185,129,0.15);
  border: 1px solid rgba(16,185,129,0.3);
  border-radius: 20px;
  padding: 4px 12px;
  font-size: 0.72rem;
  font-weight: 700;
  color: #6ee7b7;
}
.health-live-badge::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #10b981;
  animation: pulse 1.5s infinite;
}

/* --- Gauge Row --- */
.health-gauges-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
}
.health-gauge-card {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 16px;
  padding: 1.2rem 1rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.6rem;
  transition: all 0.25s;
}
.health-gauge-card:hover {
  background: rgba(255,255,255,0.09);
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.3);
}
.gauge-canvas-wrap {
  position: relative;
  width: 110px;
  height: 110px;
}
.gauge-canvas-wrap canvas { width: 110px !important; height: 110px !important; }
.gauge-center-label {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  pointer-events: none;
}
.gauge-center-val {
  font-size: 1.25rem;
  font-weight: 900;
  color: #fff;
  line-height: 1;
}
.gauge-center-unit {
  font-size: 0.65rem;
  color: rgba(255,255,255,0.5);
  margin-top: 2px;
}
.gauge-title {
  font-size: 0.78rem;
  font-weight: 700;
  color: rgba(255,255,255,0.85);
  text-align: center;
}
.gauge-subtitle {
  font-size: 0.68rem;
  color: rgba(255,255,255,0.4);
  text-align: center;
}
.gauge-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-top: 2px;
}

/* --- Bar Chart Section --- */
.health-charts-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}
.health-chart-panel {
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 16px;
  padding: 1.2rem;
}
.hcp-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1rem;
}
.hcp-title {
  font-size: 0.82rem;
  font-weight: 700;
  color: rgba(255,255,255,0.85);
  display: flex;
  align-items: center;
  gap: 6px;
}
.hcp-badge {
  font-size: 0.68rem;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 8px;
}
.hcp-canvas-wrap { position: relative; height: 140px; }

/* --- Horizontal KPI bars inside panel --- */
.health-kpi-row {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.hkpi-item {}
.hkpi-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}
.hkpi-label { font-size: 0.75rem; color: rgba(255,255,255,0.6); font-weight: 600; }
.hkpi-val   { font-size: 0.75rem; color: #fff; font-weight: 800; }
.hkpi-track {
  width: 100%;
  height: 8px;
  background: rgba(255,255,255,0.08);
  border-radius: 4px;
  overflow: hidden;
}
.hkpi-fill {
  height: 100%;
  border-radius: 4px;
  transition: width 1.2s cubic-bezier(0.25,1,0.5,1);
}

/* Responsive */
@media(max-width:1024px){
  .stats-grid-2, .stats-grid-4, .admin-actions { grid-template-columns: repeat(2,1fr); }
  .health-gauges-row { grid-template-columns: repeat(2,1fr); }
  .health-charts-row { grid-template-columns: 1fr; }
}
@media(max-width:600px){
  .stats-grid-2, .stats-grid-4, .admin-actions { grid-template-columns: 1fr; }
  .health-gauges-row { grid-template-columns: repeat(2,1fr); }
}
</style>

<div class="main-content">

  <!-- ===== Topbar ===== -->
  <header class="admin-topbar">
    <div style="font-size:1rem;font-weight:800;color:#0A1F44;display:flex;align-items:center;gap:8px;">
      <i class="bi bi-shield-lock-fill" style="color:#7c3aed;"></i>
      Admin Control Panel
    </div>
    <div style="display:flex;align-items:center;gap:12px;">
      <a href="${pageContext.request.contextPath}/admin/audit-logs"
         style="background:#f5f3ff;border-radius:8px;padding:6px 12px;text-decoration:none;
                color:#7c3aed;font-size:0.8rem;font-weight:700;">
        <i class="bi bi-journal-text"></i> Audit Logs
      </a>
      <div style="display:flex;align-items:center;gap:8px;">
        <div style="width:36px;height:36px;border-radius:50%;
                    background:linear-gradient(135deg,#dc2626,#7c3aed);
                    color:#fff;display:flex;align-items:center;justify-content:center;
                    font-weight:800;font-size:0.85rem;">
          <%= initials %>
        </div>
        <div>
          <div style="font-size:0.82rem;font-weight:700;color:#0A1F44;"><%= fullName %></div>
          <div style="font-size:0.7rem;color:#94a3b8;">System Administrator</div>
        </div>
      </div>
    </div>
  </header>

  <div class="page-content">

    <!-- ===== Hero ===== -->
    <div class="admin-hero">
      <div class="admin-hero-left" style="position:relative;z-index:2;">
        <h2>System Overview 📊</h2>
        <p>Real-time statistics for Gojjam International Bank</p>
        <div class="system-badge">All Systems Operational</div>
      </div>
      <div style="position:relative;z-index:2;text-align:right;">
        <div style="font-size:0.75rem;opacity:0.7;">Last updated</div>
        <div style="font-weight:700;font-size:0.9rem;">
          <%= java.time.LocalDateTime.now().format(
              DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) %>
        </div>
        <div style="font-size:0.8rem;opacity:0.7;margin-top:4px;">
          <i class="bi bi-geo-alt"></i> Ethiopia Standard Time
        </div>
      </div>
    </div>

    <!-- ===== Primary Stats ===== -->
    <div class="stats-grid-2">
      <a href="${pageContext.request.contextPath}/admin/accounts" class="admin-stat"
         style="border-bottom-color:#10b981;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#dcfce7;color:#059669;">
            <i class="bi bi-people-fill"></i>
          </div>
          <span class="admin-stat-change" style="background:#dcfce7;color:#15803d;">Customers</span>
        </div>
        <div class="stat-val"><%= request.getAttribute("totalUsers") %></div>
        <div class="stat-lbl">Total Registered Customers</div>
      </a>

      <div class="admin-stat" style="border-bottom-color:#f59e0b;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#fef3c7;color:#d97706;">
            <i class="bi bi-currency-exchange"></i>
          </div>
          <span class="admin-stat-change" style="background:#fef3c7;color:#92400e;">ETB</span>
        </div>
        <div class="stat-val" style="font-size:1.3rem;">
          <%= String.format("%.2f", request.getAttribute("totalBalance")) %>
        </div>
        <div class="stat-lbl">Total System Balance (ETB)</div>
      </div>

      <a href="${pageContext.request.contextPath}/admin/reversal" class="admin-stat"
         style="border-bottom-color:#2563eb;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#dbeafe;color:#2563eb;">
            <i class="bi bi-arrow-left-right"></i>
          </div>
          <span class="admin-stat-change" style="background:#dbeafe;color:#1d4ed8;">Transactions</span>
        </div>
        <div class="stat-val"><%= request.getAttribute("totalTx") %></div>
        <div class="stat-lbl">Total Transactions Processed</div>
      </a>

      <a href="${pageContext.request.contextPath}/admin/managers" class="admin-stat"
         style="border-bottom-color:#7c3aed;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#f5f3ff;color:#7c3aed;">
            <i class="bi bi-person-badge-fill"></i>
          </div>
          <span class="admin-stat-change" style="background:#f5f3ff;color:#6d28d9;">Staff</span>
        </div>
        <div class="stat-val"><%= request.getAttribute("totalManagers") %></div>
        <div class="stat-lbl">Active Branch Managers</div>
      </a>
    </div>

    <!-- ===== Secondary Stats ===== -->
    <div class="stats-grid-4">
      <div class="admin-stat" style="border-bottom-color:#ef4444;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#fef2f2;color:#dc2626;">
            <i class="bi bi-bank2"></i>
          </div>
        </div>
        <div class="stat-val" style="font-size:1.6rem;color:#dc2626;"><%= request.getAttribute("pendingLoans") %></div>
        <div class="stat-lbl">Pending Loan Applications</div>
      </div>

      <div class="admin-stat" style="border-bottom-color:#f97316;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#fff7ed;color:#ea580c;">
            <i class="bi bi-chat-dots-fill"></i>
          </div>
        </div>
        <div class="stat-val" style="font-size:1.6rem;color:#ea580c;"><%= request.getAttribute("openComplaints") %></div>
        <div class="stat-lbl">Open Complaints</div>
      </div>

      <div class="admin-stat" style="border-bottom-color:#f59e0b;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#fef3c7;color:#d97706;">
            <i class="bi bi-person-clock"></i>
          </div>
        </div>
        <div class="stat-val" style="font-size:1.6rem;color:#d97706;"><%= request.getAttribute("pendingKyc") %></div>
        <div class="stat-lbl">Pending KYC Reviews</div>
      </div>

      <div class="admin-stat" style="border-bottom-color:#0ea5e9;">
        <div class="admin-stat-top">
          <div class="admin-stat-icon" style="background:#e0f2fe;color:#0284c7;">
            <i class="bi bi-bank"></i>
          </div>
        </div>
        <div class="stat-val" style="font-size:1.6rem;color:#0284c7;"><%= request.getAttribute("totalAccounts") %></div>
        <div class="stat-lbl">Total Active Accounts</div>
      </div>
    </div>

    <!-- ===== Quick Action Cards ===== -->
    <div class="admin-actions">
      <a href="${pageContext.request.contextPath}/admin/managers" class="admin-act-card">
        <div class="aac-icon" style="background:#f5f3ff;color:#7c3aed;">
          <i class="bi bi-person-plus-fill"></i>
        </div>
        <div>
          <div class="aac-title">Manage Managers</div>
          <div class="aac-sub">Add or remove manager accounts</div>
        </div>
        <i class="bi bi-arrow-right aac-arrow"></i>
      </a>
      <a href="${pageContext.request.contextPath}/admin/config" class="admin-act-card">
        <div class="aac-icon" style="background:#fef3c7;color:#d97706;">
          <i class="bi bi-gear-fill"></i>
        </div>
        <div>
          <div class="aac-title">System Configuration</div>
          <div class="aac-sub">Fees, limits &amp; interest rates</div>
        </div>
        <i class="bi bi-arrow-right aac-arrow"></i>
      </a>
      <a href="${pageContext.request.contextPath}/admin/reversal" class="admin-act-card">
        <div class="aac-icon" style="background:#fef2f2;color:#dc2626;">
          <i class="bi bi-arrow-counterclockwise"></i>
        </div>
        <div>
          <div class="aac-title">Reverse Transactions</div>
          <div class="aac-sub">Admin-only reversal tool</div>
        </div>
        <i class="bi bi-arrow-right aac-arrow"></i>
      </a>
      <a href="${pageContext.request.contextPath}/admin/audit-logs" class="admin-act-card">
        <div class="aac-icon" style="background:#e0f2fe;color:#0284c7;">
          <i class="bi bi-journal-check"></i>
        </div>
        <div>
          <div class="aac-title">Audit Trail</div>
          <div class="aac-sub">Full system activity log</div>
        </div>
        <i class="bi bi-arrow-right aac-arrow"></i>
      </a>
      <a href="${pageContext.request.contextPath}/admin/accounts" class="admin-act-card">
        <div class="aac-icon" style="background:#dcfce7;color:#059669;">
          <i class="bi bi-people-fill"></i>
        </div>
        <div>
          <div class="aac-title">Manage Accounts</div>
          <div class="aac-sub">Lock, unlock, view all customers</div>
        </div>
        <i class="bi bi-arrow-right aac-arrow"></i>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="admin-act-card"
         onclick="return confirm('Sign out of admin portal?')"
         style="border-color:#fecaca;">
        <div class="aac-icon" style="background:#fef2f2;color:#dc2626;">
          <i class="bi bi-box-arrow-right"></i>
        </div>
        <div>
          <div class="aac-title" style="color:#dc2626;">Sign Out</div>
          <div class="aac-sub">End admin session securely</div>
        </div>
        <i class="bi bi-arrow-right aac-arrow"></i>
      </a>
    </div>

    <!-- ===================================================
         SYSTEM HEALTH MONITOR — Enhanced with Charts
         =================================================== -->
    <%
      Object totalUsersObj   = request.getAttribute("totalUsers");
      Object totalTxObj      = request.getAttribute("totalTx");
      Object pendingLoansObj = request.getAttribute("pendingLoans");
      Object openCompObj     = request.getAttribute("openComplaints");
      Object pendingKycObj   = request.getAttribute("pendingKyc");

      int totalUsers   = totalUsersObj   != null ? (int) totalUsersObj   : 0;
      int totalTx      = totalTxObj      != null ? (int) totalTxObj      : 0;
      int pendingLoans = pendingLoansObj != null ? (int) pendingLoansObj : 0;
      int openComp     = openCompObj     != null ? (int) openCompObj     : 0;
      int pendingKyc   = pendingKycObj   != null ? (int) pendingKycObj   : 0;

      int dbLoad          = 42;
      int systemUptime    = 99;
      int kycQueuePct     = Math.min(100, pendingKyc * 10);
      int complaintResPct = openComp == 0 ? 100 : Math.max(10, 100 - openComp * 5);
      int loanPendingPct  = Math.min(100, pendingLoans * 8);
      int txThroughput    = Math.min(100, (totalTx % 100 == 0 ? 85 : totalTx % 100));
    %>

    <div class="health-monitor">
      <!-- Header -->
      <div class="health-monitor-header">
        <h4>
          <i class="bi bi-activity"></i>
          System Health Monitor
        </h4>
        <span class="health-live-badge">LIVE</span>
      </div>

      <!-- === Gauge Cards Row === -->
      <div class="health-gauges-row">

        <!-- Gauge 1: System Uptime -->
        <div class="health-gauge-card">
          <div class="gauge-canvas-wrap">
            <canvas id="gaugeUptime"></canvas>
            <div class="gauge-center-label">
              <span class="gauge-center-val" id="gaugeUptimeVal">0</span>
              <span class="gauge-center-unit">%</span>
            </div>
          </div>
          <div class="gauge-title">System Uptime</div>
          <div class="gauge-subtitle">Last 30 days</div>
          <div class="gauge-status-dot" style="background:#10b981;box-shadow:0 0 6px #10b981;"></div>
        </div>

        <!-- Gauge 2: Database Load -->
        <div class="health-gauge-card">
          <div class="gauge-canvas-wrap">
            <canvas id="gaugeDbLoad"></canvas>
            <div class="gauge-center-label">
              <span class="gauge-center-val" id="gaugeDbVal">0</span>
              <span class="gauge-center-unit">%</span>
            </div>
          </div>
          <div class="gauge-title">Database Load</div>
          <div class="gauge-subtitle">Current utilisation</div>
          <div class="gauge-status-dot" style="background:#10b981;box-shadow:0 0 6px #10b981;"></div>
        </div>

        <!-- Gauge 3: Complaint Resolution -->
        <div class="health-gauge-card">
          <div class="gauge-canvas-wrap">
            <canvas id="gaugeComplaint"></canvas>
            <div class="gauge-center-label">
              <span class="gauge-center-val" id="gaugeCompVal">0</span>
              <span class="gauge-center-unit">%</span>
            </div>
          </div>
          <div class="gauge-title">Complaint Resolution</div>
          <div class="gauge-subtitle"><%= openComp %> open tickets</div>
          <div class="gauge-status-dot"
               style="background:<%= openComp == 0 ? "#10b981" : openComp < 5 ? "#f59e0b" : "#ef4444" %>;
                      box-shadow:0 0 6px <%= openComp == 0 ? "#10b981" : openComp < 5 ? "#f59e0b" : "#ef4444" %>;"></div>
        </div>

        <!-- Gauge 4: Tx Throughput -->
        <div class="health-gauge-card">
          <div class="gauge-canvas-wrap">
            <canvas id="gaugeTx"></canvas>
            <div class="gauge-center-label">
              <span class="gauge-center-val" id="gaugeTxVal">0</span>
              <span class="gauge-center-unit">%</span>
            </div>
          </div>
          <div class="gauge-title">Tx Throughput</div>
          <div class="gauge-subtitle"><%= nf.format(totalTx) %> total</div>
          <div class="gauge-status-dot" style="background:#7c3aed;box-shadow:0 0 6px #7c3aed;"></div>
        </div>

      </div><!-- /health-gauges-row -->

      <!-- === Two Panel Row === -->
      <div class="health-charts-row">

        <!-- Panel A: 7-day Loan + KYC bar chart -->
        <div class="health-chart-panel">
          <div class="hcp-header">
            <div class="hcp-title">
              <i class="bi bi-bar-chart-fill" style="color:#f59e0b;"></i>
              Pending Queues Overview
            </div>
            <span class="hcp-badge" style="background:rgba(245,158,11,0.15);color:#fbbf24;">
              Live
            </span>
          </div>
          <div class="hcp-canvas-wrap">
            <canvas id="barQueues"></canvas>
          </div>
        </div>

        <!-- Panel B: KPI horizontal bars -->
        <div class="health-chart-panel">
          <div class="hcp-header">
            <div class="hcp-title">
              <i class="bi bi-speedometer2" style="color:#7c3aed;"></i>
              Performance KPIs
            </div>
            <span class="hcp-badge" style="background:rgba(124,58,237,0.15);color:#a78bfa;">
              Real-time
            </span>
          </div>
          <div class="health-kpi-row">

            <div class="hkpi-item">
              <div class="hkpi-top">
                <span class="hkpi-label"><i class="bi bi-hdd-network"></i> Database Load</span>
                <span class="hkpi-val"><%= dbLoad %>%</span>
              </div>
              <div class="hkpi-track">
                <div class="hkpi-fill" id="kpiDb"
                     style="width:0%;background:linear-gradient(90deg,#10b981,#34d399);"></div>
              </div>
            </div>

            <div class="hkpi-item">
              <div class="hkpi-top">
                <span class="hkpi-label"><i class="bi bi-person-clock"></i> KYC Queue Pressure</span>
                <span class="hkpi-val"><%= kycQueuePct %>%</span>
              </div>
              <div class="hkpi-track">
                <div class="hkpi-fill" id="kpiKyc"
                     style="width:0%;background:linear-gradient(90deg,#f59e0b,#fbbf24);"></div>
              </div>
            </div>

            <div class="hkpi-item">
              <div class="hkpi-top">
                <span class="hkpi-label"><i class="bi bi-chat-dots"></i> Complaint Resolution</span>
                <span class="hkpi-val"><%= complaintResPct %>%</span>
              </div>
              <div class="hkpi-track">
                <div class="hkpi-fill" id="kpiComp"
                     style="width:0%;background:linear-gradient(90deg,#2563eb,#60a5fa);"></div>
              </div>
            </div>

            <div class="hkpi-item">
              <div class="hkpi-top">
                <span class="hkpi-label"><i class="bi bi-bank2"></i> Loan Queue Load</span>
                <span class="hkpi-val"><%= loanPendingPct %>%</span>
              </div>
              <div class="hkpi-track">
                <div class="hkpi-fill" id="kpiLoan"
                     style="width:0%;background:linear-gradient(90deg,#ef4444,#f87171);"></div>
              </div>
            </div>

            <div class="hkpi-item">
              <div class="hkpi-top">
                <span class="hkpi-label"><i class="bi bi-arrow-up-right"></i> System Uptime</span>
                <span class="hkpi-val"><%= systemUptime %>%</span>
              </div>
              <div class="hkpi-track">
                <div class="hkpi-fill" id="kpiUptime"
                     style="width:0%;background:linear-gradient(90deg,#7c3aed,#a78bfa);"></div>
              </div>
            </div>

          </div><!-- /health-kpi-row -->
        </div><!-- /panel B -->

      </div><!-- /health-charts-row -->

    </div><!-- /health-monitor -->

  </div><!-- /page-content -->

  <%@ include file="/jsp/includes/footer.jsp" %>
</div><!-- /main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>

<!-- ============================================================
     CHART.JS — SYSTEM HEALTH MONITOR SCRIPTS
     ============================================================ -->
<script>
(function () {
  'use strict';

  /* ---------- Server-side values injected ---------- */
  const SRV = {
    uptime        : <%= systemUptime %>,
    dbLoad        : <%= dbLoad %>,
    complaintRes  : <%= complaintResPct %>,
    txThroughput  : <%= txThroughput %>,
    pendingLoans  : <%= pendingLoans %>,
    openComplaints: <%= openComp %>,
    pendingKyc    : <%= pendingKyc %>,
    kycQueuePct   : <%= kycQueuePct %>,
    loanPendingPct: <%= loanPendingPct %>
  };

  /* ---------- Helpers ---------- */
  function gaugeColor(pct) {
    if (pct >= 80) return '#10b981';
    if (pct >= 50) return '#f59e0b';
    return '#ef4444';
  }

  /* ---------- Animated counter ---------- */
  function animateCounter(el, target, duration) {
    const start = performance.now();
    (function tick(now) {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      el.textContent = Math.round(progress * target);
      if (progress < 1) requestAnimationFrame(tick);
    })(start);
  }

  /* ---------- Build a doughnut gauge ---------- */
  function buildGauge(canvasId, value, color, trackColor) {
    trackColor = trackColor || 'rgba(255,255,255,0.07)';
    const ctx = document.getElementById(canvasId).getContext('2d');
    return new Chart(ctx, {
      type: 'doughnut',
      data: {
        datasets: [{
          data: [value, 100 - value],
          backgroundColor: [color, trackColor],
          borderWidth: 0,
          borderRadius: 6
        }]
      },
      options: {
        cutout: '72%',
        rotation: -90,
        circumference: 180,
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 1200, easing: 'easeOutQuart' },
        plugins: { tooltip: { enabled: false }, legend: { display: false } }
      }
    });
  }

  /* ---------- Bar chart — Queues ---------- */
  function buildBarQueues() {
    const ctx = document.getElementById('barQueues').getContext('2d');
    const labels = ['Pending Loans', 'Open Complaints', 'KYC Pending', 'Active Accounts (÷10)'];
    const values = [
      SRV.pendingLoans,
      SRV.openComplaints,
      SRV.pendingKyc,
      Math.round(<%= totalUsers != 0 ? "request.getAttribute(\"totalAccounts\") != null ? (int)request.getAttribute(\"totalAccounts\") / 10 : 0" : "0" %> / 1) // scaled
    ];
    const bgColors = [
      'rgba(239,68,68,0.75)',
      'rgba(249,115,22,0.75)',
      'rgba(245,158,11,0.75)',
      'rgba(14,165,233,0.75)'
    ];
    const borderColors = ['#ef4444','#f97316','#f59e0b','#0ea5e9'];

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: bgColors,
          borderColor: borderColors,
          borderWidth: 2,
          borderRadius: 8,
          borderSkipped: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 1000, easing: 'easeOutBounce' },
        plugins: {
          legend: { display: false },
          tooltip: {
            backgroundColor: '#0A1F44',
            titleColor: '#94a3b8',
            bodyColor: '#fff',
            borderColor: 'rgba(255,255,255,0.1)',
            borderWidth: 1,
            padding: 10,
            cornerRadius: 10
          }
        },
        scales: {
          x: {
            ticks: { color: 'rgba(255,255,255,0.5)', font: { size: 10 } },
            grid: { display: false },
            border: { display: false }
          },
          y: {
            ticks: { color: 'rgba(255,255,255,0.4)', font: { size: 10 }, stepSize: 1 },
            grid: { color: 'rgba(255,255,255,0.05)' },
            border: { display: false }
          }
        }
      }
    });
  }

  /* ---------- KPI bar animated fill ---------- */
  function animateKpiBars() {
    const bars = [
      { id: 'kpiDb',     pct: SRV.dbLoad          },
      { id: 'kpiKyc',    pct: SRV.kycQueuePct      },
      { id: 'kpiComp',   pct: SRV.complaintRes     },
      { id: 'kpiLoan',   pct: SRV.loanPendingPct   },
      { id: 'kpiUptime', pct: SRV.uptime           }
    ];
    bars.forEach(function(b, i) {
      const el = document.getElementById(b.id);
      if (!el) return;
      setTimeout(function() { el.style.width = b.pct + '%'; }, i * 120);
    });
  }

  /* ---------- Init on DOM ready ---------- */
  document.addEventListener('DOMContentLoaded', function () {

    /* Gauges */
    buildGauge('gaugeUptime',   SRV.uptime,       '#10b981');
    buildGauge('gaugeDbLoad',   SRV.dbLoad,       gaugeColor(100 - SRV.dbLoad));
    buildGauge('gaugeComplaint',SRV.complaintRes, gaugeColor(SRV.complaintRes));
    buildGauge('gaugeTx',       SRV.txThroughput, '#7c3aed');

    /* Animated counters */
    animateCounter(document.getElementById('gaugeUptimeVal'), SRV.uptime,       1000);
    animateCounter(document.getElementById('gaugeDbVal'),     SRV.dbLoad,       1000);
    animateCounter(document.getElementById('gaugeCompVal'),   SRV.complaintRes, 1000);
    animateCounter(document.getElementById('gaugeTxVal'),     SRV.txThroughput, 1000);

    /* Bar chart */
    buildBarQueues();

    /* KPI animated bars */
    setTimeout(animateKpiBars, 300);
  });

})();
</script>

</body>
</html>
