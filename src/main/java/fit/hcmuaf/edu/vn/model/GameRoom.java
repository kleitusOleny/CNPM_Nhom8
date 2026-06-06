package fit.hcmuaf.edu.vn.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "game_rooms")
public class GameRoom implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String roomName;
    
    private String password; // Để trống nếu là phòng công khai
    private int boardSize;   // 9, 13, hoặc 19
    private String timeControl; // Ví dụ: "30m + 3x30s"
    private String status;   // WAITING, PLAYING, FINISHED
    private String result;   // Ví dụ: "B+Resign", "W+5.5", "Đen thắng"
    private String duration; // Ví dụ: "45 phút", "1h 20m"
    
    @Column(columnDefinition = "int default 0")
    private int handicap; // Số lượng quân chấp
    
    @ManyToOne
    @JoinColumn(name = "black_player_id")
    private User blackPlayer;
    
    @ManyToOne
    @JoinColumn(name = "white_player_id")
    private User whitePlayer;
    
    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @OrderBy("moveOrder ASC")
    private List<GameMove> moves;

    @Temporal(TemporalType.TIMESTAMP)
    private java.util.Date createdAt = new java.util.Date();

    // Constructors, Getters, Setters...
    public GameRoom() { this.status = "WAITING"; }

    public java.util.Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.util.Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public int getBoardSize() {
        return boardSize;
    }
    
    public void setBoardSize(int boardSize) {
        this.boardSize = boardSize;
    }
    
    public String getTimeControl() {
        return timeControl;
    }
    
    public void setTimeControl(String timeControl) {
        this.timeControl = timeControl;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public User getBlackPlayer() {
        return blackPlayer;
    }
    
    public void setBlackPlayer(User blackPlayer) {
        this.blackPlayer = blackPlayer;
    }
    
    public User getWhitePlayer() {
        return whitePlayer;
    }
    
    public void setWhitePlayer(User whitePlayer) {
        this.whitePlayer = whitePlayer;
    }
    
    public List<GameMove> getMoves() {
        return moves;
    }
    
    public void setMoves(List<GameMove> moves) {
        this.moves = moves;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public int getHandicap() {
        return handicap;
    }

    public void setHandicap(int handicap) {
        this.handicap = handicap;
    }
}