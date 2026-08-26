<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title><fmt:message key="cart.page_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/user/cart.css">
    <link rel="stylesheet" href="CSS/user/cartitem.css">
</head>
<body class="ym-user-page ym-cart-page">
    <jsp:include page="header.jsp" />

    <div class="cart-wrapper">
        <h1 class="page-title"><fmt:message key="cart.heading" /></h1>

        <div class="cart-layout">
            <div class="cart-items-section">
                <c:choose>
                    <c:when test="${not empty cartList}">
                        <c:forEach var="item" items="${cartList}">
                            <c:set var="currentQty" value="${item.quantity}" />
                            <c:set var="maxStock" value="${item.product.stockquantyti}" />
                            <c:set var="isMaxed" value="${currentQty ge maxStock}" />
                            <c:set var="isOverStock" value="${currentQty gt maxStock}" />

                            <div class="cart-card" data-cart-item style="${isOverStock ? 'border: 1px solid #e74a3b; background: #fffdfd;' : ''}">
                                <div class="card-img"><img src="${item.product.image}" alt="Product Image"></div>
                                <div class="card-details">
                                    <h3>${item.product.pdescription}</h3>
                                    <p class="product-variant" style="font-size:0.9rem;color:#666;margin-top:4px;">
                                        <c:if test="${not empty item.size}">Kích cỡ: ${item.size}</c:if>
                                        <c:if test="${not empty item.color}"><c:if test="${not empty item.size}"> - </c:if>Màu sắc: ${item.color}</c:if>
                                    </p>
                                    <p class="price-tag"><fmt:formatNumber value="${item.product.price}" pattern="#,### VNĐ"/></p>
                                    <div class="card-actions">
                                        <form action="cart" method="post" class="quantity-control" data-cart-ajax>
                                            <input type="hidden" name="action" value="update_quantity" />
                                            <input type="hidden" name="pid" value="${item.product.pid}" />
                                            <input type="hidden" name="color" value="${item.color}" />
                                            <input type="hidden" name="size" value="${item.size}" />

                                            <button type="submit" name="mod" value="decrease" class="btn-qty"><i class="fa-solid fa-minus"></i></button>

                                            <input type="text" name="quantity" value="${currentQty}" readonly class="input-qty" />

                                            <button type="submit" name="mod" value="increase" class="btn-qty" ${isMaxed ? 'disabled' : ''}><i class="fa-solid fa-plus"></i></button>
                                        </form>

                                        <span class="item-total"><fmt:formatNumber value="${item.totalPrice}" pattern="#,### VNĐ"/></span>

                                        <a href="cart?action=remove&pid=${item.product.pid}&amp;color=${fn:escapeXml(item.color)}&amp;size=${fn:escapeXml(item.size)}" class="btn-remove"><i class="fa-solid fa-trash-can"></i></a>
                                    </div>

                                    <c:choose>
                                        <c:when test="${isOverStock}">
                                            <span class="stock-limit"><i class="fa-solid fa-triangle-exclamation"></i> Kho chỉ còn ${maxStock}. Vui lòng giảm số lượng!</span>
                                        </c:when>
                                        <c:when test="${isMaxed}">
                                            <span class="stock-limit" style="color: #f6c23e;">Đã đạt giới hạn kho</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-info">Tồn kho: ${maxStock}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart">
                            <i class="fa-solid fa-bag-shopping" style="font-size: 50px; margin-bottom: 20px; color: #ddd;"></i>
                            <p style="color: #666;"><fmt:message key="cart.empty" /></p>
                            <a href="index.jsp" class="btn-shop-now"><fmt:message key="cart.shop_now" /></a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="cart-summary-section">
                <div class="summary-box">
                    <h3><i class="fa-solid fa-ticket"></i> <fmt:message key="cart.voucher_title" /></h3>
                    <form action="cart" method="post" class="voucher-input-group">
                        <input type="hidden" name="action" value="apply_voucher" />
                        <input type="text" name="voucherCode" placeholder="<fmt:message key='cart.voucher_placeholder'/>" required />
                        <button type="submit"><fmt:message key="cart.apply" /></button>
                    </form>

                    <c:if test="${not empty myVouchers}">
                        <div class="voucher-wallet-container">
                            <span class="wallet-header"><fmt:message key="cart.your_voucher" /></span>
                            <div class="voucher-scroll-list">
                                <c:forEach var="v" items="${myVouchers}">
                                    <div class="mini-voucher-card">
                                        <div class="v-tag"><span><c:choose><c:when test="${v.discountType == 'PERCENT'}">${v.discountAmount}%</c:when><c:otherwise>${v.discountAmount / 1000}K</c:otherwise></c:choose></span></div>
                                        <div class="v-details">
                                            <strong class="v-code">${v.code}</strong>
                                            <p class="v-condition">Min: <fmt:formatNumber value="${v.minOrder}" pattern="#,### VNĐ"/></p>
                                        </div>
                                        <form action="cart" method="post" style="margin:0;" data-cart-ajax>
                                            <input type="hidden" name="action" value="apply_voucher" />
                                            <input type="hidden" name="voucherCode" value="${v.code}" />
                                            <button type="submit" class="btn-use-now"><fmt:message key="cart.use" /></button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.voucherMsg}">
                        <p class="msg-error"><i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.voucherMsg}</p>
                        <c:remove var="voucherMsg" scope="session" />
                    </c:if>
                </div>

                <div class="summary-box">
                    <h3><i class="fa-solid fa-credit-card"></i> <fmt:message key="cart.payment_title" /></h3>
                    <form action="checkout" method="post">
                        <div class="summary-row">
                            <span><fmt:message key="cart.subtotal" /></span>
                            <span id="cart-subtotal"><fmt:formatNumber value="${subtotal}" pattern="#,### VNĐ"/></span>
                        </div>

                        <div class="summary-row" id="cart-discount-row" style="color: #27ae60;" ${discountAmount le 0 ? 'hidden' : ''}>
                            <span><fmt:message key="cart.discount" /></span>
                            <span id="cart-discount">- <fmt:formatNumber value="${discountAmount}" pattern="#,### VNĐ"/></span>
                        </div>

                        <div class="summary-row total-final">
                            <span><fmt:message key="cart.total" /></span>
                            <span id="cart-final-total" style="color: var(--gold);"><fmt:formatNumber value="${finalTotal}" pattern="#,### VNĐ"/></span>
                        </div>

                        <div class="form-group" style="margin-top: 25px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                <label style="margin: 0;"><i class="fa-solid fa-location-dot"></i> <fmt:message key="cart.address" /></label>
                                <c:if test="${not empty sessionScope.selectedAddress}">
                                    <a href="address-list" class="btn-change-address">Thay đổi</a>
                                </c:if>
                            </div>

                            <c:choose>
                                <c:when test="${not empty sessionScope.selectedAddress}">
                                    <div class="address-display-box">
                                        <p class="address-text"><i class="fa-solid fa-map-pin" style="color: #e74a3b; margin-right: 5px;"></i> ${sessionScope.selectedAddress}</p>
                                    </div>
                                    <input type="hidden" name="address" value="${sessionScope.selectedAddress}" required />
                                </c:when>
                                <c:otherwise>
                                    <a href="address-list" class="address-select-box">
                                        <div class="address-info">
                                            <p class="address-placeholder"><i class="fa-solid fa-plus-circle"></i> Vui lòng chọn địa chỉ giao hàng...</p>
                                        </div>
                                        <div class="address-action"><i class="fa-solid fa-chevron-right"></i></div>
                                    </a>
                                    <input type="hidden" name="address" value="" required />
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="form-group">
                            <label style="margin-bottom: 15px;"><fmt:message key="cart.payment_method" /></label>
                            <div class="payment-methods">
                                <div class="payment-option">
                                    <input type="radio" id="pay-cod" name="paymentMethod" value="COD" checked />
                                    <label for="pay-cod" class="payment-card-label">
                                        <div class="payment-icon-box"><i class="fa-solid fa-money-bill-wave"></i></div>
                                        <div class="payment-info">
                                            <span class="p-name"><fmt:message key="cart.pay_cod" /></span>
                                            <span class="p-desc"><fmt:message key="cart.pay_cod_desc" /></span>
                                        </div>
                                    </label>
                                </div>
                                <div class="payment-option">
                                    <input type="radio" id="pay-banking" name="paymentMethod" value="BANKING" />
                                    <label for="pay-banking" class="payment-card-label">
                                        <div class="payment-icon-box"><i class="fa-solid fa-building-columns"></i></div>
                                        <div class="payment-info">
                                            <span class="p-name"><fmt:message key="cart.pay_bank" /></span>
                                            <span class="p-desc"><fmt:message key="cart.pay_bank_desc" /></span>
                                        </div>
                                    </label>
                                </div>
                                <div class="payment-option">
                                    <input type="radio" id="pay-momo" name="paymentMethod" value="MOMO" />
                                    <label for="pay-momo" class="payment-card-label">
                                        <div class="payment-icon-box"><i class="fa-solid fa-wallet"></i></div>
                                        <div class="payment-info">
                                            <span class="p-name">Ví MoMo</span>
                                            <span class="p-desc">Thanh toán online qua cổng thanh toán MoMo</span>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${cartHasError}">
                                <div class="error-alert-box">
                                    <i class="fa-solid fa-circle-exclamation"></i> Giỏ hàng có sản phẩm vượt quá tồn kho. Vui lòng điều chỉnh lại số lượng để thanh toán!
                                </div>
                                <button type="button" class="btn-checkout" disabled><fmt:message key="cart.checkout_btn" /> <i class="fa-solid fa-lock"></i></button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" class="btn-checkout"><fmt:message key="cart.checkout_btn" /> <i class="fa-solid fa-arrow-right"></i></button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
