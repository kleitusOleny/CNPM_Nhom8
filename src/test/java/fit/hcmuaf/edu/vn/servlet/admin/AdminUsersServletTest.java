package fit.hcmuaf.edu.vn.servlet.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

public class AdminUsersServletTest {
    /**
     * Kiểm tra khi người dùng không phải Admin cố gắng truy cập trang quản lý.
     * Kết quả mong đợi:
     * Chuyển hướng người dùng về trang đăng nhập
     */
    @Test
    void doGet_NotAdmin_RedirectLogin() throws Exception {

        HttpServletRequest req = mock(HttpServletRequest.class);
        HttpServletResponse resp = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        AdminUsersServlet servlet = new AdminUsersServlet();

        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("role")).thenReturn("customer");
        when(req.getContextPath()).thenReturn("");

        servlet.doGet(req, resp);

        verify(resp).sendRedirect("/login");
    }
    /**
     * Kiểm tra khi Admin gửi yêu cầu xử lý dữ liệu nhưng thiếu tham số ID.
     * Kết quả mong đợi:
     * Trả về mã lỗi 400.
     */
    @Test
    void doPost_MissingId_ReturnBadRequest() throws Exception {

        HttpServletRequest req = mock(HttpServletRequest.class);
        HttpServletResponse resp = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        AdminUsersServlet servlet = new AdminUsersServlet();

        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("role")).thenReturn("admin");

        when(req.getParameter("id")).thenReturn(null);

        servlet.doPost(req, resp);

        verify(resp).setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
    /**
     * Kiểm tra khi người dùng không phải Admin cố tình gửi yêu cầu xử lý dữ liệu.
     * Kết quả mong đợi:
     * Trả về mã lỗi 403.
     */
    @Test
    void doPost_NotAdmin_ReturnForbidden() throws Exception {

        HttpServletRequest req = mock(HttpServletRequest.class);
        HttpServletResponse resp = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        AdminUsersServlet servlet = new AdminUsersServlet();

        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("role")).thenReturn("customer");

        servlet.doPost(req, resp);

        verify(resp).setStatus(HttpServletResponse.SC_FORBIDDEN);
    }
}
