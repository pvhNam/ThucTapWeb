<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order, model.user"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Lịch Sử Mua Hàng | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/cart.css" />

<style>
/* Thêm một chút CSS riêng cho bảng lịch sử */
.history-container {
	max-width: 1200px;
	margin: 30px auto;
	padding: 0 20px;
}

.order-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	background: #fff;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.order-table th, .order-table td {
	padding: 15px;
	text-align: left;
	border-bottom: 1px solid #eee;
}

.order-table th {
	background-color: #f8f8f8;
	font-weight: 600;
}

.status-tag {
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 500;
}

.status-processing {
	background: #fff3cd;
	color: #856404;
}

.status-shipped {
	background: #d4edda;
	color: #155724;
}

.status-cancelled {
	background: #f8d7da;
	color: #721c24;
}

.btn-view-detail {
	color: #333;
	text-decoration: underline;
	font-size: 14px;
}
</style>
</head>
<body>
	<header class="header">
		<a href="index.jsp"><img src="img/logover2_5.png" alt="Logo"
			class="logo" width="80"></a>
		<nav class="menu">
			<a href="index.jsp">TRANG CHỦ</a> <a href="collection.jsp">BỘ SƯU
				TẬP</a> <a href="about.jsp">GIỚI THIỆU</a> <a href="news.jsp">TIN
				TỨC</a>
		</nav>
		<div class="actions">
			<div class="account">
				<%
				user currentUser = (user) session.getAttribute("user");
				%>
				<div class="user-info">
					<span>Hi, <%=(currentUser != null) ? currentUser.getFullname() : "Khách"%></span>
					<a href="profile.jsp"><img src="img/images.jpg" alt="User"
						class="user-avatar"></a> <a
						href="${pageContext.request.contextPath}/logout"
						class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i></a>
				</div>
			</div>
			<a href="cart"><i class="fa-solid fa-cart-shopping"></i></a>
		</div>
	</header>

	<div class="history-container">
		<h1 class="page-title" style="text-align: left; font-size: 24px;">LỊCH
			SỬ ĐƠN HÀNG</h1>

		<%
		List<Order> list = (List<Order>) request.getAttribute("listOrders");
		DecimalFormat df = new DecimalFormat("#,### VNĐ");

		if (list == null || list.isEmpty()) {
		%>
		<div class="empty-cart" style="text-align: center; padding: 50px;">
			<i class="fa-solid fa-box-open" style="font-size: 40px; color: #ccc;"></i>
			<p>Bạn chưa có đơn hàng nào.</p>
			<a href="index.jsp" class="btn-shop-now">MUA SẮM NGAY</a>
		</div>
		<%
		} else {
		%>

		<table class="order-table">
			<thead>
				<tr>
					<th>Mã đơn (#ID)</th>
					<th>Ngày đặt</th>
					<th>Địa chỉ nhận</th>
					<th>Tổng tiền</th>
					<th>Trạng thái</th>
					<th>Hành động</th>
				</tr>
			</thead>
			<tbody>
				<%
				for (Order o : list) {
					// Xử lý class màu sắc cho trạng thái
					String statusClass = "status-processing";
					if (o.getStatus().contains("hủy") || o.getStatus().contains("Hủy"))
						statusClass = "status-cancelled";
					else if (o.getStatus().contains("Giao") || o.getStatus().contains("Thành công"))
						statusClass = "status-shipped";
				%>
				<tr>
					<td>#<%=o.getId()%></td>
					<td><%=o.getCreatedAt()%></td>
					<td><%=o.getAddress()%></td>
					<td style="font-weight: bold; color: #d00;"><%=df.format(o.getTotalMoney())%></td>
					<td><span class="status-tag <%=statusClass%>"><%=o.getStatus()%></span></td>
					<td><a href="order-detail?id=<%=o.getId()%>"
						class="btn-view-detail">Xem chi tiết</a></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
		<%
		}
		%>
	</div>

	<footer class="footer">
		<div class="footer-top">
			<div class="contact">
				<h3>Liên Hệ</h3>
				<p>
					<strong>☎️</strong> 0981774313
				</p>
				<p>
					<strong>✉️</strong> tranthanglo@gmail.com
				</p>
				<p>
					<strong>📍</strong> S2, đường Hải Triều, phường Bến Nghé, Quận 1,
					TP HCM
				</p>
			</div>

			<div class="payandship">
				<div class="payment">
					<h4>Phương thức thanh toán</h4>
					<div class="logos">
						<img src="img/visa.png" alt="VISA"> <img src="img/jcb.png"
							alt="JCB"> <img src="img/paypal.png" alt="PayPal">
					</div>
				</div>
				<div class="shipping">
					<h4>Đơn vị vận chuyển</h4>
					<div class="logos2">
						<img src="img/vietnampost.png" alt="VietPost"> <img
							src="img/ghtk.png" alt="GHN"> <img src="img/jt.png"
							alt="J&T Express"> <img src="img/kerry.png" alt="Kerry">
					</div>
				</div>
			</div>
			<div class="catalog">
				<h4>Danh mục</h4>
				<ul>
					<li><a href="#">Trang chủ</a></li>
					<li><a href="#">Cửa hàng</a></li>
					<li><a href="#">Giới thiệu</a></li>
					<li><a href="#">Tin tức</a></li>
					<li><a href="#">Liên hệ</a></li>
				</ul>
			</div>
			<div class="fangage">
				<h3>Fanpage</h3>
				<div class="social-icons">
					<i class="bi bi-facebook"></i> <a href="#" aria-label="Facebook">
						<img src="img/facebook1.png" alt="FB" width="30">
					</a> <a href="#" aria-label="YouTube"><img src="img/youtube.png"
						alt="YT" width="30"></a> <a href="#" aria-label="TikTok"><img
						src="img/tiktok.png" alt="TikTok" width="30"></a> <a href="#"
						aria-label="Instagram"><img src="img/instagram.png" alt="IG"
						width="30"></a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>