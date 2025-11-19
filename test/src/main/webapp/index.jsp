<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang Chủ</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />

</head>
<body>
	<header class="header">
		<img src="img/logo.png" alt="aaaa" class="logo" width="80">

		<nav class="menu">
			<a href="#">CỬA HÀNG</a> <a href="About.jsp">BỘ SƯU TẬP</a> <a
				href="gioithieu.jsp"> GIỚI THIỆU</a> <a href="tintuc.jsp">TIN
				TỨC </a>
		</nav>

		<div class="actions">
			<div class="search-box">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text"
					placeholder="Tìm kiếm" />
			</div>
			<div class="account">
				<a href="signin.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG
					KÍ</a>
			</div>
			<i class="fa-solid fa-cart-shopping"></i>
		</div>
	</header>
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
						<img src="img/visa.png" alt="VISA" width="60"> <img
							src="img/jcb.png" alt="JCB" width="60"> <img
							src="img/paypal.png" alt="PayPal" width="60">
					</div>
				</div>
				<div class="shipping">
					<h4>Đơn vị vận chuyển</h4>
					<div class="logos">
						<img src="img/vietnampost.png" alt="VietPost" width="60"> <img
							src="img/ghtk.png" alt="GHN" width="60"> <img
							src="img/jt.png" alt="J&T Express" width="60"> <img
							src="img/kerry.png" alt="Kerry" width="60">
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
					<i class="bi bi-facebook"></i> <a href="#" aria-label="Facebook"><img
						src="img/facebook1.png" alt="FB" width="30"></a> <a href="#"
						aria-label="YouTube"><img src="img/youtube.png" alt="YT"
						width="30"></a> <a href="#" aria-label="TikTok"><img
						src="img/tiktok.png" alt="TikTok" width="30"></a> <a href="#"
						aria-label="Instagram"><img src="img/instagram.png" alt="IG"
						width="30"></a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>