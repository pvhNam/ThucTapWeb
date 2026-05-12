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
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Montserrat', sans-serif; background: #f8f7f4; color: #1a1a1a; }

        /* ── Back nav ── */
        .back-nav { padding: 18px 60px; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 8px;
            font-size: 0.82rem; font-weight: 600; letter-spacing: 0.08em;
            text-transform: uppercase; text-decoration: none; color: #555;
            transition: color 0.2s;
        }
        .btn-back:hover { color: #1a1a1a; }

        /* ── Layout ── */
        .detail-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 40px 80px;
        }

        /* ════════════════════════════
           LEFT – IMAGE SLIDER
        ════════════════════════════ */
        .detail-left { position: relative; }

        .slider-container {
            position: relative;
            width: 100%;
            aspect-ratio: 1 / 1;
            border-radius: 16px;
            overflow: hidden;
            background: #eee;
            box-shadow: 0 8px 40px rgba(0,0,0,0.10);
        }

        /* Track holds all slides side by side */
        .slider-track {
            display: flex;
            height: 100%;
            transition: transform 0.45s cubic-bezier(0.4,0,0.2,1);
        }

        .slide {
            min-width: 100%;
            height: 100%;
            flex-shrink: 0;
        }
        .slide img {
            width: 100%; height: 100%;
            object-fit: cover;
            display: block;
            user-select: none;
            -webkit-user-drag: none;
        }

        /* Arrow buttons */
        .slider-btn {
            position: absolute; top: 50%; transform: translateY(-50%);
            width: 40px; height: 40px;
            background: rgba(255,255,255,0.92);
            border: none; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; z-index: 10;
            box-shadow: 0 2px 12px rgba(0,0,0,0.15);
            transition: background 0.2s, transform 0.2s;
            font-size: 0.85rem; color: #1a1a1a;
        }
        .slider-btn:hover { background: #1a1a1a; color: #fff; transform: translateY(-50%) scale(1.08); }
        .slider-btn.prev { left: 12px; }
        .slider-btn.next { right: 12px; }

        /* Dot indicators */
        .slider-dots {
            position: absolute; bottom: 14px; left: 50%; transform: translateX(-50%);
            display: flex; gap: 6px; z-index: 10;
        }
        .dot {
            width: 7px; height: 7px; border-radius: 50%;
            background: rgba(255,255,255,0.5); cursor: pointer;
            transition: background 0.25s, transform 0.25s;
            border: none;
        }
        .dot.active { background: #fff; transform: scale(1.4); }

        /* Slide counter */
        .slide-counter {
            position: absolute; top: 12px; right: 14px;
            background: rgba(0,0,0,0.45); color: #fff;
            font-size: 0.72rem; font-weight: 600; letter-spacing: 0.05em;
            padding: 4px 10px; border-radius: 20px; z-index: 10;
        }

        /* ── Thumbnail strip ── */
        .thumbnail-gallery {
            display: flex; gap: 10px;
            margin-top: 14px;
            overflow-x: auto;
            padding-bottom: 6px;
            scroll-behavior: smooth;
            -webkit-overflow-scrolling: touch;
        }
        .thumbnail-gallery::-webkit-scrollbar { height: 4px; }
        .thumbnail-gallery::-webkit-scrollbar-thumb { background: #ccc; border-radius: 4px; }

        .thumb {
            width: 68px; height: 68px;
            object-fit: cover; border-radius: 8px;
            cursor: pointer; flex-shrink: 0;
            border: 2.5px solid transparent;
            opacity: 0.55; transition: opacity 0.2s, border-color 0.2s;
        }
        .thumb:hover { opacity: 0.85; }
        .thumb.active-thumb { opacity: 1; border-color: #1a1a1a; }

        /* ════════════════════════════
           RIGHT – PRODUCT INFO
        ════════════════════════════ */
        .detail-right { padding-top: 10px; }

        .p-cat {
            font-size: 0.75rem; font-weight: 600; letter-spacing: 0.12em;
            text-transform: uppercase; color: #999;
        }

        .p-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem; line-height: 1.25;
            margin: 10px 0 16px;
        }

        .p-price {
            font-size: 1.55rem; font-weight: 700;
            color: #1a1a1a; margin-bottom: 28px;
        }

        /* ── Variant sections ── */
        .variant-box { margin-bottom: 22px; }

        .variant-title {
            font-size: 0.78rem; font-weight: 700;
            letter-spacing: 0.1em; text-transform: uppercase;
            color: #888; margin-bottom: 12px;
        }
        .variant-title span.selected-val {
            color: #1a1a1a; font-weight: 600; font-size: 0.85rem;
            text-transform: none; letter-spacing: 0;
        }

        /* SIZE buttons */
        .var-radio { display: none; }

        .size-label {
            display: inline-flex; align-items: center; justify-content: center;
            width: 52px; height: 44px;
            border: 1.5px solid #ddd; border-radius: 8px;
            cursor: pointer; margin-right: 8px; margin-bottom: 8px;
            font-size: 0.82rem; font-weight: 600;
            transition: all 0.2s; background: #fff; color: #333;
        }
        .size-label:hover { border-color: #1a1a1a; }
        .var-radio:checked + .size-label {
            background: #1a1a1a; color: #fff; border-color: #1a1a1a;
        }

        /* COLOR swatches */
        .color-swatch-wrap {
            display: inline-flex; align-items: center;
            margin-right: 10px; margin-bottom: 8px;
            flex-direction: column; gap: 4px;
        }
        .color-swatch {
            width: 34px; height: 34px; border-radius: 50%;
            cursor: pointer; border: 2.5px solid transparent;
            transition: transform 0.2s, border-color 0.2s;
            position: relative;
        }
        .color-swatch:hover { transform: scale(1.12); }
        .var-radio:checked + .color-swatch {
            border-color: #1a1a1a;
            box-shadow: 0 0 0 3px rgba(0,0,0,0.12);
        }
        .color-swatch-name {
            font-size: 0.65rem; font-weight: 600;
            letter-spacing: 0.04em; color: #888; text-align: center;
        }

        /* ── Stock status ── */
        .stock-wrap { display: flex; align-items: center; gap: 8px; margin-bottom: 28px; }
        .stock-dot {
            width: 8px; height: 8px; border-radius: 50%;
        }
        .stock-dot.instock { background: #27ae60; }
        .stock-dot.outstock { background: #e74c3c; }
        .stock-dot.pending { background: #f39c12; }
        #stock-display { font-size: 0.85rem; font-weight: 600; }

        /* ── Actions ── */
        .action-row {
            display: flex; gap: 12px; align-items: center; margin-top: 8px;
        }

        .qty-input {
            width: 64px; height: 52px; text-align: center;
            border: 1.5px solid #ddd; border-radius: 10px;
            font-size: 1rem; font-weight: 700;
            background: #fff; color: #1a1a1a;
            -moz-appearance: textfield;
        }
        .qty-input::-webkit-outer-spin-button,
        .qty-input::-webkit-inner-spin-button { -webkit-appearance: none; }

        .btn-add-cart-detail {
            flex: 1; height: 52px;
            background: #1a1a1a; color: #fff;
            border: none; border-radius: 10px;
            font-family: 'Montserrat', sans-serif;
            font-size: 0.82rem; font-weight: 700; letter-spacing: 0.1em;
            text-transform: uppercase; cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-add-cart-detail:hover { background: #333; transform: translateY(-1px); }

        .btn-buy-now {
            flex: 1; height: 52px;
            background: #27ae60; color: #fff;
            border: none; border-radius: 10px;
            font-family: 'Montserrat', sans-serif;
            font-size: 0.82rem; font-weight: 700; letter-spacing: 0.1em;
            text-transform: uppercase; cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-buy-now:hover { background: #219a55; transform: translateY(-1px); }

        .btn-disabled { opacity: 0.4; pointer-events: none !important; cursor: not-allowed !important; }

        /* ── Description ── */
        .p-desc {
            font-size: 0.87rem; line-height: 1.7; color: #666;
            border-top: 1px solid #eee; padding-top: 24px; margin-top: 28px;
        }

        /* ── Responsive ── */
        @media (max-width: 860px) {
            .detail-wrapper { grid-template-columns: 1fr; gap: 30px; padding: 0 20px 60px; }
            .back-nav { padding: 14px 20px; }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="header.jsp"><jsp:param name="page" value="index"/></jsp:include>
</header>

<div class="back-nav">
    <a href="javascript:history.back()" class="btn-back">
        <i class="fa-solid fa-arrow-left-long"></i>
        <fmt:message key="product.back" />
    </a>
</div>

<div class="detail-wrapper">

    <!-- ══ LEFT: Image Slider ══ -->
    <div class="detail-left">
        <div class="slider-container" id="sliderContainer">
            <div class="slider-track" id="sliderTrack">
                <%-- Slides rendered by JS from the image list --%>
            </div>

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

        <%-- Hidden data for JS --%>
        <div id="img-data" style="display:none"
             data-main="${not empty p.image ? p.image : 'img/no-image.png'}">
            <c:if test="${not empty p.extraImages}">
                <c:forEach var="img" items="${p.extraImages}">
                    <span class="extra-img">${img}</span>
                </c:forEach>
            </c:if>
        </div>
    </div>

    <!-- ══ RIGHT: Product Info ══ -->
    <div class="detail-right">
        <span class="p-cat"><fmt:message key="product.code" />: #${p.pid}</span>
        <h1 class="p-title">${p.pdescription}</h1>
        <div class="p-price"><fmt:formatNumber value="${p.price}" pattern="#,### 'VNĐ'"/></div>

        <form method="post" id="productForm" style="display:block;">
            <input type="hidden" name="pid" value="${p.pid}">

            <!-- SIZE -->
            <div class="variant-box">
                <div class="variant-title">
                    Kích thước (Size):
                    <span class="selected-val" id="sz-display"></span>
                </div>
                <div id="size-options">
                    <c:choose>
                        <c:when test="${not empty p.variants}">
                            <%-- filled by JS --%>
                        </c:when>
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
                    Màu sắc (Color):
                    <span class="selected-val" id="cl-display"></span>
                </div>
                <div id="color-options">
                    <c:choose>
                        <c:when test="${not empty p.variants}">
                            <%-- filled by JS --%>
                        </c:when>
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

        <p class="p-desc">
            ${p.pdescription}. <fmt:message key="product.desc_default" />
        </p>
    </div>
</div>

<!-- Hidden variant data -->
<div id="v-data" style="display:none;">
    <c:forEach var="v" items="${p.variants}">
        <div class="v-item" data-s="${v.size}" data-c="${v.color}" data-q="${v.stockQuantity}"></div>
    </c:forEach>
</div>

<script>
    /* ══════════════════════════════════════
       1. IMAGE SLIDER
    ══════════════════════════════════════ */
    (function() {
        const imgData  = document.getElementById('img-data');
        const track    = document.getElementById('sliderTrack');
        const dotsWrap = document.getElementById('sliderDots');
        const counter  = document.getElementById('slideCounter');
        const thumbGal = document.getElementById('thumbGallery');

        // Collect all images
        const images = [];
        const mainSrc = imgData.dataset.main;
        if (mainSrc) images.push(mainSrc);
        imgData.querySelectorAll('.extra-img').forEach(el => {
            const s = el.textContent.trim();
            if (s) images.push(s);
        });

        if (images.length === 0) return;

        let current = 0;

        // Build slides
        images.forEach((src, i) => {
            const slide = document.createElement('div');
            slide.className = 'slide';
            const img = document.createElement('img');
            img.src = src;
            img.alt = 'Product image ' + (i + 1);
            img.draggable = false;
            slide.appendChild(img);
            track.appendChild(slide);
        });

        // Build dots
        images.forEach((_, i) => {
            const dot = document.createElement('button');
            dot.className = 'dot' + (i === 0 ? ' active' : '');
            dot.setAttribute('aria-label', 'Slide ' + (i + 1));
            dot.addEventListener('click', () => goTo(i));
            dotsWrap.appendChild(dot);
        });

        // Build thumbnails
        images.forEach((src, i) => {
            const thumb = document.createElement('img');
            thumb.className = 'thumb' + (i === 0 ? ' active-thumb' : '');
            thumb.src = src;
            thumb.alt = 'Thumbnail ' + (i + 1);
            thumb.addEventListener('click', () => goTo(i));
            thumbGal.appendChild(thumb);
        });

        // Hide arrows if only 1 image
        if (images.length <= 1) {
            document.getElementById('btnPrev').style.display = 'none';
            document.getElementById('btnNext').style.display = 'none';
            dotsWrap.style.display = 'none';
            counter.style.display = 'none';
        }

        function goTo(idx) {
            current = (idx + images.length) % images.length;
            track.style.transform = `translateX(-${current * 100}%)`;

            // Update dots
            dotsWrap.querySelectorAll('.dot').forEach((d, i) => d.classList.toggle('active', i === current));

            // Update thumbs
            thumbGal.querySelectorAll('.thumb').forEach((t, i) => t.classList.toggle('active-thumb', i === current));

            // Scroll active thumb into view
            const activeThumb = thumbGal.querySelectorAll('.thumb')[current];
            if (activeThumb) activeThumb.scrollIntoView({ behavior: 'smooth', inline: 'nearest', block: 'nearest' });

            counter.textContent = (current + 1) + ' / ' + images.length;
        }

        document.getElementById('btnPrev').addEventListener('click', () => goTo(current - 1));
        document.getElementById('btnNext').addEventListener('click', () => goTo(current + 1));

        // Touch/swipe support
        let touchStartX = 0;
        const container = document.getElementById('sliderContainer');
        container.addEventListener('touchstart', e => { touchStartX = e.changedTouches[0].clientX; }, { passive: true });
        container.addEventListener('touchend', e => {
            const dx = e.changedTouches[0].clientX - touchStartX;
            if (Math.abs(dx) > 40) goTo(dx < 0 ? current + 1 : current - 1);
        }, { passive: true });

        // Keyboard navigation
        document.addEventListener('keydown', e => {
            if (e.key === 'ArrowLeft') goTo(current - 1);
            if (e.key === 'ArrowRight') goTo(current + 1);
        });

        // Init counter
        counter.textContent = '1 / ' + images.length;
    })();


    /* ══════════════════════════════════════
       2. VARIANTS (SIZE & COLOR)
    ══════════════════════════════════════ */
    (function() {
        const items = document.querySelectorAll('.v-item');
        if (items.length === 0) return;

        // Collect variant data
        const sizes = new Set(), colors = new Set(), variants = [];
        items.forEach(i => {
            if (i.dataset.s) sizes.add(i.dataset.s);
            if (i.dataset.c) colors.add(i.dataset.c);
            variants.push({ s: i.dataset.s, c: i.dataset.c, q: parseInt(i.dataset.q) });
        });

        // Color name → CSS color map (expand as needed)
        const colorMap = {
            'đen': '#1a1a1a', 'den': '#1a1a1a', 'black': '#1a1a1a',
            'trắng': '#f0f0f0', 'trang': '#f0f0f0', 'white': '#f0f0f0',
            'đỏ': '#e74c3c', 'do': '#e74c3c', 'red': '#e74c3c',
            'xanh': '#2980b9', 'blue': '#2980b9',
            'xanh lá': '#27ae60', 'green': '#27ae60',
            'vàng': '#f1c40f', 'yellow': '#f1c40f',
            'hồng': '#e91e8c', 'pink': '#e91e8c',
            'xám': '#95a5a6', 'gray': '#95a5a6', 'grey': '#95a5a6',
            'nâu': '#8B4513', 'brown': '#8B4513',
            'cam': '#e67e22', 'orange': '#e67e22',
            'tím': '#8e44ad', 'purple': '#8e44ad',
            'be': '#f5f5dc', 'beige': '#f5f5dc',
        };

        function getColor(name) {
            if (!name || name === 'null') return '#ccc';
            const key = name.toLowerCase().trim();
            return colorMap[key] || '#bdc3c7';
        }

        // Render SIZE options
        const szBox = document.getElementById('size-options');
        szBox.innerHTML = '';
        sizes.forEach(s => {
            const label = (s && s !== 'null') ? s : 'Mặc định';
            const id = 'sz-' + s;
            const inp = document.createElement('input');
            inp.type = 'radio'; inp.id = id; inp.name = 'size'; inp.value = s;
            inp.className = 'var-radio'; inp.required = true;
            const lbl = document.createElement('label');
            lbl.htmlFor = id; lbl.className = 'size-label'; lbl.textContent = label;
            szBox.appendChild(inp); szBox.appendChild(lbl);
        });

        // Render COLOR options
        const clBox = document.getElementById('color-options');
        clBox.innerHTML = '';
        colors.forEach(c => {
            const label = (c && c !== 'null') ? c : 'Mặc định';
            const id = 'cl-' + c;
            const inp = document.createElement('input');
            inp.type = 'radio'; inp.id = id; inp.name = 'color'; inp.value = c;
            inp.className = 'var-radio'; inp.required = true;

            const wrap = document.createElement('label');
            wrap.htmlFor = id;
            wrap.className = 'color-swatch-wrap';

            const swatch = document.createElement('span');
            swatch.className = 'color-swatch';
            swatch.style.background = getColor(c);
            // White needs a visible border
            if (getColor(c) === '#f0f0f0') swatch.style.border = '2px solid #ccc';

            const nameEl = document.createElement('span');
            nameEl.className = 'color-swatch-name'; nameEl.textContent = label;

            wrap.appendChild(swatch); wrap.appendChild(nameEl);
            clBox.appendChild(inp); clBox.appendChild(wrap);
        });

        // Stock update logic
        function updateStock() {
            const selSz = document.querySelector('input[name="size"]:checked')?.value;
            const selCl = document.querySelector('input[name="color"]:checked')?.value;

            const btnA = document.getElementById('btn-add');
            const btnB = document.getElementById('btn-buy');
            const qty  = document.getElementById('qty-input');
            const st   = document.getElementById('stock-display');
            const dot  = document.getElementById('stock-dot');

            if (selSz && selCl) {
                const match = variants.find(v => v.s === selSz && v.c === selCl);
                if (match && match.q > 0) {
                    st.textContent = 'Còn hàng (' + match.q + ')';
                    dot.className = 'stock-dot instock';
                    qty.max = match.q; qty.value = 1; qty.disabled = false;
                    btnA.classList.remove('btn-disabled');
                    btnB.classList.remove('btn-disabled');
                } else {
                    st.textContent = 'Hết hàng / Không có phân loại này';
                    dot.className = 'stock-dot outstock';
                    qty.value = 0; qty.disabled = true;
                    btnA.classList.add('btn-disabled');
                    btnB.classList.add('btn-disabled');
                }
            } else {
                st.textContent = 'Vui lòng chọn Size & Màu';
                dot.className = 'stock-dot pending';
            }
        }

        document.querySelectorAll('.var-radio').forEach(r => {
            r.addEventListener('change', () => {
                if (r.name === 'size') {
                    const v = (r.value && r.value !== 'null') ? r.value : 'Mặc định';
                    document.getElementById('sz-display').textContent = v;
                }
                if (r.name === 'color') {
                    const v = (r.value && r.value !== 'null') ? r.value : 'Mặc định';
                    document.getElementById('cl-display').textContent = v;
                }
                updateStock();
            });
        });

        // Init stock indicator for no-variant products
        const dot = document.getElementById('stock-dot');
        const st  = document.getElementById('stock-display');
        if (st.textContent.includes('Còn hàng')) dot.className = 'stock-dot instock';
        else if (st.textContent.includes('Hết hàng')) dot.className = 'stock-dot outstock';
    })();
</script>

<jsp:include page="footer.jsp" />
</body>
</html>
