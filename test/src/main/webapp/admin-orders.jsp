<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Dashboard Admin | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">

<style>
body {
	font-family: 'Inter', sans-serif;
	background-color: #f4f6f9;
	margin: 0;
}

/* Header */
.admin-header {
	background: #343a40;
	color: white;
	padding: 0 30px;
	height: 60px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.brand {
	font-size: 20px;
	font-weight: bold;
	letter-spacing: 1px;
}

.logout-link {
	color: #ff6b6b;
	text-decoration: none;
	font-weight: 600;
	font-size: 14px;
}

.logout-link:hover {
	color: #ff4c4c;
}

/* Container */
.admin-container {
	max-width: 1200px;
	margin: 40px auto;
	padding: 30px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

/* Toolbar (Các nút quản lý) */
.toolbar {
	margin-bottom: 30px;
	display: flex;
	gap: 15px;
	padding-bottom: 20px;
	border-bottom: 1px solid #eee;
}

.btn-tool {
	padding: 10px 20px;
	text-decoration: none;
	border-radius: 6px;
	font-weight: 600;
	display: flex;
	align-items: center;
	gap: 8px;
	color: white;
	transition: 0.2s;
}

.btn-tool:hover {
	opacity: 0.9;
	transform: translateY(-1px);
}

.btn-product {
	background: #28a745;
} /* Màu xanh lá */
.btn-news {
	background: #007bff;
} /* Màu xanh dương */

/* Tiêu đề trang */
.page-title {
	font-size: 22px;
	color: #333;
	font-weight: 700;
	margin-bottom: 20px;
	border-left: 5px solid #333;
	padding-left: 15px;
}

/* Bảng */
.admin-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

.admin-table th {
	background: #f8f9fa;
	color: #495057;
	padding: 15px;
	text-align: left;
	font-weight: 600;
	border-bottom: 2px solid #dee2e6;
}

.admin-table td {
	padding: 15px;
	border-bottom: 1px solid #eee;
	color: #333;
	font-size: 14px;
	vertical-align: middle;
}

.admin-table tr:hover {
	background-color: #f8f9fa;
}

/* Trạng thái đơn hàng (Badges) */
.badge {
	padding: 6px 12px;
	border-radius: 30px;
	font-size: 12px;
	font-weight: 600;
	display: inline-block;
}

.bg-process {
	background-color: #fff3cd;
	color: #856404;
}

.bg-shipping {
	background-color: #cce5ff;
	color: #004085;
}

.bg-success {
	background-color: #d4edda;
	color: #155724;
}

.bg-cancel {
	background-color: #f8d7da;
	color: #721c24;
}

/* Nút thao tác trong bảng */
.action-group {
	display: flex;
	gap: 5px;
}

.btn-action {
	border: none;
	width: 32px;
	height: 32px;
	border-radius: 4px;
	cursor: pointer;
	color: white;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	transition: 0.2s;
}

.btn-view {
	background: #6c757d;
	text-decoration: none;
} /* Màu xám */
.btn-ship {
	background-color: #17a2b8;
} /* Màu Cyan */
.btn-success {
	background-color: #28a745;
} /* Màu xanh lá */
.btn-cancel {
	background-color: #dc3545;
} /* Màu đỏ */
.btn-action:hover {
	filter: brightness(90%);
}

.money {
	color: #d63031;
	font-weight: 700;
}

/* Tin nhắn thông báo */
.alert {
	padding: 15px;
	margin-bottom: 20px;
	border-radius: 4px;
}

.alert-success {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}
</style>
</head>
<body>

	<header class="admin-header">
		<div class="brand">
			<i class="fa-solid fa-shield-halved"></i> ADMIN PANEL
		</div>
		<div style="display: flex; align-items: center; gap: 15px;">
			<span>Xin chào, Administrator</span> <a href="logout"
				class="logout-link"><i class="fa-solid fa-power-off"></i> Đăng
				xuất</a>
		</div>
	</header>

	<div class="admin-container">

		<%
		if (request.getParameter("msg") != null) {
		%>
		<div class="alert alert-success">
			<i class="fa-solid fa-check-circle"></i> Thao tác thành công!
		</div>
		<%
		}
		%>

		<div class="toolbar">
			<a href="admin-products" class="btn-tool btn-product"> <i
				class="fa-solid fa-shirt"></i> Quản Lý Sản Phẩm
			</a> <a href="admin-news" class="btn-tool btn-news"> <i
				class="fa-solid fa-newspaper"></i> Quản Lý Tin Tức
			</a>
		</div>

		<div class="page-title">Danh Sách Đơn Hàng Gần Đây</div>

		<table class="admin-table">
			<thead>
				<tr>
					<th>ID</th>
					<th>Khách Hàng</th>
					<th>Ngày Đặt</th>
					<th>Địa Chỉ</th>
					<th>Tổng Tiền</th>
					<th>Trạng Thái</th>
					<th>Thao Tác</th>
				</tr>
			</thead>
			<tbody>
				<%
				List<Order> list = (List<Order>) request.getAttribute("listOrders");
				DecimalFormat df = new DecimalFormat("#,### VNĐ");

				if (list != null && !list.isEmpty()) {
					for (Order o : list) {
						// Xử lý màu sắc trạng thái
						String st = o.getStatus();
						String badgeClass = "bg-process";
						if (st.contains("giao"))
					badgeClass = "bg-shipping";
						if (st.contains("thành công"))
					badgeClass = "bg-success";
						if (st.contains("hủy"))
					badgeClass = "bg-cancel";
				%>
				<tr>
					<td><strong>#<%=o.getId()%></strong></td>
					<td><i class="fa-regular fa-user"
						style="color: #999; margin-right: 5px;"></i> <%=o.getUserName()%>
					</td>
					<td><%=o.getCreatedAt()%></td>
					<td><%=o.getAddress()%></td>
					<td class="money"><%=df.format(o.getTotalMoney())%></td>
					<td><span class="badge <%=badgeClass%>"><%=st%></span></td>

					<td>
						<div class="action-group">
							<a href="order-detail.jsp?id=<%=o.getId()%>"
								class="btn-action btn-view" title="Xem chi tiết"> <i
								class="fa-solid fa-eye"></i>
							</a>

							<%
							if (st.equals("Đang xử lý")) {
							%>
							<form action="update-order" method="post" style="margin: 0;">
								<input type="hidden" name="id" value="<%=o.getId()%>">
								<input type="hidden" name="action" value="ship">
								<button type="submit" class="btn-action btn-ship"
									title="Giao hàng">
									<i class="fa-solid fa-truck"></i>
								</button>
							</form>
							<form action="update-order" method="post" style="margin: 0;">
								<input type="hidden" name="id" value="<%=o.getId()%>">
								<input type="hidden" name="action" value="cancel">
								<button type="submit" class="btn-action btn-cancel"
									title="Hủy đơn"
									onclick="return confirm('Bạn chắc chắn muốn hủy đơn này?')">
									<i class="fa-solid fa-xmark"></i>
								</button>
							</form>
							<%
							}
							%>

							<%
							if (st.equals("Đang giao hàng")) {
							%>
							<form action="update-order" method="post" style="margin: 0;">
								<input type="hidden" name="id" value="<%=o.getId()%>">
								<input type="hidden" name="action" value="success">
								<button type="submit" class="btn-action btn-success"
									title="Xác nhận giao thành công">
									<i class="fa-solid fa-check"></i>
								</button>
							</form>
							<%
							}
							%>
						</div>
					</td>
				</tr>
				<%
				}
				} else {
				%>
				<tr>
					<td colspan="7"
						style="text-align: center; padding: 40px; color: #888;"><i
						class="fa-solid fa-box-open"
						style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
						Chưa có đơn hàng nào trong hệ thống.</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</div>

</body>
</html>