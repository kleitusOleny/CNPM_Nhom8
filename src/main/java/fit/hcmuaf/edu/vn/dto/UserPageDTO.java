package fit.hcmuaf.edu.vn.dto;

import fit.hcmuaf.edu.vn.model.User;
import java.util.List;

/**
 * Chức năng quản lý người dùng
 */
public class UserPageDTO {
    private List<User> users;
    private int totalPages;
    private int currentPage;
    private long totalElements;

    public UserPageDTO(List<User> users, int currentPage, int totalPages, long totalElements) {
        this.users = users;
        this.currentPage = currentPage;
        this.totalPages = totalPages;
        this.totalElements = totalElements;
    }

    // --- CÁC HÀM GETTER / SETTER DỄ COPY ---
    public List<User> getUsers() { return users; }
    public void setUsers(List<User> users) { this.users = users; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    public long getTotalElements() { return totalElements; }
    public void setTotalElements(long totalElements) { this.totalElements = totalElements; }
}