<%@page import="com.gojjam.bank.model.Account"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Account,java.util.List,
                 com.gojjam.bank.model.Deposit" %>
<%
    String pageTitle = "Manager Deposit";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-arrow-down-circle"></i> Make Customer Deposit</div>
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

    <div class="row g-3">
      <!-- Deposit Form -->
      <div class="col-md-5">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-piggy-bank"></i> Deposit into Customer Account
          </div>
          <div class="bank-card-body">
            <div class="alert-bank alert-info" style="font-size:0.83rem;">
              <i class="bi bi-info-circle"></i>
              This is an internal deposit and takes effect immediately.
              The action is fully audited.
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/manager/deposit"
                  id="mgrDepositForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>

              <div class="mb-3">
                <label class="form-label">
                  Account Number <span class="required-star">*</span>
                </label>
                <input type="text" name="accountNumber" id="accNumInput"
                       class="form-control" required maxlength="20"
                       list="accountList"
                       placeholder="ACC1234567890 or start typing..."
                       oninput="matchAccount(this.value)"/>
                <datalist id="accountList">
                  <% if (accounts != null) {
                       for (Account a : accounts) { %>
                    <option value="<%= a.getAccountNumber() %>">
                      <%= a.getOwnerFullName() %>
                    </option>
                  <%   }
                     } %>
                </datalist>
              </div>

              <!-- Account Info Preview -->
              <div id="accPreview" style="display:none;background:#f4f6f9;
                   border-radius:8px;padding:0.8rem;margin-bottom:1rem;
                   border-left:3px solid #1a3a6e;">
                <div style="font-size:0.82rem;color:#6c757d;">Account Holder</div>
                <div id="prevName"   style="font-weight:600;color:#0A1F44;"></div>
                <div id="prevBal"    style="font-size:0.83rem;color:#28a745;margin-top:2px;"></div>
              </div>

              <div class="mb-3">
                <label class="form-label">
                  Deposit Amount (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="amount" class="form-control"
                       min="1" step="0.01" required placeholder="5000.00"/>
              </div>

              <div class="mb-4">
                <label class="form-label">Notes (optional)</label>
                <textarea name="notes" class="form-control" rows="2"
                          maxlength="500"
                          placeholder="Reason or reference for deposit..."></textarea>
              </div>

              <button type="submit" class="btn-bank"
                      data-confirm="Confirm deposit into this account?">
                <i class="bi bi-send-check"></i> Process Deposit
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- Account Table Quick View -->
      <div class="col-md-7">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-table"></i> Active Customer Accounts
          </div>
          <div class="bank-card-body" style="padding:0;">
            <div class="table-responsive">
              <table class="bank-table">
                <thead>
                  <tr>
                    <th>Account No.</th><th>Owner</th>
                    <th>Balance (ETB)</th><th>KYC</th>
                  </tr>
                </thead>
                <tbody>
                  <% if (accounts != null) {
                       for (Account a : accounts) { %>
                    <tr style="cursor:pointer;"
                        onclick="selectAcc('<%= a.getAccountNumber() %>','<%= a.getOwnerFullName() %>','<%= a.getBalance().toPlainString() %>')">
                      <td><code><%= a.getAccountNumber() %></code></td>
                      <td><strong><%= a.getOwnerFullName() %></strong></td>
                      <td style="font-weight:600;">ETB <%= a.getBalance().toPlainString() %></td>
                      <td>
                        <span class="badge-status badge-<%= a.getKycStatus().toLowerCase() %>">
                          <%= a.getKycStatus() %>
                        </span>
                      </td>
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
// Account data map
const accountMap = {};
<% if (accounts != null) {
     for (Account a : accounts) { %>
  accountMap['<%= a.getAccountNumber() %>'] = {
    name: '<%= a.getOwnerFullName().replace("'","") %>',
    balance: '<%= a.getBalance().toPlainString() %>'
  };
<% }} %>

function matchAccount(val) {
  const info = accountMap[val];
  const box  = document.getElementById('accPreview');
  if (info) {
    document.getElementById('prevName').textContent = info.name;
    document.getElementById('prevBal').textContent  = 'Balance: ETB ' + info.balance;
    box.style.display = 'block';
  } else {
    box.style.display = 'none';
  }
}

function selectAcc(num, name, bal) {
  const inp = document.getElementById('accNumInput');
  inp.value = num;
  matchAccount(num);
}
</script>
</body>
</html>