<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.News"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Tin Tức | Admin</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet"  href="CSS/AdminNew.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="news" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Quản Lý Tin Tức</h1>
            <a href="admin-add-news.jsp" class="btn-add-new">
                <i class="fa-solid fa-pen-nib" style="margin-right: 8px;"></i> Đăng Tin Mới
            </a>
        </div>

        <div class="card-box">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th>Tiêu Đề Bài Viết</th>
                        <th style="width: 200px;">Ngày Đăng</th>
                        <th style="width: 120px;">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<News> list = (List<News>) request.getAttribute("listN");
                        if(list != null && !list.isEmpty()) {
                            for(News n : list) {
                    %>
                    <tr>
                        <td><strong>#<%= n.getId() %></strong></td>
                        
                        <td style="font-weight: 500; color: #2c3e50;">
                            <%= n.getTitle() %>
                        </td>
                        
                        <td style="color: #666;">
                            <i class="fa-regular fa-calendar" style="margin-right: 5px;"></i> <%= n.getCreatedAt() %>
                        </td>
                        
                        <td>
                            <div class="action-group">
                                <a href="admin-news?type=edit&id=<%= n.getId() %>" class="btn-action btn-edit" title="Sửa bài viết">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                
                                <a href="admin-news?type=delete&id=<%= n.getId() %>" 
                                   class="btn-action btn-del" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này không?')" 
                                   title="Xóa bài viết">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% 
                            } 
                        } else { 
                    %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 40px; color: #777;">
                            <i class="fa-regular fa-newspaper" style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
                            Chưa có tin tức nào được đăng.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>