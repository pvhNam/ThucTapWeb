<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="model.user"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About</title>
 <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/about.css" />

</head>
<body>
<header class="header">
        <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>

        <nav class="menu">
            <a href="index.jsp" >TRANG CHỦ</a> 
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="about.jsp" class="active">GIỚI THIỆU</a> 
            <a href="news.jsp">TIN TỨC</a>
        </nav>

        <div class="actions">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i> 
                <input type="text" placeholder="Tìm kiếm sản phẩm..." />
            </div>

            <div class="account">
            	<%user currentUser = (user) session.getAttribute("user");
                boolean isLoggedIn = (currentUser != null); %>
                <% if (!isLoggedIn) { %>
                    <a href="login.jsp">ĐĂNG NHẬP</a> <span style="color:#ccc">|</span> <a href="register.jsp">ĐĂNG KÍ</a>
                <% } else { 
                	String fullName = currentUser.getFullname();
                    String displayName = fullName;
                    
                    // Nếu tên null thì để rỗng, nếu dài quá 15 ký tự thì cắt bớt + ...
                    if (fullName == null) {
                        displayName = "Member";
                    } else if (fullName.length() > 15) {
                        displayName = fullName.substring(0, 15) + "...";
                    }
                %>
                    <div class="user-info">
                        <span>Hi, <%=displayName%></span> 
                        <a href="order-history" title="Lịch sử mua hàng" style="margin-left: 5px;">
       <i class="fa-solid fa-clock-rotate-left"></i>
    </a>
                        <a href="profile.jsp" title="Trang cá nhân"> 
                            <img src="img/images.jpg" alt="User" class="user-avatar"> 
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></a>
                    </div>
                <% } %>
            </div>
            
            <a href="cart" aria-label="Giỏ hàng" class="cart-icon"> 
                <i class="fa-solid fa-cart-shopping"></i>
            </a>
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