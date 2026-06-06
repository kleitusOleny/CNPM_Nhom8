<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("activeTab", "profile"); %>
<!DOCTYPE html>

<html lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Hồ sơ &amp; Thống kê - Tâm Thế</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "surface": "#f7f9fb",
                      "secondary": "#725a39",
                      "on-primary-fixed": "#0c1d2c",
                      "inverse-primary": "#b7c8dd",
                      "surface-container-highest": "#e0e3e5",
                      "on-secondary-fixed-variant": "#584324",
                      "primary-container": "#1a2a3a",
                      "tertiary-container": "#1e293a",
                      "background": "#f7f9fb",
                      "inverse-surface": "#2d3133",
                      "on-primary-fixed-variant": "#384859",
                      "on-primary-container": "#8191a5",
                      "surface-variant": "#e0e3e5",
                      "outline-variant": "#c4c6cc",
                      "on-primary": "#ffffff",
                      "primary-fixed-dim": "#b7c8dd",
                      "outline": "#74777d",
                      "on-error": "#ffffff",
                      "primary": "#041525",
                      "on-secondary": "#ffffff",
                      "tertiary": "#091425",
                      "on-tertiary": "#ffffff",
                      "on-background": "#191c1e",
                      "secondary-fixed": "#feddb3",
                      "on-secondary-container": "#765f3d",
                      "surface-container-high": "#e6e8ea",
                      "tertiary-fixed": "#d8e3fa",
                      "primary-fixed": "#d3e4fa",
                      "on-tertiary-fixed": "#111c2c",
                      "surface-dim": "#d8dadc",
                      "error-container": "#ffdad6",
                      "surface-container-low": "#f2f4f6",
                      "surface-container": "#eceef0",
                      "on-tertiary-fixed-variant": "#3c475a",
                      "on-surface-variant": "#44474c",
                      "on-secondary-fixed": "#281801",
                      "on-tertiary-container": "#8590a5",
                      "on-error-container": "#93000a",
                      "inverse-on-surface": "#eff1f3",
                      "secondary-container": "#fbdbb0",
                      "surface-bright": "#f7f9fb",
                      "on-surface": "#191c1e",
                      "surface-container-lowest": "#ffffff",
                      "surface-tint": "#506072",
                      "tertiary-fixed-dim": "#bcc7dd",
                      "secondary-fixed-dim": "#e1c299",
                      "error": "#ba1a1a"
              },
              "borderRadius": {
                      "DEFAULT": "0.25rem",
                      "lg": "0.5rem",
                      "xl": "0.75rem",
                      "full": "9999px"
              },
              "spacing": {
                      "unit": "4px",
                      "lg": "24px",
                      "xxl": "80px",
                      "sm": "8px",
                      "md": "16px",
                      "xl": "48px",
                      "xs": "4px",
                      "gutter": "24px",
                      "margin": "32px"
              },
              "fontFamily": {
                      "h1-display": [
                              "Inter"
                      ],
                      "body-main": [
                              "Inter"
                      ],
                      "button-text": [
                              "Inter"
                      ],
                      "label-caps": [
                              "Inter"
                      ],
                      "body-sm": [
                              "Inter"
                      ],
                      "h2-title": [
                              "Inter"
                      ]
              },
              "fontSize": {
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
                      ],
                      "label-caps": [
                              "12px",
                              {
                                      "lineHeight": "1.0",
                                      "letterSpacing": "0.05em",
                                      "fontWeight": "600"
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
                      "h2-title": [
                              "24px",
                              {
                                      "lineHeight": "1.3",
                                      "letterSpacing": "-0.01em",
                                      "fontWeight": "500"
                              }
                      ]
              }
      },
          },
        }
    </script>
<style>
        /* Custom base styles to ensure clean inputs matching Zen style */
        input:focus {
            box-shadow: none !important;
        }
    </style>
</head>
<body class="bg-background text-on-background font-body-main flex h-screen overflow-hidden">
<!-- SideNavBar (Desktop) -->
<jsp:include page="/views/layout/user-sidebar.jsp" />
<!-- Main Canvas -->
<div class="flex-1 flex flex-col min-w-0 bg-background overflow-hidden">
<!-- TopNavBar -->
<header class="bg-surface-container-lowest full-width top-0 z-50 shadow-sm border-b border-outline-variant/20 flex justify-between items-center w-full px-margin py-md shrink-0">
<div class="flex items-center gap-md md:hidden">
<button class="text-on-surface-variant p-sm rounded-full hover:bg-surface-container-high transition-colors">
<span class="material-symbols-outlined" data-icon="menu">menu</span>
</button>
<span class="font-h2-title text-h2-title font-bold text-primary">Cờ Vây System</span>
</div>
<div class="hidden md:block">
<!-- Empty space on desktop to balance right actions -->
</div>
<div class="flex items-center gap-lg">
<div class="flex gap-sm">
<button class="text-on-surface-variant p-sm rounded-full hover:bg-surface-container-high transition-colors scale-95 active:scale-90">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
</button>
<button class="text-on-surface-variant p-sm rounded-full hover:bg-surface-container-high transition-colors scale-95 active:scale-90">
<span class="material-symbols-outlined" data-icon="settings">settings</span>
</button>
</div>
<div class="h-8 w-px bg-outline-variant/30"></div>
<div class="flex items-center gap-md cursor-pointer hover:bg-surface-container p-sm rounded-lg transition-colors">
<img alt="Ảnh đại diện kỳ thủ" class="w-8 h-8 rounded-full border border-outline-variant/20 object-cover" data-alt="A portrait of a thoughtful young man with a serious expression, shot in soft natural lighting. He is wearing a minimalist dark turtleneck. The background is a muted, out-of-focus studio setting, evoking a sense of concentration and calm focus suited for a strategic player profile." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAugQ3rJvxe5TjVSgiudXnoWUoUE8ZwGlODI05JRu05fZbwuT__CHc4xbpRCTfYKPTBzjNfl9WIXxZDv8sTnDvcOgmHE9o_Y6d-Nt7q-UGCIdwldALza1E9kWjQBSETgkH9ME7IWTujOjTxU8MdHihgXqe9xTMEhbSo5Tq6_LTaqQVUmHSt9xMZjMM76yWYT3Gp3v7BIJ7rLtZsj1GHl91UpWTcEFtDX8FJz7rtC5-tlfIUUjHIO6qR9ZUzJR6yJB77IAPhmTJXbIY9"/>
<span class="font-button-text text-button-text text-primary hidden sm:block">Đăng xuất</span>
</div>
</div>
</header>
<!-- Page Content -->
<main class="flex-1 overflow-y-auto p-md md:p-xl">
<div class="max-w-[1200px] mx-auto w-full">
<div class="mb-xl">
<h2 class="font-h1-display text-h1-display text-primary">Hồ sơ &amp; Thống kê</h2>
<p class="font-body-main text-body-main text-on-surface-variant mt-sm">Quản lý thông tin cá nhân và theo dõi hành trình kỳ đạo của bạn.</p>
</div>
<div class="grid grid-cols-1 lg:grid-cols-12 gap-xl">
<!-- Left Column: Forms (8 cols) -->
<div class="lg:col-span-8 flex flex-col gap-xl">
<!-- Personal Profile Card -->
<section class="bg-surface-container-lowest rounded-xl border-t-2 border-secondary shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] p-lg md:p-xl relative overflow-hidden">
<!-- Subtle decorative element -->
<div class="absolute top-0 right-0 p-lg opacity-10 pointer-events-none">
<span class="material-symbols-outlined text-[120px]" data-icon="account_circle">account_circle</span>
</div>
<h3 class="font-h2-title text-h2-title text-primary mb-lg flex items-center gap-sm">
<span class="material-symbols-outlined text-secondary" data-icon="person">person</span>
                                Hồ sơ cá nhân
                            </h3>
<div class="flex flex-col sm:flex-row gap-xl items-start mb-xl">
<div class="relative group cursor-pointer shrink-0">
<div class="w-24 h-24 md:w-32 md:h-32 rounded-full overflow-hidden border-4 border-surface shadow-sm">
<img alt="Avatar" class="w-full h-full object-cover" data-alt="A highly detailed close-up portrait of a thoughtful young man, used as an avatar. The lighting is soft and natural, emphasizing a calm and focused demeanor. The background is a clean, minimalist studio environment in muted tones, aligning perfectly with a professional and intellectual digital persona." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCa598PQecK0b3p5loX1VASsB-XhrYTQyNER5MGKLCyLJgDu4rv3gxqTpnfFEYswfdEZWNITLivmUF2dTDIgdFAMVBwNfy3FX2kgy8o57kIopccjoTwmzX1M8qfjhV-NDDHBJPwOabDmleI-ZHn3HOuz4LsK9hwISSmDTOdxGojM1N60FuxEMNzq8ARulphs6ckvS3HJPvAuUIZvlagrSQCvhrVVwcek1V3uu3xpKIrJ4Q0490KOQPB6X-P6i_tESTwVSu-SyLNPwRL"/>
</div>
<div class="absolute inset-0 bg-primary/50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity rounded-full">
<span class="material-symbols-outlined text-on-primary" data-icon="photo_camera">photo_camera</span>
</div>
</div>
<div class="flex-1 w-full flex flex-col gap-lg mt-sm">
<div class="relative">
<label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">Họ tên</label>
<input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm px-0 text-primary font-body-main focus:ring-0 focus:border-primary transition-colors" type="text" value="Nguyễn Văn A"/>
</div>
<div class="relative">
<label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">Email</label>
<input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm px-0 text-primary font-body-main focus:ring-0 focus:border-primary transition-colors" type="email" value="nguyenvana@example.com"/>
</div>
<div class="relative">
<label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">Cấp độ</label>
<div class="flex items-center gap-sm mt-xs">
<span class="inline-flex items-center px-md py-xs rounded-full bg-surface-container-highest text-primary font-button-text text-button-text">
                                                3 Dan
                                            </span>
<span class="font-body-sm text-body-sm text-on-surface-variant italic">Cấp độ được cập nhật qua các ván đấu xếp hạng.</span>
</div>
</div>
</div>
</div>
<div class="flex justify-end">
<button class="px-xl py-sm bg-primary text-on-primary font-button-text text-button-text rounded-lg shadow-sm hover:bg-primary-container transition-colors focus:ring-2 focus:ring-offset-2 focus:ring-primary outline-none">
                                    Cập nhật
                                </button>
</div>
</section>
<!-- Change Password Card -->
<section class="bg-surface-container-lowest rounded-xl border border-outline-variant/20 shadow-sm p-lg md:p-xl">
<h3 class="font-h2-title text-h2-title text-primary mb-lg flex items-center gap-sm">
<span class="material-symbols-outlined text-outline" data-icon="lock">lock</span>
                                Đổi mật khẩu
                            </h3>
<div class="flex flex-col gap-lg max-w-md">
<div class="relative">
<label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">Mật khẩu hiện tại</label>
<input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm px-0 text-primary font-body-main focus:ring-0 focus:border-primary transition-colors" placeholder="••••••••" type="password"/>
</div>
<div class="relative">
<label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">Mật khẩu mới</label>
<input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm px-0 text-primary font-body-main focus:ring-0 focus:border-primary transition-colors" placeholder="Nhập mật khẩu mới" type="password"/>
</div>
<div class="relative">
<label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">Xác nhận mật khẩu</label>
<input class="w-full bg-transparent border-0 border-b border-outline-variant py-sm px-0 text-primary font-body-main focus:ring-0 focus:border-primary transition-colors" placeholder="Nhập lại mật khẩu mới" type="password"/>
</div>
<div class="mt-sm">
<button class="px-xl py-sm border border-secondary text-secondary font-button-text text-button-text rounded-lg hover:bg-surface-container transition-colors focus:ring-2 focus:ring-offset-2 focus:ring-secondary outline-none">
                                        Đổi mật khẩu
                                    </button>
</div>
</div>
</section>
</div>
<!-- Right Column: Stats (4 cols) -->
<div class="lg:col-span-4 flex flex-col gap-lg">
<h3 class="font-h2-title text-h2-title text-primary flex items-center gap-sm px-sm">
<span class="material-symbols-outlined text-secondary" data-icon="monitoring">monitoring</span>
                            Thống kê
                        </h3>
<!-- Stats Bento Box -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 gap-md">
<!-- Elo Card -->
<div class="bg-surface-container-lowest rounded-xl border border-outline-variant/20 p-xl flex flex-col items-center justify-center relative overflow-hidden shadow-sm group hover:shadow-md transition-shadow">
<!-- Subtle background texture simulation -->
<div class="absolute inset-0 opacity-[0.03] bg-[radial-gradient(#1a2a3a_1px,transparent_1px)] [background-size:16px_16px] pointer-events-none"></div>
<span class="font-label-caps text-label-caps text-on-surface-variant mb-sm tracking-wider uppercase">Elo Rating</span>
<div class="font-h1-display text-[48px] leading-none text-primary font-bold flex items-baseline gap-xs">
                                    2150
                                    <span class="material-symbols-outlined text-secondary text-2xl" data-icon="arrow_upward">arrow_upward</span>
</div>
<span class="font-body-sm text-body-sm text-outline mt-sm">Top 5% kỳ thủ</span>
</div>
<!-- Win Rate Card -->
<div class="bg-surface-container-lowest rounded-xl border border-outline-variant/20 p-lg flex items-center justify-between shadow-sm hover:shadow-md transition-shadow">
<div class="flex flex-col">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-xs tracking-wider">Win Rate</span>
<span class="font-h2-title text-h2-title text-primary font-bold">68%</span>
</div>
<div class="w-12 h-12 rounded-full border-4 border-surface-container-highest border-t-secondary flex items-center justify-center transform rotate-45">
<span class="material-symbols-outlined text-secondary -rotate-45" data-icon="emoji_events">emoji_events</span>
</div>
</div>
<!-- Total Matches Card -->
<div class="bg-surface-container-lowest rounded-xl border border-outline-variant/20 p-lg flex items-center justify-between shadow-sm hover:shadow-md transition-shadow">
<div class="flex flex-col">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-xs tracking-wider">Total Matches</span>
<span class="font-h2-title text-h2-title text-primary font-bold">142</span>
</div>
<div class="w-12 h-12 rounded-lg bg-surface-container flex items-center justify-center text-on-surface-variant">
<span class="material-symbols-outlined" data-icon="swords">swords</span>
</div>
</div>
</div>
<!-- Decorative filler for Zen balance -->
<div class="flex-1 rounded-xl bg-surface-container-low border border-outline-variant/10 min-h-[120px] flex items-center justify-center opacity-50 hidden lg:flex">
<span class="material-symbols-outlined text-outline text-[48px] font-light" data-icon="spa">spa</span>
</div>
</div>
</div>
</div>
</main>
</div>
</body></html>