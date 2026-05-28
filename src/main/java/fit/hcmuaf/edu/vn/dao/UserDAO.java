package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.User;
import jakarta.persistence.*;

import java.util.List;

public class UserDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("TamTheGoPU");
    
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
}