package fit.hcmuaf.edu.vn.servlet.auth;

import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

/**
 * Servlet xử lý yêu cầu Đăng nhập tài khoản (GET và POST).
 */
public class LoginServlet extends HttpServlet {

    /**
     * Xử lý yêu cầu hiển thị giao diện đăng nhập (GET).
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1. Kiểm tra xem người dùng đã đăng nhập chưa từ Session
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Đã đăng nhập -> Tự động chuyển hướng về phòng chờ (lobby)
            resp.sendRedirect(req.getContextPath() + "/lobby");
            return;
        }
        // Chưa đăng nhập -> Chuyển hướng hiển thị trang JSP đăng nhập
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }
    
    /**
     * Phương thức helper trả về đối tượng UserDAO.
     * Cho phép các lớp Unit Test ghi đè và tiêm mock đối tượng DAO.
     */
    protected UserDAO getUserDAO() {
        return new UserDAO();
    }
    
    /**
     * Xử lý yêu cầu gửi thông tin đăng nhập từ form (POST).
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy thông tin định danh (Tên đăng nhập hoặc Email) và mật khẩu từ form gửi lên
        String identifier = req.getParameter("identifier");
        String password = req.getParameter("password");
        
        // 2. Khởi tạo đối tượng UserDAO qua hàm helper
        UserDAO userDAO = getUserDAO();
        
        // 3. Thử tìm kiếm tài khoản theo tên đăng nhập (username)
        User user = userDAO.findByUsername(identifier);
        
        // 4. Nếu không tìm thấy theo username, tiếp tục tìm theo email (đáp ứng đúng nhãn hiển thị "Tên đăng nhập / Email")
        if (user == null) {
            user = userDAO.findByEmail(identifier);
        }
        
        // 5. Xác thực mật khẩu thông qua thư viện bCrypt
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            // Mật khẩu đúng -> Tạo mới Session lưu giữ thông tin đăng nhập
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("displayName", user.getFullName());
            
            // 6. Phân quyền chuyển hướng người dùng dựa theo vai trò (admin hoặc user)
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/lobby");
            }
        } else {
            // Sai mật khẩu hoặc không tồn tại tài khoản -> Báo lỗi và quay lại trang đăng nhập
            req.setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
