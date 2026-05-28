<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="hidden md:flex flex-col bg-surface-container-low text-primary font-body-sm text-body-sm h-screen sticky left-0 w-64 border-r border-outline-variant/20 shadow-sm transition-all duration-300 ease-in-out py-lg">
<!-- Header -->
<div class="px-md mb-xl flex items-center gap-md">
<img alt="Logo Tâm Thế" class="w-10 h-10 rounded-lg shadow-sm" data-alt="A minimalist, high-end logo placeholder for 'Tâm Thế', a traditional Go application. The logo features a solid dark navy blue square base with perfectly rounded corners. Imprinted on the center are crisp, elegant white geometric shapes or text. The lighting is subtle, creating a slight 3D extrusion effect typical of premium tactile digital interfaces." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCxJOR_5KhTlCvDf_quA3wwYJNhNSOONvICByw9xLVPXsc9ZBFgyhmq3mTt5fBe_MSQTKfMFcreslX2fPa-iENnk4wxUTht6MLQ0jihHeFeIk9u4nSytgNmpHxVg6UYvWwqQmSYuiYcbxIrmiXEq63ST5KyM9lh0Qpb0GO-a1asQIafKpgXg1YJd6PpkJlmmDQmpFcUDUWqN7jYw_J1rSSnbt9zvai5VqkQAlqMcKYU9sKxKuETZ1Sj6CRShPY6oBrK28rMUT-Bvfq2"/>
<div>
<h1 class="font-h2-title text-h2-title text-primary font-bold">Tâm Thế</h1>
<p class="text-on-surface-variant text-label-caps font-label-caps">Kỳ viện kỹ thuật số</p>
</div>
</div>
<!-- CTA -->
<div class="px-md mb-lg">
<button class="w-full bg-primary text-on-primary font-button-text text-button-text py-md rounded-lg shadow-ambient hover:shadow-md transition-shadow flex items-center justify-center gap-sm" onclick="window.location.href='${pageContext.request.contextPath}/create-room'">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">add_circle</span>
                Ván mới
</button>
</div>
<!-- Main Navigation Links -->
<div class="flex-1 overflow-y-auto space-y-sm">
<!-- Sảnh chờ: Inactive -->
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg <%= "lobby".equals(request.getAttribute("activeTab")) ? "bg-secondary-container text-on-secondary-container font-bold shadow-sm" : "text-on-surface-variant hover:bg-surface-container-high transition-colors" %>" href="${pageContext.request.contextPath}/lobby">
<span class="material-symbols-outlined" <%= "lobby".equals(request.getAttribute("activeTab")) ? "style=\"font-variation-settings: 'FILL' 1;\"" : "" %>>view_quilt</span>
<span>Sảnh chờ</span>
</a>
<!-- Lịch sử: Active (Index 1) -->
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg <%= "history".equals(request.getAttribute("activeTab")) ? "bg-secondary-container text-on-secondary-container font-bold shadow-sm" : "text-on-surface-variant hover:bg-surface-container-high transition-colors" %>" href="${pageContext.request.contextPath}/history">
<span class="material-symbols-outlined" <%= "history".equals(request.getAttribute("activeTab")) ? "style=\"font-variation-settings: 'FILL' 1;\"" : "" %>>history</span>
<span>Lịch sử</span>
</a>
<!-- Ván đấu: Inactive -->
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg <%= "game".equals(request.getAttribute("activeTab")) ? "bg-secondary-container text-on-secondary-container font-bold shadow-sm" : "text-on-surface-variant hover:bg-surface-container-high transition-colors" %>" href="${pageContext.request.contextPath}/game">
<span class="material-symbols-outlined" <%= "game".equals(request.getAttribute("activeTab")) ? "style=\"font-variation-settings: 'FILL' 1;\"" : "" %>>grid_4x4</span>
<span>Ván đấu</span>
</a>
<!-- Dashboard: Inactive -->
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg <%= "dashboard".equals(request.getAttribute("activeTab")) ? "bg-secondary-container text-on-secondary-container font-bold shadow-sm" : "text-on-surface-variant hover:bg-surface-container-high transition-colors" %>" href="${pageContext.request.contextPath}/admin/dashboard">
<span class="material-symbols-outlined" <%= "dashboard".equals(request.getAttribute("activeTab")) ? "style=\"font-variation-settings: 'FILL' 1;\"" : "" %>>dashboard</span>
<span>Dashboard</span>
</a>
<!-- Thành viên: Inactive -->
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg <%= "profile".equals(request.getAttribute("activeTab")) ? "bg-secondary-container text-on-secondary-container font-bold shadow-sm" : "text-on-surface-variant hover:bg-surface-container-high transition-colors" %>" href="${pageContext.request.contextPath}/profile">
<span class="material-symbols-outlined" <%= "profile".equals(request.getAttribute("activeTab")) ? "style=\"font-variation-settings: 'FILL' 1;\"" : "" %>>group</span>
<span>Thành viên</span>
</a>
<!-- Trận đấu: Inactive -->
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-high transition-colors" href="#">
<span class="material-symbols-outlined">playing_cards</span>
<span>Trận đấu</span>
</a>
</div>
<!-- Footer Links -->
<div class="mt-auto border-t border-outline-variant/20 pt-lg space-y-sm">
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-high transition-colors" href="#">
<span class="material-symbols-outlined">menu_book</span>
<span>Hướng dẫn</span>
</a>
<a class="flex items-center gap-md py-sm px-md mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-high transition-colors" href="#">
<span class="material-symbols-outlined">help_outline</span>
<span>Trợ giúp</span>
</a>
</div>
</nav>