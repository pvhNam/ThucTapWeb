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
</head>
<body>
    <jsp:include page="header.jsp">
        <jsp:param name="page" value="index" />
    </jsp:include>
    
    <div class="hero-banner" style="background-image: url('img/banner.png');">
        <div class="hero-content">
            <span class="hero-subtitle"></span>
            <h1 class="hero-title">COLLECTION 2025</h1>
            <a href="#products" class="btn-hero">MUA NGAY</a>
        </div>
    </div>

    <div class="container voucher-section">
        <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
            <h2>MÃ ƯU ĐÃI DÀNH RIÊNG CHO BẠN</h2>
            
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
                if (vouchers != null) {
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
            <% } } %>
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
                    for (product p : products) {
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
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="pid" value="<%=p.getPid()%>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn-add-cart">THÊM VÀO GIỎ</button>
                        </form>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />

    <script>
    function saveVoucher(btn, code) {
        // Lưu text cũ phòng khi lỗi
        let originalText = btn.innerText;
        btn.innerText = "...";
        
        fetch('voucher', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=save&code=' + code
        })
        .then(response => response.text())
        .then(data => {
            // Xóa khoảng trắng thừa trong response
            let result = data.trim();
            
            if (result === "SUCCESS") {
                btn.innerText = "Đã thêm ✓"; // Hiển thị ĐÃ THÊM
                btn.style.background = "#1a1a1a"; // Màu đen
                btn.style.color = "#d4af37"; // Chữ vàng
                btn.style.border = "1px solid #1a1a1a";
                btn.disabled = true; // Khóa nút lại
                
            } else if (result === "EXISTED") {
                alert("Bạn đã lưu mã này trong ví rồi!");
                btn.innerText = "Đã có";
                btn.disabled = true;
                
            } else if (result === "LOGIN_REQUIRED") {
                if(confirm("Bạn cần đăng nhập để lưu mã. Đi đến trang đăng nhập?")) {
                    window.location.href = "login.jsp";
                } else {
                    btn.innerText = originalText;
                }
                
            } else {
                alert("Lỗi: " + result);
                btn.innerText = originalText;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            btn.innerText = originalText;
        });
    }
    </script>
</body>
</html>