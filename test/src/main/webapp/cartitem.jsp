<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.cartItem, model.Voucher, java.text.DecimalFormat"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="cart.page_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/cart.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");
    List<cartItem> cartList = (List<cartItem>) request.getAttribute("cartList");
    List<Voucher> myVouchers = (List<Voucher>) request.getAttribute("myVouchers");
    %>

    <div class="cart-wrapper">
        <h1 class="page-title"><fmt:message key="cart.heading" /></h1>

        <div class="cart-layout">
            <div class="cart-items-section">
                <% if (cartList != null && !cartList.isEmpty()) {
                    for (cartItem item : cartList) { %>
                <div class="cart-card">
                    <div class="card-img"><img src="<%=item.getProduct().getImage()%>" alt="Product Image"></div>
                    <div class="card-details">
                        <h3><%=item.getProduct().getPdescription()%></h3>
                        <p class="price-tag"><%=df.format(item.getProduct().getPrice())%></p>
                        <div class="card-actions">
                            <form action="cart" method="post" class="quantity-control">
                                <input type="hidden" name="action" value="update_quantity">
                                <input type="hidden" name="pid" value="<%=item.getProduct().getPid()%>">
                                <button type="submit" name="mod" value="decrease" class="btn-qty"><i class="fa-solid fa-minus"></i></button>
                                <input type="text" name="quantity" value="<%=item.getQuantity()%>" readonly class="input-qty">
                                <button type="submit" name="mod" value="increase" class="btn-qty"><i class="fa-solid fa-plus"></i></button>
                            </form>
                            <span class="item-total"><%=df.format(item.getTotalPrice())%></span>
                            <a href="cart?action=remove&pid=<%=item.getProduct().getPid()%>" class="btn-remove"><i class="fa-solid fa-trash-can"></i></a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="empty-cart">
                    <i class="fa-solid fa-bag-shopping" style="font-size: 50px; margin-bottom: 20px; color: #ddd;"></i>
                    <p style="color: #666;"><fmt:message key="cart.empty" /></p>
                    <a href="index.jsp" class="btn-shop-now"><fmt:message key="cart.shop_now" /></a>
                </div>
                <% } %>
            </div>

            <div class="cart-summary-section">
                <div class="summary-box">
                    <h3><i class="fa-solid fa-ticket"></i> <fmt:message key="cart.voucher_title" /></h3>
                    <form action="cart" method="post" class="voucher-input-group">
                        <input type="hidden" name="action" value="apply_voucher">
                        <input type="text" name="voucherCode" placeholder="<fmt:message key='cart.voucher_placeholder'/>" required>
                        <button type="submit"><fmt:message key="cart.apply" /></button>
                    </form>

                    <% if (myVouchers != null && !myVouchers.isEmpty()) { %>
                    <div class="voucher-wallet-container">
                        <span class="wallet-header"><fmt:message key="cart.your_voucher" /></span>
                        <div class="voucher-scroll-list">
                            <% for (Voucher v : myVouchers) { %>
                            <div class="mini-voucher-card">
                                <div class="v-tag"><span><%= "PERCENT".equals(v.getDiscountType()) ? (int) v.getDiscountAmount() + "%" : (int) (v.getDiscountAmount() / 1000) + "K" %></span></div>
                                <div class="v-details">
                                    <strong class="v-code"><%=v.getCode()%></strong>
                                    <p class="v-condition">Min: <%=df.format(v.getMinOrder())%></p>
                                </div>
                                <form action="cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="apply_voucher">
                                    <input type="hidden" name="voucherCode" value="<%=v.getCode()%>">
                                    <button type="submit" class="btn-use-now"><fmt:message key="cart.use" /></button>
                                </form>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    <% if (session.getAttribute("voucherMsg") != null) { %>
                        <p class="msg-error"><i class="fa-solid fa-circle-exclamation"></i> <%=session.getAttribute("voucherMsg")%></p>
                        <% session.removeAttribute("voucherMsg"); %>
                    <% } %>
                </div>

                <div class="summary-box">
                    <h3><i class="fa-solid fa-credit-card"></i> <fmt:message key="cart.payment_title" /></h3>
                    <form action="checkout" method="post">
                        <div class="summary-row">
                            <span><fmt:message key="cart.subtotal" /></span> 
                            <span><%=request.getAttribute("subtotal") != null ? df.format(request.getAttribute("subtotal")) : "0 VNĐ"%></span>
                        </div>
                        <% if (request.getAttribute("discountAmount") != null && (Double) request.getAttribute("discountAmount") > 0) { %>
                        <div class="summary-row" style="color: #27ae60;">
                            <span><fmt:message key="cart.discount" /></span> 
                            <span>- <%=df.format(request.getAttribute("discountAmount"))%></span>
                        </div>
                        <% } %>
                        <div class="summary-row total-final">
                            <span><fmt:message key="cart.total" /></span> 
                            <span style="color: var(--gold);"><%=request.getAttribute("finalTotal") != null ? df.format(request.getAttribute("finalTotal")) : "0 VNĐ"%></span>
                        </div>

                        <div class="form-group" style="margin-top: 25px;">
                            <label><i class="fa-solid fa-location-dot"></i> <fmt:message key="cart.address" /></label>
                            <textarea name="address" required placeholder="<fmt:message key='cart.address_placeholder'/>"></textarea>
                        </div>

                        <div class="form-group">
                            <label style="margin-bottom: 15px;"><fmt:message key="cart.payment_method" /></label>
                            <div class="payment-methods">
                                <div class="payment-option">
                                    <input type="radio" id="pay-cod" name="paymentMethod" value="COD" checked>
                                    <label for="pay-cod" class="payment-card-label">
                                        <div class="payment-icon-box"><i class="fa-solid fa-money-bill-wave"></i></div>
                                        <div class="payment-info">
                                            <span class="p-name"><fmt:message key="cart.pay_cod" /></span>
                                            <span class="p-desc"><fmt:message key="cart.pay_cod_desc" /></span>
                                        </div>
                                    </label>
                                </div>
                                <div class="payment-option">
                                    <input type="radio" id="pay-banking" name="paymentMethod" value="BANKING">
                                    <label for="pay-banking" class="payment-card-label">
                                        <div class="payment-icon-box"><i class="fa-solid fa-building-columns"></i></div>
                                        <div class="payment-info">
                                            <span class="p-name"><fmt:message key="cart.pay_bank" /></span>
                                            <span class="p-desc"><fmt:message key="cart.pay_bank_desc" /></span>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn-checkout"><fmt:message key="cart.checkout_btn" /> <i class="fa-solid fa-arrow-right"></i></button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>