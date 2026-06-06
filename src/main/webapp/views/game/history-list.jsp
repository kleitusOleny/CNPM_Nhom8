<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("activeTab", "history"); %>
<!DOCTYPE html>

<html lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Lịch sử - Tâm Thế</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com" rel="preconnect"/>
<link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
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
                      "h1-display": [
                              "Inter"
                      ],
                      "body-main": [
                              "Inter"
                      ],
                      "h2-title": [
                              "Inter"
                      ],
                      "body-sm": [
                              "Inter"
                      ],
                      "label-caps": [
                              "Inter"
                      ],
                      "button-text": [
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
                      "label-caps": [
                              "12px",
                              {
                                      "lineHeight": "1.0",
                                      "letterSpacing": "0.05em",
                                      "fontWeight": "600"
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
<body class="bg-surface text-on-surface font-body-main flex h-screen overflow-hidden">
<!-- SideNavBar (Desktop Only) -->
<jsp:include page="/views/layout/user-sidebar.jsp" />
<!-- Main Content Area -->
<main class="flex-1 flex flex-col h-full overflow-hidden">
<!-- TopNavBar (Mobile Only) -->
<header class="md:hidden flex justify-between items-center w-full px-margin py-md bg-surface-container-lowest border-b border-outline-variant/20 shadow-sm z-50">
<h1 class="font-h2-title text-h2-title font-bold text-primary">Cờ Vây System</h1>
<div class="flex items-center gap-md">
<button class="text-primary hover:bg-surface-container-high p-sm rounded-full transition-all">
<span class="material-symbols-outlined">notifications</span>
</button>
<button class="text-primary hover:bg-surface-container-high p-sm rounded-full transition-all">
<span class="material-symbols-outlined">settings</span>
</button>
</div>
</header>
<!-- Canvas -->
<div class="flex-1 overflow-y-auto p-margin md:p-xl bg-surface">
<!-- Header Section -->
<div class="flex flex-col md:flex-row md:items-center justify-between mb-xl gap-md">
<div>
<h2 class="font-h1-display text-h1-display text-primary mb-xs">Lịch sử ván đấu</h2>
<p class="font-body-main text-body-main text-on-surface-variant">Xem lại các trận đấu gần đây của bạn.</p>
</div>
<!-- Filters -->
<div class="flex gap-sm">
<select class="bg-surface-container-low border border-outline-variant/50 text-on-surface font-body-sm text-body-sm rounded-lg px-md py-sm focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary appearance-none pr-xl relative">
<option>Tất cả kết quả</option>
<option>Thắng</option>
<option>Thua</option>
<option>Hòa</option>
</select>
<select class="bg-surface-container-low border border-outline-variant/50 text-on-surface font-body-sm text-body-sm rounded-lg px-md py-sm focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary appearance-none pr-xl relative">
<option>Tháng này</option>
<option>Tháng trước</option>
<option>Năm nay</option>
</select>
</div>
</div>
<!-- Bento Grid List -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-lg">
<!-- Match Card 1 -->
<div class="bg-surface-container-lowest rounded-xl p-lg border-t-2 border-secondary-container shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] flex flex-col justify-between h-full hover:-translate-y-1 transition-transform duration-300">
<div>
<div class="flex justify-between items-start mb-md">
<span class="bg-primary-fixed text-on-primary-fixed font-label-caps text-label-caps px-sm py-xs rounded-full uppercase tracking-wider">Thắng</span>
<span class="text-on-surface-variant font-body-sm text-body-sm">12/10/2023</span>
</div>
<div class="flex items-center gap-md mb-lg">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center overflow-hidden border border-outline-variant/30">
<img alt="Avatar" class="w-full h-full object-cover" data-alt="A detailed headshot portrait of a focused individual representing a Go opponent, set against a clean, minimalist studio background with soft white lighting. The mood is calm and intellectual, fitting the serene aesthetic of a traditional Go match." src="https://lh3.googleusercontent.com/aida-public/AB6AXuC3qOBfIM-AZ1UMF6DddmAGGl-AfFrs1cnBZmy3_VxbRvdG_Ua3eD3yITorWsAZ_GtiMKGR5n2vQvu-W5cxojccOtikGbno2jnJ-KmxpOmhmc5hmRICuB3o563LzxvGjTNP0esEKbjSMr2WezsPlwkjbuJgZciaV51-0sE_ZRCknVy5uMilXRDpupfWR_eWQZ87XrZuEn-iHwZCai48pfHrDC385HsINFGm0sd_K38frUqTloQf-gxzqAEs5GACmzObzhw4-hSGArLj"/>
</div>
<div>
<p class="font-h2-title text-body-main font-semibold text-primary">vs Trần Văn A</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">4 Dan • Đen</p>
</div>
</div>
<div class="space-y-xs mb-lg">
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Thời gian:</span>
<span class="font-medium text-on-surface">45 phút</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Số nước:</span>
<span class="font-medium text-on-surface">214</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Kết quả:</span>
<span class="font-medium text-on-surface">W+R</span>
</div>
</div>
</div>
<button class="w-full border border-secondary text-secondary hover:bg-secondary hover:text-on-secondary font-button-text text-button-text py-sm rounded-lg transition-colors flex justify-center items-center gap-xs" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-sm">visibility</span>
                        Xem lại
                    </button>
</div>
<!-- Match Card 2 -->
<div class="bg-surface-container-lowest rounded-xl p-lg border-t-2 border-outline-variant shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] flex flex-col justify-between h-full hover:-translate-y-1 transition-transform duration-300">
<div>
<div class="flex justify-between items-start mb-md">
<span class="bg-surface-container-high text-on-surface font-label-caps text-label-caps px-sm py-xs rounded-full uppercase tracking-wider">Thua</span>
<span class="text-on-surface-variant font-body-sm text-body-sm">10/10/2023</span>
</div>
<div class="flex items-center gap-md mb-lg">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center overflow-hidden border border-outline-variant/30">
<img alt="Avatar" class="w-full h-full object-cover" data-alt="A detailed portrait of a serious male Go player with a thoughtful expression, illuminated by soft, natural studio lighting. The background is a stark, clean white to emphasize a minimalist, professional look consistent with the Zen digital environment." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAhaXV6Qt_WnCTGQOKIl9ebO11cZCG6jzDMqCy0IHb-6OytcntolWThQgS8x59bMQSUTm6RxdiRfyqyhVcngbE3pHHFyLnEf-GtMzhMWb1ryzyZkyUDvZyQU8G4Oqxk_glGcup_WMRU-tpvvcCcDex58_M1SLZU-6Bwu55H2FifeEOll00Nfb2KqCfEIT2-xhEaJ8MydB4g1gLZBX_GrJTnXl90hseX8-cTfU5IKiQmOeygHbtKmTdubeockFtOBEz_MiAAZbj6VHTB"/>
</div>
<div>
<p class="font-h2-title text-body-main font-semibold text-primary">vs Lê Thị B</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">5 Dan • Trắng</p>
</div>
</div>
<div class="space-y-xs mb-lg">
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Thời gian:</span>
<span class="font-medium text-on-surface">1h 12m</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Số nước:</span>
<span class="font-medium text-on-surface">312</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Kết quả:</span>
<span class="font-medium text-on-surface">B+2.5</span>
</div>
</div>
</div>
<button class="w-full border border-secondary text-secondary hover:bg-secondary hover:text-on-secondary font-button-text text-button-text py-sm rounded-lg transition-colors flex justify-center items-center gap-xs" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-sm">visibility</span>
                        Xem lại
                    </button>
</div>
<!-- Match Card 3 -->
<div class="bg-surface-container-lowest rounded-xl p-lg border-t-2 border-secondary-container shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] flex flex-col justify-between h-full hover:-translate-y-1 transition-transform duration-300">
<div>
<div class="flex justify-between items-start mb-md">
<span class="bg-primary-fixed text-on-primary-fixed font-label-caps text-label-caps px-sm py-xs rounded-full uppercase tracking-wider">Thắng</span>
<span class="text-on-surface-variant font-body-sm text-body-sm">05/10/2023</span>
</div>
<div class="flex items-center gap-md mb-lg">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center overflow-hidden border border-outline-variant/30">
<img alt="Avatar" class="w-full h-full object-cover" data-alt="A soft, high-key studio portrait of a woman representing a Go opponent, bathed in bright, minimalist light. The overall aesthetic is serene and focused, utilizing a subtle palette to blend with a calm, tactile digital interface." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCfP8yy5ItAfb1YP-IBLFB7okKK5JDfGHcWsUX5wb7nMuhbtJ2CKAt8Uv5hiOgGEqOEPeAoCcQSWCa80I8njmIRXKAppUa30Ggv5eCgToMKxSnx6n9hpQ3jAUlLWyvohr6N6-c4Yj3v21Kq_rphn9VbiRl5WjhaIAAMS81fC2fQFgjBn-DYSS539Dx1f_GDALtiouWMoivLtpF5xKpQ6p5fRjMVxUlsaW_70VvB0Zvh29vGX1EJrByzjZZBChfczFgsooKXxGdXCzAn"/>
</div>
<div>
<p class="font-h2-title text-body-main font-semibold text-primary">vs Nguyễn Văn C</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">3 Dan • Đen</p>
</div>
</div>
<div class="space-y-xs mb-lg">
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Thời gian:</span>
<span class="font-medium text-on-surface">30 phút</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Số nước:</span>
<span class="font-medium text-on-surface">156</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Kết quả:</span>
<span class="font-medium text-on-surface">W+Time</span>
</div>
</div>
</div>
<button class="w-full border border-secondary text-secondary hover:bg-secondary hover:text-on-secondary font-button-text text-button-text py-sm rounded-lg transition-colors flex justify-center items-center gap-xs" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-sm">visibility</span>
                        Xem lại
                    </button>
</div>
<!-- Match Card 4 -->
<div class="bg-surface-container-lowest rounded-xl p-lg border-t-2 border-outline-variant shadow-[0_10px_25px_-5px_rgba(26,42,58,0.08)] flex flex-col justify-between h-full hover:-translate-y-1 transition-transform duration-300 hidden md:flex">
<div>
<div class="flex justify-between items-start mb-md">
<span class="bg-surface-container-high text-on-surface font-label-caps text-label-caps px-sm py-xs rounded-full uppercase tracking-wider">Thua</span>
<span class="text-on-surface-variant font-body-sm text-body-sm">01/10/2023</span>
</div>
<div class="flex items-center gap-md mb-lg">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center overflow-hidden border border-outline-variant/30">
<span class="material-symbols-outlined text-on-surface-variant">person</span>
</div>
<div>
<p class="font-h2-title text-body-main font-semibold text-primary">vs Khách ẩn danh</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">1 Kyu • Trắng</p>
</div>
</div>
<div class="space-y-xs mb-lg">
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Thời gian:</span>
<span class="font-medium text-on-surface">10 phút</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Số nước:</span>
<span class="font-medium text-on-surface">245</span>
</div>
<div class="flex justify-between font-body-sm text-body-sm text-on-surface-variant">
<span>Kết quả:</span>
<span class="font-medium text-on-surface">B+15.5</span>
</div>
</div>
</div>
<button class="w-full border border-secondary text-secondary hover:bg-secondary hover:text-on-secondary font-button-text text-button-text py-sm rounded-lg transition-colors flex justify-center items-center gap-xs" onclick="window.location.href='${pageContext.request.contextPath}/game/1/detail'">
<span class="material-symbols-outlined text-sm">visibility</span>
                        Xem lại
                    </button>
</div>
</div>
<!-- Pagination/Load More -->
<div class="mt-xl flex justify-center pb-xl">
<button class="bg-surface-container-high text-on-surface hover:bg-surface-container-highest font-button-text text-button-text py-sm px-lg rounded-lg transition-colors border border-outline-variant/50">
                    Tải thêm ván đấu
                </button>
</div>
</div>
</main>
<!-- BottomNavBar (Mobile Only) -->
<nav class="md:hidden w-full bg-surface-container-lowest border-t border-outline-variant/20 fixed bottom-0 z-50">
<div class="flex justify-around items-center h-16">
<a class="flex flex-col items-center justify-center w-full h-full text-on-surface-variant hover:bg-surface-container-high transition-colors" href="${pageContext.request.contextPath}/lobby">
<span class="material-symbols-outlined mb-1">view_quilt</span>
<span class="font-label-caps text-[10px]">Sảnh chờ</span>
</a>
<a class="flex flex-col items-center justify-center w-full h-full text-primary border-t-2 border-primary bg-primary-container/10 transition-colors" href="${pageContext.request.contextPath}/history">
<span class="material-symbols-outlined mb-1">history</span>
<span class="font-label-caps text-[10px] font-bold">Lịch sử</span>
</a>
<a class="flex flex-col items-center justify-center w-full h-full text-on-surface-variant hover:bg-surface-container-high transition-colors" href="${pageContext.request.contextPath}/game">
<span class="material-symbols-outlined mb-1">grid_4x4</span>
<span class="font-label-caps text-[10px]">Ván đấu</span>
</a>
<a class="flex flex-col items-center justify-center w-full h-full text-on-surface-variant hover:bg-surface-container-high transition-colors" href="#">
<span class="material-symbols-outlined mb-1">group</span>
<span class="font-label-caps text-[10px]">Thành viên</span>
</a>
</div>
</nav>
</body></html>