package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class GameServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        // SEQUENCE DIAGRAM: 1.5 Chọn phòng ở sảnh và tham gia (/game/{id})
        String pathInfo = req.getPathInfo(); // Sẽ lấy được ID từ /game/{id}
        if (pathInfo != null && pathInfo.length() > 1) {
            try {
                Long roomId = Long.parseLong(pathInfo.substring(1));
                RoomDAO roomDAO = new RoomDAO();
                GameRoom room = roomDAO.findById(roomId);
                
                if (room != null) {
                    String currentUsername = (String) session.getAttribute("user");
                    
                    // Nếu người vào không phải chủ phòng và phòng chưa có quân trắng
                    if (!room.getBlackPlayer().getUsername().equals(currentUsername) && room.getWhitePlayer() == null) {
                        UserDAO userDAO = new UserDAO();
                        room.setWhitePlayer(userDAO.findByUsername(currentUsername));
                        room.setStatus("PLAYING");
                        // SEQUENCE DIAGRAM: 1.6 update(Thêm WhitePlayer vào phòng)
                        roomDAO.update(room);
                        // SEQUENCE DIAGRAM: 1.7 Cập nhật thành công
                        
                        // Quan trọng: Sau khi update, hãy nạp lại room từ DB để đảm bảo Object có đầy đủ data
                        room = roomDAO.findById(room.getId());
                    }
                    
                    req.setAttribute("currentGame", room);
                    // SEQUENCE DIAGRAM: 1.8 Điều hướng sang bàn cờ (/game/{id})
                    req.getRequestDispatcher("/views/game/board.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/lobby");
    }
}
