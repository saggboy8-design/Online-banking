<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>404 – Page Not Found</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="text-align:center;">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" style="height:50px;margin-bottom:1rem;"/>
    <div style="font-size:4rem;color:#dc3545;"><i class="bi bi-exclamation-triangle"></i></div>
    <h2 style="color:#0A1F44;">404 – Page Not Found</h2>
    <p style="color:#6c757d;">The page you requested could not be found.</p>
    <a href="${pageContext.request.contextPath}/login" class="btn-bank" style="margin-top:1rem;">
      <i class="bi bi-house"></i> Go to Home
    </a>
  </div>
</div>
</body>
</html>