<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.user"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Khách Hàng | Admin</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
    /* --- CSS LAYOUT CHÍNH (Đồng bộ với admin-products) --- */
    :root {
        --sidebar-width: 250px;
        --bg-color: #f4f6f9;
    }

    body {
        font-family: 'Inter', sans-serif;
        margin: 0;
        background-color: var(--bg-color);
        /* Nếu file sidebarAdmin.jsp của bạn đã có position:fixed, 
           thì body không cần display:flex, chỉ cần chỉnh margin-left cho main-content */
    }

    .main-content {
        margin-left: var(--sidebar-width);
        padding: 30px;
        width: calc(100% - var(--sidebar-width));
        box-sizing: border-box;
    }

    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
    }

    .page-title {
        font-size: 24px;
        font-weight: 700;
        color: #333;
        margin: 0;
    }

    /* --- CSS BẢNG DỮ LIỆU --- */
    .card-box {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        padding: 25px;
        overflow-x: auto;
    }

    .admin-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .admin-table th { background: #f8f9fa; color: #495057; padding: 15px; text-align: left; font-weight: 600; border-bottom: 2px solid #dee2e6; }
    .admin-table td { padding: 15px; border-bottom: 1px solid #eee; color: #333; font-size: 14px; vertical-align: middle; }
    
    /* Style riêng cho user */
    .user-info-cell { display: flex; align-items: center; }
    .user-avatar-small {
        width: 40px; height: 40px; border-radius: 50%; object-fit: cover; margin-right: 12px;
        background-color: #eee; border: 1px solid #ddd;
    }
    .user-name { font-weight: 600; color: #2c3e50; }
    .user-username { font-size: 12px; color: #3498db; }

    /* Nút hành động */
    .btn-action { 
        border: none; width: 35px; height: 35px; border-radius: 4px; cursor: pointer; color: white;
        display: inline-flex; align-items: center; justify-content: center; transition: 0.2s; text-decoration: none;
    }
    .btn-del { background: #dc3545; }
    .btn-del:hover { background: #c82333; }
    
    /* Thông báo thành công */
    .alert-success {
        padding: 15px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 4px; margin-bottom: 20px;
    }
</style>
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="users" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Quản Lý Khách Hàng</h1>
        </div>
        
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("deleted")) { %>
        <div class="alert-success">
            <i class="fa-solid fa-check-circle"></i> Đã xóa tài khoản thành công!
        </div>
        <% } %>

        <div class="card-box">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">UID</th>
                        <th>Thông Tin Tài Khoản</th>
                        <th>Email</th>
                        <th>Số Điện Thoại</th>
                        <th style="width: 100px;">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<user> list = (List<user>) request.getAttribute("listUsers");
                    
                    if (list != null && !list.isEmpty()) {
                        for (user u : list) {
                            // Logic: Không cho hiện nút xóa với tài khoản admin (để tránh lỡ tay xóa chính mình)
                            // Giả sử tên tài khoản admin là "admin"
                            boolean isAdminAccount = "admin".equals(u.getUsername());
                    %>
                    <tr>
                        <td><strong>#<%=u.getUid()%></strong></td>
                        
                        <td>
                            <div class="user-info-cell">
                                <img src="img/images.jpg" class="user-avatar-small" alt="Avatar" onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                                <div>
                                    <div class="user-name"><%=u.getFullname() != null ? u.getFullname() : "Chưa cập nhật"%></div>
                                    <div class="user-username">@<%=u.getUsername()%></div>
                                </div>
                            </div>
                        </td>
                        
                        <td style="color: #555;"><%=u.getEmail()%></td>
                        
                        <td>
                            <% if(u.getPhonenumber() != null && !u.getPhonenumber().isEmpty()) { %>
                                <%=u.getPhonenumber()%>
                            <% } else { %>
                                <span style="color: #ccc;">---</span>
                            <% } %>
                        </td>
                        
                        <td>
                            <% if (!isAdminAccount) { %>
                                <a href="admin-users?type=delete&uid=<%=u.getUid()%>" 
                                   class="btn-action btn-del" 
                                   onclick="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa tài khoản [<%=u.getUsername()%>] không? Hành động này không thể hoàn tác.')" 
                                   title="Xóa tài khoản">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            <% } else { %>
                                <span style="font-size: 11px; background: #343a40; color: white; padding: 3px 6px; border-radius: 4px;">Admin</span>
                            <% } %>
                        </td>
                    </tr>
                    <% 
                        }
                    } else { 
                    %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 40px; color: #777;">
                            <i class="fa-solid fa-users-slash" style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
                            Chưa có khách hàng nào trong hệ thống.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>