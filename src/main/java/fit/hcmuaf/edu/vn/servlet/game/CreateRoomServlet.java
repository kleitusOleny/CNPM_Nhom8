package fit.hcmuaf.edu.vn.servlet.game;

import fit.hcmuaf.edu.vn.dao.RoomDAO;
import fit.hcmuaf.edu.vn.dao.UserDAO;
import fit.hcmuaf.edu.vn.model.GameRoom;
import fit.hcmuaf.edu.vn.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;


@WebServlet("/create-room")
public class CreateRoomServlet extends HttpServlet {

    /*
     * =========================================================
     * DAO OBJECTS
     * =========================================================
     *
     * Chỉnh sửa:
     * - Tạo DAO thành biến toàn cục
     * - Tránh khởi tạo nhiều lần trong doPost()
     *
     * File cũ:
     * UserDAO userDAO = new UserDAO();
     * RoomDAO roomDAO = new RoomDAO();
     */

    private final RoomDAO roomDAO = new RoomDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        /*
         * =====================================================
         * PRE-CONDITION CHECK
         * =====================================================
         *
         * Use Case:
         * - Player phải đăng nhập trước khi tạo phòng
         *
         * Activity Diagram:
         * - System kiểm tra session đăng nhập
         *
         * Sequence Diagram:
         * - Servlet -> Session : Kiểm tra đăng nhập
         */

        if (session == null
                || session.getAttribute("user") == null) {

            /*
             * =================================================
             * EXCEPTION FLOW
             * =================================================
             *
             * Chưa đăng nhập
             * -> Redirect đến login
             */

            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        /*
         * =====================================================
         * BASIC FLOW 4.2
         * =====================================================
         *
         * Hệ thống hiển thị form tạo phòng
         */

        req.getRequestDispatcher("/views/game/create-room.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        /*
         * =====================================================
         * PRE-CONDITION CHECK
         * =====================================================
         *
         * Kiểm tra đăng nhập khi submit form
         */

        if (session == null
                || session.getAttribute("user") == null) {

            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {

            /*
             * =================================================
             * BASIC FLOW 4.3
             * =================================================
             *
             * Player nhập thông tin cấu hình phòng
             * và nhấn xác nhận
             */

            String roomName =
                    req.getParameter("room_name");

            String password =
                    req.getParameter("room_password");

            String boardSizeRaw =
                    req.getParameter("board_size");

            String mainTime =
                    req.getParameter("main_time");

            String byoYomi =
                    req.getParameter("byo_yomi");

            String username =
                    (String) session.getAttribute("user");

            /*
             * =================================================
             * BASIC FLOW 4.4
             * =================================================
             *
             * System kiểm tra tính hợp lệ dữ liệu
             */

            if (roomName == null
                    || roomName.trim().isEmpty()) {

                /*
                 * =============================================
                 * EXCEPTION FLOW
                 * =============================================
                 *
                 * Tên phòng rỗng
                 */

                throw new Exception(
                        "Tên phòng không được để trống"
                );
            }

            roomName = roomName.trim();

            /*
             * =================================================
             * BUSINESS RULE
             * =================================================
             *
             * Tên phòng không vượt quá 50 ký tự
             */

            if (roomName.length() > 50) {

                throw new Exception(
                        "Tên phòng không vượt quá 50 ký tự"
                );
            }

            /*
             * =================================================
             * BUSINESS RULE
             * =================================================
             *
             * Tên phòng không chứa ký tự đặc biệt
             */

            if (!roomName.matches(
                    "^[a-zA-Z0-9À-ỹ\\s]+$")) {

                throw new Exception(
                        "Tên phòng chứa ký tự không hợp lệ"
                );
            }

            /*
             * =================================================
             * VALIDATE BOARD SIZE
             * =================================================
             *
             * Chỉ cho phép:
             * - 9x9
             * - 13x13
             * - 19x19
             */

            int boardSize;

            try {

                boardSize =
                        Integer.parseInt(boardSizeRaw);

            } catch (NumberFormatException e) {

                /*
                 * =============================================
                 * EXCEPTION FLOW
                 * =============================================
                 *
                 * Kích thước bàn không hợp lệ
                 */

                throw new Exception(
                        "Kích thước bàn không hợp lệ"
                );
            }

            if (boardSize != 9
                    && boardSize != 13
                    && boardSize != 19) {

                throw new Exception(
                        "Kích thước bàn không hợp lệ"
                );
            }

            /*
             * =================================================
             * BASIC FLOW
             * =================================================
             *
             * Lấy thông tin User hiện tại
             */

            User currentUser =
                    userDAO.findByUsername(username);

            if (currentUser == null) {

                /*
                 * =============================================
                 * EXCEPTION FLOW
                 * =============================================
                 *
                 * User không tồn tại
                 */

                throw new Exception(
                        "Không tìm thấy người dùng"
                );
            }

            /*
             * =================================================
             * BUSINESS RULE
             * =================================================
             *
             * Mỗi Player chỉ được tạo
             * một phòng tại một thời điểm
             */

            boolean alreadyInRoom =
                    roomDAO.isUserInRoom(
                            currentUser.getId()
                    );

            if (alreadyInRoom) {

                /*
                 * =============================================
                 * EXCEPTION FLOW
                 * =============================================
                 *
                 * User đang ở phòng khác
                 */

                throw new Exception(
                        "Bạn đang ở trong một phòng khác"
                );
            }

            /*
             * =================================================
             * BASIC FLOW 4.5
             * =================================================
             *
             * System khởi tạo GameRoom
             */

            GameRoom room = new GameRoom();

            room.setRoomName(roomName);

            /*
             * =================================================
             * ALTERNATIVE FLOW
             * =================================================
             *
             * Nếu Player nhập mật khẩu
             * -> tạo phòng riêng tư
             *
             * Nếu không nhập
             * -> phòng công khai
             */

            room.setPassword(
                    (password != null
                            && !password.trim().isEmpty())
                            ? password.trim()
                            : null
            );

            room.setBoardSize(boardSize);

            room.setTimeControl(
                    mainTime + "m + " + byoYomi
            );

            /*
             * =================================================
             * BASIC FLOW
             * =================================================
             *
             * Trạng thái mặc định:
             * WAITING
             */

            room.setStatus("WAITING");

            /*
             * =================================================
             * BASIC FLOW
             * =================================================
             *
             * Chủ phòng = Black Player
             */

            room.setBlackPlayer(currentUser);

            /*
             * =================================================
             * BASIC FLOW 4.5
             * =================================================
             *
             * Lưu phòng vào database
             */

            roomDAO.save(room);

            /*
             * =================================================
             * BASIC FLOW 4.6
             * =================================================
             *
             * Chuyển Player đến phòng chờ
             */

            resp.sendRedirect(
                    req.getContextPath()
                            + "/game/"
                            + room.getId()
            );

        } catch (Exception e) {

            /*
             * =================================================
             * EXCEPTION FLOW
             * =================================================
             *
             * - Dữ liệu không hợp lệ
             * - Lỗi tạo phòng
             * - Lỗi database
             *
             * -> Hiển thị errorMsg
             * -> Quay lại form tạo phòng
             */

            req.setAttribute(
                    "errorMsg",
                    e.getMessage()
            );

            req.getRequestDispatcher(
                    "/views/game/create-room.jsp"
            ).forward(req, resp);
        }
    }
}

