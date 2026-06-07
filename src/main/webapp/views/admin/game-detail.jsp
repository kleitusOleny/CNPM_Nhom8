<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết #${room.id} - ${room.roomName} - Admin Tâm Thế</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <script src="https://wgo.waltheri.net/wgo/wgo.min.js"></script>
    <script src="https://wgo.waltheri.net/wgo/wgo.player.min.js"></script>
    <link  rel="stylesheet" href="https://wgo.waltheri.net/wgo/wgo.player.css">
    <style>
        .detail-layout {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: var(--space-lg);
            align-items: flex-start;
        }
        @media (max-width: 1024px) { .detail-layout { grid-template-columns: 1fr; } }

        .replay-card {
            background: var(--color-surface-container-lowest);
            border-radius: var(--radius-lg);
            border: 1px solid var(--color-outline-variant);
            box-shadow: var(--shadow-md);
            padding: var(--space-xl);
            display: flex; flex-direction: column; align-items: center; gap: var(--space-lg);
        }
        #wgo-player { max-width: 560px; width: 100%; }

        .info-panel { display: flex; flex-direction: column; gap: var(--space-md); }

        .summary-card {
            background: linear-gradient(135deg, #1a2a3a 0%, #2c3e50 100%);
            color: white; border: none; border-radius: var(--radius-lg); padding: var(--space-lg);
        }
        .summary-card .card-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: var(--space-md);
        }
        .summary-card h3 { margin: 0; font-size: 16px; font-weight: 600; }
        .summary-grid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md); }
        .summary-item .label {
            font-size: 11px; opacity: .65; text-transform: uppercase;
            letter-spacing: .05em; margin-bottom: 3px;
        }
        .summary-item .value { font-weight: 600; font-size: 14px; }

        .status-badge-inline {
            display: inline-block; padding: 2px 10px; border-radius: 999px;
            font-size: 12px; font-weight: 600;
        }
        .status-in-progress { background: rgba(40,167,69,.25); color: #7fffaa; }
        .status-finished    { background: rgba(255,255,255,.15); color: #fff; }
        .status-waiting     { background: rgba(255,200,0,.2); color: #ffe066; }

        .players-card {
            background: var(--color-surface-container-lowest);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-lg); overflow: hidden;
        }
        .players-card-header {
            padding: 12px 16px;
            background: var(--color-surface-container-low);
            border-bottom: 1px solid var(--color-outline-variant);
            font-weight: 600; font-size: 14px;
        }
        .players-grid { display: flex; position: relative; }
        .player-col { flex: 1; padding: 20px; text-align: center; }
        .player-col:first-child { border-right: 1px solid var(--color-outline-variant); }
        .player-stone { width: 40px; height: 40px; border-radius: 50%; margin: 0 auto 10px; }
        .player-stone.black { background: radial-gradient(circle at 35% 35%, #555, #111); box-shadow: 0 4px 8px rgba(0,0,0,.3); }
        .player-stone.white { background: radial-gradient(circle at 35% 35%, #fff, #e0e0e0); border: 1px solid rgba(0,0,0,.1); box-shadow: 0 4px 8px rgba(0,0,0,.08); }
        .player-name { font-weight: 600; font-size: 14px; margin-bottom: 4px; }
        .player-rank { font-size: 12px; color: var(--color-secondary); }
        .player-elo  { font-size: 11px; color: var(--color-outline); margin-top: 4px; }
        .vs-circle {
            position: absolute; left: 50%; top: 50%; transform: translate(-50%,-50%);
            background: white; width: 26px; height: 26px; border-radius: 50%;
            border: 1px solid var(--color-outline-variant);
            font-size: 9px; display: flex; align-items: center; justify-content: center;
            font-weight: 800; color: var(--color-outline);
        }

        .moves-card {
            background: var(--color-surface-container-lowest);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-lg); overflow: hidden;
            display: flex; flex-direction: column;
        }
        .moves-card-header {
            padding: 12px 16px;
            background: var(--color-surface-container-low);
            border-bottom: 1px solid var(--color-outline-variant);
            font-weight: 600; font-size: 14px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .moves-table-wrap { overflow-y: auto; max-height: 320px; }
        .moves-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .moves-table thead th {
            position: sticky; top: 0; background: white; z-index: 1;
            padding: 9px 14px; font-weight: 500; color: var(--color-outline);
            text-align: left; border-bottom: 1px solid var(--color-outline-variant);
        }
        .moves-table tbody tr { border-bottom: 1px dotted var(--color-surface-container); }
        .moves-table tbody tr:hover { background: var(--color-surface-container-low); }
        .moves-table tbody td { padding: 7px 14px; }
        .move-color-dot { display: inline-flex; align-items: center; gap: 6px; }
        .dot { width: 9px; height: 9px; border-radius: 50%; flex-shrink: 0; }
        .dot.black { background: #111; }
        .dot.white { background: #eee; border: 1px solid #ccc; }

        .live-dot { width: 7px; height: 7px; border-radius: 50%; background: #28a745;
                    display: inline-block; animation: blink 1.5s infinite; }
        @keyframes blink { 0%,100%{opacity:1;} 50%{opacity:.3;} }

        .no-moves { padding: 32px; text-align: center; color: var(--color-on-surface-variant); font-size: 13px; }
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
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    Chi tiết ván đấu
                    <c:if test="${room.status eq 'IN_PROGRESS'}">
                        <span class="badge" style="background:rgba(40,167,69,.15);color:#155724;margin-left:8px;vertical-align:middle;">
                            <span class="live-dot"></span> Live
                        </span>
                    </c:if>
                </div>
                <div class="topbar-breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/games"
                       style="color:var(--color-on-surface-variant);text-decoration:none;">Admin › Ván đấu</a>
                    › #${room.id}
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/admin/games" class="btn btn-secondary btn-sm">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="15 18 9 12 15 6"/>
                </svg>
                Quay lại danh sách
            </a>
        </div>

        <div class="page-body">
            <div class="detail-layout">

                <%-- Cột trái: Replay --%>
                <div class="replay-card">
                    <h3 style="margin:0;font-size:16px;font-weight:600;align-self:flex-start;">
                        🎮 Phát lại ván đấu
                    </h3>
                    <c:choose>
                        <c:when test="${not empty sgfData and sgfData ne '(;)'}">
                            <div id="wgo-player"></div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding:40px;text-align:center;color:var(--color-on-surface-variant);">
                                <div style="font-size:48px;margin-bottom:12px;">🎲</div>
                                <div style="font-size:15px;font-weight:600;">Chưa có nước đi nào được ghi nhận</div>
                                <div style="font-size:13px;margin-top:6px;">Ván đấu chưa bắt đầu hoặc dữ liệu chưa sẵn sàng.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Cột phải: Thông tin --%>
                <div class="info-panel">

                    <div class="summary-card">
                        <div class="card-header">
                            <h3>Tổng quan ván đấu</h3>
                            <span class="badge" style="background:rgba(255,255,255,.15);color:white;border:none;">#${room.id}</span>
                        </div>
                        <div class="summary-grid">
                            <div class="summary-item">
                                <div class="label">Phòng</div>
                                <div class="value">${fn:escapeXml(room.roomName)}</div>
                            </div>
                            <div class="summary-item">
                                <div class="label">Trạng thái</div>
                                <div class="value">
                                    <c:choose>
                                        <c:when test="${room.status eq 'IN_PROGRESS'}">
                                            <span class="status-badge-inline status-in-progress">🟢 Live</span>
                                        </c:when>
                                        <c:when test="${room.status eq 'FINISHED'}">
                                            <span class="status-badge-inline status-finished">✅ Kết thúc</span>
                                        </c:when>
                                        <c:when test="${room.status eq 'WAITING'}">
                                            <span class="status-badge-inline status-waiting">⏳ Chờ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge-inline status-finished">${room.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="summary-item">
                                <div class="label">Kết quả</div>
                                <div class="value">${not empty room.result ? room.result : '---'}</div>
                            </div>
                            <div class="summary-item">
                                <div class="label">Bàn cờ</div>
                                <div class="value">${room.boardSize}×${room.boardSize}</div>
                            </div>
                            <div class="summary-item">
                                <div class="label">Thời gian kiểm soát</div>
                                <div class="value">${not empty room.timeControl ? room.timeControl : '---'}</div>
                            </div>
                            <div class="summary-item">
                                <div class="label">Tổng số nước</div>
                                <div class="value">${fn:length(room.moves)}</div>
                            </div>
                            <div class="summary-item" style="grid-column:1/-1;">
                                <div class="label">Ngày tạo</div>
                                <div class="value">
                                    <fmt:formatDate value="${room.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="players-card">
                        <div class="players-card-header">Đối thủ</div>
                        <div class="players-grid">
                            <div class="player-col">
                                <div class="player-stone black"></div>
                                <div class="player-name">${not empty room.blackPlayer ? fn:escapeXml(room.blackPlayer.fullName) : '---'}</div>
                                <div class="player-rank">${not empty room.blackPlayer ? room.blackPlayer.rank : '---'}</div>
                                <div class="player-elo">ELO: ${not empty room.blackPlayer ? room.blackPlayer.elo : '---'}</div>
                            </div>
                            <div class="vs-circle">VS</div>
                            <div class="player-col">
                                <div class="player-stone white"></div>
                                <div class="player-name">${not empty room.whitePlayer ? fn:escapeXml(room.whitePlayer.fullName) : 'Chờ người chơi'}</div>
                                <div class="player-rank">${not empty room.whitePlayer ? room.whitePlayer.rank : '---'}</div>
                                <div class="player-elo">ELO: ${not empty room.whitePlayer ? room.whitePlayer.elo : '---'}</div>
                            </div>
                        </div>
                    </div>

                    <div class="moves-card">
                        <div class="moves-card-header">
                            <span>Lịch sử nước đi</span>
                            <span style="font-size:12px;font-weight:normal;color:var(--color-on-surface-variant);">
                                ${fn:length(room.moves)} nước
                            </span>
                        </div>
                        <div class="moves-table-wrap">
                            <c:choose>
                                <c:when test="${not empty room.moves}">
                                    <table class="moves-table">
                                        <thead>
                                            <tr><th>#</th><th>Màu</th><th>Tọa độ</th></tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${room.moves}" var="m" varStatus="vs">
                                            <tr>
                                                <td style="color:var(--color-outline);font-size:12px;">${vs.count}</td>
                                                <td>
                                                    <span class="move-color-dot">
                                                        <span class="dot ${m.color}"></span>
                                                        ${m.color eq 'black' ? 'Đen' : 'Trắng'}
                                                    </span>
                                                </td>
                                                <td style="font-family:monospace;font-weight:600;">(${m.x}, ${m.y})</td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-moves">Chưa có nước đi nào.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div><%-- /info-panel --%>
            </div><%-- /detail-layout --%>
        </div><%-- /page-body --%>
    </main>
</div>

<c:if test="${not empty sgfData and sgfData ne '(;)'}">
<script>
    var sgfRaw = `${fn:replace(fn:replace(sgfData, '\\', '\\\\'), '`', '\\`')}`;
    var player = new WGo.BasicPlayer(document.getElementById("wgo-player"), {
        sgf: sgfRaw, move: 0,
        board: { background: "transparent" },
        enableKeys: true, enableWheel: true
    });
</script>
</c:if>
</body>
</html>