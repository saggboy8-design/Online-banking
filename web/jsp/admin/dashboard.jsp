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

<style>
/* Admin Dashboard Specific */
.admin-topbar {
  background:#fff;border-bottom:1px solid #e2e8f0;
  padding:0 1.5rem;height:64px;display:flex;align-items:center;
  justify-content:space-between;position:sticky;top:0;z-index:900;
  box-shadow:0 2px 8px rgba(0,0,0,0.05);
}

.admin-hero {
  background:linear-gradient(135deg,#0A1F44 0%,#1a3a6e 40%,#7c3aed 100%);
  border-radius:18px;padding:2rem;color:#fff;
  display:flex;align-items:center;justify-content:space-between;
  margin-bottom:1rem;position:relative;overflow:hidden;
}
.admin-hero::before {
  content:'';position:absolute;width:300px;height:300px;border-radius:50%;
  background:rgba(124,58,237,0.2);right:-80px;top:-80px;
}
.admin-hero::after {
  content:'';position:absolute;width:200px;height:200px;border-radius:50%;
  background:rgba(255,255,255,0.04);bottom:-60px;left:-40px;
}
.admin-hero-left h2 { font-size:1.5rem;font-weight:800;margin-bottom:4px; }
.admin-hero-left p  { font-size:0.85rem;opacity:0.7; }

.system-badge {
  display:inline-flex;align-items:center;gap:6px;margin-top:0.8rem;
  background:rgba(16,185,129,0.2);border:1px solid rgba(16,185,129,0.3);
  border-radius:20px;padding:5px 14px;font-size:0.75rem;font-weight:700;color:#6ee7b7;
}
.system-badge::before {
  content:'';width:8px;height:8px;border-radius:50%;
  background:#10b981;animation:pulse 1.5s infinite;
}
@keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }

/* Stats Grid */
.stats-grid-2 { display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1rem; }
.stats-grid-4 { display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1rem; }

.admin-stat {
  background:#fff;border-radius:14px;padding:1.2rem;
  box-shadow:0 2px 12px rgba(0,0,0,0.07);
  transition:all 0.2s;border-bottom:3px solid transparent;
  cursor:default;text-decoration:none;display:block;
}
.admin-stat:hover { transform:translateY(-3px);box-shadow:0 10px 28px rgba(0,0,0,0.12); }
.admin-stat-top {
  display:flex;align-items:center;justify-content:space-between;margin-bottom:0.8rem;
}
.admin-stat-icon {
  width:46px;height:46px;border-radius:12px;
  display:flex;align-items:center;justify-content:center;font-size:1.2rem;
}
.admin-stat-change {
  font-size:0.7rem;font-weight:700;padding:2px 8px;border-radius:10px;
}
.stat-val { font-size:1.8rem;font-weight:800;color:#0A1F44;line-height:1; }
.stat-lbl { font-size:0.75rem;color:#94a3b8;margin-top:3px; }

/* Action Cards */
.admin-actions { display:grid;grid-template-columns:repeat(3,1fr);gap:1rem;margin-bottom:1rem; }
.admin-act-card {
  background:#fff;border-radius:14px;padding:1.3rem;
  box-shadow:0 2px 12px rgba(0,0,0,0.07);
  display:flex;align-items:center;gap:1rem;
  text-decoration:none;color:inherit;
  border:1.5px solid #e2e8f0;transition:all 0.2s;
}
.admin-act-card:hover {
  border-color:#bfdbfe;transform:translateY(-3px);
  box-shadow:0 10px 28px rgba(37,99,235,0.12);
}
.aac-icon {
  width:48px;height:48px;border-radius:12px;flex-shrink:0;
  display:flex;align-items:center;justify-content:center;font-size:1.2rem;
}
.aac-title { font-weight:700;font-size:0.88rem;color:#0A1F44; }
.aac-sub   { font-size:0.75rem;color:#94a3b8; }
.aac-arrow { margin-left:auto;color:#94a3b8;font-size:0.9rem; }

/* System Health Bar */
.health-bar {
  background:#fff;border-radius:14px;padding:1.2rem;
  box-shadow:0 2px 12px rgba(0,0,0,0.07);margin-bottom:1rem;
}
.health-bar h4 { font-size:0.88rem;font-weight:700;color:#0A1F44;margin-bottom:0.8rem; }
.health-item { display:flex;align-items:center;gap:0.8rem;margin-bottom:0.5rem; }
.health-label { font-size:0.78rem;color:#94a3b8;min-width:110px; }
.h-bar-wrap { flex:1;height:8px;background:#f1f5f9;border-radius:4px;overflow:hidden; }
.h-bar-fill { height:100%;border-radius:4px;transition:width 1s ease; }
.health-pct { font-size:0.75rem;font-weight:700;color:#0A1F44;min-width:35px;text-align:right; }

@media(max-width:1024px){
  .stats-grid-2,.stats-grid-4,.admin-actions{ grid-template-columns:repeat(2,1fr); }
}
@media(max-width:600px){
  .stats-grid-2,.stats-grid-4,.admin-actions{ grid-template-columns:1fr; }
}
</style>

<div class="main-content">

  <!-- Topbar -->
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

    <!-- Hero -->
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

    <!-- Primary Stats -->
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

    <!-- Secondary Stats -->
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

    <!-- Quick Action Cards -->
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
          <div class="aac-sub">Fees, limits & interest rates</div>
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

    <!-- System Health -->
    <div class="health-bar">
      <h4><i class="bi bi-activity" style="color:#10b981;"></i> System Health Monitor</h4>
      <% Object totalUsersObj    = request.getAttribute("totalUsers");
         Object totalTxObj       = request.getAttribute("totalTx");
         Object pendingLoansObj  = request.getAttribute("pendingLoans");
         Object openCompObj      = request.getAttribute("openComplaints");
         int totalUsers   = totalUsersObj   != null ? (int) totalUsersObj   : 0;
         int totalTx      = totalTxObj      != null ? (int) totalTxObj      : 0;
         int pendingLoans = pendingLoansObj != null ? (int) pendingLoansObj : 0;
         int openComp     = openCompObj     != null ? (int) openCompObj     : 0;
      %>
      <div class="health-item">
        <div class="health-label">Database Load</div>
        <div class="h-bar-wrap">
          <div class="h-bar-fill" style="width:42%;background:#10b981;"></div>
        </div>
        <div class="health-pct" style="color:#10b981;">42%</div>
      </div>
      <div class="health-item">
        <div class="health-label">KYC Queue</div>
        <div class="h-bar-wrap">
          <div class="h-bar-fill"
               style="width:<%= Math.min(100,pendingLoans*10) %>%;background:#f59e0b;"></div>
        </div>
        <div class="health-pct" style="color:#f59e0b;"><%= pendingLoans %> pending</div>
      </div>
      <div class="health-item">
        <div class="health-label">Complaint Resolution</div>
        <div class="h-bar-wrap">
          <div class="h-bar-fill"
               style="width:<%= openComp > 0 ? Math.min(100,100-openComp*5) : 100 %>%;background:#2563eb;"></div>
        </div>
        <div class="health-pct" style="color:#2563eb;">
          <%= openComp == 0 ? "100%" : (100-Math.min(openComp*5,90))+"%" %>
        </div>
      </div>
      <div class="health-item">
        <div class="health-label">System Uptime</div>
        <div class="h-bar-wrap">
          <div class="h-bar-fill" style="width:99%;background:#10b981;"></div>
        </div>
        <div class="health-pct" style="color:#10b981;">99%</div>
      </div>
    </div>

  </div><!-- page-content -->

  <%@ include file="/jsp/includes/footer.jsp" %>
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>