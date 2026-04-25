<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Reset Password – Gojjam International Bank</title>
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet"/>
  <style>
    :root {
      --primary:#0A1F44; --secondary:#1a3a6e; --accent:#2563eb;
      --gold:#f59e0b; --success:#10b981; --danger:#ef4444;
      --gray-50:#f8fafc; --gray-100:#f1f5f9; --gray-200:#e2e8f0;
      --gray-400:#94a3b8; --gray-600:#475569; --gray-800:#1e293b;
    }
    * { box-sizing:border-box; margin:0; padding:0; }
    body {
      font-family:'Inter',sans-serif; min-height:100vh;
      background: linear-gradient(135deg,#0A1F44 0%,#1a3a6e 50%,#0e3a6b 100%);
      display:flex; align-items:center; justify-content:center;
      padding:2rem 1rem;
    }

    .fp-container {
      width:100%; max-width:720px; background:#fff;
      border-radius:20px; box-shadow:0 25px 80px rgba(0,0,0,0.4);
      overflow:hidden; animation:fadeUp 0.4s ease;
    }
    @keyframes fadeUp {
      from{opacity:0;transform:translateY(24px);}
      to{opacity:1;transform:translateY(0);}
    }

    /* Header */
    .fp-header {
      background: linear-gradient(135deg,var(--primary),var(--secondary));
      padding:1.8rem 2rem; display:flex; align-items:center; gap:1rem;
      position:relative; overflow:hidden;
    }
    .fp-header::after {
      content:''; position:absolute; width:250px; height:250px; border-radius:50%;
      background:rgba(255,255,255,0.05); right:-60px; top:-80px;
    }
    .fp-header img { height:44px; filter:brightness(0) invert(1); }
    .fp-header-text h2 { color:#fff; font-size:1.2rem; font-weight:800; }
    .fp-header-text p  { color:rgba(255,255,255,0.65); font-size:0.8rem; margin-top:2px; }

    /* Step indicator */
    .fp-steps {
      display:flex; background:var(--gray-50); border-bottom:1px solid var(--gray-200);
    }
    .fp-step {
      flex:1; padding:0.8rem; text-align:center; position:relative;
      cursor:pointer; transition:background 0.2s;
    }
    .fp-step.active { background:#eff6ff; }
    .fp-step-icon {
      width:36px; height:36px; border-radius:50%; margin:0 auto 5px;
      display:flex; align-items:center; justify-content:center;
      font-size:0.95rem; border:2px solid var(--gray-200);
      background:#fff; color:var(--gray-400); transition:all 0.3s;
    }
    .fp-step.active  .fp-step-icon { border-color:var(--accent); color:var(--accent); background:#eff6ff; }
    .fp-step.done    .fp-step-icon { border-color:var(--success); background:var(--success); color:#fff; }
    .fp-step-label { font-size:0.7rem; font-weight:600; color:var(--gray-400); }
    .fp-step.active .fp-step-label { color:var(--accent); }
    .fp-step.done   .fp-step-label { color:var(--success); }

    /* Body */
    .fp-body { padding:1.8rem 2rem; }

    /* Alerts */
    .alert {
      display:flex; gap:10px; align-items:flex-start;
      border-radius:10px; padding:12px; margin-bottom:1.2rem;
      font-size:0.85rem;
    }
    .alert-error   { background:#fef2f2; border:1px solid #fecaca; border-left:4px solid var(--danger); color:#991b1b; }
    .alert-success { background:#f0fdf4; border:1px solid #bbf7d0; border-left:4px solid var(--success); color:#166534; }
    .alert-info    { background:#eff6ff; border:1px solid #bfdbfe; border-left:4px solid var(--accent);  color:#1e40af; }

    /* Sections */
    .section { display:none; }
    .section.active { display:block; }

    .fp-grid { display:grid; grid-template-columns:1fr 1fr; gap:1rem; }
    .fp-grid.one { grid-template-columns:1fr; }

    .form-group { display:flex; flex-direction:column; }
    .form-group label {
      font-size:0.8rem; font-weight:600; color:var(--primary); margin-bottom:5px;
    }
    .inp-wrap { position:relative; }
    .inp-wrap .fi {
      position:absolute; left:11px; top:50%; transform:translateY(-50%);
      color:var(--gray-400); font-size:0.95rem; pointer-events:none;
    }
    .inp {
      width:100%; padding:0.65rem 0.9rem 0.65rem 2.3rem;
      border:1.5px solid var(--gray-200); border-radius:10px;
      font-size:0.88rem; font-family:'Inter',sans-serif;
      color:var(--gray-800); transition:all 0.2s; outline:none;
    }
    .inp:focus { border-color:var(--accent); box-shadow:0 0 0 3px rgba(37,99,235,0.1); }
    .inp.valid   { border-color:var(--success); background:#f0fdf4; }
    .inp.invalid { border-color:var(--danger);  background:#fef2f2; }
    .eye-btn {
      position:absolute; right:10px; top:50%; transform:translateY(-50%);
      background:none; border:none; cursor:pointer; color:var(--gray-400);
    }
    .inp-hint  { font-size:0.72rem; color:var(--gray-400); margin-top:3px; }
    .inp-error { font-size:0.72rem; color:var(--danger); font-weight:600; margin-top:3px; display:none; }

    /* Password Strength */
    .strength-bars { display:flex; gap:4px; margin-top:6px; }
    .s-bar { flex:1; height:5px; border-radius:3px; background:var(--gray-200); transition:background 0.3s; }
    .strength-cap { font-size:0.72rem; font-weight:600; margin-top:4px; }
    .pwd-rules { display:grid; grid-template-columns:1fr 1fr; gap:3px; margin-top:6px; }
    .pwd-rule { font-size:0.72rem; display:flex; align-items:center; gap:5px; color:var(--gray-400); }
    .pwd-rule.ok { color:var(--success); }

    /* Buttons */
    .btn-next, .btn-submit {
      padding:0.75rem 1.8rem; border:none; border-radius:10px;
      font-size:0.92rem; font-weight:700; cursor:pointer;
      font-family:'Inter',sans-serif; display:flex; align-items:center; gap:8px;
      transition:all 0.3s;
    }
    .btn-next {
      background:linear-gradient(135deg,var(--primary),var(--accent));
      color:#fff;
    }
    .btn-next:hover   { transform:translateY(-2px); box-shadow:0 8px 20px rgba(10,31,68,0.3); }
    .btn-submit { background:var(--success); color:#fff; }
    .btn-submit:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(16,185,129,0.35); }
    .btn-back {
      padding:0.7rem 1.5rem; border:2px solid var(--gray-200); border-radius:10px;
      background:none; color:var(--gray-600); font-weight:600; cursor:pointer;
      font-family:'Inter',sans-serif; transition:all 0.2s;
    }
    .btn-back:hover { border-color:var(--primary); color:var(--primary); }

    .btn-row { display:flex; gap:10px; margin-top:1.5rem; }

    /* Verify check card */
    .verify-card {
      background:var(--gray-50); border:1px solid var(--gray-200);
      border-radius:12px; padding:1rem 1.2rem; margin-bottom:1.2rem;
    }
    .verify-card h4 { font-size:0.88rem; font-weight:700; color:var(--primary); margin-bottom:0.6rem; }
    .verify-item {
      display:flex; align-items:center; gap:8px;
      font-size:0.82rem; color:var(--gray-600); padding:4px 0;
      border-bottom:1px solid var(--gray-100);
    }
    .verify-item:last-child { border-bottom:none; }
    .verify-item i { color:var(--accent); width:16px; }

    @media (max-width:600px) {
      .fp-grid { grid-template-columns:1fr; }
      .fp-body { padding:1.2rem; }
    }
  </style>
</head>
<body>

<div class="fp-container">

  <!-- Header -->
  <div class="fp-header">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo"/>
    <div class="fp-header-text">
      <h2>Reset Your Password</h2>
      <p>Verify your identity to securely reset your account password</p>
    </div>
  </div>

  <!-- Steps -->
  <div class="fp-steps">
    <div class="fp-step active" id="tab1">
      <div class="fp-step-icon"><i class="bi bi-person-badge"></i></div>
      <div class="fp-step-label">Identity</div>
    </div>
    <div class="fp-step" id="tab2">
      <div class="fp-step-icon"><i class="bi bi-shield-check"></i></div>
      <div class="fp-step-label">Verification</div>
    </div>
    <div class="fp-step" id="tab3">
      <div class="fp-step-icon"><i class="bi bi-key"></i></div>
      <div class="fp-step-label">New Password</div>
    </div>
  </div>

  <!-- Body -->
  <div class="fp-body">

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">
        <i class="bi bi-exclamation-circle-fill" style="margin-top:1px;flex-shrink:0;"></i>
        <div><%= request.getAttribute("error") %></div>
      </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">
        <i class="bi bi-check-circle-fill" style="margin-top:1px;flex-shrink:0;"></i>
        <div>
          <strong>Password Reset Successful!</strong><br/>
          <%= request.getAttribute("success") %>
          <br/><a href="${pageContext.request.contextPath}/login"
                  style="color:var(--success);font-weight:700;">
            → Sign in now
          </a>
        </div>
      </div>
    <% } %>

    <form method="post"
          action="${pageContext.request.contextPath}/forgot-password"
          id="fpForm" novalidate>
      <input type="hidden" name="csrfToken" value="${csrfToken}"/>

      <!-- ── STEP 1: Account Info ────────────────────────── -->
      <div class="section active" id="sec1">
        <div class="alert alert-info">
          <i class="bi bi-info-circle-fill" style="flex-shrink:0;margin-top:1px;"></i>
          <div>Enter the <strong>exact information</strong> used during registration.
               All 7 fields must match our records. Max 5 attempts allowed.</div>
        </div>

        <div class="fp-grid">
          <div class="form-group">
            <label>Username / Email <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-envelope-fill fi"></i>
              <input type="text" name="username" id="fpUser" class="inp" required
                     placeholder="Registered email"/>
            </div>
            <div class="inp-error" id="fpUserErr">Username is required.</div>
          </div>

          <div class="form-group">
            <label>Full Name <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-person-fill fi"></i>
              <input type="text" name="fullName" id="fpName" class="inp" required
                     placeholder="As registered"/>
            </div>
            <div class="inp-error" id="fpNameErr">Full name is required.</div>
          </div>

          <div class="form-group">
            <label>Email Address <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-at fi"></i>
              <input type="email" name="email" id="fpEmail" class="inp" required
                     placeholder="Registered email"/>
            </div>
            <div class="inp-error" id="fpEmailErr">Valid email required.</div>
          </div>

          <div class="form-group">
            <label>Phone Number <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-telephone-fill fi"></i>
              <input type="tel" name="phone" id="fpPhone" class="inp" required
                     placeholder="+251911234567" maxlength="13"/>
            </div>
            <div class="inp-hint">10–12 digits only.</div>
            <div class="inp-error" id="fpPhoneErr">Phone must be 10–12 digits.</div>
          </div>
        </div>

        <div class="btn-row">
          <button type="button" class="btn-next" onclick="goStep2()">
            <i class="bi bi-arrow-right"></i> Next: Verification
          </button>
        </div>
      </div>

      <!-- ── STEP 2: More Verification ──────────────────── -->
      <div class="section" id="sec2">
        <div class="verify-card">
          <h4><i class="bi bi-shield-lock" style="color:var(--accent);"></i>
            Additional Identity Checks</h4>
          <div class="verify-item"><i class="bi bi-calendar3"></i> Date of Birth must match registration</div>
          <div class="verify-item"><i class="bi bi-card-text"></i> National ID Number (12 chars) must match</div>
          <div class="verify-item"><i class="bi bi-bank2"></i> Account Number must match your registered account</div>
        </div>

        <div class="fp-grid">
          <div class="form-group">
            <label>Date of Birth <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-calendar3 fi"></i>
              <input type="date" name="dateOfBirth" id="fpDob" class="inp" required/>
            </div>
            <div class="inp-error" id="fpDobErr">Date of birth required.</div>
          </div>

          <div class="form-group">
            <label>National ID Number
              <span style="background:#e0f2fe;color:#0277bd;font-size:0.68rem;
                           padding:2px 8px;border-radius:12px;font-weight:600;margin-left:4px;">
                12 chars
              </span>
            </label>
            <div class="inp-wrap">
              <i class="bi bi-fingerprint fi"></i>
              <input type="text" name="nationalId" id="fpNid" class="inp" required
                     placeholder="ETH123456789" maxlength="12"
                     style="text-transform:uppercase;letter-spacing:1px;font-weight:600;"/>
            </div>
            <div style="display:flex;justify-content:space-between;">
              <div class="inp-hint">Exactly 12 characters — no document upload needed.</div>
              <div style="font-size:0.7rem;color:var(--gray-400);" id="nidFpCount">0/12</div>
            </div>
            <div style="height:4px;background:var(--gray-200);border-radius:3px;margin-top:4px;overflow:hidden;">
              <div id="nidFpBar" style="height:100%;width:0%;background:var(--danger);border-radius:3px;transition:all 0.25s;"></div>
            </div>
            <div class="inp-error" id="fpNidErr">National ID must be exactly 12 characters.</div>
          </div>

          <div class="form-group" style="grid-column:span 2;">
            <label>Account Number <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-credit-card-2-front fi"></i>
              <input type="text" name="accountNumber" id="fpAccNum" class="inp" required
                     placeholder="ACC1234567890" pattern="^ACC[0-9]{10}$"
                     style="font-weight:600;letter-spacing:1px;"/>
            </div>
            <div class="inp-hint">Format: ACC followed by 10 digits (e.g. ACC1234567890)</div>
            <div class="inp-error" id="fpAccErr">Valid account number required (ACC + 10 digits).</div>
          </div>
        </div>

        <div class="btn-row">
          <button type="button" class="btn-back" onclick="goSection(1)">
            <i class="bi bi-arrow-left"></i> Back
          </button>
          <button type="button" class="btn-next" onclick="goStep3()">
            <i class="bi bi-arrow-right"></i> Next: New Password
          </button>
        </div>
      </div>

      <!-- ── STEP 3: New Password ───────────────────────── -->
      <div class="section" id="sec3">
        <div class="alert alert-info">
          <i class="bi bi-lock-fill" style="flex-shrink:0;margin-top:1px;"></i>
          <div>Create a <strong>strong new password</strong>. Must be more than 8 characters
               with uppercase, lowercase, numbers, and special characters.</div>
        </div>

        <div class="fp-grid">
          <div class="form-group">
            <label>New Password <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-lock-fill fi"></i>
              <input type="password" name="newPassword" id="fpNewPwd" class="inp"
                     placeholder="Create strong password" required minlength="9"
                     style="padding-right:2.5rem;"/>
              <button type="button" class="eye-btn" onclick="toggle2('fpNewPwd','e1')">
                <i id="e1" class="bi bi-eye"></i>
              </button>
            </div>
            <div class="strength-bars">
              <div class="s-bar" id="fp-sb1"></div>
              <div class="s-bar" id="fp-sb2"></div>
              <div class="s-bar" id="fp-sb3"></div>
              <div class="s-bar" id="fp-sb4"></div>
            </div>
            <div class="strength-cap" id="fp-scap"></div>
            <div class="pwd-rules">
              <div class="pwd-rule" id="fp-r-len">
                <i class="bi bi-x-circle-fill"></i> More than 8 chars
              </div>
              <div class="pwd-rule" id="fp-r-upper">
                <i class="bi bi-x-circle-fill"></i> Uppercase
              </div>
              <div class="pwd-rule" id="fp-r-lower">
                <i class="bi bi-x-circle-fill"></i> Lowercase
              </div>
              <div class="pwd-rule" id="fp-r-num">
                <i class="bi bi-x-circle-fill"></i> Number
              </div>
              <div class="pwd-rule" id="fp-r-spec">
                <i class="bi bi-x-circle-fill"></i> Special char
              </div>
            </div>
            <div class="inp-error" id="fpNewPwdErr">Password does not meet requirements.</div>
          </div>

          <div class="form-group">
            <label>Confirm New Password <span style="color:var(--danger)">*</span></label>
            <div class="inp-wrap">
              <i class="bi bi-lock fi"></i>
              <input type="password" name="confirmPassword" id="fpCpwd" class="inp"
                     placeholder="Re-enter new password" required
                     style="padding-right:2.5rem;"/>
              <button type="button" class="eye-btn" onclick="toggle2('fpCpwd','e2')">
                <i id="e2" class="bi bi-eye"></i>
              </button>
            </div>
            <div class="inp-error" id="fpCpwdErr">Passwords do not match.</div>
            <div style="font-size:0.72rem;color:var(--success);margin-top:3px;display:none;"
                 id="fpCpwdOk">✔ Passwords match!</div>
          </div>
        </div>

        <div class="btn-row">
          <button type="button" class="btn-back" onclick="goSection(2)">
            <i class="bi bi-arrow-left"></i> Back
          </button>
          <button type="submit" class="btn-submit" id="fpSubmitBtn">
            <i class="bi bi-shield-lock-fill"></i> Reset Password Securely
          </button>
        </div>

        <div style="margin-top:1.2rem;text-align:center;">
          <a href="${pageContext.request.contextPath}/login"
             style="font-size:0.82rem;color:var(--accent);font-weight:600;text-decoration:none;">
            <i class="bi bi-arrow-left"></i> Back to Login
          </a>
        </div>
      </div>

    </form>
  </div>
</div>

<script>
function toggle2(id, ic) {
  const i=document.getElementById(id),e=document.getElementById(ic);
  i.type=i.type==='password'?'text':'password';
  e.className=i.type==='password'?'bi bi-eye':'bi bi-eye-slash';
}
function goSection(n) {
  [1,2,3].forEach(i=>{
    document.getElementById('sec'+i).classList.toggle('active',i===n);
    const tab=document.getElementById('tab'+i);
    tab.classList.toggle('active',i===n);
    if(i<n) tab.className='fp-step done';
  });
}

function goStep2() {
  let ok=true;
  const u=document.getElementById('fpUser').value.trim();
  const n=document.getElementById('fpName').value.trim();
  const e=document.getElementById('fpEmail').value.trim();
  const p=document.getElementById('fpPhone').value.trim();
  const setE=(id,show)=>document.getElementById(id).style.display=show?'block':'none';

  if(!u){setE('fpUserErr',true);ok=false;} else setE('fpUserErr',false);
  if(n.length<2){setE('fpNameErr',true);ok=false;} else setE('fpNameErr',false);
  if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(e)){setE('fpEmailErr',true);ok=false;} else setE('fpEmailErr',false);
  const rawP=p.replace(/[^0-9]/g,'');
  if(rawP.length<10||rawP.length>12){setE('fpPhoneErr',true);ok=false;} else setE('fpPhoneErr',false);
  if(ok) goSection(2);
}

function goStep3() {
  let ok=true;
  const d=document.getElementById('fpDob').value;
  const ni=document.getElementById('fpNid').value;
  const ac=document.getElementById('fpAccNum').value.trim();
  const setE=(id,show)=>document.getElementById(id).style.display=show?'block':'none';

  if(!d){setE('fpDobErr',true);ok=false;} else setE('fpDobErr',false);
  if(ni.length!==12){setE('fpNidErr',true);ok=false;} else setE('fpNidErr',false);
  if(!/^ACC[0-9]{10}$/.test(ac)){setE('fpAccErr',true);ok=false;} else setE('fpAccErr',false);
  if(ok) goSection(3);
}

/* National ID live counter */
document.getElementById('fpNid').addEventListener('input',function(){
  this.value=this.value.toUpperCase().replace(/[^A-Z0-9\-]/g,'');
  const l=this.value.length;
  document.getElementById('nidFpCount').textContent=l+'/12';
  const bar=document.getElementById('nidFpBar');
  bar.style.width=(l/12*100)+'%';
  bar.style.background=l===12?'#10b981':l>12?'#ef4444':'#f59e0b';
});

/* Password strength */
function fpPwdCheck(val) {
  const rules={len:val.length>8,upper:/[A-Z]/.test(val),lower:/[a-z]/.test(val),
               num:/[0-9]/.test(val),spec:/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(val)};
  const keys=['len','upper','lower','num','spec'];
  const colors=['','#ef4444','#f59e0b','#f59e0b','#10b981','#10b981'];
  const labels=['','Very Weak','Weak','Fair','Strong','Very Strong'];
  const score=Object.values(rules).filter(Boolean).length;
  keys.forEach(k=>{
    const el=document.getElementById('fp-r-'+k);
    const ic=el.querySelector('i');
    el.classList.toggle('ok',rules[k]);
    ic.className=rules[k]?'bi bi-check-circle-fill':'bi bi-x-circle-fill';
  });
  for(let i=1;i<=4;i++){
    document.getElementById('fp-sb'+i).style.background=i<=score?colors[score]:'#e2e8f0';
  }
  const cap=document.getElementById('fp-scap');
  cap.textContent=val?labels[score]:''; cap.style.color=colors[score]||'#94a3b8';
  return score===5;
}

document.getElementById('fpNewPwd').addEventListener('input',function(){
  fpPwdCheck(this.value);
  const cp=document.getElementById('fpCpwd').value;
  if(cp){
    const m=cp===this.value;
    document.getElementById('fpCpwdErr').style.display=m?'none':'block';
    document.getElementById('fpCpwdOk').style.display=m?'block':'none';
  }
});
document.getElementById('fpCpwd').addEventListener('input',function(){
  const m=this.value===document.getElementById('fpNewPwd').value;
  document.getElementById('fpCpwdErr').style.display=m?'none':'block';
  document.getElementById('fpCpwdOk').style.display=m?'block':'none';
});

document.getElementById('fpForm').addEventListener('submit',function(e){
  const p=document.getElementById('fpNewPwd').value;
  const c=document.getElementById('fpCpwd').value;
  let ok=true;
  if(!fpPwdCheck(p)){
    document.getElementById('fpNewPwdErr').style.display='block'; ok=false;
  } else { document.getElementById('fpNewPwdErr').style.display='none'; }
  if(p!==c){ document.getElementById('fpCpwdErr').style.display='block'; ok=false; }
  if(!ok) e.preventDefault();
});
</script>
</body>
</html>