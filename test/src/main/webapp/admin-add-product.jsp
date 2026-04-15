<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Thêm Sản Phẩm Mới</title>
<link rel="stylesheet" href="CSS/style.css">
<style>
.form-container {
	max-width: 600px;
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

.form-group input, .form-group select {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

.btn-submit {
	background: #28a745;
	color: white;
	padding: 12px 20px;
	border: none;
	cursor: pointer;
	width: 100%;
	font-size: 16px;
	font-weight: bold;
}

.btn-submit:hover {
	background: #218838;
}
</style>
</head>
<body style="background: #f4f6f9;">
	<div class="form-container">
		<h2 style="text-align: center; color: #333;">THÊM SẢN PHẨM MỚI</h2>
		<form action="admin-add-product" method="post">
			<div class="form-group">
				<label>Tên sản phẩm:</label> <input type="text" name="name" required
					placeholder="Nhập tên sản phẩm...">
			</div>
			<div class="form-group">
				<label>Giá tiền (VNĐ):</label> <input type="number" name="price"
					required>
			</div>
			<div class="form-group">
				<label>Danh mục (ID):</label> <select name="cateId">
					<option value="1">1 - Áo</option>
					<option value="2">2 - Quần</option>
					<option value="3">3 - Phụ kiện</option>
				</select>
			</div>
			<div class="form-group">
				<label>Màu sắc:</label> <input type="text" name="color">
			</div>
			<div class="form-group">
				<label>Kích thước (Size):</label> <input type="text" name="size"
					placeholder="S, M, L, XL...">
			</div>
			<div class="form-group">
				<label>Số lượng kho:</label> <input type="number" name="stock"
					value="100">
			</div>
			<div class="form-group">
				<label>Hình ảnh (Link hoặc tên file):</label> <input type="text"
					name="image" placeholder="Ví dụ: img/ao-thun.jpg">
			</div>
			<button type="submit" class="btn-submit">Thêm Sản Phẩm</button>
			<br>
			<br> <a href="admin-orders.jsp"
				style="display: block; text-align: center; text-decoration: none; color: #555;">&larr;
				Quay lại Admin</a>
		</form>
	</div>
</body>
</html>