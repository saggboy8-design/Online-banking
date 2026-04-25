<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Account,java.util.List" %>
<%
    String pageTitle = "Update Customer Balance";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-pencil-square"></i> Update Customer Balance</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;">Manager: <strong><%= fullName %></strong></span>
      <div class="avatar-circle" style="background:#1a3a6e;"><%= initials %></div>
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

    <div class="alert-bank alert-warning">
      <i class="bi bi-exclamation-triangle-fill"></i>
      <strong>Warning:</strong> Manually updating a balance bypasses normal transaction flow.
      This action is fully logged in the audit trail. Use with caution.
    </div>

    <div class="row g-3">
      <!-- Update Form -->
      <div class="col-md-5">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-wallet2"></i> Set New Balance
          </div>
          <div class="bank-card-body">
            <form method="post"
                  action="${pageContext.request.contextPath}/manager/update-balance"
                  id="updateBalForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>

              <div class="mb-3">
                <label class="form-label">
                  Select Account <span class="required-star">*</span>
                </label>
                <select name="accountId" id="accountSelect"
                        class="form-select" required
                        onchange="loadAccountInfo(this)">
                  <option value="">-- Select Customer Account --</option>
                  <% if (accounts != null) {
                       for (Account acc : accounts) { %>
                    <option value="<%= acc.getId() %>"
                            data-name="<%= acc.getOwnerFullName() %>"
                            data-number="<%= acc.getAccountNumber() %>"
                            data-balance="<%= acc.getBalance().toPlainString() %>"
                            data-kyc="<%= acc.getKycStatus() %>">
                      <%= acc.getAccountNumber() %> – <%= acc.getOwnerFullName() %>
                    </option>
                  <%   }
                     } %>
                </select>
              </div>

              <!-- Account Info Card -->
              <div id="accountInfo" style="display:none;background:#f4f6f9;
                   border-radius:8px;padding:0.9rem;margin-bottom:1rem;
                   border-left:3px solid #1a3a6e;">
                <table style="width:100%;font-size:0.85rem;">
                  <tr>
                    <td style="color:#6c757d;padding:2px 0;">Account Holder</td>
                    <td style="font-weight:600;" id="infoName">—</td>
                  </tr>
                  <tr>
                    <td style="color:#6c757d;padding:2px 0;">Account No.</td>
                    <td><code id="infoNumber">—</code></td>
                  </tr>
                  <tr>
                    <td style="color:#6c757d;padding:2px 0;">Current Balance</td>
                    <td style="font-weight:700;color:#0A1F44;" id="infoBalance">—</td>
                  </tr>
                  <tr>
                    <td style="color:#6c757d;padding:2px 0;">KYC Status</td>
                    <td id="infoKyc">—</td>
                  </tr>
                </table>
              </div>

              <div class="mb-4">
                <label class="form-label">
                  New Balance (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="newBalance" class="form-control"
                       min="0" step="0.01" required placeholder="0.00"/>
                <small style="color:#6c757d;font-size:0.78rem;">
                  Cannot be negative. This replaces the current balance entirely.
                </small>
              </div>

              <button type="submit" class="btn-bank"
                      data-confirm="Are you sure you want to manually update this balance? This action is irreversible and fully audited.">
                <i class="bi bi-save"></i> Update Balance
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- All Accounts Table -->
      <div class="col-md-7">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-table"></i> All Customer Accounts
          </div>
          <div class="bank-card-body" style="padding:0;">
            <div class="table-responsive">
              <table class="bank-table">
                <thead>
                  <tr>
                    <th>Account No.</th><th>Owner</th>
                    <th>Balance (ETB)</th><th>KYC</th><th>Type</th>
                  </tr>
                </thead>
                <tbody>
                  <% if (accounts != null) {
                       for (Account acc : accounts) { %>
                    <tr style="cursor:pointer;"
                        onclick="selectAccount('<%= acc.getId() %>')">
                      <td><code><%= acc.getAccountNumber() %></code></td>
                      <td><strong><%= acc.getOwnerFullName() %></strong></td>
                      <td style="font-weight:600;">
                        ETB <%= acc.getBalance().toPlainString() %>
                      </td>
                      <td>
                        <span class="badge-status badge-<%= acc.getKycStatus().toLowerCase() %>">
                          <%= acc.getKycStatus() %>
                        </span>
                      </td>
                      <td style="font-size:0.82rem;"><%= acc.getAccountType() %></td>
                    </tr>
                  <%   }
                     } %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function loadAccountInfo(sel) {
  const opt = sel.options[sel.selectedIndex];
  const box = document.getElementById('accountInfo');
  if (!opt.value) { box.style.display='none'; return; }
  document.getElementById('infoName').textContent    = opt.getAttribute('data-name');
  document.getElementById('infoNumber').textContent  = opt.getAttribute('data-number');
  document.getElementById('infoBalance').textContent = 'ETB ' + opt.getAttribute('data-balance');
  document.getElementById('infoKyc').textContent     = opt.getAttribute('data-kyc');
  box.style.display = 'block';
}
function selectAccount(id) {
  const sel = document.getElementById('accountSelect');
  sel.value = id;
  loadAccountInfo(sel);
}
</script>
</body>
</html>