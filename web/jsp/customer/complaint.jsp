<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Complaint,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Complaints & Support";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U";
  List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
/* ── Complaint Page ── */
.comp-hero {
  background: linear-gradient(135deg, #0A1F44, #1a3a6e, #2563eb);
  border-radius: 16px; padding: 1.5rem 2rem; color: #fff;
  margin-bottom: 1.5rem; display: flex; align-items: center;
  justify-content: space-between; position: relative; overflow: hidden;
}
.comp-hero::before { content:''; position:absolute; width:200px; height:200px; border-radius:50%; background:rgba(255,255,255,0.05); right:-50px; top:-60px; }
.comp-hero h2 { font-size: 1.2rem; font-weight: 800; margin-bottom: 4px; }
.comp-hero p  { font-size: 0.82rem; opacity: 0.7; }

.comp-card { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.07); overflow: hidden; }
.comp-head { background: #0A1F44; color: #fff; padding: 1rem 1.5rem; font-weight: 700; font-size: 0.92rem; display: flex; align-items: center; gap: 8px; }
.comp-body { padding: 1.5rem; }

/* Step progress */
.steps-bar { display: flex; gap: 0; margin-bottom: 1.5rem; }
.step-item { display: flex; align-items: center; flex: 1; }
.step-circle-c {
  width: 32px; height: 32px; border-radius: 50%; border: 2px solid #e2e8f0;
  display: flex; align-items: center; justify-content: center; font-size: 0.78rem;
  font-weight: 800; color: #94a3b8; background: #fff; flex-shrink: 0; transition: all 0.3s;
}
.step-circle-c.active { border-color: #2563eb; color: #2563eb; background: #eff6ff; }
.step-circle-c.done   { border-color: #10b981; background: #10b981; color: #fff; }
.step-lbl-c { font-size: 0.72rem; font-weight: 600; color: #94a3b8; margin-left: 8px; white-space: nowrap; }
.step-lbl-c.active { color: #2563eb; }
.step-lbl-c.done   { color: #10b981; }
.step-line-c { flex: 1; height: 2px; background: #e2e8f0; margin: 0 10px; transition: background 0.3s; }
.step-line-c.done { background: #10b981; }

/* Category Grid */
.cat-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 0.8rem; margin-bottom: 1.2rem; }
.cat-card {
  border: 2px solid #e2e8f0; border-radius: 12px; padding: 0.9rem;
  cursor: pointer; transition: all 0.2s; background: #fff; text-align: center;
}
.cat-card:hover { transform: translateY(-3px); }
.cat-card.selected { border-width: 2px; box-shadow: 0 0 0 3px rgba(37,99,235,0.12); }
.cat-icon { width: 42px; height: 42px; border-radius: 10px; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
.cat-title { font-size: 0.8rem; font-weight: 800; color: #0A1F44; margin-bottom: 2px; }
.cat-sub   { font-size: 0.68rem; color: #94a3b8; }

/* Cat colours */
.cat-tx    { border-color:#dbeafe; } .cat-tx.selected    { border-color:#2563eb; background:#eff6ff; } .cat-tx    .cat-icon { background:#dbeafe; color:#2563eb; }
.cat-acc   { border-color:#dcfce7; } .cat-acc.selected   { border-color:#10b981; background:#f0fdf4; } .cat-acc   .cat-icon { background:#dcfce7; color:#16a34a; }
.cat-loan  { border-color:#fdf4ff; } .cat-loan.selected  { border-color:#9333ea; background:#fdf4ff; } .cat-loan  .cat-icon { background:#fdf4ff; color:#9333ea; }
.cat-bill  { border-color:#fef3c7; } .cat-bill.selected  { border-color:#d97706; background:#fef9ec; } .cat-bill  .cat-icon { background:#fef3c7; color:#d97706; }
.cat-sec   { border-color:#fef2f2; } .cat-sec.selected   { border-color:#dc2626; background:#fef2f2; } .cat-sec   .cat-icon { background:#fef2f2; color:#dc2626; }
.cat-svc   { border-color:#e0f2fe; } .cat-svc.selected   { border-color:#0284c7; background:#f0f9ff; } .cat-svc   .cat-icon { background:#e0f2fe; color:#0284c7; }
.cat-other { border-color:#f3f4f6; } .cat-other.selected { border-color:#6b7280; background:#f9fafb; } .cat-other .cat-icon { background:#f3f4f6; color:#6b7280; }
.cat-trf   { border-color:#fce7f3; } .cat-trf.selected   { border-color:#db2777; background:#fdf2f8; } .cat-trf   .cat-icon { background:#fce7f3; color:#db2777; }
.cat-tech  { border-color:#fdf4ff; } .cat-tech.selected  { border-color:#7c3aed; background:#fdf4ff; } .cat-tech  .cat-icon { background:#ede9fe; color:#7c3aed; }

/* Form */
.fg { display: flex; flex-direction: column; margin-bottom: 1rem; }
.fg label { font-size: 0.8rem; font-weight: 700; color: #0A1F44; margin-bottom: 5px; }
.iw { position: relative; }
.iw .fi { position: absolute; left: 11px; top: 14px; color: #94a3b8; font-size: 0.95rem; }
.inp { width: 100%; padding: 0.65rem 0.9rem 0.65rem 2.3rem; border: 1.5px solid #e2e8f0; border-radius: 10px; font-size: 0.88rem; font-family: inherit; color: #1e293b; outline: none; transition: all 0.2s; background: #fff; }
textarea.inp { padding: 0.65rem 0.9rem 0.65rem 2.3rem; resize: vertical; min-height: 100px; }
.inp:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
.inp.invalid { border-color: #ef4444; background: #fef2f2; }
.inp-error { font-size: 0.72rem; color: #ef4444; margin-top: 3px; font-weight: 600; display: none; }

.char-bar { display: flex; justify-content: space-between; margin-top: 3px; }
.char-bar .cb-hint { font-size: 0.72rem; color: #94a3b8; }
.char-bar .cb-count { font-size: 0.72rem; color: #94a3b8; font-weight: 600; }

/* Priority selector */
.priority-row { display: flex; gap: 0.5rem; margin-bottom: 1rem; }
.prio-btn {
  flex: 1; border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 0.5rem;
  text-align: center; cursor: pointer; font-size: 0.78rem; font-weight: 700;
  font-family: inherit; background: #fff; color: #94a3b8; transition: all 0.2s;
}
.prio-btn:hover { border-color: #94a3b8; }
.prio-btn.psel-low    { border-color: #10b981; background: #f0fdf4; color: #15803d; }
.prio-btn.psel-medium { border-color: #f59e0b; background: #fef9ec; color: #92400e; }
.prio-btn.psel-high   { border-color: #ef4444; background: #fef2f2; color: #dc2626; }

/* Submit button */
.btn-comp {
  width: 100%; padding: 0.85rem; border: none; border-radius: 12px;
  font-size: 1rem; font-weight: 800; cursor: pointer; font-family: inherit;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  background: linear-gradient(135deg, #0A1F44, #2563eb);
  color: #fff; transition: all 0.3s;
}
.btn-comp:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(10,31,68,0.3); }

/* Alerts */
.ald { border-radius: 10px; padding: 0.9rem 1rem; margin-bottom: 1.2rem; font-size: 0.88rem; display: flex; align-items: flex-start; gap: 8px; }
.ald-ok  { background: #f0fdf4; border: 1px solid #bbf7d0; border-left: 4px solid #10b981; color: #166534; }
.ald-err { background: #fef2f2; border: 1px solid #fecaca; border-left: 4px solid #ef4444; color: #991b1b; }

/* Complaint item */
.comp-item {
  border: 1px solid #e2e8f0; border-radius: 12px; padding: 1rem; margin-bottom: 0.8rem;
  border-left: 4px solid;
  transition: box-shadow 0.2s;
}
.comp-item:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
.comp-item.open       { border-left-color: #2563eb; }
.comp-item.in_progress{ border-left-color: #f59e0b; }
.comp-item.resolved   { border-left-color: #10b981; }
.comp-item.closed     { border-left-color: #94a3b8; }

.ci-head { display: flex; justify-content: space-between; align-items: flex-start; gap: 8px; margin-bottom: 0.5rem; }
.ci-title { font-weight: 700; color: #0A1F44; font-size: 0.88rem; }
.ci-date  { font-size: 0.72rem; color: #94a3b8; white-space: nowrap; }
.ci-body  { font-size: 0.83rem; color: #475569; background: #f8fafc; border-radius: 8px; padding: 0.6rem; line-height: 1.6; }
.ci-response { margin-top: 0.6rem; padding: 0.6rem; background: #dcfce7; border-radius: 8px; font-size: 0.82rem; color: #166534; }
.ci-response strong { color: #15803d; }

.st-pill { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
.st-open { background: #dbeafe; color: #1d4ed8; }
.st-inp  { background: #fef3c7; color: #92400e; }
.st-res  { background: #dcfce7; color: #15803d; }
.st-cls  { background: #f3f4f6; color: #6b7280; }

@media(max-width:640px){ .cat-grid{grid-template-columns:1fr 1fr;} }
</style>

<div class="main-content">
  <header class="topbar">
    <div class="topbar-title"><i class="bi bi-chat-dots"></i> Complaints &amp; Support</div>
    <div class="topbar-user">
      <span style="font-size:0.85rem;color:#6c757d;"><%= fullName %></span>
      <div class="avatar-circle"><%= initials %></div>
    </div>
  </header>

  <div class="page-content">

    <% if (request.getAttribute("error") != null) { %>
      <div class="ald ald-err"><i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;"></i><div><%= request.getAttribute("error") %></div></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="ald ald-ok"><i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;"></i><div><%= request.getAttribute("success") %></div></div>
    <% } %>

    <!-- Hero -->
    <div class="comp-hero">
      <div style="position:relative;z-index:2;">
        <h2><i class="bi bi-headset"></i> Customer Support &amp; Complaints</h2>
        <p>Submit your complaint in 3 steps. Our team responds within 24 hours.</p>
      </div>
      <div style="position:relative;z-index:2;text-align:right;">
        <div style="font-size:1.8rem;font-weight:800;"><%= complaints != null ? complaints.size() : 0 %></div>
        <div style="font-size:0.72rem;opacity:0.7;">Total complaints</div>
      </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;">

      <!-- ── LEFT: New Complaint Form ── -->
      <div>
        <div class="comp-card">
          <div class="comp-head">
            <i class="bi bi-plus-circle-fill"></i> Submit New Complaint
          </div>
          <div class="comp-body">

            <!-- Step progress -->
            <div class="steps-bar">
              <div class="step-item">
                <div class="step-circle-c active" id="sc1">1</div>
                <div class="step-lbl-c active" id="sl1">Category</div>
              </div>
              <div class="step-line-c" id="sline1"></div>
              <div class="step-item">
                <div class="step-circle-c" id="sc2">2</div>
                <div class="step-lbl-c" id="sl2">Details</div>
              </div>
              <div class="step-line-c" id="sline2"></div>
              <div class="step-item">
                <div class="step-circle-c" id="sc3">3</div>
                <div class="step-lbl-c" id="sl3">Submit</div>
              </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/customer/complaint"
                  id="compForm" novalidate>
              <input type="hidden" name="csrfToken" value="${csrfToken}"/>
              <input type="hidden" name="category" id="catInput" value=""/>

              <!-- STEP 1: Category -->
              <div id="step1">
                <div style="font-size:0.82rem;color:#475569;margin-bottom:1rem;">
                  <i class="bi bi-hand-index-thumb" style="color:#2563eb;"></i>
                  Select the category that best describes your issue:
                </div>
                <div class="cat-grid">
                  <div class="cat-card cat-tx" onclick="selectCat('Transaction Issue','cat-tx',this)">
                    <div class="cat-icon"><i class="bi bi-arrow-left-right"></i></div>
                    <div class="cat-title">Transaction Issue</div>
                    <div class="cat-sub">Failed or wrong transfer</div>
                  </div>
                  <div class="cat-card cat-acc" onclick="selectCat('Account Problem','cat-acc',this)">
                    <div class="cat-icon"><i class="bi bi-person-x"></i></div>
                    <div class="cat-title">Account Problem</div>
                    <div class="cat-sub">Access, KYC, locking</div>
                  </div>
                  <div class="cat-card cat-loan" onclick="selectCat('Loan Issue','cat-loan',this)">
                    <div class="cat-icon"><i class="bi bi-bank2"></i></div>
                    <div class="cat-title">Loan Issue</div>
                    <div class="cat-sub">Approval, disbursement</div>
                  </div>
                  <div class="cat-card cat-bill" onclick="selectCat('Bill Payment Problem','cat-bill',this)">
                    <div class="cat-icon"><i class="bi bi-receipt"></i></div>
                    <div class="cat-title">Bill Payment</div>
                    <div class="cat-sub">Failed or wrong bill pay</div>
                  </div>
                  <div class="cat-card cat-sec" onclick="selectCat('Security Concern','cat-sec',this)">
                    <div class="cat-icon"><i class="bi bi-shield-exclamation"></i></div>
                    <div class="cat-title">Security Concern</div>
                    <div class="cat-sub">Fraud, suspicious activity</div>
                  </div>
                  <div class="cat-card cat-svc" onclick="selectCat('Poor Service','cat-svc',this)">
                    <div class="cat-icon"><i class="bi bi-emoji-frown"></i></div>
                    <div class="cat-title">Poor Service</div>
                    <div class="cat-sub">Staff or branch issues</div>
                  </div>
                  <div class="cat-card cat-trf" onclick="selectCat('Transfer Delay','cat-trf',this)">
                    <div class="cat-icon"><i class="bi bi-clock-history"></i></div>
                    <div class="cat-title">Transfer Delay</div>
                    <div class="cat-sub">Late or stuck transfer</div>
                  </div>
                  <div class="cat-card cat-tech" onclick="selectCat('Technical Problem','cat-tech',this)">
                    <div class="cat-icon"><i class="bi bi-gear-wide-connected"></i></div>
                    <div class="cat-title">Technical Problem</div>
                    <div class="cat-sub">App or website issues</div>
                  </div>
                  <div class="cat-card cat-other" onclick="selectCat('Other','cat-other',this)">
                    <div class="cat-icon"><i class="bi bi-three-dots"></i></div>
                    <div class="cat-title">Other</div>
                    <div class="cat-sub">Not listed above</div>
                  </div>
                </div>
                <div class="inp-error" id="catErr" style="margin-bottom:0.5rem;">Please select a complaint category.</div>
                <button type="button" class="btn-comp" onclick="goStep(2)" id="step1Btn" disabled
                        style="opacity:0.5;cursor:not-allowed;">
                  <i class="bi bi-arrow-right"></i> Next: Describe Your Issue
                </button>
              </div>

              <!-- STEP 2: Details -->
              <div id="step2" style="display:none;">
                <!-- Selected category badge -->
                <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;
                             padding:0.7rem 1rem;margin-bottom:1rem;display:flex;align-items:center;gap:8px;">
                  <i class="bi bi-tag-fill" style="color:#2563eb;"></i>
                  <span style="font-size:0.85rem;font-weight:700;color:#1d4ed8;" id="selectedCatDisplay"></span>
                  <button type="button" onclick="goStep(1)"
                          style="margin-left:auto;background:none;border:none;cursor:pointer;color:#2563eb;font-size:0.78rem;font-weight:600;">
                    <i class="bi bi-pencil"></i> Change
                  </button>
                </div>

                <!-- Priority -->
                <div class="fg">
                  <label><i class="bi bi-exclamation-triangle" style="color:#f59e0b;"></i> Priority Level</label>
                  <div class="priority-row">
                    <button type="button" class="prio-btn" id="prio-low"
                            onclick="setPriority('low')">
                      🟢 Low
                    </button>
                    <button type="button" class="prio-btn" id="prio-medium"
                            onclick="setPriority('medium')">
                      🟡 Medium
                    </button>
                    <button type="button" class="prio-btn" id="prio-high"
                            onclick="setPriority('high')">
                      🔴 High / Urgent
                    </button>
                  </div>
                </div>

                <div class="fg">
                  <label><i class="bi bi-chat-text" style="color:#2563eb;"></i>
                    Subject / Title <span style="color:#ef4444;">*</span></label>
                  <div class="iw">
                    <i class="bi bi-chat-text fi"></i>
                    <input type="text" name="subject" id="compSubject" class="inp"
                           placeholder="Brief summary of your issue..." maxlength="100"/>
                  </div>
                  <div class="inp-error" id="subjErr">Please provide a brief subject.</div>
                </div>

                <div class="fg">
                  <label><i class="bi bi-text-paragraph" style="color:#2563eb;"></i>
                    Full Description <span style="color:#ef4444;">*</span></label>
                  <div class="iw">
                    <i class="bi bi-text-paragraph fi" style="top:14px;"></i>
                    <textarea name="description" id="compDesc" class="inp"
                              placeholder="Please describe your issue in as much detail as possible. Include dates, amounts, reference numbers if applicable..."
                              maxlength="2000" rows="5" oninput="updateCharCount()"></textarea>
                  </div>
                  <div class="char-bar">
                    <div class="cb-hint">Be as specific as possible for faster resolution.</div>
                    <div class="cb-count"><span id="charCount">0</span>/2000</div>
                  </div>
                  <div class="inp-error" id="descErr">Please describe your issue (minimum 20 characters).</div>
                </div>

                <div style="display:flex;gap:0.8rem;">
                  <button type="button" onclick="goStep(1)"
                          style="flex:0;padding:0.7rem 1.2rem;border:1.5px solid #e2e8f0;
                                 border-radius:10px;background:#fff;font-family:inherit;
                                 font-weight:700;font-size:0.88rem;cursor:pointer;color:#475569;">
                    <i class="bi bi-arrow-left"></i> Back
                  </button>
                  <button type="button" class="btn-comp" style="flex:1;" onclick="goStep(3)">
                    <i class="bi bi-arrow-right"></i> Review &amp; Submit
                  </button>
                </div>
              </div>

              <!-- STEP 3: Review & Submit -->
              <div id="step3" style="display:none;">
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:1.2rem;margin-bottom:1rem;">
                  <div style="font-size:0.82rem;font-weight:800;color:#0A1F44;margin-bottom:0.8rem;">
                    <i class="bi bi-eye"></i> Review Your Complaint
                  </div>
                  <table style="width:100%;font-size:0.83rem;">
                    <tr>
                      <td style="color:#94a3b8;padding:4px 0;width:35%;">Category</td>
                      <td id="rev-cat" style="font-weight:700;color:#0A1F44;"></td>
                    </tr>
                    <tr>
                      <td style="color:#94a3b8;padding:4px 0;">Priority</td>
                      <td id="rev-prio" style="font-weight:700;"></td>
                    </tr>
                    <tr>
                      <td style="color:#94a3b8;padding:4px 0;vertical-align:top;">Description</td>
                      <td id="rev-desc" style="color:#475569;line-height:1.6;"></td>
                    </tr>
                  </table>
                </div>

                <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;padding:0.8rem;margin-bottom:1rem;font-size:0.82rem;color:#1e40af;">
                  <i class="bi bi-envelope-fill"></i>
                  Our support team will be notified immediately and will respond within <strong>24 hours</strong>.
                </div>

                <div style="display:flex;gap:0.8rem;">
                  <button type="button" onclick="goStep(2)"
                          style="flex:0;padding:0.7rem 1.2rem;border:1.5px solid #e2e8f0;border-radius:10px;background:#fff;font-family:inherit;font-weight:700;font-size:0.88rem;cursor:pointer;color:#475569;">
                    <i class="bi bi-arrow-left"></i> Edit
                  </button>
                  <button type="submit" class="btn-comp" style="flex:1;">
                    <i class="bi bi-send-fill"></i> Submit Complaint
                  </button>
                </div>
              </div>

            </form>
          </div>
        </div>
      </div>

      <!-- ── RIGHT: Complaint History ── -->
      <div>
        <div class="comp-card">
          <div class="comp-head">
            <i class="bi bi-list-check"></i> My Complaints
            <span style="margin-left:auto;background:rgba(255,255,255,0.15);padding:2px 10px;border-radius:12px;font-size:0.75rem;">
              <%= complaints != null ? complaints.size() : 0 %> total
            </span>
          </div>
          <div class="comp-body" style="max-height:70vh;overflow-y:auto;">
            <% if (complaints == null || complaints.isEmpty()) { %>
              <div style="padding:2rem;text-align:center;color:#94a3b8;">
                <i class="bi bi-emoji-smile" style="font-size:3rem;color:#10b981;display:block;margin-bottom:0.7rem;"></i>
                <strong>No complaints yet.</strong><br/>
                <span style="font-size:0.82rem;">We hope everything is going smoothly!</span>
              </div>
            <% } else { %>
              <% for (Complaint c : complaints) {
                   String statusClass =
                       "OPEN".equals(c.getStatus())        ? "open" :
                       "IN_PROGRESS".equals(c.getStatus()) ? "in_progress" :
                       "RESOLVED".equals(c.getStatus())    ? "resolved" :
                       "closed";
                   String pillClass =
                       "OPEN".equals(c.getStatus())        ? "st-open" :
                       "IN_PROGRESS".equals(c.getStatus()) ? "st-inp" :
                       "RESOLVED".equals(c.getStatus())    ? "st-res" :
                       "st-cls";
              %>
                <div class="comp-item <%= statusClass %>">
                  <div class="ci-head">
                    <div>
                      <div class="ci-title">
                        <span class="st-pill <%= pillClass %>">
                          <i class="bi bi-<%= "OPEN".equals(c.getStatus())?"circle-fill":"IN_PROGRESS".equals(c.getStatus())?"clock-fill":"RESOLVED".equals(c.getStatus())?"check-circle-fill":"dash-circle" %>"
                             style="font-size:0.65rem;"></i>
                          <%= c.getStatus().replace("_"," ") %>
                        </span>
                        &nbsp; #<%= c.getId() %> – <%= c.getCategory() %>
                      </div>
                    </div>
                    <div class="ci-date">
                      <%= c.getCreatedAt() != null ? c.getCreatedAt().format(fmt) : "" %>
                    </div>
                  </div>
                  <div class="ci-body"><%= c.getDescription() %></div>
                  <% if (c.getResponse() != null && !c.getResponse().isBlank()) { %>
                    <div class="ci-response">
                      <strong><i class="bi bi-reply-fill"></i> Support Response:</strong>
                      <%= c.getResponse() %>
                      <% if (c.getRespondedByName() != null) { %>
                        <br/><small style="color:#6c757d;">— <%= c.getRespondedByName() %>,
                          <%= c.getUpdatedAt() != null ? c.getUpdatedAt().format(fmt) : "" %>
                        </small>
                      <% } %>
                    </div>
                  <% } else { %>
                    <div style="font-size:0.72rem;color:#94a3b8;margin-top:0.4rem;">
                      <i class="bi bi-hourglass"></i> Awaiting response...
                    </div>
                  <% } %>
                </div>
              <% } %>
            <% } %>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="/jsp/includes/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
let selCat = '', selPriority = 'medium';

function selectCat(cat, cssClass, el) {
  selCat = cat;
  document.getElementById('catInput').value = cat;
  document.querySelectorAll('.cat-card').forEach(c => c.classList.remove('selected'));
  el.classList.add('selected');
  document.getElementById('step1Btn').disabled = false;
  document.getElementById('step1Btn').style.opacity = '1';
  document.getElementById('step1Btn').style.cursor = 'pointer';
  document.getElementById('catErr').style.display = 'none';
  updateSteps(1);
}

function setPriority(p) {
  selPriority = p;
  ['low','medium','high'].forEach(function(x) {
    const btn = document.getElementById('prio-' + x);
    btn.className = 'prio-btn' + (x === p ? ' psel-' + x : '');
  });
}

// Init medium priority
setPriority('medium');

function updateSteps(current) {
  [1,2,3].forEach(function(i) {
    const c = document.getElementById('sc' + i);
    const l = document.getElementById('sl' + i);
    if (i < current) {
      c.className = 'step-circle-c done'; c.innerHTML = '<i class="bi bi-check-lg"></i>';
      l.className = 'step-lbl-c done';
      if (i < 3) document.getElementById('sline' + i).className = 'step-line-c done';
    } else if (i === current) {
      c.className = 'step-circle-c active'; c.textContent = i;
      l.className = 'step-lbl-c active';
    } else {
      c.className = 'step-circle-c'; c.textContent = i;
      l.className = 'step-lbl-c';
    }
  });
}

function goStep(n) {
  if (n === 2) {
    if (!selCat) {
      document.getElementById('catErr').style.display = 'block'; return;
    }
    document.getElementById('selectedCatDisplay').textContent = selCat;
  }
  if (n === 3) {
    const subj = document.getElementById('compSubject').value.trim();
    const desc = document.getElementById('compDesc').value.trim();
    let ok = true;
    if (!subj) {
      document.getElementById('compSubject').classList.add('invalid');
      document.getElementById('subjErr').style.display = 'block'; ok = false;
    } else {
      document.getElementById('compSubject').classList.remove('invalid');
      document.getElementById('subjErr').style.display = 'none';
    }
    if (desc.length < 20) {
      document.getElementById('compDesc').classList.add('invalid');
      document.getElementById('descErr').style.display = 'block'; ok = false;
    } else {
      document.getElementById('compDesc').classList.remove('invalid');
      document.getElementById('descErr').style.display = 'none';
    }
    if (!ok) return;
    // Populate review
    const prioLabel = { low:'🟢 Low', medium:'🟡 Medium', high:'🔴 High / Urgent' };
    document.getElementById('rev-cat').textContent  = selCat;
    document.getElementById('rev-prio').textContent = prioLabel[selPriority];
    document.getElementById('rev-prio').style.color = selPriority==='high'?'#dc2626':selPriority==='medium'?'#d97706':'#16a34a';
    document.getElementById('rev-desc').textContent = desc;
  }
  [1,2,3].forEach(function(i) {
    document.getElementById('step' + i).style.display = i === n ? 'block' : 'none';
  });
  updateSteps(n);
}

function updateCharCount() {
  const len = document.getElementById('compDesc').value.length;
  const el  = document.getElementById('charCount');
  el.textContent = len;
  el.style.color = len > 1800 ? '#ef4444' : len > 1500 ? '#f59e0b' : '#94a3b8';
}
</script>
</body>
</html>