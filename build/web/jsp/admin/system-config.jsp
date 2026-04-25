<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.*,java.util.List" %>
<%
  String pageTitle="System Configuration";
  String fullName=(String)session.getAttribute("fullName");
  String initials=fullName!=null&&!fullName.isEmpty()?String.valueOf(fullName.charAt(0)).toUpperCase():"A";
  List<SystemConfig> configs=(List<SystemConfig>)request.getAttribute("configs");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-gear"></i> System Configuration</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;">
          Admin: <strong><%= fullName %></strong></span>
<div class="avatar-circle" style="background:#dc3545;"><%= initials %></div>
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
    <div class="alert-bank alert-warning">
  <i class="bi bi-exclamation-triangle-fill"></i>
  Changes take effect immediately. All changes are logged in the audit trail.
</div>

<div class="bank-card">
  <div class="bank-card-header"><i class="bi bi-sliders"></i> Fee & Rate Configuration</div>
  <div class="bank-card-body" style="padding:0;">
    <% if(configs!=null){ for(SystemConfig cfg : configs){ %>
      <form method="post" action="${pageContext.request.contextPath}/admin/config"
            class="border-bottom p-3 d-flex align-items-center gap-3"
            style="display:flex;align-items:center;gap:1rem;padding:0.8rem 1.2rem;border-bottom:1px solid #dee2e6;">
        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
        <input type="hidden" name="configKey" value="<%= cfg.getConfigKey() %>"/>
        <div style="flex:1;">
          <div style="font-weight:600;font-size:0.9rem;color:#0A1F44;">
            <%= cfg.getConfigKey().replace("_"," ").toUpperCase() %>
          </div>
          <div style="font-size:0.78rem;color:#6c757d;"><%= cfg.getDescription() %></div>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
          <input type="number" name="configValue" value="<%= cfg.getConfigValue() %>"
                 class="form-control" style="width:130px;" step="0.01" min="0" required/>
          <button type="submit" class="btn-bank"
                  style="width:auto;padding:0.4rem 0.8rem;font-size:0.82rem;"
                  data-confirm="Update <%= cfg.getConfigKey() %> to this value?">
            <i class="bi bi-save"></i> Save
          </button>
        </div>
      </form>
    <% }} %>
  </div>
</div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>