package fit.hcmuaf.edu.vn.servlet.auth;

import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ form register.jsp
        String fullName = req.getParameter("fullname");
        String email = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirm_password");
        
        // 2. Kiểm tra logic cơ bản
        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        // 3. Kiểm tra xem username đã tồn tại chưa
        if (userDAO.findByUsername(username) != null) {
            req.setAttribute("errorMsg", "Tên đăng nhập đã tồn tại");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }
        
        // 4. Tạo đối tượng User và lưu vào Database qua JPA
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setUsername(username);
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        newUser.setPassword(hashedPassword);
        newUser.setRole("user");
        newUser.setRank("18 kyu");
        newUser.setElo(1200);
        
        try {
            userDAO.save(newUser);
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
        }
    }
}
