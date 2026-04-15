<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thêm Nhân Viên | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/Admin.css">
<style>
    .form-container {
        max-width: 600px;
        margin: 40px auto;
        background: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #333;
    }
    .form-control {
        width: 100%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
        box-sizing: border-box;
    }
    .btn-submit {
        background: #4e73df;
        color: white;
        border: none;
        padding: 12px 20px;
        border-radius: 5px;
        font-weight: bold;
        cursor: pointer;
        width: 100%;
        font-size: 16px;
        margin-top: 10px;
    }
    .btn-submit:hover {
        background: #2e59d9;
    }
    .alert-error {
        background-color: #f8d7da;
        color: #721c24;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        border: 1px solid #f5c6cb;
    }
</style>
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