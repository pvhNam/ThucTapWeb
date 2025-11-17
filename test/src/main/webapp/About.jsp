<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bộ Sưu Tập - About</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="style.css" />
<link rel="stylesheet" href="CSS/About.css"/>

</head>
<body>
	<header class="header">
        <img src="img/logo.png" alt="" class="logo" width="80">
	
		<nav class="menu">
			<a href="index.jsp"> CỬA HÀNG</a>
			<a href="#">BỘ SƯU TẬP </a>
			<a href="gioithieu.jsp"> GIỚI THIỆU</a>
			<a href="tintuc.jsp">TIN TỨC </a>
		</nav>
		
        <div class="actions">
			<div class="search-box"> 
				<i class="fa-solid fa-magnifying-glass"></i>
				<input type="text" placeholder="Tìm Kiếm"/>
			</div>
            <div class="account">
                <a href="signin.jsp">ĐĂNG NHẬP</a> |
                <a href="register.jsp">ĐĂNG KÍ</a>
            </div>
            <i class="fa-solid fa-cart-shopping"></i>
        </div>
    </header>
    <div class="body-nd">
   	    </div>
  
    <div class="body-content">
        
        <h1 class="collection-title">BỘ SƯU TẬP MÙA HÈ</h1>

        <div class="collection-item">
            <div class="item-image">
                <img src="https://placehold.co/400x500/png" alt="Bộ sưu tập 1">
            </div>
            <div class="item-description">
                <h3>Street Style Năng Động</h3>
                <p>
                    Khám phá bộ sưu tập thời trang đường phố mới nhất với chất liệu thoáng mát, 
                    thiết kế hiện đại phù hợp cho những buổi dạo phố cuối tuần. 
                    Sự kết hợp hoàn hảo giữa phong cách bụi bặm và sự thoải mái tối đa.
                </p>
                <p>Giá tham khảo: <strong>500.000 VNĐ</strong></p>
                <a href="#" class="btn-view">Xem chi tiết</a>
            </div>
        </div>

        <div class="collection-item">
            <div class="item-image">
                <img src="https://placehold.co/400x500/png" alt="Bộ sưu tập 2">
            </div>
            <div class="item-description">
                <h3>Công Sở Thanh Lịch</h3>
                <p>
                    Vẻ đẹp sang trọng và chuyên nghiệp dành cho môi trường công sở. 
                    Các thiết kế tối giản nhưng tinh tế, giúp bạn tự tin trong mọi cuộc họp.
                </p>
                <p>Giá tham khảo: <strong>750.000 VNĐ</strong></p>
                <a href="#" class="btn-view">Xem chi tiết</a>
            </div>
        </div>

        <div class="collection-item">
            <div class="item-image">
                <img src="https://placehold.co/400x500/png" alt="Bộ sưu tập 3">
            </div>
            <div class="item-description">
                <h3>Dạ Hội Quý Phái</h3>
                <p>
                    Những chiếc đầm dạ hội lộng lẫy được thiết kế thủ công tỉ mỉ. 
                    Điểm nhấn là các chi tiết đính đá và đường cắt may táo bạo.
                </p>
                <p>Giá tham khảo: <strong>1.200.000 VNĐ</strong></p>
                <a href="#" class="btn-view">Xem chi tiết</a>
            </div>
        </div>

    </div>
    <footer class="footer">
        <div class="footer-top">
            <div class="contact">
                <h3>Đolis</h3>
                <p><strong>☎️</strong> 0981774313</p>
                <p><strong>✉️</strong> tranthanglo@gmail.com</p>
                <p><strong>📍</strong> S2, đường Hải Triều, phường Bến Nghé, Quận 1, TP HCM</p>
            </div>
            
            <div class="payandship">
                <div class="payment">
                    <h4>Phương thức thanh toán</h4>
                    <div class="logos">
                        <img src="visa-logo.png" alt="VISA" width="50">
                        <img src="jcb-logo.png" alt="JCB" width="50">
                        <img src="paypal-logo.png" alt="PayPal" width="50">
                    </div>
                </div>
                <div class="shipping">
                    <h4>Đơn vị vận chuyển</h4>
                    <div class="logos">
                        <img src="vietpost-logo.png" alt="VietPost" width="50">
                        <img src="ghn-logo.png" alt="GHN" width="50">
                        <img src="jt-express-logo.png" alt="J&T Express" width="50">
                        <img src="kerry-logo.png" alt="Kerry" width="50">
                    </div>
                </div>
            </div>
            <div class="catalog">
                <h4>Danh mục</h4>
                <ul>S
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
                    <a href="#" aria-label="Facebook"><img src="fb-icon.png" alt="FB" width="30"></a>
                    <a href="#" aria-label="YouTube"><img src="yt-icon.png" alt="YT" width="30"></a>
                    <a href="#" aria-label="TikTok"><img src="tiktok-icon.png" alt="TikTok" width="30"></a>
                    <a href="#" aria-label="Instagram"><img src="ig-icon.png" alt="IG" width="30"></a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>