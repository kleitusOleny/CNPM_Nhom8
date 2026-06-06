package fit.hcmuaf.edu.vn.service;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dto.GamePageDTO;
import fit.hcmuaf.edu.vn.model.AuditLog;
import fit.hcmuaf.edu.vn.model.GameMove;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import fit.hcmuaf.edu.vn.util.SGFParser;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;

import java.util.List;
import java.util.Map;

public class GameService {
    private final RoomDAO roomDAO = new RoomDAO();
    private final EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();

    /**
     * Lấy danh sách ván đấu có phân trang + bộ lọc.
     */
    public GamePageDTO getGamesPage(int page, int size, Map<String, Object> filters) {
        List<GameRoom> games = roomDAO.findWithFilters(page, size, filters);
        long totalGames = roomDAO.countWithFilters(filters);
        int totalPages = (int) Math.ceil((double) totalGames / size);
        return new GamePageDTO(games, totalPages, page, totalGames);
    }

    /**
     * Lấy ván đấu theo ID (kèm blackPlayer, whitePlayer, moves).
     */
    public GameRoom getGameById(Long id) {
        return roomDAO.findById(id);
    }

    /**
     * Kiểm tra trạng thái của ván đấu (dùng trước khi xóa).
     * @return status string hoặc null nếu không tồn tại
     */
    public String checkStatus(Long roomId) {
        GameRoom room = roomDAO.findById(roomId);
        return (room != null) ? room.getStatus() : null;
    }

    /**
     * Đếm số ván đấu theo trạng thái.
     * @param status null = đếm tất cả, còn lại = "WAITING" | "IN_PROGRESS" | "FINISHED"
     */
    public long countByStatus(String status) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT COUNT(r) FROM GameRoom r";
            if (status != null && !status.isEmpty()) {
                jpql += " WHERE r.status = :status";
            }
            var query = em.createQuery(jpql, Long.class);
            if (status != null && !status.isEmpty()) {
                query.setParameter("status", status);
            }
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    /**
     * Tạo chuỗi SGF từ danh sách nước đi của ván đấu.
     */
    public String getFullGameSGF(GameRoom room) {
        if (room == null) return null;
        List<GameMove> moves = roomDAO.getMovesByRoomId(room.getId());
        return SGFParser.convertToSGF(room, moves);
    }

    /**
     * Xóa ván đấu trong một transaction duy nhất:
     * GameMove cascade → xóa GameRoom → ghi AuditLog.
     * Ném Exception nếu ván đang IN_PROGRESS.
     */
    public void deleteGameTx(Long roomId, Long adminId) throws Exception {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            GameRoom room = em.find(GameRoom.class, roomId);
            if (room == null) {
                throw new Exception("Ván đấu không tồn tại");
            }
            if ("IN_PROGRESS".equals(room.getStatus())) {
                throw new Exception("Không thể xóa ván đấu đang diễn ra");
            }

            // Cascade ALL trên @OneToMany sẽ tự xóa GameMove
            em.remove(room);

            // Ghi audit log
            AuditLog log = new AuditLog(adminId, "DELETE", "ROOM", roomId);
            em.persist(log);

            em.getTransaction().commit();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
}