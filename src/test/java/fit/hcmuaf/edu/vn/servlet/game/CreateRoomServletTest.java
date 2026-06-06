package fit.hcmuaf.edu.vn.servlet.game;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;
public class CreateRoomServletTest {

    private CreateRoomServlet servlet;

    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setup() {

        servlet = new CreateRoomServlet();

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);
    }

    @Test
    void testDoGet_NotLogin_RedirectLogin() throws Exception {

        when(request.getSession(false))
                .thenReturn(null);

        when(request.getContextPath())
                .thenReturn("");

        servlet.doGet(request, response);

        verify(response)
                .sendRedirect("/login");
    }

    @Test
    void testDoGet_Login_ForwardCreateRoomPage() throws Exception {

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

    @Test
    void testDoPost_EmptyRoomName_ShowError() throws Exception {

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

    @Test
    void testDoPost_InvalidBoardSize_ShowError() throws Exception {

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

        verify(dispatcher)
                .forward(request, response);
    }

    @Test
    void testDoPost_InvalidCharacter_ShowError() throws Exception {

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

        verify(dispatcher)
                .forward(request, response);
    }
}

