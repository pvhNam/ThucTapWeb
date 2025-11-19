<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.CartItemDTO"%>
<%@ page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Giỏ Hàng Của Bạn</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/cart.css" />
</head>
<body>
	<header class="header">
		<img src="img/logo.png" alt="" class="logo" width="80">
		<nav class="menu">
			<a href="index.jsp"> CỬA HÀNG</a> <a href="#">BỘ SƯU TẬP </a> <a
				href="gioithieu.jsp"> GIỚI THIỆU</a> <a href="tintuc.jsp">TIN TỨC </a>
		</nav>
		<div class="actions">
			<div class="search-box">
				<i class="fa-solid fa-magnifying-glass"></i> <input type="text" placeholder="Tìm Kiếm" />
			</div>
			<div class="account">
				<a href="signin.jsp">ĐĂNG NHẬP</a> | <a href="register.jsp">ĐĂNG KÍ</a>
			</div>
			<a href="cart" aria-label="Giỏ hàng"> <i class="fa-solid fa-cart-shopping"></i> </a>
		</div>
	</header>

	<div class="body-nd"></div>

	<div class="cart-container-v3">
		<h1 class="cart-title-v3">GIỎ HÀNG CỦA TÔI</h1>

		<div class="cart-content-v3">
			<div class="cart-items-list-v3">
                <div class="cart-header-v3">
                    <span class="col-select"><input type="checkbox" id="select-all" checked></span>
                    <label for="select-all" class="col-product">SẢN PHẨM (<%= request.getAttribute("totalCount") != null ? request.getAttribute("totalCount") : 0 %>)</label>
                    <span class="col-price">GIÁ</span>
                    <span class="col-qty">SỐ LƯỢNG</span>
                    <span class="col-subtotal">THÀNH TIỀN</span>
                    <span class="col-action"></span>
                </div>
                
                <% 
                    List<CartItemDTO> list = (List<CartItemDTO>) request.getAttribute("cartList");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
                    
                    // SỬA: Lấy subtotal và xử lý Null an toàn
                    Double subtotalObj = (Double) request.getAttribute("subtotal");
                    double subtotal = (subtotalObj != null) ? subtotalObj : 0.0;
                    
                    if (list != null && !list.isEmpty()) {
                        for (CartItemDTO item : list) {
                %>
                    <div class="cart-item-row-v3">
                        <div class="col-select-v3">
                            <input type="checkbox" class="item-select" checked>
                        </div>
                        <div class="col-product-v3">
                            <img src="img/maunangdong.jpg" class="item-img-v3"> 
                            <div class="item-info-v3">
                                <h4 class="item-name-v3"><%= item.getProduct().getPdescription() %></h4>
                                <p class="item-variant-v3">Màu: <%= item.getProduct().getColor() %>, Size: <%= item.getProduct().getSize() %></p>
                            </div>
                        </div>
                        <div class="col-price-v3"><%= df.format(item.getProduct().getPrice()) %></div>
                        <div class="col-qty-v3">
                            <button class="qty-btn-v3">-</button>
                            <input type="text" value="<%= item.getQuantity() %>" readonly class="qty-input-v3">
                            <button class="qty-btn-v3">+</button>
                        </div>
                        <div class="col-subtotal-v3"><%= df.format(item.getTotalPrice()) %></div>
                        <div class="col-action-v3">
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="pid" value="<%= item.getProduct().getPid() %>">
                                <button type="submit" class="btn-remove-item-v3" title="Xóa sản phẩm"><i class="fa-solid fa-trash-can"></i></button>
                            </form>
                        </div>
                    </div>
                    <% 
                        }
                    } else {
                %>
                    <p style="padding: 20px; text-align: center;">Giỏ hàng trống.</p>
                <% } %>
            </div>
            
            <div class="cart-summary-v3">
                <h3>TÓM TẮT ĐƠN HÀNG</h3>
                <div class="summary-line-v3">
                    <span>Tạm tính:</span>
                    <span class="summary-value-v3"><%= df.format(subtotal) %></span>
                </div>
                <div class="summary-total-v3">
                    <strong>TỔNG THANH TOÁN:</strong>
                    <strong class="total-price-v3"><%= df.format(subtotal) %></strong>
                </div>
                <a href="checkout.jsp" class="btn-checkout-v3">TIẾN HÀNH THANH TOÁN</a>
            </div>
		</div>
	</div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const selectAll = document.getElementById('select-all');
        const itemCheckboxes = document.querySelectorAll('.item-select');

        // Xử lý chọn tất cả
        if(selectAll) {
            selectAll.addEventListener('change', function() {
                itemCheckboxes.forEach(cb => {
                    cb.checked = this.checked;
                });
            });
        }
        // (Bạn cần thêm AJAX ở đây nếu muốn cập nhật tiền ngay lập tức mà không load lại trang)
    });
    </script>
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