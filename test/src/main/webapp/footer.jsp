<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<footer class="main-footer">
    <div class="footer-container">
        <div class="footer-col brand-info">
            <img src="img/logover2_5.png" alt="Logo" class="footer-logo">
            <p class="brand-desc"><fmt:message key="footer.desc" /></p>
            <div class="social-links">
                <a href="#" title="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="#" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
                <a href="#" title="TikTok"><i class="fa-brands fa-tiktok"></i></a>
                <a href="#" title="YouTube"><i class="fa-brands fa-youtube"></i></a>
            </div>
        </div>
        <div class="footer-col">
            <h4 class="footer-title"><fmt:message key="footer.explore" /></h4>
            <ul class="footer-links">
                <li><a href="index.jsp"><fmt:message key="menu.home" /></a></li>
                <li><a href="collection.jsp"><fmt:message key="menu.collection" /> 2025</a></li>
                <li><a href="news.jsp"><fmt:message key="menu.news" /></a></li>
                <li><a href="about.jsp"><fmt:message key="footer.about_us" /></a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4 class="footer-title"><fmt:message key="footer.support" /></h4>
            <div class="contact-item"><i class="fa-solid fa-phone"></i> <span>0981 774 313</span></div>
            <div class="contact-item"><i class="fa-solid fa-envelope"></i> <span>phamvanhoain@gmail.com</span></div>
            <div class="contact-item"><i class="fa-solid fa-location-dot"></i> <span>S2, Hải Triều, Q.1, TP. HCM</span></div>
        </div>
        <div class="footer-col">
            <h4 class="footer-title"><fmt:message key="footer.partners" /></h4>
            <p class="partner-label"><fmt:message key="footer.payment_safe" /></p>
            <div class="partner-logos">
                <img src="img/visa.png" alt="Visa"><img src="img/jcb.png" alt="JCB"><img src="img/paypal.png" alt="Paypal">
            </div>
            <p class="partner-label" style="margin-top: 15px;"><fmt:message key="footer.shipping" /></p>
            <div class="partner-logos">
                <img src="img/ghtk.png" alt="GHTK"><img src="img/jt.png" alt="J&T"><img src="img/kerry.png" alt="Kerry">
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container"><p>&copy; 2025 Fashion Store. All Rights Reserved. Design by Nam and Thanh.</p></div>
    </div>
</footer>