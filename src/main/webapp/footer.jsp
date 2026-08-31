<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/user/modern-shell.css?v=20260831.1">

<footer class="ym-footer">
    <div class="ym-footer-inner">
        <div class="ym-footer-col ym-footer-brand">
            <div class="ym-footer-brandline">
                <img src="${pageContext.request.contextPath}/img/logover2_5.png" alt="Nam Thành Fashion" class="ym-footer-logo">
                <div>
                    <strong>NAM THÀNH</strong>
                    <span>FASHION MAN · EST. 2026</span>
                </div>
            </div>
            <p class="ym-footer-desc"><fmt:message key="footer.desc" /></p>
            <div class="ym-socials" aria-label="Mạng xã hội">
                <a href="#" title="Facebook" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="#" title="Instagram" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
                <a href="#" title="TikTok" aria-label="TikTok"><i class="fa-brands fa-tiktok"></i></a>
                <a href="#" title="YouTube" aria-label="YouTube"><i class="fa-brands fa-youtube"></i></a>
            </div>
        </div>

        <div class="ym-footer-col">
            <h4><fmt:message key="footer.explore" /></h4>
            <ul class="ym-footer-links">
                <li><a href="${pageContext.request.contextPath}/home"><fmt:message key="menu.home" /></a></li>
                <li><a href="${pageContext.request.contextPath}/collection"><fmt:message key="menu.collection" /> 2026</a></li>
                <li><a href="${pageContext.request.contextPath}/news"><fmt:message key="menu.news" /></a></li>
                <li><a href="${pageContext.request.contextPath}/about"><fmt:message key="footer.about_us" /></a></li>
            </ul>
        </div>

        <div class="ym-footer-col">
            <h4><fmt:message key="footer.support" /></h4>
            <div class="ym-contact-item">
                <i class="fa-solid fa-phone"></i>
                <span>0981 774 313</span>
            </div>
            <div class="ym-contact-item">
                <i class="fa-solid fa-envelope"></i>
                <span>phamvanhoain@gmail.com</span>
            </div>
            <div class="ym-contact-item">
                <i class="fa-solid fa-location-dot"></i>
                <span>S2, Hải Triều, Q.1, TP. HCM</span>
            </div>
        </div>

        <div class="ym-footer-col">
            <h4><fmt:message key="footer.partners" /></h4>
            <p class="ym-partner-label"><fmt:message key="footer.payment_safe" /></p>
            <div class="ym-partners">
                <img src="${pageContext.request.contextPath}/img/visa.png" alt="Visa">
                <img src="${pageContext.request.contextPath}/img/jcb.png" alt="JCB">
                <img src="${pageContext.request.contextPath}/img/paypal.png" alt="Paypal">
            </div>
            <p class="ym-partner-label"><fmt:message key="footer.shipping" /></p>
            <div class="ym-partners">
                <img src="${pageContext.request.contextPath}/img/ghtk.png" alt="GHTK">
                <img src="${pageContext.request.contextPath}/img/jt.png" alt="J&T Express">
                <img src="${pageContext.request.contextPath}/img/kerry.png" alt="Kerry Express">
            </div>
        </div>
    </div>

    <div class="ym-footer-bottom">
        <span>&copy; 2026 Nam Thành Fashion. All rights reserved.</span>
    </div>
</footer>
