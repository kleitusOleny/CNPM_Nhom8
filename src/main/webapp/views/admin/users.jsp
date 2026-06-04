<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý thành viên - Admin Tâm Thế</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">

  <style>
    .admin-container { display: flex; min-height: 100vh; background-color: var(--color-surface); }
    .main-content { flex: 1; padding: var(--space-xl); overflow-y: auto; }
    .data-table { width: 100%; border-collapse: collapse; background: var(--color-surface-container-lowest); border-radius: var(--radius-lg); overflow: hidden; box-shadow: var(--shadow-sm); }
    .data-table th { background: var(--color-surface-container-high); color: var(--color-primary); font-weight: 600; text-align: left; padding: var(--space-md) var(--space-lg); font-size: var(--font-size-body-sm); }
    .data-table td { padding: var(--space-md) var(--space-lg); border-bottom: 1px solid var(--color-surface-container-high); font-size: var(--font-size-body-md); color: var(--color-primary); vertical-align: middle; }
    .badge { padding: 4px 12px; border-radius: var(--radius-full); font-size: var(--font-size-label); font-weight: 600; display: inline-flex; align-items: center; }
    .badge.admin { background-color: #cff4fc; color: #055160; }
    .badge.user { background-color: #e2e3e5; color: #41464b; }
    .search-input { background: var(--color-surface-container-lowest); border: 1px solid var(--color-surface-dim); border-radius: var(--radius-md); padding: var(--space-sm) var(--space-md); color: var(--color-primary); }
    .search-input:focus { outline: none; border-color: var(--color-secondary); }
    .btn-action { background: none; border: none; cursor: pointer; color: var(--color-on-surface-variant); display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: var(--radius-sm); transition: background 0.2s; }
    .btn-action:hover { background: var(--color-surface-container); color: var(--color-primary); }
    .btn-action.delete:hover { background-color: #f8d7da; color: #721c24; }
  </style>
</head>
<body>

<div class="admin-container">
  <jsp:include page="sidebar.jsp" />

  <main class="main-content">
    <div class="flex-between mb-xl">
      <div>
        <h1 style="font-size: var(--font-size-headline-md); font-weight: 700; color: var(--color-primary); margin-bottom: var(--space-xs);">Quản lý thành viên</h1>
        <p class="text-muted text-small">Xem danh sách, phân quyền và điều chỉnh trạng thái tài khoản người chơi.</p>
      </div>
    </div>

    <div class="flex-between mb-lg p-md rounded-lg" style="background: var(--color-surface-container-low); gap: var(--space-md);">
      <form method="GET" action="${pageContext.request.contextPath}/admin/users" class="flex gap-md" style="flex: 1;">
        <input type="text" name="search" value="${currentSearch}" placeholder="Tìm theo tên, username, email..." class="search-input" style="width: 300px;">

        <select name="role" class="search-input" onchange="this.form.submit()">
          <option value="ALL">Tất cả vai trò</option>
          <option value="user" ${currentRole eq 'user' ? 'selected' : ''}>Người chơi (User)</option>
          <option value="admin" ${currentRole eq 'admin' ? 'selected' : ''}>Quản trị viên (Admin)</option>
        </select>

        <button type="submit" class="flex-center gap-sm px-md rounded-lg" style="background: var(--color-primary); color: var(--color-on-primary); border: none; cursor: pointer;">
          <span class="material-symbols-outlined text-[20px]">search</span> Lọc
        </button>
      </form>
    </div>

    <table class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Tài khoản</th>
          <th>Họ và tên</th>
          <th>Email</th>
          <th>ELO / Hạng</th>
          <th>Vai trò</th>
          <th style="text-align: center;">Hành động</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${not empty userPage.users}">
            <c:forEach items="${userPage.users}" var="u">
              <tr>
                <td>#${u.id}</td>
                <td style="font-weight: 600;">${u.username}</td>
                <td>${u.fullName}</td>
                <td class="text-muted">${u.email}</td>
                <td>
                  <div class="flex items-center gap-sm">
                    <span style="font-weight: 600; color: var(--color-secondary);">${u.elo} ELO</span>
                    <span class="text-small text-muted">(${u.rank})</span>
                  </div>
                </td>
                <td>
                  <span class="badge ${u.role}">${u.role.toUpperCase()}</span>
                </td>
                <td>
                  <div class="flex-center gap-md">
                    <select onchange="changeRole(${u.id}, this.value)" class="search-input" style="padding: 2px var(--space-sm); font-size: var(--font-size-body-sm);">
                      <option value="user" ${u.role eq 'user' ? 'selected' : ''}>User</option>
                      <option value="admin" ${u.role eq 'admin' ? 'selected' : ''}>Admin</option>
                    </select>

                    <button class="btn-action delete" onclick="deleteUser(${u.id}, '${u.username}')" title="Xóa tài khoản">
                      <span class="material-symbols-outlined text-[18px]">delete</span>
                    </button>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="7" style="text-align: center; padding: var(--space-xl);" class="text-muted">
                Không tìm thấy thành viên nào phù hợp.
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>

    <c:if test="${userPage.totalPages > 1}">
      <div class="flex-center gap-md mt-lg">
        <c:if test="${userPage.currentPage > 1}">
          <a href="${pageContext.request.contextPath}/admin/users?page=${userPage.currentPage - 1}&search=${currentSearch}&role=${currentRole}" class="btn-action" style="border: 1px solid var(--color-surface-dim);">
            <span class="material-symbols-outlined">chevron_left</span>
          </a>
        </c:if>

        <span class="text-small font-bold">Trang ${userPage.currentPage} / ${userPage.totalPages}</span>

        <c:if test="${userPage.currentPage < userPage.totalPages}">
          <a href="${pageContext.request.contextPath}/admin/users?page=${userPage.currentPage + 1}&search=${currentSearch}&role=${currentRole}" class="btn-action" style="border: 1px solid var(--color-surface-dim);">
            <span class="material-symbols-outlined">chevron_right</span>
          </a>
        </c:if>
      </div>
    </c:if>
  </main>
</div>

<script>
  function changeRole(userId, newRole) {
    const data = new URLSearchParams();
    data.append('action', 'updateRole');
    data.append('id', userId);
    data.append('role', newRole);

    fetch('${pageContext.request.contextPath}/admin/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: data.toString()
    })
    .then(response => {
      if (!response.ok) alert('❌ Không thể cập nhật quyền hạn.');
    })
    .catch(error => alert('❌ Lỗi kết nối hệ thống: ' + error));
  }

  function deleteUser(id, username) {
    if (confirm('⚠️ Bạn có chắc chắn muốn xóa vĩnh viễn tài khoản "' + username + '"?')) {
      const data = new URLSearchParams();
      data.append('action', 'delete');
      data.append('id', id);

      fetch('${pageContext.request.contextPath}/admin/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: data.toString()
      })
      .then(response => {
        if (response.ok) {
          alert('✅ Đã xóa thành viên thành công!');
          window.location.reload();
        } else {
          response.text().then(text => alert('❌ Thất bại: ' + text));
        }
      })
      .catch(error => alert('❌ Lỗi kết nối: ' + error));
    }
  }
</script>
</body>
</html>