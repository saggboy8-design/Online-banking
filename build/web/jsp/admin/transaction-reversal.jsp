<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Transaction,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Transaction Reversal";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "A";
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title">
      <i class="bi bi-arrow-counterclockwise"></i> Transaction Reversal
    </div>
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

    <div class="alert-bank alert-warning">
      <i class="bi bi-exclamation-triangle-fill"></i>
      <strong>Admin Only Action.</strong> Reversals are permanent and fully logged.
      Only transactions with <strong>SUCCESS</strong> status can be reversed.
      REVERSED and FAILED transactions cannot be reversed again.
    </div>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-list-columns-reverse"></i> All Transactions
        <span style="margin-left:auto;font-size:0.8rem;opacity:0.8;">
          Click Reverse to initiate a full rollback
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <!-- Search -->
        <div style="padding:0.8rem 1rem;border-bottom:1px solid #dee2e6;background:#f4f6f9;">
          <input type="text" id="revSearch" class="form-control"
                 placeholder="&#128269; Search by reference, account, owner or type..."
                 style="max-width:400px;"/>
        </div>

        <div class="table-responsive">
          <table class="bank-table" id="revTable">
            <thead>
              <tr>
                <th>Ref No.</th><th>Account</th><th>Owner</th>
                <th>Type</th><th>Amount (ETB)</th>
                <th>Fee (ETB)</th><th>Status</th>
                <th>Date</th><th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% if (transactions != null) {
                   for (Transaction tx : transactions) { %>
                <tr>
                  <td>
                    <code style="font-size:0.75rem;">
                      <%= tx.getReferenceNumber() != null
                          ? tx.getReferenceNumber() : "#"+tx.getId() %>
                    </code>
                  </td>
                  <td><code style="font-size:0.78rem;"><%= tx.getAccountNumber() %></code></td>
                  <td style="font-size:0.83rem;"><%= tx.getOwnerName() %></td>
                  <td style="font-size:0.83rem;"><%= tx.getTransactionType().replace("_"," ") %></td>
                  <td style="font-weight:600;">ETB <%= tx.getAmount().toPlainString() %></td>
                  <td style="font-size:0.83rem;">ETB <%= tx.getFee().toPlainString() %></td>
                  <td>
                    <span class="badge-status badge-<%= tx.getStatus().toLowerCase() %>">
                      <%= tx.getStatus() %>
                    </span>
                  </td>
                  <td style="font-size:0.78rem;white-space:nowrap;">
                    <%= tx.getCreatedAt() != null ? tx.getCreatedAt().format(fmt) : "" %>
                  </td>
                  <td>
                    <% if ("SUCCESS".equals(tx.getStatus())) { %>
                      <form method="post"
                            action="${pageContext.request.contextPath}/admin/reversal"
                            style="display:inline;">
                        <input type="hidden" name="csrfToken"      value="${csrfToken}"/>
                        <input type="hidden" name="transactionId"  value="<%= tx.getId() %>"/>
                        <button type="submit" class="btn-bank btn-danger-b"
                                style="width:auto;padding:3px 10px;font-size:0.78rem;"
                                data-confirm="REVERSE transaction #<%= tx.getId() %> of ETB <%= tx.getAmount().toPlainString() %>? This action is PERMANENT and cannot be undone.">
                          <i class="bi bi-arrow-counterclockwise"></i> Reverse
                        </button>
                      </form>
                    <% } else { %>
                      <span style="color:#6c757d;font-size:0.78rem;">
                        Not eligible
                      </span>
                    <% } %>
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
document.getElementById('revSearch').addEventListener('input', function () {
  const q    = this.value.toLowerCase();
  const rows = document.querySelectorAll('#revTable tbody tr');
  rows.forEach(r => {
    r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
});
</script>
</body>
</html>