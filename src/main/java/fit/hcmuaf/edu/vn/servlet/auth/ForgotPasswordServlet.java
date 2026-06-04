package fit.hcmuaf.edu.vn.servlet.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        // TODO: Send reset email
        req.setAttribute("successMsg", "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn");
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }
}
