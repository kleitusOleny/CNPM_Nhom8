<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý ván đấu - Admin Tâm Thế</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
  <style>
    /* === PLAYER PAIR === */
    .player-pair { display:flex; align-items:center; gap:6px; }
    .stone-icon  { width:16px; height:16px; border-radius:50%; flex-shrink:0; }
    .stone-icon.black { background:radial-gradient(circle at 35% 35%,#555,#111); box-shadow:0 1px 3px rgba(0,0,0,.4); }
    .stone-icon.white { background:radial-gradient(circle at 35% 35%,#fff,#ddd); border:1px solid rgba(0,0,0,.15); }
    .vs-label { font-size:10px; color:var(--color-on-surface-variant); font-weight:700; }

    /* === BOARD CHIP === */
    .board-chip {
      display:inline-block; padding:2px 8px;
      background:var(--color-surface-container);
      border-radius:var(--radius-full);
      font-size:11px; font-weight:600; color:var(--color-on-surface-variant);
    }

    /* === ICON BUTTONS === */
    .btn-icon {
      width:30px; height:30px; border-radius:var(--radius);
      border:1px solid var(--color-outline-variant); background:transparent;
      cursor:pointer; display:flex; align-items:center; justify-content:center;
      color:var(--color-on-surface-variant); transition:all var(--transition-fast);
    }
    .btn-icon:hover        { background:var(--color-surface-container); color:var(--color-on-surface); }
    .btn-icon.danger:hover { background:var(--color-error-container); color:var(--color-error); border-color:var(--color-error); }
    .btn-icon:disabled     { opacity:.35; cursor:not-allowed; }
    .action-btns { display:flex; gap:4px; }

    /* === LIVE === */
    .live-dot { width:7px; height:7px; border-radius:50%; background:#28a745; display:inline-block; animation:blink 1.5s infinite; }
    .live-indicator { display:inline-flex; align-items:center; gap:5px; }
    @keyframes blink { 0%,100%{opacity:1;} 50%{opacity:.3;} }

    /* === TABS === */
    .tab-bar {
      display:flex; gap:4px;
      background:var(--color-surface-container);
      padding:4px; border-radius:var(--radius-md);
      margin-bottom:var(--space-lg); width:fit-content;
    }
    .tab-btn {
      padding:7px 18px; border:none; border-radius:var(--radius);
      background:transparent; font-family:var(--font-family);
      font-size:var(--font-size-body-sm); font-weight:500;
      color:var(--color-on-surface-variant); cursor:pointer;
      transition:all var(--transition-fast); white-space:nowrap;
    }
    .tab-btn.active {
      background:var(--color-surface-container-lowest);
      color:var(--color-on-surface); box-shadow:var(--shadow-sm);
    }

    /* === CONFIRM MODAL === */
    .modal-overlay {
      position:fixed; inset:0;
      background:rgba(26,42,58,.45); backdrop-filter:blur(4px);
      z-index:999; display:none; align-items:center; justify-content:center;
    }
    .modal-overlay.show { display:flex; }
    .modal {
      background:var(--color-surface-container-lowest);
      border-radius:var(--radius-xl); padding:var(--space-xl);
      max-width:440px; width:90%; box-shadow:var(--shadow-xl);
      animation:slideUp .2s ease;
    }
    @keyframes slideUp { from{transform:translateY(16px);opacity:0;} to{transform:translateY(0);opacity:1;} }
    .modal-icon  { font-size:40px; margin-bottom:var(--space-md); }
    .modal-title { font-size:18px; font-weight:700; margin-bottom:8px; color:var(--color-on-surface); }
    .modal-desc  { font-size:14px; color:var(--color-on-surface-variant); margin-bottom:var(--space-lg); line-height:1.5; }
    .modal-footer{ display:flex; gap:var(--space-sm); justify-content:flex-end; }

    /* === TOAST === */
    #toast {
      position:fixed; bottom:24px; right:24px; z-index:1100;
      padding:12px 20px; border-radius:var(--radius-md);
      font-size:14px; font-weight:500; box-shadow:var(--shadow-lg);
      opacity:0; transform:translateY(8px);
      transition:opacity .25s,transform .25s; pointer-events:none;
    }
    #toast.show   { opacity:1; transform:translateY(0); }
    #toast.success{ background:#d1fae5; color:#065f46; }
    #toast.error  { background:var(--color-error-container); color:var(--color-error); }

    /* === EMPTY STATE === */
    .empty-state       { text-align:center; padding:60px var(--space-lg); color:var(--color-on-surface-variant); }
    .empty-state-icon  { font-size:56px; margin-bottom:var(--space-md); }
    .empty-state-title { font-size:16px; font-weight:600; color:var(--color-on-surface); margin-bottom:6px; }
    .empty-state-sub   { font-size:13px; }

    /* === RESULT BADGE === */
    .result-black { background:rgba(26,42,58,.1); color:var(--color-primary-container); }
    .result-white { background:rgba(210,180,140,.2); color:var(--color-secondary); }
  </style>
</head>
<body>
<div class="layout-wrapper">

  <%-- ════════ SIDEBAR ════════ --%>
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="sidebar-logo">⬡</div>
      <div class="sidebar-brand-text">
        <div class="sidebar-brand-name">Tâm Thế</div>
        <div class="sidebar-brand-sub">Admin Panel</div>
      </div>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-section">
        <div class="nav-section-label">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
          Dashboard
        </a>
      </div>
      <div class="nav-section">
        <div class="nav-section-label">Quản lý</div>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          Người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/games" class="nav-item active">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="3" y1="15" x2="21" y2="15"/><line x1="9" y1="3" x2="9" y2="21"/><line x1="15" y1="3" x2="15" y2="21"/></svg>
          Ván đấu
        </a>
      </div>
      <div class="nav-section">
        <div class="nav-section-label">Hệ thống</div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
          Đăng xuất
        </a>
      </div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="sidebar-avatar">A</div>
        <div>
          <div class="sidebar-username">${not empty sessionScope.displayName ? sessionScope.displayName : 'Admin'}</div>
          <div class="sidebar-role">Quản trị viên</div>
        </div>
      </div>
    </div>
  </aside>

  <%-- ════════ MAIN ════════ --%>
  <main class="main-content">

    <%-- Topbar --%>
    <div class="topbar">
      <div>
        <div class="topbar-title">Quản lý ván đấu</div>
        <div class="topbar-breadcrumb">Admin › Ván đấu</div>
      </div>
      <div class="flex gap-md">
        <button class="btn btn-secondary btn-sm" onclick="exportCSV()">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
            <polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
          Xuất CSV
        </button>
      </div>
    </div>

    <div class="page-body">

      <%-- ── Stat Cards ── --%>
      <div class="stat-grid" style="grid-template-columns:repeat(4,1fr); margin-bottom:var(--space-lg);">
        <div class="stat-card">
          <div class="stat-icon">♟</div>
          <div class="stat-value">${totalGames}</div>
          <div class="stat-label">Tổng ván đấu</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon" style="font-size:16px;">🟢</div>
          <div class="stat-value" style="color:#155724;">${liveGames}</div>
          <div class="stat-label">Đang diễn ra</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">✅</div>
          <div class="stat-value">${finishedGames}</div>
          <div class="stat-label">Đã kết thúc</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">⏳</div>
          <div class="stat-value">${waitingGames}</div>
          <div class="stat-label">Đang chờ</div>
        </div>
      </div>

      <%-- ── Tab bar ── --%>
      <div class="tab-bar">
        <button class="tab-btn ${empty statusFilter ? 'active' : ''}"
                onclick="goTab('')">Tất cả</button>
        <button class="tab-btn ${statusFilter eq 'IN_PROGRESS' ? 'active' : ''}"
                onclick="goTab('IN_PROGRESS')">
          <span class="live-indicator"><span class="live-dot"></span>Đang diễn ra</span>
        </button>
        <button class="tab-btn ${statusFilter eq 'FINISHED' ? 'active' : ''}"
                onclick="goTab('FINISHED')">Đã kết thúc</button>
        <button class="tab-btn ${statusFilter eq 'WAITING' ? 'active' : ''}"
                onclick="goTab('WAITING')">Đang chờ</button>
      </div>

      <%-- ── Filter bar ── --%>
      <form id="filterForm" action="${pageContext.request.contextPath}/admin/games"
            method="GET" class="filter-bar" style="margin-bottom:var(--space-lg);">
        <input type="hidden" name="status" id="statusHidden" value="${statusFilter}">

        <div style="position:relative; flex:1; min-width:200px;">
          <svg style="position:absolute;left:12px;top:50%;transform:translateY(-50%);width:15px;height:15px;color:var(--color-outline);"
               viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
          </svg>
          <input class="form-input" style="padding-left:38px;" type="text" name="player"
                 placeholder="Tìm tên người chơi..." value="${filters.player}">
        </div>

        <select name="boardSize" class="form-input form-select" style="width:150px;"
                onchange="document.getElementById('filterForm').submit()">
          <option value="">Kích thước bàn</option>
          <option value="9"  ${filters.boardSize == 9  ? 'selected' : ''}>9 × 9</option>
          <option value="13" ${filters.boardSize == 13 ? 'selected' : ''}>13 × 13</option>
          <option value="19" ${filters.boardSize == 19 ? 'selected' : ''}>19 × 19</option>
        </select>

        <select name="result" class="form-input form-select" style="width:140px;"
                onchange="document.getElementById('filterForm').submit()">
          <option value="">Kết quả</option>
          <option value="B+" ${fn:containsIgnoreCase(filters.result,'B+') ? 'selected' : ''}>⚫ Đen thắng</option>
          <option value="W+" ${fn:containsIgnoreCase(filters.result,'W+') ? 'selected' : ''}>⚪ Trắng thắng</option>
        </select>

        <input class="form-input" type="date" name="date" style="width:155px;"
               value="${filters.date}" onchange="document.getElementById('filterForm').submit()">

        <button type="submit" class="btn btn-primary btn-sm">Tìm kiếm</button>

        <a href="${pageContext.request.contextPath}/admin/games" class="btn btn-icon" title="Xóa bộ lọc">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M23 4v6h-6"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>
          </svg>
        </a>
      </form>

      <%-- ── Data Table ── --%>
      <div class="table-wrapper">
        <table class="data-table" id="gamesTable">
          <thead>
            <tr>
              <th style="width:60px;">ID</th>
              <th>Người chơi</th>
              <th style="width:90px;">Bàn cờ</th>
              <th style="width:80px;">Số nước</th>
              <th style="width:110px;">Thời gian</th>
              <th style="width:130px;">Trạng thái</th>
              <th style="width:120px;">Kết quả</th>
              <th style="width:130px;">Ngày tạo</th>
              <th style="width:90px;">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty pageData.games}">
                <c:forEach items="${pageData.games}" var="g">
                  <tr id="game-row-${g.id}">

                    <td><code style="font-size:12px;color:var(--color-on-surface-variant);">#${g.id}</code></td>

                    <td>
                      <div class="player-pair">
                        <div class="stone-icon black"></div>
                        <span style="font-size:13px;font-weight:500;">
                          ${not empty g.blackPlayer ? fn:escapeXml(g.blackPlayer.fullName) : '---'}
                        </span>
                        <span class="vs-label">VS</span>
                        <div class="stone-icon white"></div>
                        <span style="font-size:13px;font-weight:500;">
                          ${not empty g.whitePlayer ? fn:escapeXml(g.whitePlayer.fullName) : '---'}
                        </span>
                      </div>
                    </td>

                    <td><span class="board-chip">${g.boardSize}×${g.boardSize}</span></td>

                    <td style="font-weight:600;">${fn:length(g.moves)}</td>

                    <td style="font-size:12px;color:var(--color-on-surface-variant);">
                      ${not empty g.duration ? g.duration : '--'}
                    </td>

                    <td>
                      <c:choose>
                        <c:when test="${g.status eq 'IN_PROGRESS'}">
                          <span class="badge badge-success live-indicator">
                            <span class="live-dot"></span>Live
                          </span>
                        </c:when>
                        <c:when test="${g.status eq 'FINISHED'}">
                          <span class="badge badge-navy">Kết thúc</span>
                        </c:when>
                        <c:when test="${g.status eq 'WAITING'}">
                          <span class="badge badge-warning">Đang chờ</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge">${g.status}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <td>
                      <c:choose>
                        <c:when test="${fn:startsWith(g.result,'B+')}">
                          <span class="badge result-black">⚫ ${g.result}</span>
                        </c:when>
                        <c:when test="${fn:startsWith(g.result,'W+')}">
                          <span class="badge result-white">⚪ ${g.result}</span>
                        </c:when>
                        <c:when test="${not empty g.result}">
                          <span class="badge">${g.result}</span>
                        </c:when>
                        <c:otherwise>
                          <span style="color:var(--color-outline);font-size:13px;">--</span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <td style="font-size:12px;color:var(--color-on-surface-variant);white-space:nowrap;">
                      <fmt:formatDate value="${g.createdAt}" pattern="dd/MM/yyyy"/>
                      <br>
                      <span style="font-size:11px;opacity:.7;">
                        <fmt:formatDate value="${g.createdAt}" pattern="HH:mm"/>
                      </span>
                    </td>

                    <td>
                      <div class="action-btns">
                        <button class="btn-icon"
                                onclick="window.location='${pageContext.request.contextPath}/admin/games?action=detail&id=${g.id}'"
                                title="Xem chi tiết">
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                          </svg>
                        </button>
                        <button class="btn-icon danger"
                                onclick="confirmDelete(${g.id}, '${fn:escapeXml(g.blackPlayer.fullName)} vs ${not empty g.whitePlayer ? fn:escapeXml(g.whitePlayer.fullName) : '---'}')"
                                title="Xóa ván đấu"
                                ${g.status eq 'IN_PROGRESS' ? 'disabled' : ''}>
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                          </svg>
                        </button>
                      </div>
                    </td>

                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="9">
                    <div class="empty-state">
                      <div class="empty-state-icon">📂</div>
                      <div class="empty-state-title">Không tìm thấy ván đấu nào</div>
                      <div class="empty-state-sub">Thử thay đổi bộ lọc hoặc xóa điều kiện tìm kiếm</div>
                    </div>
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>

        <%-- ── Pagination ── --%>
        <c:if test="${pageData.totalPages > 1}">
          <div class="pagination">
            <c:if test="${pageData.currentPage > 1}">
              <button class="page-btn" onclick="goPage(${pageData.currentPage - 1})">←</button>
            </c:if>
            <c:forEach begin="1" end="${pageData.totalPages}" var="i">
              <c:if test="${i == 1 || i == pageData.totalPages
                         || (i >= pageData.currentPage - 2 && i <= pageData.currentPage + 2)}">
                <button class="page-btn ${pageData.currentPage == i ? 'active' : ''}"
                        onclick="goPage(${i})">${i}</button>
              </c:if>
            </c:forEach>
            <c:if test="${pageData.currentPage < pageData.totalPages}">
              <button class="page-btn" onclick="goPage(${pageData.currentPage + 1})">→</button>
            </c:if>
          </div>
        </c:if>

        <p style="text-align:center;font-size:12px;color:var(--color-on-surface-variant);padding-bottom:var(--space-md);">
          Hiển thị ${fn:length(pageData.games)} / ${pageData.totalElements} ván đấu
        </p>
      </div>

    </div><%-- /page-body --%>
  </main>
</div>

<%-- ════════ CONFIRM DELETE MODAL ════════ --%>
<div class="modal-overlay" id="deleteModal">
  <div class="modal">
    <div class="modal-icon">🗑️</div>
    <div class="modal-title">Xác nhận xóa ván đấu</div>
    <div class="modal-desc" id="modalDesc">
      Bạn có chắc muốn xóa vĩnh viễn ván đấu này?<br>
      Tất cả nước đi sẽ bị xóa và <strong>không thể khôi phục</strong>.
    </div>
    <div class="modal-footer">
      <button class="btn btn-secondary" onclick="closeModal()">Hủy</button>
      <button class="btn btn-danger" id="confirmBtn" onclick="executeDelete()">Xóa vĩnh viễn</button>
    </div>
  </div>
</div>

<%-- ════════ TOAST ════════ --%>
<div id="toast"></div>

<script>
  const ctx = '${pageContext.request.contextPath}';
  let pendingId = null;

  function goTab(status) {
    document.getElementById('statusHidden').value = status;
    document.getElementById('filterForm').submit();
  }

  function goPage(page) {
    var f = document.getElementById('filterForm');
    var inp = document.createElement('input');
    inp.type = 'hidden'; inp.name = 'page'; inp.value = page;
    f.appendChild(inp);
    f.submit();
  }

  function confirmDelete(id, label) {
    pendingId = id;
    document.getElementById('modalDesc').innerHTML =
      'Bạn có chắc muốn xóa vĩnh viễn ván đấu <strong>#' + id + '</strong>?<br>' +
      '<span style="color:var(--color-on-surface-variant);">' + label + '</span><br><br>' +
      'Tất cả nước đi sẽ bị xóa và <strong>không thể khôi phục</strong>.';
    document.getElementById('deleteModal').classList.add('show');
  }

  function closeModal() {
    document.getElementById('deleteModal').classList.remove('show');
    var btn = document.getElementById('confirmBtn');
    btn.disabled = false; btn.textContent = 'Xóa vĩnh viễn';
    pendingId = null;
  }

  document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
  });

  function executeDelete() {
    if (!pendingId) return;
    var btn = document.getElementById('confirmBtn');
    btn.disabled = true; btn.textContent = 'Đang xóa...';

    fetch(ctx + '/admin/games', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'action=delete&id=' + pendingId
    })
    .then(function(r) {
      closeModal();
      if (r.ok) {
        var row = document.getElementById('game-row-' + pendingId);
        if (row) {
          row.style.transition = 'opacity .3s, transform .3s';
          row.style.opacity = '0'; row.style.transform = 'translateX(10px)';
          setTimeout(function() { row.remove(); }, 300);
        }
        showToast('✅ Ván đấu #' + pendingId + ' đã được xóa.', 'success');
      } else {
        r.text().then(function(t) { showToast('❌ ' + t, 'error'); });
      }
      pendingId = null;
    })
    .catch(function() {
      closeModal();
      showToast('❌ Lỗi kết nối, vui lòng thử lại.', 'error');
    });
  }

  function showToast(msg, type) {
    var t = document.getElementById('toast');
    t.textContent = msg;
    t.className = 'show ' + type;
    setTimeout(function() { t.className = ''; }, 3500);
  }

  function exportCSV() {
    var table = document.getElementById('gamesTable');
    var rows  = Array.from(table.querySelectorAll('tr'));
    var csv   = rows.map(function(row) {
      return Array.from(row.querySelectorAll('th,td'))
        .map(function(c) { return '"' + c.innerText.replace(/"/g,'""').trim() + '"'; })
        .join(',');
    }).join('\n');
    var blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' });
    var a    = document.createElement('a');
    a.href   = URL.createObjectURL(blob);
    a.download = 'van-dau-' + new Date().toISOString().slice(0,10) + '.csv';
    a.click();
  }
</script>
</body>
</html>