<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String pageTitle = "Change Password";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-key"></i> Change Password</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
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

    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="bank-card">
          <div class="bank-card-header">
            <i class="bi bi-shield-lock"></i> Update Your Password
          </div>
          <div class="bank-card-body">

            <div class="alert-bank alert-info" style="font-size:0.83rem;">
              <i class="bi bi-info-circle"></i>
              Password must be at least 8 characters and include uppercase, lowercase,
              a number, and a special character.
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/customer/change-password"
                  id="changePwdForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>

              <div class="mb-3">
                <label class="form-label">
                  Current Password <span class="required-star">*</span>
                </label>
                <div style="position:relative;">
                  <input type="password" name="currentPassword" id="currentPwd"
                         class="form-control" required autocomplete="current-password"
                         placeholder="Enter current password"
                         style="padding-right:2.5rem;"/>
                  <button type="button" onclick="toggleField('currentPwd','eyeCurrent')"
                          style="position:absolute;right:10px;top:50%;transform:translateY(-50%);
                                 background:none;border:none;cursor:pointer;color:#6c757d;">
                    <i id="eyeCurrent" class="bi bi-eye"></i>
                  </button>
                </div>
              </div>

              <div class="section-divider"></div>

              <div class="mb-3">
                <label class="form-label">
                  New Password <span class="required-star">*</span>
                </label>
                <div style="position:relative;">
                  <input type="password" name="newPassword" id="password"
                         class="form-control" required minlength="8"
                         autocomplete="new-password"
                         placeholder="Create a strong password"
                         style="padding-right:2.5rem;"/>
                  <button type="button" onclick="toggleField('password','eyeNew')"
                          style="position:absolute;right:10px;top:50%;transform:translateY(-50%);
                                 background:none;border:none;cursor:pointer;color:#6c757d;">
                    <i id="eyeNew" class="bi bi-eye"></i>
                  </button>
                </div>
                <!-- Strength Meter -->
                <div class="strength-bar">
                  <div class="strength-fill" id="strengthFill"></div>
                </div>
                <div class="strength-label" id="strengthLabel"></div>
                <div id="strengthTip" style="font-size:0.78rem;margin-top:4px;"></div>
              </div>

              <div class="mb-4">
                <label class="form-label">
                  Confirm New Password <span class="required-star">*</span>
                </label>
                <input type="password" name="confirmPassword" id="confirmPwd"
                       class="form-control" required minlength="8"
                       autocomplete="new-password"
                       placeholder="Re-enter new password"/>
                <div class="invalid-feedback" id="pwdMatchMsg">
                  Passwords do not match.
                </div>
              </div>

              <!-- Requirements Checklist -->
              <div style="background:#f4f6f9;border-radius:8px;padding:0.8rem;
                           margin-bottom:1rem;font-size:0.82rem;">
                <strong style="color:#0A1F44;">Password Requirements:</strong>
                <ul style="margin:0.4rem 0 0 1rem;padding:0;list-style:none;">
                  <li id="req-len"   style="color:#dc3545;"><i class="bi bi-x-circle"></i> Minimum 8 characters</li>
                  <li id="req-upper" style="color:#dc3545;"><i class="bi bi-x-circle"></i> One uppercase letter (A-Z)</li>
                  <li id="req-lower" style="color:#dc3545;"><i class="bi bi-x-circle"></i> One lowercase letter (a-z)</li>
                  <li id="req-num"   style="color:#dc3545;"><i class="bi bi-x-circle"></i> One number (0-9)</li>
                  <li id="req-spec"  style="color:#dc3545;"><i class="bi bi-x-circle"></i> One special character (!@#$...)</li>
                </ul>
              </div>

              <button type="submit" class="btn-bank">
                <i class="bi bi-check-circle"></i> Change Password
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function toggleField(inputId, iconId) {
  const i = document.getElementById(inputId);
  const e = document.getElementById(iconId);
  if (i.type === 'password') {
    i.type = 'text'; e.className = 'bi bi-eye-slash';
  } else {
    i.type = 'password'; e.className = 'bi bi-eye';
  }
}

/* Live requirement check */
document.getElementById('password').addEventListener('input', function () {
  const v = this.value;
  const check = (id, ok) => {
    const el = document.getElementById(id);
    el.style.color = ok ? '#28a745' : '#dc3545';
    el.querySelector('i').className = ok ? 'bi bi-check-circle-fill' : 'bi bi-x-circle';
  };
  check('req-len',   v.length >= 8);
  check('req-upper', /[A-Z]/.test(v));
  check('req-lower', /[a-z]/.test(v));
  check('req-num',   /[0-9]/.test(v));
  check('req-spec',  /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(v));
});

document.getElementById('confirmPwd').addEventListener('input', function () {
  const pwd = document.getElementById('password').value;
  if (this.value && this.value !== pwd) {
    this.classList.add('is-invalid');
  } else {
    this.classList.remove('is-invalid');
  }
});

document.getElementById('changePwdForm').addEventListener('submit', function (e) {
  const newPwd  = document.getElementById('password').value;
  const confPwd = document.getElementById('confirmPwd').value;
  if (newPwd !== confPwd) {
    e.preventDefault();
    document.getElementById('confirmPwd').classList.add('is-invalid');
  }
});
</script>
</body>
</html>