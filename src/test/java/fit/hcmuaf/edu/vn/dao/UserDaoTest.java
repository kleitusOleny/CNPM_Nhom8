package fit.hcmuaf.edu.vn.dao;

import fit.hcmuaf.edu.vn.model.User;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
public class UserDaoTest {
    private final UserDAO userDAO = new UserDAO();
    /**
     * Kiểm tra phương thức findAll()
     * Kết quả mong đợi:
     * Danh sách trả về không null
     * Danh sách có ít nhất một người dùng
     */
    @Test
    void findAll_ShouldReturnUserList() {
        List<User> users = userDAO.findAll();
        System.out.println("Số user: " + users.size());
        assertNotNull(users);
        assertFalse(users.isEmpty());
    }
    /**
     * Kiểm tra tìm kiếm người dùng theo ID tồn tại trong db.
     * Kết quả mong đợi:
     * Trả về đối tượng User
     * ID của User khớp với ID tìm kiếm
     */
    @Test
    void findById_ExistingId_ShouldReturnUser() {
        User user = userDAO.findById(1L);
        assertNotNull(user);
        assertEquals(1L, user.getId());
    }
    /**
     * Kiểm tra tìm kiếm người dùng với ID không tồn tại.
     * Kết quả mong đợi:
     * Trả về null
     */
    @Test
    void findById_NotExistingId_ShouldReturnNull() {
        User user = userDAO.findById(999999L);

        assertNull(user);
    }
    /**
     * Kiểm tra tìm kiếm người dùng theo username tồn tại.
     * Kết quả mong đợi:
     * Trả về đối tượng User
     * Username của User khớp với username tìm kiếm
     */
    @Test
    void findByUsername_ExistingUsername_ShouldReturnUser() {
        User user = userDAO.findByUsername("admin");
        assertNotNull(user);
        assertEquals("admin", user.getUsername());
    }
    /**
     * Kiểm tra tìm kiếm người dùng với username không tồn tại.
     * Kết quả mong đợi:
     * Trả về null
     */
    @Test
    void findByUsername_NotExistingUsername_ShouldReturnNull() {
        User user = userDAO.findByUsername("userkhongcothat");

        assertNull(user);
    }
}
