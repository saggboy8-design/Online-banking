<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List,java.time.format.DateTimeFormatter" %>
<%
  String pageTitle="KYC Approvals";
  String fullName=(String)session.getAttribute("fullName");
  String initials=fullName!=null&&!fullName.isEmpty()?String.valueOf(fullName.charAt(0)).toUpperCase():"M";
  List<Account> accounts=(List<Account>)request.getAttribute("pendingAccounts");
  List<User> users=(List<User>)request.getAttribute("users");
  DateTimeFormatter fmt=DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-person-check"></i> KYC Approval</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle" style="background:#1a3a6e;"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">
    <% if(request.getAttribute("error")!=null){%>
      <div class="alert-bank alert-error"><i class="bi bi-exclamation-circle-fill"></i>
        <%=request.getAttribute("error")%></div>
    <%}%>
    <% if(request.getAttribute("success")!=null){%>
      <div class="alert-bank alert-success"><i class="bi bi-check-circle-fill"></i>
        <%=request.getAttribute("success")%></div>
    <%}%>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-person-check"></i> Pending KYC Registrations
        <span style="margin-left:auto;background:rgba(255,255,255,0.2);padding:2px 10px;border-radius:12px;font-size:0.8rem;">
          <%= accounts!=null?accounts.size():0 %> pending
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <% if(accounts==null||accounts.isEmpty()){%>
          <div style="padding:2rem;text-align:center;color:#6c757d;">
            <i class="bi bi-check-all" style="font-size:2.5rem;color:#28a745;"></i>
            <p style="margin-top:0.5rem;">All KYC registrations reviewed.</p>
          </div>
        <% } else { %>
          <div class="table-responsive">
            <table class="bank-table">
              <thead><tr>
                <th>#</th><th>Account No.</th><th>Full Name</th>
                <th>Email</th><th>Phone</th><th>National ID</th>
                <th>Date of Birth</th><th>Applied On</th><th>Actions</th>
              </tr></thead>
              <tbody>
                <% for(int i=0;i<accounts.size();i++){
                   Account a=accounts.get(i);
                   User u=(users!=null&&i<users.size())?users.get(i):null;
                %>
                  <tr>
                    <td><%= a.getId() %></td>
                    <td><code><%= a.getAccountNumber() %></code></td>
                    <td><strong><%= a.getOwnerFullName() %></strong></td>
                    <td style="font-size:0.82rem;"><%= a.getOwnerEmail() %></td>
                    <td style="font-size:0.82rem;"><%= a.getOwnerPhone() %></td>
                    <td>
                      <code style="background:#fff3cd;padding:2px 6px;border-radius:4px;">
                        <%= u!=null?u.getNationalIdNumber():"N/A" %>
                      </code>
                    </td>
                    <td style="font-size:0.82rem;">
                      <%= u!=null&&u.getDateOfBirth()!=null?u.getDateOfBirth().format(fmt):"N/A" %>
                    </td>
                    <td style="font-size:0.82rem;">
                      <%= a.getCreatedAt()!=null?a.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")):"" %>
                    </td>
                    <td>
                      <form method="post" action="${pageContext.request.contextPath}/manager/kyc"
                            style="display:inline;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                        <input type="hidden" name="accountId" value="<%= a.getId() %>"/>
                        <input type="hidden" name="action" value="APPROVE"/>
                        <button type="submit" class="btn-bank btn-accent"
                                style="padding:3px 10px;font-size:0.78rem;width:auto;"
                                data-confirm="Approve KYC for <%= a.getOwnerFullName() %>?">
                          <i class="bi bi-check"></i> Approve
                        </button>
                      </form>
                      <form method="post" action="${pageContext.request.contextPath}/manager/kyc"
                            style="display:inline;margin-left:4px;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                        <input type="hidden" name="accountId" value="<%= a.getId() %>"/>
                        <input type="hidden" name="action" value="REJECT"/>
                        <button type="submit" class="btn-bank btn-danger-b"
                                style="padding:3px 10px;font-size:0.78rem;width:auto;"
                                data-confirm="Reject KYC for <%= a.getOwnerFullName() %>? Customer will be notified.">
                          <i class="bi bi-x"></i> Reject
                        </button>
                      </form>
                    </td>
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