<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <!-- Logo above text -->
    <div class="logo-wrapper">
      <img src="${pageContext.request.contextPath}/images/logo.png" 
           alt="Gojjam Bank Logo" 
           class="sidebar-logo-img"
           onerror="this.style.display='none'; this.parentElement.querySelector('.sidebar-logo-fallback').style.display='flex';">
      
      <%-- Fallback text logo (shows if image fails to load) --%>
      <div class="sidebar-logo-fallback" style="display: none;">
        <i class="bi bi-bank2"></i>
      </div>
    </div>
    
    <!-- Bank name below the logo -->
    <div class="brand-name">
      <span class="bank-name">Gojjam Bank</span>
      <span class="bank-subtitle">Admin Portal</span>
    </div>
  </div>
  
  <nav class="sidebar-nav">
    <div class="nav-section-title">Overview</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="sidebar-link <%=request.getRequestURI().contains("dashboard")?"active":""%>">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>

    <div class="nav-section-title">Management</div>
    <a href="${pageContext.request.contextPath}/admin/accounts"
       class="sidebar-link <%=request.getRequestURI().contains("accounts")?"active":""%>">
      <i class="bi bi-people"></i> Customer Accounts
    </a>
    <a href="${pageContext.request.contextPath}/admin/managers"
       class="sidebar-link <%=request.getRequestURI().contains("managers")?"active":""%>">
      <i class="bi bi-person-badge"></i> Manage Managers
    </a>

    <div class="nav-section-title">System</div>
    <a href="${pageContext.request.contextPath}/admin/config"
       class="sidebar-link <%=request.getRequestURI().contains("config")?"active":""%>">
      <i class="bi bi-gear"></i> System Config
    </a>
    <a href="${pageContext.request.contextPath}/admin/reversal"
       class="sidebar-link <%=request.getRequestURI().contains("reversal")?"active":""%>">
      <i class="bi bi-arrow-counterclockwise"></i> Reverse Transactions
    </a>
    <a href="${pageContext.request.contextPath}/admin/audit-logs"
       class="sidebar-link <%=request.getRequestURI().contains("audit")?"active":""%>">
      <i class="bi bi-journal-text"></i> Audit Logs
    </a>
  </nav>
  
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link logout-link"
       onclick="return confirm('Are you sure you want to log out?')">
      <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </div>
</aside>

<style>
  /* Sidebar Base Styles */
  .sidebar {
    width: 220px;
    background: linear-gradient(180deg, #0A1F44 0%, #0a1535 100%);
    color: #fff;
    position: fixed;
    left: 0;
    top: 0;
    height: 100vh;
    overflow-y: auto;
    overflow-x: hidden;
    z-index: 1000;
    display: flex;
    flex-direction: column;
  }
  
  /* Custom scrollbar */
  .sidebar::-webkit-scrollbar {
    width: 5px;
  }
  
  .sidebar::-webkit-scrollbar-track {
    background: rgba(255,255,255,0.1);
  }
  
  .sidebar::-webkit-scrollbar-thumb {
    background: #f59e0b;
    border-radius: 5px;
  }
  
  /* Sidebar Brand - Logo Section (Fixed at top) */
  .sidebar-brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 25px 16px 20px 16px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    margin-bottom: 20px;
    text-align: center;
    flex-shrink: 0;
  }
  
  /* Logo Wrapper */
  .logo-wrapper {
    margin-bottom: 15px;
  }
  
  /* Logo Image */
  .sidebar-logo-img {
    width: 90px;
    height: 90px;
    object-fit: contain;
    border-radius: 12px;
    transition: transform 0.2s ease;
  }
  
  .sidebar-logo-img:hover {
    transform: scale(1.05);
  }
  
  /* Fallback Logo */
  .sidebar-logo-fallback {
    width: 90px;
    height: 90px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  }
  
  .sidebar-logo-fallback i {
    font-size: 45px;
    color: #0A1F44;
  }
  
  /* Brand Name Container */
  .brand-name {
    display: flex;
    flex-direction: column;
    gap: 4px;
  }
  
  /* Bank Main Name */
  .bank-name {
    font-size: 1.1rem;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: 0.5px;
    line-height: 1.2;
  }
  
  /* Bank Subtitle - Admin Portal */
  .bank-subtitle {
    font-size: 0.75rem;
    font-weight: 600;
    color: #f59e0b;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }
  
  /* Navigation Area - Scrollable */
  .sidebar-nav {
    flex: 1;
    padding: 0 12px 20px 12px;
    overflow-y: auto;
  }
  
  /* Section Titles */
  .nav-section-title {
    font-size: 0.7rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: rgba(255,255,255,0.4);
    padding: 12px 12px 6px 12px;
    margin-top: 8px;
  }
  
  /* Sidebar Links */
  .sidebar-link {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 12px;
    margin: 4px 0;
    color: rgba(255,255,255,0.7);
    text-decoration: none;
    border-radius: 10px;
    font-size: 0.85rem;
    font-weight: 500;
    transition: all 0.2s ease;
  }
  
  .sidebar-link i {
    font-size: 1.2rem;
    width: 24px;
  }
  
  .sidebar-link:hover {
    background: rgba(255,255,255,0.1);
    color: #fff;
  }
  
  .sidebar-link.active {
    background: rgba(245,158,11,0.2);
    color: #f59e0b;
    border-left: 3px solid #f59e0b;
  }
  
  /* Footer - Logout Section (Fixed at bottom) */
  .sidebar-footer {
    padding: 18px 12px;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: auto;
    flex-shrink: 0;
    background: linear-gradient(180deg, transparent, rgba(0,0,0,0.2));
  }
  
  /* Logout Link Special Styling */
  .logout-link {
    color: rgba(255,255,255,0.8);
    margin: 0;
  }
  
  .logout-link:hover {
    background: rgba(239,68,68,0.2);
    color: #ef4444;
  }
  
  /* Responsive adjustments */
  @media (max-width: 768px) {
    .sidebar {
      width: 260px;
    }
    
    .sidebar-logo-img {
      width: 70px;
      height: 70px;
    }
    
    .bank-name {
      font-size: 1rem;
    }
    
    .bank-subtitle {
      font-size: 0.7rem;
    }
  }
</style>