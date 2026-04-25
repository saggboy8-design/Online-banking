<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Open Account ? Gojjam International Bank</title>
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet"/>
  <style>
    :root {
      --primary:  #0A1F44; --secondary: #1a3a6e; --accent: #2563eb;
      --gold:     #f59e0b; --success: #10b981; --danger: #ef4444;
      --warning:  #f59e0b;
      --white:    #ffffff; --gray-50: #f8fafc; --gray-100: #f1f5f9;
      --gray-200: #e2e8f0; --gray-400: #94a3b8; --gray-600: #475569;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(135deg, #0A1F44 0%, #1a3a6e 40%, #0e3a6b 100%);
      min-height: 100vh; padding: 2rem 1rem;
      display: flex; align-items: flex-start; justify-content: center;
    }

    .reg-container {
      width: 100%; max-width: 900px; background: #fff;
      border-radius: 20px; box-shadow: 0 25px 80px rgba(0,0,0,0.35);
      overflow: hidden; animation: slideUp 0.45s ease;
    }
    @keyframes slideUp {
      from { opacity:0; transform:translateY(30px); }
      to   { opacity:1; transform:translateY(0); }
    }

    /* Header Banner - FIXED LOGO */
    .reg-header {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      padding: 2rem 2.5rem;
      display: flex;
      align-items: center;
      gap: 1.5rem;
      position: relative;
      overflow: hidden;
      flex-wrap: wrap;
    }
    .reg-header::after {
      content: ''; position: absolute;
      width: 300px; height: 300px; border-radius: 50%;
      background: rgba(255,255,255,0.04);
      right: -80px; top: -100px;
    }
    
    /* LOGO - VISIBLE AND LARGE (120px) + CIRCLE SHAPE */
    .reg-header img {
      height: 120px;
      width: 120px;           /* Force equal dimensions for perfect circle */
      object-fit: cover;      /* Cover ensures image fills circle without distortion */
      border-radius: 50%;     /* Makes logo a perfect circle */
      flex-shrink: 0;
      position: relative;
      z-index: 2;
      background-color: #fff; /* Clean background behind logo if transparent */
      box-shadow: 0 8px 20px rgba(0,0,0,0.15);
      border: 2px solid rgba(255,255,255,0.3); /* subtle border for definition */
    }
    
    .reg-header-text {
      flex: 1;
      position: relative;
      z-index: 2;
    }
    .reg-header-text h1 {
      color: #fff; font-size: 1.4rem; font-weight: 800;
    }
    .reg-header-text p {
      color: rgba(255,255,255,0.65); font-size: 0.85rem; margin-top: 3px;
    }

    /* Progress Steps */
    .progress-bar-wrap {
      background: var(--gray-50); border-bottom: 1px solid var(--gray-200);
      padding: 1.2rem 2.5rem;
    }
    .steps { display: flex; align-items: center; gap: 0; }
    .step  {
      display: flex; align-items: center; flex: 1;
    }
    .step-circle {
      width: 34px; height: 34px; border-radius: 50%;
      border: 2px solid var(--gray-200);
      display: flex; align-items: center; justify-content: center;
      font-size: 0.8rem; font-weight: 700; color: var(--gray-400);
      background: #fff; flex-shrink: 0; transition: all 0.3s;
    }
    .step-circle.active  { border-color: var(--accent); color: var(--accent); background: #eff6ff; }
    .step-circle.done    { border-color: var(--success); background: var(--success); color: #fff; }
    .step-label {
      font-size: 0.72rem; font-weight: 600; color: var(--gray-400);
      margin-left: 8px; white-space: nowrap;
    }
    .step-label.active { color: var(--accent); }
    .step-label.done   { color: var(--success); }
    .step-line {
      flex: 1; height: 2px; background: var(--gray-200);
      margin: 0 12px; transition: background 0.3s;
    }
    .step-line.done { background: var(--success); }

    /* Form Body */
    .reg-body { padding: 2rem 2.5rem; }

    .alert-error {
      display: flex; gap: 10px; align-items: flex-start;
      background: #fef2f2; border: 1px solid #fecaca;
      border-left: 4px solid var(--danger);
      border-radius: 10px; padding: 12px; margin-bottom: 1.5rem;
      font-size: 0.85rem; color: #991b1b;
    }

    /* Section Titles */
    .section-title {
      display: flex; align-items: center; gap: 10px;
      margin-bottom: 1.2rem; padding-bottom: 0.6rem;
      border-bottom: 2px solid var(--gray-100);
    }
    .section-title .num {
      width: 28px; height: 28px; border-radius: 50%;
      background: var(--primary); color: #fff;
      display: flex; align-items: center; justify-content: center;
      font-size: 0.78rem; font-weight: 700; flex-shrink: 0;
    }
    .section-title h3 { font-size: 1rem; font-weight: 700; color: var(--primary); }

    /* Form Grid */
    .form-grid { display: grid; gap: 1rem; grid-template-columns: 1fr 1fr; }
    .form-grid.one-col { grid-template-columns: 1fr; }
    .col-span-2 { grid-column: span 2; }

    .form-group { display: flex; flex-direction: column; }
    .form-group label {
      font-size: 0.8rem; font-weight: 600; color: var(--primary);
      margin-bottom: 5px;
    }
    .label-req { color: var(--danger); }

    .input-wrap { position: relative; }
    .input-wrap .fi {
      position: absolute; left: 11px; top: 50%; transform: translateY(-50%);
      color: var(--gray-400); font-size: 0.95rem; pointer-events: none;
    }
    .inp {
      width: 100%; padding: 0.65rem 0.9rem 0.65rem 2.3rem;
      border: 1.5px solid var(--gray-200); border-radius: 10px;
      font-size: 0.88rem; font-family: 'Inter', sans-serif;
      color: var(--gray-600); transition: all 0.2s; outline: none;
    }
    .inp:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
    .inp.valid   { border-color: var(--success); background: #f0fdf4; }
    .inp.invalid { border-color: var(--danger);  background: #fef2f2; }
    textarea.inp { padding: 0.65rem 0.9rem; resize: vertical; min-height: 80px; }
    select.inp { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24'%3E%3Cpath fill='%2394a3b8' d='M7 10l5 5 5-5z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 10px center; padding-right: 2rem; }

    .inp-hint { font-size: 0.72rem; color: var(--gray-400); margin-top: 3px; }
    .inp-error { font-size: 0.72rem; color: var(--danger); margin-top: 3px; display:none; font-weight:600; }
    .inp-ok    { font-size: 0.72rem; color: var(--success); margin-top: 3px; display:none; }

    /* Char Counter */
    .char-counter {
      font-size: 0.7rem; color: var(--gray-400); margin-top: 3px; text-align: right;
    }

    /* Password Strength */
    .strength-bars {
      display: flex; gap: 4px; margin-top: 6px;
    }
    .s-bar {
      flex: 1; height: 5px; border-radius: 3px;
      background: var(--gray-200); transition: background 0.3s;
    }
    .strength-caption {
      font-size: 0.72rem; font-weight: 600; margin-top: 4px;
    }
    .pwd-rules {
      margin-top: 8px; display: grid; grid-template-columns: 1fr 1fr; gap: 3px;
    }
    .pwd-rule {
      font-size: 0.72rem; display: flex; align-items: center; gap: 5px; color: var(--gray-400);
    }
    .pwd-rule.ok { color: var(--success); }
    .pwd-rule i  { font-size: 0.7rem; }

    /* Terms */
    .terms-box {
      background: var(--gray-50); border: 1px solid var(--gray-200);
      border-radius: 10px; padding: 1rem; font-size: 0.8rem;
      color: var(--gray-600); max-height: 110px; overflow-y: auto;
      margin-bottom: 0.8rem; line-height: 1.6;
    }
    .check-wrap {
      display: flex; align-items: flex-start; gap: 10px; cursor: pointer;
    }
    .check-wrap input[type="checkbox"] {
      width: 17px; height: 17px; flex-shrink: 0; accent-color: var(--accent);
      margin-top: 1px; cursor: pointer;
    }
    .check-wrap label {
      font-size: 0.85rem; color: var(--gray-600); cursor: pointer;
      font-weight: 500;
    }
    .check-wrap label strong { color: var(--primary); }

    /* Submit Button */
    .btn-submit {
      width: 100%; padding: 0.85rem;
      background: linear-gradient(135deg, var(--primary), var(--accent));
      color: #fff; border: none; border-radius: 12px;
      font-size: 1rem; font-weight: 700; cursor: pointer;
      font-family: 'Inter', sans-serif;
      display: flex; align-items: center; justify-content: center; gap: 8px;
      transition: all 0.3s; margin-top: 1.2rem;
      position: relative; overflow: hidden;
    }
    .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(10,31,68,0.3); }
    .btn-submit:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }

    .login-link {
      text-align: center; margin-top: 1rem; font-size: 0.84rem; color: var(--gray-600);
    }
    .login-link a { color: var(--accent); font-weight: 700; text-decoration: none; }

    /* Eye toggle */
    .eye-btn {
      position: absolute; right: 10px; top: 50%; transform: translateY(-50%);
      background: none; border: none; cursor: pointer; color: var(--gray-400);
      font-size: 0.95rem; padding: 0;
    }
    .eye-btn:hover { color: var(--primary); }

    /* Responsive */
    @media (max-width: 640px) {
      body { padding: 1rem 0.5rem; }
      .form-grid { grid-template-columns: 1fr; }
      .col-span-2 { grid-column: span 1; }
      .reg-body { padding: 1.5rem 1.2rem; }
      .reg-header { 
        padding: 1.5rem; 
        flex-direction: column; 
        text-align: center;
      }
      /* Responsive circular logo: maintain circle shape but scale down elegantly */
      .reg-header img {
        height: 110px;
        width: 110px;          /* keep square dimension for circle */
      }
      .progress-bar-wrap { padding: 1.2rem 1.5rem; }
      .step-label { font-size: 1rem; white-space: normal; }
    }
    /* Extra small screens fine-tuning */
    @media (max-width: 480px) {
      .reg-header img {
        height: 90px;
        width: 90px;
      }
    }
  </style>
</head>
<body>

<div class="reg-container">

  <!-- Header with LARGE CIRCULAR VISIBLE LOGO (120px, border-radius 50%) -->
  <div class="reg-header">
    <img src="${pageContext.request.contextPath}/images/logo.png" 
         alt="Gojjam International Bank Logo"
         onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20120%20120%22%3E%3Crect%20width%3D%22120%22%20height%3D%22120%22%20fill%3D%22%23f59e0b%22%2F%3E%3Ctext%20x%3D%2260%22%20y%3D%2275%22%20text-anchor%3D%22middle%22%20fill%3D%22%230A1F44%22%20font-size%3D%2250%22%20font-weight%3D%22bold%22%3EG%3C%2Ftext%3E%3C%2Fsvg%3E';"/>
    <div class="reg-header-text">
      <h1>Gojjam International Bank</h1>
      <p>Open your account in minutes ? secure, fast, and fully digital</p>
    </div>
  </div>

  <!-- Progress Steps -->
  <div class="progress-bar-wrap">
    <div class="steps">
      <div class="step">
        <div class="step-circle active" id="s1">1</div>
        <div class="step-label active">Personal Info</div>
      </div>
      <div class="step-line" id="line1"></div>
      <div class="step">
        <div class="step-circle" id="s2">2</div>
        <div class="step-label">Security</div>
      </div>
      <div class="step-line" id="line2"></div>
      <div class="step">
        <div class="step-circle" id="s3">3</div>
        <div class="step-label">Verification</div>
      </div>
      <div class="step-line" id="line3"></div>
      <div class="step">
        <div class="step-circle" id="s4">4</div>
        <div class="step-label">Terms</div>
      </div>
    </div>
  </div>

  <!-- Form Body -->
  <div class="reg-body">
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-error">
        <i class="bi bi-exclamation-circle-fill" style="margin-top:1px;"></i>
        <div><%= request.getAttribute("error") %></div>
      </div>
    <% } %>

    <form method="post"
          action="${pageContext.request.contextPath}/register"
          id="regForm" novalidate>
      <input type="hidden" name="csrfToken" value="${csrfToken}"/>

      <!-- SECTION 1: Personal Info -->
      <div class="section-title">
        <span class="num">1</span>
        <h3>Personal Information</h3>
      </div>
      <div class="form-grid">
        <!-- Full Name -->
        <div class="form-group">
          <label>Full Name <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-person-fill fi"></i>
            <input type="text" name="fullName" id="fullName" class="inp"
                   placeholder="Abebe Girma Kebede"
                   maxlength="200" required autocomplete="name"/>
          </div>
          <div class="inp-error" id="fullNameErr">Full name is required (min 3 chars).</div>
        </div>

        <!-- Username/Email -->
        <div class="form-group">
          <label>Username / Email <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-envelope-fill fi"></i>
            <input type="email" name="username" id="regUsername" class="inp"
                   placeholder="abebe@email.com" required autocomplete="email"/>
          </div>
          <div class="inp-error" id="usernameErr">Valid email address required.</div>
        </div>

        <!-- Email -->
        <div class="form-group">
          <label>Confirm Email <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-envelope fi"></i>
            <input type="email" name="email" id="regEmail" class="inp"
                   placeholder="Re-enter email address" required autocomplete="email"/>
          </div>
          <div class="inp-error" id="emailErr">Emails must match.</div>
        </div>

        <!-- Phone -->
        <div class="form-group">
          <label>Phone Number <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-telephone-fill fi"></i>
            <input type="tel" name="phone" id="regPhone" class="inp"
                   placeholder="+251911234567" required maxlength="13"
                   autocomplete="tel"/>
          </div>
          <div class="inp-hint">10?12 digits (with optional + prefix). E.g. 0911234567</div>
          <div class="inp-error" id="phoneErr">Phone must be 10?12 digits.</div>
        </div>

        <!-- Date of Birth -->
        <div class="form-group">
          <label>Date of Birth <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-calendar3 fi"></i>
            <input type="date" name="dateOfBirth" id="regDob" class="inp"
                   required
                   max="<%= java.time.LocalDate.now().minusYears(18) %>"/>
          </div>
          <div class="inp-hint">You must be at least 18 years old.</div>
          <div class="inp-error" id="dobErr">Valid date of birth required (18+ years).</div>
        </div>

        <!-- Account Type -->
        <div class="form-group">
          <label>Account Type <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-bank2 fi"></i>
            <select name="accountType" class="inp" required>
              <option value="SAVINGS" selected>? Savings Account</option>
              <option value="CURRENT">? Current Account</option>
            </select>
          </div>
        </div>
      </div>

      <div style="height:1.5rem;"></div>

      <!-- SECTION 2: Security -->
      <div class="section-title">
        <span class="num">2</span>
        <h3>Security Credentials</h3>
      </div>
      <div class="form-grid">
        <!-- Password -->
        <div class="form-group">
          <label>Create Password <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-lock-fill fi"></i>
            <input type="password" name="password" id="regPwd" class="inp"
                   placeholder="Minimum 8 characters" required
                   autocomplete="new-password"
                   style="padding-right:2.5rem;"/>
            <button type="button" class="eye-btn"
                    onclick="toggle('regPwd','eyePwd')">
              <i id="eyePwd" class="bi bi-eye"></i>
            </button>
          </div>
          <!-- Strength Bars -->
          <div class="strength-bars">
            <div class="s-bar" id="sb1"></div>
            <div class="s-bar" id="sb2"></div>
            <div class="s-bar" id="sb3"></div>
            <div class="s-bar" id="sb4"></div>
          </div>
          <div class="strength-caption" id="strengthCap"></div>
          <!-- Rules -->
          <div class="pwd-rules">
            <div class="pwd-rule" id="r-len">
              <i class="bi bi-x-circle-fill"></i> 8+ characters
            </div>
            <div class="pwd-rule" id="r-upper">
              <i class="bi bi-x-circle-fill"></i> Uppercase (A-Z)
            </div>
            <div class="pwd-rule" id="r-lower">
              <i class="bi bi-x-circle-fill"></i> Lowercase (a-z)
            </div>
            <div class="pwd-rule" id="r-num">
              <i class="bi bi-x-circle-fill"></i> Number (0-9)
            </div>
            <div class="pwd-rule" id="r-spec">
              <i class="bi bi-x-circle-fill"></i> Special char (!@#...)
            </div>
          </div>
          <div class="inp-error" id="pwdErr">Password does not meet requirements.</div>
        </div>

        <!-- Confirm Password -->
        <div class="form-group">
          <label>Confirm Password <span class="label-req">*</span></label>
          <div class="input-wrap">
            <i class="bi bi-lock fi"></i>
            <input type="password" name="confirmPassword" id="regCpwd" class="inp"
                   placeholder="Re-enter password" required
                   autocomplete="new-password"
                   style="padding-right:2.5rem;"/>
            <button type="button" class="eye-btn"
                    onclick="toggle('regCpwd','eyeCpwd')">
              <i id="eyeCpwd" class="bi bi-eye"></i>
            </button>
          </div>
          <div class="inp-error" id="cpwdErr">Passwords do not match.</div>
          <div class="inp-ok"    id="cpwdOk">? Passwords match!</div>
        </div>
      </div>

      <div style="height:1.5rem;"></div>

      <!-- SECTION 3: KYC Verification -->
      <div class="section-title">
        <span class="num">3</span>
        <h3>Identity Verification (KYC)</h3>
      </div>
      <div class="form-grid">
        <div class="form-group col-span-2">
          <label>National ID Number <span class="label-req">*</span>
            <span style="background:#e0f2fe;color:#0277bd;font-size:0.68rem;
                         padding:2px 8px;border-radius:12px;font-weight:600;margin-left:6px;">
              Exactly 12 characters
            </span>
          </label>
          <div class="input-wrap">
            <i class="bi bi-card-text fi"></i>
            <input type="text" name="nationalId" id="regNid" class="inp"
                   placeholder="ETH-123456789" required
                   maxlength="12" minlength="12"
                   style="text-transform:uppercase;letter-spacing:1.5px;font-weight:600;"/>
          </div>
          <div style="display:flex;justify-content:space-between;align-items:center;">
            <div class="inp-hint">
              Enter exactly 12 alphanumeric characters. No document upload required.
            </div>
            <div class="char-counter" id="nidCount">0 / 12</div>
          </div>
          <!-- NID Progress Bar -->
          <div style="height:4px;background:var(--gray-200);border-radius:3px;margin-top:5px;overflow:hidden;">
            <div id="nidBar" style="height:100%;width:0;background:var(--danger);border-radius:3px;transition:all 0.25s;"></div>
          </div>
          <div class="inp-error" id="nidErr">National ID must be exactly 12 characters.</div>
          <div class="inp-ok"    id="nidOk">? National ID format valid.</div>
        </div>
      </div>

      <div style="height:1.5rem;"></div>

      <!-- SECTION 4: Terms -->
      <div class="section-title">
        <span class="num">4</span>
        <h3>Privacy Policy & Terms of Use</h3>
      </div>

      <div class="terms-box">
        <strong>Gojjam International Bank ? Terms of Use &amp; Privacy Policy</strong><br/><br/>
        By opening an account with Gojjam International Bank, you agree to the following:
        <ul style="margin:0.5rem 0 0 1rem;">
          <li>Your personal data, including National ID number, is stored securely using AES-256 encryption.</li>
          <li>Your information will only be used for identity verification and banking services.</li>
          <li>You agree to comply with the National Bank of Ethiopia's directives and regulations.</li>
          <li>All transactions are subject to anti-money laundering (AML) and KYC requirements.</li>
          <li>Unauthorized or fraudulent use of banking services is strictly prohibited and will be reported.</li>
          <li>Session data is protected and automatically expires after 15 minutes of inactivity.</li>
        </ul>
      </div>

      <div class="check-wrap" style="margin-bottom:0.8rem;">
        <input type="checkbox" id="acceptTerms" name="acceptTerms" required/>
        <label for="acceptTerms">
          I have read, understood, and agree to the
          <strong>Privacy Policy</strong> and <strong>Terms &amp; Conditions</strong>
          of Gojjam International Bank. <span class="label-req">*</span>
        </label>
      </div>
      <div class="inp-error" id="termsErr">You must accept the terms and conditions.</div>

      <button type="submit" class="btn-submit" id="regBtn">
        <i class="bi bi-person-check-fill"></i>
        <span id="regBtnText">Create My Account</span>
      </button>

      <div class="login-link">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login">Sign in here</a>
      </div>
    </form>
  </div>
</div>

<script>
/* Eye toggle */
function toggle(inputId, iconId) {
  const i = document.getElementById(inputId);
  const e = document.getElementById(iconId);
  i.type = i.type === 'password' ? 'text' : 'password';
  e.className = i.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
}

/* Helpers */
function setValid(id)   { const el=document.getElementById(id); el.classList.add('valid');   el.classList.remove('invalid'); }
function setInvalid(id) { const el=document.getElementById(id); el.classList.add('invalid'); el.classList.remove('valid'); }
function showErr(id, show) { document.getElementById(id).style.display = show ? 'block' : 'none'; }
function showOk(id,  show) { document.getElementById(id).style.display = show ? 'block' : 'none'; }

/* Password strength */
function checkPwd(val) {
  const rules = {
    len:   val.length >= 8,
    upper: /[A-Z]/.test(val),
    lower: /[a-z]/.test(val),
    num:   /[0-9]/.test(val),
    spec:  /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(val)
  };
  const keys = ['len','upper','lower','num','spec'];
  keys.forEach(function(k) {
    const el = document.getElementById('r-'+k);
    const ic = el.querySelector('i');
    if (rules[k]) {
      el.classList.add('ok');
      ic.className = 'bi bi-check-circle-fill';
    } else {
      el.classList.remove('ok');
      ic.className = 'bi bi-x-circle-fill';
    }
  });

  const score = Object.values(rules).filter(Boolean).length;
  const colors = ['','#ef4444','#f59e0b','#f59e0b','#10b981','#10b981'];
  const labels = ['','Very Weak','Weak','Fair','Strong','Very Strong'];
  const cap = document.getElementById('strengthCap');

  for (let i = 1; i <= 4; i++) {
    const bar = document.getElementById('sb'+i);
    bar.style.background = i <= score ? colors[score] : '#e2e8f0';
  }
  cap.textContent  = val ? labels[score] : '';
  cap.style.color  = colors[score] || '#94a3b8';

  return score === 5;
}

document.getElementById('regPwd').addEventListener('input', function() {
  const ok = checkPwd(this.value);
  if (this.value.length > 0) {
    if (ok) { setValid('regPwd'); showErr('pwdErr', false); }
    else     { setInvalid('regPwd'); showErr('pwdErr', !ok && this.value.length > 0); }
  }
  // Re-check confirm
  const cp = document.getElementById('regCpwd').value;
  if (cp) checkConfirm(cp);
});

function checkConfirm(val) {
  const match = val === document.getElementById('regPwd').value;
  if (match) { setValid('regCpwd');   showErr('cpwdErr',false); showOk('cpwdOk',true); }
  else        { setInvalid('regCpwd'); showErr('cpwdErr',true);  showOk('cpwdOk',false); }
  return match;
}
document.getElementById('regCpwd').addEventListener('input', function() {
  checkConfirm(this.value);
});

/* National ID counter */
document.getElementById('regNid').addEventListener('input', function() {
  this.value = this.value.toUpperCase().replace(/[^A-Z0-9\-]/g,'');
  const len  = this.value.length;
  document.getElementById('nidCount').textContent = len + ' / 12';
  const pct  = (len / 12) * 100;
  const bar  = document.getElementById('nidBar');
  bar.style.width = pct + '%';
  bar.style.background = len === 12 ? '#10b981' : (len > 12 ? '#ef4444' : '#f59e0b');

  if (len === 12) {
    setValid('regNid'); showErr('nidErr',false); showOk('nidOk',true);
  } else {
    setInvalid('regNid'); showErr('nidErr', len>0); showOk('nidOk',false);
  }
});

/* Phone validation */
document.getElementById('regPhone').addEventListener('input', function() {
  const raw   = this.value.replace(/[^0-9]/g,'');
  const ok    = raw.length >= 10 && raw.length <= 12;
  if (this.value.length > 0) {
    if (ok) { setValid('regPhone'); showErr('phoneErr',false); }
    else     { setInvalid('regPhone'); showErr('phoneErr',true); }
  }
});

/* Email match */
document.getElementById('regEmail').addEventListener('input', function() {
  const match = this.value === document.getElementById('regUsername').value;
  if (this.value) {
    if (match) { setValid('regEmail'); showErr('emailErr',false); }
    else        { setInvalid('regEmail'); showErr('emailErr',true); }
  }
});

/* Full Name */
document.getElementById('fullName').addEventListener('input', function() {
  if (this.value.trim().length >= 3) { setValid('fullName'); showErr('fullNameErr',false); }
  else if (this.value.length > 0) { setInvalid('fullName'); showErr('fullNameErr',true); }
});

/* Progress step visual update */
function updateSteps() {
  const fv = document.getElementById('fullName').value.trim().length >= 3;
  const ev = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(document.getElementById('regUsername').value);
  const pv = checkPwd(document.getElementById('regPwd').value);
  const nv = document.getElementById('regNid').value.length === 12;

  const markStep = (num, done) => {
    const c = document.getElementById('s'+num);
    const l = c.nextElementSibling;
    if (done) { c.className='step-circle done'; c.innerHTML='<i class="bi bi-check-lg"></i>'; }
    else       { c.className='step-circle active'; c.textContent=num; }
    if (l && l.classList.contains('step-line')) {
      l.classList.toggle('done', done);
    }
  };
  markStep(1, fv && ev);
  markStep(2, pv);
  markStep(3, nv);
}

['fullName','regUsername','regPwd','regNid'].forEach(id => {
  document.getElementById(id).addEventListener('input', updateSteps);
});

/* Form submit */
document.getElementById('regForm').addEventListener('submit', function(e) {
  let valid = true;
  const fn = document.getElementById('fullName').value.trim();
  const un = document.getElementById('regUsername').value.trim();
  const em = document.getElementById('regEmail').value.trim();
  const ph = document.getElementById('regPhone').value.trim();
  const db = document.getElementById('regDob').value;
  const pw = document.getElementById('regPwd').value;
  const cp = document.getElementById('regCpwd').value;
  const ni = document.getElementById('regNid').value;
  const tc = document.getElementById('acceptTerms').checked;

  if (fn.length < 3) { setInvalid('fullName'); showErr('fullNameErr',true); valid=false; }
  if (!un || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(un)) { setInvalid('regUsername'); valid=false; }
  if (em !== un) { setInvalid('regEmail'); showErr('emailErr',true); valid=false; }

  const rawPh = ph.replace(/[^0-9]/g,'');
  if (rawPh.length < 10 || rawPh.length > 12) { setInvalid('regPhone'); showErr('phoneErr',true); valid=false; }

  if (!db) { setInvalid('regDob'); showErr('dobErr',true); valid=false; }

  if (!checkPwd(pw)) { setInvalid('regPwd'); showErr('pwdErr',true); valid=false; }
  if (pw !== cp)     { setInvalid('regCpwd'); showErr('cpwdErr',true); showOk('cpwdOk',false); valid=false; }

  if (ni.length !== 12) { setInvalid('regNid'); showErr('nidErr',true); showOk('nidOk',false); valid=false; }

  if (!tc) { showErr('termsErr',true); valid=false; }
  else      { showErr('termsErr',false); }

  if (!valid) {
    e.preventDefault();
    // Scroll to first error
    const firstInvalid = document.querySelector('.invalid');
    if (firstInvalid) firstInvalid.scrollIntoView({ behavior:'smooth', block:'center' });
  }
});
</script>
</body>
</html>