<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.User,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Unlock Accounts";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
    List<User> lockedUsers = (List<User>) request.getAttribute("lockedUsers");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-unlock"></i> Unlock Accounts</div>
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

    <div class="alert-bank alert-info">
      <i class="bi bi-info-circle-fill"></i>
      Accounts are locked after <strong>3 consecutive failed login attempts</strong>.
      Unlock only after verifying the account holder's identity.
    </div>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-lock"></i> Locked Accounts
        <span style="margin-left:auto;background:rgba(255,255,255,0.2);
                     padding:2px 10px;border-radius:12px;font-size:0.8rem;">
          <%= lockedUsers != null ? lockedUsers.size() : 0 %> locked
        </span>
      </div>
      <div class="bank-card-body" style="padding:0;">
        <% if (lockedUsers == null || lockedUsers.isEmpty()) { %>
          <div style="padding:2rem;text-align:center;color:#6c757d;">
            <i class="bi bi-check-circle" style="font-size:2.5rem;color:#28a745;"></i>
            <p style="margin-top:0.5rem;">No locked accounts. All accounts are active.</p>
          </div>
        <% } else { %>
          <div class="table-responsive">
            <table class="bank-table">
              <thead>
                <tr>
                  <th>#</th><th>Username</th><th>Full Name</th>
                  <th>Email</th><th>Phone</th>
                  <th>Member Since</th><th>Action</th>
                </tr>
              </thead>
              <tbody>
                <% for (User u : lockedUsers) { %>
                  <tr>
                    <td><%= u.getId() %></td>
                    <td><code><%= u.getUsername() %></code></td>
                    <td><strong><%= u.getFullName() %></strong></td>
                    <td style="font-size:0.82rem;"><%= u.getEmail() %></td>
                    <td style="font-size:0.82rem;"><%= u.getPhone() %></td>
                    <td style="font-size:0.82rem;">
                      <%= u.getCreatedAt() != null
                          ? u.getCreatedAt().format(fmt) : "" %>
                    </td>
                    <td>
                      <form method="post"
                            action="${pageContext.request.contextPath}/manager/unlock"
                            style="display:inline;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                        <input type="hidden" name="userId"    value="<%= u.getId() %>"/>
                        <button type="submit" class="btn-bank btn-accent"
                                style="width:auto;padding:4px 12px;font-size:0.82rem;"
                                data-confirm="Unlock account for <%= u.getFullName() %>?">
                          <i class="bi bi-unlock"></i> Unlock
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
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>