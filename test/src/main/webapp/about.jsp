<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="shop.page_title" /> | Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/user/about.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/user/index.css">
 </head>
<body>
    <jsp:include page="header.jsp"><jsp:param name="page" value="about" /></jsp:include>

    <div style="background-color: #f5f5f5; padding: 40px 0; text-align: center; margin-bottom: 20px;">
        <h1 style="font-size: 2rem; margin-bottom: 10px; letter-spacing: 2px;"><fmt:message key="shop.title" /></h1>
        <p style="color: #666;"><fmt:message key="shop.breadcrumb" /></p>

        <c:if test="${not empty txtSearch}">
            <p style="color: #d4af37; margin-top: 10px; font-weight: bold;">
                <i class="fa-solid fa-magnifying-glass"></i> Kết quả tìm kiếm cho: "${txtSearch}"
            </p>
        </c:if>
    </div>

    <div class="page-container">

        <aside class="sidebar">
            <div class="filter-group">
                <h3 class="filter-title"><fmt:message key="shop.filter_price" /></h3>
                <ul class="filter-list">
                    <li><a href="about?price=all${baseParams}" class="${priceFilter == null || priceFilter == 'all' ? 'active' : ''}">
                        <i class="fa-solid fa-circle-check"></i> <fmt:message key="shop.price_all" />
                    </a></li>
                    <li><a href="about?price=under500${baseParams}" class="${priceFilter == 'under500' ? 'active' : ''}">
                        <i class="fa-solid fa-tag"></i> <fmt:message key="shop.price_under500" />
                    </a></li>
                    <li><a href="about?price=500to1000${baseParams}" class="${priceFilter == '500to1000' ? 'active' : ''}">
                        <i class="fa-solid fa-tag"></i> <fmt:message key="shop.price_500_1000" />
                    </a></li>
                    <li><a href="about?price=above1000${baseParams}" class="${priceFilter == 'above1000' ? 'active' : ''}">
                        <i class="fa-solid fa-tag"></i> <fmt:message key="shop.price_above1000" />
                    </a></li>
                </ul>
            </div>
            
            <div class="filter-group">
                <h3 class="filter-title"><fmt:message key="shop.category" /></h3>
                <ul class="filter-list">
                    <li><a href="#"><fmt:message key="shop.cat_shirt" /></a></li>
                    <li><a href="#"><fmt:message key="shop.cat_pants" /></a></li>
                    <li><a href="#"><fmt:message key="shop.cat_accessories" /></a></li>
                    <li><a href="#"><fmt:message key="shop.cat_collection" /></a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="shop-toolbar">
                <span class="result-count"><fmt:message key="shop.showing" /> <b><c:out value="${totalProducts > 0 ? start+1 : 0}" /></b>-<b><c:out value="${end}" /></b> <fmt:message key="shop.of" /> <b><c:out value="${totalProducts}" /></b> <fmt:message key="shop.results" /></span>
                
                <form action="about" method="get" class="sort-box">
                    <c:if test="${not empty priceFilter}"><input type="hidden" name="price" value="${priceFilter}"></c:if>
                    <c:if test="${not empty txtSearch}"><input type="hidden" name="txt" value="${txtSearch}"></c:if>
                    
                    <select name="sort" onchange="this.form.submit()">
                        <option value="default"><fmt:message key="shop.sort_default" /></option>
                        <option value="price_asc" ${sortType == 'price_asc' ? 'selected' : ''}><fmt:message key="shop.sort_price_asc" /></option>
                        <option value="price_desc" ${sortType == 'price_desc' ? 'selected' : ''}><fmt:message key="shop.sort_price_desc" /></option>
                        <option value="name_asc" ${sortType == 'name_asc' ? 'selected' : ''}><fmt:message key="shop.sort_name" /></option>
                    </select>
                </form>
            </div>

            <div class="product-grid-shop">
                <c:choose>
                    <c:when test="${empty pageProducts}">
                        <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
                            <i class="fa-solid fa-box-open" style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i>
                            <p><fmt:message key="shop.no_products" /></p>
                            <a href="about" style="color: var(--gold); text-decoration: underline; font-weight: 600;">
                                <i class="fa-solid fa-rotate-left"></i> <fmt:message key="shop.clear_filter" />
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${pageProducts}">
                            <div class="product-card">
                                <div class="product-image">
                                    <a href="product-detail?pid=${p.pid}">
                                        <img src="${p.image != null ? p.image : 'img/no-image.png'}" alt="${p.pdescription}">
                                    </a>
                                    <a href="product-detail?pid=${p.pid}" class="overlay-btn"><i class="fa-regular fa-eye"></i></a>
                                </div>
                                <div class="product-details">
                                    <h3 class="product-name"><a href="product-detail?pid=${p.pid}">${p.pdescription}</a></h3>
                                    <span class="price"><fmt:formatNumber value="${p.price}" pattern="#,###" /> VNĐ</span>
                                    <form action="cart" method="post">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="pid" value="${p.pid}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn-add-cart"><fmt:message key="home.product.add_cart" /></button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${pageCurrent > 1}">
                        <a href="about?page=${pageCurrent - 1}${pageParams}" class="page-link"><i class="fa-solid fa-chevron-left"></i></a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="about?page=${i}${pageParams}" class="page-link <c:out value='${i == pageCurrent ? "active" : ""}'/>">${i}</a>
                    </c:forEach>

                    <c:if test="${pageCurrent < totalPages}">
                        <a href="about?page=${pageCurrent + 1}${pageParams}" class="page-link"><i class="fa-solid fa-chevron-right"></i></a>
                    </c:if>
                </div>
            </c:if>
        </main>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>