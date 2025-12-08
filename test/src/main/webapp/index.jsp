<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="dao.ProductDAO"%>
<%@ page import="model.product"%>
<%@ page import="model.user"%>
<%
// BẮT BUỘC: Xóa Cache trình duyệt để tránh lỗi hiển thị sau khi Logout
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang Chủ</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/index.css" />

<style>
.user-info {
	display: flex;
	align-items: center;
	gap: 10px;
	color: #333;
	font-weight: bold;
}

.user-icon {
	font-size: 1.2rem;
	color: #333;
	cursor: pointer;
}

.logout-btn {
	font-size: 0.8rem;
	color: red;
	text-decoration: none;
}
</style>
</head>

<body>
	<header class="header">
		<img src="img/logover2_5.png" alt="Logo" class="logo" width="80">

		<nav class="menu">
			<a href="#" class="active">CỬA HÀNG</a> <a href="collection.jsp">BỘ
				SƯU TẬP</a> <a href="about.jsp"> GIỚI THIỆU</a> <a href="news.jsp">TIN
				TỨC </a>
		</nav>

		<div class="actions">
			<div class="search-box">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text"
					placeholder="Tìm kiếm" />
			</div>

			<div class="account">
				<%
				// 1. Lấy đối tượng user từ session
				user currentUser = (user) session.getAttribute("user");

				// 2. Kiểm tra điều kiện
				if (currentUser == null) {
					// CHƯA ĐĂNG NHẬP -> Hiện nút Login/Register
				%>
				<a href="login.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG
					KÍ</a>
				<%
				} else {
				// ĐÃ ĐĂNG NHẬP -> Hiện Avatar và Tên
				String displayName = currentUser.getUsername();
				// Nếu user có fullname thì hiện fullname cho thân thiện (tùy chọn)
				if (currentUser.getFullname() != null)
					displayName = currentUser.getFullname();
				%>
				<div class="user-info">
					<span>Xin chào, <%=displayName%></span> <a href="profile.jsp"
						title="Trang cá nhân"> <img src="img/default-user.png"
						alt="User" class="user-avatar"> <a
						href="${pageContext.request.contextPath}/logout"
						class="logout-btn">(Thoát)</a>
				</div>
				<%
				}
				%>
			</div>
			<a href="cart" aria-label="Giỏ hàng"> <i
				class="fa-solid fa-cart-shopping"></i>
			</a>
		</div>
	</header>

	<div class="body-nd"></div>

	<div class="body-content">
		<h1 class="collection-title">BỘ SƯU TẬP MỚI</h1>

		<%
		ProductDAO pdao = new ProductDAO();
		List<product> products = pdao.getAllProducts();
		DecimalFormat df = new DecimalFormat("#,### VNĐ");

		if (products == null || products.isEmpty()) {
		%>
		<div style="text-align: center; color: red; padding: 50px;">
			<h3>Không tìm thấy sản phẩm nào!</h3>
		</div>
		<%
		} else {
		for (product p : products) {
		%>

		<div class="collection-item">
			<div class="item-image">
				<img
					src="<%=(p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "img/no-image.png"%>"
					alt="<%=p.getPdescription()%>">
			</div>

			<div class="item-description">
				<h3><%=p.getPdescription()%></h3>
				<p>
					Mô tả ngắn: Thiết kế hiện đại (Size:
					<%=p.getSize()%>, Màu:
					<%=p.getColor()%>).
				</p>
				<p>
					Giá tham khảo: <strong><%=df.format(p.getPrice())%></strong>
				</p>

				<div class="item-actions">
					<a href="product-detail.jsp?pid=<%=p.getPid()%>" class="btn-view">Xem
						chi tiết</a>
					<form action="cart" method="post">
						<input type="hidden" name="action" value="add"> <input
							type="hidden" name="pid" value="<%=p.getPid()%>"> <input
							type="hidden" name="quantity" value="1">
						<button type="submit" class="btn-add-cart">
							<i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
						</button>
					</form>
				</div>
			</div>
		</div>

		<%
		}
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
			</div>
		</div>
	</footer>
</body>
</html>
