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
      <span class="bank-subtitle">Manager Portal</span>
    </div>
  </div>
  
  <nav class="sidebar-nav">
    <div class="nav-section-title">Overview</div>
    <a href="${pageContext.request.contextPath}/manager/dashboard"
       class="sidebar-link <%=request.getRequestURI().contains("dashboard")?"active":""%>">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>

    <div class="nav-section-title">KYC & Accounts</div>
    <a href="${pageContext.request.contextPath}/manager/kyc"
       class="sidebar-link <%=request.getRequestURI().contains("kyc")?"active":""%>">
      <i class="bi bi-person-check"></i> KYC Approvals
    </a>
    <a href="${pageContext.request.contextPath}/manager/unlock"
       class="sidebar-link <%=request.getRequestURI().contains("unlock")?"active":""%>">
      <i class="bi bi-unlock"></i> Unlock Accounts
    </a>
    <a href="${pageContext.request.contextPath}/manager/update-balance"
       class="sidebar-link <%=request.getRequestURI().contains("update-balance")?"active":""%>">
      <i class="bi bi-pencil-square"></i> Update Balance
    </a>

    <div class="nav-section-title">Transactions</div>
    <a href="${pageContext.request.contextPath}/manager/deposit"
       class="sidebar-link <%=request.getRequestURI().contains("deposit")?"active":""%>">
      <i class="bi bi-arrow-down-circle"></i> Make Deposit
    </a>
    <a href="${pageContext.request.contextPath}/manager/external-transfers"
       class="sidebar-link <%=request.getRequestURI().contains("external-transfer")?"active":""%>">
      <i class="bi bi-send"></i> External Transfers
    </a>
    <a href="${pageContext.request.contextPath}/manager/transactions"
       class="sidebar-link <%=request.getRequestURI().contains("/manager/transactions")?"active":""%>">
      <i class="bi bi-table"></i> All Transactions
    </a>

    <div class="nav-section-title">Services</div>
    <a href="${pageContext.request.contextPath}/manager/loans"
       class="sidebar-link <%=request.getRequestURI().contains("loans")?"active":""%>">
      <i class="bi bi-bank"></i> Loan Approvals
    </a>
    <a href="${pageContext.request.contextPath}/manager/withdrawals"
   class="sidebar-link <%= request.getRequestURI().contains("withdrawals") ? "active" : "" %>">
  <i class="bi bi-cash-coin"></i> Withdrawal Approvals
</a>
    <a href="${pageContext.request.contextPath}/manager/audit-logs"
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
  
  /* Sidebar Brand - Logo Section (Compact) */
  .sidebar-brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 16px 12px 12px 12px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    margin-bottom: 16px;
    text-align: center;
    flex-shrink: 0;
  }
  
  /* Logo Wrapper */
  .logo-wrapper {
    margin-bottom: 8px;
  }
  
  /* Logo Image - SMALLER SIZE */
  .sidebar-logo-img {
    width: 55px;
    height: 55px;
    object-fit: contain;
    border-radius: 10px;
    transition: transform 0.2s ease;
  }
  
  .sidebar-logo-img:hover {
    transform: scale(1.05);
  }
  
  /* Fallback Logo - SMALLER */
  .sidebar-logo-fallback {
    width: 55px;
    height: 55px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    border-radius: 10px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.2);
  }
  
  .sidebar-logo-fallback i {
    font-size: 28px;
    color: #0A1F44;
  }
  
  /* Brand Name Container - COMPACT */
  .brand-name {
    display: flex;
    flex-direction: column;
    gap: 2px;
  }
  
  /* Bank Main Name - SMALLER */
  .bank-name {
    font-size: 0.85rem;
    font-weight: 700;
    color: #ffffff;
    letter-spacing: 0.3px;
    line-height: 1.2;
  }
  
  /* Bank Subtitle - SMALLER */
  .bank-subtitle {
    font-size: 0.6rem;
    font-weight: 500;
    color: #f59e0b;
    letter-spacing: 0.3px;
    text-transform: uppercase;
  }
  
  /* Navigation Area - Scrollable */
  .sidebar-nav {
    flex: 1;
    padding: 0 12px 16px 12px;
    overflow-y: auto;
  }
  
  /* Section Titles */
  .nav-section-title {
    font-size: 0.65rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    color: rgba(255,255,255,0.4);
    padding: 10px 10px 4px 10px;
    margin-top: 6px;
  }
  
  /* Sidebar Links */
  .sidebar-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 10px;
    margin: 3px 0;
    color: rgba(255,255,255,0.7);
    text-decoration: none;
    border-radius: 8px;
    font-size: 0.8rem;
    font-weight: 500;
    transition: all 0.2s ease;
  }
  
  .sidebar-link i {
    font-size: 1.1rem;
    width: 22px;
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
  
  /* Footer - Logout Section */
  .sidebar-footer {
    padding: 12px 12px;
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
      width: 220px;
    }
    
    .sidebar-logo-img {
      width: 45px;
      height: 45px;
    }
    
    .sidebar-logo-fallback {
      width: 45px;
      height: 45px;
    }
    
    .sidebar-logo-fallback i {
      font-size: 24px;
    }
    
    .bank-name {
      font-size: 0.75rem;
    }
    
    .bank-subtitle {
      font-size: 0.55rem;
    }
  }
</style>