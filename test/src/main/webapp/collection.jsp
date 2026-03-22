<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setLocale
	value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<title><fmt:message key="collection.page_title" /> | Fashion
	Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css">
<link rel="stylesheet" href="CSS/collection.css">
</head>
<body>

	<jsp:include page="header.jsp">
		<jsp:param name="page" value="collection" />
	</jsp:include>

	<div class="collection-wrapper">
		<div class="collection-header">
			<h1>
				<fmt:message key="collection.lookbook" />
			</h1>

			<!-- FILTER (gọi servlet) -->
			<div class="filter-menu">
				<a href="collection?category=all"
					class="filter-btn ${empty selectedCategory || selectedCategory == 'all' ? 'active' : ''}">
					<fmt:message key="collection.filter_all" /></a> <a
					href="collection?category=summer"
					class="filter-btn ${selectedCategory == 'summer' ? 'active' : ''}">
					<fmt:message key="collection.filter_summer" />
				</a> <a href="collection?category=office"
					class="filter-btn ${selectedCategory == 'office' ? 'active' : ''}">
					<fmt:message key="collection.filter_office" />
				</a> <a href="collection?category=party"
					class="filter-btn ${selectedCategory == 'party' ? 'active' : ''}">
					<fmt:message key="collection.filter_party" />
				</a>
			</div>
		</div>

		<!-- PRODUCT LIST -->
		<div class="gallery-grid">

			<c:forEach var="p" items="${products}">
				<div class="gallery-item show" data-category="${p.category.name}">

					<!-- IMAGE -->
					<img src="${empty p.image ? 'img/no-image.png' : p.image}"
						alt="${p.pdescription}">

					<div class="item-overlay">

						<!-- TAG -->
						<span class="collection-tag"> <c:choose>
								<c:when test="${p.category.name == 'summer'}">
                                SUMMER VIBES
                            </c:when>
								<c:when test="${p.category.name == 'office'}">
                                OFFICE CHIC
                            </c:when>
								<c:when test="${p.category.name == 'party'}">
                                PARTY NIGHT
                            </c:when>
								<c:otherwise>
                                DAILY WEAR
                            </c:otherwise>
							</c:choose>
						</span>

						<!-- NAME -->
						<h2 class="collection-name">${p.pdescription}</h2>

						<!-- DESC -->
						<div class="collection-desc">
							<fmt:message key="collection.item_desc" />
						</div>

						<!-- LINK -->
						<a href="product-detail?pid=${p.pid}" class="btn-discover"> <fmt:message
								key="collection.btn_detail" />
						</a>

					</div>
				</div>
			</c:forEach>

		</div>
	</div>

	<jsp:include page="footer.jsp" />

</body>
</html>