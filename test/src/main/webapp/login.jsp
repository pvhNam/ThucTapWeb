<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng Nhập</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/login.css" /> </head>
<body>
    <header class="header">
		<img src="img/logo.png" alt="Logo" class="logo" width="80">
		<nav class="menu">
			<a href="index.jsp">CỬA HÀNG</a> 
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="gioithieu.jsp"> GIỚI THIỆU</a> 
            <a href="tintuc.jsp">TIN TỨC </a>
		</nav>
		<div class="actions">
			<div class="search-box">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text" placeholder="Tìm kiếm" />
			</div>
            <a href="cart" aria-label="Giỏ hàng"> <i class="fa-solid fa-cart-shopping"></i></a>
		</div>
	</header>

    <div class="login-container">
        <div class="login-wrapper">
            <h2>ĐĂNG NHẬP</h2>
            <p class="login-subtitle">Chào mừng bạn quay trở lại!</p>
            
            <form action="login" method="post" class="login-form">
                
                <input type="hidden" name="origin" value="<%= request.getParameter("origin") == null ? "" : request.getParameter("origin") %>">

                <% String error = (String) request.getAttribute("error"); 
                   if (error != null) { %>
                    <div class="alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> <%= error %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="username">Tên đăng nhập</label>
                    <div class="input-field">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password">Mật khẩu</label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember"> Ghi nhớ tôi
                    </label>
                    <a href="#" class="forgot-password">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-login">ĐĂNG NHẬP</button>

                <div class="register-link">
                    <p>Bạn chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-top">
			<div class="contact">
				<h3>Liên Hệ</h3>
				<p><strong>☎️</strong> 0981774313</p>
                <p><strong>📍</strong> TP HCM</p>
			</div>
            <div class="catalog">
				<h4>Hỗ trợ</h4>
				<ul>
					<li><a href="#">Chính sách</a></li>
				</ul>
			</div>
		</div>
	</footer>
</body>
</html>