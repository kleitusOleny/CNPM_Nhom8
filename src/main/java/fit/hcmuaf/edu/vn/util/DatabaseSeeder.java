package fit.hcmuaf.edu.vn.util;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.GameMove;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import org.mindrot.jbcrypt.BCrypt;

public class DatabaseSeeder {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        RoomDAO roomDAO = new RoomDAO();

        // 1. Tạo tài khoản Admin
        if (userDAO.findByUsername("admin") == null) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(BCrypt.hashpw("admin123", BCrypt.gensalt()));
            admin.setFullName("Quản trị viên");
            admin.setEmail("admin@tamthego.vn");
            admin.setRole("admin");
            admin.setElo(2000);
            admin.setRank("1 dan");
            userDAO.save(admin);
            System.out.println("Đã tạo tài khoản admin/admin123");
        }

        // 2. Tạo tài khoản User 1
        User user1 = userDAO.findByUsername("user1");
        if (user1 == null) {
            user1 = new User();
            user1.setUsername("user1");
            user1.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));
            user1.setFullName("Nguyễn Văn A");
            user1.setEmail("vana@gmail.com");
            user1.setRole("user");
            user1.setElo(1200);
            user1.setRank("18 kyu");
            userDAO.save(user1);
            System.out.println("Đã tạo tài khoản user1/password123");
        }

        // 3. Tạo tài khoản User 2
        User user2 = userDAO.findByUsername("user2");
        if (user2 == null) {
            user2 = new User();
            user2.setUsername("user2");
            user2.setPassword(BCrypt.hashpw("password123", BCrypt.gensalt()));
            user2.setFullName("Trần Thị B");
            user2.setEmail("thib@gmail.com");
            user2.setRole("user");
            user2.setElo(1350);
            user2.setRank("15 kyu");
            userDAO.save(user2);
            System.out.println("Đã tạo tài khoản user2/password123");
        }

        // 4. Tạo ván đấu mẫu (GameRoom) đã kết thúc
        GameRoom room = new GameRoom();
        room.setRoomName("Trận đấu giao hữu mẫu");
        room.setBlackPlayer(user1);
        room.setWhitePlayer(user2);
        room.setStatus("FINISHED");
        room.setBoardSize(19);
        room.setResult("Đen thắng (B+Resign)");
        room.setDuration("45 phút");
        room.setCreatedAt(new java.util.Date());
        roomDAO.save(room);
        System.out.println("Đã tạo ván đấu mẫu: #" + room.getId());

        // 5. Tạo các nước đi (Moves) cho ván đấu này
        int[][] moves = {
            {3, 3}, {15, 15}, {3, 15}, {15, 3}, {5, 5}, {13, 13}, {5, 13}, {13, 5},
            {10, 10}, {9, 9}, {11, 11}, {8, 8}, {10, 9}, {9, 10}
        };

        for (int i = 0; i < moves.length; i++) {
            GameMove move = new GameMove();
            move.setRoom(room);
            move.setX(moves[i][0]);
            move.setY(moves[i][1]);
            move.setColor(i % 2 == 0 ? "black" : "white");
            move.setMoveOrder(i + 1);
            roomDAO.saveMove(move);
        }
        System.out.println("Đã thêm " + moves.length + " nước đi vào ván đấu.");

        System.out.println("Hoàn tất thêm dữ liệu mẫu!");
        System.exit(0);
    }
}
