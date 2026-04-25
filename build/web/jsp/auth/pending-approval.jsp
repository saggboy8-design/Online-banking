<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Registration Submitted – Gojjam International Bank</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="text-align:center;max-width:520px;">
    <img src="${pageContext.request.contextPath}/images/logo.png"
         alt="Gojjam Bank" style="height:60px;margin-bottom:1rem;"/>

    <div style="font-size:3.5rem;color:#28a745;margin-bottom:1rem;">
      <i class="bi bi-hourglass-split"></i>
    </div>

    <h2 style="color:#0A1F44;font-weight:700;margin-bottom:0.5rem;">Registration Submitted!</h2>

    <div class="alert-bank alert-info" style="text-align:left;">
      <i class="bi bi-info-circle-fill"></i>
      <div>
        <strong>Your account registration is pending approval.</strong><br/>
        A bank manager will review your information and KYC details within 1–2 business days.
        You will receive an email notification once your account is approved or if further
        information is required.
      </div>
    </div>

    <p style="color:#6c757d;font-size:0.9rem;margin-bottom:1.5rem;">
      <strong>What happens next?</strong><br/>
      ① Manager reviews your National ID and personal details<br/>
      ② Account is approved or rejected with an email notification<br/>
      ③ If approved – you can log in and start banking
    </p>

    <a href="${pageContext.request.contextPath}/login" class="btn-bank">
      <i class="bi bi-box-arrow-in-right"></i> Go to Login
    </a>
  </div>
</div>
</body>
</html>