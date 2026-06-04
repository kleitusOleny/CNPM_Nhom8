<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>404 - Không tìm thấy trang - Tâm Thế</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Inter', sans-serif; background: #f7f9fb; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
    .error-card { text-align: center; max-width: 400px; padding: 48px 40px; background: white; border-radius: 16px; box-shadow: 0 10px 40px rgba(26,42,58,0.1); }
    .error-code { font-size: 80px; font-weight: 700; color: #1a2a3a; line-height: 1; margin-bottom: 16px; }
    .error-title { font-size: 22px; font-weight: 600; color: #191c1e; margin-bottom: 8px; }
    .error-desc { font-size: 14px; color: #44474c; margin-bottom: 32px; line-height: 1.6; }
    .btn { display: inline-flex; align-items: center; gap: 6px; padding: 12px 24px; background: #1a2a3a; color: white; border-radius: 8px; text-decoration: none; font-weight: 500; font-size: 14px; transition: background 0.2s; }
    .btn:hover { background: #041525; }
  </style>
</head>
<body>
  <div class="error-card">
    <div class="error-code">404</div>
    <div class="error-title">Không tìm thấy trang</div>
    <div class="error-desc">Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.</div>
    <a href="${pageContext.request.contextPath}/lobby" class="btn">← Về trang chủ</a>
  </div>
</body>
</html>
