<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/About.css" />

</head>
<body>
	<header class="header">
		<img src="img/logo.png" alt="" class="logo" width="80">

		<nav class="menu">
			<a href="index.jsp"> CỬA HÀNG</a> <a href="#">BỘ SƯU TẬP </a> <a
				href="gioithieu.jsp"> GIỚI THIỆU</a> <a href="tintuc.jsp">TIN
				TỨC </a>
		</nav>

		<div class="actions">
			<div class="search-box">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text"
					placeholder="Tìm Kiếm" />
			</div>
			<div class="account">
				<a href="signin.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG
					KÍ</a>
		</div>
        <a href="cartitem.jsp" aria-label="Giỏ hàng">
            <i class="fa-solid fa-cart-shopping"></i>
        </a>
    </div>
	</header>
	<div class="body-nd"></div>

	<div class="body-content">

		<h1 class="collection-title">BỘ SƯU TẬP</h1>

		<div class="collection-item">
			<div class="item-image">
				<img src="img/maunangdong.jpg" alt="Bộ sưu tập 1">
			</div>
			<div class="item-description">
				<h3>Street Style Năng Động</h3>
				<p>Khám phá bộ sưu tập thời trang đường phố mới nhất với chất
					liệu thoáng mát, thiết kế hiện đại phù hợp cho những buổi dạo phố
					cuối tuần. Sự kết hợp hoàn hảo giữa phong cách bụi bặm và sự thoải
					mái tối đa.</p>
				<p>
					Giá tham khảo: <strong>500.000 VNĐ</strong>
				</p>
				<a href="#" class="btn-view">Xem chi tiết</a>
			</div>
		</div>

		<div class="collection-item">
			<div class="item-image">
				<img src="img/congso.jpg" alt="Bộ sưu tập 2">
			</div>
			<div class="item-description">
				<h3>Công Sở Thanh Lịch</h3>
				<p>Vẻ đẹp sang trọng và chuyên nghiệp dành cho môi trường công
					sở. Các thiết kế tối giản nhưng tinh tế, giúp bạn tự tin trong mọi
					cuộc họp.</p>
				<p>
					Giá tham khảo: <strong>750.000 VNĐ</strong>
				</p>
				<a href="#" class="btn-view">Xem chi tiết</a>
			</div>
		</div>

		<div class="collection-item">
			<div class="item-image">
				<img src="img/dangcap.jpg" alt="Bộ sưu tập 3">
			</div>
			<div class="item-description">
				<h3>Dạ Hội Quý Phái</h3>
				<p>Những chiếc đầm dạ hội lộng lẫy được thiết kế thủ công tỉ mỉ.
					Điểm nhấn là các chi tiết đính đá và đường cắt may táo bạo.</p>
				<p>
					Giá tham khảo: <strong>1.200.000 VNĐ</strong>
				</p>
				<a href="#" class="btn-view">Xem chi tiết</a>
			</div>
		</div>

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
						<img src="img/visa.png" alt="VISA" width="30"> <img
							src="img/jcb.png" alt="JCB" > <img
							src="img/paypal.png" alt="PayPal" >
					</div>
				</div>
				<div class="shipping">
					<h4>Đơn vị vận chuyển</h4>
					<div class="logos2">
						<img src="img/vietnampost.png" alt="VietPost"> <img
							src="img/ghtk.png" alt="GHN" > <img
							src="img/jt.png" alt="J&T Express" > <img
							src="img/kerry.png" alt="Kerry" >
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