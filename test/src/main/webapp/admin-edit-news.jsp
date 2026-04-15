<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.News"%>
<!DOCTYPE html>
<html>
<head>
<title>Sửa Tin Tức</title>
<style>
body {
	background: #f4f6f9;
	font-family: sans-serif;
}

.form-container {
	max-width: 700px;
	margin: 50px auto;
	padding: 30px;
	background: white;
	border-radius: 8px;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	font-weight: bold;
	margin-bottom: 5px;
}

.form-group input, .form-group textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	box-sizing: border-box;
}

.btn-submit {
	background: #007bff;
	color: white;
	padding: 12px;
	border: none;
	width: 100%;
	cursor: pointer;
	border-radius: 4px;
}
</style>
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