<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Gia nhập kỳ viện - Tâm Thế</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-background": "#191c1e",
                        "on-surface": "#191c1e",
                        "surface-container-high": "#e6e8ea",
                        "secondary": "#725a39",
                        "outline-variant": "#c4c6cc",
                        "primary-fixed": "#d3e4fa",
                        "on-tertiary": "#ffffff",
                        "surface-dim": "#d8dadc",
                        "on-error": "#ffffff",
                        "inverse-surface": "#2d3133",
                        "secondary-fixed-dim": "#e1c299",
                        "background": "#f7f9fb",
                        "tertiary-fixed": "#d8e3fa",
                        "surface-tint": "#506072",
                        "inverse-primary": "#b7c8dd",
                        "on-secondary": "#ffffff",
                        "on-primary-fixed": "#0c1d2c",
                        "surface-container": "#eceef0",
                        "on-tertiary-container": "#8590a5",
                        "secondary-fixed": "#feddb3",
                        "tertiary-container": "#1e293a",
                        "primary-container": "#1a2a3a",
                        "on-error-container": "#93000a",
                        "tertiary": "#091425",
                        "surface-container-low": "#f2f4f6",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary-fixed": "#111c2c",
                        "on-primary": "#ffffff",
                        "outline": "#74777d",
                        "on-secondary-fixed": "#281801",
                        "inverse-on-surface": "#eff1f3",
                        "surface-bright": "#f7f9fb",
                        "surface": "#f7f9fb",
                        "primary-fixed-dim": "#b7c8dd",
                        "tertiary-fixed-dim": "#bcc7dd",
                        "on-primary-fixed-variant": "#384859",
                        "error": "#ba1a1a",
                        "primary": "#041525",
                        "on-tertiary-fixed-variant": "#3c475a",
                        "on-secondary-fixed-variant": "#584324",
                        "on-secondary-container": "#765f3d",
                        "error-container": "#ffdad6",
                        "surface-container-highest": "#e0e3e5",
                        "on-surface-variant": "#44474c",
                        "on-primary-container": "#8191a5",
                        "surface-variant": "#e0e3e5",
                        "secondary-container": "#fbdbb0"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "xxl": "80px",
                        "xl": "48px",
                        "margin": "32px",
                        "lg": "24px",
                        "md": "16px",
                        "xs": "4px",
                        "gutter": "24px",
                        "sm": "8px",
                        "unit": "4px"
                    },
                    "fontFamily": {
                        "label-caps": ["Inter"],
                        "h2-title": ["Inter"],
                        "body-sm": ["Inter"],
                        "body-main": ["Inter"],
                        "button-text": ["Inter"],
                        "h1-display": ["Inter"]
                    },
                    "fontSize": {
                        "label-caps": ["12px", {"lineHeight": "1.0", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "h2-title": ["24px", {"lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "500"}],
                        "body-sm": ["14px", {"lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400"}],
                        "body-main": ["16px", {"lineHeight": "1.6", "letterSpacing": "0", "fontWeight": "400"}],
                        "button-text": ["15px", {"lineHeight": "1.0", "letterSpacing": "0.01em", "fontWeight": "500"}],
                        "h1-display": ["32px", {"lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "600"}]
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-surface text-on-surface font-body-main min-h-screen flex items-center justify-center p-md sm:p-margin relative overflow-hidden">
<div class="absolute inset-0 z-0 opacity-30 pointer-events-none"
     style="background-image: radial-gradient(circle at top right, #e1c299 0%, transparent 40%), radial-gradient(circle at bottom left, #d3e4fa 0%, transparent 40%);"></div>
<main class="w-full max-w-[480px] z-10">
    <div class="bg-surface-container-lowest rounded-xl shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] border-t-[3px] border-secondary p-xl flex flex-col gap-xl">
        <header class="flex flex-col items-center gap-sm">
            <div class="font-h1-display text-h1-display text-primary flex items-center gap-sm">
                <span class="material-symbols-outlined text-[36px]"
                      style="font-variation-settings: 'FILL' 1;">eco</span>
                Tâm Thế
            </div>
            <h1 class="font-h2-title text-h2-title text-on-surface-variant text-center">Gia nhập kỳ viện</h1>
        </header>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error">
                <span class="material-symbols-outlined">error</span>
                    ${errorMsg}
            </div>
        </c:if>
        <form class="flex flex-col gap-lg" action="${pageContext.request.contextPath}/register" method="POST">
            <div class="flex flex-col gap-xs group">
                <label class="font-label-caps text-label-caps text-on-surface-variant group-focus-within:text-primary transition-colors"
                       for="fullname">Họ và tên</label>
                <input class="w-full bg-transparent border-0 border-b border-outline-variant px-0 py-sm font-body-main text-body-main text-on-surface focus:ring-0 focus:border-primary transition-colors placeholder:text-outline"
                       id="fullname" name="fullname" placeholder="Nhập họ và tên của bạn" required="" type="text"/>
            </div>
            <div class="flex flex-col gap-xs group">
                <label class="font-label-caps text-label-caps text-on-surface-variant group-focus-within:text-primary transition-colors"
                       for="email">Email</label>
                <input class="w-full bg-transparent border-0 border-b border-outline-variant px-0 py-sm font-body-main text-body-main text-on-surface focus:ring-0 focus:border-primary transition-colors placeholder:text-outline"
                       id="email" name="email" placeholder="ví dụ: kythu@tamthe.vn" required="" type="email"/>
            </div>
            <div class="flex flex-col gap-xs group">
                <label class="font-label-caps text-label-caps text-on-surface-variant group-focus-within:text-primary transition-colors"
                       for="username">Tên đăng nhập</label>
                <input class="w-full bg-transparent border-0 border-b border-outline-variant px-0 py-sm font-body-main text-body-main text-on-surface focus:ring-0 focus:border-primary transition-colors placeholder:text-outline"
                       id="username" name="username" placeholder="Sử dụng trong game" required="" type="text"/>
            </div>
            <div class="flex flex-col gap-xs group">
                <label class="font-label-caps text-label-caps text-on-surface-variant group-focus-within:text-primary transition-colors"
                       for="password">Mật khẩu</label>
                <input class="w-full bg-transparent border-0 border-b border-outline-variant px-0 py-sm font-body-main text-body-main text-on-surface focus:ring-0 focus:border-primary transition-colors placeholder:text-outline"
                       id="password" name="password" placeholder="Tối thiểu 8 ký tự" required="" type="password"/>
            </div>
            <div class="flex flex-col gap-xs group">
                <label class="font-label-caps text-label-caps text-on-surface-variant group-focus-within:text-primary transition-colors"
                       for="confirm_password">Xác nhận mật khẩu</label>
                <input class="w-full bg-transparent border-0 border-b border-outline-variant px-0 py-sm font-body-main text-body-main text-on-surface focus:ring-0 focus:border-primary transition-colors placeholder:text-outline"
                       id="confirm_password" name="confirm_password" placeholder="Nhập lại mật khẩu" required=""
                       type="password"/>
            </div>
            <div class="flex items-start gap-md mt-sm">
                <div class="flex items-center h-5">
                    <input class="w-4 h-4 rounded border-outline-variant text-primary focus:ring-primary bg-transparent cursor-pointer"
                           id="terms" name="terms" required="" type="checkbox"/>
                </div>
                <label class="font-body-sm text-body-sm text-on-surface-variant cursor-pointer select-none" for="terms">
                    Tôi đồng ý với các <a class="text-primary hover:underline font-medium" href="#">điều khoản</a> và <a
                        class="text-primary hover:underline font-medium" href="#">quy định</a> của Tâm Thế
                </label>
            </div>
            <button class="w-full bg-primary text-on-primary font-button-text text-button-text py-3 px-lg rounded-lg shadow-sm hover:shadow-md hover:bg-tertiary active:scale-[0.98] transition-all mt-md flex justify-center items-center gap-sm"
                    type="submit">
                Tạo tài khoản
                <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
            </button>
        </form>
        <div class="text-center font-body-sm text-body-sm text-on-surface-variant border-t border-surface-variant pt-lg">
            Đã có tài khoản?
            <a class="text-primary font-button-text text-button-text hover:underline ml-xs"
               href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
    </div>
</main>
</body>
</html>