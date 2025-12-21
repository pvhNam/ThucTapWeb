<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.product, model.user, java.text.DecimalFormat"%>

<%
//Lấy dữ liệu sản phẩm được gửi từ Controller sang
product p = (product) request.getAttribute("p");

// Bảo vệ: Nếu truy cập trực tiếp file jsp mà không qua controller thì p sẽ null
if (p == null) {
	response.sendRedirect("index.jsp");
	return;
}

DecimalFormat df = new DecimalFormat("#,### VNĐ");
user currentUser = (user) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title><%=p.getPdescription()%> | Fashion Store</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@400;500;600&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/index.css" />

<style>
.detail-wrapper {
	max-width: 1000px;
	margin: 60px auto;
	display: flex;
	gap: 50px;
	padding: 0 20px;
}

.detail-left {
	flex: 1;
}

.detail-left img {
	width: 100%;
	border-radius: 5px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.detail-right {
	flex: 1;
	font-family: 'Montserrat', sans-serif;
	padding-top: 20px;
}

.p-cat {
	color: #888;
	font-size: 0.9rem;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.p-title {
	font-family: 'Playfair Display', serif;
	font-size: 2.5rem;
	margin: 15px 0;
	color: #1a1a1a;
	line-height: 1.2;
}

.p-price {
	font-size: 1.8rem;
	font-weight: 700;
	color: #1a1a1a;
	margin-bottom: 25px;
}

.p-desc {
	line-height: 1.8;
	color: #555;
	margin-bottom: 30px;
	font-size: 0.95rem;
}

.meta-info {
	margin-bottom: 30px;
	padding: 20px;
	background: #f9f9f9;
	border-radius: 5px;
}

.meta-row {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
	border-bottom: 1px dashed #ddd;
	padding-bottom: 10px;
}

.meta-row:last-child {
	border-bottom: none;
	margin-bottom: 0;
	padding-bottom: 0;
}

.meta-label {
	font-weight: 600;
	color: #333;
}

.stock-tag {
	font-weight: 700;
}

.instock {
	color: #27ae60;
}

.outstock {
	color: #c0392b;
}

.action-box {
	display: flex;
	gap: 15px;
	margin-top: 20px;
}

.qty-input {
	width: 70px;
	text-align: center;
	font-weight: 600;
	border: 1px solid #333;
	padding: 10px;
	font-size: 1rem;
}

.btn-add-cart-detail {
	flex: 1;
	background: #1a1a1a;
	color: #fff;
	border: none;
	font-weight: 700;
	text-transform: uppercase;
	cursor: pointer;
	transition: 0.3s;
}

.btn-add-cart-detail:hover {
	background: #d4af37;
}

.btn-disabled {
	background: #ccc !important;
	cursor: not-allowed;
}

@media ( max-width : 768px) {
	.detail-wrapper {
		flex-direction: column;
	}
}
</style>
</head>
<body>
	<header class="header">
		<a href="index.jsp"><img src="img/logover2_5.png" class="logo"
			width="80"></a>
		<nav class="menu">
			<a href="index.jsp">TRANG CHỦ</a> <a href="collection.jsp">BỘ
				SƯU TẬP</a> <a href="about.jsp">GIỚI THIỆU</a> <a href="news.jsp">TIN
				TỨC</a>
		</nav>
		<div class="actions">
			<a href="cart"><i class="fa-solid fa-cart-shopping"></i></a>
		</div>
	</header>

	<div class="detail-wrapper">
		<div class="detail-left">
			<img
				src="<%=(p.getImage() != null) ? p.getImage() : "img/no-image.png"%>"
				alt="Product">
		</div>

		<div class="detail-right">
			<span class="p-cat">Mã SP: #<%=p.getPid()%></span>
			<h1 class="p-title"><%=p.getPdescription()%></h1>
			<div class="p-price"><%=df.format(p.getPrice())%></div>

			<div class="meta-info">
				<div class="meta-row">
					<span class="meta-label">Màu sắc:</span> <span><%=p.getColor()%></span>
				</div>
				<div class="meta-row">
					<span class="meta-label">Kích thước:</span> <span><%=p.getSize()%></span>
				</div>
				<div class="meta-row">
					<span class="meta-label">Tình trạng:</span>
					<%
					if (p.getStockquantyti() > 0) {
					%>
					<span class="stock-tag instock">Còn hàng (<%=p.getStockquantyti()%>)
					</span>
					<%
					} else {
					%>
					<span class="stock-tag outstock">HẾT HÀNG</span>
					<%
					}
					%>
				</div>
			</div>

			<p class="p-desc">Sản phẩm được thiết kế tinh tế, sử dụng chất
				liệu cao cấp mang lại cảm giác thoải mái. Phù hợp cho cả đi làm và
				đi chơi. Đây là item không thể thiếu trong tủ đồ của bạn.</p>

			<form action="cart" method="post" class="action-box">
				<input type="hidden" name="action" value="add"> <input
					type="hidden" name="pid" value="<%=p.getPid()%>">

				<%
				if (p.getStockquantyti() > 0) {
				%>
				<input type="number" name="quantity" value="1" min="1"
					max="<%=p.getStockquantyti()%>" class="qty-input">
				<button type="submit" class="btn-add-cart-detail">THÊM VÀO
					GIỎ</button>
				<%
				} else {
				%>
				<input type="number" value="0" disabled class="qty-input"
					style="background: #eee; color: #999;">
				<button type="button" class="btn-add-cart-detail btn-disabled">TẠM
					HẾT HÀNG</button>
				<%
				}
				%>
			</form>
		</div>
	</div>
</body>
</html>