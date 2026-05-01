<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<head>
<link rel="stylesheet" href="CSS/user/Header.css">
</head>

<fmt:setLocale
	value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<header class="header">
	<a href="home"> <img src="img/logover2_5.png" alt="Logo"
		class="logo" width="60">
	</a>

	<nav class="menu">
		<a href="home"><fmt:message key="menu.home" /></a> <a
			href="collection"><fmt:message key="menu.collection" /></a> <a
			href="about"><fmt:message key="menu.products" /></a> <a
			href="news.jsp"><fmt:message key="menu.news" /></a>
	</nav>

	<div class="actions">

		<!-- Language -->
		<div class="lang-switch">

			<a href="change-lang?lang=vi">VN</a> | <a href="change-lang?lang=en">EN</a>

			<c:if test="${sessionScope.user != null}">
				<div>👋 Xin chào, ${sessionScope.user.fullname}</div>

			</c:if>

		</div>

		<!-- Search -->
		<form action="${pageContext.request.contextPath}/search" method="get"
			class="search-box">
			<button type="submit">
				<i class="fa-solid fa-magnifying-glass"></i>
			</button>
			<input type="text" name="txt" placeholder="Tìm kiếm..."
				value="${param.txt}" />
		</form>


		<!-- Account -->
		<div class="account">
			<div class="user-menu">

				<!-- Trigger -->
				<div class="user-trigger">

					<!-- Avatar -->
					<c:choose>
						<c:when
							test="${sessionScope.user != null && not empty sessionScope.user.avatar}">
							<img src="img/avatars/${sessionScope.user.avatar}"
								class="user-avatar" />
						</c:when>
						<c:otherwise>
							<i class="fa-solid fa-user"></i>
						</c:otherwise>
					</c:choose>

					<!-- Arrow -->
					<i class="fa-solid fa-caret-down arrow-down"></i>
				</div>

				<!-- Dropdown -->
				<div class="user-dropdown">

					<c:choose>

						<%-- CHƯA LOGIN --%>
						<c:when test="${sessionScope.user == null}">
							<a href="login">🔑 Đăng nhập</a>
							<a href="register">📝 Đăng ký</a>
						</c:when>

						<%-- ĐÃ LOGIN --%>
						<c:otherwise>
							<div>👋 Xin chào, ${sessionScope.user.fullname}</div>

							<a href="profile.jsp">👤 Thông tin</a>
							<a href="order-history">📦 Lịch sử mua</a>
							<a href="settings.jsp">⚙️ Cài đặt</a>

							<c:if test="${sessionScope.isAdmin}">
								<a href="admin">🛠 Admin</a>
							</c:if>

							<a href="${pageContext.request.contextPath}/logout">🚪 Đăng
								xuất</a>
						</c:otherwise>

					</c:choose>

				</div>
			</div>
		</div>

		<!-- Cart -->
		<a href="cart" class="cart-icon"> <i
			class="fa-solid fa-cart-shopping"></i>
		</a>

	</div>
</header>