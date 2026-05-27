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

							<div class="button-group">

								<c:choose>

									<c:when test="${canAdd && stock > 0}">
										<form action="add-to-cart" method="post">
											<input type="hidden" name="action" value="add"> <input
												type="hidden" name="pid" value="${p.pid}"> <input
												type="hidden" name="quantity" value="1">

											<button type="submit" class="btn-add-cart">
												<fmt:message key="home.product.add_cart" />
											</button>
										</form>
										<button type="button" class="btn-buy-now"
											onclick="openBuyNowModal(this)"
											data-pid="${p.pid}"
											data-name="${p.pdescription}"
											data-img="${p.image != null ? p.image : 'img/no-image.png'}"
											data-price="${p.price}"
											data-stock="${stock}"
											data-sizes="${p.size}"
											data-colors="${p.color}"
											>MUA NGAY</button>

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

							</div>
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
	<div id="buyNowModal">
		<div class="modal-backdrop" onclick="closeBuyNowModal()"></div>
		<div class="modal-inner">
			<button type="button" class="modal-close" onclick="closeBuyNowModal()">&times;</button>
			<h3>Chọn kích thước và màu</h3>
			<form id="buyNowForm" action="buy-now" method="post">
				<input type="hidden" name="pid" id="modal-pid">
				<div id="modal-options"></div>
				<div class="modal-actions">
					<button type="button" class="btn-cancel" onclick="closeBuyNowModal()">Hủy</button>
					<button type="submit" class="modal-buy-btn">MUA NGAY</button>
				</div>
			</form>
		</div>
	</div>

	<!-- SCRIPT  -->
	<script>
	function openBuyNowModal(btn) {
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
				if (!raw) return [];
				if (raw.startsWith('[') && raw.endsWith(']')) raw = raw.substring(1, raw.length-1);
				return raw.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s.length>0; });
			}

			var sizes = parseList(sizesRaw);
			var colors = parseList(colorsRaw);

			var optionsContainer = document.getElementById('modal-options');
			var html = '';
			html += '<div style="display:flex; gap:12px; align-items:flex-start;">';
			html += '<img class="product-mini" src="'+escapeHtml(img)+'" alt="'+escapeHtml(name)+'">';
			html += '<div style="flex:1">';
			html += '<h4 style="margin:0 0 6px; font-size:16px">'+escapeHtml(name)+'</h4>';
			html += '<div style="color:#e74a3b;font-weight:700;margin-bottom:6px">Đơn giá: <span id="modal-unit-price">'+formatPrice(price)+'</span> VNĐ</div>';
			html += '<div style="color:#111;font-weight:700;margin-bottom:6px">Tổng: <span id="modal-total-price">'+formatPrice(price)+'</span> VNĐ</div>';
			html += '<div style="font-size:13px;color:#666;margin-bottom:8px">Còn lại: <strong id="modal-stock">'+stock+'</strong></div>';
			html += '<div style="display:flex;align-items:center;gap:8px;margin-bottom:8px">Số lượng: <button type="button" class="qty-decr">-</button><input id="modal-quantity" type="text" name="quantity" value="1" class="qty-input" /> <button type="button" class="qty-incr">+</button></div>';
			html += '</div></div>';

			if (sizes.length>0) {
				html += '<div class="template-field"><label>Size</label><div class="options-row" id="modal-sizes">';
				for (var i=0;i<sizes.length;i++){
					var s = sizes[i]; html += '<button type="button" class="option-btn" data-value="'+escapeHtml(s)+'">'+escapeHtml(s)+'</button>';
				}
				html += '</div></div>';
			}

			if (colors.length>0) {
				html += '<div class="template-field"><label>Màu</label><div class="options-row" id="modal-colors">';
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
				decr.addEventListener('click', function(){ var v=parseInt(qtyInput.value||'1',10); if(isNaN(v)) v=1; if(v>1) qtyInput.value = v-1; updateTotal(); });
				incr.addEventListener('click', function(){ var v=parseInt(qtyInput.value||'1',10); if(isNaN(v)) v=1; if(v<stock) qtyInput.value = v+1; updateTotal(); });
				qtyInput.addEventListener('input', function(){ var v=parseInt(qtyInput.value||'1',10); if(isNaN(v) || v<1) qtyInput.value=1; if(v>stock) qtyInput.value=stock; updateTotal(); });
			}
			function wireOptions(containerId, hiddenId){
				var wrap = document.getElementById(containerId);
				if (!wrap) return;
				var buttons = wrap.querySelectorAll('.option-btn');
				buttons.forEach(function(b, idx){ b.addEventListener('click', function(){
					buttons.forEach(function(x){ x.classList.remove('selected'); });
					b.classList.add('selected');
					var val = b.getAttribute('data-value');
					var hid = document.getElementById(hiddenId);
					if (hid) hid.value = val;
				});
				if (idx===0) { b.classList.add('selected'); document.getElementById(hiddenId).value = b.getAttribute('data-value'); }
				});
			}
			wireOptions('modal-sizes','modal-size');
			wireOptions('modal-colors','modal-color');

			updateTotal();
			var modal = document.getElementById('buyNowModal');
			modal.style.display = 'flex';
			setTimeout(function(){
				var validateBtn = document.getElementById('modal-validate');
				var confirmBox = document.getElementById('modal-confirm');
				var confirmSize = document.getElementById('confirm-size-modal');
				var confirmColor = document.getElementById('confirm-color-modal');
				var confirmQty = document.getElementById('confirm-qty-modal');
				var confirmTotal = document.getElementById('confirm-total-modal');
				var unitPriceEl = document.getElementById('modal-unit-price');
				var qtyInputInner = document.getElementById('modal-quantity');

				if (validateBtn) {
					validateBtn.addEventListener('click', function(){
						var sz = document.getElementById('modal-size') ? document.getElementById('modal-size').value : '';
						var cl = document.getElementById('modal-color') ? document.getElementById('modal-color').value : '';
						var q = qtyInputInner ? (parseInt(qtyInputInner.value||'1',10)||1) : 1;
						confirmSize.textContent = sz || 'Mặc định';
						confirmColor.textContent = cl || 'Mặc định';
						confirmQty.textContent = q;
						var unit = 0; try { unit = Number((unitPriceEl && unitPriceEl.textContent) ? unitPriceEl.textContent.replace(/\D/g,'') : 0); } catch(e){ unit = 0; }
						var total = (unit || Number(price)) * q;
						confirmTotal.textContent = (typeof Intl !== 'undefined' ? Intl.NumberFormat('vi-VN').format(total) : total);
						confirmBox.style.display = 'block';
						confirmBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
					});
				}
			}, 20);
		} catch (e) {
			console.error('openBuyNowModal error', e);
			alert('Không thể mở cửa sổ mua ngay.');
		}
	}

	function closeBuyNowModal() { var modal = document.getElementById('buyNowModal'); if (modal) modal.style.display = 'none'; }

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