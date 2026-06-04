package fit.hcmuaf.edu.vn.servlet.admin;

import fit.hcmuaf.edu.vn.dto.UserPageDTO;
import fit.hcmuaf.edu.vn.model.User;
import fit.hcmuaf.edu.vn.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Chức năng quản lý người dùng
 */
//@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        // Bảo mật phân quyền hệ thống Admin giống AdminGamesServlet
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (NumberFormatException e) { page = 1; }
        }

        String search = req.getParameter("search");
        String role = req.getParameter("role");

        Map<String, Object> filters = new HashMap<>();
        if (search != null && !search.trim().isEmpty()) filters.put("search", search.trim());
        if (role != null && !role.isEmpty() && !"ALL".equals(role)) filters.put("role", role);

        UserPageDTO pageDTO = userService.getUsersPage(page, PAGE_SIZE, filters);

        req.setAttribute("userPage", pageDTO);
        req.setAttribute("currentSearch", search);
        req.setAttribute("currentRole", role);

        req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long targetId = Long.parseLong(idStr);
            Object userObj = session.getAttribute("user");
            Long adminId = 1L; // Fallback mặc định bảo toàn logic
            if (userObj instanceof User) {
                adminId = ((User) userObj).getId();
            }

            if ("updateRole".equals(action)) {
                String newRole = req.getParameter("role");
                userService.updateUserRoleTx(targetId, newRole, adminId);
                resp.setStatus(HttpServletResponse.SC_OK);
            } else if ("delete".equals(action)) {
                userService.deleteUserTx(targetId, adminId);
                resp.setStatus(HttpServletResponse.SC_OK);
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(e.getMessage());
        }
    }
}