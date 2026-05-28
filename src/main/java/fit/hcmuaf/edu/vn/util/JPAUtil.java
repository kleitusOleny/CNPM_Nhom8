package fit.hcmuaf.edu.vn.util;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {
    private static EntityManagerFactory emf;
    
    static {
        try {
            // Khớp với tên trong persistence.xml
            emf = Persistence.createEntityManagerFactory("TamTheGoPU");
        } catch (Throwable ex) {
            System.err.println("Lỗi khởi tạo EntityManagerFactory: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }
    
    public static EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }
}