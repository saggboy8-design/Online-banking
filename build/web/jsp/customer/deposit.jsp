<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String pageTitle = "Deposit";
    String fullName  = (String) session.getAttribute("fullName");
    String initials  = fullName != null && !fullName.isEmpty()
        ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-arrow-down-circle"></i> Deposit Funds</div>
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

    <div class="alert-bank alert-info">
      <i class="bi bi-info-circle-fill"></i>
      <strong>Internal</strong> deposits are instant. <strong>External</strong> and
      <strong>International</strong> deposits require manager approval (PENDING → SUCCESS).
    </div>

    <div class="bank-card">
      <div class="bank-card-header">
        <i class="bi bi-piggy-bank"></i> New Deposit Request
      </div>
      <div class="bank-card-body">

        <!-- Type Tabs -->
        <div class="bank-tabs" id="depositTabs">
          <button type="button" class="bank-tab active"
                  onclick="switchDepositType('INTERNAL', this)">
            <i class="bi bi-building"></i> Internal
          </button>
          <button type="button" class="bank-tab"
                  onclick="switchDepositType('EXTERNAL', this)">
            <i class="bi bi-bank2"></i> External Bank
          </button>
          <button type="button" class="bank-tab"
                  onclick="switchDepositType('INTERNATIONAL', this)">
            <i class="bi bi-globe2"></i> International (SWIFT)
          </button>
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/customer/deposit"
              id="depositForm" novalidate>
          <input type="hidden" name="csrfToken"    value="${csrfToken}"/>
          <input type="hidden" name="depositType"  id="depositTypeInput" value="INTERNAL"/>

          <!-- ── INTERNAL ─────────────────────────────────────── -->
          <div id="internalSection">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">
                  Source Name <span class="required-star">*</span>
                </label>
                <input type="text" name="sourceName" id="srcName"
                       class="form-control" maxlength="200"
                       placeholder="Your name or reference"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Amount (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="amount" id="amountInternal"
                       class="form-control" min="1" step="0.01"
                       placeholder="1000.00"/>
                <div class="fee-display">
                  <i class="bi bi-tag"></i> Deposit Fee: <strong>ETB 0.00</strong>
                  &nbsp;| Net Credit: <strong id="netInternal">ETB 0.00</strong>
                </div>
              </div>
            </div>
          </div>

          <!-- ── EXTERNAL ─────────────────────────────────────── -->
          <div id="externalSection" style="display:none;">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">
                  Source Bank Name <span class="required-star">*</span>
                </label>
                <input type="text" name="bankName" class="form-control"
                       placeholder="CBE, Awash Bank..." maxlength="200"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Source Account Number <span class="required-star">*</span>
                </label>
                <input type="text" name="sourceAccount" class="form-control"
                       placeholder="Sender's account number" maxlength="50"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Sender Name <span class="required-star">*</span>
                </label>
                <input type="text" name="sourceName" class="form-control"
                       placeholder="Full name of sender" maxlength="200"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Amount (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="amount" id="amountExternal"
                       class="form-control" min="1" step="0.01"
                       placeholder="5000.00"/>
                <div class="fee-display">
                  <i class="bi bi-tag"></i> Processing Fee: <strong>ETB 50.00</strong>
                  &nbsp;| Status: <strong style="color:#856404;">PENDING → Approval</strong>
                </div>
              </div>
            </div>
          </div>

          <!-- ── INTERNATIONAL / SWIFT ────────────────────────── -->
          <div id="intlSection" style="display:none;">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">
                  Beneficiary Name <span class="required-star">*</span>
                </label>
                <input type="text" name="beneficiaryName" class="form-control"
                       placeholder="Account holder name" maxlength="200"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  IBAN / Account Number <span class="required-star">*</span>
                </label>
                <input type="text" name="iban" class="form-control"
                       placeholder="GB29NWBK60161331926819" maxlength="50"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  SWIFT / BIC Code <span class="required-star">*</span>
                </label>
                <input type="text" name="swiftCode" class="form-control"
                       placeholder="CBETETAA" maxlength="11"
                       style="text-transform:uppercase;"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Sending Bank Name <span class="required-star">*</span>
                </label>
                <input type="text" name="bankName" class="form-control"
                       placeholder="HSBC, Deutsche Bank..." maxlength="200"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Country <span class="required-star">*</span>
                </label>
                <input type="text" name="country" class="form-control"
                       placeholder="United Kingdom, USA..." maxlength="100"/>
              </div>
              <div class="col-md-6">
                <label class="form-label">
                  Amount (ETB) <span class="required-star">*</span>
                </label>
                <input type="number" name="amount" id="amountIntl"
                       class="form-control" min="1" step="0.01"
                       placeholder="10000.00"/>
                <div class="fee-display">
                  <i class="bi bi-tag"></i> SWIFT Fee: <strong>ETB 50.00</strong>
                  &nbsp;| Status: <strong style="color:#856404;">PENDING → Manager Approval</strong>
                </div>
              </div>
            </div>
          </div>

          <div class="section-divider"></div>
          <button type="submit" class="btn-bank" style="max-width:250px;">
            <i class="bi bi-send-check"></i> Submit Deposit Request
          </button>
        </form>
      </div>
    </div>
  </div><!-- page-content -->
</div><!-- main-content -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function switchDepositType(type, btn) {
  document.getElementById('depositTypeInput').value = type;
  document.querySelectorAll('#depositTabs .bank-tab')
          .forEach(t => t.classList.remove('active'));
  btn.classList.add('active');
  ['internalSection','externalSection','intlSection']
    .forEach(id => document.getElementById(id).style.display = 'none');
  const map = {INTERNAL:'internalSection', EXTERNAL:'externalSection', INTERNATIONAL:'intlSection'};
  document.getElementById(map[type]).style.display = 'block';
}

document.getElementById('amountInternal')?.addEventListener('input', function () {
  const n = parseFloat(this.value) || 0;
  document.getElementById('netInternal').textContent = 'ETB ' + n.toFixed(2);
});

document.getElementById('depositForm').addEventListener('submit', function (e) {
  const amount = this.querySelector('[name="amount"]').value;
  if (!amount || parseFloat(amount) <= 0) {
    e.preventDefault();
    alert('Please enter a valid amount greater than zero.');
  }
});
</script>
</body>
</html>