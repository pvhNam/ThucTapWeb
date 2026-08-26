<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/user/modern-shell.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/shared/smooth-navigation.css?v=20260822.4">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/user/user-pages.css">
<script src="${pageContext.request.contextPath}/JS/smooth-navigation.js?v=20260822.5" defer></script>

<header class="ym-header" id="ym-site-header"
		data-current-lang="${sessionScope.lang == 'en' ? 'en' : 'vi'}">
	<div class="ym-header-inner">
		<a href="${pageContext.request.contextPath}/home" class="ym-logo" aria-label="Nam Thành Fashion - Trang chủ" data-prefetch data-site-navigation data-page="index">
			<img class="ym-logo-mark" src="${pageContext.request.contextPath}/img/logover2_5.png" alt="Nam Thành Fashion">
			<span class="ym-logo-copy" aria-hidden="true">
				<strong>NAM THÀNH</strong>
				<small>FASHION MAN</small>
			</span>
		</a>

		<nav class="ym-nav" id="ym-main-navigation" data-current-page="${param.page}" aria-label="Điều hướng chính">
			<a href="${pageContext.request.contextPath}/home" class="${param.page == 'index' ? 'active' : ''}" data-prefetch data-site-navigation data-page="index"><fmt:message key="menu.home" /></a>
			<a href="${pageContext.request.contextPath}/collection" class="${param.page == 'collection' ? 'active' : ''}" data-prefetch data-site-navigation data-page="collection"><fmt:message key="menu.collection" /></a>
			<a href="${pageContext.request.contextPath}/about" class="${param.page == 'about' ? 'active' : ''}" data-prefetch data-site-navigation data-page="about"><fmt:message key="menu.products" /></a>
			<a href="${pageContext.request.contextPath}/news" class="${param.page == 'news' ? 'active' : ''}" data-prefetch data-site-navigation data-page="news"><fmt:message key="menu.news" /></a>

			<div class="ym-mobile-tools">
				<form action="${pageContext.request.contextPath}/search" method="get" class="ym-search" role="search">
					<input type="search" name="txt" placeholder="<fmt:message key='header.search_placeholder' />" value="<c:out value='${param.txt}' />" aria-label="<fmt:message key='header.search_placeholder' />">
					<button type="submit" aria-label="<fmt:message key='header.search_placeholder' />"><i class="fa-solid fa-magnifying-glass"></i></button>
				</form>
				<div class="ym-mobile-languages" data-language-switcher data-active-lang="${sessionScope.lang == 'en' ? 'en' : 'vi'}" aria-label="Chọn ngôn ngữ">
					<a href="${pageContext.request.contextPath}/change-lang?lang=vi" data-lang="vi" class="${sessionScope.lang == null || sessionScope.lang == 'vi' ? 'active' : ''}" aria-pressed="${sessionScope.lang == null || sessionScope.lang == 'vi'}">Tiếng Việt</a>
					<a href="${pageContext.request.contextPath}/change-lang?lang=en" data-lang="en" class="${sessionScope.lang == 'en' ? 'active' : ''}" aria-pressed="${sessionScope.lang == 'en'}">English</a>
				</div>
			</div>
		</nav>

		<div class="ym-actions">
			<form action="${pageContext.request.contextPath}/search" method="get" class="ym-search" role="search">
				<input type="search" name="txt" placeholder="<fmt:message key='header.search_placeholder' />" value="<c:out value='${param.txt}' />" aria-label="<fmt:message key='header.search_placeholder' />">
				<button type="submit" aria-label="<fmt:message key='header.search_placeholder' />"><i class="fa-solid fa-magnifying-glass"></i></button>
			</form>

			<div class="ym-lang" data-language-switcher data-active-lang="${sessionScope.lang == 'en' ? 'en' : 'vi'}" aria-label="Chọn ngôn ngữ">
				<a href="${pageContext.request.contextPath}/change-lang?lang=vi" data-lang="vi" class="${sessionScope.lang == null || sessionScope.lang == 'vi' ? 'active' : ''}" aria-pressed="${sessionScope.lang == null || sessionScope.lang == 'vi'}">VN</a>
				<a href="${pageContext.request.contextPath}/change-lang?lang=en" data-lang="en" class="${sessionScope.lang == 'en' ? 'active' : ''}" aria-pressed="${sessionScope.lang == 'en'}">EN</a>
			</div>

			<div class="ym-user-menu">
				<button class="ym-user-trigger" type="button" aria-label="Mở menu tài khoản" aria-haspopup="true" aria-expanded="false">
					<c:choose>
						<c:when test="${sessionScope.user != null && not empty sessionScope.user.avatar}">
							<img src="${pageContext.request.contextPath}/img/avatars/${sessionScope.user.avatar}" alt="Ảnh đại diện">
						</c:when>
						<c:otherwise>
							<i class="fa-regular fa-user"></i>
						</c:otherwise>
					</c:choose>
				</button>

				<div class="ym-dropdown" role="menu">
					<c:choose>
						<c:when test="${sessionScope.user == null}">
							<a href="${pageContext.request.contextPath}/login" role="menuitem"><i class="fa-solid fa-arrow-right-to-bracket"></i> <fmt:message key="header.login" /></a>
							<a href="${pageContext.request.contextPath}/register" role="menuitem"><i class="fa-solid fa-user-plus"></i> <fmt:message key="header.register" /></a>
						</c:when>
						<c:otherwise>
							<div class="user-greet"><i class="fa-regular fa-face-smile"></i> <fmt:message key="header.greeting" /> <c:out value="${sessionScope.user.fullname}" />!</div>
							<a href="${pageContext.request.contextPath}/profile.jsp" role="menuitem"><i class="fa-regular fa-id-card"></i> <fmt:message key="profile.info_title" /></a>
							<a href="${pageContext.request.contextPath}/order-history" role="menuitem"><i class="fa-solid fa-clock-rotate-left"></i> <fmt:message key="header.history_title" /></a>
							<c:if test="${sessionScope.isAdmin}">
								<a href="${pageContext.request.contextPath}/admin" class="ym-admin-link" role="menuitem"><i class="fa-solid fa-chart-line"></i> Quản trị Admin</a>
							</c:if>
							<a href="${pageContext.request.contextPath}/logout" role="menuitem"><i class="fa-solid fa-arrow-right-from-bracket"></i> <fmt:message key="header.logout_title" /></a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<a href="${pageContext.request.contextPath}/cart" class="ym-cart" aria-label="Giỏ hàng">
				<i class="fa-solid fa-bag-shopping"></i>
				<span class="ym-cart-count" aria-live="polite" data-count="${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}">${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}</span>
			</a>

			<button class="ym-menu-toggle" type="button" aria-controls="ym-main-navigation" aria-expanded="false" aria-label="Mở menu">
				<span></span>
			</button>
		</div>
	</div>

	<div id="ym-toast" role="status" aria-live="polite"
		 data-message="<c:out value='${sessionScope.toastMessage}' />"
		 data-type="<c:out value='${sessionScope.toastType}' />"></div>
</header>

<script>
	(function () {
		const header = document.getElementById('ym-site-header');
		if (!header || header.dataset.ready === 'true') return;
		header.dataset.ready = 'true';

		const menuButton = header.querySelector('.ym-menu-toggle');
		const navigation = header.querySelector('.ym-nav');
		const userMenu = header.querySelector('.ym-user-menu');
		const userButton = header.querySelector('.ym-user-trigger');

		function setNav(open) {
			header.classList.toggle('nav-open', open);
			document.body.classList.toggle('ym-nav-open', open);
			if (menuButton) {
				menuButton.setAttribute('aria-expanded', String(open));
				menuButton.setAttribute('aria-label', open ? 'Đóng menu' : 'Mở menu');
			}
		}

		if (menuButton) {
			menuButton.addEventListener('click', function () {
				setNav(!header.classList.contains('nav-open'));
			});
		}

		if (navigation) {
			navigation.addEventListener('click', function (event) {
				if (event.target.closest('a')) setNav(false);
			});
		}

		if (userButton && userMenu) {
			userButton.addEventListener('click', function (event) {
				event.stopPropagation();
				const open = !userMenu.classList.contains('is-open');
				userMenu.classList.toggle('is-open', open);
				userButton.setAttribute('aria-expanded', String(open));
			});
		}

		document.addEventListener('click', function (event) {
			if (userMenu && !userMenu.contains(event.target)) {
				userMenu.classList.remove('is-open');
				if (userButton) userButton.setAttribute('aria-expanded', 'false');
			}
		});

		document.addEventListener('keydown', function (event) {
			if (event.key !== 'Escape') return;
			setNav(false);
			if (userMenu) userMenu.classList.remove('is-open');
			if (userButton) userButton.setAttribute('aria-expanded', 'false');
		});

		window.addEventListener('resize', function () {
			if (window.innerWidth > 920) setNav(false);
		});

		function syncHeader() {
			header.classList.toggle('is-scrolled', window.scrollY > 24);
		}
		syncHeader();
		window.addEventListener('scroll', syncHeader, { passive: true });

		window.showToast = function (message, type) {
			const toast = document.getElementById('ym-toast');
			if (!toast) return;
			toast.replaceChildren();
			const icon = document.createElement('i');
			icon.className = type === 'success' ? 'fa-solid fa-circle-check' : 'fa-solid fa-circle-exclamation';
			icon.style.color = type === 'success' ? '#7ed99d' : '#ff8b8b';
			const text = document.createElement('span');
			text.textContent = message;
			toast.append(icon, text);
			toast.classList.remove('success', 'error', 'show');
			toast.classList.add(type === 'success' ? 'success' : 'error');
			requestAnimationFrame(function () { toast.classList.add('show'); });
			window.clearTimeout(window.ymToastTimer);
			window.ymToastTimer = window.setTimeout(function () { toast.classList.remove('show'); }, 3500);
		};

		const toast = document.getElementById('ym-toast');
		if (toast && toast.dataset.message) {
			window.showToast(toast.dataset.message, toast.dataset.type || 'success');
		}
	})();
</script>

<c:if test="${not empty sessionScope.toastMessage}">
	<c:remove var="toastMessage" scope="session" />
	<c:remove var="toastType" scope="session" />
</c:if>
