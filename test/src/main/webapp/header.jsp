<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>



	<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />
<%
    // Lấy user từ session
    user currentUser = (user) session.getAttribute("user");
    boolean isLoggedIn = (currentUser != null);
    
    String displayName = "Member";
    String avatarLink = "profile.jsp";
    String avatarImgSrc = "img/images.jpg"; // Ảnh mặc định

    if (isLoggedIn) {
        // 1. Xử lý tên hiển thị
        String fullName = currentUser.getFullname();
        displayName = (fullName == null || fullName.isEmpty()) ? "Member" : fullName;
        if (displayName.length() > 15) {
            displayName = displayName.substring(0, 15) + "...";
        }

        // 2. Xử lý Avatar
        if (currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) {
            avatarImgSrc = "img/avatars/" + currentUser.getAvatar();
        }

        // 3. Xử lý Link Avatar (Check Admin)
        Boolean isAdminSession = (Boolean) session.getAttribute("isAdmin");
        String uName = currentUser.getUsername();
        String uEmail = currentUser.getEmail();

        boolean isAdmin = (isAdminSession != null && isAdminSession) ||
                          (uName != null && uName.equalsIgnoreCase("admin")) || 
                          (uEmail != null && uEmail.contains("admin"));

        if (isAdmin) {
            avatarLink = "admin";
        }
    }
    
    String currentPage = request.getParameter("page");
%>

<header class="header">
    <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>
    
    <nav class="menu">
        <a href="index.jsp" class="<%= "index".equals(currentPage) ? "active" : "" %>">
            <fmt:message key="menu.home" /> </a> 
        <a href="collection.jsp" class="<%= "collection".equals(currentPage) ? "active" : "" %>">
            <fmt:message key="menu.collection" /> </a> 
        <a href="about.jsp" class="<%= "about".equals(currentPage) ? "active" : "" %>">
            <fmt:message key="menu.products" /> </a> 
        <a href="news.jsp" class="<%= "news".equals(currentPage) ? "active" : "" %>">
            <fmt:message key="menu.news" /> </a>
    </nav>
    
    <div class="actions">
        <div class="lang-switch" style="font-size: 0.9rem; font-weight: 600;">
            <a href="change-lang?lang=vi" style="color: ${sessionScope.lang == 'vi' || sessionScope.lang == null ? '#d4af37' : 'white'}; text-decoration: none;">VN</a> 
            <span style="color: #666">|</span> 
            <a href="change-lang?lang=en" style="color: ${sessionScope.lang == 'en' ? '#d4af37' : 'white'}; text-decoration: none;">EN</a>
        </div>

        <div class="search-box">
            <i class="fa-solid fa-magnifying-glass"></i> 
            <input type="text" placeholder="<fmt:message key='header.search_placeholder'/>" />
        </div>
        
        <div class="account">
            <% if (!isLoggedIn) { %>
                <a href="login.jsp"><fmt:message key="header.login" /></a> <span style="color:#ccc">|</span> 
                <a href="register.jsp"><fmt:message key="header.register" /></a> <% } else { %>
                <div class="user-info">
                    <span><fmt:message key="header.greeting" /> <%= displayName %></span> 
                    
                    <a href="order-history" title="<fmt:message key='header.history_title'/>" style="margin-left: 5px;">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                    </a>
                    
                    <a href="<%= avatarLink %>" title="<%= avatarLink.equals("admin") ? "Admin Dashboard" : "Profile" %>">
                        <img src="<%= avatarImgSrc %>" alt="User" class="user-avatar">
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="<fmt:message key='header.logout_title'/>">
                       <i class="fa-solid fa-right-from-bracket"></i>
                    </a>
                </div>
            <% } %>
        </div>
        
        <a href="cart" class="cart-icon"><i class="fa-solid fa-cart-shopping"></i></a>
    </div>
</header>