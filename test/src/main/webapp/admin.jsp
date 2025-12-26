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
/* --- Cấu hình chung --- */
:root {
	--sidebar-width: 250px;
	--header-height: 60px;
	--primary-color: #343a40; /* Màu đen sidebar */
	--accent-color: #3498db;
	--bg-color: #f4f6f9;
}

body {
	font-family: 'Inter', sans-serif;
	margin: 0;
	background-color: var(--bg-color);
	display: flex; /* Layout Flex để chia cột */
	min-height: 100vh;
}

/* --- 1. SIDEBAR (Bên trái) --- */
.sidebar {
	width: var(--sidebar-width);
	background-color: var(--primary-color);
	color: white;
	display: flex;
	flex-direction: column;
	position: fixed; /* Cố định khi cuộn trang */
	height: 100vh;
	left: 0;
	top: 0;
	z-index: 1000;
	box-shadow: 2px 0 5px rgba(0,0,0,0.1);
}

.sidebar-brand {
	height: var(--header-height);
	display: flex;
	align-items: center;
	padding: 0 20px;
	font-size: 18px;
	font-weight: bold;
	border-bottom: 1px solid rgba(255,255,255,0.1);
	letter-spacing: 1px;
}

.sidebar-menu {
	padding: 20px 0;
	flex-grow: 1;
}

.menu-item {
	display: flex;
	align-items: center;
	padding: 12px 20px;
	color: #c2c7d0;
	text-decoration: none;
	transition: 0.3s;
	font-size: 15px;
	border-left: 3px solid transparent;
}

.menu-item i {
	width: 25px; /* Căn chỉnh icon */
	text-align: center;
	margin-right: 10px;
}

.menu-item:hover, .menu-item.active {
	background-color: rgba(255,255,255,0.1);
	color: white;
	border-left-color: var(--accent-color);
}

.sidebar-footer {
	padding: 20px;
	border-top: 1px solid rgba(255,255,255,0.1);
}

.btn-logout {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	padding: 10px;
	background-color: #ff6b6b;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	font-weight: 600;
	transition: 0.2s;
}

.btn-logout:hover {
	background-color: #ff4c4c;
}

/* --- 2. MAIN CONTENT (Bên phải) --- */
.main-content {
	margin-left: var(--sidebar-width); /* Chừa chỗ cho sidebar */
	width: calc(100% - var(--sidebar-width));
	padding: 30px;
}

/* Header nhỏ trong content (Hiển thị User) */
.content-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
}

.page-title {
	font-size: 24px;
	font-weight: 700;
	color: #333;
	margin: 0;
}

.user-info {
	font-weight: 500;
	color: #555;
	background: white;
	padding: 8px 15px;
	border-radius: 20px;
	box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

/* Box chứa bảng */
.card-box {
	background: white;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	padding: 25px;
	overflow-x: auto;
}

/* --- Styles cho Bảng (Giữ nguyên từ code cũ) --- */
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

.badge {
	padding: 6px 12px;
	border-radius: 30px;
	font-size: 11px;
	font-weight: 600;
	text-transform: uppercase;
}
/* Màu badge */
.bg-process { background-color: #fff3cd; color: #856404; }
.bg-shipping { background-color: #cce5ff; color: #004085; }
.bg-success { background-color: #d4edda; color: #155724; }
.bg-cancel { background-color: #f8d7da; color: #721c24; }

/* Nút hành động */
.action-group { display: flex; gap: 5px; }
.btn-action {
	border: none; width: 32px; height: 32px;
	border-radius: 4px; cursor: pointer; color: white;
	display: inline-flex; align-items: center; justify-content: center;
	transition: 0.2s;
}
.btn-view { background: #6c757d; text-decoration: none; }
.btn-ship { background-color: #17a2b8; }
.btn-success { background-color: #28a745; }
.btn-cancel { background-color: #dc3545; }
.btn-action:hover { filter: brightness(90%); }

.money { color: #d63031; font-weight: 700; }

.alert {
	padding: 15px; margin-bottom: 20px; border-radius: 4px;
}
.alert-success {
	background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb;
}
</style>
</head>
<body>

	<nav class="sidebar">
		<div class="sidebar-brand">
			<i class="fa-solid fa-shield-halved" style="margin-right: 10px;"></i> ADMIN PANEL
		</div>
		
		<div class="sidebar-menu">
			<a href="" class="menu-item active">
				<i class="fa-solid fa-chart-line"></i> Thống kê
			</a>
			<a href="admin-dashboard.jsp" class="menu-item">
				<i class="fa-solid fa-chart-line"></i>Quản lý đơn hàng
			</a>
			
			<a href="admin-products" class="menu-item">
				<i class="fa-solid fa-shirt"></i> Quản lý Sản phẩm
			</a>
			
			<a href="admin-news" class="menu-item">
				<i class="fa-solid fa-newspaper"></i> Quản lý Tin tức
			</a>
			
			<a href="admin-users" class="menu-item">
				<i class="fa-solid fa-users"></i> Quản lý Khách hàng
			</a>
		</div>

		<div class="sidebar-footer">
			<a href="logout" class="btn-logout">
				<i class="fa-solid fa-power-off" style="margin-right: 8px;"></i> Đăng xuất
			</a>
		</div>
	</nav>

	<main class="main-content">
		
		<div class="content-header">
			<h1 class="page-title">Danh sách Đơn Hàng</h1>
			<div class="user-info">
				<i class="fa-regular fa-circle-user"></i> Xin chào, Administrator
			</div>
		</div>

		<% if (request.getParameter("msg") != null) { %>
		<div class="alert alert-success">
			<i class="fa-solid fa-check-circle"></i> Thao tác thành công!
		</div>
		<% } %>

		<div class="card-box">
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
							// Logic xử lý màu badge trạng thái
							String st = o.getStatus();
							String badgeClass = "bg-process";
							if (st.contains("giao")) badgeClass = "bg-shipping";
							if (st.contains("thành công")) badgeClass = "bg-success";
							if (st.contains("hủy")) badgeClass = "bg-cancel";
					%>
					<tr>
						<td><strong>#<%=o.getId()%></strong></td>
						<td>
							<div style="display: flex; align-items: center; gap: 8px;">
								<i class="fa-regular fa-user" style="color: #999;"></i> 
								<%=o.getUserName()%>
							</div>
						</td>
						<td><%=o.getCreatedAt()%></td>
						<td style="max-width: 200px;"><%=o.getAddress()%></td>
						<td class="money"><%=df.format(o.getTotalMoney())%></td>
						<td><span class="badge <%=badgeClass%>"><%=st%></span></td>

						<td>
							<div class="action-group">
								<a href="order-detail.jsp?id=<%=o.getId()%>"
									class="btn-action btn-view" title="Xem chi tiết"> 
									<i class="fa-solid fa-eye"></i>
								</a>

								<% if (st.equals("Đang xử lý")) { %>
								<form action="update-order" method="post" style="margin: 0;">
									<input type="hidden" name="id" value="<%=o.getId()%>"> 
									<input type="hidden" name="action" value="ship">
									<button type="submit" class="btn-action btn-ship" title="Giao hàng">
										<i class="fa-solid fa-truck"></i>
									</button>
								</form>
								<form action="update-order" method="post" style="margin: 0;">
									<input type="hidden" name="id" value="<%=o.getId()%>"> 
									<input type="hidden" name="action" value="cancel">
									<button type="submit" class="btn-action btn-cancel" title="Hủy đơn"
										onclick="return confirm('Bạn chắc chắn muốn hủy đơn này?')">
										<i class="fa-solid fa-xmark"></i>
									</button>
								</form>
								<% } %>

								<% if (st.equals("Đang giao hàng")) { %>
								<form action="update-order" method="post" style="margin: 0;">
									<input type="hidden" name="id" value="<%=o.getId()%>"> 
									<input type="hidden" name="action" value="success">
									<button type="submit" class="btn-action btn-success" title="Xác nhận giao thành công">
										<i class="fa-solid fa-check"></i>
									</button>
								</form>
								<% } %>
							</div>
						</td>
					</tr>
					<%
						}
					} else {
					%>
					<tr>
						<td colspan="7" style="text-align: center; padding: 40px; color: #888;">
							<i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 15px; display: block; color: #ddd;"></i>
							Chưa có đơn hàng nào trong hệ thống.
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</main>

</body>
</html>