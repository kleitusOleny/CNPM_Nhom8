package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.GameMove;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class RoomDAO {
    private EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();

    public void save(GameRoom room) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(room);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    public List<GameRoom> findAvailableRooms() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT r FROM GameRoom r WHERE r.status = 'WAITING'", GameRoom.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
    
    public GameRoom findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT r FROM GameRoom r " +
                    "LEFT JOIN FETCH r.blackPlayer " +
                    "LEFT JOIN FETCH r.whitePlayer " +
                    "WHERE r.id = :id", GameRoom.class)
                    .setParameter("id", id)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    public void update(GameRoom room) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(room);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    public void saveMove(GameMove move) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(move);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    public List<GameMove> getMovesByRoomId(Long roomId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT m FROM GameMove m WHERE m.room.id = :roomId ORDER BY m.moveOrder ASC", GameMove.class)
                    .setParameter("roomId", roomId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<GameRoom> findWithPagination(int page, int size, String statusFilter) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT r FROM GameRoom r LEFT JOIN FETCH r.blackPlayer LEFT JOIN FETCH r.whitePlayer";
            if (statusFilter != null && !statusFilter.isEmpty()) {
                jpql += " WHERE r.status = :status";
            }
            jpql += " ORDER BY r.createdAt DESC";
            
            var query = em.createQuery(jpql, GameRoom.class);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                query.setParameter("status", statusFilter);
            }
            
            return query.setFirstResult((page - 1) * size)
                    .setMaxResults(size)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long countGames(String statusFilter) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT COUNT(r) FROM GameRoom r";
            if (statusFilter != null && !statusFilter.isEmpty()) {
                jpql += " WHERE r.status = :status";
            }
            var query = em.createQuery(jpql, Long.class);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                query.setParameter("status", statusFilter);
            }
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public void deleteRoom(Long roomId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            GameRoom room = em.find(GameRoom.class, roomId);
            if (room != null) {
                em.remove(room);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void deleteMoves(Long roomId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.createQuery("DELETE FROM GameMove m WHERE m.room.id = :roomId")
                    .setParameter("roomId", roomId)
                    .executeUpdate();
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void removeMoveAt(Long roomId, int x, int y) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Query query = em.createQuery("DELETE FROM GameMove m WHERE m.room.id = :roomId AND m.x = :x AND m.y = :y");
            query.setParameter("roomId", roomId);
            query.setParameter("x", x);
            query.setParameter("y", y);
            query.executeUpdate();
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<GameRoom> findWithFilters(int page, int size, java.util.Map<String, Object> filters) {
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT r FROM GameRoom r LEFT JOIN FETCH r.blackPlayer LEFT JOIN FETCH r.whitePlayer WHERE 1=1");
            applyFilters(jpql, filters);
            jpql.append(" ORDER BY r.createdAt DESC");

            TypedQuery<GameRoom> query = em.createQuery(jpql.toString(), GameRoom.class);
            setParameters(query, filters);

            return query.setFirstResult((page - 1) * size)
                    .setMaxResults(size)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long countWithFilters(java.util.Map<String, Object> filters) {
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(r) FROM GameRoom r WHERE 1=1");
            applyFilters(jpql, filters);

            TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
            setParameters(query, filters);

            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    private void applyFilters(StringBuilder jpql, java.util.Map<String, Object> filters) {
        if (filters.get("id") != null) jpql.append(" AND r.id = :id");
        if (filters.get("status") != null) jpql.append(" AND r.status = :status");
        if (filters.get("boardSize") != null) jpql.append(" AND r.boardSize = :boardSize");
        if (filters.get("result") != null) jpql.append(" AND r.result LIKE :result");
        if (filters.get("date") != null) jpql.append(" AND FUNCTION('DATE', r.createdAt) = :date");
        if (filters.get("player") != null) {
            jpql.append(" AND (r.blackPlayer.fullName LIKE :player OR r.whitePlayer.fullName LIKE :player OR r.blackPlayer.username LIKE :player OR r.whitePlayer.username LIKE :player)");
        }
    }

    private void setParameters(Query query, java.util.Map<String, Object> filters) {
        if (filters.get("id") != null) query.setParameter("id", filters.get("id"));
        if (filters.get("status") != null) query.setParameter("status", filters.get("status"));
        if (filters.get("boardSize") != null) query.setParameter("boardSize", filters.get("boardSize"));
        if (filters.get("result") != null) query.setParameter("result", "%" + filters.get("result") + "%");
        if (filters.get("date") != null) query.setParameter("date", filters.get("date"));
        if (filters.get("player") != null) query.setParameter("player", "%" + filters.get("player") + "%");
    }
    
    public void finishGame(Long roomId, String result) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            GameRoom room = em.find(GameRoom.class, roomId);
            if (room != null) {
                room.setStatus("FINISHED");
                room.setResult(result);
                // Bạn có thể tính toán duration ở đây nếu cần
                em.merge(room);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}