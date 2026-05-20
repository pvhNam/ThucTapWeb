<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setLocale
	value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'vi'}">
<head>
<meta charset="UTF-8">
<title><fmt:message key="home.page_title" /> | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css">
<link rel="stylesheet" href="CSS/user/index.css">
</head>

<body>

	<jsp:include page="header.jsp">
		<jsp:param name="page" value="index" />
	</jsp:include>


	<div class="hero-banner"
		style="background-image: url('img/banner.png');">
		<div class="hero-content">
			<span class="hero-subtitle"><fmt:message
					key="home.hero.subtitle" /></span>
			<h1 class="hero-title">
				<fmt:message key="home.hero.title" />
			</h1>
			<a href="#products" class="btn-hero"><fmt:message
					key="home.hero.btn" /></a>
		</div>
	</div>

	<!-- VOUCHER -->
	<div class="container voucher-section">
		<div class="section-header"
			style="display: flex; justify-content: space-between; align-items: center;">
			<h2>
				<fmt:message key="home.voucher.title" />
			</h2>

			<c:if test="${sessionScope.isAdmin}">
				<a href="admin-add-voucher.jsp" class="btn-add-cart"
					style="width: auto; margin: 0; background: #27ae60;"> + <fmt:message
						key="home.voucher.add" />
				</a>
			</c:if>
		</div>

		<div class="voucher-grid">
			<c:forEach var="v" items="${vouchers}">
				<div class="voucher-card">

					<div class="voucher-left">
						<span class="voucher-amount"> <c:choose>
								<c:when test="${v.discountType == 'PERCENT'}">
                                ${v.discountAmount}%
                            </c:when>
								<c:otherwise>
									<fmt:formatNumber value="${v.discountAmount/1000}" />K
                            </c:otherwise>
							</c:choose>
						</span> <span class="voucher-unit"> <c:choose>
								<c:when test="${v.discountType == 'PERCENT'}">OFF</c:when>
								<c:otherwise>VNĐ</c:otherwise>
							</c:choose>
						</span>
					</div>

					<div class="voucher-right">
						<div class="voucher-info">
							<span class="voucher-code">${v.code}</span>
							<h4 class="voucher-desc">${v.description}</h4>

							<p class="voucher-expiry">
								<c:choose>
									<c:when test="${v.minOrder > 0}">
                                    Min: <fmt:formatNumber
											value="${v.minOrder}" />đ
                                </c:when>
									<c:otherwise>
                                    Exp: ${v.expiryDate}
                                </c:otherwise>
								</c:choose>
							</p>
						</div>

						<button class="btn-save-voucher"
							onclick="saveVoucher(this, '${v.code}')">
							<fmt:message key="home.voucher.save" />
						</button>
					</div>

				</div>
			</c:forEach>
		</div>
	</div>

	<!-- PRODUCTS -->
	<div class="container product-section">
		<div class="section-header" id="products">
			<h2>
				<fmt:message key="home.product.title" />
			</h2>
			<div class="section-line"></div>
		</div>

		<div class="product-grid">
			<c:forEach var="p" items="${products}" varStatus="loop">

				<c:if test="${loop.index < 8}">

					<c:set var="stock" value="${p.stockquantyti}" />
					<c:set var="inCart"
						value="${mapCart[p.pid] != null ? mapCart[p.pid] : 0}" />
					<c:set var="canAdd" value="${inCart < stock}" />

					<div class="product-card">

						<div class="product-image">
							<a href="product-detail?pid=${p.pid}"> <img
								src="${p.image != null ? p.image : 'img/no-image.png'}"
								alt="${p.pdescription}">
							</a> <a href="product-detail?pid=${p.pid}" class="overlay-btn"> <i
								class="fa-regular fa-eye"></i>
							</a>

							<c:if test="${stock <= 0}">
								<span
									style="position: absolute; top: 10px; left: 10px; background: #e74a3b; color: white; padding: 5px 10px; font-size: 12px; font-weight: bold; border-radius: 4px;">
									SOLD OUT </span>
							</c:if>
						</div>

						<div class="product-details">
							<h3 class="product-name">
								<a href="product-detail?pid=${p.pid}"> ${p.pdescription} </a>
							</h3>

							<span class="price"> <fmt:formatNumber value="${p.price}" />
								VNĐ
							</span>

							<form action="add-to-cart" method="post">
								<input type="hidden" name="action" value="add"> <input
									type="hidden" name="pid" value="${p.pid}"> <input
									type="hidden" name="quantity" value="1">

								<c:choose>
									<c:when test="${canAdd && stock > 0}">
										<button type="submit" class="btn-add-cart">
											<fmt:message key="home.product.add_cart" />
										</button>
										<button type="submit" name="action" value="buyNow"
											class="btn-buy-now">MUA NGAY</button>
									</c:when>

									<c:otherwise>
										<button type="button" class="btn-add-cart" disabled
											style="background-color: #ccc; color: #666; cursor: not-allowed; border: 1px solid #ccc;">
											<c:choose>
												<c:when test="${stock <= 0}">
                                                Hết hàng
                                            </c:when>
												<c:otherwise>
                                                Đã đạt giới hạn
                                            </c:otherwise>
											</c:choose>
										</button>
									</c:otherwise>
								</c:choose>

							</form>
						</div>

					</div>

				</c:if>

			</c:forEach>
		</div>

		<div
			style="text-align: center; margin-top: 40px; margin-bottom: 20px;">
			<a href="about" class="btn-see-more"> <fmt:message
					key="home.see_more" /> <i class="fa-solid fa-arrow-right"></i>
			</a>
		</div>
	</div>

	<jsp:include page="footer.jsp" />

	<!-- SCRIPT  -->
	<script>
function saveVoucher(btn, code) {
    let originalText = btn.innerText;
    btn.innerText = "...";

    fetch('voucher', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=save&code=' + code
    })
    .then(response => response.text())
    .then(data => {
        let result = data.trim();

        if (result === "SUCCESS") {
            btn.innerText = "Saved ✓";
            btn.style.background = "#1a1a1a";
            btn.style.color = "#d4af37";
            btn.disabled = true;
        } else if (result === "EXISTED") {
            alert("Bạn đã lưu mã này rồi!");
            btn.innerText = "Saved";
            btn.disabled = true;
        } else if (result === "LOGIN_REQUIRED") {
            if(confirm("Bạn cần đăng nhập để lưu mã. Đi đến trang đăng nhập?")) {
                window.location.href = "login";
            } else {
                btn.innerText = originalText;
            }
        } else {
            alert("Lỗi: " + result);
            btn.innerText = originalText;
        }
    })
 	.catch(error => {
        console.error(error);
        btn.innerText = originalText;
    });
}
</script>

</body>
</html>