<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Khách Hàng | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-users.css">
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
                    List<User> list = (List<User>) request.getAttribute("listUsers");
                    if (list != null && !list.isEmpty()) {
                        for (User u : list) {
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
