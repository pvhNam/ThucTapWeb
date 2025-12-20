<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.product"%>
<!DOCTYPE html>
<html>
<head>
<title>Sửa Sản Phẩm</title>
<style>
body {
	background: #f4f6f9;
	font-family: sans-serif;
}

.form-container {
	max-width: 600px;
	margin: 50px auto;
	padding: 30px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input {
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
	font-size: 16px;
	border-radius: 4px;
}
</style>
</head>
<body>
	<%
	product p = (product) request.getAttribute("p");
	%>
	<div class="form-container">
		<h2 style="text-align: center;">
			CẬP NHẬT SẢN PHẨM #<%=p.getPid()%></h2>
		<form action="admin-products" method="post">
			<input type="hidden" name="pid" value="<%=p.getPid()%>">

			<div class="form-group">
				<label>Tên sản phẩm:</label><input type="text" name="name"
					value="<%=p.getPdescription()%>">
			</div>
			<div class="form-group">
				<label>Giá tiền:</label><input type="number" name="price"
					value="<%=p.getPrice()%>">
			</div>
			<div class="form-group">
				<label>Danh mục (ID):</label><input type="number" name="cateId"
					value="<%=p.getCid()%>">
			</div>
			<div class="form-group">
				<label>Màu sắc:</label><input type="text" name="color"
					value="<%=p.getColor()%>">
			</div>
			<div class="form-group">
				<label>Kích thước:</label><input type="text" name="size"
					value="<%=p.getSize()%>">
			</div>
			<div class="form-group">
				<label>Tồn kho:</label><input type="number" name="stock"
					value="<%=p.getStockquantyti()%>">
			</div>
			<div class="form-group">
				<label>Hình ảnh:</label><input type="text" name="image"
					value="<%=p.getImage()%>">
			</div>

			<button type="submit" class="btn-submit">Lưu Cập Nhật</button>
			<br>
			<br> <a href="admin-products"
				style="display: block; text-align: center; text-decoration: none;">Hủy
				bỏ</a>
		</form>
	</div>
</body>
</html>