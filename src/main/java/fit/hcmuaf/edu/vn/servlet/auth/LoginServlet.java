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
        // Alternative Flow: 1.1.a. Người dùng đã đăng nhập từ trước
        // Hệ thống phát hiện Session đã tồn tại và hợp lệ
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Tự động chuyển hướng người dùng về thẳng phòng chờ (/lobby)
            resp.sendRedirect(req.getContextPath() + "/lobby");
            return;
        }
        // Hiển thị giao diện trang đăng nhập (chuẩn bị cho bước 1.1)
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
        // Basic Flow: 1.2. Gửi yêu cầu
        // Giao diện gửi yêu cầu POST chứa thông tin định danh và mật khẩu đến LoginServlet
        String identifier = req.getParameter("identifier");
        String password = req.getParameter("password");
        
        UserDAO userDAO = getUserDAO();
        
        // Basic Flow: 1.3. Kiểm tra tài khoản
        // 1.3.1. Tìm kiếm người dùng theo tên đăng nhập
        User user = userDAO.findByUsername(identifier);
        
        // 1.3.1. Nếu không tìm thấy, tiếp tục tìm kiếm theo địa chỉ email
        if (user == null) {
            user = userDAO.findByEmail(identifier);
        }
        
        // (1.3.2. Cơ sở dữ liệu trả về thông tin người dùng tương ứng được xử lý ngầm trong DAO)
        
        // 1.3.3. So sánh mật khẩu người dùng nhập vào với mật khẩu đã mã hóa bằng BCrypt
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            // Basic Flow: 1.4. Tạo Session
            // Khi mật khẩu xác thực đúng, khởi tạo một HttpSession mới
            HttpSession session = req.getSession(true);
            
            // Lưu các thuộc tính: tên đăng nhập, quyền hạn (role) và tên hiển thị
            session.setAttribute("user", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("displayName", user.getFullName());
            
            // Basic Flow: 1.5. Kết thúc và Chuyển hướng
            // Hệ thống kiểm tra quyền hạn và chuyển hướng
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/lobby");
            }
        } else {
            // Bao gồm xử lý cho 2 trường hợp:
            // Exception Flow: 1.4.a. Sai thông tin định danh (User == null)
            // Alternative Flow: 1.3.a. Sai thông tin đăng nhập (Xác thực BCrypt thất bại)
            
            // 1.3.a.1 / 1.4.a: Thiết lập thông báo lỗi
            req.setAttribute("errorMsg", "Tên đăng nhập hoặc mật khẩu không đúng");
            
            // 1.3.a.2 / 1.4.a: Hệ thống chuyển hướng trả lại giao diện trang đăng nhập kèm thông báo lỗi
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
