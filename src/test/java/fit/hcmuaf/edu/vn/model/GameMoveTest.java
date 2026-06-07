package fit.hcmuaf.edu.vn.model;

import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

public class GameMoveTest {

    @Test
    public void testGameMoveGettersAndSetters() {
        GameMove move = new GameMove();
        GameRoom room = new GameRoom();
        room.setId(10L);
        
        Date now = new Date();
        
        move.setId(1L);
        move.setRoom(room);
        move.setPlayerColor("black");
        move.setMoveOrder(5);
        move.setX(3);
        move.setY(4);
        move.setCreatedAt(now);

        assertEquals(1L, move.getId());
        assertEquals(room, move.getRoom());
        assertEquals(10L, move.getRoom().getId());
        assertEquals("black", move.getPlayerColor());
        assertEquals(5, move.getMoveOrder());
        assertEquals(3, move.getX());
        assertEquals(4, move.getY());
        assertEquals(now, move.getCreatedAt());
    }
}
