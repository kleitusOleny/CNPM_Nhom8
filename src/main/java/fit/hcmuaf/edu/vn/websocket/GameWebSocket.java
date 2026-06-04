package fit.hcmuaf.edu.vn.websocket;

import com.google.gson.Gson;
import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.model.GameMove;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.util.GoLogic;
import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@ServerEndpoint("/ws/game/{roomId}")
public class GameWebSocket {
    private static Map<Long, Integer> consecutivePasses = new ConcurrentHashMap<>();
    private static Map<Long, Set<Session>> roomSessions = new ConcurrentHashMap<>();
    private static Map<Long, Set<String>> deadStonesMap = new ConcurrentHashMap<>();
    private static Map<Long, Set<String>> confirmationMap = new ConcurrentHashMap<>();
    private static Map<Long, RoomTimer> gameTimers = new ConcurrentHashMap<>();
    // Lưu trữ lịch sử tất cả các trạng thái bàn cờ để xử lý luật Kiếp nâng cao (Superko)
    private static Map<Long, Stack<String>> boardHistoryMap = new ConcurrentHashMap<>();
    // Lưu trữ danh sách các người chơi đã chấp nhận đề nghị hòa trong một phòng
    private static Map<Long, Set<String>> drawProposalMap = new ConcurrentHashMap<>();
    // Lưu trữ các trạng thái bàn cờ để hỗ trợ tính năng Hồi nước đi (Undo)
    private static Map<Long, Stack<List<GameMove>>> moveHistoryMap = new ConcurrentHashMap<>();
    private static Map<Long, Set<String>> undoProposalMap = new ConcurrentHashMap<>();
    private final Gson gson = new Gson();
    
    // Luồng chạy ngầm để kiểm tra hết giờ (mỗi 1 giây)
    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    static {
        scheduler.scheduleAtFixedRate(() -> {
            long now = System.currentTimeMillis();
            for (Map.Entry<Long, RoomTimer> entry : gameTimers.entrySet()) {
                Long roomId = entry.getKey();
                RoomTimer timer = entry.getValue();
                
                if (timer.isGameStarted) {
                    long elapsed = now - timer.lastTurnStartTime;
                    PlayerTimer currentPlayerTimer = timer.currentTurn.equals("black") ? timer.black : timer.white;
                    
                    long tempMain = currentPlayerTimer.mainTimeMillis;
                    int tempPeriods = currentPlayerTimer.periods;
                    
                    if (tempMain > 0) {
                        tempMain -= elapsed;
                        if (tempMain < 0) {
                            elapsed = -tempMain;
                            tempMain = 0;
                        } else {
                            elapsed = 0;
                        }
                    }
                    
                    if (elapsed > 0 && tempPeriods >= 0) {
                        if (elapsed > currentPlayerTimer.periodTimeMillis) {
                            tempPeriods -= (int) (elapsed / currentPlayerTimer.periodTimeMillis);
                        }
                    }
                    
                    if (tempPeriods < 0) {
                        handleTimeout(roomId, timer);
                    }
                }
            }
        }, 1, 1, TimeUnit.SECONDS);
    }
    
    private static void handleTimeout(Long roomId, RoomTimer timer) {
        // Tránh gọi nhiều lần nếu luồng ngầm và user cùng lúc tác động
        if (gameTimers.remove(roomId) == null) return;
        
        String res = timer.currentTurn.equals("black") ? "Trắng thắng (Đen hết giờ)" : "Đen thắng (Trắng hết giờ)";
        RoomDAO dao = new RoomDAO();
        dao.finishGame(roomId, res);
        
        GameResponse response = new GameResponse("GAME_OVER", res);
        String message = new Gson().toJson(response);
        
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions != null) {
            for (Session s : sessions) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        
        boardHistoryMap.remove(roomId);
        consecutivePasses.remove(roomId);
        deadStonesMap.remove(roomId);
        confirmationMap.remove(roomId);
        // Xóa thông tin đề xuất hòa và hoàn tác
        drawProposalMap.remove(roomId);
        moveHistoryMap.remove(roomId);
        undoProposalMap.remove(roomId);
    }
    
    public static class StoneCoords {
        public int x, y;
        public StoneCoords(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }
    
    public static class GameResponse {
        String type;
        Object data;
        String nextTurn;
        
        public GameResponse(String type, Object data) {
            this.type = type;
            this.data = data;
        }
        
        public GameResponse(String type, Object data, String nextTurn) {
            this.type = type;
            this.data = data;
            this.nextTurn = nextTurn;
        }
    }
    
    public static class PlayerTimer {
        public long mainTimeMillis;
        public int periods;
        public long periodTimeMillis;
        
        public PlayerTimer(int mainMin, int p, int pSec) {
            this.mainTimeMillis = mainMin * 60 * 1000L;
            this.periods = p;
            this.periodTimeMillis = pSec * 1000L;
        }
    }
    
    public static class RoomTimer {
        public PlayerTimer black;
        public PlayerTimer white;
        public long lastTurnStartTime;
        public String currentTurn;
        public boolean isGameStarted; // Thêm trạng thái bắt đầu game
        public int blackCaptures = 0; // Đen ăn được bao nhiêu quân trắng
        public int whiteCaptures = 0; // Trắng ăn được bao nhiêu quân đen
        
        public RoomTimer(String timeControl) {
            try {
                String[] parts = timeControl.split("\\+");
                int mainMin = Integer.parseInt(parts[0].trim().replace("m", ""));
                String[] byo = parts[1].trim().split("x");
                int p = Integer.parseInt(byo[0]);
                int pSec = Integer.parseInt(byo[1].replace("s", ""));
                
                this.black = new PlayerTimer(mainMin, p, pSec);
                this.white = new PlayerTimer(mainMin, p, pSec);
                this.lastTurnStartTime = System.currentTimeMillis();
                this.currentTurn = "black";
                this.isGameStarted = false;
            } catch (Exception e) {
                this.black = new PlayerTimer(30, 3, 30);
                this.white = new PlayerTimer(30, 3, 30);
                this.lastTurnStartTime = System.currentTimeMillis();
                this.currentTurn = "black";
                this.isGameStarted = false;
            }
        }
    }
    
    private Map<String, Object> getTimeData(RoomTimer timer) {
        Map<String, Object> timeData = new HashMap<>();
        timeData.put("blackMain", timer.black.mainTimeMillis);
        timeData.put("blackPeriods", timer.black.periods);
        timeData.put("whiteMain", timer.white.mainTimeMillis);
        timeData.put("whitePeriods", timer.white.periods);
        timeData.put("periodTime", timer.black.periodTimeMillis);
        timeData.put("blackCaptures", timer.blackCaptures);
        timeData.put("whiteCaptures", timer.whiteCaptures);
        return timeData;
    }
    
    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") Long roomId) {
        // [Bước 6.2] Kết nối WebSocket (@OnOpen)
        Set<Session> sessions = roomSessions.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>()));
        sessions.add(session);
        
        RoomDAO dao = new RoomDAO();
        // [Bước 6.3] findById(roomId)
        // [Bước 6.4, 6.5] Query Room & Moves dưới DB và trả về
        // [Bước 6.6] Trả về GameRoom
        GameRoom room = dao.findById(roomId);
        
        if (room != null) {
            RoomTimer timer = gameTimers.computeIfAbsent(roomId, k -> new RoomTimer(room.getTimeControl()));
            List<GameMove> moves = room.getMoves();
            
            // Nếu bàn cờ đã có nước đi, nghĩa là game đã bắt đầu từ trước (trường hợp F5)
            if (moves != null && !moves.isEmpty()) {
                timer.isGameStarted = true;
                for (GameMove m : moves) {
                    Map<String, Object> historyMove = new HashMap<>();
                    historyMove.put("x", m.getX());
                    historyMove.put("y", m.getY());
                    historyMove.put("color", m.getColor());
                    historyMove.put("isHistory", true);
                    try { session.getBasicRemote().sendText(gson.toJson(historyMove)); } catch (IOException e) { e.printStackTrace(); }
                }
            }
            
            // [Bước 6.7] Kiểm tra số lượng Session (>= 2)
            if (sessions.size() >= 2 && !timer.isGameStarted) {
                timer.isGameStarted = true;
                timer.lastTurnStartTime = System.currentTimeMillis();
                // [Bước 6.8] Broadcast "GAME_STARTED" (kèm Timer)
                broadcast(roomId, gson.toJson(new GameResponse("GAME_STARTED", getTimeData(timer))), null);
            } else if (timer.isGameStarted) {
                // Gửi trạng thái GAME_STARTED cho người vừa reconnect
                try { session.getBasicRemote().sendText(gson.toJson(new GameResponse("GAME_STARTED", getTimeData(timer)))); } catch (IOException e) { e.printStackTrace(); }
            }
            
            if (moves != null) {
                String startTurn;
                int handicap = room.getHandicap();
                // [Handicap] Quân đen được đi liên tục các nước đầu tiên bằng đúng số quân chấp
                if (handicap > 0 && moves.size() < handicap) {
                    startTurn = "black";
                } else if (handicap > 0) {
                    startTurn = ((moves.size() - handicap) % 2 == 0) ? "white" : "black";
                } else {
                    startTurn = (moves.size() % 2 == 0) ? "black" : "white";
                }
                timer.currentTurn = startTurn;
                try { session.getBasicRemote().sendText(gson.toJson(new GameResponse("SYNC_TURN", null, startTurn))); } catch (IOException e) { e.printStackTrace(); }
            }
        }
    }
    
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("roomId") Long roomId) {
        try {
            // [Bước 6.10], [Bước 6.30], [Bước 6.35]: Nhận các message từ Browser (Client)
            Map<String, Object> data = gson.fromJson(message, Map.class);
            String type = (String) data.get("type");
            RoomDAO dao = new RoomDAO();
            // [Bước 6.12, 6.13] findById(roomId) để lấy trạng thái bàn cờ hiện tại
            GameRoom room = dao.findById(roomId);
            
            if (room == null) return;
            // [Bước 6.11] Cập nhật Timer (Trừ thời gian đã qua)
            RoomTimer timer = gameTimers.computeIfAbsent(roomId, k -> new RoomTimer(room.getTimeControl()));
            
            // Chặn thao tác nếu game chưa bắt đầu
            if (!timer.isGameStarted) {
                session.getBasicRemote().sendText(gson.toJson(new GameResponse("INVALID", "Vui lòng chờ đối thủ vào phòng để bắt đầu!")));
                return;
            }
            
            // Chỉ tính giờ khi đang đánh cờ
            if (!"TOGGLE_DEAD".equals(type) && !"CONFIRM_SCORE".equals(type)) {
                long now = System.currentTimeMillis();
                long elapsed = now - timer.lastTurnStartTime;
                PlayerTimer currentPlayerTimer = timer.currentTurn.equals("black") ? timer.black : timer.white;
                
                if (currentPlayerTimer.mainTimeMillis > 0) {
                    currentPlayerTimer.mainTimeMillis -= elapsed;
                } else {
                    if (elapsed > currentPlayerTimer.periodTimeMillis) {
                        currentPlayerTimer.periods -= (int) (elapsed / currentPlayerTimer.periodTimeMillis);
                    }
                }
                
                if (currentPlayerTimer.periods < 0) {
                    handleTimeout(roomId, timer);
                    return;
                }
                timer.lastTurnStartTime = now;
            }
            
            Map<String, Object> timeData = getTimeData(timer);
            
            if ("RESIGN".equals(type)) {
                String color = (String) data.get("color");
                String res = color.equals("black") ? "Trắng thắng (Đen đầu hàng)" : "Đen thắng (Trắng đầu hàng)";
                dao.finishGame(roomId, res);
                broadcast(roomId, gson.toJson(new GameResponse("GAME_OVER", res)), null);
                gameTimers.remove(roomId);
                // Xóa lịch sử bàn cờ khi có người đầu hàng
                boardHistoryMap.remove(roomId);
                drawProposalMap.remove(roomId);
                return;
            }
            
            // Xử lý gửi yêu cầu hòa hoặc đồng ý hòa
            if ("DRAW_PROPOSE".equals(type)) {
                // Thêm ID của người dùng vào danh sách đồng ý hòa
                Set<String> draws = drawProposalMap.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>()));
                draws.add(session.getId());
                
                // Nếu cả 2 người cùng đồng ý hòa
                if (draws.size() >= 2) {
                    dao.finishGame(roomId, "Hòa (Hai bên thỏa thuận)");
                    broadcast(roomId, gson.toJson(new GameResponse("GAME_OVER", "Hòa (Hai bên thỏa thuận)")), null);
                    // Dọn dẹp tài nguyên
                    gameTimers.remove(roomId);
                    boardHistoryMap.remove(roomId);
                    drawProposalMap.remove(roomId);
                    moveHistoryMap.remove(roomId);
                    undoProposalMap.remove(roomId);
                    consecutivePasses.remove(roomId);
                    deadStonesMap.remove(roomId);
                    confirmationMap.remove(roomId);
                } else {
                    // Nếu mới 1 người đề xuất, báo cho người còn lại
                    broadcast(roomId, gson.toJson(new GameResponse("DRAW_REQUESTED", "Đối thủ đề nghị hòa ván cờ. Bạn có đồng ý không?")), session);
                }
                return;
            }
            
            // Xử lý khi đối thủ từ chối đề nghị hòa
            if ("DRAW_REJECT".equals(type)) {
                drawProposalMap.remove(roomId); // Xóa đề xuất trước đó
                broadcast(roomId, gson.toJson(new GameResponse("DRAW_REJECTED", "Đối thủ đã từ chối đề nghị hòa.")), session);
                return;
            }
            
            // Xử lý Hồi nước đi (Undo)
            if ("UNDO_PROPOSE".equals(type)) {
                Stack<List<GameMove>> stack = moveHistoryMap.get(roomId);
                if (stack == null || stack.isEmpty()) {
                    session.getBasicRemote().sendText(gson.toJson(new GameResponse("INVALID", "Không có nước đi nào để hoàn tác!")));
                    return;
                }
                
                Set<String> undos = undoProposalMap.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>()));
                undos.add(session.getId());
                
                if (undos.size() >= 2) {
                    List<GameMove> previousMoves = stack.pop();
                    dao.deleteMoves(roomId); // Xóa toàn bộ nước đi hiện tại ở DB
                    for (GameMove m : previousMoves) {
                        m.setRoom(room);
                        dao.saveMove(m); // Phục hồi lại các nước đi cũ (kể cả các quân đã từng bị ăn)
                    }
                    
                    // Lùi lại 1 lượt
                    timer.currentTurn = timer.currentTurn.equals("black") ? "white" : "black";
                    undoProposalMap.remove(roomId);
                    
                    // Lùi lại lịch sử Superko 1 bước
                    Stack<String> bHistory = boardHistoryMap.get(roomId);
                    if (bHistory != null && !bHistory.isEmpty()) {
                        bHistory.pop();
                    }
                    
                    // Trả về dữ liệu để client render lại bàn cờ
                    Map<String, Object> syncData = new HashMap<>();
                    syncData.put("moves", previousMoves);
                    syncData.put("nextTurn", timer.currentTurn);
                    broadcast(roomId, gson.toJson(new GameResponse("UNDO_SUCCESS", syncData)), null);
                } else {
                    broadcast(roomId, gson.toJson(new GameResponse("UNDO_REQUESTED", "Đối thủ muốn hoàn tác nước đi vừa rồi. Bạn đồng ý không?")), session);
                }
                return;
            }
            
            if ("UNDO_REJECT".equals(type)) {
                undoProposalMap.remove(roomId);
                broadcast(roomId, gson.toJson(new GameResponse("UNDO_REJECTED", "Đối thủ không đồng ý hoàn tác nước đi.")), session);
                return;
            }
            
            if ("PASS".equals(type)) {
                timer.currentTurn = timer.currentTurn.equals("black") ? "white" : "black";
                // [Bước 6.31] consecutivePasses++
                int passes = consecutivePasses.getOrDefault(roomId, 0) + 1;
                consecutivePasses.put(roomId, passes);
                
                if (passes >= 2) {
                    // [Bước 6.32] Broadcast "START_DEAD_SELECTION"
                    broadcast(roomId, gson.toJson(new GameResponse("START_DEAD_SELECTION", null)), null);
                } else {
                    Map<String, Object> res = new HashMap<>();
                    res.put("type", "PASS");
                    res.put("nextTurn", timer.currentTurn);
                    res.put("timeData", timeData);
                    broadcast(roomId, gson.toJson(res), null);
                }
                return;
            }
            
            if ("TOGGLE_DEAD".equals(type)) {
                int x = ((Double) data.get("x")).intValue();
                int y = ((Double) data.get("y")).intValue();
                int size = room.getBoardSize();
                
                // Validate: Kiểm tra tọa độ chọn quân chết có nằm ngoài phạm vi bàn cờ không
                if (x < 0 || x >= size || y < 0 || y >= size) {
                    session.getBasicRemote().sendText(gson.toJson(new GameResponse("INVALID", "Tọa độ vượt quá phạm vi bàn cờ!")));
                    return;
                }
                String posKey = x + "-" + y;
                
                Set<String> deadStones = deadStonesMap.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>()));
                if (!deadStones.remove(posKey)) {
                    deadStones.add(posKey);
                }
                broadcast(roomId, gson.toJson(new GameResponse("UPDATE_DEAD_STONES", deadStones)), null);
                return;
            }
            
            // [Bước 6.35] Send {type: "CONFIRM_SCORE"}
            if ("CONFIRM_SCORE".equals(type)) {
                Set<String> confirms = confirmationMap.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>()));
                confirms.add(session.getId());
                
                if (confirms.size() >= 2) {
                    calculateAndFinish(roomId, room, dao);
                } else {
                    broadcast(roomId, gson.toJson(new GameResponse("WAITING_CONFIRM", "Đang chờ đối thủ xác nhận...")), null);
                }
                return;
            }
            
            consecutivePasses.put(roomId, 0);
            int x = ((Double) data.get("x")).intValue();
            int y = ((Double) data.get("y")).intValue();
            String color = (String) data.get("color");
            int size = room.getBoardSize();
            
            // Validate: Kiểm tra tọa độ đánh cờ có nằm ngoài phạm vi bàn cờ không
            if (x < 0 || x >= size || y < 0 || y >= size) {
                session.getBasicRemote().sendText(gson.toJson(new GameResponse("INVALID", "Tọa độ vượt quá phạm vi bàn cờ!")));
                return;
            }
            
            int[][] currentBoard = new int[size][size];
            int[][] previousBoard = new int[size][size];
            List<GameMove> moves = room.getMoves();
            
            if (moves != null) {
                for (int i = 0; i < moves.size(); i++) {
                    GameMove m = moves.get(i);
                    int stoneColorInt = m.getColor().equals("black") ? 1 : 2;
                    if (i < moves.size() - 1) {
                        previousBoard[m.getX()][m.getY()] = stoneColorInt;
                    }
                    currentBoard[m.getX()][m.getY()] = stoneColorInt;
                }
            }
            
            if (currentBoard[x][y] != 0) return;
            // [Bước 6.14] setBoard(currentBoard)
            GoLogic logic = new GoLogic(size);
            logic.setBoard(currentBoard);
            
            int myColorInt = color.equals("black") ? 1 : 2;
            int opponentColorInt = (myColorInt == 1) ? 2 : 1;
            // [Bước 6.15] isSuicide(x, y, color)
            if (logic.isSuicide(x, y, myColorInt)) {
                // [Alt: Nước đi tự sát]
                // [Bước 6.16, 6.17] Send "INVALID" (Nước đi tự sát!)
                session.getBasicRemote().sendText(gson.toJson(new GameResponse("INVALID", "Nước đi tự sát!")));
                return;
            }
            
            int[][] nextBoard = new int[size][size];
            for (int i = 0; i < size; i++) {
                nextBoard[i] = currentBoard[i].clone();
            }
            nextBoard[x][y] = myColorInt;
            // [Alt: Nước đi hợp lệ] -> [Bước 6.18] false (Tiếp tục xử lý)
            
            // [Bước 6.19] Kiểm tra Capture (Ăn quân đối phương)
            // [Bước 6.20] Trả về danh sách quân bị ăn (toRemove)
            List<StoneCoords> toRemove = new ArrayList<>();
            int[][] neighbors = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
            
            for (int[] n : neighbors) {
                int nx = x + n[0], ny = y + n[1];
                if (nx >= 0 && nx < size && ny >= 0 && ny < size && nextBoard[nx][ny] == opponentColorInt) {
                    logic.setBoard(nextBoard);
                    List<int[]> group = logic.findGroup(nx, ny, opponentColorInt);
                    if (logic.countLiberties(group) == 0) {
                        for (int[] stonePos : group) {
                            toRemove.add(new StoneCoords(stonePos[0], stonePos[1]));
                            nextBoard[stonePos[0]][stonePos[1]] = 0;
                        }
                    }
                }
            }
            
            // [Superko] Chuyển trạng thái bàn cờ tiếp theo thành chuỗi để dễ so sánh
            String nextBoardStr = logic.getBoardString(nextBoard);
            
            // Lấy danh sách lịch sử trạng thái của phòng hiện tại
            Stack<String> history = boardHistoryMap.computeIfAbsent(roomId, k -> new Stack<>());
            
            // Nếu lịch sử trống (nước đầu tiên hoặc server vừa restart), lưu trạng thái hiện tại vào trước
            if (history.isEmpty()) {
                history.push(logic.getBoardString(currentBoard));
            }
            
            // [Superko] Kiểm tra luật Kiếp toàn cục (Positional Superko): Trạng thái không được lặp lại bất kỳ lúc nào trong quá khứ
            if (history.contains(nextBoardStr)) {
                session.getBasicRemote().sendText(gson.toJson(new GameResponse("INVALID", "Vi phạm luật Kiếp (Superko)! Trạng thái bàn cờ bị lặp lại.")));
                return;
            }
            
            // Clone trạng thái nước đi hiện tại để hỗ trợ tính năng Hồi nước đi (Undo)
            Stack<List<GameMove>> moveStack = moveHistoryMap.computeIfAbsent(roomId, k -> new Stack<>());
            List<GameMove> clonedMoves = new ArrayList<>();
            if (moves != null) {
                for (GameMove m : moves) {
                    GameMove clone = new GameMove();
                    clone.setX(m.getX()); clone.setY(m.getY()); clone.setColor(m.getColor()); clone.setMoveOrder(m.getMoveOrder());
                    clonedMoves.add(clone);
                }
            }
            moveStack.push(clonedMoves);
            
            // Nếu hợp lệ, lưu trạng thái mới vào lịch sử
            history.push(nextBoardStr);
            
            for (StoneCoords s : toRemove) {
                // [Bước 6.21, 6.22] removeMoveAt(roomId, x, y) - Xóa quân bị ăn trong DB
                dao.removeMoveAt(roomId, s.x, s.y);
            }
            
            if (!toRemove.isEmpty()) {
                if (color.equals("black")) {
                    timer.blackCaptures += toRemove.size();
                } else {
                    timer.whiteCaptures += toRemove.size();
                }
                broadcast(roomId, gson.toJson(new GameResponse("REMOVE", toRemove)), null);
            }
            
            // [Bước 6.23, 6.24, 6.25, 6.26] saveMove(newMove) -> Insert vào DB
            GameMove newMove = new GameMove();
            newMove.setRoom(room);
            newMove.setX(x);
            newMove.setY(y);
            newMove.setColor(color);
            newMove.setMoveOrder(moves != null ? moves.size() + 1 : 1);
            dao.saveMove(newMove);
            
            // [Bước 6.27] Đổi lượt, xem xét luật chấp quân (Handicap)
            int handicap = room.getHandicap();
            int currentMovesCount = moves != null ? moves.size() + 1 : 1;
            
            // Nếu vẫn đang trong giai đoạn đặt quân chấp, quân Đen tiếp tục được đi
            if (handicap > 0 && currentMovesCount < handicap) {
                timer.currentTurn = "black";
            } else if (handicap > 0 && currentMovesCount == handicap) {
                timer.currentTurn = "white"; // Sau khi Đen đặt xong quân chấp, lượt chuyển sang Trắng
            } else {
                timer.currentTurn = timer.currentTurn.equals("black") ? "white" : "black";
            }
            
            Map<String, Object> moveResponse = new HashMap<>(data);
            moveResponse.put("nextTurn", timer.currentTurn);
            moveResponse.put("timeData", timeData);
            // [Bước 6.28] Broadcast nước đi mới & toRemove
            broadcast(roomId, gson.toJson(moveResponse), null);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void calculateAndFinish(Long roomId, GameRoom room, RoomDAO dao) {
        GoLogic logic = new GoLogic(room.getBoardSize());
        int[][] finalBoard = new int[room.getBoardSize()][room.getBoardSize()];
        Set<String> deadStones = deadStonesMap.getOrDefault(roomId, new HashSet<>());
        
        if (room.getMoves() != null) {
            for (GameMove m : room.getMoves()) {
                if (!deadStones.contains(m.getX() + "-" + m.getY())) {
                    finalBoard[m.getX()][m.getY()] = m.getColor().equals("black") ? 1 : 2;
                }
            }
        }
        
        logic.setBoard(finalBoard);
        // [Handicap] Tự động điều chỉnh Komi: Nếu có chấp quân thì Komi chỉ còn 0.5 để tránh hòa
        double komi = room.getHandicap() > 0 ? 0.5 : 6.5;
        // [Bước 6.36] calculateFinalScore(komi)
        // [Bước 6.37] Trả về Map<String, Double> (Điểm số)
        Map<String, Double> scores = logic.calculateFinalScore(komi);
        
        String result;
        // Tự động kiểm tra và xử lý nếu điểm số bằng nhau
        if (scores.get("black").equals(scores.get("white"))) {
            result = "Hòa (Điểm số bằng nhau)";
        } else if (scores.get("black") > scores.get("white")) {
            result = "Đen thắng " + (scores.get("black") - scores.get("white"));
        } else {
            result = "Trắng thắng " + (scores.get("white") - scores.get("black"));
        }
        // [Bước 6.38, 6.39, 6.40, 6.41] finishGame(roomId, result) -> Update status = "FINISHED"
        dao.finishGame(roomId, result);
        
        // [Bước 6.42] Broadcast "FINAL_SCORE" & "GAME_OVER"
        broadcast(roomId, gson.toJson(new GameResponse("FINAL_SCORE", scores)), null);
        
        gameTimers.remove(roomId);
        consecutivePasses.remove(roomId);
        deadStonesMap.remove(roomId);
        confirmationMap.remove(roomId);
        // Dọn dẹp bộ nhớ lịch sử bàn cờ khi kết thúc game
        boardHistoryMap.remove(roomId);
        // Dọn dẹp bộ nhớ đề xuất hòa và hoàn tác
        drawProposalMap.remove(roomId);
        moveHistoryMap.remove(roomId);
        undoProposalMap.remove(roomId);
    }
    
    private void broadcast(Long roomId, String message, Session sender) {
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions != null) {
            for (Session s : sessions) {
                if (s.isOpen() && (sender == null || !s.getId().equals(sender.getId()))) {
                    try {
                        s.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
    
    @OnClose
    public void onClose(Session session, @PathParam("roomId") Long roomId) {
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions != null) {
            sessions.remove(session);
        }
    }
}