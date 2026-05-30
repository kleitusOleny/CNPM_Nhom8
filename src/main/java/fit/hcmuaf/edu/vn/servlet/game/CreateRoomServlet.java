package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

public class CreateRoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/views/game/create-room.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 1. Lấy dữ liệu từ form
        String roomName = req.getParameter("room_name");
        String password = req.getParameter("room_password");
        int boardSize = Integer.parseInt(req.getParameter("board_size"));
        String mainTime = req.getParameter("main_time");
        String byoYomi = req.getParameter("byo_yomi");
        String username = (String) session.getAttribute("user");

        // 2. Khởi tạo đối tượng GameRoom
        GameRoom room = new GameRoom();
        room.setRoomName(roomName);
        room.setPassword(password != null && !password.isEmpty() ? password : null);
        room.setBoardSize(boardSize);
        room.setTimeControl(mainTime + "m + " + byoYomi);
        room.setStatus("WAITING");

        // 3. Lấy thông tin User hiện tại làm quân Đen (Chủ phòng)
        UserDAO userDAO = new UserDAO();
        User currentUser = userDAO.findByUsername(username);
        room.setBlackPlayer(currentUser);

        // 4. Lưu vào Database thông qua RoomDAO
        RoomDAO roomDAO = new RoomDAO();
        try {
            roomDAO.save(room);
            // 5. Chuyển hướng người dùng vào bàn cờ của phòng vừa tạo
            resp.sendRedirect(req.getContextPath() + "/game/" + room.getId());
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Không thể tạo phòng: " + e.getMessage());
            req.getRequestDispatcher("/views/game/create-room.jsp").forward(req, resp);
        }
    }
    }
}