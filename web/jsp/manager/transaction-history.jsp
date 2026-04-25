<%@page import="com.gojjam.bank.model.Transaction"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Transaction,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "All Transactions";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-table"></i> All Customer Transactions</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;">Manager: <strong><%= fullName %></strong></span>
      <div class="avatar-circle" style="background:#1a3a6e;"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">
    <div class="alert-bank alert-info">
      <i class="bi bi-eye"></i>
      Showing last 500 transactions across all customer accounts.
    </div>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-list-columns-reverse"></i> Transaction Ledger
        <span style="margin-left:auto;font-size:0.8rem;opacity:0.8;">
          <%= transactions != null ? transactions.size() : 0 %> records
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <!-- Search Filter -->
        <div style="padding:0.8rem 1rem;border-bottom:1px solid #dee2e6;
                    background:#f4f6f9;">
          <input type="text" id="txSearch" class="form-control"
                 placeholder="&#128269; Search by reference, type, account, or owner..."
                 style="max-width:400px;"/>
        </div>

        <% if (transactions == null || transactions.isEmpty()) { %>
          <div style="padding:2rem;text-align:center;color:#6c757d;">
            <i class="bi bi-inbox" style="font-size:2rem;"></i>
            <p style="margin-top:0.5rem;">No transactions found.</p>
          </div>
        <% } else { %>
          <div class="table-responsive">
            <table class="bank-table" id="txTable">
              <thead>
                <tr>
                  <th>Ref No.</th><th>Account</th><th>Owner</th>
                  <th>Type</th><th>Amount (ETB)</th>
                  <th>Fee (ETB)</th><th>Bal. After</th>
                  <th>Status</th><th>Date</th>
                </tr>
              </thead>
              <tbody>
                <% for (Transaction tx : transactions) {
                     String t = tx.getTransactionType();
                     boolean credit = "TRANSFER_IN".equals(t) || "DEPOSIT".equals(t)
                                      || "LOAN_CREDIT".equals(t);
                %>
                  <tr>
                    <td>
                      <code style="font-size:0.75rem;">
                        <%= tx.getReferenceNumber() != null ? tx.getReferenceNumber() : "#"+tx.getId() %>
                      </code>
                    </td>
                    <td><code style="font-size:0.78rem;"><%= tx.getAccountNumber() %></code></td>
                    <td style="font-size:0.83rem;"><%= tx.getOwnerName() %></td>
                    <td>
                      <i class="bi <%= credit ? "bi-arrow-down-circle":"bi-arrow-up-circle" %>"
                         style="color:<%= credit ? "#28a745":"#dc3545" %>;"></i>
                      <span style="font-size:0.82rem;"><%= t.replace("_"," ") %></span>
                    </td>
                    <td style="font-weight:600;
                        color:<%= credit ? "#28a745":"#dc3545" %>;">
                      <%= credit ? "+" : "−" %> ETB <%= tx.getAmount().toPlainString() %>
                    </td>
                    <td style="font-size:0.83rem;"><%= tx.getFee().toPlainString() %></td>
                    <td style="font-size:0.83rem;">ETB <%= tx.getBalanceAfter().toPlainString() %></td>
                    <td>
                      <span class="badge-status badge-<%= tx.getStatus().toLowerCase() %>">
                        <%= tx.getStatus() %>
                      </span>
                    </td>
                    <td style="font-size:0.78rem;white-space:nowrap;">
                      <%= tx.getCreatedAt() != null ? tx.getCreatedAt().format(fmt) : "" %>
                    </td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        <% } %>
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
/* Live search */
document.getElementById('txSearch').addEventListener('input', function () {
  const q    = this.value.toLowerCase();
  const rows = document.querySelectorAll('#txTable tbody tr');
  rows.forEach(function (row) {
    row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
});
</script>
</body>
</html>