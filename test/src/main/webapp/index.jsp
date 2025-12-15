<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="dao.ProductDAO"%>
<%@ page import="model.product"%>
<%@ page import="model.user"%>

<%
    // 1. Chống Cache (để khi Logout xong back lại không thấy trang cũ)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);


%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ | Fashion Store</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="CSS/style.css" /> 
    <link rel="stylesheet" href="CSS/index.css" /> </head>

<body>
    <header class="header">
        <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>

        <nav class="menu">
            <a href="index.jsp" class="active">TRANG CHỦ</a> 
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="about.jsp">GIỚI THIỆU</a> 
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

    <div class="hero-banner">
        <div class="hero-content">
            <span class="hero-subtitle">NEW ARRIVALS</span>
            <h1 class="hero-title">COLLECTION 2025</h1>
            <a href="#products" class="btn-hero">MUA NGAY</a>
        </div>
    </div>

    <div class="container voucher-section">
        <div class="section-header">
            <h2>MÃ ƯU ĐÃI DÀNH RIÊNG CHO BẠN</h2>
            <div class="section-line"></div>
        </div>
        
        <div class="voucher-grid">
            <div class="voucher-card">
                <div class="voucher-left">
                    <span class="voucher-amount">10%</span>
                    <span class="voucher-unit">OFF</span>
                </div>
                <div class="voucher-right">
                    <div class="voucher-info">
                        <span class="voucher-code">WELCOME10</span>
                        <h4 class="voucher-desc">Giảm 10% đơn đầu tiên</h4>
                        <p class="voucher-expiry">HSD: 30/12/2025</p>
                    </div>
                    <button class="btn-save-voucher" onclick="saveVoucher(this, 'WELCOME10')">Lưu Mã</button>
                </div>
            </div>

            <div class="voucher-card">
                <div class="voucher-left">
                    <span class="voucher-amount">50K</span>
                    <span class="voucher-unit">VNĐ</span>
                </div>
                <div class="voucher-right">
                    <div class="voucher-info">
                        <span class="voucher-code">FREESHIP</span>
                        <h4 class="voucher-desc">Miễn phí vận chuyển</h4>
                        <p class="voucher-expiry">Đơn tối thiểu 500k</p>
                    </div>
                    <button class="btn-save-voucher" onclick="saveVoucher(this, 'FREESHIP')">Lưu Mã</button>
                </div>
            </div>

            <div class="voucher-card">
                <div class="voucher-left">
                    <span class="voucher-amount">20%</span>
                    <span class="voucher-unit">OFF</span>
                </div>
                <div class="voucher-right">
                    <div class="voucher-info">
                        <span class="voucher-code">SUMMER20</span>
                        <h4 class="voucher-desc">BST Mùa Hè 2025</h4>
                        <p class="voucher-expiry">HSD: 15/06/2025</p>
                    </div>
                    <button class="btn-save-voucher" onclick="saveVoucher(this, 'SUMMER20')">Lưu Mã</button>
                </div>
            </div>
        </div>
    </div>

    <div class="container product-section" id="products">
        <div class="section-header">
            <h2>SẢN PHẨM MỚI NHẤT</h2>
            <div class="section-line"></div>
        </div>

        <div class="product-grid">
            <%
                ProductDAO pdao = new ProductDAO();
                List<product> products = pdao.getAllProducts();
                DecimalFormat df = new DecimalFormat("#,### VNĐ");
                
                if (products == null || products.isEmpty()) {
            %>
                <div class="no-product">
                    <p>Hiện chưa có sản phẩm nào được bày bán.</p>
                </div>
            <%
    } else {
        for (product p : products) {
            // Xử lý ảnh null
            String imgPath = (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "img/no-image.png";
%>
    <div class="product-card" onclick="window.location.href='product-detail?pid=<%=p.getPid()%>'" style="cursor: pointer;">
        
        <div class="product-image">
            <img src="<%=imgPath%>" alt="<%=p.getPdescription()%>">
            <a href="product-detail?pid=<%=p.getPid()%>" class="overlay-btn view-btn"><i class="fa-regular fa-eye"></i></a>
        </div>

        <div class="product-details">
            <span class="product-cat">Size: <%=p.getSize()%> | <%=p.getColor()%></span>
            
            <h3 class="product-name"><a href="product-detail?pid=<%=p.getPid()%>"><%=p.getPdescription()%></a></h3>
            
            <div class="price-row">
                <span class="price"><%=df.format(p.getPrice())%></span>
            </div>
            
            <form action="cart" method="post" class="add-cart-form" onclick="event.stopPropagation()">
                <input type="hidden" name="action" value="add"> 
                <input type="hidden" name="pid" value="<%=p.getPid()%>"> 
                <input type="hidden" name="quantity" value="1">
                <button type="submit" class="btn-add-cart">
                    THÊM VÀO GIỎ <i class="fa-solid fa-cart-plus"></i>
                </button>
            </form>
        </div>
    </div>
<%
        }
    }
%>
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
					<i class="bi bi-facebook"></i> <a href="#" aria-label="Facebook">
						<img src="img/facebook1.png" alt="FB" width="30">
					</a> <a href="#" aria-label="YouTube"><img src="img/youtube.png"
						alt="YT" width="30"></a> <a href="#" aria-label="TikTok"><img
						src="img/tiktok.png" alt="TikTok" width="30"></a> <a href="#"
						aria-label="Instagram"><img src="img/instagram.png" alt="IG"
						width="30"></a>
				</div>
			</div>
		</div>
	</footer>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <script>
        // Hàm xử lý lưu Voucher
        function saveVoucher(btn, code) {
            // Biến kiểm tra đăng nhập từ JSP
            var isUserLoggedIn = <%= isLoggedIn %>;

            if (!isUserLoggedIn) {
                alert("Bạn cần đăng nhập để lưu mã giảm giá này!");
                window.location.href = "login.jsp";
                return;
            }

            // Gửi AJAX
            $.ajax({
                url: "voucher",
                type: "POST",
                data: {
                    action: "save",
                    code: code
                },
                success: function(response) {
                    var res = response.trim();
                    if (res === "SUCCESS") {
                        $(btn).html('<i class="fa-solid fa-check"></i> ĐÃ LƯU');
                        $(btn).addClass("saved");
                        $(btn).prop("disabled", true);
                        alert("Thành công! Mã " + code + " đã được thêm vào ví.");
                    } else if (res === "EXISTED") {
                        alert("Mã này đã có trong ví của bạn rồi!");
                        $(btn).html('ĐÃ CÓ');
                        $(btn).prop("disabled", true);
                    } else if (res === "INVALID") {
                        alert("Mã giảm giá không hợp lệ.");
                    } else if (res === "LOGIN_REQUIRED") {
                        window.location.href = "login.jsp";
                    }
                },
                error: function() {
                    alert("Lỗi kết nối server. Vui lòng thử lại sau.");
                }
            });
        }
    </script>
</body>
</html>