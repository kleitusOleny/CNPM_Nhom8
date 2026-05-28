package fit.hcmuaf.edu.vn.dto;

import fit.hcmuaf.edu.vn.model.GameRoom;
import java.util.List;

public class GamePageDTO {
    private List<GameRoom> games;
    private int totalPages;
    private int currentPage;
    private long totalElements;

    public GamePageDTO(List<GameRoom> games, int totalPages, int currentPage, long totalElements) {
        this.games = games;
        this.totalPages = totalPages;
        this.currentPage = currentPage;
        this.totalElements = totalElements;
    }

    // Getters and Setters
    public List<GameRoom> getGames() { return games; }
    public void setGames(List<GameRoom> games) { this.games = games; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    public long getTotalElements() { return totalElements; }
    public void setTotalElements(long totalElements) { this.totalElements = totalElements; }
}
