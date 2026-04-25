<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Security Verification – Gojjam International Bank</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="max-width:420px;">
    <div class="auth-logo">
      <img src="${pageContext.request.contextPath}/images/logo.png" alt="Gojjam Bank"/>
      <h2>Security Verification</h2>
      <p>Please confirm your password to continue with this operation</p>
    </div>

    <div class="alert-bank alert-warning">
      <i class="bi bi-shield-lock-fill"></i>
      This operation requires re-authentication for your security.
      Authorization expires in <strong>10 minutes</strong>.
    </div>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-bank alert-error">
        <i class="bi bi-exclamation-circle-fill"></i> <%= request.getAttribute("error") %>
      </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/reauth">
      <input type="hidden" name="csrfToken" value="${csrfToken}"/>
      <input type="hidden" name="redirectTo" value="${redirectTo}"/>

      <div class="mb-3">
        <label class="form-label">Username</label>
        <input type="text" class="form-control"
               value="<%= session.getAttribute("username") %>" readonly
               style="background:#f4f6f9;"/>
      </div>

      <div class="mb-4">
        <label class="form-label">Password <span class="required-star">*</span></label>
        <input type="password" name="password" class="form-control"
               required autofocus placeholder="Enter your password"/>
      </div>

      <button type="submit" class="btn-bank">
        <i class="bi bi-shield-check"></i> Verify & Continue
      </button>

      <div class="text-center mt-3" style="font-size:0.88rem;">
        <a href="${pageContext.request.contextPath}/customer/dashboard"
           style="color:#0A1F44;text-decoration:none;">
          &larr; Cancel – Go to Dashboard
        </a>
      </div>
    </form>
  </div>
</div>
</body>
</html>