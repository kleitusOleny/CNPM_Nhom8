package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.mockito.MockedConstruction;

import java.io.IOException;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class CreateRoomServletTest {

    /**
     * Kiểm tra truy cập trang tạo phòng khi CHƯA đăng nhập.
     * <p>
     * Tham số đầu vào (Input):
     * - Request GET gửi đến "/create-room".
     * - Không có Session hợp lệ (session = null).
     * Kết quả mong đợi (Output):
     * - Hệ thống từ chối truy cập và điều hướng (redirect) về trang "/login".
     */
    @Test
    public void testDoGet_NotLoggedIn() throws ServletException, IOException {
        try (MockedConstruction<RoomDAO> mockRoom = mockConstruction(RoomDAO.class);
             MockedConstruction<UserDAO> mockUser = mockConstruction(UserDAO.class)) {
            
            CreateRoomServlet servlet = new CreateRoomServlet();
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);

            when(request.getSession(false)).thenReturn(null);
            when(request.getContextPath()).thenReturn("/go_chess_war");

            servlet.doGet(request, response);

            verify(response).sendRedirect("/go_chess_war/login");
        }
    }

    /**
     * Kiểm tra truy cập trang tạo phòng khi ĐÃ đăng nhập.
     * <p>
     * Tham số đầu vào (Input):
     * - Request GET gửi đến "/create-room".
     * - Có Session hợp lệ, thuộc tính "user" có giá trị (ví dụ: "player1").
     * Kết quả mong đợi (Output):
     * - Hệ thống cho phép truy cập.
     * - Chuyển tiếp (forward) hiển thị giao diện form tạo phòng ("/views/game/create-room.jsp").
     */
    @Test
    public void testDoGet_LoggedIn() throws ServletException, IOException {
        try (MockedConstruction<RoomDAO> mockRoom = mockConstruction(RoomDAO.class);
             MockedConstruction<UserDAO> mockUser = mockConstruction(UserDAO.class)) {
             
            CreateRoomServlet servlet = new CreateRoomServlet();
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);
            HttpSession session = mock(HttpSession.class);
            RequestDispatcher dispatcher = mock(RequestDispatcher.class);

            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("user")).thenReturn("player1");
            when(request.getRequestDispatcher("/views/game/create-room.jsp")).thenReturn(dispatcher);

            servlet.doGet(request, response);

            verify(dispatcher).forward(request, response);
        }
    }

    /**
     * Kiểm tra tạo phòng thành công (Success Flow).
     * <p>
     * Tham số đầu vào (Input):
     * - Các parameter hợp lệ: room_name="My Room", room_password="", board_size="19", main_time="30", byo_yomi="3x30s".
     * - User hiện tại chưa ở phòng nào (isUserInRoom = false).
     * Kết quả mong đợi (Output):
     * - Gọi roomDAO.save() thành công.
     * - Trình duyệt điều hướng sang giao diện ván đấu (redirect to /game/...).
     */
    @Test
    public void testDoPost_Success() throws ServletException, IOException {
        User player = new User();
        player.setId(1L);
        player.setUsername("player1");

        try (MockedConstruction<UserDAO> mockUserDAO = mockConstruction(UserDAO.class, (mock, context) -> {
            when(mock.findByUsername("player1")).thenReturn(player);
        });
             MockedConstruction<RoomDAO> mockRoomDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
                 when(mock.isUserInRoom(1L)).thenReturn(false); // User is not in another room
             })) {
             
            CreateRoomServlet servlet = new CreateRoomServlet();
            
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);
            HttpSession session = mock(HttpSession.class);

            when(request.getCharacterEncoding()).thenReturn("UTF-8");
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("user")).thenReturn("player1");
            when(request.getContextPath()).thenReturn("/go_chess_war");

            // Valid parameters
            when(request.getParameter("room_name")).thenReturn("My Room");
            when(request.getParameter("room_password")).thenReturn("");
            when(request.getParameter("board_size")).thenReturn("19");
            when(request.getParameter("main_time")).thenReturn("30");
            when(request.getParameter("byo_yomi")).thenReturn("3x30s");

            servlet.doPost(request, response);

            verify(mockRoomDAO.constructed().get(0)).save(any());
            verify(response).sendRedirect(contains("/game/"));
        }
    }

    /**
     * Kiểm tra xử lý ngoại lệ: Tên phòng không hợp lệ (Trống).
     * <p>
     * Tham số đầu vào (Input):
     * - Tham số "room_name" rỗng ("").
     * Kết quả mong đợi (Output):
     * - Đặt thông báo lỗi "Tên phòng không được để trống" vào request (errorMsg).
     * - Chuyển tiếp (forward) trở lại trang create-room.jsp.
     */
    @Test
    public void testDoPost_InvalidRoomName() throws ServletException, IOException {
        try (MockedConstruction<RoomDAO> mockRoom = mockConstruction(RoomDAO.class);
             MockedConstruction<UserDAO> mockUser = mockConstruction(UserDAO.class)) {
             
            CreateRoomServlet servlet = new CreateRoomServlet();
            
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);
            HttpSession session = mock(HttpSession.class);
            RequestDispatcher dispatcher = mock(RequestDispatcher.class);

            when(request.getCharacterEncoding()).thenReturn("UTF-8");
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("user")).thenReturn("player1");
            when(request.getRequestDispatcher("/views/game/create-room.jsp")).thenReturn(dispatcher);

            // Empty room name
            when(request.getParameter("room_name")).thenReturn("");

            servlet.doPost(request, response);

            verify(request).setAttribute(eq("errorMsg"), eq("Tên phòng không được để trống"));
            verify(dispatcher).forward(request, response);
        }
    }

    /**
     * Kiểm tra xử lý ngoại lệ: Kích thước bàn cờ không hợp lệ.
     * <p>
     * Tham số đầu vào (Input):
     * - Tham số "board_size" bằng "15" (chỉ cho phép 9, 13, 19).
     * Kết quả mong đợi (Output):
     * - Đặt thông báo lỗi "Kích thước bàn không hợp lệ" vào request.
     * - Chuyển tiếp trở lại giao diện tạo phòng.
     */
    @Test
    public void testDoPost_InvalidBoardSize() throws ServletException, IOException {
        try (MockedConstruction<RoomDAO> mockRoom = mockConstruction(RoomDAO.class);
             MockedConstruction<UserDAO> mockUser = mockConstruction(UserDAO.class)) {
             
            CreateRoomServlet servlet = new CreateRoomServlet();
            
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);
            HttpSession session = mock(HttpSession.class);
            RequestDispatcher dispatcher = mock(RequestDispatcher.class);

            when(request.getCharacterEncoding()).thenReturn("UTF-8");
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("user")).thenReturn("player1");
            when(request.getRequestDispatcher("/views/game/create-room.jsp")).thenReturn(dispatcher);

            when(request.getParameter("room_name")).thenReturn("Room 1");
            // Invalid size
            when(request.getParameter("board_size")).thenReturn("15");

            servlet.doPost(request, response);

            verify(request).setAttribute(eq("errorMsg"), eq("Kích thước bàn không hợp lệ"));
            verify(dispatcher).forward(request, response);
        }
    }

    /**
     * Kiểm tra quy tắc nghiệp vụ: Một user không thể tạo/có mặt trong 2 phòng cùng lúc.
     * <p>
     * Tham số đầu vào (Input):
     * - Các tham số tạo phòng hợp lệ.
     * - Trạng thái: Mock hệ thống trả về User đã ở trong một phòng khác (isUserInRoom = true).
     * Kết quả mong đợi (Output):
     * - Khước từ việc tạo phòng và báo lỗi "Bạn đang ở trong một phòng khác".
     * - Không gọi lệnh save() xuống DB.
     */
    @Test
    public void testDoPost_UserAlreadyInRoom() throws ServletException, IOException {
        User player = new User();
        player.setId(1L);
        player.setUsername("player1");

        try (MockedConstruction<UserDAO> mockUserDAO = mockConstruction(UserDAO.class, (mock, context) -> {
            when(mock.findByUsername("player1")).thenReturn(player);
        });
             MockedConstruction<RoomDAO> mockRoomDAO = mockConstruction(RoomDAO.class, (mock, context) -> {
                 // Simulate user already in another room
                 when(mock.isUserInRoom(1L)).thenReturn(true);
             })) {
             
            CreateRoomServlet servlet = new CreateRoomServlet();
            
            HttpServletRequest request = mock(HttpServletRequest.class);
            HttpServletResponse response = mock(HttpServletResponse.class);
            HttpSession session = mock(HttpSession.class);
            RequestDispatcher dispatcher = mock(RequestDispatcher.class);

            when(request.getCharacterEncoding()).thenReturn("UTF-8");
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("user")).thenReturn("player1");
            when(request.getRequestDispatcher("/views/game/create-room.jsp")).thenReturn(dispatcher);

            when(request.getParameter("room_name")).thenReturn("Valid Name");
            when(request.getParameter("board_size")).thenReturn("19");

            servlet.doPost(request, response);

            verify(request).setAttribute(eq("errorMsg"), eq("Bạn đang ở trong một phòng khác"));
            verify(dispatcher).forward(request, response);
        }
    }
}
