package fit.hcmuaf.edu.vn.service;

import fit.hcmuaf.edu.vn.dto.UserPageDTO;
import fit.hcmuaf.edu.vn.model.User;
import org.junit.jupiter.api.Test;

import java.util.HashMap;

import static org.junit.jupiter.api.Assertions.*;

public class UserServiceTest {
    /**
     * Kiểm tra lấy thông tin người dùng theo ID hợp lệ.
     * Kết quả mong đợi:
     * Trả về đối tượng User khác null.
     */
    @Test
    void getUserById_ExistingId_ReturnUser() {
        UserService service = new UserService();

        User user = service.getUserById(1L);

        assertNotNull(user);
    }
    /**
     * Kiểm tra xóa người dùng khi ID người dùng không tồn tại.
     * Kết quả mong đợi:
     * Phát sinh Exception.
     * Thông báo lỗi "Thành viên không tồn tại".
     */
    @Test
    void deleteUserTx_UserNotFound_ThrowException() {

        UserService service = new UserService();

        Exception ex = assertThrows(
                Exception.class,
                () -> service.deleteUserTx(999999L, 1L)
        );

        assertEquals(
                "Thành viên không tồn tại",
                ex.getMessage()
        );
    }
    /**
     * Kiểm tra trường hợp người dùng tự xóa chính tài khoản của mình.
     * Kết quả mong đợi:
     * Phát sinh Exception.
     * Thông báo lỗi không cho phép tự xóa tài khoản.
     */
    @Test
    void deleteUserTx_SelfDelete_ThrowException() {

        UserService service = new UserService();

        Exception ex = assertThrows(
                Exception.class,
                () -> service.deleteUserTx(1L, 1L)
        );

        assertEquals(
                "Bạn không được phép tự xóa tài khoản của chính mình!",
                ex.getMessage()
        );
    }
    /**
     * Kiểm tra cập nhật vai trò cho người dùng không tồn tại.
     * Kết quả mong đợi:
     * Phát sinh Exception.
     * Thông báo lỗi "Thành viên không tồn tại".
     */
    @Test
    void updateUserRoleTx_UserNotFound_ThrowException() {

        UserService service = new UserService();

        Exception ex = assertThrows(
                Exception.class,
                () -> service.updateUserRoleTx(
                        999999L,
                        "ADMIN",
                        1L
                )
        );

        assertEquals(
                "Thành viên không tồn tại",
                ex.getMessage()
        );
    }
    /**
     * Kiểm tra chức năng phân trang danh sách người dùng.
     * Kết quả mong đợi:
     * Trả về đối tượng UserPageDTO khác null.
     * Danh sách người dùng trong trang được khởi tạo.
     */
    @Test
    void getUsersPage_ReturnPageData() {

        UserService service = new UserService();

        UserPageDTO dto =
                service.getUsersPage(1, 10, new HashMap<>());

        assertNotNull(dto);
        assertNotNull(dto.getUsers());
    }
}
