<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List,java.time.format.DateTimeFormatter" %>
<%
  String pageTitle="Audit Logs";
  String fullName=(String)session.getAttribute("fullName");
  String initials=fullName!=null&&!fullName.isEmpty()?String.valueOf(fullName.charAt(0)).toUpperCase():"A";
  List<AuditLog> logs=(List<AuditLog>)request.getAttribute("logs");
  DateTimeFormatter fmt=DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-journal-text"></i> Audit Logs</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;">Admin: <strong><%= fullName %></strong></span>
      <div class="avatar-circle" style="background:#dc3545;"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">
    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-shield-check"></i> System Audit Trail
        <span style="margin-left:auto;font-size:0.8rem;opacity:0.8;">
          Retention: Minimum 5 years | Showing last 500 entries
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <% if(logs==null||logs.isEmpty()){ %>
          <div style="padding:2rem;text-align:center;color:#6c757d;">No audit logs found.</div>
        <% } else { %>
          <div class="table-responsive">
            <table class="bank-table">
              <thead><tr>
                <th>#</th><th>User</th><th>Action</th>
                <th>IP Address</th><th>Old Value</th><th>New Value</th><th>Timestamp</th>
              </tr></thead>
              <tbody>
                <% for(AuditLog log : logs){ %>
                  <tr>
                    <td><%= log.getId() %></td>
                    <td style="font-size:0.82rem;">
                      <% if(log.getUserFullName()!=null){ %>
                        <strong><%= log.getUserFullName() %></strong>
                        <% if(log.getUserId()!=null){ %>
                          <br/><span style="color:#6c757d;">#<%= log.getUserId() %></span>
                        <% } %>
                      <% } else { %><span style="color:#6c757d;">System</span><% } %>
                    </td>
                    <td style="font-size:0.82rem;max-width:250px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
                        title="<%= log.getAction() %>">
                      <%= log.getAction() %>
                    </td>
                    <td><code style="font-size:0.75rem;"><%= log.getIpAddress()!=null?log.getIpAddress():"N/A" %></code></td>
                    <td style="font-size:0.78rem;color:#dc3545;max-width:100px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                      <%= log.getOldValue()!=null?log.getOldValue():"–" %></td>
                    <td style="font-size:0.78rem;color:#28a745;max-width:100px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                      <%= log.getNewValue()!=null?log.getNewValue():"–" %></td>
                    <td style="font-size:0.78rem;white-space:nowrap;">
                      <%= log.getCreatedAt()!=null?log.getCreatedAt().format(fmt):"" %>
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