package fit.hcmuaf.edu.vn.websocket;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import jakarta.websocket.RemoteEndpoint;
import jakarta.websocket.Session;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedConstruction;

import java.io.IOException;
import java.util.ArrayList;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.contains;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

public class GameWebSocketTest {

    private GameWebSocket gameWebSocket;
    private Session session1;
    private Session session2;
    private RemoteEndpoint.Basic basicRemote1;
    private RemoteEndpoint.Basic basicRemote2;

    @BeforeEach
    public void setUp() {
        gameWebSocket = new GameWebSocket();
        
        session1 = mock(Session.class);
        basicRemote1 = mock(RemoteEndpoint.Basic.class);
        when(session1.getBasicRemote()).thenReturn(basicRemote1);
        when(session1.isOpen()).thenReturn(true);
        when(session1.getId()).thenReturn("session1");

        session2 = mock(Session.class);
        basicRemote2 = mock(RemoteEndpoint.Basic.class);
        when(session2.getBasicRemote()).thenReturn(basicRemote2);
        when(session2.isOpen()).thenReturn(true);
        when(session2.getId()).thenReturn("session2");
    }

    /**
     * Kiểm tra luồng tham gia phòng (onOpen). Game chỉ bắt đầu khi có đủ 2 người.
     * <p>
     * Input: Lần lượt gọi sự kiện onOpen() với 2 session độc lập (session1, session2) cho cùng một ID phòng (1L).
     * Tham số truyền vào:
     * - {@code session}: Mock Session của kết nối WebSocket.
     * - {@code roomId}: 1L
     * Output:
     * - Khi chỉ có session1, không có tin nhắn nào được gửi.
     * - Khi session2 vào, cả 2 session đều nhận được tin nhắn bắt đầu "GAME_STARTED".
     */
    @Test
    public void testOnOpen_GameStartsWhenTwoPlayersJoin() throws IOException {
        GameRoom room = new GameRoom();
        room.setId(1L);
        room.setTimeControl("30m+3x30s");
        room.setMoves(new ArrayList<>());

        try (MockedConstruction<RoomDAO> mockedDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findById(1L)).thenReturn(room);
        })) {
            // Player 1 (Black) joins
            gameWebSocket.onOpen(session1, 1L);
            verify(basicRemote1, never()).sendText(anyString());

            // Player 2 (White) joins, game should start
            gameWebSocket.onOpen(session2, 1L);
            
            // Both sessions should receive GAME_STARTED
            verify(basicRemote1, atLeastOnce()).sendText(contains("GAME_STARTED"));
            verify(basicRemote2, atLeastOnce()).sendText(contains("GAME_STARTED"));
        }
    }

    /**
     * Kiểm tra tính năng xin thua (Resign).
     * <p>
     * Input: 
     * - 2 session đã tham gia phòng (2L).
     * - session1 gửi thông điệp chuỗi JSON loại RESIGN: {@code {"type":"RESIGN", "color":"black"}}
     * Output:
     * - Hệ thống gọi hàm {@code RoomDAO.finishGame} để lưu kết quả (Trắng thắng).
     * - Hệ thống gửi tin nhắn "GAME_OVER" đến cả 2 session.
     */
    @Test
    public void testOnMessage_Resign() throws IOException {
        GameRoom room = new GameRoom();
        room.setId(2L);
        room.setTimeControl("30m+3x30s");

        try (MockedConstruction<RoomDAO> mockedDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findById(2L)).thenReturn(room);
        })) {
            // Setup room with 2 sessions to start the game
            gameWebSocket.onOpen(session1, 2L);
            gameWebSocket.onOpen(session2, 2L);

            String resignMsg = "{\"type\":\"RESIGN\", \"color\":\"black\"}";
            gameWebSocket.onMessage(resignMsg, session1, 2L);

            verify(mockedDAO.constructed().get(0)).finishGame(eq(2L), contains("Trắng thắng"));
            verify(basicRemote1, atLeastOnce()).sendText(contains("GAME_OVER"));
            verify(basicRemote2, atLeastOnce()).sendText(contains("GAME_OVER"));
        }
    }

    /**
     * Kiểm tra quy trình xin hòa 2 chiều (Draw Propose & Accept).
     * <p>
     * Input:
     * - Lần 1: session1 gửi JSON: {@code {"type":"DRAW_PROPOSE"}}
     * - Lần 2: session2 gửi JSON tương tự để đồng ý.
     * Output:
     * - Sau lần 1: session2 nhận được "DRAW_REQUESTED" để hiển thị hộp thoại xác nhận.
     * - Sau lần 2: Trận đấu kết thúc hòa, gọi {@code RoomDAO.finishGame} và phát sóng "GAME_OVER".
     */
    @Test
    public void testOnMessage_DrawProposeAndAccept() throws IOException {
        GameRoom room = new GameRoom();
        room.setId(3L);
        room.setTimeControl("30m+3x30s");

        try (MockedConstruction<RoomDAO> mockedDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findById(3L)).thenReturn(room);
        })) {
            gameWebSocket.onOpen(session1, 3L);
            gameWebSocket.onOpen(session2, 3L);

            // Player 1 proposes a draw
            String drawMsg = "{\"type\":\"DRAW_PROPOSE\"}";
            gameWebSocket.onMessage(drawMsg, session1, 3L);
            
            // Player 2 should receive DRAW_REQUESTED
            verify(basicRemote2, atLeastOnce()).sendText(contains("DRAW_REQUESTED"));
            
            // Player 2 accepts the draw
            gameWebSocket.onMessage(drawMsg, session2, 3L);
            
            // The game should be marked as Draw and broadcast GAME_OVER
            verify(mockedDAO.constructed().get(0)).finishGame(eq(3L), contains("Hòa"));
            verify(basicRemote1, atLeastOnce()).sendText(contains("GAME_OVER"));
        }
    }
    
    /**
     * Kiểm tra tính năng bỏ lượt (Pass).
     * <p>
     * Input:
     * - 2 session đã kết nối vào phòng (4L).
     * - session1 gửi JSON bỏ lượt: {@code {"type":"PASS"}}
     * Output:
     * - Hệ thống chuyển lượt và gửi thông báo chứa chuỗi "PASS" sang cho session2 để đồng bộ giao diện.
     */
    @Test
    public void testOnMessage_Pass() throws IOException {
        GameRoom room = new GameRoom();
        room.setId(4L);
        room.setTimeControl("30m+3x30s");

        try (MockedConstruction<RoomDAO> mockedDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findById(4L)).thenReturn(room);
        })) {
            gameWebSocket.onOpen(session1, 4L);
            gameWebSocket.onOpen(session2, 4L);

            // Player 1 passes
            String passMsg = "{\"type\":\"PASS\"}";
            gameWebSocket.onMessage(passMsg, session1, 4L);
            
            // Should broadcast PASS event
            verify(basicRemote2, atLeastOnce()).sendText(contains("PASS"));
        }
    }
}
