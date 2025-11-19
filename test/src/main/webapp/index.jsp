<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="dao.DataStore" %>
<%@ page import="model.product" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang Chủ</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/index.css" />

</head>
<body> <header class="header">
		<img src="img/logo.png" alt="Logo" class="logo" width="80">

		<nav class="menu">
			<a href="#">CỬA HÀNG</a> 
            <a href="About.jsp">BỘ SƯU TẬP</a> 
            <a href="gioithieu.jsp"> GIỚI THIỆU</a> 
            <a href="tintuc.jsp">TIN TỨC </a>
		</nav>

		<div class="actions">
			<div class="search-box">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text" placeholder="Tìm kiếm" />
			</div>
			<div class="account">
				<a href="signin.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG KÍ</a>
			</div>
            <a href="cart" aria-label="Giỏ hàng"> 
                <i class="fa-solid fa-cart-shopping"></i>
			</a>
		</div>
	</header>
    <div class="body-nd"></div>

    <div class="body-content">

		<h1 class="collection-title">BỘ SƯU TẬP MỚI</h1>

        <%
            // 1. Lấy danh sách sản phẩm từ DataStore
            List<product> products = DataStore.listProduct;
            DecimalFormat df = new DecimalFormat("#,### VNĐ");

            // 2. Duyệt qua từng sản phẩm
            if (products != null) {
                for (product p : products) {
        %>
        
		<div class="collection-item">
			<div class="item-image">
                <img src="<%= p.getImage() %>" alt="<%= p.getPdescription() %>">
			</div>
            
			<div class="item-description">
				<h3><%= p.getPdescription() %></h3>
				<p>Mô tả ngắn: Thiết kế hiện đại, chất liệu cao cấp (Size: <%= p.getSize() %>, Màu: <%= p.getColor() %>).</p>
				<p>
					Giá tham khảo: <strong><%= df.format(p.getPrice()) %></strong>
				</p>
				
                <div class="item-actions">
                    <a href="product-detail.jsp?pid=<%= p.getPid() %>" class="btn-view">Xem chi tiết</a>

                    <form action="cart" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="pid" value="<%= p.getPid() %>">
                        <input type="hidden" name="quantity" value="1"> 
                        <button type="submit" class="btn-add-cart">
                            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                        </button>
                    </form>
                </div>
			</div>
		</div>

        <%
                } // Kết thúc vòng lặp
            } // Kết thúc if
        %>

	</div>
    <footer class="footer">
		<div class="footer-top">
			<div class="contact">
				<h3>Liên Hệ</h3>
				<p><strong>☎️</strong> 0981774313</p>
				<p><strong>✉️</strong> tranthanglo@gmail.com</p>
				<p><strong>📍</strong> S2, đường Hải Triều, phường Bến Nghé, Quận 1, TP HCM</p>
			</div>

			<div class="payandship">
				<div class="payment">
					<h4>Phương thức thanh toán</h4>
					<div class="logos">
						<img src="img/visa.png" alt="VISA"> <img src="img/jcb.png" alt="JCB"> <img src="img/paypal.png" alt="PayPal">
					</div>
				</div>
				<div class="shipping">
					<h4>Đơn vị vận chuyển</h4>
					<div class="logos2">
						<img src="img/vietnampost.png" alt="VietPost"> <img src="img/ghtk.png" alt="GHN"> <img src="img/jt.png" alt="J&T Express"> <img src="img/kerry.png" alt="Kerry">
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
                    <a href="#"><img src="img/facebook1.png" alt="FB" width="30"></a> 
                    <a href="#"><img src="img/youtube.png" alt="YT" width="30"></a> 
                    <a href="#"><img src="img/tiktok.png" alt="TikTok" width="30"></a> 
                    <a href="#"><img src="img/instagram.png" alt="IG" width="30"></a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>