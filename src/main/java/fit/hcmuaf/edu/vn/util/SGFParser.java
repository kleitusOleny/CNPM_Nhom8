package fit.hcmuaf.edu.vn.util;

import fit.hcmuaf.edu.vn.model.GameMove;
import fit.hcmuaf.edu.vn.model.GameRoom;
import java.util.List;

public class SGFParser {
    public static String convertToSGF(GameRoom room, List<GameMove> moves) {
        StringBuilder sgf = new StringBuilder();
        sgf.append("(;GM[1]FF[4]CA[UTF-8]AP[TamTheGo:1.0]KM[6.5]SZ[19]");
        
        String blackName = room.getBlackPlayer() != null ? room.getBlackPlayer().getFullName() : "Unknown";
        String whiteName = room.getWhitePlayer() != null ? room.getWhitePlayer().getFullName() : "Unknown";
        
        sgf.append("PB[").append(blackName).append("]");
        if (room.getBlackPlayer() != null) sgf.append("BR[").append(room.getBlackPlayer().getRank()).append("]");
        
        sgf.append("PW[").append(whiteName).append("]");
        if (room.getWhitePlayer() != null) sgf.append("WR[").append(room.getWhitePlayer().getRank()).append("]");
        
        sgf.append("GN[").append(room.getRoomName()).append("]");
        sgf.append("DT[").append(room.getCreatedAt()).append("]");
        if (room.getResult() != null) sgf.append("RE[").append(room.getResult()).append("]");
        if (room.getDuration() != null) sgf.append("TM[").append(room.getDuration()).append("]");

        for (GameMove move : moves) {
            String color = move.getColor().equalsIgnoreCase("black") ? "B" : "W";
            String coordX = String.valueOf((char) ('a' + move.getX()));
            String coordY = String.valueOf((char) ('a' + move.getY()));
            sgf.append(";").append(color).append("[").append(coordX).append(coordY).append("]");
        }
        
        sgf.append(")");
        return sgf.toString();
    }
}
