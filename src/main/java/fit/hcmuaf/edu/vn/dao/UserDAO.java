package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.User;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import java.util.Map;

/**
 * Lớp truy xuất dữ liệu (DAO) cho đối tượng User.
 * Thực hiện các câu lệnh JPA/Hibernate để thêm, đọc và cập nhật thông tin trong Database.
 */
public class UserDAO {
    private final EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();
    
    /**
     * Lưu thông tin người chơi mới vào Database.
     * @param user Đối tượng user cần lưu.
     */
    public void save(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            // ĐĂNG KÝ - Basic Flow: Đăng nhập (Bước 1.4): Tiến hành lưu tài khoản mới vào cơ sở dữ liệu
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    
    /**
     * Tìm kiếm người dùng dựa trên Tên đăng nhập (Username).
     * @param username Tên đăng nhập cần tìm.
     * @return Đối tượng User nếu tồn tại, ngược lại trả về null.
     */
    public User findByUsername(String username) {
        EntityManager em = emf.createEntityManager();
        try {
            // BR2 / BR3: Sử dụng tham số động (:user) để ngăn chặn hoàn toàn lỗi SQL Injection
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :user", User.class);
            // ĐĂNG NHẬP - Basic Flow (Bước 1.3.1): Tìm kiếm người dùng theo tên đăng nhập
            // ĐĂNG KÝ - Quy trình kiểm tra (Bước 1.3.2): Kiểm tra tính duy nhất của Username
            query.setParameter("user", username);
            // (Bước 1.3.2 Đăng nhập / Bước 1.3.3 Đăng ký): Cơ sở dữ liệu trả về thông tin tương ứng
            return query.getSingleResult();
        } catch (NoResultException e) {
            // Trả về null nếu không tìm thấy bản ghi nào khớp
            return null;
        } finally {
            em.close();
        }
    }
    
    /**
     * Tìm kiếm người dùng dựa trên Email.
     * @param email Địa chỉ email cần tìm.
     * @return Đối tượng User nếu tồn tại, ngược lại trả về null.
     */
    public User findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            // BR2: Sử dụng câu truy vấn JPQL an toàn với tham số động tránh SQL Injection
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class);
            // ĐĂNG NHẬP - Basic Flow (Bước 1.3.1): Nếu không tìm thấy theo username, tiếp tục tìm theo địa chỉ email
            // ĐĂNG KÝ - Quy trình kiểm tra (Bước 1.3.2): Kiểm tra tính duy nhất của Email trong DB
            query.setParameter("email", email);
            // (Bước 1.3.2 Đăng nhập / Bước 1.3.3 Đăng ký): Cơ sở dữ liệu trả về thông tin tương ứng
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<User> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            // 1. Thực hiện truy vấn JPQL lấy toàn bộ thực thể User
            return em.createQuery("SELECT u FROM User u", User.class).getResultList();
        } finally {
            em.close();
        }
    }

    
    /**
     * Tìm kiếm danh sách người dùng kết hợp bộ lọc tìm kiếm và phân trang dữ liệu.
     * @param page Số trang hiện tại (1-indexed).
     * @param size Số bản ghi trên mỗi trang.
     * @param filters Map chứa các bộ lọc động (như role, search key).
     * @return Danh sách User khớp với bộ lọc trên trang hiện tại.
     */
    public List<User> findWithFilters(int page, int size, Map<String, Object> filters) {
        EntityManager em = emf.createEntityManager();
        try {
            // 1. Xây dựng động chuỗi JPQL
            StringBuilder jpql = new StringBuilder("SELECT u FROM User u WHERE 1=1");
            buildQuery(jpql, filters);
            jpql.append(" ORDER BY u.id DESC");

            // 2. Khởi tạo câu truy vấn JPQL
            TypedQuery<User> query = em.createQuery(jpql.toString(), User.class);
            setParameters(query, filters);

            // 3. Thiết lập thông số phân trang (Offset và Limit)
            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            
            // 4. Lấy danh sách kết quả phân trang
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Đếm tổng số lượng người chơi khớp với bộ lọc hiện tại.
     * @param filters Map chứa bộ lọc động.
     * @return Tổng số lượng bản ghi thỏa mãn điều kiện.
     */
    public long countWithFilters(Map<String, Object> filters) {
        EntityManager em = emf.createEntityManager();
        try {
            // 1. Xây dựng JPQL đếm số lượng thực thể
            StringBuilder jpql = new StringBuilder("SELECT COUNT(u) FROM User u WHERE 1=1");
            buildQuery(jpql, filters);

            // 2. Truyền tham số lọc và lấy kết quả duy nhất
            Query query = em.createQuery(jpql.toString());
            setParameters(query, filters);
            return (Long) query.getSingleResult();
        } finally {
            em.close();
        }
    }

    // Hàm phụ trợ nối thêm chuỗi JPQL dựa theo các bộ lọc có giá trị
    private void buildQuery(StringBuilder jpql, Map<String, Object> filters) {
        if (filters.get("role") != null) {
            jpql.append(" AND u.role = :role");
        }
        if (filters.get("search") != null) {
            jpql.append(" AND (u.username LIKE :search OR u.fullName LIKE :search OR u.email LIKE :search)");
        }
    }

    // Hàm phụ trợ gán giá trị tham số lọc động
    private void setParameters(Query query, Map<String, Object> filters) {
        if (filters.get("role") != null) {
            query.setParameter("role", filters.get("role"));
        }
        if (filters.get("search") != null) {
            query.setParameter("search", "%" + filters.get("search") + "%");
        }
    }
    
    /**
     * Tìm kiếm người dùng dựa theo Khóa chính ID.
     * @param id Khóa chính cần tìm.
     * @return Đối tượng User tương ứng hoặc null nếu không tồn tại.
     */
    public User findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            // 1. Tạo truy vấn JPQL tìm kiếm bằng ID
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.id = :id", User.class);
            query.setParameter("id", id);
            // 2. Trả về thực thể User
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}