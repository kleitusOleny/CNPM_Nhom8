package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedConstruction;

import java.io.IOException;

import static org.mockito.Mockito.*;

public class GameServletTest {

    private GameServlet gameServlet;

    @BeforeEach
    public void setUp() {
        gameServlet = new GameServlet();
    }

    /**
     * Kiểm tra ngoại lệ: Người dùng truy cập nhưng chưa có Session (chưa đăng nhập).
     * <p>
     * Input: Request không có Session (getSession(false) trả về null).
     * Output: Hệ thống điều hướng (redirect) người dùng về trang đăng nhập (/login).
     */
    @Test
    public void testDoGet_NotLoggedIn_SessionNull() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);

        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        gameServlet.doGet(request, response);

        verify(response).sendRedirect("/go_chess_war/login");
    }

    /**
     * Kiểm tra ngoại lệ: Người dùng có Session nhưng chưa đăng nhập (Attribute "user" rỗng).
     * <p>
     * Input: Request có Session nhưng session.getAttribute("user") trả về null.
     * Output: Hệ thống điều hướng (redirect) người dùng về trang đăng nhập (/login).
     */
    @Test
    public void testDoGet_NotLoggedIn_UserAttributeNull() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(null);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        gameServlet.doGet(request, response);

        verify(response).sendRedirect("/go_chess_war/login");
    }

    /**
     * Kiểm tra ngoại lệ: Đường dẫn (PathInfo) không hợp lệ.
     * <p>
     * Input: Request PathInfo chỉ có dấu gạch chéo "/", không chứa ID phòng.
     * Output: Hệ thống điều hướng (redirect) người dùng về Sảnh chờ (/lobby).
     */
    @Test
    public void testDoGet_InvalidPathInfo() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("player1");
        when(request.getPathInfo()).thenReturn("/");
        when(request.getContextPath()).thenReturn("/go_chess_war");

        gameServlet.doGet(request, response);

        verify(response).sendRedirect("/go_chess_war/lobby");
    }

    /**
     * Kiểm tra ngoại lệ: ID phòng không tồn tại trong CSDL.
     * <p>
     * Input:
     * - Request PathInfo chứa ID phòng "/999".
     * - Mock RoomDAO trả về null khi tìm kiếm ID 999.
     * Output: Hệ thống không cho phép vào game và điều hướng (redirect) về Sảnh chờ (/lobby).
     */
    @Test
    public void testDoGet_RoomNotFound() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("player1");
        when(request.getPathInfo()).thenReturn("/999");
        when(request.getContextPath()).thenReturn("/go_chess_war");

        try (MockedConstruction<RoomDAO> mockedRoomDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findById(999L)).thenReturn(null);
        })) {
            gameServlet.doGet(request, response);
        }

        verify(response).sendRedirect("/go_chess_war/lobby");
    }

    /**
     * Kiểm tra trường hợp tham gia phòng khi đã là chủ phòng (Black Player).
     * <p>
     * Tham số đầu vào (Input):
     * - Request URL chứa tham số ID phòng: {@code pathInfo="/1"}
     * - Session hiện tại thuộc về user: "blackPlayer".
     * Kết quả mong đợi (Output):
     * - Đặt đối tượng GameRoom lấy từ DB vào thuộc tính request "currentGame".
     * - Chuyển tiếp người dùng sang giao diện bàn cờ (board.jsp).
     */
    @Test
    public void testDoGet_JoinExistingRoom_AsBlackPlayer() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("blackPlayer");
        when(request.getPathInfo()).thenReturn("/1");
        when(request.getRequestDispatcher("/views/game/board.jsp")).thenReturn(dispatcher);

        GameRoom room = new GameRoom();
        room.setId(1L);
        User blackUser = new User();
        blackUser.setUsername("blackPlayer");
        room.setBlackPlayer(blackUser);

        try (MockedConstruction<RoomDAO> mockedRoomDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
            when(mock.findById(1L)).thenReturn(room);
        })) {
            gameServlet.doGet(request, response);
        }

        verify(request).setAttribute("currentGame", room);
        verify(dispatcher).forward(request, response);
    }

    /**
     * Kiểm tra trường hợp một người dùng khác tham gia vào phòng (trở thành White Player).
     * <p>
     * Tham số đầu vào (Input):
     * - Request URL chứa ID phòng: {@code pathInfo="/1"}
     * - Session hiện tại thuộc về user: "whitePlayer".
     * - Mock DB trả về phòng 1L đang có sẵn Black Player, chưa có White Player.
     * Kết quả mong đợi (Output):
     * - Hệ thống tự động gán user "whitePlayer" vào vị trí White Player của phòng.
     * - Gọi hàm roomDAO.update(room) để lưu trạng thái mới xuống Database.
     * - Chuyển tiếp người dùng sang giao diện bàn cờ (board.jsp).
     */
    @Test
    public void testDoGet_JoinRoom_AsWhitePlayer() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("whitePlayer");
        when(request.getPathInfo()).thenReturn("/1");
        when(request.getRequestDispatcher("/views/game/board.jsp")).thenReturn(dispatcher);

        GameRoom room = new GameRoom();
        room.setId(1L);
        User blackUser = new User();
        blackUser.setUsername("blackPlayer");
        room.setBlackPlayer(blackUser);

        User whiteUser = new User();
        whiteUser.setUsername("whitePlayer");

        try (MockedConstruction<RoomDAO> mockedRoomDAO = mockConstruction(RoomDAO.class, (mockRoom, contextRoom) -> {
            when(mockRoom.findById(1L)).thenReturn(room);
        });
             MockedConstruction<UserDAO> mockedUserDAO = mockConstruction(UserDAO.class, (mockUser, contextUser) -> {
                 when(mockUser.findByUsername("whitePlayer")).thenReturn(whiteUser);
             })) {
            gameServlet.doGet(request, response);
            
            verify(mockedRoomDAO.constructed().get(0)).update(room);
        }

        verify(request).setAttribute("currentGame", room);
        verify(dispatcher).forward(request, response);
    }

    /**
     * Kiểm tra ngoại lệ: ID phòng nhập vào không phải là số (Lỗi định dạng).
     * <p>
     * Input: Request PathInfo chứa chuỗi chữ cái "/abc".
     * Output: Hệ thống bắt lỗi NumberFormatException và trả về mã lỗi HTTP 404 (SC_NOT_FOUND).
     */
    @Test
    public void testDoGet_InvalidNumberFormat() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("player1");
        when(request.getPathInfo()).thenReturn("/abc");

        gameServlet.doGet(request, response);

        verify(response).sendError(HttpServletResponse.SC_NOT_FOUND);
    }
}
