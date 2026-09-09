<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${empty themes}"><c:redirect url="/collection" /></c:if>
<c:set var="en" value="${sessionScope.lang == 'en'}" />
<fmt:setLocale value="${en ? 'en' : 'vi'}" />
<fmt:setBundle basename="resources.messages" />
<!DOCTYPE html>
<html lang="${en ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>${en ? 'Collections' : 'Bộ sưu tập'} | Nam Thanh</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/user/collection.css?v=20260909.2">
</head>
<body class="ym-user-page ym-collection-page">
<jsp:include page="header.jsp"><jsp:param name="page" value="collection" /></jsp:include>
<main class="edits-page">
    <div class="edits-breadcrumb"><a href="home">${en ? 'Home' : 'Trang chủ'}</a><span aria-hidden="true">/</span><span>${en ? 'Collections' : 'Bộ sưu tập'}</span></div>
    <section class="edits-hero" aria-labelledby="edits-title">
        <div class="edits-hero-copy">
            <span class="edits-eyebrow">NAM THANH — COLLECTIONS</span>
            <h1 id="edits-title">${en ? 'A season.' : 'Một mùa mới.'}<br><em>${en ? 'A signature.' : 'Một dấu ấn riêng.'}</em></h1>
            <p>${en ? 'Considered pieces for every season and every occasion. Discover the style that feels like you.' : 'Những lựa chọn chỉn chu cho từng mùa, từng khoảnh khắc. Khám phá phong cách mang dấu ấn của bạn.'}</p>
            <a class="edits-hero-link" href="#collection-themes">${en ? 'Discover the collections' : 'Khám phá bộ sưu tập'}<i class="fa-solid fa-arrow-down" aria-hidden="true"></i></a>
            <span class="edits-hero-note">THE ART OF EVERYDAY DRESSING</span>
        </div>
        <div class="edits-hero-visual"><img src="img/congso.jpg" alt="${en ? 'Tailored menswear by Nam Thanh' : 'Phong cách thời trang nam lịch lãm'}" fetchpriority="high"><div class="edits-visual-caption"><span>THE MODERN GENTLEMAN</span><span>NAM THANH / EDIT</span></div></div>
    </section>
    <div class="edits-section-label" id="collection-themes"><span>${en ? 'FIND YOUR INSPIRATION' : 'CẢM HỨNG CHO BẠN'}</span><span>01 — 05</span></div>
    <section class="edits-themes" aria-label="${en ? 'Choose a collection' : 'Chọn bộ sưu tập'}">
        <c:forEach var="theme" items="${themes}" varStatus="status">
            <a href="collection?category=${theme.slug}#collection-products" class="edit-theme edit-theme-${theme.slug} ${selectedCategory == theme.slug ? 'is-selected' : ''}" aria-current="${selectedCategory == theme.slug ? 'page' : 'false'}">
                <div class="edit-theme-top"><span>0${status.index + 1}</span><i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i></div>
                <div class="edit-theme-bottom">
                    <h2><c:out value="${en ? theme.nameEn : theme.nameVi}" /></h2>
                    <p><c:out value="${en ? theme.descriptionEn : theme.descriptionVi}" /></p>
                    <span class="edit-theme-count"><c:choose><c:when test="${collectionUnavailable}">—</c:when><c:when test="${collectionCounts[theme.slug] == 0}">${en ? 'Coming soon' : 'Sắp ra mắt'}</c:when><c:otherwise>${collectionCounts[theme.slug]} ${en ? 'pieces' : 'sản phẩm'}</c:otherwise></c:choose></span>
                </div>
            </a>
        </c:forEach>
    </section>
    <section id="collection-products" class="edits-products" aria-labelledby="edits-products-title">
        <div class="edits-products-heading"><div><span class="edits-eyebrow">THE SELECTION</span><h2 id="edits-products-title"><c:choose><c:when test="${empty selectedTheme}">${en ? 'Selected for you' : 'Dành riêng cho bạn'}</c:when><c:otherwise><c:out value="${en ? selectedTheme.nameEn : selectedTheme.nameVi}" /></c:otherwise></c:choose></h2></div>
            <c:if test="${!collectionUnavailable}"><span class="edits-total">${fn:length(products)} ${en ? 'pieces' : 'sản phẩm'}</span></c:if>
        </div>
        <nav class="edits-filters" aria-label="${en ? 'Filter by collection' : 'Lọc theo bộ sưu tập'}">
            <a href="collection?category=all#collection-products" class="${selectedCategory == 'all' ? 'is-active' : ''}" aria-current="${selectedCategory == 'all' ? 'page' : 'false'}">${en ? 'All collections' : 'Tất cả bộ sưu tập'}</a>
            <c:forEach var="theme" items="${themes}"><a href="collection?category=${theme.slug}#collection-products" class="${selectedCategory == theme.slug ? 'is-active' : ''}" aria-current="${selectedCategory == theme.slug ? 'page' : 'false'}"><c:out value="${en ? theme.nameEn : theme.nameVi}" /></a></c:forEach>
        </nav>
        <c:choose>
            <c:when test="${collectionUnavailable}"><div class="edits-empty" role="alert"><i class="fa-solid fa-cloud" aria-hidden="true"></i><h3>${en ? 'Collections are temporarily unavailable' : 'Tạm thời chưa tải được bộ sưu tập'}</h3><p>${en ? 'Please try again in a moment.' : 'Bạn vui lòng thử lại sau ít phút nhé.'}</p><a href="collection">${en ? 'Try again' : 'Thử lại'} <i class="fa-solid fa-arrow-rotate-right" aria-hidden="true"></i></a></div></c:when>
            <c:when test="${empty products}"><div class="edits-empty"><span class="edits-empty-monogram" aria-hidden="true">NT</span><span class="edits-eyebrow">COMING SOON</span><h3>${en ? 'Something special is on its way.' : 'Một cảm hứng mới đang đến.'}</h3><p>${en ? 'This collection is being curated. In the meantime, discover more styles in our store.' : 'Bộ sưu tập đang được hoàn thiện. Trong lúc chờ đợi, khám phá thêm những thiết kế tại cửa hàng.'}</p><a href="about">${en ? 'Explore the store' : 'Khám phá cửa hàng'} <i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a></div></c:when>
            <c:otherwise><div class="edits-product-grid">
                <c:forEach var="p" items="${products}">
                    <a class="edit-product" href="product-detail?pid=${p.pid}">
                        <div class="edit-product-image"><i class="fa-solid fa-shirt edit-product-placeholder" aria-hidden="true"></i><c:if test="${not empty p.image}"><img src="<c:out value='${p.image}' />" alt="<c:out value='${p.pdescription}' />" loading="lazy" onerror="this.hidden=true"></c:if><span class="edit-product-action" aria-hidden="true"><i class="fa-solid fa-arrow-up-right-from-square"></i></span></div>
                        <div class="edit-product-info"><span>${empty selectedTheme ? 'NAM THANH' : (en ? selectedTheme.nameEn : selectedTheme.nameVi)}</span><h3><c:out value="${p.pdescription}" /></h3><strong><fmt:formatNumber value="${p.price}" pattern="#,##0" /> đ</strong></div>
                    </a>
                </c:forEach>
            </div></c:otherwise>
        </c:choose>
    </section>
</main>
<jsp:include page="footer.jsp" />
</body>
</html>
