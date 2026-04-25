<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Manage Accounts";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "A";
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-people"></i> Manage Customer Accounts</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;">Admin: <strong><%= fullName %></strong></span>
      <div class="avatar-circle"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-bank alert-error">
        <i class="bi bi-exclamation-circle-fill"></i>
        <%= request.getAttribute("error") %>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert-bank alert-success">
        <i class="bi bi-check-circle-fill"></i>
        <%= request.getAttribute("success") %>
      </div>
    <% } %>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-table"></i> All Customer Accounts
        <span style="margin-left:auto;font-size:0.8rem;opacity:0.8;">
          <%= accounts != null ? accounts.size() : 0 %> accounts
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <!-- Search -->
        <div style="padding:0.8rem 1rem;border-bottom:1px solid #dee2e6;background:#f4f6f9;">
          <input type="text" id="accSearch" class="form-control"
                 placeholder="&#128269; Search by account number, name or email..."
                 style="max-width:400px;"/>
        </div>

        <div class="table-responsive">
          <table class="bank-table" id="accTable">
            <thead>
              <tr>
                <th>Account No.</th><th>Owner</th><th>Email</th>
                <th>Balance (ETB)</th><th>KYC</th><th>Type</th>
                <th>Opened</th><th>User Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (accounts != null) {
                   for (Account a : accounts) { %>
                <tr>
                  <td><code><%= a.getAccountNumber() %></code></td>
                  <td><strong><%= a.getOwnerFullName() %></strong></td>
                  <td style="font-size:0.82rem;"><%= a.getOwnerEmail() %></td>
                  <td style="font-weight:600;">ETB <%= a.getBalance().toPlainString() %></td>
                  <td>
                    <span class="badge-status badge-<%= a.getKycStatus().toLowerCase() %>">
                      <%= a.getKycStatus() %>
                    </span>
                  </td>
                  <td style="font-size:0.82rem;"><%= a.getAccountType() %></td>
                  <td style="font-size:0.78rem;">
                    <%= a.getCreatedAt() != null ? a.getCreatedAt().format(fmt) : "" %>
                  </td>
                  <td>
                    <!-- User status is from users table; approximate via KYC+account context -->
                    <span class="badge-status badge-approved" style="font-size:0.72rem;">
                      ACTIVE
                    </span>
                  </td>
                  <td>
                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/accounts"
                          style="display:inline;">
                      <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                      <input type="hidden" name="userId"    value="<%= a.getUserId() %>"/>
                      <input type="hidden" name="action"    value="LOCK"/>
                      <button type="submit" class="btn-bank btn-danger-b"
                              style="width:auto;padding:3px 8px;font-size:0.75rem;"
                              data-confirm="Lock account for <%= a.getOwnerFullName() %>?">
                        <i class="bi bi-lock"></i> Lock
                      </button>
                    </form>
                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/accounts"
                          style="display:inline;margin-left:4px;">
                      <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                      <input type="hidden" name="userId"    value="<%= a.getUserId() %>"/>
                      <input type="hidden" name="action"    value="UNLOCK"/>
                      <button type="submit" class="btn-bank btn-accent"
                              style="width:auto;padding:3px 8px;font-size:0.75rem;"
                              data-confirm="Unlock account for <%= a.getOwnerFullName() %>?">
                        <i class="bi bi-unlock"></i> Unlock
                      </button>
                    </form>
                  </td>
                </tr>
              <%   }
                 } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
document.getElementById('accSearch').addEventListener('input', function () {
  const q    = this.value.toLowerCase();
  const rows = document.querySelectorAll('#accTable tbody tr');
  rows.forEach(r => {
    r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
});
</script>
</body>
</html>