<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.ProductDAO, dao.VoucherDAO, model.product, model.Voucher, java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/index.css">
    
    <style>
        .view-more-container {
            text-align: center;
            margin-top: 50px;
        }
        .btn-view-more {
            display: inline-block;
            padding: 12px 40px;
            background-color: transparent;
            color: #1a1a1a;
            border: 2px solid #1a1a1a;
            text-decoration: none;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.3s;
        }
        .btn-view-more:hover {
            background-color: #1a1a1a;
            color: #fff;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp">
        <jsp:param name="page" value="index" />
    </jsp:include>
    
    <div class="hero-banner">
        <div class="hero-content">
            <span class="hero-subtitle">NEW ARRIVALS</span>
            <h1 class="hero-title">COLLECTION 2025</h1>
            <a href="#products" class="btn-hero">MUA NGAY</a>
        </div>
    </div>

    <div class="container voucher-section">
        <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
            <h2>MÃ ƯU ĐÃI DÀNH RIÊNG CHO BẠN</h2>
            
            <%-- Nút thêm cho Admin --%>
            <% Boolean isAdmin = (Boolean) session.getAttribute("isAdmin"); 
               if (isAdmin != null && isAdmin) { %>
                <a href="admin-add-voucher.jsp" class="btn-add-cart" style="width: auto; margin: 0; background: #27ae60;">+ THÊM VOUCHER</a>
            <% } %>
        </div>
        
        <div class="voucher-grid">
            <%
                VoucherDAO vdao = new VoucherDAO();
                List<Voucher> vouchers = vdao.getAllVouchers();
                DecimalFormat df = new DecimalFormat("#,###");
                
                // Kiểm tra null và danh sách trống
                if (vouchers != null && !vouchers.isEmpty()) {
                    for (Voucher v : vouchers) {
                        String amountDisplay = "PERCENT".equals(v.getDiscountType()) 
                                               ? (int)v.getDiscountAmount() + "%" 
                                               : df.format(v.getDiscountAmount() / 1000) + "K";
                        String unitDisplay = "PERCENT".equals(v.getDiscountType()) ? "OFF" : "VNĐ";
            %>
                <div class="voucher-card">
                    <div class="voucher-left">
                        <span class="voucher-amount"><%= amountDisplay %></span>
                        <span class="voucher-unit"><%= unitDisplay %></span>
                    </div>
                    <div class="voucher-right">
                        <div class="voucher-info">
                            <span class="voucher-code"><%= v.getCode() %></span>
                            <h4 class="voucher-desc"><%= v.getDescription() %></h4>
                            <p class="voucher-expiry">
                                <%= v.getMinOrder() > 0 ? "Đơn từ " + df.format(v.getMinOrder()) + "đ" : "HSD: " + v.getExpiryDate() %>
                            </p>
                        </div>
                        <button class="btn-save-voucher" onclick="saveVoucher(this, '<%= v.getCode() %>')">Lưu Mã</button>
                    </div>
                </div>
            <%  } 
                } else { %>
                <p style="text-align:center; width: 100%; color: #666;">Hiện chưa có mã giảm giá nào.</p>
            <% } %>
        </div>
    </div>

    <div class="container product-section">
        <div class="section-header" id="products">
            <h2>SẢN PHẨM MỚI NHẤT</h2>
            <div class="section-line"></div>
        </div>
        <div class="product-grid">
            <%
                ProductDAO pdao = new ProductDAO();
                List<product> products = pdao.getAllProducts();
                DecimalFormat dfFull = new DecimalFormat("#,### VNĐ");
                
                if (products != null) {
                    int count = 0; // Biến đếm số sản phẩm đã hiện
                    for (product p : products) {
                        // Nếu đã hiện đủ 8 sản phẩm thì dừng vòng lặp
                        if (count >= 8) break; 
            %>
                <div class="product-card">
                    <div class="product-image">
                        <a href="product-detail?pid=<%=p.getPid()%>">
                            <img src="<%= (p.getImage() != null) ? p.getImage() : "img/no-image.png" %>">
                        </a>
                        <a href="product-detail?pid=<%=p.getPid()%>" class="overlay-btn">
                            <i class="fa-regular fa-eye"></i>
                        </a>
                    </div>
                    <div class="product-details">
                        <h3 class="product-name"><a href="product-detail?pid=<%=p.getPid()%>"><%=p.getPdescription()%></a></h3>
                        <span class="price"><%=dfFull.format(p.getPrice())%></span>
                        <form action="cart" method="post">
                            <input type="hidden" name="action" value="add"><input type="hidden" name="pid" value="<%=p.getPid()%>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn-add-cart">THÊM VÀO GIỎ</button>
                        </form>
                    </div>
                </div>
            <% 
                        count++; // Tăng biến đếm sau mỗi lần hiện
                    } 
                } 
            %>
        </div>
        
        <div class="view-more-container">
            <a href="about.jsp" class="btn-view-more">Xem Tất Cả Sản Phẩm <i class="fa-solid fa-arrow-right"></i></a>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />

    <script>
    function saveVoucher(btn, code) {
        fetch('voucher', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=save&code=' + code
        })
        .then(response => response.text())
        .then(data => {
            if (data === "SUCCESS") {
                btn.innerText = "Đã Lưu";
                btn.style.background = "#ccc";
                btn.disabled = true;
                alert("Đã lưu mã " + code + " thành công!");
            } else if (data === "EXISTED") {
                alert("Bạn đã lưu mã này rồi!");
            } else if (data === "LOGIN_REQUIRED") {
                window.location.href = "login.jsp";
            } else {
                alert("Có lỗi xảy ra, vui lòng thử lại.");
            }
        });
    }
    </script>
</body>
</html>