<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.product"%>
<%@ page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
<head>
<title>Quản Lý Sản Phẩm</title>
<link rel="stylesheet" href="CSS/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
	font-family: sans-serif;
	background: #f4f6f9;
	padding: 20px;
}

.container {
	max-width: 1200px;
	margin: 0 auto;
	background: white;
	padding: 20px;
	border-radius: 8px;
}

.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.table {
	width: 100%;
	border-collapse: collapse;
}

.table th, .table td {
	padding: 12px;
	border: 1px solid #ddd;
	text-align: left;
}

.table th {
	background: #343a40;
	color: white;
}

.btn {
	padding: 5px 10px;
	border-radius: 4px;
	text-decoration: none;
	color: white;
	font-size: 13px;
}

.btn-edit {
	background: #ffc107;
	color: black;
}

.btn-del {
	background: #dc3545;
}

.btn-add {
	background: #28a745;
	padding: 10px 20px;
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="container">
		<div class="header">
			<h2>DANH SÁCH SẢN PHẨM</h2>
			<div>
				<a href="admin-orders"
					style="margin-right: 15px; text-decoration: none; color: #333;">&larr;
					Về Dashboard</a> <a href="admin-add-product.jsp" class="btn btn-add">+
					Thêm Mới</a>
			</div>
		</div>

		<table class="table">
			<tr>
				<th>ID</th>
				<th>Hình ảnh</th>
				<th>Tên Sản Phẩm</th>
				<th>Giá</th>
				<th>Kho</th>
				<th>Hành Động</th>
			</tr>
			<%
			List<product> list = (List<product>) request.getAttribute("listP");
			DecimalFormat df = new DecimalFormat("#,### VNĐ");
			if (list != null) {
				for (product p : list) {
			%>
			<tr>
				<td><%=p.getPid()%></td>
				<td><img src="<%=p.getImage()%>" width="50"
					style="border-radius: 4px;"></td>
				<td><%=p.getPdescription()%></td>
				<td style="color: red; font-weight: bold;"><%=df.format(p.getPrice())%></td>
				<td><%=p.getStockquantyti()%></td>
				<td><a href="admin-products?type=edit&pid=<%=p.getPid()%>"
					class="btn btn-edit"><i class="fa-solid fa-pen"></i></a> <a
					href="admin-products?type=delete&pid=<%=p.getPid()%>"
					class="btn btn-del" onclick="return confirm('Xóa sản phẩm này?')"><i
						class="fa-solid fa-trash"></i></a></td>
			</tr>
			<%
			}
			}
			%>
		</table>
	</div>
</body>
</html>