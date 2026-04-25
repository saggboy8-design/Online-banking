<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.User,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
    String pageTitle = "Manage Managers";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "A";
    List<User> managers = (List<User>) request.getAttribute("managers");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-person-badge"></i> Manage Managers</div>
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

    <div class="row g-3">
      <!-- Add Manager Form -->
      <div class="col-md-4">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-person-plus"></i> Add New Manager
          </div>
          <div class="bank-card-body">
            <form method="post"
                  action="${pageContext.request.contextPath}/admin/managers"
                  id="addMgrForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>
              <input type="hidden" name="action"    value="ADD"/>

              <div class="mb-2">
                <label class="form-label">Username / Email <span class="required-star">*</span></label>
                <input type="email" name="username" class="form-control"
                       required placeholder="manager@bank.com"/>
              </div>
              <div class="mb-2">
                <label class="form-label">Full Name <span class="required-star">*</span></label>
                <input type="text" name="fullName" class="form-control"
                       required maxlength="200" placeholder="Full name"/>
              </div>
              <div class="mb-2">
                <label class="form-label">Email <span class="required-star">*</span></label>
                <input type="email" name="email" class="form-control"
                       required placeholder="email@example.com"/>
              </div>
              <div class="mb-2">
                <label class="form-label">Phone <span class="required-star">*</span></label>
                <input type="tel" name="phone" class="form-control"
                       required placeholder="+251911..."/>
              </div>
              <div class="mb-2">
                <label class="form-label">Date of Birth <span class="required-star">*</span></label>
                <input type="date" name="dateOfBirth" class="form-control" required/>
              </div>
              <div class="mb-2">
                <label class="form-label">National ID Number <span class="required-star">*</span></label>
                <input type="text" name="nationalId" class="form-control"
                       required placeholder="ETH-MGR-XXXX"
                       style="text-transform:uppercase;"/>
              </div>
              <div class="mb-3">
                <label class="form-label">Password <span class="required-star">*</span></label>
                <input type="password" id="password" name="password"
                       class="form-control" required minlength="8"
                       placeholder="Strong password"/>
                <div class="strength-bar">
                  <div class="strength-fill" id="strengthFill"></div>
                </div>
                <div class="strength-label" id="strengthLabel"></div>
                <div id="strengthTip" style="font-size:0.78rem;margin-top:3px;"></div>
              </div>

              <button type="submit" class="btn-bank">
                <i class="bi bi-person-plus"></i> Create Manager Account
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- Managers Table -->
      <div class="col-md-8">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-table"></i> Current Managers
            <span style="margin-left:auto;font-size:0.8rem;opacity:0.8;">
              <%= managers != null ? managers.size() : 0 %> managers
            </span>
          </div>
          <div class="bank-card-body" style="padding:0;">
            <div class="table-responsive">
              <table class="bank-table">
                <thead>
                  <tr>
                    <th>#</th><th>Username</th><th>Full Name</th>
                    <th>Email</th><th>Phone</th>
                    <th>Status</th><th>Created</th><th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <% if (managers != null) {
                       for (User m : managers) { %>
                    <tr>
                      <td><%= m.getId() %></td>
                      <td><code><%= m.getUsername() %></code></td>
                      <td><strong><%= m.getFullName() %></strong></td>
                      <td style="font-size:0.82rem;"><%= m.getEmail() %></td>
                      <td style="font-size:0.82rem;"><%= m.getPhone() %></td>
                      <td>
                        <span class="badge-status badge-<%= m.getStatus().toLowerCase() %>">
                          <%= m.getStatus() %>
                        </span>
                      </td>
                      <td style="font-size:0.78rem;">
                        <%= m.getCreatedAt() != null ? m.getCreatedAt().format(fmt) : "" %>
                      </td>
                      <td>
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/managers"
                              style="display:inline;">
                          <input type="hidden" name="csrfToken"  value="${csrfToken}"/>
                          <input type="hidden" name="action"     value="DELETE"/>
                          <input type="hidden" name="managerId"  value="<%= m.getId() %>"/>
                          <button type="submit" class="btn-bank btn-danger-b"
                                  style="width:auto;padding:3px 10px;font-size:0.78rem;"
                                  data-confirm="Delete manager <%= m.getFullName() %>? This cannot be undone.">
                            <i class="bi bi-trash"></i> Delete
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
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
document.getElementById('addMgrForm').addEventListener('submit', function (e) {
  let ok = true;
  this.querySelectorAll('[required]').forEach(function (el) {
    if (!el.value.trim()) { el.classList.add('is-invalid'); ok = false; }
    else el.classList.remove('is-invalid');
  });
  if (!ok) e.preventDefault();
});
document.querySelector('[name="nationalId"]').addEventListener('input', function () {
  this.value = this.value.toUpperCase();
});
</script>
</body>
</html>