package fit.hcmuaf.edu.vn.servlet.admin;

import fit.hcmuaf.edu.vn.dto.GamePageDTO;
import fit.hcmuaf.edu.vn.service.GameService;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/games")
public class AdminGamesServlet extends HttpServlet {
    private GameService gameService = new GameService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra quyền admin
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            showDetail(req, resp);
        } else {
            listGames(req, resp);
        }
    }

    private void listGames(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Phân trang
        String pageStr = req.getParameter("page");
        int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);

        // Tập hợp bộ lọc từ query params
        String gameId    = req.getParameter("gameId");
        String status    = req.getParameter("status");
        String boardSize = req.getParameter("boardSize");
        String result    = req.getParameter("result");
        String date      = req.getParameter("date");
        String player    = req.getParameter("player");

        Map<String, Object> filters = new HashMap<>();
        if (gameId    != null && !gameId.isEmpty())    filters.put("id",        Long.parseLong(gameId));
        if (status    != null && !status.isEmpty())    filters.put("status",    status);
        if (boardSize != null && !boardSize.isEmpty()) filters.put("boardSize", Integer.parseInt(boardSize));
        if (result    != null && !result.isEmpty())    filters.put("result",    result);
        if (date      != null && !date.isEmpty())      filters.put("date",      java.sql.Date.valueOf(date));
        if (player    != null && !player.isEmpty())    filters.put("player",    player);

        // Lấy danh sách ván đấu có phân trang + lọc
        GamePageDTO pageDTO = gameService.getGamesPage(page, PAGE_SIZE, filters);

        // Lấy thống kê tổng quan cho stat cards
        long totalGames    = gameService.countByStatus(null);
        long liveGames     = gameService.countByStatus("IN_PROGRESS");
        long finishedGames = gameService.countByStatus("FINISHED");
        long waitingGames  = gameService.countByStatus("WAITING");

        req.setAttribute("pageData",      pageDTO);
        req.setAttribute("filters",       filters);
        req.setAttribute("statusFilter",  status);
        req.setAttribute("totalGames",    totalGames);
        req.setAttribute("liveGames",     liveGames);
        req.setAttribute("finishedGames", finishedGames);
        req.setAttribute("waitingGames",  waitingGames);

        req.getRequestDispatcher("/views/admin/games.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/games");
            return;
        }

        try {
            Long roomId = Long.parseLong(idStr);
            GameRoom room = gameService.getGameById(roomId);
            if (room == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Ván đấu không tồn tại");
                return;
            }

            String sgf = gameService.getFullGameSGF(room);
            req.setAttribute("sgfData", sgf);
            req.setAttribute("room",    room);
            req.getRequestDispatcher("/views/admin/game-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/games");
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            deleteGame(req, resp);
        } else if ("checkDelete".equals(action)) {
            checkDelete(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ");
        }
    }

    /**
     * Kiểm tra xem ván đấu có thể xóa không (không được xóa ván đang IN_PROGRESS).
     * Trả về HTTP 200 nếu có thể xóa, 403 nếu đang diễn ra, 404 nếu không tồn tại.
     */
    private void checkDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long roomId = Long.parseLong(idStr);
            String roomStatus = gameService.checkStatus(roomId);

            if (roomStatus == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Ván đấu không tồn tại");
            } else if ("IN_PROGRESS".equals(roomStatus)) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("Ván đấu đang diễn ra, không thể xóa!");
            } else {
                resp.setStatus(HttpServletResponse.SC_OK);
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("ID không hợp lệ");
        }
    }

    /**
     * Thực hiện xóa ván đấu (trong transaction: xóa moves → xóa room → ghi audit log).
     */
    private void deleteGame(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long roomId = Long.parseLong(idStr);

            // Lấy adminId từ session (fallback = 1 nếu chưa lưu object)
            HttpSession session = req.getSession(false);
            Object userObj = session != null ? session.getAttribute("user") : null;
            Long adminId = 1L;
            if (userObj instanceof User) {
                adminId = ((User) userObj).getId();
            }

            gameService.deleteGameTx(roomId, adminId);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Xóa thành công");

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("ID không hợp lệ");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(e.getMessage());
        }
    }
}