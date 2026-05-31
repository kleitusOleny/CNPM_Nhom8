package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.AuditLog;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;

public class AuditDAO {
    private EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();

    public void save(AuditLog log) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(log);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
