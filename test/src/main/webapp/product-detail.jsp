<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title>${p.pdescription} | Fashion Store</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/user/product-detail.css" />
</head>
<body>
<header>
    <jsp:include page="header.jsp"><jsp:param name="page" value="index"/></jsp:include>
</header>

<%-- CSS sau header để load sau Header.css --%>
<link rel="stylesheet" href="CSS/user/product-detail.css" />

<div class="back-nav">
    <a href="javascript:history.back()" class="btn-back">
        <i class="fa-solid fa-arrow-left-long"></i>
        <fmt:message key="product.back" />
    </a>
</div>

<div class="detail-wrapper">

    <!-- LEFT: Image Slider -->
    <div class="detail-left">
        <div class="slider-container" id="sliderContainer">
            <div class="slider-track" id="sliderTrack"></div>
            <button class="slider-btn prev" id="btnPrev" aria-label="Previous">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <button class="slider-btn next" id="btnNext" aria-label="Next">
                <i class="fa-solid fa-chevron-right"></i>
            </button>
            <div class="slider-dots" id="sliderDots"></div>
            <div class="slide-counter" id="slideCounter">1 / 1</div>
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
        const mainSrc  = imgData.dataset.main;
        if (mainSrc) images.push(mainSrc);
        imgData.querySelectorAll('.extra-img').forEach(el => { const s = el.textContent.trim(); if (s) images.push(s); });
        if (images.length === 0) return;
        let current = 0;
        images.forEach((src, i) => {
            const slide = document.createElement('div'); slide.className = 'slide';
            const img = document.createElement('img'); img.src = src; img.alt = 'Product image ' + (i + 1); img.draggable = false;
            slide.appendChild(img); track.appendChild(slide);
        });
        images.forEach((_, i) => {
            const dot = document.createElement('button');
            dot.className = 'dot' + (i === 0 ? ' active' : '');
            dot.setAttribute('aria-label', 'Slide ' + (i + 1));
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
            track.style.transform = `translateX(-${current * 100}%)`;
            dotsWrap.querySelectorAll('.dot').forEach((d, i) => d.classList.toggle('active', i === current));
            thumbGal.querySelectorAll('.thumb').forEach((t, i) => t.classList.toggle('active-thumb', i === current));
            const activeThumb = thumbGal.querySelectorAll('.thumb')[current];
            if (activeThumb) activeThumb.scrollIntoView({ behavior: 'smooth', inline: 'nearest', block: 'nearest' });
            counter.textContent = (current + 1) + ' / ' + images.length;
        }
        document.getElementById('btnPrev').addEventListener('click', () => goTo(current - 1));
        document.getElementById('btnNext').addEventListener('click', () => goTo(current + 1));
        let touchStartX = 0;
        const container = document.getElementById('sliderContainer');
        container.addEventListener('touchstart', e => { touchStartX = e.changedTouches[0].clientX; }, { passive: true });
        container.addEventListener('touchend', e => { const dx = e.changedTouches[0].clientX - touchStartX; if (Math.abs(dx) > 40) goTo(dx < 0 ? current + 1 : current - 1); }, { passive: true });
        document.addEventListener('keydown', e => { if (e.key === 'ArrowLeft') goTo(current - 1); if (e.key === 'ArrowRight') goTo(current + 1); });
        counter.textContent = '1 / ' + images.length;
    })();

    /* VARIANTS */
    (function() {
        const items = document.querySelectorAll('.v-item');
        if (items.length === 0) return;
        const sizes = new Set(), colors = new Set(), variants = [];
        items.forEach(i => { if (i.dataset.s) sizes.add(i.dataset.s); if (i.dataset.c) colors.add(i.dataset.c); variants.push({ s: i.dataset.s, c: i.dataset.c, q: parseInt(i.dataset.q) }); });
        const colorMap = { 'đen':'#1a1a1a','den':'#1a1a1a','black':'#1a1a1a','trắng':'#f0f0f0','trang':'#f0f0f0','white':'#f0f0f0','đỏ':'#e74c3c','do':'#e74c3c','red':'#e74c3c','xanh':'#2980b9','blue':'#2980b9','xanh lá':'#27ae60','green':'#27ae60','vàng':'#f1c40f','yellow':'#f1c40f','hồng':'#e91e8c','pink':'#e91e8c','xám':'#95a5a6','gray':'#95a5a6','grey':'#95a5a6','nâu':'#8B4513','brown':'#8B4513','cam':'#e67e22','orange':'#e67e22','tím':'#8e44ad','purple':'#8e44ad','be':'#f5f5dc','beige':'#f5f5dc' };
        function getColor(name) { if (!name || name === 'null') return '#ccc'; return colorMap[name.toLowerCase().trim()] || '#bdc3c7'; }
        const szBox = document.getElementById('size-options'); szBox.innerHTML = '';
        sizes.forEach(s => {
            const label = (s && s !== 'null') ? s : 'Mặc định'; const id = 'sz-' + s;
            const inp = document.createElement('input'); inp.type = 'radio'; inp.id = id; inp.name = 'size'; inp.value = s; inp.className = 'var-radio'; inp.required = true;
            const lbl = document.createElement('label'); lbl.htmlFor = id; lbl.className = 'size-label'; lbl.textContent = label;
            szBox.appendChild(inp); szBox.appendChild(lbl);
        });
        const clBox = document.getElementById('color-options'); clBox.innerHTML = '';
        colors.forEach(c => {
            const label = (c && c !== 'null') ? c : 'Mặc định'; const id = 'cl-' + c;
            const inp = document.createElement('input'); inp.type = 'radio'; inp.id = id; inp.name = 'color'; inp.value = c; inp.className = 'var-radio'; inp.required = true;
            const wrap = document.createElement('label'); wrap.htmlFor = id; wrap.className = 'color-swatch-wrap';
            const swatch = document.createElement('span'); swatch.className = 'color-swatch'; swatch.style.background = getColor(c);
            if (getColor(c) === '#f0f0f0') swatch.style.border = '2px solid #ccc';
            const nameEl = document.createElement('span'); nameEl.className = 'color-swatch-name'; nameEl.textContent = label;
            wrap.appendChild(swatch); wrap.appendChild(nameEl); clBox.appendChild(inp); clBox.appendChild(wrap);
        });
        function updateStock() {
            const selSz = document.querySelector('input[name="size"]:checked')?.value;
            const selCl = document.querySelector('input[name="color"]:checked')?.value;
            const btnA = document.getElementById('btn-add'); const btnB = document.getElementById('btn-buy');
            const qty = document.getElementById('qty-input'); const st = document.getElementById('stock-display'); const dot = document.getElementById('stock-dot');
            if (selSz && selCl) {
                const match = variants.find(v => v.s === selSz && v.c === selCl);
                if (match && match.q > 0) { st.textContent = 'Còn hàng (' + match.q + ')'; dot.className = 'stock-dot instock'; qty.max = match.q; qty.value = 1; qty.disabled = false; btnA.classList.remove('btn-disabled'); btnB.classList.remove('btn-disabled'); }
                else { st.textContent = 'Hết hàng / Không có phân loại này'; dot.className = 'stock-dot outstock'; qty.value = 0; qty.disabled = true; btnA.classList.add('btn-disabled'); btnB.classList.add('btn-disabled'); }
            } else { st.textContent = 'Vui lòng chọn Size & Màu'; dot.className = 'stock-dot pending'; }
        }
        document.querySelectorAll('.var-radio').forEach(r => {
            r.addEventListener('change', () => {
                if (r.name === 'size') document.getElementById('sz-display').textContent = (r.value && r.value !== 'null') ? r.value : 'Mặc định';
                if (r.name === 'color') document.getElementById('cl-display').textContent = (r.value && r.value !== 'null') ? r.value : 'Mặc định';
                updateStock();
            });
        });
        const dot = document.getElementById('stock-dot'); const st = document.getElementById('stock-display');
        if (st.textContent.includes('Còn hàng')) dot.className = 'stock-dot instock';
        else if (st.textContent.includes('Hết hàng')) dot.className = 'stock-dot outstock';
    })();
</script>

<jsp:include page="footer.jsp" />
</body>
</html>
