```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết thành viên - Admin Tâm Thế</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/global.css">

    <style>
        .profile-avatar{
            width:90px;
            height:90px;
            border-radius:50%;
            background:#fff;
            color:#2c3e50;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:32px;
            font-weight:700;
        }

        .info-table{
            width:100%;
            border-collapse:collapse;
        }

        .info-table td{
            padding:14px 0;
            border-bottom:1px solid #eee;
        }

        .info-table td:first-child{
            width:180px;
            font-weight:600;
            color:var(--color-on-surface-variant);
        }

        .stat-value{
            font-size:40px;
            font-weight:700;
            color:var(--color-secondary);
        }

        .status-item{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:14px;
        }

        .action-btn{
            display:block;
            width:100%;
            text-align:center;
            padding:12px;
            border-radius:8px;
            background:var(--color-primary);
            color:white;
            text-decoration:none;
            font-weight:600;
        }
    </style>
</head>

<body>

<div class="layout-wrapper">
    <aside class="sidebar">

        <div class="sidebar-brand">
            <div class="sidebar-logo">⬡</div>

            <div class="sidebar-brand-text">
                <div class="sidebar-brand-name">
                    Tâm Thế
                </div>

                <div class="sidebar-brand-sub">
                    Admin Panel
                </div>
            </div>
        </div>

        <nav class="sidebar-nav">

            <div class="nav-section">
                <div class="nav-section-label">
                    Điều hướng
                </div>

                <a href="${pageContext.request.contextPath}/admin/users"
                   class="nav-item">

                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">
                        <polyline points="15 18 9 12 15 6"/>
                    </svg>

                    Quay lại danh sách
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-label">
                    Quản lý
                </div>

                <a href="${pageContext.request.contextPath}/admin/users"
                   class="nav-item active">

                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                    </svg>

                    Người dùng
                </a>

                <a href="${pageContext.request.contextPath}/admin/games"
                   class="nav-item">

                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">
                        <rect x="3" y="3" width="18" height="18" rx="2"/>
                        <line x1="3" y1="9" x2="21" y2="9"/>
                        <line x1="3" y1="15" x2="21" y2="15"/>
                        <line x1="9" y1="3" x2="9" y2="21"/>
                        <line x1="15" y1="3" x2="15" y2="21"/>
                    </svg>

                    Ván đấu
                </a>
            </div>

        </nav>

    </aside>
    <main class="main-content">

        <div class="topbar">
            <div>
                <div class="topbar-title">
                    #${user.id} - ${user.fullName}
                </div>

                <div class="topbar-breadcrumb">
                    Admin › Người dùng › Chi tiết
                </div>
            </div>
        </div>

        <div class="page-body">

            <div style="
                display:flex;
                gap:24px;
                align-items:flex-start;">
                <div style="
                    flex:1;
                    display:flex;
                    flex-direction:column;
                    gap:20px;">

                    <!-- Profile -->
                    <div class="card premium-card"
                         style="
                         background:linear-gradient(
                         135deg,
                         #1a2a3a 0%,
                         #2c3e50 100%);
                         color:white;
                         border:none;">

                        <div style="
                            display:flex;
                            justify-content:space-between;
                            align-items:center;">

                            <h3 style="margin:0;">
                                Thông tin tài khoản
                            </h3>

                            <span class="badge"
                                  style="
                                  background:rgba(255,255,255,.2);
                                  color:white;
                                  border:none;">
                                #${user.id}
                            </span>
                        </div>

                        <div style="
                            display:flex;
                            align-items:center;
                            gap:20px;
                            margin-top:20px;">

                            <div class="profile-avatar">
                                ${fn:substring(user.fullName,0,1)}
                            </div>

                            <div>

                                <div style="
                                    font-size:24px;
                                    font-weight:700;">

                                    ${user.fullName}
                                </div>

                                <div style="
                                    opacity:.8;
                                    margin-top:4px;">

                                    @${user.username}
                                </div>

                                <div style="margin-top:10px;">
                                    <span class="badge ${user.role}">
                                        ${user.role}
                                    </span>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Detail -->
                    <div class="card">

                        <h3 style="margin-bottom:20px;">
                            Thông tin chi tiết
                        </h3>

                        <table class="info-table">

                            <tr>
                                <td>ID</td>
                                <td>#${user.id}</td>
                            </tr>

                            <tr>
                                <td>Username</td>
                                <td>${user.username}</td>
                            </tr>

                            <tr>
                                <td>Họ tên</td>
                                <td>${user.fullName}</td>
                            </tr>

                            <tr>
                                <td>Email</td>
                                <td>${user.email}</td>
                            </tr>

                            <tr>
                                <td>Vai trò</td>
                                <td>
                                    <span class="badge ${user.role}">
                                        ${user.role}
                                    </span>
                                </td>
                            </tr>

                            <tr>
                                <td>ELO</td>
                                <td>${user.elo}</td>
                            </tr>

                            <tr>
                                <td>Hạng</td>
                                <td>${user.rank}</td>
                            </tr>

                        </table>

                    </div>

                </div>

                <!-- RIGHT -->
                <div style="
                    width:380px;
                    display:flex;
                    flex-direction:column;
                    gap:20px;">

                    <!-- ELO -->
                    <div class="card">

                        <div style="
                            padding-bottom:15px;
                            border-bottom:1px solid #eee;
                            font-weight:600;">

                            Xếp hạng người chơi
                        </div>

                        <div style="padding-top:20px;">

                            <div class="stat-value">
                                ${user.elo}
                            </div>

                            <div style="
                                margin-top:8px;
                                font-size:18px;
                                font-weight:600;">

                                ${user.rank}
                            </div>

                        </div>

                    </div>

                    <!-- Status -->
                    <div class="card">

                        <div style="
                            padding-bottom:15px;
                            border-bottom:1px solid #eee;
                            font-weight:600;">

                            Trạng thái tài khoản
                        </div>

                        <div style="padding-top:20px;">

                            <div class="status-item">
                                <span>Vai trò</span>
                                <strong>${user.role}</strong>
                            </div>

                            <div class="status-item">
                                <span>Email</span>
                                <strong>
                                    <c:choose>
                                        <c:when test="${not empty user.email}">
                                            Đã thiết lập
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>

                            <div class="status-item">
                                <span>Trạng thái</span>

                                <span class="badge user">
                                    Hoạt động
                                </span>
                            </div>

                        </div>

                    </div>

                    <!-- Action -->
                    <div class="card">

                        <a href="${pageContext.request.contextPath}/admin/users"
                           class="action-btn">

                            Quay lại danh sách người dùng

                        </a>

                    </div>

                </div>

            </div>

        </div>

    </main>

</div>

</body>
</html>
