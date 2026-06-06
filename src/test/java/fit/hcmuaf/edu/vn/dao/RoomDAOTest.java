package fit.hcmuaf.edu.vn.dao;
import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
public class RoomDAOTest {

    private RoomDAO roomDAO;

    @BeforeEach
    void setup() {
        roomDAO = new RoomDAO();
    }

    @Test
    void testFindAvailableRooms() {

        List<GameRoom> rooms =
                roomDAO.findAvailableRooms();

        assertNotNull(rooms);

        for (GameRoom room : rooms) {
            assertEquals(
                    "WAITING",
                    room.getStatus()
            );
        }
    }

    @Test
    void testFindById_NotFound() {

        GameRoom room =
                roomDAO.findById(-1L);

        assertNull(room);
    }

    @Test
    void testCountGames() {

        long total =
                roomDAO.countGames(null);

        assertTrue(total >= 0);
    }

    @Test
    void testCountGames_WithStatus() {

        long total =
                roomDAO.countGames("WAITING");

        assertTrue(total >= 0);
    }

    @Test
    void testIsUserInRoom() {

        boolean result =
                roomDAO.isUserInRoom(1L);

        assertNotNull(result);
    }

    @Test
    void testFindWithPagination() {

        List<GameRoom> rooms =
                roomDAO.findWithPagination(
                        1,
                        5,
                        "WAITING"
                );

        assertNotNull(rooms);
    }
}

