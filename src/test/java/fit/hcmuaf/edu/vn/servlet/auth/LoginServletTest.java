package fit.hcmuaf.edu.vn.servlet.auth;

import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

import static org.mockito.Mockito.*;

/**
 * Bộ kiểm thử Unit Test cho LoginServlet.
 * Sử dụng thư viện Mockito để giả lập các thực thể Servlet mà không kết nối database thật.
 */
public class LoginServletTest {

    private LoginServlet loginServlet;
    private UserDAO mockUserDAO;

    @BeforeEach
    public void setUp() {
        // Khởi tạo đối tượng giả lập cho UserDAO
        mockUserDAO = mock(UserDAO.class);
        
        // Tạo một subclass nặc danh của LoginServlet để ghi đè phương thức getUserDAO(),
        // từ đó trả về mockUserDAO thay vì kết nối thật đến database MySQL
        loginServlet = new LoginServlet() {
            @Override
            protected UserDAO getUserDAO() {
                return mockUserDAO;
            }
        };
    }

    /**
     * Kịch bản: Người dùng đã đăng nhập từ trước và thực hiện truy cập trang đăng nhập bằng phương thức GET.
     * Mong muốn: Hệ thống tự động chuyển hướng người dùng sang trang phòng chờ (/lobby).
     */
    @Test
    public void testDoGet_UserAlreadyLoggedIn() throws ServletException, IOException {
        // BƯỚC 1: Thiết lập giả lập các đối tượng đầu vào (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        // Định nghĩa hành vi: Lấy session tồn tại -> trả về đối tượng session mock
        when(request.getSession(false)).thenReturn(session);
        // Định nghĩa hành vi: Thuộc tính "user" có giá trị tồn tại
        when(session.getAttribute("user")).thenReturn("existing_user");
        when(request.getContextPath()).thenReturn("/go_chess_war");

        // BƯỚC 2: Kích hoạt kiểm thử phương thức doGet (Run Test)
        loginServlet.doGet(request, response);

        // BƯỚC 3: Kiểm chứng kết quả thực thi (Verifying Results)
        // Xác minh response đã gọi redirect về đúng trang /lobby
        verify(response).sendRedirect("/go_chess_war/lobby");
        // Xác minh KHÔNG thực hiện forward (chuyển tiếp giao diện jsp)
        verify(request, never()).getRequestDispatcher(anyString());
    }

    /**
     * Kịch bản: Người dùng truy cập trang bằng GET nhưng chưa có Session nào tồn tại.
     * Mong muốn: Hệ thống hiển thị trang đăng nhập (login.jsp) bằng RequestDispatcher.
     */
    @Test
    public void testDoGet_UserNotLoggedIn_SessionNull() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        // Định nghĩa hành vi: Lấy session trả về null (không tồn tại session)
        when(request.getSession(false)).thenReturn(null);
        // Định nghĩa hành vi: Lấy bộ chuyển tiếp giao diện jsp đăng nhập
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doGet(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        // Xác minh dispatcher đã gọi lệnh forward để render ra giao diện login.jsp
        verify(dispatcher).forward(request, response);
        // Xác minh KHÔNG chuyển hướng redirect
        verify(response, never()).sendRedirect(anyString());
    }

    /**
     * Kịch bản: Người dùng truy cập bằng GET, Session tồn tại nhưng thuộc tính "user" bị trống.
     * Mong muốn: Hiển thị giao diện đăng nhập jsp.
     */
    @Test
    public void testDoGet_UserNotLoggedIn_SessionExistsButUserAttributeNull() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        // Session tồn tại nhưng chưa lưu tên đăng nhập "user"
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(null);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doGet(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        verify(dispatcher).forward(request, response);
        verify(response, never()).sendRedirect(anyString());
    }

    /**
     * Kịch bản: Đăng nhập thành công bằng TÊN ĐĂNG NHẬP (Username) với tài khoản có vai trò "user".
     * Mong muốn: Session lưu các thông tin tương ứng và chuyển hướng người dùng sang trang phòng chờ (/lobby).
     */
    @Test
    public void testDoPost_LoginSuccess_UserRole() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        // Định nghĩa tham số gửi lên từ form đăng nhập
        when(request.getParameter("identifier")).thenReturn("john_doe");
        when(request.getParameter("password")).thenReturn("password123");

        // Tạo đối tượng thực thể User giả lập trong cơ sở dữ liệu
        User testUser = new User();
        testUser.setUsername("john_doe");
        // Mã hóa mật khẩu gốc bằng BCrypt
        testUser.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));
        testUser.setRole("user");
        testUser.setFullName("John Doe");

        // Giả định: Tìm kiếm theo tên đăng nhập trả về đúng testUser
        when(mockUserDAO.findByUsername("john_doe")).thenReturn(testUser);
        when(request.getSession(true)).thenReturn(session);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doPost(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        // Xác minh các thông tin định danh được lưu đầy đủ vào session
        verify(session).setAttribute("user", "john_doe");
        verify(session).setAttribute("role", "user");
        verify(session).setAttribute("displayName", "John Doe");
        // Xác minh chuyển hướng tới trang /lobby của người chơi
        verify(response).sendRedirect("/go_chess_war/lobby");
    }

    /**
     * Kịch bản: Đăng nhập thành công bằng địa chỉ EMAIL của người chơi.
     * Mong muốn: LoginServlet tự nhận biết đăng nhập qua Email, truy vấn cơ sở dữ liệu theo email
     * và chuyển hướng người chơi đến trang phòng chờ (/lobby).
     */
    @Test
    public void testDoPost_LoginSuccess_Email() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        // Giả lập người dùng nhập địa chỉ email vào ô Tên đăng nhập
        when(request.getParameter("identifier")).thenReturn("john@gmail.com");
        when(request.getParameter("password")).thenReturn("password123");

        // Cấu hình đối tượng User đại diện
        User testUser = new User();
        testUser.setUsername("john_doe");
        testUser.setEmail("john@gmail.com");
        testUser.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));
        testUser.setRole("user");
        testUser.setFullName("John Doe");

        // Giả lập logic tìm kiếm:
        // 1. Tìm theo username trả về null (do người dùng nhập email)
        when(mockUserDAO.findByUsername("john@gmail.com")).thenReturn(null);
        // 2. Tìm theo email trả về đúng testUser
        when(mockUserDAO.findByEmail("john@gmail.com")).thenReturn(testUser);
        
        when(request.getSession(true)).thenReturn(session);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doPost(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        // Xác định session đã lưu đúng thông tin tài khoản john_doe
        verify(session).setAttribute("user", "john_doe");
        verify(session).setAttribute("role", "user");
        verify(session).setAttribute("displayName", "John Doe");
        verify(response).sendRedirect("/go_chess_war/lobby");
    }

    /**
     * Kịch bản: Đăng nhập thành công bằng TÊN ĐĂNG NHẬP với tài khoản quản trị viên "admin".
     * Mong muốn: Session lưu trữ quyền và chuyển hướng admin tới trang quản trị (/admin/dashboard).
     */
    @Test
    public void testDoPost_LoginSuccess_AdminRole() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getParameter("identifier")).thenReturn("admin_user");
        when(request.getParameter("password")).thenReturn("adminpass");

        User testUser = new User();
        testUser.setUsername("admin_user");
        testUser.setPassword(BCrypt.hashpw("adminpass", BCrypt.gensalt()));
        testUser.setRole("admin");
        testUser.setFullName("System Admin");

        when(mockUserDAO.findByUsername("admin_user")).thenReturn(testUser);
        when(request.getSession(true)).thenReturn(session);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doPost(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        verify(session).setAttribute("user", "admin_user");
        verify(session).setAttribute("role", "admin");
        verify(session).setAttribute("displayName", "System Admin");
        // Xác minh chuyển hướng về trang dashboard quản trị viên
        verify(response).sendRedirect("/go_chess_war/admin/dashboard");
    }

    /**
     * Kịch bản: Đăng nhập thất bại do nhập sai mật khẩu đăng nhập.
     * Mong muốn: Trả về lỗi errorMsg, chuyển hướng quay lại trang jsp đăng nhập và không khởi tạo session.
     */
    @Test
    public void testDoPost_LoginFailure_WrongPassword() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getParameter("identifier")).thenReturn("john_doe");
        when(request.getParameter("password")).thenReturn("wrongpassword");

        User testUser = new User();
        testUser.setUsername("john_doe");
        testUser.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));

        // Tên đăng nhập khớp, tìm được user trên DB
        when(mockUserDAO.findByUsername("john_doe")).thenReturn(testUser);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doPost(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        // Xác minh đã gán thông tin báo lỗi tương ứng
        verify(request).setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
        verify(dispatcher).forward(request, response);
        // Đảm bảo không tạo session và không gọi redirect
        verify(request, never()).getSession(anyBoolean());
        verify(response, never()).sendRedirect(anyString());
    }

    /**
     * Kịch bản: Đăng nhập thất bại do không tìm thấy tài khoản (username và email đều không khớp).
     * Mong muốn: Báo lỗi và quay lại trang đăng nhập jsp.
     */
    @Test
    public void testDoPost_LoginFailure_UserNotFound() throws ServletException, IOException {
        // BƯỚC 1: Giả lập (Mocking / Setup)
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getParameter("identifier")).thenReturn("unknown_user");
        when(request.getParameter("password")).thenReturn("anypassword");

        // Tìm theo username và email đều trả về null (không tồn tại tài khoản)
        when(mockUserDAO.findByUsername("unknown_user")).thenReturn(null);
        when(mockUserDAO.findByEmail("unknown_user")).thenReturn(null);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        // BƯỚC 2: Chạy kiểm thử (Run Test)
        loginServlet.doPost(request, response);

        // BƯỚC 3: Kiểm chứng (Verifying)
        verify(request).setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
        verify(dispatcher).forward(request, response);
        verify(request, never()).getSession(anyBoolean());
        verify(response, never()).sendRedirect(anyString());
    }
}
