<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>500 – System Error</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="text-align:center;">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" style="height:50px;margin-bottom:1rem;"/>
    <div style="font-size:4rem;color:#ffc107;"><i class="bi bi-gear-wide-connected"></i></div>
    <h2 style="color:#0A1F44;">System Error</h2>
    <p style="color:#6c757d;">An internal error occurred. Our team has been notified.</p>
    <p style="color:#6c757d;font-size:0.82rem;">Please try again or contact support.</p>
    <a href="${pageContext.request.contextPath}/login" class="btn-bank" style="margin-top:1rem;">
      <i class="bi bi-house"></i> Return to Home
    </a>
  </div>
</div>
</body>
</html>