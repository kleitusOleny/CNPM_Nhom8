package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.mockito.MockedConstruction;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static org.mockito.Mockito.*;

public class LobbyServletTest {

    /**
     * Kiểm tra truy cập Sảnh Chờ (Lobby) khi chưa đăng nhập.
     * <p>
     * Tham số đầu vào (Input):
     * - Request GET gửi đến trang Sảnh Chờ.
     * - Session hiện tại không tồn tại (null).
     * Kết quả mong đợi (Output):
     * - Từ chối truy cập và chuyển hướng người dùng (redirect) sang trang đăng nhập.
     */
    @Test
    public void testDoGet_NotLoggedIn() throws ServletException, IOException {
        LobbyServlet servlet = new LobbyServlet();
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);

        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/go_chess_war/login");
    }

    /**
     * Kiểm tra truy cập Sảnh Chờ (Lobby) khi đã đăng nhập thành công.
     * <p>
     * Tham số đầu vào (Input):
     * - Request GET có đính kèm Session hợp lệ (user = "player1").
     * - Mock DB (RoomDAO) trả về một danh sách chứa 2 phòng đang chờ người chơi.
     * Kết quả mong đợi (Output):
     * - Servlet lưu danh sách phòng này vào biến request (attribute "rooms").
     * - Chuyển tiếp người dùng hiển thị giao diện Sảnh Chờ (/views/lobby/lobby.jsp).
     */
    @Test
    public void testDoGet_LoggedIn_DisplaysAvailableRooms() throws ServletException, IOException {
        GameRoom room1 = new GameRoom();
        GameRoom room2 = new GameRoom();
        List<GameRoom> availableRooms = Arrays.asList(room1, room2);

        try (MockedConstruction<RoomDAO> mockRoomDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findAvailableRooms()).thenReturn(availableRooms);
        })) {
            LobbyServlet servlet = new LobbyServlet();
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);
            HttpSession session = mock(HttpSession.class);
            RequestDispatcher dispatcher = mock(RequestDispatcher.class);

            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("user")).thenReturn("player1");
            when(request.getRequestDispatcher("/views/lobby/lobby.jsp")).thenReturn(dispatcher);

            servlet.doGet(request, response);

            verify(request).setAttribute("rooms", availableRooms);
            verify(dispatcher).forward(request, response);
        }
    }
}
