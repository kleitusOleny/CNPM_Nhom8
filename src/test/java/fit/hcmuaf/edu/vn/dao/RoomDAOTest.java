
package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.mockito.MockedStatic;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/*
 * =========================================================
 * UC4 – ROOM DAO TESTING
 * =========================================================
 *
 * Use Case:
 * - UC4 – Tạo phòng
 *
 * Mục đích:
 * - Kiểm thử database interaction
 * - Kiểm thử persistence layer
 * - Kiểm thử business rule của room
 *
 * Thành phần kiểm thử:
 * - RoomDAO
 *
 * Công nghệ:
 * - JUnit 5
 * - Mockito
 *
 * Loại kiểm thử:
 * - DAO Testing
 * - Integration Testing
 */

public class RoomDAOTest {

    private RoomDAO roomDAO;

    private EntityManagerFactory emf;
    private EntityManager em;
    private EntityTransaction transaction;

    private MockedStatic<JPAUtil> mockedJPAUtil;

    /*
     * =========================================================
     * TEST SETUP
     * =========================================================
     *
     * Mock:
     * - EntityManagerFactory
     * - EntityManager
     * - Transaction
     *
     * Mục đích:
     * - Giả lập môi trường database
     * - Không truy cập DB thật
     */

    @BeforeEach
    public void setUp() {

        emf = mock(EntityManagerFactory.class);

        em = mock(EntityManager.class);

        transaction = mock(EntityTransaction.class);

        when(emf.createEntityManager())
                .thenReturn(em);

        when(em.getTransaction())
                .thenReturn(transaction);

        /*
         * =====================================================
         * MOCK STATIC JPAUTIL
         * =====================================================
         */

        mockedJPAUtil = mockStatic(JPAUtil.class);

        mockedJPAUtil.when(
                JPAUtil::getEntityManagerFactory
        ).thenReturn(emf);

        roomDAO = new RoomDAO();
    }

    @AfterEach
    public void tearDown() {

        /*
         * =====================================================
         * CLEANUP MOCK STATIC
         * =====================================================
         */

        mockedJPAUtil.close();
    }

    /*
     * =========================================================
     * UC4 - TEST CASE DAO01
     * =========================================================
     *
     * Scenario:
     * - Lưu GameRoom mới
     *
     * Expected Result:
     * - persist() được gọi
     * - transaction được commit
     *
     * Testing Type:
     * - Persistence Test
     */

    @Test
    public void testSaveRoom() {

        GameRoom room = new GameRoom();

        roomDAO.save(room);

        verify(transaction).begin();

        verify(em).persist(room);

        verify(transaction).commit();

        verify(em).close();
    }

    /*
     * =========================================================
     * UC4 - TEST CASE DAO02
     * =========================================================
     *
     * Scenario:
     * - Tìm room theo ID
     *
     * Expected Result:
     * - Trả về đúng room
     *
     * Testing Type:
     * - Retrieval Test
     */

    @Test
    @SuppressWarnings("unchecked")
    public void testFindById() {

        GameRoom expectedRoom = new GameRoom();

        expectedRoom.setId(1L);

        TypedQuery<GameRoom> query =
                mock(TypedQuery.class);

        when(em.createQuery(
                anyString(),
                eq(GameRoom.class)
        )).thenReturn(query);

        when(query.setParameter(
                "id",
                1L
        )).thenReturn(query);

        when(query.getSingleResult())
                .thenReturn(expectedRoom);

        GameRoom actualRoom =
                roomDAO.findById(1L);

        assertEquals(
                expectedRoom,
                actualRoom
        );

        verify(em).close();
    }

    /*
     * =========================================================
     * UC4 - TEST CASE DAO03
     * =========================================================
     *
     * Scenario:
     * - Lấy danh sách room WAITING
     *
     * Expected Result:
     * - Danh sách không null
     *
     * Testing Type:
     * - Query Test
     */

    @Test
    @SuppressWarnings("unchecked")
    public void testFindAvailableRooms() {

        TypedQuery<GameRoom> query =
                mock(TypedQuery.class);

        List<GameRoom> expectedRooms =
                new ArrayList<>();

        when(em.createQuery(
                anyString(),
                eq(GameRoom.class)
        )).thenReturn(query);

        when(query.getResultList())
                .thenReturn(expectedRooms);

        List<GameRoom> actualRooms =
                roomDAO.findAvailableRooms();

        assertNotNull(actualRooms);

        verify(em).close();
    }

    /*
     * =========================================================
     * UC4 - TEST CASE DAO04
     * =========================================================
     *
     * Scenario:
     * - User đang ở room khác
     *
     * Business Rule:
     * - Một user chỉ được ở một room
     *
     * Expected Result:
     * - Trả về true
     *
     * Testing Type:
     * - Business Rule Test
     */

    @Test
    @SuppressWarnings("unchecked")
    public void testIsUserInRoom() {

        TypedQuery<Long> query =
                mock(TypedQuery.class);

        when(em.createQuery(
                anyString(),
                eq(Long.class)
        )).thenReturn(query);

        when(query.setParameter(
                "userId",
                1L
        )).thenReturn(query);

        when(query.getSingleResult())
                .thenReturn(1L);

        boolean result =
                roomDAO.isUserInRoom(1L);

        assertTrue(result);

        verify(em).close();
    }

    /*
     * =========================================================
     * UC4 - TEST CASE DAO05
     * =========================================================
     *
     * Scenario:
     * - Kết thúc game
     *
     * Expected Result:
     * - Status chuyển thành FINISHED
     * - Result được cập nhật
     *
     * Testing Type:
     * - Update Test
     */

    @Test
    public void testFinishGame() {

        GameRoom room = new GameRoom();

        room.setId(1L);

        room.setStatus("PLAYING");

        when(em.find(
                GameRoom.class,
                1L
        )).thenReturn(room);

        roomDAO.finishGame(
                1L,
                "Đen thắng"
        );

        verify(transaction).begin();

        verify(em).merge(room);

        verify(transaction).commit();

        verify(em).close();

        assertEquals(
                "FINISHED",
                room.getStatus()
        );

        assertEquals(
                "Đen thắng",
                room.getResult()
        );
    }
}

