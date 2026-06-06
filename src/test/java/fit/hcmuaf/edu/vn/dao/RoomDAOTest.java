package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

public class RoomDAOTest {

    private RoomDAO roomDAO;
    private EntityManagerFactory emf;
    private EntityManager em;
    private EntityTransaction transaction;
    private MockedStatic<JPAUtil> mockedJPAUtil;

    @BeforeEach
    public void setUp() {
        // Mock các thành phần của Hibernate/JPA
        emf = mock(EntityManagerFactory.class);
        em = mock(EntityManager.class);
        transaction = mock(EntityTransaction.class);

        when(emf.createEntityManager()).thenReturn(em);
        when(em.getTransaction()).thenReturn(transaction);

        // Mock Static hàm lấy kết nối DB của JPAUtil
        mockedJPAUtil = mockStatic(JPAUtil.class);
        mockedJPAUtil.when(JPAUtil::getEntityManagerFactory).thenReturn(emf);

        // Khởi tạo DAO sau khi đã mock Database
        roomDAO = new RoomDAO();
    }

    @AfterEach
    public void tearDown() {
        // Dọn dẹp mock static để không ảnh hưởng các test khác
        mockedJPAUtil.close();
    }

    /**
     * Kiểm tra quy trình lưu một phòng mới vào Database (Save Room).
     * <p>
     * Input: Một đối tượng GameRoom trống.
     * Output: 
     * - Hàm thực thi thành công không ném lỗi.
     * - EntityManager.persist() được gọi chính xác 1 lần với tham số là room vừa tạo.
     * - Đảm bảo luồng Transaction: begin() -> persist() -> commit() -> close() được tuân thủ nghiêm ngặt.
     */
    @Test
    public void testSaveRoom() {
        GameRoom room = new GameRoom();
        
        roomDAO.save(room);
        
        // Kiểm tra xem transaction có được mở, persist (lưu) và commit đúng quy trình không
        verify(em).getTransaction();
        verify(transaction).begin();
        verify(em).persist(room);
        verify(transaction).commit();
        verify(em).close();
    }
    
    /**
     * Kiểm tra truy vấn tìm phòng bằng ID (Find By ID).
     * <p>
     * Tham số đầu vào (Input): ID = 1L.
     * Cấu hình Mock:
     * - Trả về một đối tượng GameRoom có ID = 1L khi truy vấn Jpql được gọi.
     * Kết quả đầu ra (Output):
     * - Hàm trả về đúng đối tượng GameRoom đã setup (ID = 1L).
     * - Đảm bảo kết nối EntityManager được đóng an toàn (close).
     */
    @Test
    @SuppressWarnings("unchecked")
    public void testFindById() {
        GameRoom expectedRoom = new GameRoom();
        expectedRoom.setId(1L);
        
        TypedQuery<GameRoom> query = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(GameRoom.class))).thenReturn(query);
        when(query.setParameter("id", 1L)).thenReturn(query);
        when(query.getSingleResult()).thenReturn(expectedRoom);
        
        GameRoom actualRoom = roomDAO.findById(1L);
        
        assertEquals(expectedRoom, actualRoom, "Phải tìm thấy đúng phòng chơi có ID là 1");
        verify(em).close();
    }

    /**
     * Kiểm tra chức năng cập nhật trạng thái kết thúc trận đấu (Finish Game).
     * <p>
     * Tham số đầu vào (Input):
     * - {@code roomId}: 1L
     * - {@code result}: "Đen thắng"
     * Kịch bản:
     * - Mock DB trả về một phòng (ID = 1L) đang ở trạng thái PLAYING.
     * Kết quả đầu ra (Output):
     * - Đối tượng phòng được thay đổi status thành "FINISHED".
     * - Thuộc tính result được cập nhật thành "Đen thắng".
     * - EntityManager.merge() được gọi để lưu thay đổi xuống Database.
     */
    @Test
    public void testFinishGame() {
        GameRoom room = new GameRoom();
        room.setId(1L);
        room.setStatus("PLAYING");
        
        when(em.find(GameRoom.class, 1L)).thenReturn(room);
        
        // Gọi hàm kết thúc game
        roomDAO.finishGame(1L, "Đen thắng");
        
        // Kiểm tra xem DAO có cập nhật status thành FINISHED và merge vào DB không
        verify(transaction).begin();
        verify(em).merge(room);
        verify(transaction).commit();
        verify(em).close();
        
        assertEquals("FINISHED", room.getStatus(), "Trạng thái phòng phải chuyển thành FINISHED");
        assertEquals("Đen thắng", room.getResult(), "Kết quả ván đấu phải được cập nhật");
    }
}
