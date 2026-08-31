<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>${p.pdescription} | Fashion Store</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css?v=20260831.1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/user/product-detail.css?v=20260831.3" />
</head>
<body class="ym-user-page ym-product-page">
<jsp:include page="header.jsp"><jsp:param name="page" value="index"/></jsp:include>

<div class="back-nav">
    <a href="javascript:history.back()" class="btn-back">
        <i class="fa-solid fa-arrow-left-long"></i>
        <fmt:message key="product.back" />
    </a>
</div>

<div class="detail-wrapper">

    <!-- LEFT: Image Slider -->
    <div class="detail-left">
        <div class="slider-container" id="sliderContainer" tabindex="0" aria-label="Bộ ảnh sản phẩm">
            <div class="slider-track" id="sliderTrack"></div>
            <button type="button" class="slider-btn prev" id="btnPrev" aria-label="Ảnh trước">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <button type="button" class="slider-btn next" id="btnNext" aria-label="Ảnh tiếp theo">
                <i class="fa-solid fa-chevron-right"></i>
            </button>
            <div class="slider-dots" id="sliderDots"></div>
            <div class="slide-counter" id="slideCounter" aria-live="polite">1 / 1</div>
        </div>
        <div class="thumbnail-gallery" id="thumbGallery"></div>
        <div id="img-data" style="display:none" data-main="${not empty p.image ? p.image : 'img/no-image.png'}">
            <c:if test="${not empty p.extraImages}">
                <c:forEach var="img" items="${p.extraImages}">
                    <span class="extra-img">${img}</span>
                </c:forEach>
            </c:if>
        </div>
    </div>

    <!-- RIGHT: Product Info -->
    <div class="detail-right">
        <span class="p-cat"><fmt:message key="product.code" />: #${p.pid}</span>
        <h1 class="p-title">${p.pdescription}</h1>
        <a class="p-rating-summary" href="#reviews">
            <span class="p-rating-stars" aria-hidden="true">
                <c:forEach begin="1" end="5" var="star">
                    <c:choose>
                        <c:when test="${p.reviewCount > 0 && p.averageRating >= star}"><i class="fa-solid fa-star"></i></c:when>
                        <c:when test="${p.reviewCount > 0 && p.averageRating >= star - 0.5}"><i class="fa-solid fa-star-half-stroke"></i></c:when>
                        <c:otherwise><i class="fa-regular fa-star"></i></c:otherwise>
                    </c:choose>
                </c:forEach>
            </span>
            <c:choose>
                <c:when test="${p.reviewCount > 0}">
                    <strong><fmt:formatNumber value="${p.averageRating}" minFractionDigits="1" maxFractionDigits="1" /></strong>
                    <span>${p.reviewCount} đánh giá</span>
                </c:when>
                <c:otherwise><span>Chưa có đánh giá</span></c:otherwise>
            </c:choose>
        </a>
        <div class="p-price"><fmt:formatNumber value="${p.price}" pattern="#,### 'VNĐ'"/></div>

        <form method="post" id="productForm">
            <input type="hidden" name="pid" value="${p.pid}">

            <!-- SIZE -->
            <div class="variant-box">
                <div class="variant-title">
                    Kích thước (Size): <span class="selected-val" id="sz-display"></span>
                </div>
                <div id="size-options">
                    <c:choose>
                        <c:when test="${not empty p.variants}"><%-- filled by JS --%></c:when>
                        <c:otherwise>
                            <input type="hidden" name="size" value="${p.size != null ? p.size : 'Mặc định'}">
                            <span class="size-label" style="pointer-events:none; opacity:0.7;">
                                    ${p.size != null ? p.size : 'Mặc định'}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- COLOR -->
            <div class="variant-box">
                <div class="variant-title">
                    Màu sắc (Color): <span class="selected-val" id="cl-display"></span>
                </div>
                <div id="color-options">
                    <c:choose>
                        <c:when test="${not empty p.variants}"><%-- filled by JS --%></c:when>
                        <c:otherwise>
                            <input type="hidden" name="color" value="${p.color != null ? p.color : 'Mặc định'}">
                            <span class="color-swatch-wrap">
                                <span class="color-swatch" style="background:#ccc; border-color:#999; pointer-events:none;"></span>
                                <span class="color-swatch-name">${p.color != null ? p.color : 'Mặc định'}</span>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- STOCK -->
            <div class="stock-wrap">
                <span class="meta-label" style="font-size:0.78rem; font-weight:700; letter-spacing:0.08em; text-transform:uppercase; color:#888;">
                    <fmt:message key="product.status" />:
                </span>
                <span class="stock-dot pending" id="stock-dot"></span>
                <span id="stock-display">
                    <c:choose>
                        <c:when test="${empty p.variants && p.stockquantyti > 0}">Còn hàng (${p.stockquantyti})</c:when>
                        <c:when test="${empty p.variants && p.stockquantyti <= 0}">Hết hàng</c:when>
                        <c:otherwise>Vui lòng chọn Size &amp; Màu</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <!-- ACTIONS -->
            <div class="action-row">
                <input type="number" name="quantity" id="qty-input"
                       value="${p.stockquantyti > 0 ? 1 : 0}"
                       min="1" max="${p.stockquantyti}" class="qty-input">
                <button type="submit" formaction="add-to-cart" id="btn-add"
                        class="btn-add-cart-detail ${empty p.variants && p.stockquantyti <= 0 ? 'btn-disabled' : ''}">
                    <fmt:message key="home.product.add_cart" />
                </button>
                <button type="submit" formaction="buy-now" id="btn-buy"
                        class="btn-buy-now ${empty p.variants && p.stockquantyti <= 0 ? 'btn-disabled' : ''}">
                    MUA NGAY
                </button>
            </div>
        </form>

        <p class="p-desc">${p.pdescription}. <fmt:message key="product.desc_default" /></p>
    </div>
</div>

<section class="reviews-section" id="reviews" aria-labelledby="reviews-title">
    <div class="reviews-heading">
        <div>
            <span class="reviews-kicker">Khách hàng nói gì?</span>
            <h2 id="reviews-title">Đánh giá sản phẩm</h2>
            <p>Chia sẻ trải nghiệm thực tế để cộng đồng mua sắm dễ dàng hơn.</p>
        </div>
        <span class="reviews-total-pill"><i class="fa-regular fa-comment-dots"></i> ${p.reviewCount} đánh giá</span>
    </div>

    <c:if test="${not empty reviewSuccess}">
        <div class="review-alert review-alert--success" role="status">
            <i class="fa-solid fa-circle-check"></i> <c:out value="${reviewSuccess}" />
        </div>
    </c:if>
    <c:if test="${not empty reviewError}">
        <div class="review-alert review-alert--error" role="alert">
            <i class="fa-solid fa-circle-exclamation"></i> <c:out value="${reviewError}" />
        </div>
    </c:if>

    <div class="reviews-dashboard">
        <aside class="review-overview-card" aria-label="Tổng quan đánh giá">
            <div class="review-average-block">
                <div class="review-average-number">
                    <strong><fmt:formatNumber value="${p.averageRating}" minFractionDigits="1" maxFractionDigits="1" /></strong>
                    <span>/ 5</span>
                </div>
                <div class="review-average-stars" aria-label="${p.averageRating} trên 5 sao">
                    <c:forEach begin="1" end="5" var="star">
                        <c:choose>
                            <c:when test="${p.reviewCount > 0 && p.averageRating >= star}"><i class="fa-solid fa-star"></i></c:when>
                            <c:when test="${p.reviewCount > 0 && p.averageRating >= star - 0.5}"><i class="fa-solid fa-star-half-stroke"></i></c:when>
                            <c:otherwise><i class="fa-regular fa-star"></i></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <p>Dựa trên ${p.reviewCount} lượt đánh giá</p>
            </div>

            <div class="review-distribution">
                <c:forEach begin="1" end="5" var="position">
                    <c:set var="starValue" value="${6 - position}" />
                    <div class="review-distribution-row">
                        <span>${starValue} <i class="fa-solid fa-star" aria-hidden="true"></i></span>
                        <div class="review-progress" aria-hidden="true">
                            <span style="--rating-percent: ${p.reviewCount > 0 ? ratingCounts[starValue] * 100 / p.reviewCount : 0}%;"></span>
                        </div>
                        <small>${ratingCounts[starValue]}</small>
                    </div>
                </c:forEach>
            </div>
        </aside>

        <div class="review-compose-card">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <form action="product-review" method="post" class="review-form">
                        <input type="hidden" name="pid" value="${p.pid}">
                        <input type="hidden" name="csrfToken" value="${reviewCsrfToken}">

                        <div class="review-form-heading">
                            <span class="review-form-icon"><i class="fa-regular fa-pen-to-square"></i></span>
                            <div>
                                <h3>${empty currentReview ? 'Viết đánh giá của bạn' : 'Chỉnh sửa đánh giá'}</h3>
                                <p>${empty currentReview ? 'Bạn cảm thấy sản phẩm này thế nào?' : 'Cập nhật lại trải nghiệm bất cứ lúc nào.'}</p>
                            </div>
                        </div>

                        <fieldset class="review-rating-field">
                            <legend>Mức độ hài lòng <span aria-hidden="true">*</span></legend>
                            <div class="review-star-picker" aria-label="Chọn số sao đánh giá">
                                <c:forEach begin="1" end="5" var="position">
                                    <c:set var="starValue" value="${6 - position}" />
                                    <c:choose>
                                        <c:when test="${not empty currentReview && currentReview.rating == starValue}">
                                            <input type="radio" id="review-star-${starValue}" name="rating" value="${starValue}" checked required>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="radio" id="review-star-${starValue}" name="rating" value="${starValue}" required>
                                        </c:otherwise>
                                    </c:choose>
                                    <label for="review-star-${starValue}" title="${starValue} sao">
                                        <i class="fa-solid fa-star" aria-hidden="true"></i>
                                        <span class="sr-only">${starValue} sao</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </fieldset>

                        <label class="review-comment-label" for="review-comment">Nhận xét <span>(không bắt buộc)</span></label>
                        <div class="review-textarea-wrap">
                            <textarea id="review-comment" name="comment" maxlength="1000" rows="4"
                                      placeholder="Ví dụ: Chất liệu đẹp, form vừa vặn, giao hàng nhanh..."><c:out value="${currentReview.comment}" /></textarea>
                            <i class="fa-regular fa-message" aria-hidden="true"></i>
                        </div>
                        <div class="review-form-footer">
                            <small><i class="fa-solid fa-shield-halved"></i> Đánh giá được lưu theo tài khoản</small>
                            <button type="submit">
                                ${empty currentReview ? 'Gửi đánh giá' : 'Lưu thay đổi'}
                                <i class="fa-solid fa-arrow-right"></i>
                            </button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="review-login-callout">
                        <span class="review-login-icon"><i class="fa-regular fa-user"></i></span>
                        <div>
                            <span class="review-login-kicker">Tham gia cộng đồng</span>
                            <h3>Đăng nhập để đánh giá</h3>
                            <p>Chia sẻ cảm nhận của bạn và giúp mọi người lựa chọn dễ dàng hơn.</p>
                        </div>
                        <a href="login">Đăng nhập <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="review-list-panel">
        <c:choose>
            <c:when test="${empty reviews}">
                <div class="review-empty">
                    <span><i class="fa-regular fa-comments"></i></span>
                    <h3>Chưa có đánh giá nào</h3>
                    <p>Hãy là người đầu tiên chia sẻ trải nghiệm về sản phẩm này.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="review-list-toolbar">
                    <div>
                        <h3>Nhận xét từ khách hàng</h3>
                        <p>Những chia sẻ mới nhất về sản phẩm</p>
                    </div>
                    <div class="review-filters" role="group" aria-label="Lọc đánh giá">
                        <button type="button" class="review-filter is-active" data-review-filter="all">Tất cả <span>${p.reviewCount}</span></button>
                        <c:forEach begin="1" end="5" var="position">
                            <c:set var="starValue" value="${6 - position}" />
                            <button type="button" class="review-filter" data-review-filter="${starValue}">${starValue} sao <span>${ratingCounts[starValue]}</span></button>
                        </c:forEach>
                        <button type="button" class="review-filter" data-review-filter="comment">Có nhận xét <span>${reviewsWithComment}</span></button>
                    </div>
                </div>

                <div class="review-list" aria-live="polite">
                    <c:forEach var="review" items="${reviews}">
                        <fmt:formatDate value="${review.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ssXXX" var="reviewDateIso" />
                        <article class="review-item" data-review-rating="${review.rating}" data-has-comment="${not empty review.comment}">
                            <div class="review-avatar" aria-hidden="true">
                                <c:out value="${fn:substring(review.userDisplayName, 0, 1)}" />
                            </div>
                            <div class="review-body">
                                <div class="review-meta">
                                    <div class="review-author">
                                        <strong><c:out value="${review.userDisplayName}" /></strong>
                                        <c:if test="${not empty sessionScope.user && review.userId == sessionScope.user.uid}">
                                            <span class="review-own-badge"><i class="fa-solid fa-check"></i> Của bạn</span>
                                        </c:if>
                                    </div>
                                    <time datetime="${reviewDateIso}"><i class="fa-regular fa-clock"></i> <fmt:formatDate value="${review.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></time>
                                </div>
                                <div class="review-rating-line">
                                    <div class="review-item-stars" aria-label="${review.rating} trên 5 sao">
                                        <c:forEach begin="1" end="5" var="star">
                                            <i class="${review.rating >= star ? 'fa-solid' : 'fa-regular'} fa-star" aria-hidden="true"></i>
                                        </c:forEach>
                                    </div>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${review.rating == 5}">Tuyệt vời</c:when>
                                            <c:when test="${review.rating == 4}">Hài lòng</c:when>
                                            <c:when test="${review.rating == 3}">Bình thường</c:when>
                                            <c:when test="${review.rating == 2}">Chưa hài lòng</c:when>
                                            <c:otherwise>Không hài lòng</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty review.comment}">
                                        <p class="review-comment"><c:out value="${review.comment}" /></p>
                                    </c:when>
                                    <c:otherwise><p class="review-no-comment">Khách hàng chỉ chấm sao, không để lại nhận xét.</p></c:otherwise>
                                </c:choose>
                            </div>
                        </article>
                    </c:forEach>
                    <div class="review-filter-empty" hidden>
                        <i class="fa-solid fa-filter-circle-xmark"></i>
                        <p>Chưa có đánh giá phù hợp với bộ lọc này.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<div id="v-data" style="display:none;">
    <c:forEach var="v" items="${p.variants}">
        <div class="v-item" data-s="${v.size}" data-c="${v.color}" data-q="${v.stockQuantity}"></div>
    </c:forEach>
</div>

<script>
    /* IMAGE SLIDER */
    (function() {
        const imgData  = document.getElementById('img-data');
        const track    = document.getElementById('sliderTrack');
        const dotsWrap = document.getElementById('sliderDots');
        const counter  = document.getElementById('slideCounter');
        const thumbGal = document.getElementById('thumbGallery');
        const images   = [];
        function addImage(src) {
            const normalized = (src || '').trim();
            if (normalized) images.push(normalized);
        }
        addImage(imgData.dataset.main);
        imgData.querySelectorAll('.extra-img').forEach(el => addImage(el.textContent));
        if (images.length === 0) return;
        let current = 0;
        images.forEach((src, i) => {
            const slide = document.createElement('div'); slide.className = 'slide';
            const img = document.createElement('img'); img.src = src; img.alt = 'Product image ' + (i + 1); img.draggable = false;
            slide.appendChild(img); track.appendChild(slide);
        });
        images.forEach((_, i) => {
            const dot = document.createElement('button');
            dot.type = 'button';
            dot.className = 'dot' + (i === 0 ? ' active' : '');
            dot.setAttribute('aria-label', 'Xem ảnh ' + (i + 1));
            dot.addEventListener('click', () => goTo(i)); dotsWrap.appendChild(dot);
        });
        images.forEach((src, i) => {
            const thumb = document.createElement('img');
            thumb.className = 'thumb' + (i === 0 ? ' active-thumb' : '');
            thumb.src = src; thumb.alt = 'Thumbnail ' + (i + 1);
            thumb.addEventListener('click', () => goTo(i)); thumbGal.appendChild(thumb);
        });
        if (images.length <= 1) {
            document.getElementById('btnPrev').style.display = 'none';
            document.getElementById('btnNext').style.display = 'none';
            dotsWrap.style.display = 'none'; counter.style.display = 'none';
        }
        function goTo(idx) {
            current = (idx + images.length) % images.length;
            // Dùng phép nối chuỗi để JSP không hiểu nhầm biểu thức JavaScript là JSP EL.
            track.style.transform = 'translateX(-' + (current * 100) + '%)';
            dotsWrap.querySelectorAll('.dot').forEach((d, i) => d.classList.toggle('active', i === current));
            thumbGal.querySelectorAll('.thumb').forEach((t, i) => t.classList.toggle('active-thumb', i === current));
            const activeThumb = thumbGal.querySelectorAll('.thumb')[current];
            if (activeThumb) activeThumb.scrollIntoView({ behavior: 'smooth', inline: 'nearest', block: 'nearest' });
            counter.textContent = (current + 1) + ' / ' + images.length;
        }
        document.getElementById('btnPrev').addEventListener('click', () => goTo(current - 1));
        document.getElementById('btnNext').addEventListener('click', () => goTo(current + 1));
        const container = document.getElementById('sliderContainer');
        let gestureStartX = null;
        container.addEventListener('pointerdown', e => {
            if (e.target.closest('button') || (e.pointerType === 'mouse' && e.button !== 0)) return;
            gestureStartX = e.clientX;
            container.classList.add('is-dragging');
            container.setPointerCapture(e.pointerId);
        });
        container.addEventListener('pointerup', e => {
            if (gestureStartX === null) return;
            const dx = e.clientX - gestureStartX;
            gestureStartX = null;
            container.classList.remove('is-dragging');
            if (Math.abs(dx) > 40) goTo(dx < 0 ? current + 1 : current - 1);
        });
        container.addEventListener('pointercancel', () => {
            gestureStartX = null;
            container.classList.remove('is-dragging');
        });
        container.addEventListener('keydown', e => {
            if (e.key === 'ArrowLeft') { e.preventDefault(); goTo(current - 1); }
            if (e.key === 'ArrowRight') { e.preventDefault(); goTo(current + 1); }
        });
        counter.textContent = '1 / ' + images.length;
    })();

    /* VARIANTS */
    (function() {
        const items = document.querySelectorAll('.v-item');
        if (items.length === 0) return;

        const sizes = [];
        const colors = [];
        const variantMap = new Map();
        function normalizeValue(value) {
            const normalized = (value || '').trim();
            return normalized.toLowerCase() === 'null' ? '' : normalized;
        }
        function variantKey(size, color) {
            return size + '\u001f' + color;
        }
        items.forEach(i => {
            const size = normalizeValue(i.dataset.s);
            const color = normalizeValue(i.dataset.c);
            const quantity = Math.max(0, parseInt(i.dataset.q, 10) || 0);
            const key = variantKey(size, color);
            if (variantMap.has(key)) {
                variantMap.get(key).q += quantity;
            } else {
                variantMap.set(key, { s: size, c: color, q: quantity });
            }
            if (!sizes.includes(size)) sizes.push(size);
            if (!colors.includes(color)) colors.push(color);
        });
        const variants = Array.from(variantMap.values());
        const hasAnyStock = variants.some(v => v.q > 0);
        const colorMap = { 'đen':'#1a1a1a','den':'#1a1a1a','black':'#1a1a1a','trắng':'#f0f0f0','trang':'#f0f0f0','white':'#f0f0f0','đỏ':'#e74c3c','do':'#e74c3c','red':'#e74c3c','xanh':'#2980b9','blue':'#2980b9','xanh lá':'#27ae60','green':'#27ae60','vàng':'#f1c40f','yellow':'#f1c40f','hồng':'#e91e8c','pink':'#e91e8c','xám':'#95a5a6','gray':'#95a5a6','grey':'#95a5a6','nâu':'#8B4513','brown':'#8B4513','cam':'#e67e22','orange':'#e67e22','tím':'#8e44ad','purple':'#8e44ad','be':'#f5f5dc','beige':'#f5f5dc' };

        function displayValue(value) {
            return value ? value : 'Mặc định';
        }
        function getColor(name) {
            return name ? (colorMap[name.toLowerCase()] || '#bdc3c7') : '#ccc';
        }
        function getSelected(name) {
            const selected = document.querySelector('input[name="' + name + '"]:checked');
            return selected ? selected.value : null;
        }
        function getVariant(size, color) {
            return variantMap.get(variantKey(size, color));
        }
        function hasStock(size, color) {
            const variant = getVariant(size, color);
            return Boolean(variant && variant.q > 0);
        }
        const sizeInputs = [];
        const szBox = document.getElementById('size-options');
        szBox.innerHTML = '';
        sizes.forEach((size, index) => {
            const id = 'sz-option-' + index;
            const input = document.createElement('input');
            input.type = 'radio';
            input.id = id;
            input.name = 'size';
            input.value = size;
            input.className = 'var-radio';
            input.required = true;

            const label = document.createElement('label');
            label.htmlFor = id;
            label.className = 'size-label';
            label.textContent = displayValue(size);
            sizeInputs.push(input);
            szBox.appendChild(input);
            szBox.appendChild(label);
        });

        const colorInputs = [];
        const clBox = document.getElementById('color-options');
        clBox.innerHTML = '';
        colors.forEach((color, index) => {
            const id = 'cl-option-' + index;
            const input = document.createElement('input');
            input.type = 'radio';
            input.id = id;
            input.name = 'color';
            input.value = color;
            input.className = 'var-radio';
            input.required = true;

            const wrap = document.createElement('label');
            wrap.htmlFor = id;
            wrap.className = 'color-swatch-wrap';
            const swatch = document.createElement('span');
            swatch.className = 'color-swatch';
            swatch.style.background = getColor(color);
            if (getColor(color) === '#f0f0f0') swatch.classList.add('light-color');
            const name = document.createElement('span');
            name.className = 'color-swatch-name';
            name.textContent = displayValue(color);
            wrap.appendChild(swatch);
            wrap.appendChild(name);
            colorInputs.push(input);
            clBox.appendChild(input);
            clBox.appendChild(wrap);
        });

        const form = document.getElementById('productForm');
        const qty = document.getElementById('qty-input');
        const btnAdd = document.getElementById('btn-add');
        const btnBuy = document.getElementById('btn-buy');
        const stockText = document.getElementById('stock-display');
        const stockDot = document.getElementById('stock-dot');

        function setActionsEnabled(enabled, availableStock) {
            qty.disabled = !enabled;
            qty.min = 1;
            qty.max = enabled ? availableStock : 1;
            qty.value = enabled ? Math.min(Math.max(parseInt(qty.value, 10) || 1, 1), availableStock) : (hasAnyStock ? 1 : 0);
            [btnAdd, btnBuy].forEach(button => {
                button.disabled = !enabled;
                button.classList.toggle('btn-disabled', !enabled);
            });
        }

        function updateStock() {
            const selectedSize = getSelected('size');
            const selectedColor = getSelected('color');
            document.getElementById('sz-display').textContent = selectedSize === null ? 'Chưa chọn' : displayValue(selectedSize);
            document.getElementById('cl-display').textContent = selectedColor === null ? 'Chưa chọn' : displayValue(selectedColor);

            if (!hasAnyStock) {
                stockText.textContent = 'Hết hàng';
                stockDot.className = 'stock-dot outstock';
                setActionsEnabled(false, 0);
                return;
            }
            if (selectedSize === null || selectedColor === null) {
                stockText.textContent = 'Vui lòng chọn Size và Màu';
                stockDot.className = 'stock-dot pending';
                setActionsEnabled(false, 0);
                return;
            }

            const match = getVariant(selectedSize, selectedColor);
            if (match && match.q > 0) {
                stockText.textContent = 'Còn hàng (' + match.q + ')';
                stockDot.className = 'stock-dot instock';
                setActionsEnabled(true, match.q);
            } else {
                stockText.textContent = 'Hết hàng';
                stockDot.className = 'stock-dot outstock';
                setActionsEnabled(false, 0);
            }
        }

        [...sizeInputs, ...colorInputs].forEach(input => {
            input.addEventListener('change', () => {
                updateStock();
            });
        });

        qty.addEventListener('change', () => {
            const max = parseInt(qty.max, 10) || 1;
            qty.value = Math.min(Math.max(parseInt(qty.value, 10) || 1, 1), max);
        });
        form.addEventListener('submit', event => {
            const selectedSize = getSelected('size');
            const selectedColor = getSelected('color');
            if (selectedSize === null || selectedColor === null || !hasStock(selectedSize, selectedColor)) {
                event.preventDefault();
                stockText.textContent = selectedSize === null || selectedColor === null
                    ? 'Vui lòng chọn Size và Màu'
                    : 'Hết hàng';
                stockDot.className = selectedSize === null || selectedColor === null ? 'stock-dot pending' : 'stock-dot outstock';
            }
        });

        const firstAvailable = variants.find(variant => variant.q > 0);
        if (firstAvailable) {
            const firstSize = sizeInputs.find(input => input.value === firstAvailable.s);
            const firstColor = colorInputs.find(input => input.value === firstAvailable.c);
            if (firstSize) firstSize.checked = true;
            if (firstColor) firstColor.checked = true;
        }
        updateStock();
    })();

    /* REVIEW FILTERS */
    (function() {
        const filters = Array.from(document.querySelectorAll('.review-filter'));
        const reviewItems = Array.from(document.querySelectorAll('.review-item[data-review-rating]'));
        const emptyState = document.querySelector('.review-filter-empty');
        if (filters.length === 0 || reviewItems.length === 0) return;

        function applyFilter(activeButton) {
            const filter = activeButton.dataset.reviewFilter;
            let visibleCount = 0;

            filters.forEach(button => {
                const isActive = button === activeButton;
                button.classList.toggle('is-active', isActive);
                button.setAttribute('aria-pressed', String(isActive));
            });

            reviewItems.forEach(item => {
                const matches = filter === 'all'
                    || (filter === 'comment' && item.dataset.hasComment === 'true')
                    || item.dataset.reviewRating === filter;
                item.hidden = !matches;
                if (matches) visibleCount++;
            });

            if (emptyState) emptyState.hidden = visibleCount !== 0;
        }

        filters.forEach(button => button.addEventListener('click', () => applyFilter(button)));
        applyFilter(filters[0]);
    })();
</script>

<jsp:include page="footer.jsp" />
</body>
</html>
