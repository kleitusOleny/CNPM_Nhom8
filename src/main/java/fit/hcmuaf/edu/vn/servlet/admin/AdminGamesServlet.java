package fit.hcmuaf.edu.vn.servlet.admin;

import fit.hcmuaf.edu.vn.dto.GamePageDTO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import fit.hcmuaf.edu.vn.service.GameService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

    private void listGames(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pageStr = req.getParameter("page");
        int page = (pageStr == null) ? 1 : Integer.parseInt(pageStr);

        // Lấy các tham số lọc
        String gameId = req.getParameter("gameId");
        String status = req.getParameter("status");
        String boardSize = req.getParameter("boardSize");
        String result = req.getParameter("result");
        String date = req.getParameter("date");
        String player = req.getParameter("player");

        Map<String, Object> filters = new HashMap<>();
        if (gameId != null && !gameId.isEmpty()) filters.put("id", Long.parseLong(gameId));
        if (status != null && !status.isEmpty()) filters.put("status", status);
        if (boardSize != null && !boardSize.isEmpty()) filters.put("boardSize", Integer.parseInt(boardSize));
        if (result != null && !result.isEmpty()) filters.put("result", result);
        if (date != null && !date.isEmpty()) filters.put("date", java.sql.Date.valueOf(date));
        if (player != null && !player.isEmpty()) filters.put("player", player);

        GamePageDTO pageDTO = gameService.getGamesPage(page, PAGE_SIZE, filters);
        
        req.setAttribute("pageData", pageDTO);
        req.setAttribute("filters", filters); // Để giữ lại giá trị trên form
        
        req.getRequestDispatcher("/views/admin/games.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
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
            req.setAttribute("room", room);
            req.getRequestDispatcher("/views/admin/game-detail.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
        }
    }

    private void checkDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) return;
        try {
            Long roomId = Long.parseLong(idStr);
            String status = gameService.checkStatus(roomId);
            
            if ("IN_PROGRESS".equals(status)) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("Ván đấu đang diễn ra, không thể xóa!");
            } else if (status == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            } else {
                resp.setStatus(HttpServletResponse.SC_OK);
            }
        } catch (Exception e) {
            resp.setStatus(500);
        }
    }

    private void deleteGame(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) return;
        try {
            Long roomId = Long.parseLong(idStr);
            User admin = (User) req.getSession().getAttribute("user");
            Long adminId = (admin != null) ? admin.getId() : 1L; 

            gameService.deleteGameTx(roomId, adminId);
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            resp.setStatus(400);
            resp.getWriter().write(e.getMessage());
        }
    }
}
