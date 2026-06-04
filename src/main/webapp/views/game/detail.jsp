<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("activeTab", "game"); %>
<!DOCTYPE html>

<html lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Cờ Vây System - Review Game</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-tertiary": "#ffffff",
                        "surface-bright": "#f7f9fb",
                        "secondary": "#725a39",
                        "on-primary-container": "#8191a5",
                        "tertiary-container": "#1e293a",
                        "on-primary-fixed": "#0c1d2c",
                        "primary-fixed": "#d3e4fa",
                        "surface-tint": "#506072",
                        "on-secondary-container": "#765f3d",
                        "primary-container": "#1a2a3a",
                        "on-error": "#ffffff",
                        "error": "#ba1a1a",
                        "surface-container-low": "#f2f4f6",
                        "surface-container-high": "#e6e8ea",
                        "outline-variant": "#c4c6cc",
                        "secondary-fixed": "#feddb3",
                        "primary-fixed-dim": "#b7c8dd",
                        "on-secondary": "#ffffff",
                        "surface-dim": "#d8dadc",
                        "on-tertiary-fixed-variant": "#3c475a",
                        "background": "#f7f9fb",
                        "on-secondary-fixed": "#281801",
                        "on-surface-variant": "#44474c",
                        "surface": "#f7f9fb",
                        "inverse-on-surface": "#eff1f3",
                        "surface-variant": "#e0e3e5",
                        "secondary-fixed-dim": "#e1c299",
                        "tertiary-fixed-dim": "#bcc7dd",
                        "tertiary-fixed": "#d8e3fa",
                        "on-tertiary-container": "#8590a5",
                        "on-secondary-fixed-variant": "#584324",
                        "error-container": "#ffdad6",
                        "on-error-container": "#93000a",
                        "primary": "#041525",
                        "on-primary": "#ffffff",
                        "outline": "#74777d",
                        "on-tertiary-fixed": "#111c2c",
                        "inverse-primary": "#b7c8dd",
                        "surface-container": "#eceef0",
                        "secondary-container": "#fbdbb0",
                        "surface-container-highest": "#e0e3e5",
                        "tertiary": "#091425",
                        "surface-container-lowest": "#ffffff",
                        "on-primary-fixed-variant": "#384859",
                        "inverse-surface": "#2d3133",
                        "on-surface": "#191c1e",
                        "on-background": "#191c1e"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "gutter": "24px",
                        "xxl": "80px",
                        "xs": "4px",
                        "lg": "24px",
                        "margin": "32px",
                        "unit": "4px",
                        "sm": "8px",
                        "md": "16px",
                        "xl": "48px"
                    },
                    "fontFamily": {
                        "h1-display": ["Inter"],
                        "body-main": ["Inter"],
                        "h2-title": ["Inter"],
                        "body-sm": ["Inter"],
                        "label-caps": ["Inter"],
                        "button-text": ["Inter"]
                    },
                    "fontSize": {
                        "h1-display": ["32px", { "lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "600" }],
                        "body-main": ["16px", { "lineHeight": "1.6", "letterSpacing": "0", "fontWeight": "400" }],
                        "h2-title": ["24px", { "lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "500" }],
                        "body-sm": ["14px", { "lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400" }],
                        "label-caps": ["12px", { "lineHeight": "1.0", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "button-text": ["15px", { "lineHeight": "1.0", "letterSpacing": "0.01em", "fontWeight": "500" }]
                    }
                }
            }
        }
    </script>
<style>
        .board-grid {
            background-image: linear-gradient(to right, #041525 1px, transparent 1px), linear-gradient(to bottom, #041525 1px, transparent 1px);
            background-size: calc(100% / 18) calc(100% / 18);
            background-position: center center;
        }
        .wood-texture {
            background-color: #fbdbb0;
            background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100' height='100' filter='url(%23noise)' opacity='0.08'/%3E%3C/svg%3E");
        }
    </style>
</head>
<body class="bg-surface text-on-surface font-body-main text-body-main antialiased h-screen overflow-hidden flex flex-col">
<!-- TopNavBar -->
<nav class="bg-surface-container-lowest dark:bg-primary docked full-width top-0 z-50 shadow-sm dark:shadow-none border-b border-outline-variant/20 flex justify-between items-center w-full px-margin py-md">
<div class="flex items-center gap-md">
<span class="font-h2-title text-h2-title font-bold text-primary dark:text-primary-fixed">Cờ Vây System</span>
</div>
<div class="flex items-center gap-lg">
<div class="flex gap-sm">
<button class="p-sm rounded-full text-on-surface-variant hover:bg-surface-container-high transition-all scale-95 active:scale-90 transition-transform">
<span class="material-symbols-outlined">notifications</span>
</button>
<button class="p-sm rounded-full text-on-surface-variant hover:bg-surface-container-high transition-all scale-95 active:scale-90 transition-transform">
<span class="material-symbols-outlined">settings</span>
</button>
</div>
<div class="flex items-center gap-sm">
<img alt="Ảnh đại diện kỳ thủ" class="w-10 h-10 rounded-full object-cover border-2 border-surface-container-highest" data-alt="A close-up portrait of a thoughtful Go player looking slightly off-camera. The lighting is soft and natural, emphasizing a calm and focused demeanor. The background is a blurred, minimalist studio setting with subtle warm tones. The overall aesthetic matches the clean, professional light-mode design of a modern digital platform." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBMPvWwleTxSnS7txClRYBGwBoXq-mwoK2369hJygE3R1JdPeLGoh4MO6iaYvgrLKmlkObB29oV09-PO5Wvzg8Tya1ndUW0cMVYkSddmbW3HQBjzxSNvwWh9fZmrJSceiSS1MUf8qGgbk8MFL4HVlRBzLS1v--7ke9keBkawt9FWsTIkruzK5AxdeXzYdKLSrnMTC4LwGp8TBxzxab_1p0Fkyc62WitrsrjptcL2-06vSynewOVEdMZGTmOKJ6c7uGRja_QLLsUQgsU"/>
<button class="font-button-text text-button-text text-primary hover:bg-surface-container-high px-md py-sm rounded-lg transition-all">Đăng xuất</button>
</div>
</div>
</nav>
<div class="flex flex-1 overflow-hidden">
<!-- SideNavBar -->
<jsp:include page="/views/layout/user-sidebar.jsp" />
<!-- Main Canvas -->
<main class="flex-1 bg-surface-bright flex flex-col overflow-hidden relative">
<div class="flex-1 grid grid-cols-12 gap-xl p-xl h-full overflow-hidden">
<!-- Game Board Area (7 columns) -->
<div class="col-span-7 flex flex-col items-center justify-center h-full">
<!-- Player Top -->
<div class="w-full flex justify-between items-center mb-lg px-xl">
<div class="flex items-center gap-md">
<div class="w-12 h-12 rounded-xl wood-texture flex items-center justify-center shadow-sm border border-outline-variant/20">
<div class="w-6 h-6 rounded-full bg-on-tertiary border border-outline-variant"></div>
</div>
<div>
<h3 class="font-h2-title text-body-main font-bold text-primary">MasterAlpha</h3>
<span class="bg-surface-container-high text-primary font-label-caps text-label-caps px-sm py-xs rounded-full inline-block mt-xs">9 Dan</span>
</div>
</div>
<div class="text-right">
<div class="font-h1-display text-h2-title text-primary font-bold bg-surface-container px-md py-sm rounded-lg border-b-2 border-outline-variant/30">12:45</div>
<div class="font-label-caps text-label-caps text-on-surface-variant mt-sm">Tù binh: 12</div>
</div>
</div>
<!-- The Board -->
<div class="relative w-full aspect-square max-w-[600px] wood-texture rounded-sm shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] border-t-[3px] border-l-[3px] border-b-[5px] border-r-[5px] border-[#d4b07e] p-[4%]">
<div class="w-full h-full board-grid relative">
<!-- Star points (Hoshi) -->
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 3 - 2px); left: calc(100% / 18 * 3 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 3 - 2px); left: calc(100% / 18 * 9 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 3 - 2px); left: calc(100% / 18 * 15 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 9 - 2px); left: calc(100% / 18 * 3 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 9 - 2px); left: calc(100% / 18 * 9 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 9 - 2px); left: calc(100% / 18 * 15 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 15 - 2px); left: calc(100% / 18 * 3 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 15 - 2px); left: calc(100% / 18 * 9 - 2px);"></div>
<div class="absolute w-[4px] h-[4px] bg-primary rounded-full" style="top: calc(100% / 18 * 15 - 2px); left: calc(100% / 18 * 15 - 2px);"></div>
<!-- Sample Stones -->
<div class="absolute w-[calc(100%/18.5)] h-[calc(100%/18.5)] bg-primary rounded-full shadow-md transform -translate-x-1/2 -translate-y-1/2" style="top: calc(100% / 18 * 3); left: calc(100% / 18 * 15);"></div>
<div class="absolute w-[calc(100%/18.5)] h-[calc(100%/18.5)] bg-on-tertiary rounded-full shadow-md transform -translate-x-1/2 -translate-y-1/2 border border-outline-variant/30" style="top: calc(100% / 18 * 15); left: calc(100% / 18 * 3);"></div>
<div class="absolute w-[calc(100%/18.5)] h-[calc(100%/18.5)] bg-primary rounded-full shadow-md transform -translate-x-1/2 -translate-y-1/2" style="top: calc(100% / 18 * 15); left: calc(100% / 18 * 16);"></div>
<!-- Last move indicator -->
<div class="absolute w-[calc(100%/18.5)] h-[calc(100%/18.5)] bg-on-tertiary rounded-full shadow-md transform -translate-x-1/2 -translate-y-1/2 border border-outline-variant/30 flex items-center justify-center" style="top: calc(100% / 18 * 14); left: calc(100% / 18 * 15);">
<div class="w-1/3 h-1/3 rounded-full bg-error/80"></div>
</div>
</div>
</div>
<!-- Player Bottom -->
<div class="w-full flex justify-between items-center mt-lg px-xl">
<div class="flex items-center gap-md">
<div class="w-12 h-12 rounded-xl wood-texture flex items-center justify-center shadow-sm border border-outline-variant/20">
<div class="w-6 h-6 rounded-full bg-primary shadow-inner"></div>
</div>
<div>
<h3 class="font-h2-title text-body-main font-bold text-primary">KỳThủ99</h3>
<span class="bg-surface-container-high text-primary font-label-caps text-label-caps px-sm py-xs rounded-full inline-block mt-xs">7 Dan</span>
</div>
</div>
<div class="text-right">
<div class="font-h1-display text-h2-title text-primary font-bold bg-surface-container px-md py-sm rounded-lg border-b-2 border-outline-variant/30">08:15</div>
<div class="font-label-caps text-label-caps text-on-surface-variant mt-sm">Tù binh: 9</div>
</div>
</div>
</div>
<!-- Analysis/Review Sidebar (5 columns) -->
<div class="col-span-5 h-full flex flex-col bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant/20 overflow-hidden">
<!-- Review Controls Header -->
<div class="p-lg border-b border-outline-variant/20 bg-surface-container-low flex flex-col gap-md">
<div class="flex justify-between items-center">
<h2 class="font-h2-title text-h2-title text-primary font-bold">Phân tích ván đấu</h2>
<span class="bg-primary text-on-primary font-label-caps text-label-caps px-sm py-xs rounded-md">Kết thúc</span>
</div>
<!-- Playback Controls -->
<div class="flex items-center justify-center gap-lg py-sm bg-surface-container-lowest rounded-lg border border-outline-variant/20 shadow-sm mt-sm">
<button class="p-sm text-on-surface-variant hover:text-primary transition-colors">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">skip_previous</span>
</button>
<button class="p-sm text-on-surface-variant hover:text-primary transition-colors">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">fast_rewind</span>
</button>
<button class="w-12 h-12 flex items-center justify-center bg-primary text-on-primary rounded-full hover:bg-tertiary-container transition-transform active:scale-95 shadow-md">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">play_arrow</span>
</button>
<button class="p-sm text-on-surface-variant hover:text-primary transition-colors">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">fast_forward</span>
</button>
<button class="p-sm text-on-surface-variant hover:text-primary transition-colors">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">skip_next</span>
</button>
</div>
<div class="flex justify-between items-center mt-xs">
<span class="font-body-sm text-body-sm text-on-surface-variant">Nước đi 142 / 215</span>
<div class="flex items-center gap-xs">
<span class="font-body-sm text-body-sm text-on-surface-variant">Tự động phát</span>
<label class="relative inline-flex items-center cursor-pointer">
<input class="sr-only peer" type="checkbox" value=""/>
<div class="w-9 h-5 bg-surface-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
</label>
</div>
</div>
</div>
<!-- Move List -->
<div class="flex-1 overflow-y-auto p-md space-y-xs">
<!-- Striped List Example -->
<div class="flex items-center justify-between p-sm rounded hover:bg-surface-container transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-on-surface-variant">139</span>
<div class="w-4 h-4 rounded-full bg-primary shadow-sm"></div>
<span class="font-body-main text-body-sm font-medium">Q-16</span>
</div>
<span class="font-body-sm text-body-sm text-on-surface-variant">0:12</span>
</div>
<div class="flex items-center justify-between p-sm rounded bg-surface-container-low hover:bg-surface-container transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-on-surface-variant">140</span>
<div class="w-4 h-4 rounded-full bg-on-tertiary border border-outline-variant/30 shadow-sm"></div>
<span class="font-body-main text-body-sm font-medium">R-15</span>
</div>
<span class="font-body-sm text-body-sm text-on-surface-variant">0:45</span>
</div>
<div class="flex items-center justify-between p-sm rounded hover:bg-surface-container transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-on-surface-variant">141</span>
<div class="w-4 h-4 rounded-full bg-primary shadow-sm"></div>
<span class="font-body-main text-body-sm font-medium">P-15</span>
</div>
<span class="font-body-sm text-body-sm text-on-surface-variant">1:02</span>
</div>
<div class="flex items-center justify-between p-sm rounded bg-secondary-container/50 border border-secondary/20 transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-primary font-bold">142</span>
<div class="w-4 h-4 rounded-full bg-on-tertiary border border-outline-variant/30 shadow-sm relative">
<div class="absolute inset-0 rounded-full border-2 border-error/50"></div>
</div>
<span class="font-body-main text-body-sm font-bold text-primary">O-16</span>
<span class="bg-error/10 text-error font-label-caps text-[10px] px-1 rounded border border-error/20">Nước đi lỗi</span>
</div>
<span class="font-body-sm text-body-sm text-primary font-medium">2:15</span>
</div>
<div class="flex items-center justify-between p-sm rounded hover:bg-surface-container transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-on-surface-variant">143</span>
<div class="w-4 h-4 rounded-full bg-primary shadow-sm"></div>
<span class="font-body-main text-body-sm font-medium">P-16</span>
</div>
<span class="font-body-sm text-body-sm text-on-surface-variant">0:08</span>
</div>
<div class="flex items-center justify-between p-sm rounded bg-surface-container-low hover:bg-surface-container transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-on-surface-variant">144</span>
<div class="w-4 h-4 rounded-full bg-on-tertiary border border-outline-variant/30 shadow-sm"></div>
<span class="font-body-main text-body-sm font-medium">N-17</span>
</div>
<span class="font-body-sm text-body-sm text-on-surface-variant">0:22</span>
</div>
<div class="flex items-center justify-center py-md">
<div class="w-1 px-1 bg-surface-variant rounded-full h-8 flex flex-col justify-between items-center opacity-50">
<div class="w-1 h-1 bg-on-surface-variant rounded-full"></div>
<div class="w-1 h-1 bg-on-surface-variant rounded-full"></div>
<div class="w-1 h-1 bg-on-surface-variant rounded-full"></div>
</div>
</div>
<div class="flex items-center justify-between p-sm rounded bg-surface-container-low hover:bg-surface-container transition-colors cursor-pointer">
<div class="flex items-center gap-md">
<span class="w-8 text-center font-label-caps text-label-caps text-on-surface-variant">215</span>
<div class="w-4 h-4 rounded-full bg-primary shadow-sm"></div>
<span class="font-body-main text-body-sm font-medium">Bỏ lượt</span>
</div>
<span class="font-body-sm text-body-sm text-on-surface-variant">0:05</span>
</div>
</div>
<!-- Score Calculation Panel (Tính điểm) -->
<div class="p-lg bg-surface-container border-t-2 border-secondary-container">
<h3 class="font-h2-title text-body-main font-bold text-primary mb-md flex items-center gap-sm">
<span class="material-symbols-outlined">calculate</span>
                            Tính điểm (Kết quả)
                        </h3>
<div class="space-y-sm">
<div class="flex justify-between items-center border-b border-outline-variant/20 pb-sm">
<div class="flex items-center gap-sm">
<div class="w-3 h-3 rounded-full bg-primary"></div>
<span class="font-body-sm text-body-sm text-on-surface-variant">Đen (KỳThủ99)</span>
</div>
<div class="text-right">
<span class="font-body-main text-body-main font-bold text-primary">68.0</span>
<p class="font-label-caps text-[10px] text-on-surface-variant">Lãnh thổ: 59 | Tù binh: 9</p>
</div>
</div>
<div class="flex justify-between items-center border-b border-outline-variant/20 pb-sm">
<div class="flex items-center gap-sm">
<div class="w-3 h-3 rounded-full bg-on-tertiary border border-outline-variant"></div>
<span class="font-body-sm text-body-sm text-on-surface-variant">Trắng (MasterAlpha)</span>
</div>
<div class="text-right">
<span class="font-body-main text-body-main font-bold text-primary">74.5</span>
<p class="font-label-caps text-[10px] text-on-surface-variant">Lãnh thổ: 56 | Tù binh: 12 | Komi: 6.5</p>
</div>
</div>
<div class="pt-sm text-center">
<p class="font-body-main text-body-main font-bold text-secondary">Trắng thắng 6.5 điểm</p>
</div>
</div>
<div class="mt-md flex gap-sm">
<button class="flex-1 py-sm rounded-lg border border-outline-variant font-button-text text-button-text text-primary hover:bg-surface-container-highest transition-colors">Tải SGF</button>
<button class="flex-1 py-sm rounded-lg bg-primary text-on-primary font-button-text text-button-text hover:bg-tertiary-container transition-colors shadow-sm">Phân tích AI</button>
</div>
</div>
</div>
</div>
</main>
</div>
</body></html>