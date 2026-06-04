<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("activeTab", "game"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Cờ Vây System - Trận Đấu</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <style>
        .material-symbols-outlined {
            font-family: 'Material Symbols Outlined';
            font-weight: normal;
            font-style: normal;
            font-size: 24px;
            line-height: 1;
            letter-spacing: normal;
            text-transform: none;
            display: inline-block;
            white-space: nowrap;
            word-wrap: normal;
            direction: ltr;
            -webkit-font-feature-settings: 'liga';
            -webkit-font-smoothing: antialiased;
        }
    </style>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "gt-primary": "#041525",
                        "gt-wood": "#e1c299",
                        "gt-wood-dark": "#8b7355",
                        "gt-stone-black": "#111111",
                        "gt-stone-white": "#fcfcfc",
                        "on-tertiary": "#ffffff",
                        "surface-bright": "#f7f9fb",
                        "secondary": "#725a39",
                        "on-primary-container": "#8191a5",
                        "tertiary-container": "#1e293a",
                        "on-primary-fixed": "#0c1d2c",
                        "primary-fixed": "#d3e4fa",
                        "surface-tint": "#506072",
                        "on-secondary-container": "#765f3d",
                        "primary-container": "#1a2a3a",
                        "on-error": "#ffffff",
                        "error": "#ba1a1a",
                        "surface-container-low": "#f2f4f6",
                        "surface-container-high": "#e6e8ea",
                        "outline-variant": "#c4c6cc",
                        "secondary-fixed": "#feddb3",
                        "primary-fixed-dim": "#b7c8dd",
                        "on-secondary": "#ffffff",
                        "surface-dim": "#d8dadc",
                        "on-tertiary-fixed-variant": "#3c475a",
                        "background": "#f7f9fb",
                        "on-secondary-fixed": "#281801",
                        "on-surface-variant": "#44474c",
                        "surface": "#f7f9fb",
                        "inverse-on-surface": "#eff1f3",
                        "surface-variant": "#e0e3e5",
                        "secondary-fixed-dim": "#e1c299",
                        "tertiary-fixed-dim": "#bcc7dd",
                        "tertiary-fixed": "#d8e3fa",
                        "on-tertiary-container": "#8590a5",
                        "on-secondary-fixed-variant": "#584324",
                        "error-container": "#ffdad6",
                        "on-error-container": "#93000a",
                        "primary": "#041525",
                        "on-primary": "#ffffff",
                        "outline": "#74777d",
                        "on-tertiary-fixed": "#111c2c",
                        "inverse-primary": "#b7c8dd",
                        "surface-container": "#eceef0",
                        "secondary-container": "#fbdbb0",
                        "surface-container-highest": "#e0e3e5",
                        "tertiary": "#091425",
                        "surface-container-lowest": "#ffffff",
                        "on-primary-fixed-variant": "#384859",
                        "inverse-surface": "#2d3133",
                        "on-surface": "#191c1e",
                        "on-background": "#191c1e"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "gutter": "24px",
                        "xxl": "80px",
                        "xs": "4px",
                        "lg": "24px",
                        "margin": "32px",
                        "unit": "4px",
                        "sm": "8px",
                        "md": "16px",
                        "xl": "48px"
                    },
                    "fontFamily": {
                        "h1-display": ["Inter"],
                        "body-main": ["Inter"],
                        "h2-title": ["Inter"],
                        "body-sm": ["Inter"],
                        "label-caps": ["Inter"],
                        "button-text": ["Inter"]
                    },
                    "fontSize": {
                        "h1-display": ["32px", {"lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "600"}],
                        "body-main": ["16px", {"lineHeight": "1.6", "letterSpacing": "0", "fontWeight": "400"}],
                        "h2-title": ["24px", {"lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "500"}],
                        "body-sm": ["14px", {"lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400"}],
                        "label-caps": ["12px", {"lineHeight": "1.0", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "button-text": ["15px", {"lineHeight": "1.0", "letterSpacing": "0.01em", "fontWeight": "500"}]
                    }
                }
            }
        }
    </script>
    <style>
        /* Cô lập CSS cho vùng Game */
        #gt-game-root .gt-goban {
            background-color: theme('colors.gt-wood');
            background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100' height='100' filter='url(%23noise)' opacity='0.08'/%3E%3C/svg%3E");
            box-shadow: inset 0 0 80px rgba(0,0,0,0.1), 0 15px 30px rgba(0,0,0,0.2);
            border-bottom: 6px solid theme('colors.gt-wood-dark');
            border-right: 6px solid theme('colors.gt-wood-dark');
        }

        #gt-game-root .gt-grid-line {
            background-color: rgba(4, 21, 37, 0.35);
            position: absolute;
        }

        #gt-game-root .gt-hoshi {
            background-color: rgba(4, 21, 37, 0.7);
            position: absolute;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            transform: translate(-50%, -50%);
        }

        /* Tránh xung đột với Sidebar chính */
        .gt-info-sidebar {
            width: 320px;
            flex-shrink: 0;
            border-left: 1px solid rgba(0,0,0,0.05);
        }

        .gt-stone {
            position: absolute;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            z-index: 10;
        }

        .gt-stone.is-dead {
            opacity: 0.3;
        }
        .gt-stone.is-dead::after {
            content: '×';
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            color: #ff0000;
            font-size: 24px;
            font-weight: bold;
        }
        /* Modal tính điểm */
        #scoring-modal { backdrop-filter: blur(8px); display: none; }
        #scoring-modal.active { display: flex; animation: fadeIn 0.3s ease; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    </style>
</head>
<body class="bg-surface font-body-main flex h-screen overflow-hidden antialiased">
<jsp:include page="/views/layout/user-sidebar.jsp" />
<div id="gt-game-root" class="flex-1 flex flex-col bg-background relative">
    <header class="h-[64px] bg-white flex justify-between items-center px-6 border-b border-outline-variant/20 z-20">
        <div class="flex items-center gap-4">
            <h2 class="text-xl font-bold text-primary">${currentGame.roomName}</h2>
            <span class="px-2 py-0.5 bg-slate-100 text-[10px] font-bold rounded uppercase">Bàn ${currentGame.boardSize}x${currentGame.boardSize}</span>
        </div>
        <button onclick="location.href='${pageContext.request.contextPath}/lobby'" class="text-slate-500 font-bold hover:text-red-500 transition-colors">THOÁT</button>
    </header>

    <main class="flex-1 flex flex-row overflow-hidden">
        <section class="flex-1 flex flex-col items-center justify-center p-8 relative">
            <div class="mb-6 px-4 py-2 bg-white rounded-full shadow-sm border flex items-center gap-3">
                <span id="gt-turn-dot" class="w-2.5 h-2.5 rounded-full bg-slate-300"></span>
                <span id="gt-turn-text" class="text-sm font-medium">Đang chờ đối thủ vào phòng...</span>
            </div>
            <div id="gt-goban-container" class="gt-goban relative aspect-square w-full max-w-[650px] max-h-full rounded-sm">
                <div id="gt-grid-layer" class="absolute inset-[5%] pointer-events-none"></div>
                <div id="gt-stones-layer" class="absolute inset-[5%] pointer-events-none"></div>
                <div id="gt-interaction-layer" class="absolute inset-[5%] cursor-not-allowed"></div>
            </div>
            <div class="w-full max-w-[650px] flex justify-between items-center mt-6">
                <div class="flex gap-3">
                    <button id="btn-resign" class="px-4 py-2 bg-white border border-red-200 text-red-600 rounded-lg text-sm">Đầu hàng</button>
                    <button id="btn-pass" class="px-4 py-2 bg-primary text-white rounded-lg text-sm">Bỏ lượt</button>
                </div>
            </div>
        </section>

        <aside class="w-[300px] bg-slate-50 flex flex-col p-6 gap-4 border-l">
            <c:set var="isBlack" value="${sessionScope.user eq currentGame.blackPlayer.username}" />
            <c:set var="opponent" value="${isBlack ? currentGame.whitePlayer : currentGame.blackPlayer}" />

            <div id="panel-opponent" class="bg-white p-4 rounded-xl border-t-4 border-slate-300 shadow-sm transition-all duration-300">
                <div class="font-bold truncate text-slate-700">${opponent != null ? opponent.fullName : 'Chờ đối thủ...'}</div>
                <div id="timer-opponent" class="text-3xl font-black text-red-500 mt-2">00:00</div>
                <div class="flex justify-between items-end mt-1">
                    <div id="periods-opponent" class="text-xs font-bold bg-red-50 text-red-600 inline-block px-2 py-1 rounded">BYO: 3</div>
                    <div class="text-xs font-medium text-slate-500">Tù binh: <span id="captures-opponent" class="font-bold text-slate-800">0</span></div>
                </div>
            </div>
            
            <div class="flex-1 bg-white p-3 rounded-xl border border-slate-200 shadow-sm flex flex-col overflow-hidden my-1">
                <div class="text-sm font-bold text-slate-700 mb-2 border-b pb-1">Lịch sử nước đi</div>
                <div id="move-history-container" class="flex-1 overflow-y-auto text-sm space-y-1 pr-1" style="max-height: 250px;">
                    <!-- Lịch sử nước đi sẽ hiển thị ở đây -->
                </div>
            </div>

            <div id="panel-me" class="mt-auto bg-white p-4 rounded-xl border-t-4 border-green-500 shadow-md transition-all duration-300">
                <div class="font-bold truncate text-slate-800">${sessionScope.displayName} (Bạn)</div>
                <div id="timer-me" class="text-3xl font-black text-green-600 mt-2">00:00</div>
                <div class="flex justify-between items-end mt-1">
                    <div id="periods-me" class="text-xs font-bold bg-green-50 text-green-700 inline-block px-2 py-1 rounded">BYO: 3</div>
                    <div class="text-xs font-medium text-slate-500">Tù binh: <span id="captures-me" class="font-bold text-slate-800">0</span></div>
                </div>
            </div>
        </aside>
    </main>

    <div id="scoring-modal" class="fixed inset-0 z-[100] items-center justify-center bg-black/40 p-4">
        <div class="bg-white rounded-2xl w-full max-w-md p-8 text-center shadow-2xl">
            <h2 class="text-2xl font-bold mb-6 text-slate-800">KẾT QUẢ VÁN ĐẤU</h2>
            <div class="flex justify-around mb-8">
                <div class="flex-1 border-r border-slate-100">
                    <p class="text-sm text-slate-500 font-bold mb-1">QUÂN ĐEN</p>
                    <p id="score-black" class="text-4xl font-black text-slate-800">0.0</p>
                </div>
                <div class="flex-1">
                    <p class="text-sm text-slate-500 font-bold mb-1">QUÂN TRẮNG</p>
                    <p id="score-white" class="text-4xl font-black text-slate-800">0.0</p>
                </div>
            </div>
            <div id="winner-banner" class="p-3 bg-slate-100 text-slate-800 rounded-lg font-bold text-lg mb-8 uppercase">--</div>
            <button onclick="location.href='${pageContext.request.contextPath}/lobby'" class="w-full py-4 bg-slate-800 text-white font-bold rounded-xl hover:bg-slate-700 transition-colors">QUAY VỀ SẢNH</button>
        </div>
    </div>
    
    <!-- Modal Thông báo chung (Custom Alert) -->
    <div id="alert-modal" class="fixed inset-0 z-[100] hidden items-center justify-center bg-black/40 p-4 transition-opacity">
        <div class="bg-white rounded-xl w-full max-w-sm p-6 text-center shadow-2xl transform transition-all">
            <h3 id="alert-title" class="text-xl font-bold text-slate-800 mb-2">Thông báo</h3>
            <p id="alert-message" class="text-slate-500 mb-6 text-sm"></p>
            <div id="alert-buttons" class="flex gap-3 justify-center">
                <button onclick="closeAlert()" class="px-6 py-2.5 bg-blue-600 text-white font-bold rounded-lg hover:bg-blue-700 transition-colors w-full">OK</button>
            </div>
        </div>
    </div>
    
    <!-- Modal Xác nhận đầu hàng -->
    <div id="resign-modal" class="fixed inset-0 z-[100] hidden items-center justify-center bg-black/40 p-4">
        <div class="bg-white rounded-xl w-full max-w-sm p-6 text-center shadow-2xl">
            <h3 class="text-xl font-bold text-slate-800 mb-2">Đầu hàng?</h3>
            <p class="text-slate-500 mb-6 text-sm">Bạn có chắc chắn muốn nhận thua ván cờ này không? Hành động này không thể hoàn tác.</p>
            <div class="flex gap-3">
                <button id="btn-cancel-resign" class="flex-1 py-2.5 bg-slate-100 text-slate-700 font-medium rounded-lg hover:bg-slate-200 transition-colors">Hủy bỏ</button>
                <button id="btn-confirm-resign" class="flex-1 py-2.5 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 transition-colors">Xác nhận</button>
            </div>
        </div>
    </div>
</div>

<script>
    let timeState = {
        blackMain: 1800000, blackPeriods: 3,
        whiteMain: 1800000, whitePeriods: 3,
        periodTime: 30000,
        blackCaptures: 0,
        whiteCaptures: 0
    };
    let currentByoYomi = { black: 30000, white: 30000 };

    let timerInterval = null;
    let currentTurn = "black";
    let isSelectingDead = false;
    let isGameStarted = false; // Cờ kiểm soát trạng thái phòng
    let moveCount = 0; // Đếm số nước đi để hiển thị lịch sử
    let hoverStone = null;

    const config = {
        id: "${currentGame.id}",
        size: ${currentGame.boardSize},
        role: ("${sessionScope.user}" === "${currentGame.blackPlayer.username}") ? "black" : "white",
        spacing: 100 / (${currentGame.boardSize} - 1)
    };

    const ws = new WebSocket("ws://" + window.location.host + "${pageContext.request.contextPath}/ws/game/" + config.id);

    ws.onmessage = (e) => {
        const data = JSON.parse(e.data);

        // Bắt sự kiện bắt đầu game khi đủ người
        if (data.type === "GAME_STARTED") {
            isGameStarted = true;
            if (data.data) {
                timeState = { ...timeState, ...data.data };
                renderTimers();
            }
            updateTurnUI();
            startClocks();
            return;
        }

        if (data.timeData) {
            timeState = { ...timeState, ...data.timeData };
            renderTimers();
        }

        if (data.nextTurn) {
            currentTurn = data.nextTurn;
            startClocks();
            updateTurnUI();
        }

        if (data.type === "SYNC_TURN") {
            currentTurn = data.nextTurn;
            updateTurnUI();
        }
        else if (data.type === "INVALID") {
            showAlert("Thông báo", data.data);
        }
        else if (data.type === "GAME_OVER") {
            showAlert("Trận đấu kết thúc", data.data, `
                <button onclick="window.location.href='${pageContext.request.contextPath}/lobby'" class="px-6 py-2.5 bg-blue-600 text-white font-bold rounded-lg hover:bg-blue-700 transition-colors w-full">Về Sảnh Chờ</button>
            `);
        }
        else if (data.type === "START_DEAD_SELECTION") {
            isSelectingDead = true;
            showAlert("Giai đoạn đếm điểm", "Hai bên đã bỏ lượt. Hãy click chọn các quân chết rồi nhấn Xác nhận điểm.");
            document.getElementById('gt-turn-text').innerText = "Giai đoạn xác nhận quân chết...";
            const btnPass = document.getElementById('btn-pass');
            btnPass.innerText = "Xác nhận điểm";
            btnPass.classList.replace('bg-primary', 'bg-green-600');
        }
        else if (data.type === "UPDATE_DEAD_STONES") {
            document.querySelectorAll('.gt-stone').forEach(s => s.classList.remove('is-dead'));
            data.data.forEach(pos => {
                const el = document.querySelector(`[data-pos="\${pos}"]`);
                if (el) {
                    el.classList.add('is-dead');
                }
            });
        }
        else if (data.type === "FINAL_SCORE") {
            const sc = data.data;
            document.getElementById('score-black').innerText = sc.black.toFixed(1);
            document.getElementById('score-white').innerText = sc.white.toFixed(1);

            const winnerText = sc.black > sc.white ? "Quân Đen Thắng" : "Quân Trắng Thắng";
            const banner = document.getElementById('winner-banner');
            banner.innerText = winnerText;
            banner.className = `p-3 rounded-lg font-bold text-lg mb-8 uppercase \${sc.black > sc.white ? 'bg-slate-800 text-white' : 'bg-slate-200 text-slate-800'}`;

            document.getElementById('scoring-modal').classList.add('active');
        }
        else if (data.type === "REMOVE") {
            data.data.forEach(stone => {
                const el = document.querySelector(`[data-pos="\${stone.x}-\${stone.y}"]`);
                if (el) {
                    el.remove();
                }
            });
        }
        else if (data.type === "PASS") {
            const passColor = currentTurn === 'black' ? 'white' : 'black'; // currentTurn was already flipped before PASS broadcast
            appendMoveHistory(-1, -1, passColor);
        }
        else if (data.type === "UNDO_SUCCESS") {
            // Khôi phục lại bàn cờ và lịch sử
            document.querySelectorAll('.gt-stone').forEach(s => s.remove());
            document.getElementById('move-history-container').innerHTML = '';
            moveCount = 0;
            
            const moves = data.data.moves;
            if (moves) {
                moves.forEach(m => {
                    addStoneToUI(m.x, m.y, m.color, moveCount + 1);
                    appendMoveHistory(m.x, m.y, m.color);
                });
            }
            
            currentTurn = data.data.nextTurn;
            updateTurnUI();
            showAlert("Hoàn tác", "Nước đi đã được hoàn tác.");
        }
        else if (data.type === "MOVE" || (data.x !== undefined && data.y !== undefined)) {
            // Xử lý nước đi được server xác nhận (hoặc lịch sử)
            addStoneToUI(data.x, data.y, data.color, moveCount + 1);
            appendMoveHistory(data.x, data.y, data.color);
            
            if (data.nextTurn) {
                currentTurn = data.nextTurn;
                updateTurnUI();
            } else if (!data.isHistory) {
                currentTurn = (data.color === 'black') ? 'white' : 'black';
                updateTurnUI();
            }
        }
    };

    function appendMoveHistory(x, y, color) {
        moveCount++;
        const container = document.getElementById('move-history-container');
        const entry = document.createElement('div');
        entry.className = "flex justify-between items-center bg-slate-50 p-1.5 rounded";
        
        const moveNumber = document.createElement('span');
        moveNumber.className = "text-slate-400 font-mono text-xs w-6";
        moveNumber.innerText = moveCount + ".";
        
        const playerBadge = document.createElement('span');
        playerBadge.className = "inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold uppercase " + (color === 'black' ? "bg-black text-white" : "bg-white text-black border border-slate-300");
        playerBadge.innerText = color === 'black' ? "Đen" : "Trắng";
        
        const coord = document.createElement('span');
        coord.className = "text-slate-700 font-medium font-mono text-xs";
        
        if (x === -1 && y === -1) {
            coord.innerText = "Bỏ lượt";
            coord.className += " italic text-slate-500";
        } else {
            // Chuyển đổi tọa độ (x, y) sang format như A1, C3...
            const letters = "ABCDEFGHJKLMNOPQRSTUVWXYZ";
            const l = letters.charAt(x);
            const n = config.size - y;
            coord.innerText = `\${l}\${n}`;
        }
        
        entry.appendChild(moveNumber);
        entry.appendChild(playerBadge);
        entry.appendChild(coord);
        
        container.appendChild(entry);
        container.scrollTop = container.scrollHeight;
    }

    function startClocks() {
        if (!isGameStarted) return;

        if (timerInterval) {
            clearInterval(timerInterval);
        }
        
        currentByoYomi.black = timeState.periodTime;
        currentByoYomi.white = timeState.periodTime;

        timerInterval = setInterval(() => {
            if (currentTurn === 'black') {
                if (timeState.blackMain > 0) {
                    timeState.blackMain -= 1000;
                    if (timeState.blackMain <= 0) {
                         currentByoYomi.black += timeState.blackMain;
                         timeState.blackMain = 0;
                    }
                } else {
                    currentByoYomi.black -= 1000;
                    if (currentByoYomi.black <= 0) {
                        timeState.blackPeriods--;
                        if (timeState.blackPeriods >= 0) {
                            currentByoYomi.black = timeState.periodTime;
                        } else {
                            currentByoYomi.black = 0;
                        }
                    }
                }
            } else {
                if (timeState.whiteMain > 0) {
                    timeState.whiteMain -= 1000;
                    if (timeState.whiteMain <= 0) {
                         currentByoYomi.white += timeState.whiteMain;
                         timeState.whiteMain = 0;
                    }
                } else {
                    currentByoYomi.white -= 1000;
                    if (currentByoYomi.white <= 0) {
                        timeState.whitePeriods--;
                        if (timeState.whitePeriods >= 0) {
                            currentByoYomi.white = timeState.periodTime;
                        } else {
                            currentByoYomi.white = 0;
                        }
                    }
                }
            }
            renderTimers();
        }, 1000);
    }

    function renderTimers() {
        const isIBlack = (config.role === 'black');

        const formatTime = (ms) => {
            if (ms < 0) ms = 0;
            let seconds = Math.floor(ms / 1000);
            let m = Math.floor(seconds / 60).toString().padStart(2, '0');
            let s = (seconds % 60).toString().padStart(2, '0');
            return `\${m}:\${s}`;
        };

        const blackDisp = timeState.blackMain > 0 ? timeState.blackMain : currentByoYomi.black;
        const whiteDisp = timeState.whiteMain > 0 ? timeState.whiteMain : currentByoYomi.white;

        document.getElementById('timer-me').innerText = formatTime(isIBlack ? blackDisp : whiteDisp);
        document.getElementById('periods-me').innerText = "BYO: " + (isIBlack ? Math.max(0, timeState.blackPeriods) : Math.max(0, timeState.whitePeriods));

        document.getElementById('timer-opponent').innerText = formatTime(isIBlack ? whiteDisp : blackDisp);
        document.getElementById('periods-opponent').innerText = "BYO: " + (isIBlack ? Math.max(0, timeState.whitePeriods) : Math.max(0, timeState.blackPeriods));
        
        document.getElementById('captures-me').innerText = isIBlack ? (timeState.blackCaptures || 0) : (timeState.whiteCaptures || 0);
        document.getElementById('captures-opponent').innerText = isIBlack ? (timeState.whiteCaptures || 0) : (timeState.blackCaptures || 0);
    }

    function addStoneToUI(x, y, color, moveNum) {
        if (document.querySelector(`[data-pos="\${x}-\${y}"]`)) {
            return false;
        }
        const layer = document.getElementById('gt-stones-layer');
        const stone = document.createElement('div');
        const sizePercentage = (config.size === 19) ? 5.2 : 7.5;

        stone.className = "gt-stone shadow-lg";
        stone.setAttribute('data-pos', `\${x}-\${y}`);
        stone.style.width = sizePercentage + "%";
        stone.style.height = sizePercentage + "%";
        stone.style.left = (x * config.spacing) + "%";
        stone.style.top = (y * config.spacing) + "%";
        stone.style.background = (color === 'black') ? "#111111" : "#ffffff";

        if (color === 'white') {
            stone.style.border = "1px solid #d1d5db";
        }

        layer.appendChild(stone);
        return true;
    }

    function updateTurnUI() {
        if (!isGameStarted) {
            document.getElementById('gt-turn-text').innerText = "Đang chờ đối thủ vào phòng...";
            document.getElementById('gt-turn-dot').className = "w-2.5 h-2.5 rounded-full bg-slate-300";
            document.getElementById('gt-interaction-layer').style.cursor = "not-allowed";
            return;
        }

        const isMyTurn = (currentTurn === config.role);
        const textElement = document.getElementById('gt-turn-text');
        const dotElement = document.getElementById('gt-turn-dot');

        textElement.innerText = isMyTurn ? `Lượt của bạn (\${config.role === 'black' ? 'Đen' : 'Trắng'}) - Nước thứ \${moveCount + 1}` : `Đang chờ đối thủ... - Nước thứ \${moveCount + 1}`;
        dotElement.className = "w-2.5 h-2.5 rounded-full " + (isMyTurn ? "bg-green-500 animate-pulse" : "bg-slate-300");
        document.getElementById('gt-interaction-layer').style.cursor = isMyTurn ? "crosshair" : "not-allowed";
        
        // Highlight panel
        const panelMe = document.getElementById('panel-me');
        const panelOpponent = document.getElementById('panel-opponent');
        
        if (isMyTurn) {
            panelMe.classList.add('ring-4', 'ring-green-300', 'shadow-lg');
            panelOpponent.classList.remove('ring-4', 'ring-slate-300', 'shadow-lg');
        } else {
            panelOpponent.classList.add('ring-4', 'ring-slate-300', 'shadow-lg');
            panelMe.classList.remove('ring-4', 'ring-green-300', 'shadow-lg');
        }
    }

    document.getElementById('gt-interaction-layer').addEventListener('click', (e) => {
        if (!isGameStarted) {
            showAlert("Chưa bắt đầu", "Vui lòng chờ đối thủ vào phòng để bắt đầu!");
            return;
        }

        if (isSelectingDead) {
            const r = e.currentTarget.getBoundingClientRect();
            const x = Math.round(((e.clientX - r.left) / r.width) * (config.size - 1));
            const y = Math.round(((e.clientY - r.top) / r.height) * (config.size - 1));
            ws.send(JSON.stringify({ type: "TOGGLE_DEAD", x: x, y: y }));
            return;
        }

        if (currentTurn !== config.role) {
            return;
        }

        const r = e.currentTarget.getBoundingClientRect();
        const x = Math.round(((e.clientX - r.left) / r.width) * (config.size - 1));
        const y = Math.round(((e.clientY - r.top) / r.height) * (config.size - 1));

        // Nếu ô đã có quân cờ thì chặn ngay tại local
        if (document.querySelector(`[data-pos="\${x}-\${y}"]`)) {
            return;
        }

        // Gửi yêu cầu lên server. KHÔNG update UI ngay lập tức để tránh out-of-sync
        // UI sẽ chỉ cập nhật khi server gửi về message type="MOVE"
        ws.send(JSON.stringify({ type: "MOVE", x: x, y: y, color: config.role }));
        if (hoverStone) hoverStone.style.display = 'none';
    });

    document.getElementById('gt-interaction-layer').addEventListener('mousemove', (e) => {
        if (!isGameStarted || currentTurn !== config.role || isSelectingDead) {
            if (hoverStone) hoverStone.style.display = 'none';
            return;
        }
        
        const r = e.currentTarget.getBoundingClientRect();
        const x = Math.round(((e.clientX - r.left) / r.width) * (config.size - 1));
        const y = Math.round(((e.clientY - r.top) / r.height) * (config.size - 1));
        
        if (x >= 0 && x < config.size && y >= 0 && y < config.size) {
            if (document.querySelector(`[data-pos="\${x}-\${y}"]`)) {
                hoverStone.style.display = 'none';
            } else {
                hoverStone.style.display = 'block';
                hoverStone.style.left = (x * config.spacing) + "%";
                hoverStone.style.top = (y * config.spacing) + "%";
                hoverStone.style.background = (config.role === 'black') ? "rgba(17, 17, 17, 0.5)" : "rgba(255, 255, 255, 0.5)";
                if (config.role === 'white') hoverStone.style.border = "1px solid rgba(209, 213, 219, 0.5)";
            }
        } else {
            hoverStone.style.display = 'none';
        }
    });

    document.getElementById('gt-interaction-layer').addEventListener('mouseleave', () => {
        if (hoverStone) hoverStone.style.display = 'none';
    });

    document.getElementById('btn-pass').addEventListener('click', () => {
        if (!isGameStarted) return;

        if (isSelectingDead) {
            ws.send(JSON.stringify({ type: "CONFIRM_SCORE" }));
            return;
        }
        if (currentTurn === config.role) {
            ws.send(JSON.stringify({ type: "PASS", color: config.role }));
            appendMoveHistory(-1, -1, config.role);
        }
    });

    document.getElementById('btn-resign').addEventListener('click', () => {
        if (!isGameStarted) return;
        
        // Hiển thị modal custom thay cho confirm()
        const modal = document.getElementById('resign-modal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    });

    document.getElementById('btn-cancel-resign').addEventListener('click', () => {
        const modal = document.getElementById('resign-modal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    });

    document.getElementById('btn-confirm-resign').addEventListener('click', () => {
        const modal = document.getElementById('resign-modal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
        
        ws.send(JSON.stringify({ type: "RESIGN", color: config.role }));
    });

    window.onload = () => {
        const gridLayer = document.getElementById('gt-grid-layer');
        for (let i = 0; i < config.size; i++) {
            const position = i * config.spacing;

            const hLine = document.createElement('div');
            hLine.className = "gt-grid-line w-full h-[1px]";
            hLine.style.top = position + "%";
            gridLayer.appendChild(hLine);

            const vLine = document.createElement('div');
            vLine.className = "gt-grid-line h-full w-[1px]";
            vLine.style.left = position + "%";
            gridLayer.appendChild(vLine);
        }
        
        // Khởi tạo hover stone
        hoverStone = document.createElement('div');
        hoverStone.id = 'gt-hover-stone';
        const sizePercentage = (config.size === 19) ? 5.2 : 7.5;
        hoverStone.style.width = sizePercentage + "%";
        hoverStone.style.height = sizePercentage + "%";
        hoverStone.style.display = 'none';
        hoverStone.style.position = 'absolute';
        hoverStone.style.borderRadius = '50%';
        hoverStone.style.transform = 'translate(-50%, -50%)';
        hoverStone.style.pointerEvents = 'none';
        hoverStone.style.zIndex = '5';
        document.getElementById('gt-interaction-layer').appendChild(hoverStone);
    };

    // Hàm hiển thị Custom Alert thay cho alert() mặc định
    function showAlert(title, message, buttonsHTML = null) {
        document.getElementById('alert-title').innerText = title || "Thông báo";
        document.getElementById('alert-message').innerText = message;
        if (buttonsHTML) {
            document.getElementById('alert-buttons').innerHTML = buttonsHTML;
        } else {
            document.getElementById('alert-buttons').innerHTML = `<button onclick="closeAlert()" class="px-6 py-2.5 bg-blue-600 text-white font-bold rounded-lg hover:bg-blue-700 transition-colors w-full">OK</button>`;
        }
        
        const modal = document.getElementById('alert-modal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }

    function closeAlert() {
        const modal = document.getElementById('alert-modal');
        modal.classList.remove('flex');
        modal.classList.add('hidden');
    }
</script>
</body>
</html>