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

public class LoginServletTest {

    private LoginServlet loginServlet;
    private UserDAO mockUserDAO;

    @BeforeEach
    public void setUp() {
        mockUserDAO = mock(UserDAO.class);
        // Tạo subclass nặc danh để ghi đè phương thức getUserDAO() nhằm trả về mockUserDAO thay vì kết nối DB thật
        loginServlet = new LoginServlet() {
            @Override
            protected UserDAO getUserDAO() {
                return mockUserDAO;
            }
        };
    }

    @Test
    public void testDoGet_UserAlreadyLoggedIn() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn("existing_user");
        when(request.getContextPath()).thenReturn("/go_chess_war");

        loginServlet.doGet(request, response);

        verify(response).sendRedirect("/go_chess_war/lobby");
        verify(request, never()).getRequestDispatcher(anyString());
    }

    @Test
    public void testDoGet_UserNotLoggedIn_SessionNull() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getSession(false)).thenReturn(null);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        loginServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
        verify(response, never()).sendRedirect(anyString());
    }

    @Test
    public void testDoGet_UserNotLoggedIn_SessionExistsButUserAttributeNull() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(null);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        loginServlet.doGet(request, response);

        verify(dispatcher).forward(request, response);
        verify(response, never()).sendRedirect(anyString());
    }

    @Test
    public void testDoPost_LoginSuccess_UserRole() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getParameter("identifier")).thenReturn("john_doe");
        when(request.getParameter("password")).thenReturn("password123");

        User testUser = new User();
        testUser.setUsername("john_doe");
        testUser.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));
        testUser.setRole("user");
        testUser.setFullName("John Doe");

        when(mockUserDAO.findByUsername("john_doe")).thenReturn(testUser);
        when(request.getSession(true)).thenReturn(session);
        when(request.getContextPath()).thenReturn("/go_chess_war");

        loginServlet.doPost(request, response);

        verify(session).setAttribute("user", "john_doe");
        verify(session).setAttribute("role", "user");
        verify(session).setAttribute("displayName", "John Doe");
        verify(response).sendRedirect("/go_chess_war/lobby");
    }

    @Test
    public void testDoPost_LoginSuccess_AdminRole() throws ServletException, IOException {
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

        loginServlet.doPost(request, response);

        verify(session).setAttribute("user", "admin_user");
        verify(session).setAttribute("role", "admin");
        verify(session).setAttribute("displayName", "System Admin");
        verify(response).sendRedirect("/go_chess_war/admin/dashboard");
    }

    @Test
    public void testDoPost_LoginFailure_WrongPassword() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getParameter("identifier")).thenReturn("john_doe");
        when(request.getParameter("password")).thenReturn("wrongpassword");

        User testUser = new User();
        testUser.setUsername("john_doe");
        testUser.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));

        when(mockUserDAO.findByUsername("john_doe")).thenReturn(testUser);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        loginServlet.doPost(request, response);

        verify(request).setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
        verify(dispatcher).forward(request, response);
        verify(request, never()).getSession(anyBoolean());
        verify(response, never()).sendRedirect(anyString());
    }

    @Test
    public void testDoPost_LoginFailure_UserNotFound() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getParameter("identifier")).thenReturn("unknown_user");
        when(request.getParameter("password")).thenReturn("anypassword");

        when(mockUserDAO.findByUsername("unknown_user")).thenReturn(null);
        when(request.getRequestDispatcher("/views/auth/login.jsp")).thenReturn(dispatcher);

        loginServlet.doPost(request, response);

        verify(request).setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
        verify(dispatcher).forward(request, response);
        verify(request, never()).getSession(anyBoolean());
        verify(response, never()).sendRedirect(anyString());
    }
}
