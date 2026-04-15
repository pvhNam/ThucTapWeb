<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Đăng Tin Tức Mới</title>
<link rel="stylesheet" href="CSS/style.css">
<style>
.form-container {
	max-width: 700px;
	margin: 50px auto;
	padding: 30px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background: #fff;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input, .form-group textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-family: inherit;
}

.btn-submit {
	background: #007bff;
	color: white;
	padding: 12px 20px;
	border: none;
	cursor: pointer;
	width: 100%;
	font-size: 16px;
	font-weight: bold;
}

.btn-submit:hover {
	background: #0056b3;
}
</style>
</head>
<body style="background: #f4f6f9;">
	<div class="form-container">
		<h2 style="text-align: center; color: #333;">ĐĂNG TIN TỨC MỚI</h2>
		<form action="admin-add-news" method="post">
			<div class="form-group">
				<label>Tiêu đề tin:</label> <input type="text" name="title" required
					placeholder="Nhập tiêu đề...">
			</div>
			<div class="form-group">
				<label>Mô tả ngắn:</label>
				<textarea name="shortDesc" rows="3"
					placeholder="Tóm tắt nội dung..."></textarea>
			</div>
			<div class="form-group">
				<label>Nội dung chi tiết:</label>
				<textarea name="content" rows="10" required
					placeholder="Nội dung bài viết..."></textarea>
			</div>
			<div class="form-group">
				<label>Hình ảnh (Link hoặc tên file):</label> <input type="text"
					name="image" placeholder="Ví dụ: img/news1.jpg">
			</div>
			<button type="submit" class="btn-submit">Đăng Tin</button>
			<br>
			<br> <a href="admin-orders.jsp"
				style="display: block; text-align: center; text-decoration: none; color: #555;">&larr;
				Quay lại Admin</a>
		</form>
	</div>
</body>
</html>