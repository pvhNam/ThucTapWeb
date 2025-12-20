<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.News"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Tin Tức</title>
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: sans-serif; background: #f4f6f9; }
        .admin-container { max-width: 1200px; margin: 30px auto; padding: 20px; background: white; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        .table th { background: #333; color: white; }
        .btn-edit { background: #ffc107; padding: 5px 10px; color: #000; text-decoration: none; }
        .btn-del { background: #dc3545; padding: 5px 10px; color: #fff; text-decoration: none; }
    </style>
</head>
<body>
    <div class="admin-container">
        <h2>QUẢN LÝ TIN TỨC</h2>
        <a href="admin-orders" style="margin-right: 20px;">&larr; Về Dashboard</a>
        <a href="admin-add-news.jsp" style="background: blue; color: white; padding: 8px 15px; text-decoration: none;">+ Đăng Tin Mới</a>
        
        <table class="table">
            <tr>
                <th>ID</th>
                <th>Tiêu Đề</th>
                <th>Ngày Đăng</th>
                <th>Hành Động</th>
            </tr>
            <% 
                List<News> list = (List<News>) request.getAttribute("listN");
                if(list != null) {
                    for(News n : list) {
            %>
            <tr>
                <td><%= n.getId() %></td>
                <td><%= n.getTitle() %></td>
                <td><%= n.getCreatedAt() %></td>
                <td>
                    <a href="admin-news?type=edit&id=<%= n.getId() %>" class="btn-edit"><i class="fa-solid fa-pen"></i></a>
                    <a href="admin-news?type=delete&id=<%= n.getId() %>" class="btn-del" onclick="return confirm('Xóa tin này?')"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
            <% } } %>
        </table>
    </div>
</body>
</html>