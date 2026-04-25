<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.gojjam.bank.model.Complaint,java.util.List,
                 java.time.format.DateTimeFormatter" %>
<%
  String pageTitle = "Complaints Management";
  String fullName  = (String) session.getAttribute("fullName");
  String initials  = fullName != null && !fullName.isEmpty()
      ? String.valueOf(fullName.charAt(0)).toUpperCase() : "M";
  List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

  long openCount  = complaints != null ? complaints.stream().filter(c->"OPEN".equals(c.getStatus())).count() : 0;
  long inpCount   = complaints != null ? complaints.stream().filter(c->"IN_PROGRESS".equals(c.getStatus())).count() : 0;
  long resCount   = complaints != null ? complaints.stream().filter(c->"RESOLVED".equals(c.getStatus())).count() : 0;
%>
<%@ include file="includes/header.jsp" %>
<%@ include file="includes/sidebar.jsp" %>

<style>
/* ── Manager Complaints ── */
.cm-hero {
  background: linear-gradient(135deg, #1a3a6e, #2563eb);
  border-radius: 16px; padding: 1.5rem 2rem; color: #fff;
  margin-bottom: 1.5rem; display: flex; align-items: center;
  justify-content: space-between; position: relative; overflow: hidden;
}
.cm-hero::before { content:''; position:absolute; width:200px; height:200px; border-radius:50%; background:rgba(255,255,255,0.05); right:-50px; top:-60px; }
.cm-hero h2 { font-size: 1.2rem; font-weight: 800; }
.cm-hero p  { font-size: 0.82rem; opacity: 0.7; margin-top: 4px; }

.cm-stats { display: flex; gap: 0.8rem; }
.cm-stat {
  background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
  border-radius: 10px; padding: 0.6rem 1rem; text-align: center; position: relative; z-index: 2;
}
.cm-stat .cs-num { font-size: 1.4rem; font-weight: 800; line-height: 1; }
.cm-stat .cs-lbl { font-size: 0.65rem; opacity: 0.8; }

/* Filter tabs */
.filter-tabs { display: flex; gap: 4px; margin-bottom: 1.2rem; background: #fff; border-radius: 12px; padding: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
.ft { flex: 1; text-align: center; padding: 0.55rem; border-radius: 8px; font-size: 0.8rem; font-weight: 700; cursor: pointer; border: none; background: none; font-family: inherit; color: #94a3b8; transition: all 0.2s; }
.ft:hover { background: #f8fafc; color: #0A1F44; }
.ft.active { background: #0A1F44; color: #fff; }

/* Complaint cards */
.cm-card {
  background: #fff; border-radius: 14px; margin-bottom: 1rem;
  box-shadow: 0 2px 12px rgba(0,0,0,0.07); overflow: hidden;
  border-left: 4px solid; transition: box-shadow 0.2s;
}
.cm-card:hover { box-shadow: 0 8px 28px rgba(0,0,0,0.12); }
.cm-card.bc-open { border-left-color: #2563eb; }
.cm-card.bc-inp  { border-left-color: #f59e0b; }
.cm-card.bc-res  { border-left-color: #10b981; }
.cm-card.bc-cls  { border-left-color: #94a3b8; }

.cm-card-head {
  padding: 0.9rem 1.2rem; display: flex; align-items: center;
  justify-content: space-between; gap: 0.8rem; border-bottom: 1px solid #f1f5f9; background: #f8fafc;
}
.cm-meta { display: flex; align-items: center; gap: 0.8rem; flex-wrap: wrap; }
.cm-id { font-size: 0.78rem; color: #94a3b8; font-weight: 600; }
.cm-cat-badge {
  display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px;
  border-radius: 20px; font-size: 0.72rem; font-weight: 700; background: #eff6ff; color: #2563eb;
}
.cm-user { font-size: 0.83rem; font-weight: 700; color: #0A1F44; }
.cm-time { font-size: 0.72rem; color: #94a3b8; white-space: nowrap; }

.cm-card-body { padding: 1rem 1.2rem; }
.cm-desc { font-size: 0.85rem; color: #475569; background: #f8fafc; border-radius: 8px; padding: 0.7rem; line-height: 1.65; margin-bottom: 0.8rem; }
.cm-prev-resp { background: #dcfce7; border-radius: 8px; padding: 0.7rem; font-size: 0.82rem; color: #166534; margin-bottom: 0.8rem; }

/* Response form */
.resp-form { background: #f8fafc; border-radius: 10px; padding: 1rem; border: 1px solid #e2e8f0; }
.resp-form label { font-size: 0.78rem; font-weight: 700; color: #0A1F44; margin-bottom: 5px; display: block; }
.resp-form textarea { width: 100%; border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 0.6rem 0.8rem; font-size: 0.83rem; font-family: inherit; resize: vertical; outline: none; background: #fff; transition: border-color 0.2s; }
.resp-form textarea:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
.resp-form select { border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 0.5rem 0.8rem; font-size: 0.83rem; font-family: inherit; outline: none; background: #fff; }
.resp-form select:focus { border-color: #2563eb; }

.btn-resp { display: inline-flex; align-items: center; gap: 6px; background: linear-gradient(135deg, #1a3a6e, #2563eb); color: #fff; border: none; border-radius: 8px; padding: 0.6rem 1.2rem; font-size: 0.83rem; font-weight: 700; cursor: pointer; font-family: inherit; transition: all 0.2s; }
.btn-resp:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(37,99,235,0.3); }

.st-pill-m { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; }
.st-open { background: #dbeafe; color: #1d4ed8; }
.st-inp  { background: #fef3c7; color: #92400e; }
.st-res  { background: #dcfce7; color: #15803d; }
.st-cls  { background: #f3f4f6; color: #6b7280; }

.empty { padding: 3rem; text-align: center; color: #94a3b8; background: #fff; border-radius: 16px; box-shadow: 0 2px 12px rgba(0,0,0,0.07); }
.empty i { font-size: 3rem; display: block; margin-bottom: 0.8rem; color: #10b981; }

/* Alerts */
.ma { border-radius: 10px; padding: 0.9rem 1rem; margin-bottom: 1.2rem; font-size: 0.88rem; display: flex; align-items: flex-start; gap: 8px; }
.ma-ok  { background: #f0fdf4; border: 1px solid #bbf7d0; border-left: 4px solid #10b981; color: #166534; }
.ma-err { background: #fef2f2; border: 1px solid #fecaca; border-left: 4px solid #ef4444; color: #991b1b; }

@media(max-width:768px){ .cm-stats{flex-wrap:wrap;} .cm-meta{flex-direction:column;align-items:flex-start;} }
</style>

<div class="main-content">
  <header class="topbar" style="background:#fff;border-bottom:1px solid #e2e8f0;padding:0 1.5rem;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:900;box-shadow:0 2px 8px rgba(0,0,0,0.05);">
    <div style="font-size:1rem;font-weight:800;color:#1a3a6e;">
      <i class="bi bi-chat-dots-fill"></i> Complaints Management
    </div>
    <div style="display:flex;align-items:center;gap:8px;">
      <div style="width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,#1a3a6e,#2563eb);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:0.85rem;"><%= initials %></div>
      <strong style="font-size:0.88rem;color:#1a3a6e;"><%= fullName %></strong>
    </div>
  </header>

  <div class="page-content">
    <% if (request.getAttribute("error") != null) { %>
      <div class="ma ma-err"><i class="bi bi-exclamation-circle-fill" style="flex-shrink:0;margin-top:1px;"></i><div><%= request.getAttribute("error") %></div></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="ma ma-ok"><i class="bi bi-check-circle-fill" style="flex-shrink:0;margin-top:1px;"></i><div><%= request.getAttribute("success") %></div></div>
    <% } %>

    <!-- Hero -->
    <div class="cm-hero">
      <div style="position:relative;z-index:2;">
        <h2><i class="bi bi-headset"></i> Customer Complaints &amp; Support</h2>
        <p>Respond to customer complaints and update their status.</p>
      </div>
      <div class="cm-stats">
        <div class="cm-stat">
          <div class="cs-num" style="color:#93c5fd;"><%= openCount %></div>
          <div class="cs-lbl">Open</div>
        </div>
        <div class="cm-stat">
          <div class="cs-num" style="color:#fcd34d;"><%= inpCount %></div>
          <div class="cs-lbl">In Progress</div>
        </div>
        <div class="cm-stat">
          <div class="cs-num" style="color:#6ee7b7;"><%= resCount %></div>
          <div class="cs-lbl">Resolved</div>
        </div>
        <div class="cm-stat">
          <div class="cs-num"><%= complaints != null ? complaints.size() : 0 %></div>
          <div class="cs-lbl">Total</div>
        </div>
      </div>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs">
      <button class="ft active" onclick="filterComplaints('ALL',this)">
        All (<%= complaints != null ? complaints.size() : 0 %>)
      </button>
      <button class="ft" onclick="filterComplaints('OPEN',this)">
        🔵 Open (<%= openCount %>)
      </button>
      <button class="ft" onclick="filterComplaints('IN_PROGRESS',this)">
        🟡 In Progress (<%= inpCount %>)
      </button>
      <button class="ft" onclick="filterComplaints('RESOLVED',this)">
        🟢 Resolved (<%= resCount %>)
      </button>
    </div>

    <!-- Search -->
    <div style="margin-bottom:1rem;">
      <input type="text" id="compSearch" class="form-control"
             placeholder="🔍 Search by customer name, category, or description..."
             style="border:1.5px solid #e2e8f0;border-radius:10px;padding:0.65rem 1rem;
                    font-size:0.88rem;font-family:inherit;outline:none;width:100%;"/>
    </div>

    <!-- Complaint Cards -->
    <% if (complaints == null || complaints.isEmpty()) { %>
      <div class="empty">
        <i class="bi bi-emoji-smile"></i>
        <h3 style="color:#0A1F44;font-weight:800;margin-bottom:0.4rem;">No Complaints Found</h3>
        <p>There are currently no customer complaints to review.</p>
      </div>
    <% } else { %>
      <div id="complaintsList">
      <% for (Complaint c : complaints) {
           String bc      = "OPEN".equals(c.getStatus()) ? "bc-open"
                          : "IN_PROGRESS".equals(c.getStatus()) ? "bc-inp"
                          : "RESOLVED".equals(c.getStatus()) ? "bc-res" : "bc-cls";
           String pillCls = "OPEN".equals(c.getStatus()) ? "st-open"
                          : "IN_PROGRESS".equals(c.getStatus()) ? "st-inp"
                          : "RESOLVED".equals(c.getStatus()) ? "st-res" : "st-cls";
      %>
        <div class="cm-card <%= bc %>" data-status="<%= c.getStatus() %>"
             data-search="<%= (c.getUserName()+" "+c.getCategory()+" "+c.getDescription()).toLowerCase() %>">

          <!-- Head -->
          <div class="cm-card-head">
            <div class="cm-meta">
              <span class="cm-id">#<%= c.getId() %></span>
              <span class="cm-cat-badge">
                <i class="bi bi-tag-fill" style="font-size:0.65rem;"></i>
                <%= c.getCategory() %>
              </span>
              <span class="cm-user">
                <i class="bi bi-person-fill" style="color:#2563eb;margin-right:3px;"></i>
                <%= c.getUserName() %>
              </span>
              <span class="st-pill-m <%= pillCls %>">
                <i class="bi bi-circle-fill" style="font-size:0.5rem;"></i>
                <%= c.getStatus().replace("_"," ") %>
              </span>
            </div>
            <div class="cm-time">
              <i class="bi bi-clock" style="margin-right:3px;"></i>
              <%= c.getCreatedAt() != null ? c.getCreatedAt().format(fmt) : "" %>
            </div>
          </div>

          <!-- Body -->
          <div class="cm-card-body">
            <div class="cm-desc"><%= c.getDescription() %></div>

            <% if (c.getResponse() != null && !c.getResponse().isBlank()) { %>
              <div class="cm-prev-resp">
                <strong><i class="bi bi-reply-fill"></i> Previous Response:</strong>
                <%= c.getResponse() %>
                <% if (c.getRespondedByName() != null) { %>
                  <br/><small style="color:#6c757d;">— <%= c.getRespondedByName() %>,
                    <%= c.getUpdatedAt() != null ? c.getUpdatedAt().format(fmt) : "" %>
                  </small>
                <% } %>
              </div>
            <% } %>

            <!-- Response Form -->
            <div class="resp-form">
              <div style="font-size:0.78rem;font-weight:700;color:#0A1F44;margin-bottom:0.7rem;">
                <i class="bi bi-pencil-square" style="color:#2563eb;"></i>
                <%= (c.getResponse() != null && !c.getResponse().isBlank()) ? "Update Response" : "Write Response" %>
              </div>
              <form method="post" action="${pageContext.request.contextPath}/manager/complaints">
                <input type="hidden" name="csrfToken"   value="${csrfToken}"/>
                <input type="hidden" name="complaintId" value="<%= c.getId() %>"/>

                <label>Your Response <span style="color:#ef4444;">*</span></label>
                <textarea name="response" rows="3" required
                          placeholder="Type your response to the customer..."
                          style="margin-bottom:0.6rem;"><%= c.getResponse() != null ? c.getResponse() : "" %></textarea>

                <div style="display:flex;align-items:center;gap:0.6rem;flex-wrap:wrap;">
                  <div>
                    <label style="margin-bottom:3px;">Update Status</label>
                    <select name="status">
                      <option value="OPEN"        <%= "OPEN".equals(c.getStatus())        ?"selected":"" %>>🔵 Open</option>
                      <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(c.getStatus()) ?"selected":"" %>>🟡 In Progress</option>
                      <option value="RESOLVED"    <%= "RESOLVED".equals(c.getStatus())    ?"selected":"" %>>🟢 Resolved</option>
                      <option value="CLOSED"      <%= "CLOSED".equals(c.getStatus())      ?"selected":"" %>>⚫ Closed</option>
                    </select>
                  </div>
                  <div style="margin-top:auto;">
                    <button type="submit" class="btn-resp">
                      <i class="bi bi-send-fill"></i>
                      <%= (c.getResponse() != null && !c.getResponse().isBlank()) ? "Update Response" : "Send Response" %>
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      <% } %>
      </div>
    <% } %>
  </div><!-- page-content -->
  <%@ include file="/jsp/includes/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
/* Filter by status */
function filterComplaints(status, btn) {
  document.querySelectorAll('.ft').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('#complaintsList .cm-card').forEach(function(card) {
    if (status === 'ALL') {
      card.style.display = '';
    } else {
      card.style.display = card.getAttribute('data-status') === status ? '' : 'none';
    }
  });
}

/* Live search */
document.getElementById('compSearch').addEventListener('input', function () {
  const q = this.value.toLowerCase();
  document.querySelectorAll('#complaintsList .cm-card').forEach(function(card) {
    const text = card.getAttribute('data-search') || '';
    card.style.display = text.includes(q) ? '' : 'none';
  });
});
</script>
</body>
</html>