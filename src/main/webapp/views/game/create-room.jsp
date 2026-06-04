<
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
// =========================================================
// CHỈNH SỬA MỚI
// Hiển thị errorMsg từ Servlet
//
// FILE CŨ:
// Không render lỗi
//
// FILE MỚI:
// Đồng bộ với:
// req.setAttribute("errorMsg", ...)
// trong CreateRoomServlet
// =========================================================

```
String errorMsg = (String) request.getAttribute("errorMsg");
```

%>

<% request.setAttribute("activeTab", "game"); %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Tạo phòng - Tâm Thế</title>

```
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap"
      rel="stylesheet"/>

<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
      rel="stylesheet"/>

<script id="tailwind-config">

    // =========================================================
    // GIỮ NGUYÊN TOÀN BỘ TAILWIND CONFIG
    // Không chỉnh sửa để tránh ảnh hưởng UI team
    // =========================================================

    tailwind.config = {
        darkMode: "class",
        theme: {
            extend: {
                colors: {
                    "background": "#f7f9fb",
                    "primary": "#041525",
                    "on-primary": "#ffffff",
                    "outline-variant": "#c4c6cc",
                    "surface-container-lowest": "#ffffff",
                    "on-surface": "#191c1e",
                    "on-surface-variant": "#44474c",
                    "surface-container-low": "#f2f4f6",
                    "surface-container-high": "#e6e8ea",
                    "secondary-fixed-dim": "#e1c299",
                    "error": "#ba1a1a"
                }
            }
        }
    }
</script>
```

</head>

<body class="bg-background text-on-surface min-h-screen flex items-center justify-center p-4">

<div class="bg-surface-container-lowest
            rounded-xl
            shadow-lg
            w-full
            max-w-2xl
            border-t-2
            border-secondary-fixed-dim
            overflow-hidden">

```
<!-- ===================================================== -->
<!-- HEADER -->
<!-- ===================================================== -->

<div class="px-8 py-6 border-b border-outline-variant/20 flex justify-between items-center">

    <div>
        <h1 class="text-2xl font-semibold text-primary">
            Tạo phòng mới
        </h1>

        <p class="text-sm text-on-surface-variant mt-1">
            Thiết lập thông số cho ván đấu của bạn.
        </p>
    </div>

    <button onclick="window.history.back()"
            class="text-on-surface-variant hover:bg-surface-container-high p-2 rounded-full">

        <span class="material-symbols-outlined">
            close
        </span>
    </button>
</div>

<!-- ===================================================== -->
<!-- CHỈNH SỬA MỚI -->
<!-- HIỂN THỊ ERROR MESSAGE -->
<!-- ===================================================== -->

<% if(errorMsg != null){ %>

<div class="mx-8 mt-6
            bg-red-100
            border border-red-300
            text-red-700
            px-4 py-3
            rounded-lg">

    <%= errorMsg %>

</div>

<% } %>

<!-- ===================================================== -->
<!-- FORM -->
<!-- ===================================================== -->

<form action="${pageContext.request.contextPath}/create-room"
      method="POST">

    <div class="p-8 flex flex-col gap-6">

        <!-- ================================================= -->
        <!-- ROOM NAME + PASSWORD -->
        <!-- ================================================= -->

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            <!-- ============================================= -->
            <!-- ROOM NAME -->
            <!-- ============================================= -->

            <div class="flex flex-col gap-2">

                <label class="text-sm text-on-surface-variant">

                    Tên phòng

                </label>

                <input
                        id="room_name"
                        name="room_name"
                        type="text"

                        <!-- ============================= -->
                        <!-- CHỈNH SỬA MỚI -->
                        <!-- maxlength -->
                        <!-- khớp Business Rule -->
                        <!-- ============================= -->

                        maxlength="50"

                        <!-- ============================= -->
                        <!-- CHỈNH SỬA MỚI -->
                        <!-- required -->
                        <!-- khớp validate servlet -->
                        <!-- ============================= -->

                        required

                        <!-- ============================= -->
                        <!-- CHỈNH SỬA MỚI -->
                        <!-- regex -->
                        <!-- khớp servlet -->
                        <!-- ============================= -->

                        pattern="^[a-zA-Z0-9À-ỹ\s]+$"

                        class="w-full
                               bg-transparent
                               border-0
                               border-b
                               border-outline-variant
                               py-2
                               focus:ring-0
                               focus:border-primary"

                        placeholder="Nhập tên phòng"
                />

                <!-- ========================================= -->
                <!-- CHỈNH SỬA MỚI -->
                <!-- Helper text -->
                <!-- ========================================= -->

                <small class="text-xs text-on-surface-variant">

                    Tối đa 50 ký tự, không chứa ký tự đặc biệt.

                </small>

            </div>

            <!-- ============================================= -->
            <!-- PASSWORD -->
            <!-- ============================================= -->

            <div class="flex flex-col gap-2">

                <label class="text-sm text-on-surface-variant">

                    Mật khẩu (Tùy chọn)

                </label>

                <input
                        name="room_password"
                        type="password"

                        <!-- ============================= -->
                        <!-- CHỈNH SỬA MỚI -->
                        <!-- maxlength -->
                        <!-- ============================= -->

                        maxlength="20"

                        class="w-full
                               bg-transparent
                               border-0
                               border-b
                               border-outline-variant
                               py-2
                               focus:ring-0
                               focus:border-primary"

                        placeholder="Để trống nếu công khai"
                />

            </div>

        </div>

        <hr class="border-outline-variant/20"/>

        <!-- ================================================= -->
        <!-- BOARD SIZE -->
        <!-- ================================================= -->

        <div class="flex flex-col gap-4">

            <label class="text-sm text-on-surface-variant">

                Kích thước bàn cờ

            </label>

            <div class="grid grid-cols-3 gap-4">

                <!-- ========================================= -->
                <!-- GIỮ NGUYÊN LOGIC CŨ -->
                <!-- ========================================= -->

                <label class="relative flex flex-col items-center p-4 rounded-lg border border-outline-variant/30 cursor-pointer">

                    <input class="peer sr-only"
                           name="board_size"
                           type="radio"
                           value="19"
                           checked/>

                    <span class="peer-checked:text-primary">
                        19x19
                    </span>

                </label>

                <label class="relative flex flex-col items-center p-4 rounded-lg border border-outline-variant/30 cursor-pointer">

                    <input class="peer sr-only"
                           name="board_size"
                           type="radio"
                           value="13"/>

                    <span class="peer-checked:text-primary">
                        13x13
                    </span>

                </label>

                <label class="relative flex flex-col items-center p-4 rounded-lg border border-outline-variant/30 cursor-pointer">

                    <input class="peer sr-only"
                           name="board_size"
                           type="radio"
                           value="9"/>

                    <span class="peer-checked:text-primary">
                        9x9
                    </span>

                </label>

            </div>

        </div>

        <hr class="border-outline-variant/20"/>

        <!-- ================================================= -->
        <!-- TIME CONTROL -->
        <!-- ================================================= -->

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            <!-- MAIN TIME -->

            <div class="flex flex-col gap-2">

                <label class="text-sm text-on-surface-variant">

                    Thời gian chính

                </label>

                <select name="main_time"
                        class="bg-transparent border-0 border-b border-outline-variant py-2">

                    <option value="10">10 phút</option>
                    <option value="20">20 phút</option>
                    <option value="30" selected>30 phút</option>

                </select>

            </div>

            <!-- BYO YOMI -->

            <div class="flex flex-col gap-2">

                <label class="text-sm text-on-surface-variant">

                    Byo-yomi

                </label>

                <select name="byo_yomi"
                        class="bg-transparent border-0 border-b border-outline-variant py-2">

                    <option value="3x30">
                        3 lần x 30 giây
                    </option>

                    <option value="5x30">
                        5 lần x 30 giây
                    </option>

                    <option value="none">
                        Không có
                    </option>

                </select>

            </div>

        </div>

    </div>

    <!-- ===================================================== -->
    <!-- FOOTER -->
    <!-- ===================================================== -->

    <div class="px-8 py-6
                border-t
                border-outline-variant/20
                bg-surface-container-low
                flex justify-end gap-4">

        <button type="button"
                onclick="window.history.back()"
                class="px-6 py-2 rounded-lg border border-outline-variant/30">

            Hủy

        </button>

        <button type="submit"
                class="px-6 py-2 rounded-lg bg-primary text-on-primary flex items-center gap-2">

            <span class="material-symbols-outlined text-[18px]">
                add
            </span>

            Xác nhận tạo phòng

        </button>

    </div>

</form>
```

</div>

</body>
</html>
