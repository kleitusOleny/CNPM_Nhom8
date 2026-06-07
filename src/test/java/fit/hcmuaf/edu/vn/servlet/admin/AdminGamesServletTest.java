package fit.hcmuaf.edu.vn.servlet.admin;

import fit.hcmuaf.edu.vn.dto.GamePageDTO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import fit.hcmuaf.edu.vn.service.GameService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedConstruction;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Lớp kiểm thử cho {@link AdminGamesServlet} - Servlet quản lý danh sách ván đấu.
 * <p>
 */
public class AdminGamesServletTest {

    // =========================================================
    // MOCK OBJECTS - Giả lập tầng HTTP và Service
    // =========================================================
    private HttpServletRequest req;
    private HttpServletResponse resp;
    private HttpSession session;
    private RequestDispatcher dispatcher;
    private AdminGamesServlet servlet;

    @BeforeEach
    public void setUp() throws Exception {
        req        = mock(HttpServletRequest.class);
        resp       = mock(HttpServletResponse.class);
        session    = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);

        // Session mặc định: đã đăng nhập với vai trò admin
        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("role")).thenReturn("admin");
        when(req.getContextPath()).thenReturn("");
        when(req.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        servlet = new AdminGamesServlet();
    }

    // =========================================================
    // TEST: Phân quyền (Authorization)
    // =========================================================

    /**
     * Kiểm tra chặn truy cập khi chưa đăng nhập (session null).
     * <p>
     * Input: GET /admin/games, không có session.
     * Output: Redirect về trang /login.
     */
    @Test
    public void testDoGet_NoSession_RedirectsToLogin() throws Exception {
        when(req.getSession(false)).thenReturn(null);

        servlet.doGet(req, resp);

        verify(resp).sendRedirect(contains("/login"));
    }

    /**
     * Kiểm tra chặn truy cập khi đăng nhập với vai trò user thường (không phải admin).
     * <p>
     * Input: GET /admin/games, session với role="user".
     * Output: Redirect về trang /login.
     */
    @Test
    public void testDoGet_NonAdminRole_RedirectsToLogin() throws Exception {
        when(session.getAttribute("role")).thenReturn("user");

        servlet.doGet(req, resp);

        verify(resp).sendRedirect(contains("/login"));
    }

    /**
     * Kiểm tra chặn POST khi không có quyền admin.
     * <p>
     * Input: POST /admin/games, session với role="user".
     * Output: HTTP 403 Forbidden.
     */
    @Test
    public void testDoPost_NonAdminRole_ReturnsForbidden() throws Exception {
        when(session.getAttribute("role")).thenReturn("user");

        servlet.doPost(req, resp);

        verify(resp).sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    // =========================================================
    // TEST: doGet - Hiển thị danh sách ván đấu
    // =========================================================

    /**
     * Kiểm tra hiển thị danh sách ván đấu khi không có bộ lọc.
     * <p>
     * Input: GET /admin/games, không có tham số lọc, admin đã đăng nhập.
     * Output:
     * - setAttribute("pageData", ...) được gọi để đưa dữ liệu ra view.
     * - Forward đến /views/admin/games.jsp.
     */
    @Test
    public void testDoGet_ListGames_NoFilter_ForwardsToGamesJsp() throws Exception {
        // Không có action nào -> listGames()
        when(req.getParameter("action")).thenReturn(null);
        when(req.getParameter("page")).thenReturn(null);
        when(req.getParameter("gameId")).thenReturn(null);
        when(req.getParameter("status")).thenReturn(null);
        when(req.getParameter("boardSize")).thenReturn(null);
        when(req.getParameter("result")).thenReturn(null);
        when(req.getParameter("date")).thenReturn(null);
        when(req.getParameter("player")).thenReturn(null);

        GameRoom room = new GameRoom();
        room.setId(1L);
        room.setStatus("FINISHED");
        GamePageDTO pageDTO = new GamePageDTO(List.of(room), 1, 1, 1L);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.getGamesPage(eq(1), eq(10), anyMap())).thenReturn(pageDTO);
        })) {
            servlet.doGet(req, resp);

            verify(req).setAttribute(eq("pageData"), any(GamePageDTO.class));
            verify(dispatcher).forward(req, resp);
        }
    }

    /**
     * Kiểm tra hiển thị danh sách ván đấu khi lọc theo status=FINISHED.
     * <p>
     * Input: GET /admin/games?status=FINISHED.
     * Output: Bộ lọc được truyền vào GameService, forward đến games.jsp.
     */
    @Test
    public void testDoGet_ListGames_FilterByStatus_CallsServiceWithFilter() throws Exception {
        when(req.getParameter("action")).thenReturn(null);
        when(req.getParameter("page")).thenReturn("1");
        when(req.getParameter("gameId")).thenReturn(null);
        when(req.getParameter("status")).thenReturn("FINISHED");
        when(req.getParameter("boardSize")).thenReturn(null);
        when(req.getParameter("result")).thenReturn(null);
        when(req.getParameter("date")).thenReturn(null);
        when(req.getParameter("player")).thenReturn(null);

        GamePageDTO pageDTO = new GamePageDTO(new ArrayList<>(), 1, 0, 0L);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.getGamesPage(eq(1), eq(10), argThat(filters ->
                    "FINISHED".equals(filters.get("status"))
            ))).thenReturn(pageDTO);
        })) {
            servlet.doGet(req, resp);

            // Xác nhận GameService đã được gọi với filter status=FINISHED
            GameService mockSvc = mockedService.constructed().get(0);
            verify(mockSvc).getGamesPage(eq(1), eq(10), argThat(filters ->
                    "FINISHED".equals(filters.get("status"))
            ));
        }
    }

    /**
     * Kiểm tra hiển thị danh sách khi trang là 2 (phân trang).
     * <p>
     * Input: GET /admin/games?page=2.
     * Output: GameService được gọi với page=2.
     */
    @Test
    public void testDoGet_ListGames_Page2_CallsServiceWithPage2() throws Exception {
        when(req.getParameter("action")).thenReturn(null);
        when(req.getParameter("page")).thenReturn("2");
        when(req.getParameter("gameId")).thenReturn(null);
        when(req.getParameter("status")).thenReturn(null);
        when(req.getParameter("boardSize")).thenReturn(null);
        when(req.getParameter("result")).thenReturn(null);
        when(req.getParameter("date")).thenReturn(null);
        when(req.getParameter("player")).thenReturn(null);

        GamePageDTO pageDTO = new GamePageDTO(new ArrayList<>(), 2, 3, 25L);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.getGamesPage(eq(2), eq(10), anyMap())).thenReturn(pageDTO);
        })) {
            servlet.doGet(req, resp);

            GameService mockSvc = mockedService.constructed().get(0);
            verify(mockSvc).getGamesPage(eq(2), eq(10), anyMap());
        }
    }

    /**
     * Kiểm tra hiển thị danh sách khi lọc theo gameId cụ thể.
     * <p>
     * Input: GET /admin/games?gameId=5.
     * Output: Filter id=5L được truyền vào GameService.
     */
    @Test
    public void testDoGet_ListGames_FilterByGameId_ParsesLong() throws Exception {
        when(req.getParameter("action")).thenReturn(null);
        when(req.getParameter("page")).thenReturn(null);
        when(req.getParameter("gameId")).thenReturn("5");
        when(req.getParameter("status")).thenReturn(null);
        when(req.getParameter("boardSize")).thenReturn(null);
        when(req.getParameter("result")).thenReturn(null);
        when(req.getParameter("date")).thenReturn(null);
        when(req.getParameter("player")).thenReturn(null);

        GamePageDTO pageDTO = new GamePageDTO(new ArrayList<>(), 1, 0, 0L);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.getGamesPage(eq(1), eq(10), argThat(f -> Long.valueOf(5L).equals(f.get("id")))))
                    .thenReturn(pageDTO);
        })) {
            servlet.doGet(req, resp);

            GameService mockSvc = mockedService.constructed().get(0);
            verify(mockSvc).getGamesPage(eq(1), eq(10), argThat(f ->
                    Long.valueOf(5L).equals(f.get("id"))
            ));
        }
    }

    // =========================================================
    // TEST: doGet - Xem chi tiết ván đấu (action=detail)
    // =========================================================

    /**
     * Kiểm tra xem chi tiết ván đấu tồn tại.
     * <p>
     * Input: GET /admin/games?action=detail&id=1.
     * Output:
     * - setAttribute("room", GameRoom) được gọi.
     * - Forward đến /views/admin/game-detail.jsp.
     */
    @Test
    public void testDoGet_DetailAction_ExistingRoom_ForwardsToDetailJsp() throws Exception {
        when(req.getParameter("action")).thenReturn("detail");
        when(req.getParameter("id")).thenReturn("1");

        GameRoom room = new GameRoom();
        room.setId(1L);
        room.setStatus("FINISHED");
        room.setMoves(new ArrayList<>());

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.getGameById(1L)).thenReturn(room);
            when(mock.getFullGameSGF(room)).thenReturn("(;FF[4]GM[1])");
        })) {
            servlet.doGet(req, resp);

            verify(req).setAttribute(eq("room"), eq(room));
            verify(req).setAttribute(eq("sgfData"), anyString());
            verify(dispatcher).forward(req, resp);
        }
    }

    /**
     * Kiểm tra xem chi tiết ván đấu không tồn tại.
     * <p>
     * Input: GET /admin/games?action=detail&id=9999.
     * Output: sendError 404 Not Found.
     */
    @Test
    public void testDoGet_DetailAction_NotExistingRoom_Returns404() throws Exception {
        when(req.getParameter("action")).thenReturn("detail");
        when(req.getParameter("id")).thenReturn("9999");

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.getGameById(9999L)).thenReturn(null);
        })) {
            servlet.doGet(req, resp);

            verify(resp).sendError(eq(HttpServletResponse.SC_NOT_FOUND), anyString());
        }
    }

    /**
     * Kiểm tra xem chi tiết khi không truyền id.
     * <p>
     * Input: GET /admin/games?action=detail (không có tham số id).
     * Output: Redirect về /admin/games.
     */
    @Test
    public void testDoGet_DetailAction_NoId_RedirectsToList() throws Exception {
        when(req.getParameter("action")).thenReturn("detail");
        when(req.getParameter("id")).thenReturn(null);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class)) {
            servlet.doGet(req, resp);

            verify(resp).sendRedirect(contains("/admin/games"));
        }
    }

    // =========================================================
    // TEST: doPost - Kiểm tra trước khi xóa (action=checkDelete)
    // =========================================================

    /**
     * Kiểm tra ván đấu có thể xóa được (không phải IN_PROGRESS).
     * <p>
     * Input: POST /admin/games?action=checkDelete&id=1, ván có status=FINISHED.
     * Output: HTTP 200 OK.
     */
    @Test
    public void testDoPost_CheckDelete_FinishedGame_Returns200() throws Exception {
        when(req.getParameter("action")).thenReturn("checkDelete");
        when(req.getParameter("id")).thenReturn("1");

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.checkStatus(1L)).thenReturn("FINISHED");
        })) {
            servlet.doPost(req, resp);

            verify(resp).setStatus(HttpServletResponse.SC_OK);
        }
    }

    /**
     * Kiểm tra ván đấu đang diễn ra không thể xóa.
     * <p>
     * Input: POST /admin/games?action=checkDelete&id=3, ván có status=IN_PROGRESS.
     * Output: HTTP 403 Forbidden kèm thông báo lỗi.
     */
    @Test
    public void testDoPost_CheckDelete_InProgressGame_Returns403() throws Exception {
        when(req.getParameter("action")).thenReturn("checkDelete");
        when(req.getParameter("id")).thenReturn("3");

        StringWriter sw = new StringWriter();
        when(resp.getWriter()).thenReturn(new PrintWriter(sw));

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.checkStatus(3L)).thenReturn("IN_PROGRESS");
        })) {
            servlet.doPost(req, resp);

            verify(resp).setStatus(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    /**
     * Kiểm tra khi ID ván đấu không tồn tại trong DB (checkDelete).
     * <p>
     * Input: POST /admin/games?action=checkDelete&id=9999, GameService trả về null.
     * Output: HTTP 404 Not Found.
     */
    @Test
    public void testDoPost_CheckDelete_NotExistingGame_Returns404() throws Exception {
        when(req.getParameter("action")).thenReturn("checkDelete");
        when(req.getParameter("id")).thenReturn("9999");

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            when(mock.checkStatus(9999L)).thenReturn(null);
        })) {
            servlet.doPost(req, resp);

            verify(resp).setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // =========================================================
    // TEST: doPost - Xóa ván đấu (action=delete)
    // =========================================================

    /**
     * Kiểm tra xóa ván đấu thành công.
     * <p>
     * Input: POST /admin/games?action=delete&id=1, admin đã đăng nhập.
     * Output: HTTP 200 OK sau khi xóa thành công.
     */
    @Test
    public void testDoPost_DeleteGame_Success_Returns200() throws Exception {
        when(req.getParameter("action")).thenReturn("delete");
        when(req.getParameter("id")).thenReturn("1");

        User adminUser = new User();
        adminUser.setId(99L);
        when(req.getSession()).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(adminUser);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            doNothing().when(mock).deleteGameTx(eq(1L), eq(99L));
        })) {
            servlet.doPost(req, resp);

            verify(resp).setStatus(HttpServletResponse.SC_OK);
            GameService mockSvc = mockedService.constructed().get(0);
            verify(mockSvc).deleteGameTx(eq(1L), eq(99L));
        }
    }

    /**
     * Kiểm tra xóa ván đấu thất bại khi Service ném exception (ví dụ ván đang diễn ra).
     * <p>
     * Input: POST /admin/games?action=delete&id=3, GameService.deleteGameTx ném Exception.
     * Output: HTTP 400 kèm thông báo lỗi.
     */
    @Test
    public void testDoPost_DeleteGame_ServiceThrowsException_Returns400() throws Exception {
        when(req.getParameter("action")).thenReturn("delete");
        when(req.getParameter("id")).thenReturn("3");

        User adminUser = new User();
        adminUser.setId(1L);
        when(req.getSession()).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(adminUser);

        StringWriter sw = new StringWriter();
        when(resp.getWriter()).thenReturn(new PrintWriter(sw));

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            doThrow(new Exception("Không thể xóa ván đấu đang diễn ra"))
                    .when(mock).deleteGameTx(anyLong(), anyLong());
        })) {
            servlet.doPost(req, resp);

            verify(resp).setStatus(400);
        }
    }

    /**
     * Kiểm tra xóa ván đấu khi session user là null (dùng adminId fallback = 1L).
     * <p>
     * Input: POST /admin/games?action=delete&id=2, session user = null.
     * Output: HTTP 200 OK, deleteGameTx được gọi với adminId=1L (fallback).
     */
    @Test
    public void testDoPost_DeleteGame_NullSessionUser_UsesFallbackAdminId() throws Exception {
        when(req.getParameter("action")).thenReturn("delete");
        when(req.getParameter("id")).thenReturn("2");

        when(req.getSession()).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(null); // Không có user trong session

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class, (mock, ctx) -> {
            doNothing().when(mock).deleteGameTx(eq(2L), eq(1L)); // fallback adminId = 1L
        })) {
            servlet.doPost(req, resp);

            verify(resp).setStatus(HttpServletResponse.SC_OK);
            GameService mockSvc = mockedService.constructed().get(0);
            verify(mockSvc).deleteGameTx(eq(2L), eq(1L));
        }
    }

    /**
     * Kiểm tra doPost khi không có tham số id.
     * <p>
     * Input: POST /admin/games?action=delete (thiếu id).
     * Output: Không gọi deleteGameTx, không crash.
     */
    @Test
    public void testDoPost_DeleteGame_NoId_DoesNothing() throws Exception {
        when(req.getParameter("action")).thenReturn("delete");
        when(req.getParameter("id")).thenReturn(null);

        try (MockedConstruction<GameService> mockedService = mockConstruction(GameService.class)) {
            servlet.doPost(req, resp);

            GameService mockSvc = mockedService.constructed().get(0);
            verify(mockSvc, never()).deleteGameTx(anyLong(), anyLong());
        }
    }
}