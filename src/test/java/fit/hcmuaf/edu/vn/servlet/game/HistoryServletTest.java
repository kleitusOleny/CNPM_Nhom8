package fit.hcmuaf.edu.vn.servlet.game;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static org.mockito.Mockito.*;

public class HistoryServletTest {

    /**
     * Kiểm tra truy cập Lịch sử đấu khi chưa đăng nhập.
     * <p>
     * Tham số đầu vào (Input):
     * - Request GET gửi đến trang lịch sử.
     * - Session hiện tại không tồn tại (null).
     * Kết quả mong đợi (Output):
     * - Từ chối truy cập và chuyển hướng người dùng (redirect) sang trang đăng nhập.
     */
    @Test
    public void testDoGet_NotLoggedIn() throws ServletException, IOException {
        HistoryServlet servlet = new HistoryServlet();
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);

        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/go_chess_war/login");
    }

    /**
     * Kiểm tra truy cập Lịch sử đấu khi đã đăng nhập thành công.
     * <p>
     * Tham số đầu vào (Input):
     * - Request GET có đính kèm Session hợp lệ (user = "player1").
     * Kết quả mong đợi (Output):
     * - Servlet cho phép truy cập.
     * - Chuyển tiếp (forward) hiển thị giao diện xem lịch sử (/views/game/history.jsp).
     */
    @Test
    public void testDoGet_LoggedIn_DisplaysHistory() throws ServletException, IOException {
        HistoryServlet servlet = new HistoryServlet();
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("player1");
        when(request.getRequestDispatcher("/views/game/history.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }
}
