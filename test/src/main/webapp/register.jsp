<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng Ký Tài Khoản</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/login.css" /> 
</head>
<body>
    <header class="header">
        <img src="img/logover2_5.png" alt="Logo" class="logo" width="80">
        <nav class="menu">
            <a href="index.jsp">CỬA HÀNG</a> 
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="about.jsp"> GIỚI THIỆU</a> 
            <a href="news.jsp">TIN TỨC </a>
        </nav>
        <div class="actions">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i> <input type="text" placeholder="Tìm kiếm" />
            </div>
            <a href="cart" aria-label="Giỏ hàng"> <i class="fa-solid fa-cart-shopping"></i></a>
        </div>
    </header>

    <div class="login-container">
        <div class="login-wrapper register-wrapper"> <h2>ĐĂNG KÝ</h2>
            <p class="login-subtitle">Tạo tài khoản để nhận nhiều ưu đãi!</p>
            
            <form action="register" method="post" class="login-form">

                <% String mess = (String) request.getAttribute("mess"); 
                   if (mess != null) { %>
                    <div class="alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> <%= mess %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="fullname">Họ và tên</label>
                    <div class="input-field">
                        <i class="fa-solid fa-user-tag"></i>
                        <input type="text" id="fullname" name="fullname" placeholder="Nhập họ tên đầy đủ" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="user">Tên đăng nhập</label>
                    <div class="input-field">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="user" name="user" placeholder="Chọn tên đăng nhập" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="email">Email</label>
                    <div class="input-field">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="phone">Số điện thoại</label>
                    <div class="input-field">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="pass">Mật khẩu</label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="pass" name="pass" placeholder="Tạo mật khẩu" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="re_pass">Xác nhận mật khẩu</label>
                    <div class="input-field">
                        <i class="fa-solid fa-check-double"></i>
                        <input type="password" id="re_pass" name="re_pass" placeholder="Nhập lại mật khẩu" required>
                    </div>
                </div>

                <button type="submit" class="btn-login btn-register">ĐĂNG KÝ NGAY</button>

                <div class="register-link">
                    <p>Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập tại đây</a></p>
                </div>
            </form>
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
						<img src="img/visa.png" alt="VISA"> 
						<img src="img/jcb.png"alt="JCB"> 
						<img src="img/paypal.png" alt="PayPal">
					</div>
				</div>
				<div class="shipping">
					<h4>Đơn vị vận chuyển</h4>
					<div class="logos2">
						<img src="img/vietnampost.png" alt="VietPost"> 
						<img src="img/ghtk.png" alt="GHN"> 
						<img src="img/jt.png" alt="J&T Express"> 
						<img src="img/kerry.png" alt="Kerry">
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
						<i class="bi bi-facebook"></i> 
					<a href="#" aria-label="Facebook"> <img src="img/facebook1.png" alt="FB" width="30"></a> 
					<a href="#" aria-label="YouTube"><img src="img/youtube.png" alt="YT" width="30"></a> 
					<a href="#" aria-label="TikTok"><img src="img/tiktok.png" alt="TikTok" width="30"></a> 
					<a href="#" aria-label="Instagram"><img src="img/instagram.png" alt="IG" width="30"></a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>