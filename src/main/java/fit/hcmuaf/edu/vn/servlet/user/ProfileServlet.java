package fit.hcmuaf.edu.vn.servlet.user;

import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        // Lấy thông tin user từ DB dựa vào username trong session
        String username = (String) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByUsername(username);
        
        if (user != null) {
            req.setAttribute("userProfile", user);
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        // TODO: Update user in database
        resp.sendRedirect(req.getContextPath() + "/profile?updated=true");
    }
}
