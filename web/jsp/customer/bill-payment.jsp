<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Bill Payment";
  String fullName = (String) session.getAttribute("fullName");
  String initials = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-receipt"></i> Bill Payment</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-bank alert-error"><i class="bi bi-exclamation-circle-fill"></i>
        <%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert-bank alert-success"><i class="bi bi-check-circle-fill"></i>
        <%= request.getAttribute("success") %></div>
    <% } %>

    <div class="row">
      <!-- Bill Type Quick Select -->
      <div class="col-md-3 mb-3">
        <div class="bank-card">
          <div class="bank-card-header"><i class="bi bi-grid"></i> Bill Types</div>
          <div class="bank-card-body" style="padding:0.5rem;">
            <% String[][] bills = {
              {"ELECTRICITY","bi-lightning-charge","Electricity"},
              {"WATER","bi-droplet","Water"},
              {"INTERNET","bi-wifi","Internet"},
              {"MOBILE","bi-phone","Mobile Recharge"},
              {"SCHOOL_FEES","bi-mortarboard","School Fees"}
            }; %>
            <% for (String[] b : bills) { %>
            <button type="button" onclick="selectBill('<%= b[0] %>')"
                    style="width:100%;text-align:left;padding:0.6rem 0.8rem;
                           margin-bottom:4px;border:1px solid #dee2e6;border-radius:6px;
                           background:#fff;cursor:pointer;display:flex;align-items:center;gap:8px;">
              <i class="bi <%= b[1] %>" style="color:#0A1F44;"></i>
              <span style="font-size:0.88rem;"><%= b[2] %></span>
            </button>
            <% } %>
          </div>
        </div>
      </div>

      <!-- Payment Form -->
      <div class="col-md-9">
        <div class="bank-card">
          <div class="bank-card-header"><i class="bi bi-credit-card"></i> Pay Bill</div>
          <div class="bank-card-body">
            <form method="post" action="${pageContext.request.contextPath}/customer/bill-payment"
                  id="billForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>

              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label">Bill Type <span class="required-star">*</span></label>
                  <select name="billType" id="billType" class="form-select" required>
                    <option value="">-- Select Bill Type --</option>
                    <option value="ELECTRICITY">⚡ Electricity</option>
                    <option value="WATER">💧 Water</option>
                    <option value="INTERNET">🌐 Internet</option>
                    <option value="MOBILE">📱 Mobile Recharge</option>
                    <option value="SCHOOL_FEES">🎓 School Fees</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Provider / Company Name <span class="required-star">*</span></label>
                  <input type="text" name="providerName" class="form-control"
                         placeholder="EEU, AAWSA, Ethio Telecom..." required maxlength="200"/>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Reference / Bill Number <span class="required-star">*</span></label>
                  <input type="text" name="referenceNumber" class="form-control"
                         placeholder="Unique reference number" required maxlength="100"/>
                  <small style="color:#6c757d;font-size:0.78rem;">This must be unique per payment type.</small>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Amount (ETB) <span class="required-star">*</span></label>
                  <input type="number" name="amount" id="billAmount" class="form-control"
                         placeholder="250.00" min="1" step="0.01" required/>
                  <div class="fee-display" id="billFeeDisplay">
                    Service Fee: ETB 10.00 | Total: ETB <span id="billTotal">0.00</span>
                  </div>
                </div>
              </div>

              <div class="section-divider"></div>
              <div style="display:flex;gap:10px;">
                <button type="submit" class="btn-bank" style="max-width:200px;">
                  <i class="bi bi-credit-card"></i> Pay Now
                </button>
                <button type="submit" name="downloadPdf" value="true"
                        class="btn-bank btn-accent" style="max-width:220px;">
                  <i class="bi bi-file-pdf"></i> Pay & Download Receipt
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function selectBill(type) {
  document.getElementById('billType').value = type;
}
document.getElementById('billAmount')?.addEventListener('input', function() {
  const total = (parseFloat(this.value)||0) + 10;
  document.getElementById('billTotal').textContent = total.toFixed(2);
});
document.getElementById('billForm').addEventListener('submit', function(e) {
  const fields = ['billType','providerName','referenceNumber','billAmount'];
  let ok = true;
  fields.forEach(id => {
    const el = document.getElementById(id) || document.querySelector('[name="'+id+'"]');
    if (el && !el.value.trim()) { el.classList.add('is-invalid'); ok=false; }
    else if (el) el.classList.remove('is-invalid');
  });
  if (!ok) e.preventDefault();
});
</script>
</body>
</html>