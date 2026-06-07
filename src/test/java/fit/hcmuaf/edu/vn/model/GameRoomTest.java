package fit.hcmuaf.edu.vn.model;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class GameRoomTest {

    @Test
    public void testGameRoomGettersAndSetters() {
        GameRoom room = new GameRoom();
        
        User blackPlayer = new User();
        blackPlayer.setUsername("player1");
        
        User whitePlayer = new User();
        whitePlayer.setUsername("player2");

        Date now = new Date();
        List<GameMove> moves = new ArrayList<>();
        GameMove move1 = new GameMove();
        moves.add(move1);

        room.setId(100L);
        room.setRoomName("Ván đấu thế kỷ");
        room.setPassword("1234");
        room.setBoardSize(19);
        room.setTimeControl("30m + 3x30s");
        room.setStatus("PLAYING");
        room.setBlackPlayer(blackPlayer);
        room.setWhitePlayer(whitePlayer);
        room.setResult("Đen thắng");
        room.setCreatedAt(now);
        room.setMoves(moves);

        assertEquals(100L, room.getId());
        assertEquals("Ván đấu thế kỷ", room.getRoomName());
        assertEquals("1234", room.getPassword());
        assertEquals(19, room.getBoardSize());
        assertEquals("30m + 3x30s", room.getTimeControl());
        assertEquals("PLAYING", room.getStatus());
        assertEquals(blackPlayer, room.getBlackPlayer());
        assertEquals(whitePlayer, room.getWhitePlayer());
        assertEquals("Đen thắng", room.getResult());
        assertEquals(now, room.getCreatedAt());
        assertEquals(1, room.getMoves().size());
        assertEquals(moves, room.getMoves());
    }
}
