<%--
  Created by IntelliJ IDEA.
  User: vinhp
  Date: 5/29/2026
  Time: 10:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("activeTab", "game"); %>
<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Tạo phòng - Tâm Thế</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-container-high": "#e6e8ea",
                        "background": "#f7f9fb",
                        "on-secondary": "#ffffff",
                        "inverse-on-surface": "#eff1f3",
                        "on-primary-fixed-variant": "#384859",
                        "tertiary-fixed": "#d8e3fa",
                        "surface-container": "#eceef0",
                        "on-background": "#191c1e",
                        "surface-bright": "#f7f9fb",
                        "error-container": "#ffdad6",
                        "primary-container": "#1a2a3a",
                        "on-primary-fixed": "#0c1d2c",
                        "surface-container-highest": "#e0e3e5",
                        "on-tertiary": "#ffffff",
                        "tertiary": "#091425",
                        "error": "#ba1a1a",
                        "on-secondary-container": "#765f3d",
                        "surface-container-low": "#f2f4f6",
                        "secondary": "#725a39",
                        "on-error-container": "#93000a",
                        "tertiary-fixed-dim": "#bcc7dd",
                        "tertiary-container": "#1e293a",
                        "secondary-fixed-dim": "#e1c299",
                        "surface": "#f7f9fb",
                        "outline": "#74777d",
                        "on-primary": "#ffffff",
                        "outline-variant": "#c4c6cc",
                        "surface-container-lowest": "#ffffff",
                        "inverse-surface": "#2d3133",
                        "on-tertiary-fixed": "#111c2c",
                        "on-primary-container": "#8191a5",
                        "primary-fixed-dim": "#b7c8dd",
                        "primary-fixed": "#d3e4fa",
                        "on-secondary-fixed": "#281801",
                        "on-secondary-fixed-variant": "#584324",
                        "on-tertiary-container": "#8590a5",
                        "on-surface": "#191c1e",
                        "secondary-fixed": "#feddb3",
                        "on-tertiary-fixed-variant": "#3c475a",
                        "inverse-primary": "#b7c8dd",
                        "surface-variant": "#e0e3e5",
                        "primary": "#041525",
                        "on-error": "#ffffff",
                        "surface-tint": "#506072",
                        "surface-dim": "#d8dadc",
                        "secondary-container": "#fbdbb0",
                        "on-surface-variant": "#44474c"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "lg": "24px",
                        "sm": "8px",
                        "unit": "4px",
                        "xl": "48px",
                        "margin": "32px",
                        "xxl": "80px",
                        "xs": "4px",
                        "md": "16px",
                        "gutter": "24px"
                    },
                    "fontFamily": {
                        "body-sm": [
                            "Inter"
                        ],
                        "label-caps": [
                            "Inter"
                        ],
                        "h2-title": [
                            "Inter"
                        ],
                        "h1-display": [
                            "Inter"
                        ],
                        "body-main": [
                            "Inter"
                        ],
                        "button-text": [
                            "Inter"
                        ]
                    },
                    "fontSize": {
                        "body-sm": [
                            "14px",
                            {
                                "lineHeight": "1.5",
                                "letterSpacing": "0",
                                "fontWeight": "400"
                            }
                        ],
                        "label-caps": [
                            "12px",
                            {
                                "lineHeight": "1.0",
                                "letterSpacing": "0.05em",
                                "fontWeight": "600"
                            }
                        ],
                        "h2-title": [
                            "24px",
                            {
                                "lineHeight": "1.3",
                                "letterSpacing": "-0.01em",
                                "fontWeight": "500"
                            }
                        ],
                        "h1-display": [
                            "32px",
                            {
                                "lineHeight": "1.2",
                                "letterSpacing": "-0.02em",
                                "fontWeight": "600"
                            }
                        ],
                        "body-main": [
                            "16px",
                            {
                                "lineHeight": "1.6",
                                "letterSpacing": "0",
                                "fontWeight": "400"
                            }
                        ],
                        "button-text": [
                            "15px",
                            {
                                "lineHeight": "1.0",
                                "letterSpacing": "0.01em",
                                "fontWeight": "500"
                            }
                        ]
                    }
                },
            },
        }
    </script>
</head>
<body class="bg-background text-on-background font-body-main min-h-screen flex items-center justify-center p-md antialiased">

<div class="bg-surface-container-lowest rounded-xl shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] w-full max-w-2xl border-t-[2px] border-secondary-fixed-dim flex flex-col overflow-hidden">
    <div class="px-margin py-lg border-b border-outline-variant/20 flex justify-between items-center bg-surface-container-lowest">
        <div>
            <h1 class="font-h2-title text-h2-title text-primary">Tạo phòng mới</h1>
            <p class="font-body-sm text-body-sm text-on-surface-variant mt-xs">Thiết lập thông số cho ván đấu của bạn.</p>
        </div>
        <button onclick="window.history.back()" class="text-on-surface-variant hover:bg-surface-container-high p-sm rounded-full transition-colors">
            <span class="material-symbols-outlined">close</span>
        </button>
    </div>

    <form action="${pageContext.request.contextPath}/create-room" method="POST">
        <div class="p-margin flex flex-col gap-lg">

            <div class="flex flex-col gap-md">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
                    <div class="flex flex-col gap-xs">
                        <label class="font-body-sm text-body-sm text-on-surface-variant" for="room_name">Tên phòng</label>
                        <input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm text-primary focus:ring-0 focus:border-primary"
                               id="room_name" name="room_name" type="text" placeholder="Nhập tên phòng" required/>
                    </div>
                    <div class="flex flex-col gap-xs">
                        <label class="font-body-sm text-body-sm text-on-surface-variant">Mật khẩu (Tùy chọn)</label>
                        <input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm text-primary focus:ring-0 focus:border-primary"
                               name="room_password" type="password" placeholder="Để trống nếu công khai"/>
                    </div>
                </div>
            </div>

            <hr class="border-outline-variant/20"/>

            <div class="flex flex-col gap-md">
                <label class="font-body-sm text-body-sm text-on-surface-variant mb-xs">Kích thước bàn cờ</label>
                <div class="grid grid-cols-3 gap-md">
                    <label class="relative flex flex-col items-center p-md rounded-lg border border-outline-variant/30 cursor-pointer hover:bg-surface-container-low transition-all">
                        <input class="peer sr-only" name="board_size" type="radio" value="19" checked/>
                        <span class="font-button-text text-on-surface peer-checked:text-primary">19x19</span>
                        <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-lg"></div>
                    </label>
                    <label class="relative flex flex-col items-center p-md rounded-lg border border-outline-variant/30 cursor-pointer hover:bg-surface-container-low transition-all">
                        <input class="peer sr-only" name="board_size" type="radio" value="13"/>
                        <span class="font-button-text text-on-surface peer-checked:text-primary">13x13</span>
                        <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-lg"></div>
                    </label>
                    <label class="relative flex flex-col items-center p-md rounded-lg border border-outline-variant/30 cursor-pointer hover:bg-surface-container-low transition-all">
                        <input class="peer sr-only" name="board_size" type="radio" value="9"/>
                        <span class="font-button-text text-on-surface peer-checked:text-primary">9x9</span>
                        <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-lg"></div>
                    </label>
                </div>
            </div>

            <hr class="border-outline-variant/20"/>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-lg">
                <div class="flex flex-col gap-xs">
                    <label class="font-body-sm text-body-sm text-on-surface-variant">Thời gian chính</label>
                    <select name="main_time" class="bg-transparent border-0 border-b border-outline-variant py-sm text-primary focus:ring-0">
                        <option value="10">10 phút</option>
                        <option value="20">20 phút</option>
                        <option value="30" selected>30 phút</option>
                    </select>
                </div>
                <div class="flex flex-col gap-xs">
                    <label class="font-body-sm text-body-sm text-on-surface-variant">Byo-yomi</label>
                    <select name="byo_yomi" class="bg-transparent border-0 border-b border-outline-variant py-sm text-primary focus:ring-0">
                        <option value="3x30">3 lần x 30 giây</option>
                        <option value="5x30">5 lần x 30 giây</option>
                        <option value="none">Không có</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="px-margin py-lg border-t border-outline-variant/20 bg-surface-container-low flex justify-end gap-md">
            <button type="button" onclick="window.history.back()" class="px-lg py-sm rounded-lg font-button-text text-on-surface-variant border border-outline-variant/30">Hủy</button>
            <button type="submit" class="px-lg py-sm rounded-lg bg-primary text-on-primary shadow-sm flex items-center gap-xs">
                <span class="material-symbols-outlined text-[18px]">add</span>
                Xác nhận tạo phòng
            </button>
        </div>
    </form>
</div>

</body>
</html>
