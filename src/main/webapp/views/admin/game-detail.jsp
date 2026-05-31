<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết ván đấu - Admin Tâm Thế</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
  <!-- WGo.js for SGF Replay -->
  <script src="https://wgo.waltheri.net/wgo/wgo.min.js"></script>
  <script src="https://wgo.waltheri.net/wgo/wgo.player.min.js"></script>
  <link rel="stylesheet" href="https://wgo.waltheri.net/wgo/wgo.player.css">
  <style>
    .replay-container {
      background: var(--color-surface-container-lowest);
      padding: var(--space-xl);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-md);
      display: flex; flex-direction: column; align-items: center; gap: var(--space-lg);
    }
    #player {
      max-width: 600px; width: 100%;
    }
  </style>
</head>
<body>
<div class="layout-wrapper">
  <!-- Sidebar (Simplified) -->
  <aside class="sidebar">
     <div class="sidebar-brand">
       <div class="sidebar-logo">⬡</div>
       <div class="sidebar-brand-text">
         <div class="sidebar-brand-name">Tâm Thế</div>
         <div class="sidebar-brand-sub">Admin Panel</div>
       </div>
     </div>
     <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/games" class="nav-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
          Quay lại danh sách
        </a>
     </nav>
  </aside>

  <main class="main-content">
    <div class="topbar">
      <div>
        <div class="topbar-title">#${room.id} - ${room.roomName}</div>
        <div class="topbar-breadcrumb">Admin › Ván đấu › Chi tiết</div>
      </div>
    </div>

    <div class="page-body">
      <div class="replay-layout" style="display: flex; gap: 24px; align-items: flex-start;">
        
        <!-- Left: Replay Player -->
        <div class="replay-container" style="flex: 1;">
          <div id="player"></div>
        </div>

        <!-- Right: Information Panel -->
        <div class="info-panel" style="width: 380px; display: flex; flex-direction: column; gap: 20px;">
          
          <!-- Game Summary Card -->
          <div class="card premium-card" style="background: linear-gradient(135deg, #1a2a3a 0%, #2c3e50 100%); color: white; border: none;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
               <h3 style="margin: 0; font-size: 18px;">Tổng quan ván đấu</h3>
               <span class="badge" style="background: rgba(255,255,255,0.2); color: white; border: none;">#${room.id}</span>
            </div>
            <div style="margin-top: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
               <div class="meta-item">
                  <div style="font-size: 11px; opacity: 0.7; text-transform: uppercase;">Kết quả</div>
                  <div style="font-weight: 600; font-size: 14px;">${not empty room.result ? room.result : '---'}</div>
               </div>
               <div class="meta-item">
                  <div style="font-size: 11px; opacity: 0.7; text-transform: uppercase;">Thời gian</div>
                  <div style="font-weight: 600; font-size: 14px;">${not empty room.duration ? room.duration : '--'}</div>
               </div>
               <div class="meta-item">
                  <div style="font-size: 11px; opacity: 0.7; text-transform: uppercase;">Bàn cờ</div>
                  <div style="font-weight: 600; font-size: 14px;">${room.boardSize}x${room.boardSize}</div>
               </div>
               <div class="meta-item">
                  <div style="font-size: 11px; opacity: 0.7; text-transform: uppercase;">Trạng thái</div>
                  <div style="font-weight: 600; font-size: 14px;">${room.status}</div>
               </div>
            </div>
          </div>

          <!-- Players Comparison -->
          <div class="card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
            <div style="padding: 15px; border-bottom: 1px solid #eee; background: #f8f9fa; font-weight: 600;">Đối thủ</div>
            <div style="display: flex; position: relative;">
               <!-- Black Player -->
               <div style="flex: 1; padding: 20px; text-align: center; border-right: 1px solid #eee;">
                  <div style="width: 40px; height: 40px; background: #000; border-radius: 50%; margin: 0 auto 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"></div>
                  <div style="font-weight: 600; font-size: 14px;">${room.blackPlayer.fullName}</div>
                  <div style="font-size: 12px; color: var(--color-secondary);">${room.blackPlayer.rank}</div>
                  <div style="font-size: 11px; color: var(--color-outline); margin-top: 4px;">ELO: ${room.blackPlayer.elo}</div>
               </div>
               <!-- VS Circle -->
               <div style="position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); background: white; width: 24px; height: 24px; border-radius: 50%; border: 1px solid #eee; font-size: 9px; display: flex; align-items: center; justify-content: center; font-weight: 800; color: #999;">VS</div>
               <!-- White Player -->
               <div style="flex: 1; padding: 20px; text-align: center;">
                  <div style="width: 40px; height: 40px; background: #fff; border: 1px solid #eee; border-radius: 50%; margin: 0 auto 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.05);"></div>
                  <div style="font-weight: 600; font-size: 14px;">${not empty room.whitePlayer ? room.whitePlayer.fullName : '---'}</div>
                  <div style="font-size: 12px; color: var(--color-secondary);">${not empty room.whitePlayer ? room.whitePlayer.rank : '---'}</div>
                  <div style="font-size: 11px; color: var(--color-outline); margin-top: 4px;">ELO: ${not empty room.whitePlayer ? room.whitePlayer.elo : '---'}</div>
               </div>
            </div>
          </div>

          <!-- Move History -->
          <div class="card" style="padding: 0; flex: 1; display: flex; flex-direction: column; min-height: 250px;">
             <div style="padding: 15px; border-bottom: 1px solid #eee; background: #f8f9fa; font-weight: 600; display: flex; justify-content: space-between;">
                <span>Lịch sử nước đi</span>
                <span style="font-size: 12px; color: var(--color-on-surface-variant); font-weight: normal;">${fn:length(room.moves)} nước</span>
             </div>
             <div style="padding: 0; overflow-y: auto; max-height: 300px;">
                <table style="width: 100%; border-collapse: collapse; font-size: 13px;">
                   <thead style="position: sticky; top: 0; background: #fff; z-index: 1;">
                      <tr style="border-bottom: 1px solid #eee; text-align: left;">
                         <th style="padding: 10px 15px; font-weight: normal; color: #999;">#</th>
                         <th style="padding: 10px 15px; font-weight: normal; color: #999;">Màu</th>
                         <th style="padding: 10px 15px; font-weight: normal; color: #999;">Tọa độ</th>
                      </tr>
                   </thead>
                   <tbody>
                      <c:forEach items="${room.moves}" var="m" varStatus="vs">
                         <tr style="border-bottom: 1px dotted #eee;">
                            <td style="padding: 8px 15px;">${vs.count}</td>
                            <td style="padding: 8px 15px;">
                               <span style="display: flex; align-items: center; gap: 6px;">
                                  <div style="width: 8px; height: 8px; border-radius: 50%; background: ${m.color eq 'black' ? '#000' : '#fff'}; border: ${m.color eq 'black' ? 'none' : '1px solid #ccc'}"></div>
                                  ${m.color eq 'black' ? 'Đen' : 'Trắng'}
                               </span>
                            </td>
                            <td style="padding: 8px 15px; font-family: monospace; font-weight: 600;">
                               (${m.x}, ${m.y})
                            </td>
                         </tr>
                      </c:forEach>
                   </tbody>
                </table>
             </div>
          </div>

        </div>

      </div>
    </div>
  </main>
</div>

<script>
  var player = new WGo.BasicPlayer(document.getElementById("player"), {
    sgf: `${sgfData}`,
    move: 0,
    board: {
      background: "${pageContext.request.contextPath}/assets/board_bg.png"
    }
  });
</script>
</body>
</html>
