<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.user"%>
<%
String activePage = request.getParameter("pageName");
if (activePage == null)
	activePage = "";

// Xử lý Phân quyền
user currUser = (user) session.getAttribute("user");
Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");

int role = 0;
if (currUser != null) {
	role = currUser.getIsAdmin();
} else if (isHardcodedAdmin != null && isHardcodedAdmin) {
	role = 1; 
}
%>

<style>
:root {
	--sidebar-width: 250px;
	--sidebar-bg: #343a40;
	--sidebar-color: white;
	--active-color: #3498db;
	--hover-bg: rgba(255, 255, 255, 0.1);
}

.sidebar {
	width: var(--sidebar-width);
	background-color: var(--sidebar-bg);
	color: var(--sidebar-color);
	display: flex;
	flex-direction: column;
	position: fixed;
	height: 100vh;
	left: 0;
	top: 0;
	z-index: 1000;
	box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
	font-family: 'Inter', sans-serif;
}

.sidebar-brand {
	padding: 20px;
	font-size: 20px;
	font-weight: 700;
	text-align: center;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	letter-spacing: 1px;
	color: #fff;
}

.sidebar-menu {
	padding: 20px 0;
	flex: 1;
	overflow-y: auto;
}

.menu-item {
	padding: 15px 25px;
	display: flex;
	align-items: center;
	color: rgba(255, 255, 255, 0.8);
	text-decoration: none;
	transition: 0.3s;
	font-weight: 500;
}

.menu-item i {
	width: 25px;
	font-size: 18px;
	margin-right: 10px;
	text-align: center;
}

.menu-item:hover, .menu-item.active {
	background-color: var(--hover-bg);
	color: white;
	border-left: 4px solid var(--active-color);
	padding-left: 21px;
}
</style>

<div class="sidebar">
	<div class="sidebar-brand">
		<i class="fa-solid fa-shield-halved" style="margin-right: 10px;"></i>
		ADMIN PANEL
	</div>

	<div class="sidebar-menu">
		<a href="admin"
			class="menu-item <%=activePage.equals("dashboard") ? "active" : ""%>">
			<i class="fa-solid fa-chart-pie"></i> Tổng quan
		</a> <a href="admin-orders"
			class="menu-item <%=activePage.equals("orders") ? "active" : ""%>">
			<i class="fa-solid fa-box"></i> Quản lý Đơn hàng
		</a> <a href="admin-products"
			class="menu-item <%=activePage.equals("products") ? "active" : ""%>">
			<i class="fa-solid fa-shirt"></i> Quản lý Sản phẩm
		</a> <a href="admin-users"
			class="menu-item <%=activePage.equals("users") ? "active" : ""%>">
			<i class="fa-solid fa-user-group"></i> Quản lý Khách hàng
		</a>

		<%-- CẢ ADMIN VÀ NHÂN VIÊN ĐỀU THẤY DANH SÁCH ĐỒNG NGHIỆP --%>
		<a href="admin-staffs"
			class="menu-item <%=activePage.equals("staffs") ? "active" : ""%>">
			<i class="fa-solid fa-address-book"></i> Danh sách Nhân viên
		</a>

		<%
		if (role == 1) { 
		%>
		 <a href="admin-news"
			class="menu-item <%=activePage.equals("news") ? "active" : ""%>">
			<i class="fa-solid fa-newspaper"></i> Quản lý Tin tức
		</a> <a href="admin-vouchers"
			class="menu-item <%=activePage.equals("vouchers") ? "active" : ""%>">
			<i class="fa-solid fa-ticket"></i> Quản lý Voucher
		</a>
		<%
		}
		%>
	</div>

	<div class="sidebar-footer" style="margin-top: auto; padding: 20px;">
		<a href="logout"
			style="color: #ccc; text-decoration: none; display: flex; align-items: center; gap: 10px; transition: 0.3s;">
			<i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
		</a>
	</div>
</div>