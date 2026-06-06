package fit.hcmuaf.edu.vn.util;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class GoLogicTest {

    private GoLogic goLogic;
    private int[][] board;

    @BeforeEach
    public void setUp() {
        // Khởi tạo bàn cờ 9x9 cho test case
        goLogic = new GoLogic(9);
        board = new int[9][9];
        goLogic.setBoard(board);
    }

    /**
     * Kiểm tra logic đếm số "khí" (liberties) của một quân cờ độc lập.
     * <p>
     * Input: Đặt một quân cờ Đen (color=1) vào vị trí (4,4) trên bàn cờ trống.
     * Output:
     * - Hàm findGroup trả về danh sách chứa 1 quân cờ.
     * - Hàm countLiberties trả về 4 (do quân đứng giữa có 4 ô xung quanh trống).
     */
    @Test
    public void testFindGroupAndCountLiberties_SingleStone() {
        board[4][4] = 1; // Quân Đen
        
        List<int[]> group = goLogic.findGroup(4, 4, 1);
        assertEquals(1, group.size(), "Nhóm cờ chỉ có 1 quân");
        
        int liberties = goLogic.countLiberties(group);
        assertEquals(4, liberties, "Quân cờ đứng độc lập giữa bàn phải có 4 khí (liberties)");
    }

    /**
     * Kiểm tra logic đếm số "khí" của một nhóm quân cờ liên kết.
     * <p>
     * Input: Đặt 2 quân cờ Đen ở (4,4) và (4,5) liền kề nhau.
     * Output:
     * - Hàm findGroup trả về danh sách chứa 2 quân.
     * - Hàm countLiberties trả về 6 (tổng 8 ô trừ đi 2 ô giao tiếp xúc nhau).
     */
    @Test
    public void testFindGroupAndCountLiberties_ConnectedStones() {
        board[4][4] = 1;
        board[4][5] = 1;
        
        List<int[]> group = goLogic.findGroup(4, 4, 1);
        assertEquals(2, group.size(), "Nhóm cờ có 2 quân liên kết với nhau");
        
        int liberties = goLogic.countLiberties(group);
        // 4 + 4 - 2 (phần giao tiếp xúc) = 6 khí
        assertEquals(6, liberties, "2 quân cờ liên kết ngang giữa bàn phải có 6 khí");
    }

    /**
     * Kiểm tra luật cấm tự sát (Suicide Rule) cơ bản.
     * <p>
     * Input: Tạo một hình chữ U của quân Trắng bao kín ô (0,0) (chặn hết đường ra của ô này).
     * Output: Hàm isSuicide(0,0,1) trả về true, báo hiệu việc Đen đặt quân vào (0,0) là tự sát (không có khí và không ăn được ai).
     */
    @Test
    public void testIsSuicide_BasicSuicide() {
        // Tạo hình chữ U của Trắng (2) bao quanh 1 ô trống ở góc
        board[0][1] = 2; // Trắng
        board[1][0] = 2; // Trắng
        
        // Đen (1) đánh vào (0,0) sẽ là tự sát vì góc chỉ có 2 khí và đã bị Trắng chặn hết
        assertTrue(goLogic.isSuicide(0, 0, 1), "Đánh vào ô bị bao vây kín mà không ăn được quân là tự sát");
    }

    /**
     * Kiểm tra ngoại lệ của luật cấm tự sát: Đánh vào lỗ chết nhưng lại ăn được quân đối phương.
     * <p>
     * Input: 
     * - Quân Trắng bao quanh ô (4,4) nhưng bản thân nhóm quân Trắng đó cũng chỉ còn duy nhất 1 khí ở đúng ô (4,4).
     * - Quân Đen chuẩn bị đặt vào (4,4).
     * Output: Hàm isSuicide trả về false. Nước đi hợp lệ vì theo luật cờ vây, đặt vào lỗ chết nhưng bắt được quân đối thủ thì quân thủ bị nhấc ra trước, do đó không tính là tự sát.
     */
    @Test
    public void testIsSuicide_NotSuicideIfCaptures() {
        // Tình huống: Đen đánh vào lỗ tự sát, nhưng nước đi đó lại ăn được quân Trắng.
        
        // Trắng (2) bao quanh (4,4)
        board[3][4] = 2;
        board[5][4] = 2;
        board[4][3] = 2;
        board[4][5] = 2;
        
        // Nhóm Trắng ở (3,4) bị Đen bao quanh, chỉ còn 1 khí duy nhất là ở (4,4)
        board[2][4] = 1;
        board[3][3] = 1;
        board[3][5] = 1;
        
        // Lúc này Đen (1) đánh vào (4,4), Đen bị bao vây (0 khí)
        // NHƯNG quân Trắng ở (3,4) cũng hết khí và sẽ bị Đen ăn.
        // Theo luật cờ vây, đây là nước đi HỢP LỆ (không phải tự sát).
        assertFalse(goLogic.isSuicide(4, 4, 1), "Không phải tự sát nếu nước đi ăn được quân đối phương");
    }

    /**
     * Tính điểm (Area Scoring) khi bàn cờ hoàn toàn trống.
     * <p>
     * Input: Điểm lợi thế (Komi) là 6.5.
     * Output: Map kết quả chứa {black=0.0, white=6.5}.
     */
    @Test
    public void testCalculateFinalScore_EmptyBoard() {
        Map<String, Double> score = goLogic.calculateFinalScore(6.5);
        
        // Bàn cờ trống không thuộc về ai (owner = 0)
        assertEquals(0.0, score.get("black"), "Đen 0 điểm trên bàn cờ trống");
        assertEquals(6.5, score.get("white"), "Trắng mặc định có điểm Komi 6.5");
    }

    /**
     * Tính điểm (Area Scoring) ở trạng thái cuối game thực tế.
     * <p>
     * Input: 
     * - Đen bao vây kín hoàn toàn một góc 3x3 ở phía trên bên trái bàn cờ bằng 7 quân cờ.
     * - Điểm Komi cho Trắng = 6.5.
     * Output:
     * - Đen: Nhận 16 điểm (7 điểm từ quân sống trên bàn + 9 điểm từ lãnh thổ 3x3 vây được).
     * - Trắng: Nhận 6.5 điểm.
     */
    @Test
    public void testCalculateFinalScore_AreaScoring() {
        // Thiết lập: Đen (1) chiếm khu vực góc trên bên trái (3x3)
        // Đặt quân Đen làm hàng rào để bao vây đất
        board[0][3] = 1;
        board[1][3] = 1;
        board[2][3] = 1;
        board[3][0] = 1;
        board[3][1] = 1;
        board[3][2] = 1;
        board[3][3] = 1;
        
        // Phân tích theo luật cờ vây Trung Quốc (Area Scoring):
        // Điểm = Số quân trên bàn + Số đất bao vây được.
        // Số lượng quân Đen = 7. Khu vực Đen bao vây (góc 3x3) = 9 ô (từ 0..2, 0..2).
        // Tổng điểm Đen (Area Scoring) = 7 + 9 = 16 điểm.

        Map<String, Double> score = goLogic.calculateFinalScore(6.5);
        
        assertEquals(16.0, score.get("black"), "Đen phải đạt 16 điểm (7 quân cờ + 9 điểm đất)");
        assertEquals(6.5, score.get("white"), "Trắng chưa đánh quân nào, chỉ có điểm Komi");
    }

    /**
     * Kiểm tra chức năng chuyển đổi trạng thái bàn cờ sang chuỗi String để lưu trữ/hashing.
     * Tính năng này cực kỳ quan trọng cho luật Superko (cấm lặp lại bàn cờ cũ).
     * <p>
     * Input: Bàn cờ với quân Đen ở (0,0) và Trắng ở (0,1).
     * Output: Chuỗi String bắt đầu bằng "120000" (Đen=1, Trắng=2, Trống=0).
     */
    @Test
    public void testGetBoardString_ForSuperko() {
        board[0][0] = 1; // Đen
        board[0][1] = 2; // Trắng
        
        String str = goLogic.getBoardString(board);
        
        // Đảm bảo chuỗi sinh ra phản ánh đúng trạng thái bàn cờ để hashing
        assertTrue(str.startsWith("120000"), "Chuỗi ký tự đại diện bàn cờ phải bắt đầu bằng 12000... (Đen là 1, Trắng là 2)");
    }
}
