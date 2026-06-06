package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.User;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.*;
import java.util.List;
import java.util.Map;

public class UserDAO {
    // Đồng bộ cấu trúc kết nối DB sử dụng JPAUtil của dự án
    private final EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();

    public void save(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public User findByUsername(String username) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :user", User.class);
            query.setParameter("user", username);
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
            return em.createQuery("SELECT u FROM User u", User.class).getResultList();
        } finally {
            em.close();
        }
    }

    // ==========================================
    // PHẦN THÊM CHO QUẢN LÝ NGƯỜI DÙNG: PHỤC VỤ PHÂN TRANG & BỘ LỌC
    // ==========================================

    public List<User> findWithFilters(int page, int size, Map<String, Object> filters) {
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT u FROM User u WHERE 1=1");
            buildQuery(jpql, filters);
            jpql.append(" ORDER BY u.id DESC");

            TypedQuery<User> query = em.createQuery(jpql.toString(), User.class);
            setParameters(query, filters);

            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public long countWithFilters(Map<String, Object> filters) {
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(u) FROM User u WHERE 1=1");
            buildQuery(jpql, filters);

            Query query = em.createQuery(jpql.toString());
            setParameters(query, filters);
            return (Long) query.getSingleResult();
        } finally {
            em.close();
        }
    }

    private void buildQuery(StringBuilder jpql, Map<String, Object> filters) {
        if (filters.get("role") != null) {
            jpql.append(" AND u.role = :role");
        }
        if (filters.get("search") != null) {
            jpql.append(" AND (u.username LIKE :search OR u.fullName LIKE :search OR u.email LIKE :search)");
        }
    }

    private void setParameters(Query query, Map<String, Object> filters) {
        if (filters.get("role") != null) {
            query.setParameter("role", filters.get("role"));
        }
        if (filters.get("search") != null) {
            query.setParameter("search", "%" + filters.get("search") + "%");
        }
    }
    public User findById(Long id) {
        EntityManager em = emf.createEntityManager();

        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.id = :id",
                    User.class
            );

            query.setParameter("id", id);

            return query.getSingleResult();

        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}