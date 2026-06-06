
package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/*
 * =========================================================
 * UC4 – CREATE ROOM SERVLET TESTING
 * =========================================================
 *
 * Use Case:
 * - UC4 – Tạo phòng
 *
 * Mục đích:
 * - Kiểm thử chức năng tạo phòng
 * - Kiểm tra validation
 * - Kiểm tra business rule
 * - Kiểm tra session handling
 * - Kiểm tra redirect flow
 * - Kiểm tra exception flow
 *
 * Thành phần kiểm thử:
 * - CreateRoomServlet
 *
 * Công nghệ:
 * - JUnit 5
 * - Mockito
 *
 * Loại kiểm thử:
 * - Development Testing
 * - Servlet Testing
 * - Component Testing
 */

public class CreateRoomServletTest {

    private CreateRoomServlet servlet;

    private RoomDAO roomDAO;

    private UserDAO userDAO;

    private HttpServletRequest request;

    private HttpServletResponse response;

    private HttpSession session;

    private RequestDispatcher dispatcher;

    /*
     * =========================================================
     * TEST SETUP
     * =========================================================
     *
     * Mock:
     * - DAO
     * - Request
     * - Response
     * - Session
     * - Dispatcher
     */

    @BeforeEach
    public void setUp() throws Exception {

        servlet = new CreateRoomServlet();

        roomDAO = mock(RoomDAO.class);

        userDAO = mock(UserDAO.class);

        request = mock(HttpServletRequest.class);

        response = mock(HttpServletResponse.class);

        session = mock(HttpSession.class);

        dispatcher = mock(RequestDispatcher.class);

        /*
         * =====================================================
         * INJECT MOCK DAO
         * =====================================================
         */

        Field roomDAOField =
                CreateRoomServlet.class
                        .getDeclaredField("roomDAO");

        roomDAOField.setAccessible(true);

        roomDAOField.set(servlet, roomDAO);

        Field userDAOField =
                CreateRoomServlet.class
                        .getDeclaredField("userDAO");

        userDAOField.setAccessible(true);

        userDAOField.set(servlet, userDAO);
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 01
     * =========================================================
     *
     * Scenario:
     * - User chưa đăng nhập
     *
     * Expected Result:
     * - Redirect đến login
     */

    @Test
    public void testDoGet_NotLogin() throws Exception {

        when(request.getSession(false))
                .thenReturn(null);

        when(request.getContextPath())
                .thenReturn("");

        servlet.doGet(request, response);

        verify(response)
                .sendRedirect("/login");
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 02
     * =========================================================
     *
     * Scenario:
     * - User đã đăng nhập
     *
     * Expected Result:
     * - Forward create-room.jsp
     */

    @Test
    public void testDoGet_Login() throws Exception {

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(dispatcher)
                .forward(request, response);
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 03
     * =========================================================
     *
     * Scenario:
     * - Room name rỗng
     *
     * Business Rule:
     * - Tên phòng không được để trống
     *
     * Expected Result:
     * - Hiển thị errorMsg
     */

    @Test
    public void testDoPost_EmptyRoomName()
            throws Exception {

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn("");

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("Tên phòng")
                );

        verify(dispatcher)
                .forward(request, response);
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 04
     * =========================================================
     *
     * Scenario:
     * - Room name vượt quá 50 ký tự
     *
     * Expected Result:
     * - Hiển thị lỗi validation
     */

    @Test
    public void testDoPost_RoomNameTooLong()
            throws Exception {

        String longName =
                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn(longName);

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("50")
                );
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 05
     * =========================================================
     *
     * Scenario:
     * - Room name chứa ký tự đặc biệt
     *
     * Expected Result:
     * - Hiển thị lỗi regex validation
     */

    @Test
    public void testDoPost_InvalidCharacter()
            throws Exception {

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn("@@@###");

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("ký tự")
                );
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 06
     * =========================================================
     *
     * Scenario:
     * - Board size không phải số
     *
     * Expected Result:
     * - Hiển thị lỗi NumberFormatException
     */

    @Test
    public void testDoPost_InvalidBoardSizeFormat()
            throws Exception {

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn("Phong Test");

        when(request.getParameter("board_size"))
                .thenReturn("abc");

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("Kích thước")
                );
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 07
     * =========================================================
     *
     * Scenario:
     * - Board size sai business rule
     *
     * Expected Result:
     * - Hiển thị lỗi validation
     */

    @Test
    public void testDoPost_InvalidBoardSize()
            throws Exception {

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn("Phong Test");

        when(request.getParameter("board_size"))
                .thenReturn("15");

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("Kích thước")
                );
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 08
     * =========================================================
     *
     * Scenario:
     * - User không tồn tại
     *
     * Expected Result:
     * - Hiển thị lỗi
     */

    @Test
    public void testDoPost_UserNotFound()
            throws Exception {

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn("Phong Test");

        when(request.getParameter("board_size"))
                .thenReturn("9");

        when(userDAO.findByUsername("admin"))
                .thenReturn(null);

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("người dùng")
                );
    }

    /*
     * =========================================================
     * UC4 - TEST CASE 09
     * =========================================================
     *
     * Scenario:
     * - User đang ở room khác
     *
     * Expected Result:
     * - Hiển thị lỗi business rule
     */

    @Test
    public void testDoPost_UserAlreadyInRoom()
            throws Exception {

        User user = new User();

        user.setId(1L);

        when(request.getSession(false))
                .thenReturn(session);

        when(session.getAttribute("user"))
                .thenReturn("admin");

        when(request.getParameter("room_name"))
                .thenReturn("Phong Test");

        when(request.getParameter("board_size"))
                .thenReturn("9");

        when(userDAO.findByUsername("admin"))
                .thenReturn(user);

        when(roomDAO.isUserInRoom(1L))
                .thenReturn(true);

        when(request.getRequestDispatcher(anyString()))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request)
                .setAttribute(
                        eq("errorMsg"),
                        contains("phòng khác")
                );
    }
}
