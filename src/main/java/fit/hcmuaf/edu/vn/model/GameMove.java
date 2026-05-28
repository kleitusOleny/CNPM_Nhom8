package fit.hcmuaf.edu.vn.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "game_moves")
public class GameMove implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "room_id")
    private GameRoom room;
    
    private int x;
    private int y;
    private String color; // black, white
    private int moveOrder; // Số thứ tự nước đi (1, 2, 3...)
    
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt = new Date();
    
    // Constructors, Getters, Setters...
    public GameMove() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public GameRoom getRoom() {
        return room;
    }
    
    public void setRoom(GameRoom room) {
        this.room = room;
    }
    
    public int getX() {
        return x;
    }
    
    public void setX(int x) {
        this.x = x;
    }
    
    public int getY() {
        return y;
    }
    
    public void setY(int y) {
        this.y = y;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public int getMoveOrder() {
        return moveOrder;
    }
    
    public void setMoveOrder(int moveOrder) {
        this.moveOrder = moveOrder;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}