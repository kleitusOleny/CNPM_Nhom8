<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<html lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Khôi phục mật khẩu - Tâm Thế</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
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
                        "label-caps": ["12px", { "lineHeight": "1.0", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "h2-title": ["24px", { "lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "500" }],
                        "body-sm": ["14px", { "lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400" }],
                        "body-main": ["16px", { "lineHeight": "1.6", "letterSpacing": "0", "fontWeight": "400" }],
                        "button-text": ["15px", { "lineHeight": "1.0", "letterSpacing": "0.01em", "fontWeight": "500" }],
                        "h1-display": ["32px", { "lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "600" }]
                    }
                }
            }
        }
    </script>
<style>
        .wood-texture-bg {
            background-color: #f7f9fb;
            background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.05' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100' height='100' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E");
        }
        .zen-shadow {
            box-shadow: 0 10px 25px -5px rgba(26, 42, 58, 0.08);
        }
    </style>
</head>
<body class="bg-surface font-body-main text-on-surface min-h-screen flex items-center justify-center relative overflow-hidden wood-texture-bg">
<!-- Decorative Zen Background Elements -->
<div class="absolute inset-0 pointer-events-none opacity-20">
<div class="absolute top-1/4 left-1/4 w-96 h-96 bg-secondary-fixed rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-pulse"></div>
<div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-primary-fixed rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-pulse" style="animation-delay: 2s;"></div>
</div>
<!-- Main Content Container -->
<main class="w-full max-w-md px-margin relative z-10">
<!-- Logo/Brand Anchor -->
<div class="text-center mb-xl">
<h1 class="font-h1-display text-h1-display text-primary flex items-center justify-center gap-sm">
<span class="material-symbols-outlined" style="font-size: 40px; font-variation-settings: 'FILL' 1;">
                    grid_on
                </span>
                Tâm Thế
            </h1>
</div>
<!-- Forgot Password Card -->
<div class="bg-surface-container-lowest rounded-xl zen-shadow border-t-2 border-secondary-fixed-dim p-xl relative overflow-hidden">
<!-- Subtle internal decoration -->
<div class="absolute top-0 right-0 w-32 h-32 bg-surface-container-low rounded-bl-full -z-10 opacity-50"></div>
<!-- Header Section -->
<div class="mb-lg">
<h2 class="font-h2-title text-h2-title text-primary mb-sm">Khôi phục mật khẩu</h2>
<p class="font-body-sm text-body-sm text-on-surface-variant">
                    Nhập email của bạn để nhận mã xác minh đặt lại mật khẩu.
                </p>
</div>
<!-- Form Section -->
<form action="${pageContext.request.contextPath}/forgot-password" class="space-y-lg" method="POST">
<!-- Email Input -->
<div class="relative group">
<label class="sr-only" for="email">Email</label>
<div class="flex items-center">
<span class="material-symbols-outlined absolute left-0 text-outline group-focus-within:text-primary transition-colors duration-200">
                            mail
                        </span>
<input class="w-full bg-transparent border-0 border-b border-outline-variant text-on-surface font-body-main pl-margin py-sm focus:ring-0 focus:border-primary transition-colors duration-300 placeholder:text-outline-variant placeholder:font-body-sm" id="email" name="email" placeholder="Địa chỉ email" required="" type="email"/>
</div>
</div>
<!-- Action Button -->
<button class="w-full bg-primary text-on-primary font-button-text text-button-text py-md rounded-lg zen-shadow hover:bg-tertiary transition-all duration-200 active:scale-95 flex justify-center items-center gap-xs" type="submit">
<span>Gửi mã xác nhận</span>
<span class="material-symbols-outlined text-[20px]">
                        arrow_forward
                    </span>
</button>
</form>
<!-- Navigation Links -->
<div class="mt-xl text-center">
<a class="inline-flex items-center gap-xs font-body-sm text-body-sm text-on-surface-variant hover:text-primary transition-colors duration-200" href="mailto:admin@tamthe.vn">
<span class="material-symbols-outlined text-[16px]">
                        arrow_back
                    </span>
                    Quay lại Đăng nhập
                </a>
</div>
</div>
<!-- Footer / Support -->
<div class="mt-lg text-center">
<p class="font-body-sm text-body-sm text-outline">
                Cần hỗ trợ? <a class="text-primary hover:underline underline-offset-4" href="mailto:admin@tamthe.vn">Liên hệ quản trị viên</a>
</p>
</div>
</main>
</body></html>