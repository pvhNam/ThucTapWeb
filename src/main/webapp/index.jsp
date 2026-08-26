<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	if (request.getAttribute("homePage") == null) {
		response.sendRedirect(request.getContextPath() + "/home");
		return;
	}
%>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'vi'}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
	<meta name="theme-color" content="#0b0c10">
	<title><fmt:message key="home.page_title" /> | Nam Thành Fashion</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<link rel="stylesheet" href="CSS/style.css">
	<%-- Giao diện trang chủ mới được tách riêng để không xung đột với các trang còn lại. --%>

	<style media="not all">
		/* ========================================================
           YAME VIBE: STREETWEAR, MONOCHROME, BOLD, ASYMMETRICAL
           + SUPER SMOOTH INTERACTIONS & ANIMATIONS
           ======================================================== */
		@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&display=swap');

		:root {
			--ym-black: #000000;
			--ym-white: #ffffff;
			--ym-gray: #f5f5f5;
			--ym-dark-gray: #333333;
			--ym-red: #e60000;
			--ym-border: #e0e0e0;
		}

		html { scroll-behavior: smooth; }

		body {
			font-family: 'Montserrat', sans-serif;
			background-color: var(--ym-white);
			color: var(--ym-black);
			margin: 0;
			padding: 0;
			overflow-x: hidden;
		}

		button, a.btn-hero-solid, a.badge-add, a.btn-massive, .btn-vt-save, .option-btn {
			transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
		}

		button:active, a.btn-hero-solid:active, a.badge-add:active, a.btn-massive:active, .btn-vt-save:active, .option-btn:active {
			transform: scale(0.92) !important;
		}

		/* 1. SCROLLING MARQUEE (TOP BAR) */
		.marquee-bar {
			background: var(--ym-black);
			color: var(--ym-white);
			padding: 8px 0;
			overflow: hidden;
			white-space: nowrap;
			font-size: 11px;
			font-weight: 800;
			letter-spacing: 2px;
			text-transform: uppercase;
		}
		.marquee-content {
			display: inline-block;
			animation: marquee 20s linear infinite;
		}
		@keyframes marquee {
			0% { transform: translateX(100%); }
			100% { transform: translateX(-100%); }
		}

		/* 2. DYNAMIC HERO SECTION */
		.hero-container {
			position: relative;
			height: 85vh;
			width: 100%;
			display: flex;
			background-color: var(--ym-gray);
			overflow: hidden;
		}
		.hero-image {
			width: 60%;
			height: 100%;
			background-image: url('img/banner.png');
			background-size: cover;
			background-position: center;
			clip-path: polygon(0 0, 100% 0, 85% 100%, 0% 100%);
			animation: imageFadeIn 1.5s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
		}
		@keyframes imageFadeIn {
			from { transform: scale(1.1); opacity: 0; }
			to { transform: scale(1); opacity: 1; }
		}

		.hero-text-box {
			position: absolute;
			right: 5%;
			top: 50%;
			transform: translateY(-50%);
			width: 45%;
			text-align: right;
			z-index: 2;
			animation: slideInRight 1.2s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
		}
		@keyframes slideInRight {
			from { transform: translate(50px, -50%); opacity: 0; }
			to { transform: translate(0, -50%); opacity: 1; }
		}

		.hero-title-huge {
			font-size: 5.5rem;
			font-weight: 900;
			line-height: 0.9;
			text-transform: uppercase;
			color: var(--ym-black);
			text-shadow: 2px 2px 0px var(--ym-white);
			margin-bottom: 20px;
		}
		.hero-subtitle-styled {
			font-size: 1.2rem;
			font-weight: 600;
			letter-spacing: 5px;
			background: var(--ym-black);
			color: var(--ym-white);
			display: inline-block;
			padding: 5px 15px;
			margin-bottom: 30px;
		}
		.btn-hero-solid {
			display: inline-block;
			padding: 16px 45px;
			background: var(--ym-red);
			color: var(--ym-white);
			font-weight: 800;
			text-transform: uppercase;
			letter-spacing: 2px;
			font-size: 14px;
			text-decoration: none;
		}
		.btn-hero-solid:hover {
			transform: translateY(-5px);
			box-shadow: 0 10px 20px rgba(230, 0, 0, 0.3);
		}

		/* 3. SECTION HEADINGS */
		.section-wrap {
			max-width: 1350px;
			margin: 100px auto;
			padding: 0 20px;
		}
		.ym-heading {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-bottom: 40px;
			border-bottom: 3px solid var(--ym-black);
			padding-bottom: 15px;
		}
		.ym-heading h2 {
			font-size: 32px;
			font-weight: 900;
			text-transform: uppercase;
			margin: 0;
			letter-spacing: -1px;
		}
		.ym-heading .badge-add {
			background: var(--ym-black);
			color: var(--ym-white);
			padding: 8px 20px;
			font-size: 12px;
			font-weight: 800;
			text-decoration: none;
		}
		.ym-heading .badge-add:hover { background: var(--ym-red); }

		/* 4. VOUCHER TICKETS */
		.voucher-scroller {
			display: flex;
			gap: 30px;
			overflow-x: auto;
			padding: 10px 0 20px 0;
			scrollbar-width: thin;
			scrollbar-color: var(--ym-black) var(--ym-gray);
			scroll-behavior: smooth;
		}
		.voucher-ticket {
			flex: 0 0 380px;
			background: var(--ym-white);
			border: 2px dashed var(--ym-border);
			display: flex;
			position: relative;
			transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.4s ease;
		}
		.voucher-ticket:hover {
			border-color: var(--ym-black);
			transform: translateY(-8px);
			box-shadow: 10px 10px 0 rgba(0,0,0,0.08);
		}
		.vt-left {
			background: var(--ym-black);
			color: var(--ym-white);
			width: 35%;
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			padding: 20px;
			border-right: 2px dashed var(--ym-white);
		}
		.vt-val { font-size: 36px; font-weight: 900; line-height: 1; }
		.vt-unit { font-size: 14px; font-weight: 600; letter-spacing: 2px; margin-top: 5px; }
		.vt-right {
			padding: 20px;
			width: 65%;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
		}
		.vt-code { font-size: 14px; font-weight: 800; color: var(--ym-red); margin-bottom: 5px; }
		.vt-desc { font-size: 14px; font-weight: 700; text-transform: uppercase; margin: 0 0 10px 0; }
		.vt-exp { font-size: 12px; color: var(--ym-dark-gray); font-weight: 600; }
		.btn-vt-save {
			align-self: flex-start;
			margin-top: 15px;
			background: transparent;
			border: 2px solid var(--ym-black);
			color: var(--ym-black);
			font-size: 11px;
			font-weight: 800;
			padding: 8px 16px;
			cursor: pointer;
		}
		.btn-vt-save:hover { background: var(--ym-black); color: var(--ym-white); }

		/* 5. ASYMMETRICAL PRODUCT MASONRY GRID - FIXED */
		.ym-grid {
			display: grid;
			grid-template-columns: repeat(4, 1fr);
			grid-auto-rows: 320px; /* Reduced to avoid extreme heights */
			gap: 20px;
		}
		@media (max-width: 1200px) {
			.ym-grid { grid-auto-rows: 280px; }
		}
		@media (max-width: 1024px) {
			.ym-grid { grid-template-columns: repeat(2, 1fr); grid-auto-rows: 320px; }
			.hero-title-huge { font-size: 3.5rem; }
		}
		@media (max-width: 768px) {
			.hero-container { flex-direction: column; }
			.hero-image { width: 100%; clip-path: none; height: 50%; }
			.hero-text-box { width: 100%; position: relative; right: 0; top: 0; transform: none; text-align: center; padding: 20px; height: 50%; display: flex; flex-direction: column; justify-content: center; align-items: center;}
			.hero-title-huge { font-size: 2.5rem; text-shadow: none; }
			.ym-grid { grid-template-columns: 1fr; }
		}

		.ym-item {
			position: relative;
			background: var(--ym-gray);
			overflow: hidden;
			border-radius: 4px;
			transition: box-shadow 0.4s ease;
		}
		.ym-item:hover {
			box-shadow: 0 15px 35px rgba(0,0,0,0.15);
		}
		.ym-item.featured {
			grid-column: span 2;
			grid-row: span 2;
		}

		.ym-img-wrap {
			width: 100%;
			height: 100%;
			position: absolute;
			top: 0; left: 0;
			z-index: 1;
		}
		.ym-img-wrap img {
			width: 100%;
			height: 100%;
			object-fit: cover;
			transition: transform 0.8s cubic-bezier(0.2, 0.8, 0.2, 1);
		}
		.ym-item:hover .ym-img-wrap img { transform: scale(1.08); }

		/* OVERLAY RE-DESIGNED TO PREVENT CUTOFF */
		.ym-info-overlay {
			position: absolute;
			bottom: 0; left: 0; width: 100%;
			padding: 20px;
			background: linear-gradient(to top, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.6) 60%, transparent 100%);
			color: var(--ym-white);
			z-index: 2;
			display: flex;
			flex-direction: column;
			justify-content: flex-end;
		}

		.ym-p-name {
			font-size: 14px;
			font-weight: 800;
			text-transform: uppercase;
			margin: 0 0 5px 0;
			text-shadow: 1px 1px 2px rgba(0,0,0,0.8);
			display: -webkit-box;
			-webkit-line-clamp: 2;
			-webkit-box-orient: vertical;
			overflow: hidden;
		}
		.ym-item.featured .ym-p-name { font-size: 22px; }

		.ym-p-price {
			font-size: 14px;
			font-weight: 600;
			color: var(--ym-white);
		}

		/* ACTIONS EXPAND UPWARDS INSIDE THE CONTAINER */
		.ym-actions {
			display: flex;
			gap: 10px;
			margin-top: 0;
			max-height: 0;
			opacity: 0;
			overflow: hidden;
			transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
		}
		.ym-item:hover .ym-actions {
			margin-top: 15px;
			max-height: 50px;
			opacity: 1;
		}

		.btn-ym-action {
			flex: 1;
			padding: 10px 0;
			font-size: 11px;
			font-weight: 800;
			text-transform: uppercase;
			cursor: pointer;
			border: none;
		}
		.btn-ym-cart { background: var(--ym-white); color: var(--ym-black); }
		.btn-ym-buy { background: var(--ym-red); color: var(--ym-white); }
		.btn-ym-cart:hover { background: var(--ym-gray); }
		.btn-ym-buy:hover { background: #cc0000; }
		.btn-ym-disabled { background: rgba(255,255,255,0.2); color: #ccc; cursor: not-allowed; }

		.ym-badge-soldout {
			position: absolute;
			top: 20px; left: 20px;
			background: var(--ym-black);
			color: var(--ym-white);
			padding: 8px 15px;
			font-size: 11px;
			font-weight: 900;
			letter-spacing: 2px;
			z-index: 2;
		}

		.center-btn-wrap { text-align: center; margin-top: 60px; }
		.btn-massive {
			display: inline-block;
			padding: 20px 60px;
			background: var(--ym-black);
			color: var(--ym-white);
			font-size: 16px;
			font-weight: 900;
			text-transform: uppercase;
			text-decoration: none;
			letter-spacing: 4px;
		}
		.btn-massive:hover {
			background: var(--ym-white);
			color: var(--ym-black);
			border: 4px solid var(--ym-black);
			padding: 16px 56px;
		}

		/* 6. MƯỢT MÀ CHO MODAL (SMOOTH POPUP ANIMATION) */
		#buyNowModal {
			position: fixed;
			inset: 0;
			display: none;
			align-items: center;
			justify-content: center;
			z-index: 9999;
			transition: opacity 0.3s ease;
			opacity: 0;
		}

		.modal-backdrop {
			position: absolute;
			inset: 0;
			background: rgba(0, 0, 0, 0.6);
			backdrop-filter: blur(8px);
			-webkit-backdrop-filter: blur(8px);
		}

		@keyframes modalPop {
			0% { opacity: 0; transform: scale(0.8) translateY(30px); }
			100% { opacity: 1; transform: scale(1) translateY(0); }
		}

		.modal-inner {
			position: relative;
			background: rgba(255, 255, 255, 0.95);
			backdrop-filter: blur(20px);
			-webkit-backdrop-filter: blur(20px);
			width: 100%;
			max-width: 500px;
			padding: 40px;
			border: 2px solid var(--ym-black);
			box-shadow: 20px 20px 0px rgba(0,0,0,1);
			z-index: 2;
			animation: modalPop 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
		}

		.modal-close {
			position: absolute;
			top: -20px; right: -20px;
			background: var(--ym-black);
			color: var(--ym-white);
			width: 40px; height: 40px;
			border: none;
			font-size: 20px;
			font-weight: bold;
			cursor: pointer;
			display: flex;
			align-items: center;
			justify-content: center;
			transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), background 0.3s ease;
		}
		.modal-close:hover {
			background: var(--ym-red);
			transform: rotate(90deg) scale(1.1);
		}
		.modal-inner h3 {
			margin: 0 0 25px 0;
			font-size: 22px;
			font-weight: 900;
			text-transform: uppercase;
			letter-spacing: 1px;
		}
		.option-btn {
			padding: 10px 18px;
			border: 2px solid var(--ym-border);
			background: transparent;
			cursor: pointer;
			font-size: 12px;
			font-weight: 800;
			text-transform: uppercase;
			margin-right: 8px;
			margin-bottom: 8px;
		}
		.option-btn.selected, .option-btn:hover {
			border-color: var(--ym-black);
			background: var(--ym-black);
			color: var(--ym-white);
		}
		.modal-actions {
			display: flex;
			gap: 15px;
			margin-top: 35px;
		}
		.modal-actions button {
			flex: 1;
			padding: 16px 0;
			font-size: 13px;
			font-weight: 900;
			text-transform: uppercase;
			cursor: pointer;
			border: none;
			letter-spacing: 1px;
		}
		.btn-cancel { background: var(--ym-gray); color: var(--ym-black); border: 2px solid var(--ym-black); }
		.modal-buy-btn { background: var(--ym-black); color: var(--ym-white); border: 2px solid var(--ym-black); }
		.btn-cancel:hover { background: var(--ym-black); color: var(--ym-white); }
		.modal-buy-btn:hover { background: var(--ym-white); color: var(--ym-black); }
	</style>
	<link rel="stylesheet" href="CSS/user/home-modern.css">
</head>

<body class="ym-home-page">
<div class="marquee-bar">
	<div class="marquee-track" aria-label="Thông báo ưu đãi">
		<div class="marquee-group">
			<span><i class="fa-solid fa-diamond"></i> New season 2026</span>
			<span><i class="fa-solid fa-diamond"></i> Freeship đơn hàng từ 500K</span>
			<span><i class="fa-solid fa-diamond"></i> Đổi trả trong 7 ngày</span>
			<span><i class="fa-solid fa-diamond"></i> Phong cách tạo nên bản sắc</span>
		</div>
		<div class="marquee-group" aria-hidden="true">
			<span><i class="fa-solid fa-diamond"></i> New season 2026</span>
			<span><i class="fa-solid fa-diamond"></i> Freeship đơn hàng từ 500K</span>
			<span><i class="fa-solid fa-diamond"></i> Đổi trả trong 7 ngày</span>
			<span><i class="fa-solid fa-diamond"></i> Phong cách tạo nên bản sắc</span>
		</div>
	</div>
</div>

<jsp:include page="header.jsp">
	<jsp:param name="page" value="index" />
</jsp:include>

<main>
	<section class="hero-container" aria-labelledby="home-hero-title">
		<span class="hero-orb hero-orb--one" aria-hidden="true"></span>
		<span class="hero-orb hero-orb--two" aria-hidden="true"></span>

		<div class="hero-copy">
			<h1 class="hero-title-huge" id="home-hero-title">Mặc chất riêng.<span>Sống đúng gu.</span></h1>
			<p class="hero-description">Thiết kế dành cho nhịp sống hiện đại — tối giản, linh hoạt và đủ khác biệt để mỗi ngày bạn đều tự tin theo cách của riêng mình.</p>
			<div class="hero-ctas">
				<a href="#products" class="btn-hero-solid"><fmt:message key="home.hero.btn" /> <i class="fa-solid fa-arrow-right"></i></a>
				<a href="collection" class="btn-hero-ghost"><i class="fa-regular fa-images"></i> Khám phá lookbook</a>
			</div>
			<div class="hero-notes" aria-label="Cam kết cửa hàng">
				<div class="hero-note"><strong>100%</strong><span>Chính hãng</span></div>
				<div class="hero-note"><strong>07 ngày</strong><span>Đổi trả</span></div>
				<div class="hero-note"><strong>24/7</strong><span>Hỗ trợ</span></div>
			</div>
		</div>

		<div class="hero-visual" data-parallax-card>
			<div class="hero-image">
				<img src="img/banner2.jpg" alt="Bộ sưu tập thời trang nam mới 2026">
			</div>
			<div class="hero-float-card hero-float-card--top">
				<i class="fa-solid fa-wand-magic-sparkles"></i>
				<div><strong>New edit</strong><span>Curated weekly</span></div>
			</div>
			<div class="hero-float-card hero-float-card--bottom">
				<i class="fa-solid fa-truck-fast"></i>
				<div><strong>Giao nhanh 2H</strong><span>Nội thành TP.HCM</span></div>
			</div>
		</div>
	</section>

	<section class="ym-benefits ym-reveal" aria-label="Quyền lợi mua sắm">
		<div class="ym-benefit"><i class="fa-solid fa-shield-halved"></i><div><strong>Sản phẩm tuyển chọn</strong><span>Kiểm tra kỹ trước khi giao</span></div></div>
		<div class="ym-benefit"><i class="fa-solid fa-arrow-rotate-left"></i><div><strong>Đổi trả linh hoạt</strong><span>Hỗ trợ trong vòng 7 ngày</span></div></div>
		<div class="ym-benefit"><i class="fa-solid fa-box-open"></i><div><strong>Đóng gói chỉn chu</strong><span>Sẵn sàng để làm quà tặng</span></div></div>
		<div class="ym-benefit"><i class="fa-solid fa-headset"></i><div><strong>Tư vấn tận tâm</strong><span>Đồng hành cùng mọi phong cách</span></div></div>
	</section>

<section class="section-wrap ym-reveal" aria-labelledby="voucher-heading">
	<div class="ym-heading">
		<div class="ym-heading-copy">
			<span class="ym-section-kicker">Ưu đãi dành riêng cho bạn</span>
			<h2 id="voucher-heading">Chạm để nhận quà.</h2>
			<p>Lưu mã yêu thích và sử dụng ngay khi thanh toán. Mỗi ưu đãi là một lý do tuyệt vời để làm mới tủ đồ.</p>
		</div>
		<c:if test="${sessionScope.isAdmin}">
			<a href="admin-add-voucher.jsp" class="badge-add">+ <fmt:message key="home.voucher.add" /></a>
		</c:if>
	</div>

	<div class="voucher-scroller">
		<c:forEach var="v" items="${vouchers}">
			<article class="voucher-ticket">
				<div class="vt-left">
						<span class="vt-val">
                            <c:choose>
								<c:when test="${v.discountType == 'PERCENT'}">${v.discountAmount}%</c:when>
								<c:otherwise><fmt:formatNumber value="${v.discountAmount/1000}" />K</c:otherwise>
							</c:choose>
						</span>
					<span class="vt-unit">
                            <c:choose>
								<c:when test="${v.discountType == 'PERCENT'}">OFF</c:when>
								<c:otherwise>VNĐ</c:otherwise>
							</c:choose>
						</span>
				</div>
				<div class="vt-right">
					<div>
						<span class="vt-code">${v.code}</span>
						<h4 class="vt-desc">${v.description}</h4>
						<p class="vt-exp">
							<c:choose>
								<c:when test="${v.minOrder > 0}">Đơn tối thiểu: <fmt:formatNumber value="${v.minOrder}" />đ</c:when>
								<c:otherwise>HSD: ${v.expiryDate}</c:otherwise>
							</c:choose>
						</p>
					</div>
					<button class="btn-vt-save" onclick="saveVoucher(this, '${v.code}')">
						LƯU MÃ NGAY
					</button>
				</div>
			</article>
		</c:forEach>
	</div>
</section>

<section class="section-wrap ym-reveal" id="products" aria-labelledby="product-heading">
	<div class="ym-heading">
		<div class="ym-heading-copy">
			<span class="ym-section-kicker">The new essentials</span>
			<h2 id="product-heading">Đang được săn đón.</h2>
			<p>Những thiết kế nổi bật được chọn lọc cho diện mạo mới — dễ mặc, dễ phối và không hề mờ nhạt.</p>
		</div>
	</div>

	<div class="ym-grid">
		<c:forEach var="p" items="${products}" varStatus="loop">
			<c:if test="${loop.index < 7}">
				<c:set var="stock" value="${p.stockquantyti}" />
				<c:set var="inCart" value="${mapCart[p.pid] != null ? mapCart[p.pid] : 0}" />
				<c:set var="canAdd" value="${inCart < stock}" />

				<article class="ym-item ym-reveal ${loop.index == 0 ? 'featured' : ''}" data-delay="${loop.index % 4}">
					<div class="ym-img-wrap">
						<img src="${p.image != null ? p.image : 'img/no-image.png'}" alt="${p.pdescription}" loading="lazy" decoding="async">
					</div>

					<c:if test="${stock <= 0}">
						<span class="ym-badge-soldout">SOLD OUT</span>
					</c:if>

					<div class="ym-info-overlay">
						<h3 class="ym-p-name">${p.pdescription}</h3>
						<div class="ym-p-price"><fmt:formatNumber value="${p.price}" /> VNĐ</div>

						<div class="ym-card-actions">
							<c:choose>
								<c:when test="${canAdd && stock > 0}">
									<button type="button" class="btn-ym-action btn-ym-cart"
									        onclick="openBuyNowModal(this, 'cart')" data-pid="${p.pid}"
									        data-name="${p.pdescription}" data-img="${p.image != null ? p.image : 'img/no-image.png'}"
									        data-price="${p.price}" data-stock="${stock}" data-sizes="${p.size}" data-colors="${p.color}">
										<i class="fa-solid fa-cart-shopping"></i> GIỎ HÀNG
									</button>
									<button type="button" class="btn-ym-action btn-ym-buy"
									        onclick="openBuyNowModal(this, 'buy')" data-pid="${p.pid}"
									        data-name="${p.pdescription}" data-img="${p.image != null ? p.image : 'img/no-image.png'}"
									        data-price="${p.price}" data-stock="${stock}" data-sizes="${p.size}" data-colors="${p.color}">
										MUA NGAY
									</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn-ym-action btn-ym-disabled" disabled>
										<c:choose>
											<c:when test="${stock <= 0}">HẾT HÀNG</c:when>
											<c:otherwise>ĐẠT GIỚI HẠN</c:otherwise>
										</c:choose>
									</button>
								</c:otherwise>
							</c:choose>
							<a href="product-detail?pid=${p.pid}" class="btn-ym-action btn-ym-cart ym-view-button" aria-label="Xem chi tiết ${p.pdescription}"><i class="fa-regular fa-eye"></i></a>
						</div>
					</div>
					<div id="home-variants-${p.pid}" hidden>
						<c:forEach var="variant" items="${p.variants}">
							<span class="home-variant" data-stock="${variant.stockQuantity}">
								<span class="home-variant-size"><c:out value="${variant.size}" /></span>
								<span class="home-variant-color"><c:out value="${variant.color}" /></span>
							</span>
						</c:forEach>
					</div>
				</article>
			</c:if>
		</c:forEach>
	</div>

	<div class="center-btn-wrap">
		<a href="about" class="btn-massive">
			XEM TẤT CẢ SẢN PHẨM
		</a>
	</div>
</section>
</main>

<jsp:include page="footer.jsp" />

<div id="buyNowModal" aria-hidden="true" aria-labelledby="buy-modal-title" role="dialog" aria-modal="true">
	<div class="modal-backdrop" onclick="closeBuyNowModal()"></div>
	<div class="modal-inner">
		<button type="button" class="modal-close" onclick="closeBuyNowModal()" aria-label="Đóng cửa sổ"><i class="fa-solid fa-xmark"></i></button>
		<h3 id="buy-modal-title">Tùy chọn sản phẩm</h3>
		<form id="buyNowForm" action="buy-now" method="post">
			<input type="hidden" name="pid" id="modal-pid">
			<input type="hidden" name="action" id="modal-action" value="buy">
			<div id="modal-options"></div>
			<div class="modal-actions">
				<button type="button" class="btn-cancel" onclick="closeBuyNowModal()">HỦY</button>
				<button type="submit" class="modal-buy-btn" id="modal-submit-btn">XÁC NHẬN</button>
			</div>
		</form>
	</div>
</div>

<script>
	function openBuyNowModal(btn,mode) {
		try {
			window.ymLastModalTrigger = btn;
			var name = btn.getAttribute('data-name') || '';
			var img = btn.getAttribute('data-img') || 'img/no-image.png';
			var price = btn.getAttribute('data-price') || '0';
			var stock = parseInt(btn.getAttribute('data-stock') || '0', 10);
			var sizesRaw = btn.getAttribute('data-sizes') || '';
			var colorsRaw = btn.getAttribute('data-colors') || '';
			var pid = btn.getAttribute('data-pid');
			var variants = [];
			var variantRoot = document.getElementById('home-variants-' + pid);
			if (variantRoot) {
				variantRoot.querySelectorAll('.home-variant').forEach(function(node) {
					variants.push({
						size: (node.querySelector('.home-variant-size')?.textContent || '').trim(),
						color: (node.querySelector('.home-variant-color')?.textContent || '').trim(),
						stock: parseInt(node.getAttribute('data-stock') || '0', 10) || 0
					});
				});
			}
			function parseList(raw) {
				raw = raw.trim();
				if (!raw) return [];
				if (raw.startsWith('[') && raw.endsWith(']')) raw = raw.substring(1, raw.length-1);
				return raw.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s.length>0; });
			}

			var availableVariants = variants.filter(function(variant) { return variant.stock > 0; });
			var sizes = variants.length > 0
				? Array.from(new Set(availableVariants.map(function(variant) { return variant.size; })))
				: parseList(sizesRaw);
			var colors = variants.length > 0
				? Array.from(new Set(availableVariants.map(function(variant) { return variant.color; })))
				: parseList(colorsRaw);

			var optionsContainer = document.getElementById('modal-options');
			var isCart = (mode === 'cart');
			document.getElementById('modal-action').value = isCart ? 'add' : 'buy';
			document.getElementById('buyNowForm').action  = isCart ? 'add-to-cart' : 'buy-now';
			document.getElementById('modal-submit-btn').textContent = isCart ? 'THÊM GIỎ HÀNG' : 'THANH TOÁN NGAY';

			var html = '';
			html += '<div class="ym-modal-product">';
			html += '<img src="'+escapeHtml(img)+'" alt="'+escapeHtml(name)+'">';
			html += '<div>';
			html += '<h4>'+escapeHtml(name)+'</h4>';
			html += '<div class="ym-modal-price"><span id="modal-unit-price" hidden>'+price+'</span><span id="modal-total-price">'+formatPrice(price)+'</span> VNĐ</div>';
			html += '<div class="ym-modal-stock">Còn <strong id="modal-stock">'+stock+'</strong> sản phẩm</div>';

			html += '<div class="ym-quantity"><button type="button" class="qty-decr" aria-label="Giảm số lượng">−</button><input id="modal-quantity" type="text" inputmode="numeric" name="quantity" value="1" class="qty-input" aria-label="Số lượng"><button type="button" class="qty-incr" aria-label="Tăng số lượng">+</button></div>';
			html += '</div></div>';

			if (sizes.length>0) {
				html += '<div class="ym-option-group"><label>Chọn size</label><div id="modal-sizes">';
				for (var i=0;i<sizes.length;i++){
					var s = sizes[i]; html += '<button type="button" class="option-btn" data-value="'+escapeHtml(s)+'">'+escapeHtml(s)+'</button>';
				}
				html += '</div></div>';
			}

			if (colors.length>0) {
				html += '<div class="ym-option-group"><label>Chọn màu sắc</label><div id="modal-colors">';
				for (var j=0;j<colors.length;j++){ var c = colors[j]; html += '<button type="button" class="option-btn" data-value="'+escapeHtml(c)+'">'+escapeHtml(c)+'</button>'; }
				html += '</div></div>';
			}
			html += '<input type="hidden" name="size" id="modal-size">';
			html += '<input type="hidden" name="color" id="modal-color">';

			optionsContainer.innerHTML = html;
			document.getElementById('modal-pid').value = pid;
			var qtyInput = optionsContainer.querySelector('.qty-input');
			var decr = optionsContainer.querySelector('.qty-decr');
			var incr = optionsContainer.querySelector('.qty-incr');

			if (qtyInput) { qtyInput.value = '1'; }

			function updateTotal(){
				var q = parseInt((qtyInput && qtyInput.value) || '1', 10); if (isNaN(q) || q<1) q=1; if (q>stock) q = stock; if (qtyInput) qtyInput.value = q;
				var total = Number(price) * q;
				var totalEl = document.getElementById('modal-total-price');
				if (totalEl) totalEl.innerText = formatPrice(total);
			}

			if (decr && incr && qtyInput) {
				decr.addEventListener('click', function(){
					this.style.transform = "scale(0.8)"; setTimeout(() => this.style.transform = "scale(1)", 150);
					var v=parseInt(qtyInput.value||'1',10); if(isNaN(v)) v=1; if(v>1) qtyInput.value = v-1; updateTotal();
				});
				incr.addEventListener('click', function(){
					this.style.transform = "scale(0.8)"; setTimeout(() => this.style.transform = "scale(1)", 150);
					var v=parseInt(qtyInput.value||'1',10); if(isNaN(v)) v=1; if(v<stock) qtyInput.value = v+1; updateTotal();
				});
				qtyInput.addEventListener('input', function(){ var v=parseInt(qtyInput.value||'1',10); if(isNaN(v) || v<1) qtyInput.value=1; if(v>stock) qtyInput.value=stock; updateTotal(); });
			}
			function markSelected(containerId, value) {
				var wrap = document.getElementById(containerId);
				if (!wrap) return;
				wrap.querySelectorAll('.option-btn').forEach(function(button) {
					button.classList.toggle('selected', button.getAttribute('data-value') === value);
				});
			}

			function applyVariant(variant) {
				if (!variant) return;
				stock = variant.stock;
				document.getElementById('modal-size').value = variant.size;
				document.getElementById('modal-color').value = variant.color;
				markSelected('modal-sizes', variant.size);
				markSelected('modal-colors', variant.color);
				var stockElement = document.getElementById('modal-stock');
				if (stockElement) stockElement.textContent = stock;
				updateTotal();
			}

			function selectAvailableVariant(changedField, value) {
				if (availableVariants.length === 0) return;
				var currentSize = document.getElementById('modal-size').value;
				var currentColor = document.getElementById('modal-color').value;
				if (changedField === 'size') currentSize = value;
				else currentColor = value;
				var match = availableVariants.find(function(variant) {
					return variant.size === currentSize && variant.color === currentColor;
				});
				if (!match) {
					match = availableVariants.find(function(variant) {
						return changedField === 'size' ? variant.size === value : variant.color === value;
					});
				}
				applyVariant(match);
			}

			function wireOptions(containerId, hiddenId){
				var wrap = document.getElementById(containerId);
				if (!wrap) return;
				var buttons = wrap.querySelectorAll('.option-btn');
				buttons.forEach(function(b, idx){ b.addEventListener('click', function(){
					var val = b.getAttribute('data-value');
					if (availableVariants.length > 0) {
						selectAvailableVariant(hiddenId === 'modal-size' ? 'size' : 'color', val);
					} else {
						buttons.forEach(function(x){ x.classList.remove('selected'); });
						b.classList.add('selected');
						var hid = document.getElementById(hiddenId);
						if (hid) hid.value = val;
					}
				});
					if (idx===0 && availableVariants.length === 0) { b.classList.add('selected'); document.getElementById(hiddenId).value = b.getAttribute('data-value'); }
				});
			}
			wireOptions('modal-sizes','modal-size');
			wireOptions('modal-colors','modal-color');
			if (availableVariants.length > 0) applyVariant(availableVariants[0]);

			updateTotal();

			var modal = document.getElementById('buyNowModal');
			modal.classList.add('is-open');
			modal.setAttribute('aria-hidden', 'false');
			document.body.classList.add('ym-modal-open');
			var closeButton = modal.querySelector('.modal-close');
			if (closeButton) closeButton.focus();
		} catch (e) {
			console.error('openBuyNowModal error', e);
			alert('Không thể mở cửa sổ.');
		}
	}

	function closeBuyNowModal() {
		var modal = document.getElementById('buyNowModal');
		if (modal) {
			modal.classList.remove('is-open');
			modal.setAttribute('aria-hidden', 'true');
			document.body.classList.remove('ym-modal-open');
			if (window.ymLastModalTrigger) window.ymLastModalTrigger.focus();
		}
	}
	function escapeHtml(str){ if(!str) return ''; return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
	function formatPrice(p){ try { return Number(p).toLocaleString('vi-VN'); } catch(e){ return p; } }
</script>
<script>
	function saveVoucher(btn, code) {
		let originalText = btn.innerText;
		btn.innerText = "...";

		fetch('voucher', {
			method: 'POST',
			headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			body: 'action=save&code=' + encodeURIComponent(code)
		})
				.then(response => response.text())
				.then(data => {
					let result = data.trim();
					if (result === "SUCCESS") {
						btn.innerText = "ĐÃ LƯU ✓";
						btn.disabled = true;
					} else if (result === "EXISTED") {
						alert("Bạn đã lưu mã này rồi!");
						btn.innerText = "ĐÃ LƯU ✓";
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

<script>
	(function () {
		const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
		const revealItems = Array.from(document.querySelectorAll('.ym-reveal'));

		if (!reduceMotion && 'IntersectionObserver' in window) {
			document.documentElement.classList.add('reveal-ready');
			const observer = new IntersectionObserver(function (entries) {
				entries.forEach(function (entry) {
					if (!entry.isIntersecting) return;
					entry.target.classList.add('is-visible');
					observer.unobserve(entry.target);
				});
			}, { threshold: 0.12, rootMargin: '0px 0px -45px' });
			revealItems.forEach(function (item) { observer.observe(item); });
		} else {
			revealItems.forEach(function (item) { item.classList.add('is-visible'); });
		}

		if (!reduceMotion && window.matchMedia('(hover: hover) and (pointer: fine)').matches) {
			const parallax = document.querySelector('[data-parallax-card]');
			if (parallax) {
				const image = parallax.querySelector('.hero-image');
				parallax.addEventListener('pointermove', function (event) {
					const bounds = parallax.getBoundingClientRect();
					const x = (event.clientX - bounds.left) / bounds.width - 0.5;
					const y = (event.clientY - bounds.top) / bounds.height - 0.5;
					image.style.transform = 'rotateY(' + (x * 5 - 3) + 'deg) rotateX(' + (-y * 4 + 1) + 'deg) translate3d(' + (x * 5) + 'px,' + (y * 5) + 'px,0)';
				});
				parallax.addEventListener('pointerleave', function () { image.style.transform = ''; });
			}

			document.querySelectorAll('.ym-item').forEach(function (card) {
				card.addEventListener('pointermove', function (event) {
					const bounds = card.getBoundingClientRect();
					card.style.setProperty('--mx', (event.clientX - bounds.left) + 'px');
					card.style.setProperty('--my', (event.clientY - bounds.top) + 'px');
					card.classList.add('is-hovering');
				});
				card.addEventListener('pointerleave', function () { card.classList.remove('is-hovering'); });
			});
		}

		document.addEventListener('keydown', function (event) {
			var modal = document.getElementById('buyNowModal');
			if (event.key === 'Escape' && modal && modal.classList.contains('is-open')) {
				closeBuyNowModal();
			}
		});
	})();
</script>

</body>
</html>
