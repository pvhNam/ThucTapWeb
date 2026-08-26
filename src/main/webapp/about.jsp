<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setLocale
	value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title><fmt:message key="shop.page_title" /> | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/user/about.css">
<link rel="stylesheet" href="CSS/style.css">
<link rel="stylesheet" href="CSS/user/index.css">
</head>
<body class="ym-user-page ym-catalog-page">
	<jsp:include page="header.jsp"><jsp:param name="page"
			value="about" /></jsp:include>

	<section class="ym-page-hero">
		<span class="ym-page-eyebrow">Nam Thành Selection</span>
		<h1>
			<fmt:message key="shop.title" />
		</h1>
		<p>
			<fmt:message key="shop.breadcrumb" />
		</p>

		<c:if test="${not empty txtSearch}">
			<p style="color: #d4af37; margin-top: 10px; font-weight: bold;">
				<i class="fa-solid fa-magnifying-glass"></i> Kết quả tìm kiếm cho:
				"${txtSearch}"
			</p>
		</c:if>
	</section>

	<div class="page-container">

		<aside class="sidebar">
			<div class="filter-group">
				<h3 class="filter-title">
					<fmt:message key="shop.filter_price" />
				</h3>
				<ul class="filter-list">
					<li><a href="about?price=all${baseParams}"
						class="${priceFilter == null || priceFilter == 'all' ? 'active' : ''}">
							<i class="fa-solid fa-circle-check"></i> <fmt:message
								key="shop.price_all" />
					</a></li>
					<li><a href="about?price=under500${baseParams}"
						class="${priceFilter == 'under500' ? 'active' : ''}"> <i
							class="fa-solid fa-tag"></i> <fmt:message
								key="shop.price_under500" />
					</a></li>
					<li><a href="about?price=500to1000${baseParams}"
						class="${priceFilter == '500to1000' ? 'active' : ''}"> <i
							class="fa-solid fa-tag"></i> <fmt:message
								key="shop.price_500_1000" />
					</a></li>
					<li><a href="about?price=above1000${baseParams}"
						class="${priceFilter == 'above1000' ? 'active' : ''}"> <i
							class="fa-solid fa-tag"></i> <fmt:message
								key="shop.price_above1000" />
					</a></li>
				</ul>
			</div>

			<div class="filter-group">
				<h3 class="filter-title">
					<fmt:message key="shop.category" />
				</h3>
				<ul class="filter-list">
					<li><a href="about?category=áo nam${baseParams}" class="${categoryFilter == null || categoryFilter == 'all' ? '' : (categoryFilter == 'áo nam' ? 'active' : '')}">Áo nam</a></li>
					<li><a href="about?category=quần nam${baseParams}" class="${categoryFilter == 'quần nam' ? 'active' : ''}">Quần nam</a></li>
					<li><a href="about?category=phụ kiện${baseParams}" class="${categoryFilter == 'phụ kiện' ? 'active' : ''}">Phụ kiện</a></li>
					<li><a href="about?category=bộ sưu tập 2026${baseParams}" class="${categoryFilter == 'bộ sưu tập 2026' ? 'active' : ''}">Bộ sưu tập 2026</a></li>
				</ul>
			</div>
		</aside>

		<main class="main-content">
			<div class="shop-toolbar">
				<span class="result-count"><fmt:message key="shop.showing" />
					<b><c:out value="${totalProducts > 0 ? start+1 : 0}" /></b>-<b><c:out
							value="${end}" /></b> <fmt:message key="shop.of" /> <b><c:out
							value="${totalProducts}" /></b> <fmt:message key="shop.results" /></span>

				<form action="about" method="get" class="sort-box">
					<c:if test="${not empty priceFilter}">
						<input type="hidden" name="price" value="${priceFilter}">
					</c:if>
					<c:if test="${not empty txtSearch}">
						<input type="hidden" name="txt" value="${txtSearch}">
					</c:if>

					<select name="sort" onchange="this.form.submit()">
						<option value="default"><fmt:message
								key="shop.sort_default" /></option>
						<option value="price_asc"
							${sortType == 'price_asc' ? 'selected' : ''}><fmt:message
								key="shop.sort_price_asc" /></option>
						<option value="price_desc"
							${sortType == 'price_desc' ? 'selected' : ''}><fmt:message
								key="shop.sort_price_desc" /></option>
						<option value="name_asc"
							${sortType == 'name_asc' ? 'selected' : ''}><fmt:message
								key="shop.sort_name" /></option>
					</select>
				</form>
			</div>

			<div class="product-grid-shop">
				<c:choose>
					<c:when test="${empty pageProducts}">
						<div style="grid-column: 1/-1; text-align: center; padding: 50px;">
							<i class="fa-solid fa-box-open"
								style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i>
							<p>
								<fmt:message key="shop.no_products" />
							</p>
							<a href="about"
								style="color: var(--gold); text-decoration: underline; font-weight: 600;">
								<i class="fa-solid fa-rotate-left"></i> <fmt:message
									key="shop.clear_filter" />
							</a>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="p" items="${pageProducts}">

							<c:set var="stock" value="${p.stockquantyti}" />
							<c:set var="inCart"
								value="${mapCart[p.pid] != null ? mapCart[p.pid] : 0}" />
							<c:set var="canAdd" value="${inCart < stock}" />

							<div class="product-card">
								<div class="product-image">
									<a href="product-detail?pid=${p.pid}"> <img
										src="${p.image != null ? p.image : 'img/no-image.png'}"
										alt="${p.pdescription}">
									</a> <a href="product-detail?pid=${p.pid}" class="overlay-btn"><i
										class="fa-regular fa-eye"></i></a>

									<c:if test="${stock <= 0}">
										<span
											style="position: absolute; top: 10px; left: 10px; background: #e74a3b; color: white; padding: 5px 10px; font-size: 12px; font-weight: bold; border-radius: 4px;">SOLD
											OUT</span>
									</c:if>
								</div>

								<div class="product-details">
									<h3 class="product-name">
										<a href="product-detail?pid=${p.pid}">${p.pdescription}</a>
									</h3>
									<span class="price"><fmt:formatNumber value="${p.price}"
											pattern="#,###" /> VNĐ</span>

									<div class="button-group">
										<c:choose>
											<c:when test="${canAdd && stock > 0}">
												<button type="button" class="btn-add-cart"
													onclick="openBuyNowModal(this, 'cart')" data-pid="${p.pid}"
													data-name="${p.pdescription}"
													data-img="${p.image != null ? p.image : 'img/no-image.png'}"
													data-price="${p.price}" data-stock="${stock}"
													data-sizes="${p.size}" data-colors="${p.color}">
													<fmt:message key="home.product.add_cart" />
												</button>

												<button type="button" class="btn-buy-now"
													onclick="openBuyNowModal(this, 'buy')" data-pid="${p.pid}"
													data-name="${p.pdescription}"
													data-img="${p.image != null ? p.image : 'img/no-image.png'}"
													data-price="${p.price}" data-stock="${stock}"
													data-sizes="${p.size}" data-colors="${p.color}">MUA
													NGAY</button>
											</c:when>
											<c:otherwise>
												<button type="button" class="btn-add-cart" disabled
													style="background-color: #ccc; color: #666; cursor: not-allowed; border: 1px solid #ccc;">
													<c:choose>
														<c:when test="${stock <= 0}">Hết hàng</c:when>
														<c:otherwise>Đã đạt giới hạn</c:otherwise>
													</c:choose>
												</button>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>

			<c:if test="${totalPages > 1}">
				<div class="pagination">
					<c:if test="${pageCurrent > 1}">
						<a href="about?page=${pageCurrent - 1}${pageParams}"
							class="page-link"><i class="fa-solid fa-chevron-left"></i></a>
					</c:if>

					<c:forEach var="i" begin="1" end="${totalPages}">
						<a href="about?page=${i}${pageParams}"
							class="page-link <c:out value='${i == pageCurrent ? "active" : ""}'/>">${i}</a>
					</c:forEach>

					<c:if test="${pageCurrent < totalPages}">
						<a href="about?page=${pageCurrent + 1}${pageParams}"
							class="page-link"><i class="fa-solid fa-chevron-right"></i></a>
					</c:if>
				</div>
			</c:if>
		</main>
	</div>
	<jsp:include page="footer.jsp" />

	<div id="buyNowModal" style="display: none;">
		<div class="modal-backdrop" onclick="closeBuyNowModal()"></div>
		<div class="modal-inner">
			<button type="button" class="modal-close"
				onclick="closeBuyNowModal()">&times;</button>
			<h3>Chọn kích thước và màu</h3>
			<form id="buyNowForm" action="buy-now" method="post">
				<input type="hidden" name="pid" id="modal-pid"> <input
					type="hidden" name="action" id="modal-action" value="buy">
				<div id="modal-options"></div>
				<div class="modal-actions">
					<button type="button" class="btn-cancel"
						onclick="closeBuyNowModal()">Hủy</button>
					<button type="submit" class="modal-buy-btn" id="modal-submit-btn">MUA
						NGAY</button>
				</div>
			</form>
		</div>
	</div>
	<script>
		function openBuyNowModal(btn, mode) {
			try {
				var name = btn.getAttribute('data-name') || '';
				var img = btn.getAttribute('data-img') || 'img/no-image.png';
				var price = btn.getAttribute('data-price') || '0';
				var stock = parseInt(btn.getAttribute('data-stock') || '0', 10);
				var sizesRaw = btn.getAttribute('data-sizes') || '';
				var colorsRaw = btn.getAttribute('data-colors') || '';
				var pid = btn.getAttribute('data-pid');
				function parseList(raw) {
					raw = raw.trim();
					if (!raw)
						return [];
					if (raw.startsWith('[') && raw.endsWith(']'))
						raw = raw.substring(1, raw.length - 1);
					return raw.split(',').map(function(s) {
						return s.trim();
					}).filter(function(s) {
						return s.length > 0;
					});
				}

				var sizes = parseList(sizesRaw);
				var colors = parseList(colorsRaw);

				var optionsContainer = document.getElementById('modal-options');
				var isCart = (mode === 'cart');
				document.getElementById('modal-action').value = isCart ? 'add'
						: 'buy';
				document.getElementById('buyNowForm').action = isCart ? 'add-to-cart'
						: 'buy-now';
				document.getElementById('modal-submit-btn').textContent = isCart ? 'THÊM VÀO GIỎ'
						: 'MUA NGAY';
				var html = '';
				html += '<div style="display:flex; gap:12px; align-items:flex-start;">';
				html += '<img class="product-mini" src="' + escapeHtml(img)
						+ '" alt="' + escapeHtml(name) + '">';
				html += '<div style="flex:1">';
				html += '<h4 style="margin:0 0 6px; font-size:16px">'
						+ escapeHtml(name) + '</h4>';
				html += '<div style="color:#e74a3b;font-weight:700;margin-bottom:6px">Đơn giá: <span id="modal-unit-price">'
						+ formatPrice(price) + '</span> VNĐ</div>';
				html += '<div style="color:#111;font-weight:700;margin-bottom:6px">Tổng: <span id="modal-total-price">'
						+ formatPrice(price) + '</span> VNĐ</div>';
				html += '<div style="font-size:13px;color:#666;margin-bottom:8px">Còn lại: <strong id="modal-stock">'
						+ stock + '</strong></div>';
				html += '<div style="display:flex;align-items:center;gap:8px;margin-bottom:8px">Số lượng: <button type="button" class="qty-decr">-</button><input id="modal-quantity" type="text" name="quantity" value="1" class="qty-input" /> <button type="button" class="qty-incr">+</button></div>';
				html += '</div></div>';

				if (sizes.length > 0) {
					html += '<div class="template-field"><label>Size</label><div class="options-row" id="modal-sizes">';
					for (var i = 0; i < sizes.length; i++) {
						var s = sizes[i];
						html += '<button type="button" class="option-btn" data-value="'
								+ escapeHtml(s)
								+ '">'
								+ escapeHtml(s)
								+ '</button>';
					}
					html += '</div></div>';
				}

				if (colors.length > 0) {
					html += '<div class="template-field"><label>Màu</label><div class="options-row" id="modal-colors">';
					for (var j = 0; j < colors.length; j++) {
						var c = colors[j];
						html += '<button type="button" class="option-btn" data-value="'
								+ escapeHtml(c)
								+ '">'
								+ escapeHtml(c)
								+ '</button>';
					}
					html += '</div></div>';
				}
				html += '<input type="hidden" name="size" id="modal-size">';
				html += '<input type="hidden" name="color" id="modal-color">';

				optionsContainer.innerHTML = html;
				document.getElementById('modal-pid').value = pid;
				var qtyInput = optionsContainer.querySelector('.qty-input');
				var decr = optionsContainer.querySelector('.qty-decr');
				var incr = optionsContainer.querySelector('.qty-incr');

				if (qtyInput) {
					qtyInput.value = '1';
				}

				function updateTotal() {
					var q = parseInt((qtyInput && qtyInput.value) || '1', 10);
					if (isNaN(q) || q < 1)
						q = 1;
					if (q > stock)
						q = stock;
					if (qtyInput)
						qtyInput.value = q;
					var total = Number(price) * q;
					var totalEl = document.getElementById('modal-total-price');
					if (totalEl)
						totalEl.innerText = formatPrice(total);
				}

				if (decr && incr && qtyInput) {
					decr.addEventListener('click', function() {
						var v = parseInt(qtyInput.value || '1', 10);
						if (isNaN(v))
							v = 1;
						if (v > 1)
							qtyInput.value = v - 1;
						updateTotal();
					});
					incr.addEventListener('click', function() {
						var v = parseInt(qtyInput.value || '1', 10);
						if (isNaN(v))
							v = 1;
						if (v < stock)
							qtyInput.value = v + 1;
						updateTotal();
					});
					qtyInput.addEventListener('input', function() {
						var v = parseInt(qtyInput.value || '1', 10);
						if (isNaN(v) || v < 1)
							qtyInput.value = 1;
						if (v > stock)
							qtyInput.value = stock;
						updateTotal();
					});
				}
				function wireOptions(containerId, hiddenId) {
					var wrap = document.getElementById(containerId);
					if (!wrap)
						return;
					var buttons = wrap.querySelectorAll('.option-btn');
					buttons.forEach(function(b, idx) {
						b.addEventListener('click', function() {
							buttons.forEach(function(x) {
								x.classList.remove('selected');
							});
							b.classList.add('selected');
							var val = b.getAttribute('data-value');
							var hid = document.getElementById(hiddenId);
							if (hid)
								hid.value = val;
						});
						if (idx === 0) {
							b.classList.add('selected');
							document.getElementById(hiddenId).value = b
									.getAttribute('data-value');
						}
					});
				}
				wireOptions('modal-sizes', 'modal-size');
				wireOptions('modal-colors', 'modal-color');

				updateTotal();
				var modal = document.getElementById('buyNowModal');
				modal.style.display = 'flex';
				setTimeout(
						function() {
							var validateBtn = document
									.getElementById('modal-validate');
							var confirmBox = document
									.getElementById('modal-confirm');
							var confirmSize = document
									.getElementById('confirm-size-modal');
							var confirmColor = document
									.getElementById('confirm-color-modal');
							var confirmQty = document
									.getElementById('confirm-qty-modal');
							var confirmTotal = document
									.getElementById('confirm-total-modal');
							var unitPriceEl = document
									.getElementById('modal-unit-price');
							var qtyInputInner = document
									.getElementById('modal-quantity');

							if (validateBtn) {
								validateBtn
										.addEventListener(
												'click',
												function() {
													var sz = document
															.getElementById('modal-size') ? document
															.getElementById('modal-size').value
															: '';
													var cl = document
															.getElementById('modal-color') ? document
															.getElementById('modal-color').value
															: '';
													var q = qtyInputInner ? (parseInt(
															qtyInputInner.value
																	|| '1', 10) || 1)
															: 1;
													confirmSize.textContent = sz
															|| 'Mặc định';
													confirmColor.textContent = cl
															|| 'Mặc định';
													confirmQty.textContent = q;
													var unit = 0;
													try {
														unit = Number((unitPriceEl && unitPriceEl.textContent) ? unitPriceEl.textContent
																.replace(/\D/g,
																		'')
																: 0);
													} catch (e) {
														unit = 0;
													}
													var total = (unit || Number(price))
															* q;
													confirmTotal.textContent = (typeof Intl !== 'undefined' ? Intl
															.NumberFormat(
																	'vi-VN')
															.format(total)
															: total);
													confirmBox.style.display = 'block';
													confirmBox.scrollIntoView({
														behavior : 'smooth',
														block : 'nearest'
													});
												});
							}
						}, 20);
			} catch (e) {
				console.error('openBuyNowModal error', e);
				alert('Không thể mở cửa sổ mua ngay.');
			}
		}

		function closeBuyNowModal() {
			var modal = document.getElementById('buyNowModal');
			if (modal)
				modal.style.display = 'none';
		}

		function escapeHtml(str) {
			if (!str)
				return '';
			return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;')
					.replace(/>/g, '&gt;').replace(/"/g, '&quot;');
		}
		function formatPrice(p) {
			try {
				return Number(p).toLocaleString('vi-VN');
			} catch (e) {
				return p;
			}
		}
	</script>

</body>
</html>
