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
    private RoomDAO roomDAO = new RoomDAO();
    private EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();

    public GamePageDTO getGamesPage(int page, int size, Map<String, Object> filters) {
        List<GameRoom> games = roomDAO.findWithFilters(page, size, filters);
        long totalGames = roomDAO.countWithFilters(filters);
        int totalPages = (int) Math.ceil((double) totalGames / size);

        return new GamePageDTO(games, page, totalPages, totalGames);
    }

    public GameRoom getGameById(Long id) {
        return roomDAO.findById(id);
    }

    public String checkStatus(Long roomId) {
        GameRoom room = roomDAO.findById(roomId);
        return (room != null) ? room.getStatus() : null;
    }

    public String getFullGameSGF(GameRoom room) {
        if (room == null) return null;
        List<GameMove> moves = roomDAO.getMovesByRoomId(room.getId());
        return SGFParser.convertToSGF(room, moves);
    }

    public void deleteGameTx(Long roomId, Long adminId) throws Exception {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            
            GameRoom room = em.find(GameRoom.class, roomId);
            if (room == null) throw new Exception("Ván đấu không tồn tại");
            if ("IN_PROGRESS".equals(room.getStatus())) throw new Exception("Không thể xóa ván đấu đang diễn ra");

            // Bước 38-39: Xóa Room (Moves tự cascade)
            em.remove(room);

            // Bước 40-41: Ghi log
            AuditLog log = new AuditLog(adminId, "DELETE", "ROOM", roomId);
            em.persist(log);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
