<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.News"%>
<!DOCTYPE html>
<html>
<head>
<title>Sửa Tin Tức</title>
<link rel="stylesheet" href="CSS/admin/admin-edit-news.css">
</head>
<body>
	<%
	News n = (News) request.getAttribute("n");
	%>
	<div class="form-container">
		<h2 style="text-align: center;">CHỈNH SỬA BÀI VIẾT</h2>
		<form action="admin-news" method="post">
			<input type="hidden" name="id" value="<%=n.getId()%>">

			<div class="form-group">
				<label>Tiêu đề:</label><input type="text" name="title"
					value="<%=n.getTitle()%>">
			</div>
			<div class="form-group">
				<label>Mô tả ngắn:</label>
				<textarea name="shortDesc" rows="3"><%=n.getShortDesc()%></textarea>
			</div>
			<div class="form-group">
				<label>Nội dung chi tiết:</label>
				<textarea name="content" rows="10"><%=n.getContent()%></textarea>
			</div>
			<div class="form-group">
				<label>Hình ảnh:</label><input type="text" name="image"
					value="<%=n.getImage()%>">
			</div>

			<button type="submit" class="btn-submit">Lưu Thay Đổi</button>
			<br>
			<br> <a href="admin-news"
				style="display: block; text-align: center; text-decoration: none;">Hủy
				bỏ</a>
		</form>
	</div>
</body>
</html>
