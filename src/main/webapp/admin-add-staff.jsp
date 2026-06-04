<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thêm Nhân Viên | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-add-staff.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="staffs" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
    <h1 class="page-title">Thêm Tài Khoản Nhân Viên</h1>
    <a href="admin-staffs" class="btn-add-new" style="background-color: #858796;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>
</div>

        <div class="form-container">
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= error %>
                </div>
            <% } %>

            <form action="admin-add-staff" method="post">
                <div class="form-group">
                    <label>Tài khoản đăng nhập (Username):</label>
                    <input type="text" name="username" class="form-control" required placeholder="Nhập tài khoản viết liền không dấu...">
                </div>

                <div class="form-group">
                    <label>Mật khẩu:</label>
                    <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu...">
                </div>

                <div class="form-group">
                    <label>Họ và Tên:</label>
                    <input type="text" name="fullname" class="form-control" required placeholder="Nhập tên nhân viên...">
                </div>

                <div class="form-group">
                    <label>Email liên hệ:</label>
                    <input type="email" name="email" class="form-control" required placeholder="example@gmail.com">
                </div>

                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="text" name="phone" class="form-control" required placeholder="09xx xxx xxx">
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-user-plus"></i> Tạo Tài Khoản Nhân Viên
                </button>
            </form>
        </div>
    </main>

</body>
</html>
