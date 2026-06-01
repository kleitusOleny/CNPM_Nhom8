<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Đăng nhập - Tâm Thế</title>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
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
                        "label-caps": [
                            "Inter"
                        ],
                        "h2-title": [
                            "Inter"
                        ],
                        "body-sm": [
                            "Inter"
                        ],
                        "body-main": [
                            "Inter"
                        ],
                        "button-text": [
                            "Inter"
                        ],
                        "h1-display": [
                            "Inter"
                        ]
                    },
                    "fontSize": {
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
                        "body-sm": [
                            "14px",
                            {
                                "lineHeight": "1.5",
                                "letterSpacing": "0",
                                "fontWeight": "400"
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
                        ],
                        "h1-display": [
                            "32px",
                            {
                                "lineHeight": "1.2",
                                "letterSpacing": "-0.02em",
                                "fontWeight": "600"
                            }
                        ]
                    }
                },
            },
        }
    </script>
</head>
<body class="bg-surface font-body-main text-on-surface antialiased min-h-screen relative flex items-center justify-center">
<div class="fixed inset-0 z-0 overflow-hidden">
    <img class="w-full h-full object-cover scale-105"
         data-alt="A serene, minimalist photograph of a traditional wooden Go board (Goban) set in a quiet, zen-inspired room. The lighting is soft and natural, casting gentle shadows across the intersecting grid lines. In the background, out of focus, elements of a traditional Japanese room with sliding shoji screens can be seen, emphasizing a calm, contemplative state of mind. The overall color palette features warm wood tones, slate grays, and soft whites, fitting perfectly into a clean, modern light-mode aesthetic."
         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBFNFDaFdUrMW8Z4ZQi0kNwzoyKWboB2vKke78rDSSfr0WrAXPBaZIS5Goa88MJNcrdLFjHf_FfJBFIpJCeiTmKGaZoUyhL8mZZHc3mbMTrLz7J8_AQYdYQUFvJ1Ru4ASotePZxv40zMCucVpbIDcZ_Au6YHs1mHkX5xzL-Hrj-znuZTU3HrN4k4Af9t5VX1M8VjgXQq-lbiSOYx-c3VHwG_p0NjFN5el7CWbEEdIj877XGPnLpAurlcoHuigrR_pI62M3uzTAR4kWP"
         style="filter: blur(8px);"/>
    <div class="absolute inset-0 bg-surface/70 mix-blend-overlay"></div>
    <div class="absolute inset-0 bg-background/50"></div>
</div>
<main class="relative z-10 w-full max-w-[440px] px-md">
    <div class="bg-surface-container-lowest rounded-xl shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] border-t-[3px] border-secondary-fixed-dim px-xl py-xl flex flex-col items-center">
        <div class="flex flex-col items-center mb-xl">
            <div class="w-16 h-16 rounded-full bg-surface-container flex items-center justify-center mb-sm shadow-sm border border-outline-variant/30">
                <span class="material-symbols-outlined text-4xl text-primary"
                      style="font-variation-settings: 'FILL' 0;">lens</span>
            </div>
            <h1 class="font-h1-display text-h1-display text-primary mb-xs">Tâm Thế</h1>
            <p class="font-body-main text-body-main text-on-surface-variant">Chào mừng trở lại</p>
        </div>

        <form action="${pageContext.request.contextPath}/login" class="w-full" method="POST">
            <div class="mb-lg relative group">
                <input class="w-full bg-transparent border-0 border-b border-outline-variant text-on-surface focus:border-primary focus:ring-0 px-0 py-sm font-body-main text-body-main transition-colors peer placeholder-transparent"
                       id="identifier" name="identifier" placeholder="Tên đăng nhập / Email" required="" type="text"/>
                <label class="absolute left-0 -top-4 font-body-sm text-body-sm text-on-surface-variant transition-all peer-placeholder-shown:text-body-main peer-placeholder-shown:top-2 peer-focus:-top-4 peer-focus:text-body-sm peer-focus:text-primary cursor-text"
                       for="identifier">
                    Tên đăng nhập / Email
                </label>
            </div>
            <div class="mb-lg relative group">
                <input class="w-full bg-transparent border-0 border-b border-outline-variant text-on-surface focus:border-primary focus:ring-0 px-0 py-sm font-body-main text-body-main transition-colors peer placeholder-transparent"
                       id="password" name="password" placeholder="Mật khẩu" required="" type="password"/>
                <label class="absolute left-0 -top-4 font-body-sm text-body-sm text-on-surface-variant transition-all peer-placeholder-shown:text-body-main peer-placeholder-shown:top-2 peer-focus:-top-4 peer-focus:text-body-sm peer-focus:text-primary cursor-text"
                       for="password">
                    Mật khẩu
                </label>
            </div>
            <div class="flex items-center justify-between mb-xl">
                <label class="flex items-center gap-2 cursor-pointer group">
                    <div class="relative flex items-center justify-center">
                        <input class="peer sr-only" type="checkbox" name="rememberMe"/>
                        <div class="w-4 h-4 rounded border border-outline-variant group-hover:border-primary peer-checked:bg-primary peer-checked:border-primary transition-colors"></div>
                        <span class="material-symbols-outlined absolute text-[12px] text-on-primary opacity-0 peer-checked:opacity-100 transition-opacity"
                              style="font-variation-settings: 'wght' 600;">check</span>
                    </div>
                    <span class="font-body-sm text-body-sm text-on-surface-variant group-hover:text-on-surface transition-colors">Ghi nhớ đăng nhập</span>
                </label>
                <a class="font-body-sm text-body-sm text-primary hover:text-tertiary transition-colors"
                   href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
            </div>
            <button class="w-full bg-primary text-on-primary font-button-text text-button-text py-3 px-6 rounded-lg hover:bg-tertiary shadow-sm hover:shadow-[0_10px_25px_-5px_rgba(26,42,58,0.12)] transition-all duration-200"
                    type="submit">
                Đăng nhập
            </button>
        </form>
        <div class="mt-xl pt-lg border-t border-outline-variant/20 w-full text-center">
            <p class="font-body-sm text-body-sm text-on-surface-variant">
                Chưa có tài khoản? <a class="text-primary font-medium hover:text-tertiary transition-colors"
                                      href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </p>
        </div>
    </div>
</main>
</body>
</html>