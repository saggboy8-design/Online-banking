<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List" %>
<%
  String pageTitle = "Transaction History";
  String fullName = (String) session.getAttribute("fullName");
  String initials = fullName!=null&&!fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase():"U";
  Account account = (Account) request.getAttribute("account");
  List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-list-columns-reverse"></i> Transaction History</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-bank alert-error"><i class="bi bi-x-circle-fill"></i>
        <%= request.getAttribute("error") %></div>
    <% } %>

    <!-- Filter Form -->
    <div class="bank-card mb-3">
      <div class="bank-card-header"><i class="bi bi-funnel"></i> Filter Transactions</div>
      <div class="bank-card-body">
        <form method="get" action="${pageContext.request.contextPath}/customer/transactions"
              class="row g-2 align-items-end">
          <div class="col-md-4">
            <label class="form-label">From Date</label>
            <input type="date" name="fromDate" class="form-control"
                   value="<%= request.getAttribute("fromDate") != null ? request.getAttribute("fromDate") : "" %>"/>
          </div>
          <div class="col-md-4">
            <label class="form-label">To Date</label>
            <input type="date" name="toDate" class="form-control"
                   value="<%= request.getAttribute("toDate") != null ? request.getAttribute("toDate") : "" %>"/>
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn-bank" style="padding:0.6rem 1rem;">
              <i class="bi bi-search"></i> Filter
            </button>
          </div>
          <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/customer/transactions?pdf=true<%= request.getAttribute("fromDate")!=null?"&fromDate="+request.getAttribute("fromDate"):"" %><%= request.getAttribute("toDate")!=null?"&toDate="+request.getAttribute("toDate"):"" %>"
               class="btn-bank btn-accent" style="display:block;text-align:center;text-decoration:none;padding:0.6rem 1rem;">
              <i class="bi bi-file-pdf"></i> PDF
            </a>
          </div>
        </form>
      </div>
    </div>

    <!-- Table -->
    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-table"></i>
        Transactions
        <% if (account != null) { %>
          – Account: <strong><%= account.getAccountNumber() %></strong>
        <% } %>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <% if (transactions == null || transactions.isEmpty()) { %>
          <div style="padding:2rem;text-align:center;color:#6c757d;">
            <i class="bi bi-inbox" style="font-size:2.5rem;"></i>
            <p style="margin-top:0.5rem;">No transactions found.</p>
          </div>
        <% } else { %>
          <div class="table-responsive">
            <table class="bank-table">
              <thead>
                <tr>
                  <th>Reference</th><th>Type</th><th>Amount (ETB)</th>
                  <th>Fee (ETB)</th><th>Balance After</th>
                  <th>Description</th><th>Status</th><th>Date</th>
                </tr>
              </thead>
              <tbody>
                <% for (Transaction tx : transactions) {
                    String t = tx.getTransactionType();
                    boolean isCredit = "TRANSFER_IN".equals(t)||"DEPOSIT".equals(t)||"LOAN_CREDIT".equals(t);
                %>
                  <tr>
                    <td><code style="font-size:0.78rem;">
                      <%= tx.getReferenceNumber()!=null?tx.getReferenceNumber():"#"+tx.getId() %></code></td>
                    <td>
                      <i class="bi <%= isCredit?"bi-arrow-down-circle":"bi-arrow-up-circle" %>"
                         style="color:<%= isCredit?"#28a745":"#dc3545" %>;"></i>
                      <span style="font-size:0.83rem;"><%= t.replace("_"," ") %></span>
                    </td>
                    <td style="font-weight:600;color:<%= isCredit?"#28a745":"#dc3545" %>;">
                      <%= isCredit?"+":"−" %> ETB <%= tx.getAmount().toPlainString() %>
                    </td>
                    <td><%= tx.getFee().toPlainString() %></td>
                    <td>ETB <%= tx.getBalanceAfter().toPlainString() %></td>
                    <td style="max-width:150px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:0.82rem;">
                      <%= tx.getDescription()!=null?tx.getDescription():"–" %></td>
                    <td><span class="badge-status badge-<%= tx.getStatus().toLowerCase() %>">
                      <%= tx.getStatus() %></span></td>
                    <td style="font-size:0.82rem;">
                      <%= tx.getCreatedAt()!=null
                          ?tx.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                          :"" %></td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        <% } %>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>