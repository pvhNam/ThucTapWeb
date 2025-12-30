<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.cartItem, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Giỏ Hàng | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css"><link rel="stylesheet" href="CSS/cart.css">
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="cart-wrapper">
        <h1 class="page-title">GIỎ HÀNG CỦA BẠN</h1>
        <div class="cart-layout">
            <div class="cart-items-section">
                <% 
                    List<cartItem> cartList = (List<cartItem>) request.getAttribute("cartList");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");
                    if (cartList != null && !cartList.isEmpty()) {
                        for (cartItem item : cartList) {
                %>
                    <div class="cart-card">
                        <div class="card-img"><img src="<%= item.getProduct().getImage() %>"></div>
                        <div class="card-details">
                            <h3><%= item.getProduct().getPdescription() %></h3>
                            <p><%= df.format(item.getProduct().getPrice()) %></p>
                            <div class="card-actions"><span>Số lượng: <%= item.getQuantity() %></span><span class="item-total"><%= df.format(item.getTotalPrice()) %></span></div>
                        </div>
                    </div>
                <% } } else { %>
                    <div class="empty-cart"><p>Giỏ hàng trống.</p><a href="index.jsp" class="btn-shop-now">MUA SẮM NGAY</a></div>
                <% } %>
            </div>
            <div class="cart-summary-section">
                <div class="summary-box">
                    <h3>TỔNG ĐƠN HÀNG</h3>
                    <div class="summary-row"><span>Tạm tính:</span><span><%= request.getAttribute("subtotal") != null ? df.format(request.getAttribute("subtotal")) : "0 VNĐ" %></span></div>
                    <button class="btn-checkout">THANH TOÁN</button>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>