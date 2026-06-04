package fit.hcmuaf.edu.vn.servlet.auth;

import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/lobby");
            return;
        }
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("identifier");
        String password = req.getParameter("password");
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByUsername(username);
        
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("displayName", user.getFullName());
            
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/lobby");
            }
        } else {
            req.setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
