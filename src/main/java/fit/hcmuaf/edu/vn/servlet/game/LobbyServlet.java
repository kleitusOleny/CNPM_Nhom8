package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class LobbyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        RoomDAO roomDAO = new RoomDAO();
        List<GameRoom> availableRooms = roomDAO.findAvailableRooms();

        req.setAttribute("rooms", availableRooms);
        req.getRequestDispatcher("/views/lobby/lobby.jsp").forward(req, resp);
    }
}
