package fit.hcmuaf.edu.vn.service;

import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.dto.UserPageDTO;
import fit.hcmuaf.edu.vn.model.AuditLog;
import fit.hcmuaf.edu.vn.model.User;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.util.List;
import java.util.Map;

/**
 * Chức năng quản lý người dùng
 */
public class UserService {
    private final UserDAO userDAO = new UserDAO();
    private final EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();

    // Lấy danh sách thành viên kết hợp phân trang
    public UserPageDTO getUsersPage(int page, int size, Map<String, Object> filters) {
        List<User> users = userDAO.findWithFilters(page, size, filters);
        long totalUsers = userDAO.countWithFilters(filters);
        int totalPages = (int) Math.ceil((double) totalUsers / size);

        return new UserPageDTO(users, page, totalPages, totalUsers);
    }

    // Đồng bộ nghiệp vụ Giao dịch (Transaction) + Ghi Log hệ thống của Admin giống GameService
    public void updateUserRoleTx(Long targetUserId, String newRole, Long adminId) throws Exception {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, targetUserId);
            if (user == null) throw new Exception("Thành viên không tồn tại");

            user.setRole(newRole);
            em.merge(user);

            // Ghi nhận hành động cập nhật quyền vào bảng audit_logs
            AuditLog log = new AuditLog(adminId, "UPDATE_ROLE", "USER", targetUserId);
            em.persist(log);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void deleteUserTx(Long targetUserId, Long adminId) throws Exception {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, targetUserId);
            if (user == null) throw new Exception("Thành viên không tồn tại");
            if (targetUserId.equals(adminId)) {
                throw new Exception("Bạn không được phép tự xóa tài khoản của chính mình!");
            }

            em.remove(user);

            // Ghi nhận hành động xóa người dùng vào bảng audit_logs
            AuditLog log = new AuditLog(adminId, "DELETE", "USER", targetUserId);
            em.persist(log);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    public User getUserById(Long id) {
        return userDAO.findById(id);
    }

}