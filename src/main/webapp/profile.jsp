<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user}"><c:redirect url="/login" /></c:if>
<c:if test="${empty membership}"><c:redirect url="/profile" /></c:if>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en' : 'vi'}" />
<fmt:setBundle basename="resources.messages" />
<c:set var="en" value="${sessionScope.lang == 'en'}" />
<c:set var="account" value="${sessionScope.user}" />
<c:set var="nextTarget" value="${membership.lifetimeSpend lt 2000000 ? 2000000 : membership.lifetimeSpend lt 5000000 ? 5000000 : membership.lifetimeSpend lt 10000000 ? 10000000 : 20000000}" />
<c:set var="tierProgress" value="${membership.lifetimeSpend ge 20000000 ? 100 : membership.lifetimeSpend / nextTarget * 100}" />
<c:url var="avatarUrl" value="/img/avatar-default.svg" />
<c:if test="${not empty account.avatar}"><c:url var="avatarUrl" value="/img/avatars/${account.avatar}" /></c:if>
<!DOCTYPE html>
<html lang="${en ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title><fmt:message key="profile.page_title" /> | Nam Thanh</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="stylesheet" href="CSS/user/profile.css?v=20260909.2">
</head>
<body class="ym-user-page ym-profile-page">
<jsp:include page="header.jsp"><jsp:param name="page" value="profile" /></jsp:include>
<main class="account-page">
    <div class="account-heading">
        <div><span class="account-eyebrow">NAM THANH / MY ACCOUNT</span>
            <h1>${en ? 'Your personal space.' : 'Không gian của bạn.'}</h1>
            <p>${en ? 'Your details, your style, your privileges.' : 'Thông tin của bạn, phong cách của bạn và những đặc quyền riêng.'}</p>
        </div>
        <a class="account-text-link" href="about">${en ? 'Continue shopping' : 'Tiếp tục mua sắm'} <i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i></a>
    </div>
    <div class="account-layout">
        <aside class="account-sidebar">
            <section class="account-card account-identity">
                <div class="account-avatar-wrap"><img id="account-avatar" class="account-avatar" src="<c:out value='${avatarUrl}' />" alt="${en ? 'Profile photo' : 'Ảnh đại diện'}"></div>
                <h2><c:out value="${empty account.fullname ? account.username : account.fullname}" /></h2>
                <p class="account-handle">@<c:out value="${account.username}" /></p>
                <span class="account-member-badge"><i class="fa-solid fa-crown" aria-hidden="true"></i> ${en ? 'Member' : 'Thành viên'} · <c:out value="${membership.tierLabel}" /></span>
                <form action="profile" method="post" enctype="multipart/form-data" class="account-avatar-form">
                    <input type="hidden" name="action" value="upload-avatar">
                    <label for="avatar-file" class="account-file-label"><i class="fa-solid fa-camera" aria-hidden="true"></i> ${en ? 'Choose a photo' : 'Chọn ảnh mới'}</label>
                    <input id="avatar-file" type="file" name="avatarFile" accept="image/jpeg,image/png,image/webp" required aria-describedby="avatar-help">
                    <span id="avatar-help" class="account-help">JPG, PNG, WEBP · ${en ? 'Up to 10 MB' : 'Tối đa 10 MB'}</span>
                    <button type="submit" class="account-button account-button-light"><fmt:message key="profile.upload_btn" /></button>
                </form>
                <nav class="account-nav" aria-label="${en ? 'Account navigation' : 'Điều hướng tài khoản'}">
                    <a href="#personal-info" class="is-current"><i class="fa-regular fa-user" aria-hidden="true"></i> <fmt:message key="profile.info_title" /><i class="fa-solid fa-chevron-right" aria-hidden="true"></i></a>
                    <a href="#account-security"><i class="fa-solid fa-shield-halved" aria-hidden="true"></i> ${en ? 'Password & security' : 'Mật khẩu & bảo mật'}</a>
                    <a href="order-history"><i class="fa-solid fa-box" aria-hidden="true"></i> ${en ? 'My orders' : 'Đơn hàng của tôi'}</a>
                    <a href="address-list"><i class="fa-solid fa-location-dot" aria-hidden="true"></i> ${en ? 'Address book' : 'Sổ địa chỉ'}</a>
                </nav>
            </section>
            <a href="collection" class="account-discover"><span>THE STYLE EDIT</span><h3>${en ? 'Find your next look.' : 'Cảm hứng cho diện mạo mới.'}</h3><p>${en ? 'Explore our collections' : 'Khám phá các bộ sưu tập'} <i class="fa-solid fa-arrow-right" aria-hidden="true"></i></p></a>
        </aside>
        <div class="account-main">
            <c:if test="${not empty msgInfo}"><div class="account-notice" role="status"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> <c:out value="${msgInfo}" /></div></c:if>
            <c:if test="${not empty errInfo}"><div class="account-notice account-notice-error" role="alert"><c:out value="${errInfo}" /></div></c:if>
            <section class="account-card account-membership">
                <div class="account-membership-top"><span class="account-eyebrow">NAM THANH MEMBERSHIP</span><i class="fa-solid fa-crown" aria-hidden="true"></i></div>
                <div class="account-membership-summary"><div><p>${en ? 'Your membership tier' : 'Hạng thành viên của bạn'}</p><h2><c:out value="${membership.tierLabel}" /></h2></div><div class="account-benefit"><strong><fmt:formatNumber value="${membership.discountPercent}" maxFractionDigits="0" />%</strong><span>${en ? 'off each order' : 'ưu đãi mỗi đơn hàng'}</span></div></div>
                <div class="account-spend"><span>${en ? 'Completed order spending' : 'Chi tiêu đơn hàng thành công'}</span><strong><fmt:formatNumber value="${membership.lifetimeSpend}" pattern="#,##0" /> đ</strong></div>
                <progress class="account-progress" value="${tierProgress}" max="100" aria-label="${en ? 'Membership progress' : 'Tiến độ hạng thành viên'}"></progress>
                <p class="account-membership-note"><c:choose><c:when test="${membership.lifetimeSpend ge 20000000}">${en ? 'You have reached our highest tier. Enjoy your privileges!' : 'Bạn đã đạt hạng cao nhất. Tận hưởng những đặc quyền của bạn!'}</c:when><c:otherwise>${en ? 'Spend another' : 'Chi tiêu thêm'} <strong><fmt:formatNumber value="${nextTarget - membership.lifetimeSpend}" pattern="#,##0" /> đ</strong> ${en ? 'to reach the next tier.' : 'để nâng hạng tiếp theo.'}</c:otherwise></c:choose></p>
                <div class="account-tier-list"><span>${en ? 'Bronze' : 'Đồng'} <b>2tr · 5%</b></span><span>${en ? 'Silver' : 'Bạc'} <b>5tr · 10%</b></span><span>${en ? 'Gold' : 'Vàng'} <b>10tr · 15%</b></span><span>${en ? 'Diamond' : 'Kim cương'} <b>20tr · 20%</b></span></div>
            </section>
            <section id="personal-info" class="account-card account-section">
                <div class="account-section-heading"><span class="account-section-icon"><i class="fa-regular fa-id-card" aria-hidden="true"></i></span><div><h2><fmt:message key="profile.info_title" /></h2><p>${en ? 'Keep your contact details up to date.' : 'Cập nhật thông tin để chúng mình kết nối với bạn dễ dàng hơn.'}</p></div></div>
                <form action="profile" method="post" class="account-form">
                    <input type="hidden" name="action" value="update-info">
                    <div class="account-fields">
                        <div class="account-field"><label for="account-username"><fmt:message key="profile.username" /></label><input id="account-username" type="text" value="<c:out value='${account.username}' />" readonly aria-describedby="username-help"><span id="username-help" class="account-help">${en ? 'Your username cannot be changed.' : 'Tên đăng nhập không thể thay đổi.'}</span></div>
                        <div class="account-field"><label for="account-fullname"><fmt:message key="profile.fullname" /></label><input id="account-fullname" type="text" name="fullname" value="<c:out value='${account.fullname}' />" autocomplete="name" maxlength="100" required></div>
                        <div class="account-field"><label for="account-email"><fmt:message key="profile.email" /></label><input id="account-email" type="email" name="email" value="<c:out value='${account.email}' />" autocomplete="email" maxlength="100" required></div>
                        <div class="account-field"><label for="account-phone"><fmt:message key="profile.phone" /></label><input id="account-phone" type="tel" name="phone" value="<c:out value='${account.phonenumber}' />" autocomplete="tel" maxlength="20" required></div>
                    </div>
                    <div class="account-form-footer"><span><i class="fa-solid fa-lock" aria-hidden="true"></i> ${en ? 'Your personal information is private.' : 'Thông tin cá nhân của bạn được giữ riêng tư.'}</span><button type="submit" class="account-button"><fmt:message key="profile.update_btn" /> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i></button></div>
                </form>
            </section>
            <section id="account-security" class="account-card account-section">
                <div class="account-section-heading"><span class="account-section-icon"><i class="fa-solid fa-shield-halved" aria-hidden="true"></i></span><div><h2>${en ? 'Password & security' : 'Mật khẩu & bảo mật'}</h2><p>${en ? 'Use a unique password to protect your account.' : 'Sử dụng mật khẩu riêng để bảo vệ tài khoản của bạn.'}</p></div></div>
                <c:if test="${not empty msgPass}"><div class="account-notice" role="status"><c:out value="${msgPass}" /></div></c:if>
                <c:if test="${not empty errPass}"><div class="account-notice account-notice-error" role="alert"><c:out value="${errPass}" /></div></c:if>
                <form action="profile#account-security" method="post" class="account-form">
                    <input type="hidden" name="action" value="change-pass">
                    <div class="account-field"><label for="old-password"><fmt:message key="profile.old_pass" /></label><input id="old-password" type="password" name="old_pass" autocomplete="current-password" required></div>
                    <div class="account-fields">
                        <div class="account-field"><label for="new-password"><fmt:message key="profile.new_pass" /></label><input id="new-password" type="password" name="new_pass" autocomplete="new-password" required></div>
                        <div class="account-field"><label for="confirm-password"><fmt:message key="profile.confirm_pass" /></label><input id="confirm-password" type="password" name="confirm_pass" autocomplete="new-password" required></div>
                    </div>
                    <div class="account-form-footer"><label class="account-show-password"><input type="checkbox" id="show-passwords"> ${en ? 'Show passwords' : 'Hiện mật khẩu'}</label><button type="submit" class="account-button account-button-light"><fmt:message key="profile.change_pass_btn" /></button></div>
                </form>
            </section>
        </div>
    </div>
</main>
<jsp:include page="footer.jsp" />
<script src="JS/profile.js?v=20260909"></script>
</body>
</html>
