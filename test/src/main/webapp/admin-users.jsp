<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.user"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Khách Hàng | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/Admin.css">

<style>
    /* CSS cho thanh tìm kiếm */
    .search-box { 
        display: flex; 
        align-items: center; 
        background: white; 
        border: 1px solid #ddd; 
        border-radius: 8px; 
        padding: 5px 15px; 
        width: 300px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    .search-box input { 
        border: none; 
        outline: none; 
        width: 100%; 
        font-size: 14px; 
        color: #555;
    }
    .search-box button { 
        background: none; 
        border: none; 
        cursor: pointer; 
        color: #888; 
        transition: 0.2s;
    }
    .search-box button:hover { color: #4e73df; transform: scale(1.1); }
    
    /* CSS cho User Info trong bảng */
    .user-info-cell { display: flex; align-items: center; gap: 12px; }
    .user-avatar-small { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid #eee; }
    
    /* CSS cho Link tên khách hàng */
    .user-name a { 
        text-decoration: none; 
        color: #2c3e50; 
        font-weight: 600; 
        font-size: 14px;
        transition: 0.2s; 
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .user-name a:hover { 
        color: #4e73df; 
    }
    .icon-link { font-size: 10px; color: #aaa; }
    .user-name a:hover .icon-link { color: #4e73df; }
    
    .user-username { font-size: 12px; color: #888; margin-top: 2px; }

    /* --- MỚI: CSS CHO NÚT XÓA ĐỒNG BỘ --- */
    .btn-icon {
        width: 36px;       
        height: 36px;      
        border-radius: 6px; 
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        transition: all 0.2s ease;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        font-size: 14px;
    }

    .btn-icon:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }

    /* Màu đỏ cho nút xóa */
    .btn-delete { background-color: #dc3545; color: white; }
    .btn-delete:hover { background-color: #c82333; }
</style>
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="users" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header" style="justify-content: space-between;">
            <h1 class="page-title">Quản Lý Khách Hàng</h1>
            
            <form action="admin-users" method="get" class="search-box">
                <input type="text" name="search" placeholder="Tìm tên, email, sđt..." value="${param.search}">
                <button type="submit" title="Tìm kiếm"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>

        <% if (request.getParameter("msg") != null) { %>
            <div class="alert alert-success" style="padding: 12px; background: #d4edda; color: #155724; border-radius: 6px; margin-bottom: 20px; border-left: 4px solid #28a745;">
                <i class="fa-solid fa-check-circle"></i> Thao tác thành công!
            </div>
        <% } %>

        <div class="card-box">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">ID</th>
                        <th>Thông Tin Khách Hàng</th>
                        <th>Email</th>
                        <th>Số Điện Thoại</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<user> list = (List<user>) request.getAttribute("listUsers");
                    if (list != null && !list.isEmpty()) {
                        for (user u : list) {
                            String avatarUrl = (u.getAvatar() != null && !u.getAvatar().isEmpty()) ? "img/avatars/" + u.getAvatar() : "img/images.jpg";
                    %>
                    <tr>
                        <td><strong>#<%=u.getUid()%></strong></td>
                        <td>
                            <div class="user-info-cell">
                                <img src="<%=avatarUrl%>" class="user-avatar-small" onerror="this.src='img/images.jpg'">
                                <div>
                                    <div class="user-name">
                                        <a href="admin-user-detail?uid=<%=u.getUid()%>" title="Xem lịch sử mua hàng">
                                            <%=u.getFullname() != null ? u.getFullname() : "Chưa cập nhật"%> 
                                            <i class="fa-solid fa-arrow-up-right-from-square icon-link"></i>
                                        </a>
                                    </div>
                                    <div class="user-username">@<%=u.getUsername()%></div>
                                </div>
                            </div>
                        </td>
                        <td style="color: #555;"><%=u.getEmail()%></td>
                        <td>
                            <% if (u.getPhonenumber() != null && !u.getPhonenumber().isEmpty()) { %>
                                <%=u.getPhonenumber()%> 
                            <% } else { %> 
                                <span style="color: #ccc; font-style: italic;">---</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 40px; color: #888;">
                            <i class="fa-solid fa-user-slash" style="font-size: 30px; margin-bottom: 10px;"></i><br>
                            Không tìm thấy khách hàng nào phù hợp.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>