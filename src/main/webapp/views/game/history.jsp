<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("activeTab", "history"); %>
<!DOCTYPE html>

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Lịch sử ván đấu - Tâm Thế</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com" rel="preconnect"/>
<link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<style>
        .material-symbols-outlined {
            font-family: 'Material Symbols Outlined';
            font-weight: normal;
            font-style: normal;
            font-size: 24px;
            line-height: 1;
            letter-spacing: normal;
            text-transform: none;
            display: inline-block;
            white-space: nowrap;
            word-wrap: normal;
            direction: ltr;
            -webkit-font-feature-settings: 'liga';
            -webkit-font-smoothing: antialiased;
        }

        /* Custom Ambient Shadow from Design Guidelines */
        .shadow-ambient {
            box-shadow: 0 10px 25px -5px rgba(26, 42, 58, 0.08);
        }
    </style>
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
                        "h1-display": ["Inter"],
                        "body-main": ["Inter"],
                        "button-text": ["Inter"],
                        "label-caps": ["Inter"],
                        "body-sm": ["Inter"],
                        "h2-title": ["Inter"]
                    },
                    "fontSize": {
                        "h1-display": ["32px", { "lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "600" }],
                        "body-main": ["16px", { "lineHeight": "1.6", "letterSpacing": "0", "fontWeight": "400" }],
                        "button-text": ["15px", { "lineHeight": "1.0", "letterSpacing": "0.01em", "fontWeight": "500" }],
                        "label-caps": ["12px", { "lineHeight": "1.0", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "body-sm": ["14px", { "lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400" }],
                        "h2-title": ["24px", { "lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "500" }]
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-background text-on-background font-body-main min-h-screen flex flex-col md:flex-row">
<!-- Web Navigation: SideNavBar (Hidden on Mobile) -->
<jsp:include page="/views/layout/user-sidebar.jsp" />
<!-- Main Content Canvas -->
<main class="flex-1 flex flex-col min-w-0">
<!-- Mobile Navigation: TopNavBar (Hidden on Web) -->
<header class="md:hidden flex justify-between items-center w-full px-margin py-md bg-surface-container-lowest text-primary font-body-main text-body-main docked full-width top-0 z-50 shadow-sm border-b border-outline-variant/20 transition-transform">
<div class="font-h2-title text-h2-title font-bold text-primary">Cờ Vây System</div>
<div class="flex items-center gap-md">
<button class="text-on-surface-variant hover:bg-surface-container-high transition-all p-sm rounded-full scale-95 active:scale-90">
<span class="material-symbols-outlined">notifications</span>
</button>
<button class="text-on-surface-variant hover:bg-surface-container-high transition-all p-sm rounded-full scale-95 active:scale-90">
<span class="material-symbols-outlined">settings</span>
</button>
<img alt="Ảnh đại diện kỳ thủ" class="w-8 h-8 rounded-full border border-outline-variant/20 ml-sm" data-alt="A minimalist, circular avatar placeholder for a Go player profile. The background is a sophisticated navy blue. The lighting is completely flat, fitting a pure digital UI context. The style is strictly minimalist, conveying a professional and focused atmosphere typical of modern board game applications." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDi8qYN5SpjRIo2ah4LUb77B-RVOGaVmFgHbxxfuOB180xbHABwNgG6wpM7ud31JANZELiGU80Gp1-KfeTcBLfr8D2ZvTADHI08b8Ta1ceuCmwlJYQDJkUkwuCXtRqTVSOB7XkGjXDN1wC-LDZBu79eXVNcBImxD7DR4An8OW1u59Es-UThDj7JcVfKT3UGpm6yyqmqXJW-tI3XSy-dHEMeewciYvTxjW7qWgf0fElmI38Rez0LGel2PiQMZbiKADOIP_dNxilVFqFO"/>
</div>
</header>
<!-- Page Content -->
<div class="flex-1 overflow-y-auto px-lg md:px-xl py-lg md:py-xl">
<!-- Header Section -->
<div class="flex flex-col md:flex-row md:items-end justify-between mb-xl gap-md">
<div>
<h2 class="font-h1-display text-h1-display text-primary mb-xs">Lịch sử ván đấu</h2>
<p class="font-body-main text-body-main text-on-surface-variant">Xem lại các ván cờ đã chơi, phân tích chiến thuật và theo dõi tiến độ.</p>
</div>
<!-- Search/Filter Input (Minimalist tactile design) -->
<div class="relative w-full md:w-64">
<span class="material-symbols-outlined absolute left-0 top-1/2 -translate-y-1/2 text-outline pb-sm">search</span>
<input class="w-full bg-transparent border-0 border-b border-outline-variant focus:border-primary focus:ring-0 pl-lg pb-sm text-primary placeholder-outline font-body-sm text-body-sm transition-colors" placeholder="Tìm kiếm đối thủ..." type="text"/>
</div>
</div>
<!-- Bento Stats Summary -->
<div class="grid grid-cols-2 md:grid-cols-4 gap-md mb-xl">
<!-- Stat Card 1 -->
<div class="bg-surface-container-lowest rounded-lg p-md shadow-sm border-t-2 border-secondary flex flex-col justify-between">
<span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-wider">Tổng ván</span>
<div class="font-h2-title text-h2-title text-primary mt-sm">1,248</div>
</div>
<!-- Stat Card 2 -->
<div class="bg-surface-container-lowest rounded-lg p-md shadow-sm border-t-2 border-primary-container flex flex-col justify-between">
<span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-wider">Thắng</span>
<div class="font-h2-title text-h2-title text-primary mt-sm">742</div>
</div>
<!-- Stat Card 3 -->
<div class="bg-surface-container-lowest rounded-lg p-md shadow-sm border-t-2 border-outline-variant flex flex-col justify-between">
<span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-wider">Tỷ lệ thắng</span>
<div class="font-h2-title text-h2-title text-primary mt-sm">59.4%</div>
</div>
<!-- Stat Card 4 (Win Streak) -->
<div class="bg-surface-container-lowest rounded-lg p-md shadow-sm border-t-2 border-secondary-container flex flex-col justify-between">
<span class="font-label-caps text-label-caps text-on-surface-variant uppercase tracking-wider">Chuỗi thắng</span>
<div class="font-h2-title text-h2-title text-primary mt-sm flex items-center gap-xs">
                        4 <span class="material-symbols-outlined text-[16px] text-secondary">local_fire_department</span>
</div>
</div>
</div>
<!-- Matches List/Grid (Bento style cards) -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-lg">
<!-- Match Card 1 (Win) -->
<article class="bg-surface-container-lowest rounded-xl p-lg shadow-sm hover:shadow-ambient transition-shadow border border-outline-variant/10 relative overflow-hidden group">
<!-- Top accent line -->
<div class="absolute top-0 left-0 w-full h-1 bg-secondary-container"></div>
<div class="flex justify-between items-start mb-md">
<div class="font-label-caps text-label-caps text-on-surface-variant">14 Tháng 10, 2023 • 15:30</div>
<!-- Status Chip -->
<div class="px-sm py-xs bg-primary-container text-on-primary rounded-full font-label-caps text-label-caps flex items-center gap-xs">
<span class="material-symbols-outlined text-[14px]">emoji_events</span>
                            Thắng
                        </div>
</div>
<div class="flex items-center gap-md mb-lg">
<img alt="Avatar" class="w-12 h-12 rounded-lg border border-outline-variant/20" data-alt="A minimalist avatar for an online Go opponent. The image is a simple square with rounded corners, featuring a soft gray background and a clean, dark navy blue geometric shape in the center. The style is flat and unobtrusive, designed to blend seamlessly into a serene, tactical user interface without causing distraction." src="https://lh3.googleusercontent.com/aida-public/AB6AXuD73jBKai-yBjGcj3bVbQn3436nWUP9IWppJ97oF_0tekA0UB5VbbC8NND4_MdmXljJWIOPlew8_X2p30VSjY3R9IZFGYTVz_B-qOrMwAngYIEJSZL690RTp5xDdKE8G8Xr9zUnWWgpQFiXSF1WukSEMACzP7T9tsAkhitVSUmJayLAVGiYd56BE595W3ekZrY7jH4OUjeIKCDWUtVssKpkcafksmS8Qn2k7kw1HcBhkvCaf_07_nkL8USmgHRJAFCOMdTG9Nd80snw"/>
<div>
<h3 class="font-body-main text-body-main font-semibold text-primary">KỳThủẨnDanh</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant flex items-center gap-xs">
<span class="w-2 h-2 rounded-full bg-secondary"></span>
                                Cầm quân Đen (3 Dan)
                            </p>
</div>
</div>
<div class="flex items-center justify-between border-t border-outline-variant/10 pt-md">
<div>
<div class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Kết quả</div>
<div class="font-body-main text-body-main font-medium text-primary">W+Resign</div>
</div>
<button class="bg-surface-container-low hover:bg-surface-container-high text-primary font-button-text text-button-text px-md py-sm rounded-lg transition-colors flex items-center gap-sm border border-outline-variant/20" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-[18px]">visibility</span>
                            Xem lại
                        </button>
</div>
</article>
<!-- Match Card 2 (Loss) -->
<article class="bg-surface-container-lowest rounded-xl p-lg shadow-sm hover:shadow-ambient transition-shadow border border-outline-variant/10 relative overflow-hidden group">
<div class="absolute top-0 left-0 w-full h-1 bg-surface-variant"></div>
<div class="flex justify-between items-start mb-md">
<div class="font-label-caps text-label-caps text-on-surface-variant">12 Tháng 10, 2023 • 09:15</div>
<!-- Status Chip -->
<div class="px-sm py-xs bg-surface-variant text-on-surface-variant rounded-full font-label-caps text-label-caps flex items-center gap-xs">
<span class="material-symbols-outlined text-[14px]">close</span>
                            Thua
                        </div>
</div>
<div class="flex items-center gap-md mb-lg">
<img alt="Avatar" class="w-12 h-12 rounded-lg border border-outline-variant/20" data-alt="A minimalist avatar for an online Go opponent. The image is a simple square with rounded corners, featuring a soft gray background and a clean, dark navy blue geometric shape in the center. The style is flat and unobtrusive, designed to blend seamlessly into a serene, tactical user interface without causing distraction." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCAVqNS4QVVIQGAjYb9sWasqD0VmIALGt5JsrPkgIlnyH6QMLbQ3x3F8DOxdDo-sxiPmM2MoTuAljmE1NUS4QU5yhvGDHJ1nwtayqnTGHKCLxduPC8REWa4SJZdmUhM21rBzgL8F8TX31tQMMPGeQtybNr3sY3wrr42IoLMrtHXhAjMIt0FJ7Yzgz-eSgmZN4kxcLJw080gMm3SVwzw0DZsT3NdgZYR-cWJyeoewHr0qB8Zrv3rudCH6wB-gX2cdFymV7YjP4iIO0e9"/>
<div>
<h3 class="font-body-main text-body-main font-semibold text-primary">MasterGo99</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant flex items-center gap-xs">
<span class="w-2 h-2 rounded-full border-2 border-primary bg-white"></span>
                                Cầm quân Trắng (4 Dan)
                            </p>
</div>
</div>
<div class="flex items-center justify-between border-t border-outline-variant/10 pt-md">
<div>
<div class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Kết quả</div>
<div class="font-body-main text-body-main font-medium text-primary">B+2.5</div>
</div>
<button class="bg-surface-container-low hover:bg-surface-container-high text-primary font-button-text text-button-text px-md py-sm rounded-lg transition-colors flex items-center gap-sm border border-outline-variant/20" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-[18px]">visibility</span>
                            Xem lại
                        </button>
</div>
</article>
<!-- Match Card 3 (Win) -->
<article class="bg-surface-container-lowest rounded-xl p-lg shadow-sm hover:shadow-ambient transition-shadow border border-outline-variant/10 relative overflow-hidden group">
<div class="absolute top-0 left-0 w-full h-1 bg-secondary-container"></div>
<div class="flex justify-between items-start mb-md">
<div class="font-label-caps text-label-caps text-on-surface-variant">10 Tháng 10, 2023 • 20:00</div>
<div class="px-sm py-xs bg-primary-container text-on-primary rounded-full font-label-caps text-label-caps flex items-center gap-xs">
<span class="material-symbols-outlined text-[14px]">emoji_events</span>
                            Thắng
                        </div>
</div>
<div class="flex items-center gap-md mb-lg">
<img alt="Avatar" class="w-12 h-12 rounded-lg border border-outline-variant/20" data-alt="A minimalist avatar for an online Go opponent. The image is a simple square with rounded corners, featuring a soft gray background and a clean, dark navy blue geometric shape in the center. The style is flat and unobtrusive, designed to blend seamlessly into a serene, tactical user interface without causing distraction." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDJ4sAGhuSH8E0o3dhqOZEk-gWD4G4hRKFDT0Z4hPYY0ux-jF1mTM-3IFxVQ4IeF4iSOxZeEO_nBEjcDaySSBAqFKdDS_ge4cOZDA1iGGKd1V5Ek5cHpfVlrtvNYR8t7ScyQV1aOeD0670lm-nE4vRix8Hdsj5W0I1MGJx_SwNeCJi8G-UrXbtZglAUt_ZEwYaRf52vxFvW4GMIrLm4KehvcC9urIik1RqNnG8DBtnmytfJ7-mo-m7jeIor3NSElDNVWdCkJdaMUOpd"/>
<div>
<h3 class="font-body-main text-body-main font-semibold text-primary">ShadowStones</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant flex items-center gap-xs">
<span class="w-2 h-2 rounded-full border-2 border-primary bg-white"></span>
                                Cầm quân Trắng (2 Dan)
                            </p>
</div>
</div>
<div class="flex items-center justify-between border-t border-outline-variant/10 pt-md">
<div>
<div class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Kết quả</div>
<div class="font-body-main text-body-main font-medium text-primary">W+Time</div>
</div>
<button class="bg-surface-container-low hover:bg-surface-container-high text-primary font-button-text text-button-text px-md py-sm rounded-lg transition-colors flex items-center gap-sm border border-outline-variant/20" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-[18px]">visibility</span>
                            Xem lại
                        </button>
</div>
</article>
<!-- Match Card 4 (Win) -->
<article class="bg-surface-container-lowest rounded-xl p-lg shadow-sm hover:shadow-ambient transition-shadow border border-outline-variant/10 relative overflow-hidden group">
<div class="absolute top-0 left-0 w-full h-1 bg-secondary-container"></div>
<div class="flex justify-between items-start mb-md">
<div class="font-label-caps text-label-caps text-on-surface-variant">08 Tháng 10, 2023 • 14:20</div>
<div class="px-sm py-xs bg-primary-container text-on-primary rounded-full font-label-caps text-label-caps flex items-center gap-xs">
<span class="material-symbols-outlined text-[14px]">emoji_events</span>
                            Thắng
                        </div>
</div>
<div class="flex items-center gap-md mb-lg">
<img alt="Avatar" class="w-12 h-12 rounded-lg border border-outline-variant/20" data-alt="A minimalist avatar for an online Go opponent. The image is a simple square with rounded corners, featuring a soft gray background and a clean, dark navy blue geometric shape in the center. The style is flat and unobtrusive, designed to blend seamlessly into a serene, tactical user interface without causing distraction." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDHCXtXM_vdPHo3RI-B8zCkwBldGEd6w15eOeIY8Ul6mkzRWKUFkH8qijalVjvKBp-O5TJGhqWqlQz9WXFvpMIGeggLuQP9LODmfXLFUmzoiZvqEMtA7MRvnoLl3xok--Cc3k2FvCpVgICqr8dfrjhwfNHZ1q3ZjfPYypho8qx08iUgDArBFu_Ad81t5EGpISEaEuA48Lw_4dB0LhFznnf1lFMnt5ffmQLzHSYzvTe_lj4pBW2ft4Mfodum1g42OmYxCZOGXxelQZOX"/>
<div>
<h3 class="font-body-main text-body-main font-semibold text-primary">ZenMindset</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant flex items-center gap-xs">
<span class="w-2 h-2 rounded-full bg-secondary"></span>
                                Cầm quân Đen (3 Dan)
                            </p>
</div>
</div>
<div class="flex items-center justify-between border-t border-outline-variant/10 pt-md">
<div>
<div class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Kết quả</div>
<div class="font-body-main text-body-main font-medium text-primary">W+12.5</div>
</div>
<button class="bg-surface-container-low hover:bg-surface-container-high text-primary font-button-text text-button-text px-md py-sm rounded-lg transition-colors flex items-center gap-sm border border-outline-variant/20" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-[18px]">visibility</span>
                            Xem lại
                        </button>
</div>
</article>
</div>
<!-- Load More (Tactile style) -->
<div class="mt-xl text-center">
<button class="inline-flex items-center gap-sm font-button-text text-button-text text-primary px-lg py-md rounded-lg border-2 border-surface-container-highest hover:bg-surface-container-low hover:border-outline-variant/50 transition-all">
<span class="material-symbols-outlined">expand_more</span>
                    Tải thêm lịch sử
                </button>
</div>
</div>
</main>
</body></html>