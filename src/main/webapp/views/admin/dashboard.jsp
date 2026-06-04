<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard - Tâm Thế</title>
  <meta name="description" content="Bảng điều khiển quản trị hệ thống cờ vây Tâm Thế">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
  <style>
    .chart-bar {
      display: flex; align-items: flex-end; gap: 6px; height: 100px;
    }
    .bar-group {
      flex: 1; display: flex; align-items: flex-end; gap: 3px;
    }
    .bar {
      flex: 1;
      border-radius: 3px 3px 0 0;
      transition: opacity var(--transition-fast);
      min-width: 6px;
    }
    .bar:hover { opacity: 0.75; }
    .bar-black { background: var(--color-primary-container); }
    .bar-white { background: var(--color-wood); }
    .recent-game-item {
      display: flex; align-items: center; gap: var(--space-md);
      padding: var(--space-sm) 0;
      border-bottom: 1px solid var(--color-surface-container);
    }
    .recent-game-item:last-child { border-bottom: none; }
    .game-stones {
      display: flex; gap: 4px;
    }
    .mini-stone {
      width: 20px; height: 20px; border-radius: 50%;
    }
    .mini-stone.black { background: radial-gradient(circle at 35% 35%, #555, #111); box-shadow: 0 1px 3px rgba(0,0,0,0.4); }
    .mini-stone.white { background: radial-gradient(circle at 35% 35%, #fff, #ddd); border: 1px solid rgba(0,0,0,0.15); box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
    .game-info { flex: 1; }
    .game-players { font-size: var(--font-size-body-sm); font-weight: 500; color: var(--color-on-surface); }
    .game-meta { font-size: 12px; color: var(--color-on-surface-variant); margin-top: 1px; }
    .game-result { text-align: right; }
    .win-badge {
      font-size: 12px; font-weight: 600; padding: 2px 8px; border-radius: var(--radius-full);
    }
    .win-badge.black-win { background: rgba(26,42,58,0.1); color: var(--color-primary-container); }
    .win-badge.white-win { background: rgba(210,180,140,0.2); color: var(--color-secondary); }
    .activity-dot {
      width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0;
    }
    .activity-item {
      display: flex; align-items: flex-start; gap: var(--space-sm);
      padding: var(--space-sm) 0;
      border-bottom: 1px solid var(--color-surface-container);
    }
    .activity-item:last-child { border-bottom: none; }
    .grid-cols-2 { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-lg); }
    .grid-cols-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: var(--space-lg); }
  </style>
</head>
<body>
<div class="layout-wrapper">
  <!-- Sidebar -->
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
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active">
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
        <a href="${pageContext.request.contextPath}/admin/games" class="nav-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="3" y1="15" x2="21" y2="15"/><line x1="9" y1="3" x2="9" y2="21"/><line x1="15" y1="3" x2="15" y2="21"/></svg>
          Ván đấu
        </a>
      </div>
      <div class="nav-section">
        <div class="nav-section-label">Cài đặt</div>
        <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93l-1.41 1.41M4.93 4.93l1.41 1.41M12 2v2M12 20v2M20 12h2M2 12h2M17.66 17.66l-1.41-1.41M6.34 17.66l1.41-1.41"/></svg>
          Cài đặt
        </a>
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
          <div class="sidebar-username">Admin</div>
          <div class="sidebar-role">Quản trị viên</div>
        </div>
      </div>
    </div>
  </aside>

  <!-- Main -->
  <main class="main-content">
    <div class="topbar">
      <div>
        <div class="topbar-title">Admin Dashboard</div>
        <div class="topbar-breadcrumb">Tổng quan hệ thống</div>
      </div>
      <div class="flex gap-md">
        <button class="btn btn-secondary btn-sm">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
          Xuất báo cáo
        </button>
      </div>
    </div>

    <div class="page-body">
      <!-- Stat Cards -->
      <div class="stat-grid" style="grid-template-columns: repeat(4, 1fr);">
        <div class="stat-card">
          <div class="stat-icon">👥</div>
          <div class="stat-value">${totalUsers != null ? totalUsers : '1,248'}</div>
          <div class="stat-label">Tổng người dùng</div>
          <div class="stat-change up">↑ +12 tuần này</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">♟</div>
          <div class="stat-value">${totalGames != null ? totalGames : '5,832'}</div>
          <div class="stat-label">Tổng ván đấu</div>
          <div class="stat-change up">↑ +87 hôm nay</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">🟢</div>
          <div class="stat-value">${activeGames != null ? activeGames : '23'}</div>
          <div class="stat-label">Đang diễn ra</div>
          <div class="stat-change" style="color:var(--color-on-surface-variant);">Thời gian thực</div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">⏱</div>
          <div class="stat-value">47'</div>
          <div class="stat-label">Thời gian TB/ván</div>
          <div class="stat-change down">↓ -3 phút</div>
        </div>
      </div>

      <!-- Charts & Recent -->
      <div class="grid-cols-2 mb-lg">
        <!-- Chart -->
        <div class="card">
          <div class="flex-between mb-md">
            <div>
              <div class="card-title">Thống kê ván đấu</div>
              <div class="card-subtitle">7 ngày gần nhất</div>
            </div>
            <div class="flex gap-sm" style="align-items:center;font-size:12px;">
              <span style="display:flex;align-items:center;gap:4px;">
                <span style="width:10px;height:10px;background:var(--color-primary-container);border-radius:2px;display:inline-block;"></span>Quân đen
              </span>
              <span style="display:flex;align-items:center;gap:4px;">
                <span style="width:10px;height:10px;background:var(--color-wood);border-radius:2px;display:inline-block;"></span>Quân trắng
              </span>
            </div>
          </div>
          <div class="chart-bar">
            <div class="bar-group"><div class="bar bar-black" style="height:55px;"></div><div class="bar bar-white" style="height:40px;"></div></div>
            <div class="bar-group"><div class="bar bar-black" style="height:70px;"></div><div class="bar bar-white" style="height:60px;"></div></div>
            <div class="bar-group"><div class="bar bar-black" style="height:45px;"></div><div class="bar bar-white" style="height:50px;"></div></div>
            <div class="bar-group"><div class="bar bar-black" style="height:80px;"></div><div class="bar bar-white" style="height:75px;"></div></div>
            <div class="bar-group"><div class="bar bar-black" style="height:60px;"></div><div class="bar bar-white" style="height:55px;"></div></div>
            <div class="bar-group"><div class="bar bar-black" style="height:90px;"></div><div class="bar bar-white" style="height:80px;"></div></div>
            <div class="bar-group"><div class="bar bar-black" style="height:65px;"></div><div class="bar bar-white" style="height:70px;"></div></div>
          </div>
          <div style="display:flex;justify-content:space-between;margin-top:8px;">
            <c:forEach items="${chartDays != null ? chartDays : 'T2,T3,T4,T5,T6,T7,CN'.split(',') }" var="d">
              <span style="font-size:11px;color:var(--color-on-surface-variant);flex:1;text-align:center;">${d}</span>
            </c:forEach>
          </div>
        </div>

        <!-- Recent Games -->
        <div class="card">
          <div class="flex-between mb-md">
            <div class="card-title">Ván đấu gần đây</div>
            <a href="${pageContext.request.contextPath}/admin/games" class="btn btn-secondary btn-sm">Xem tất cả</a>
          </div>
          <div>
            <div class="recent-game-item">
              <div class="game-stones"><div class="mini-stone black"></div><div class="mini-stone white"></div></div>
              <div class="game-info">
                <div class="game-players">NguyenVanA vs TranThiB</div>
                <div class="game-meta">19×19 · 120 nước · 52 phút</div>
              </div>
              <div class="game-result"><span class="win-badge black-win">Đen thắng</span></div>
            </div>
            <div class="recent-game-item">
              <div class="game-stones"><div class="mini-stone black"></div><div class="mini-stone white"></div></div>
              <div class="game-info">
                <div class="game-players">LeVanC vs PhamThiD</div>
                <div class="game-meta">19×19 · 94 nước · 38 phút</div>
              </div>
              <div class="game-result"><span class="win-badge white-win">Trắng thắng</span></div>
            </div>
            <div class="recent-game-item">
              <div class="game-stones"><div class="mini-stone black"></div><div class="mini-stone white"></div></div>
              <div class="game-info">
                <div class="game-players">HoangVanE vs NguyenThiF</div>
                <div class="game-meta">9×9 · 61 nước · 22 phút</div>
              </div>
              <div class="game-result"><span class="win-badge black-win">Đen thắng</span></div>
            </div>
            <div class="recent-game-item">
              <div class="game-stones"><div class="mini-stone black"></div><div class="mini-stone white"></div></div>
              <div class="game-info">
                <div class="game-players">BuiVanG vs VoThiH</div>
                <div class="game-meta">13×13 · 77 nước · 31 phút</div>
              </div>
              <div class="game-result"><span class="win-badge white-win">Trắng thắng</span></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Activity Log -->
      <div class="card">
        <div class="flex-between mb-md">
          <div class="card-title">Hoạt động hệ thống</div>
          <span class="badge badge-navy">Hôm nay</span>
        </div>
        <div>
          <div class="activity-item">
            <div class="activity-dot" style="background:#155724;margin-top:5px;"></div>
            <div style="flex:1;">
              <div style="font-size:14px;font-weight:500;">Người dùng mới đăng ký</div>
              <div style="font-size:12px;color:var(--color-on-surface-variant);">NguyenVanZ - 08:32 sáng</div>
            </div>
          </div>
          <div class="activity-item">
            <div class="activity-dot" style="background:var(--color-wood);margin-top:5px;"></div>
            <div style="flex:1;">
              <div style="font-size:14px;font-weight:500;">Ván đấu mới bắt đầu</div>
              <div style="font-size:12px;color:var(--color-on-surface-variant);">NguyenVanA vs TranThiB - 09:15 sáng</div>
            </div>
          </div>
          <div class="activity-item">
            <div class="activity-dot" style="background:var(--color-primary-container);margin-top:5px;"></div>
            <div style="flex:1;">
              <div style="font-size:14px;font-weight:500;">Ván đấu kết thúc</div>
              <div style="font-size:12px;color:var(--color-on-surface-variant);">LeVanC vs PhamThiD - Đen thắng - 10:01 sáng</div>
            </div>
          </div>
          <div class="activity-item">
            <div class="activity-dot" style="background:var(--color-error);margin-top:5px;"></div>
            <div style="flex:1;">
              <div style="font-size:14px;font-weight:500;">Người dùng bị khóa</div>
              <div style="font-size:12px;color:var(--color-on-surface-variant);">SpamUser123 - Vi phạm quy định - 10:47 sáng</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>
