<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <!-- Logo centered above text - REDUCED SIZE -->
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
    
    <!-- Bank name below the logo - COMPACT VERSION -->
    <div class="brand-name">
      <span class="bank-name">Gojjam Bank</span>
      <span class="bank-subtitle">International</span>
    </div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section-title">Main</div>
    <a href="${pageContext.request.contextPath}/customer/dashboard"
       class="sidebar-link <%= request.getRequestURI().contains("dashboard") ? "active" : "" %>">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/customer/transactions"
       class="sidebar-link <%= request.getRequestURI().contains("transaction") ? "active" : "" %>">
      <i class="bi bi-list-columns-reverse"></i> Transactions
    </a>

    <div class="nav-section-title">Banking</div>
    <a href="${pageContext.request.contextPath}/customer/withdraw"
   class="sidebar-link <%= request.getRequestURI().contains("withdraw") ? "active" : "" %>">
    <i class="bi bi-cash-coin"></i> Withdraw
    </a>
    <a href="${pageContext.request.contextPath}/customer/transfer"
       class="sidebar-link <%= request.getRequestURI().contains("transfer") ? "active" : "" %>">
      <i class="bi bi-arrow-left-right"></i> Transfer
    </a>
    <a href="${pageContext.request.contextPath}/customer/bill-payment"
       class="sidebar-link <%= request.getRequestURI().contains("bill") ? "active" : "" %>">
      <i class="bi bi-receipt"></i> Bill Payment
    </a>
    <a href="${pageContext.request.contextPath}/customer/scheduled-payment"
       class="sidebar-link <%= request.getRequestURI().contains("scheduled") ? "active" : "" %>">
      <i class="bi bi-calendar-check"></i> Scheduled Payments
    </a>

    <div class="nav-section-title">Services</div>
    <a href="${pageContext.request.contextPath}/customer/loan"
       class="sidebar-link <%= request.getRequestURI().contains("loan") ? "active" : "" %>">
      <i class="bi bi-bank"></i> Loan Request
    </a>
    <div class="nav-section-title">Account</div>
    <a href="${pageContext.request.contextPath}/customer/change-password"
       class="sidebar-link <%= request.getRequestURI().contains("change-password") ? "active" : "" %>">
      <i class="bi bi-key"></i> Change Password
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
  
  /* Sidebar Brand - Logo Section (Fixed at top) - REDUCED PADDING */
  .sidebar-brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 16px 16px 12px 16px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    margin-bottom: 12px;
    text-align: center;
    flex-shrink: 0;
  }
  
  /* Logo Wrapper - REDUCED MARGIN */
  .logo-wrapper {
    margin-bottom: 8px;
  }
  
  /* Logo Image - REDUCED SIZE (was 90px, now 60px) */
  .sidebar-logo-img {
    width: 60px;
    height: 60px;
    object-fit: contain;
    border-radius: 10px;
    transition: transform 0.2s ease;
  }
  
  .sidebar-logo-img:hover {
    transform: scale(1.05);
  }
  
  /* Fallback Logo - REDUCED SIZE */
  .sidebar-logo-fallback {
    width: 60px;
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  }
  
  .sidebar-logo-fallback i {
    font-size: 30px;
    color: #0A1F44;
  }
  
  /* Brand Name Container - COMPACT */
  .brand-name {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 2px;
  }
  
  /* Bank Main Name - SMALLER FONT */
  .bank-name {
    font-size: 0.95rem;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: 0.5px;
    line-height: 1.2;
  }
  
  /* Bank Subtitle - SMALLER FONT */
  .bank-subtitle {
    font-size: 0.65rem;
    font-weight: 500;
    color: rgba(255,255,255,0.65);
    letter-spacing: 0.5px;
  }
  
  /* Navigation Area - Scrollable */
  .sidebar-nav {
    flex: 1;
    padding: 0 12px 20px 12px;
    overflow-y: auto;
  }
  
  /* Section Titles */
  .nav-section-title {
    font-size: 0.65rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: rgba(255,255,255,0.4);
    padding: 10px 12px 5px 12px;
    margin-top: 6px;
  }
  
  /* Sidebar Links */
  .sidebar-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 12px;
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
  
  /* Footer - Logout Section (Fixed at bottom) */
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
  
  /* Ensure no overlapping issues */
  .sidebar-nav {
    padding-bottom: 20px;
  }
  
  /* Make sure content doesn't get hidden behind footer */
  .sidebar-nav {
    margin-bottom: 0;
  }
</style>