<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user" %>
<%
    user currentUser = (user) session.getAttribute("user");
    boolean isLoggedIn = (currentUser != null);
    String displayName = "Member";
    if (isLoggedIn) {
        String fullName = currentUser.getFullname();
        displayName = (fullName == null || fullName.isEmpty()) ? "Member" : fullName;
        if (displayName.length() > 15) {
            displayName = displayName.substring(0, 15) + "...";
        }
    }
    String currentPage = request.getParameter("page");
%>
<header class="header">
    <a href="index.jsp"><img src="img/logover2_5.png" alt="Logo" class="logo" width="80"></a>
    <nav class="menu">
        <a href="index.jsp" class="<%= "index".equals(currentPage) ? "active" : "" %>">TRANG CHỦ</a> 
        <a href="collection.jsp" class="<%= "collection".equals(currentPage) ? "active" : "" %>">BỘ SƯU TẬP</a> 
        <a href="about.jsp" class="<%= "about".equals(currentPage) ? "active" : "" %>">SẢN PHẨM</a> 
        <a href="news.jsp" class="<%= "news".equals(currentPage) ? "active" : "" %>">TIN TỨC</a>
    </nav>
    <div class="actions">
        <div class="search-box">
            <i class="fa-solid fa-magnifying-glass"></i> 
            <input type="text" placeholder="Tìm kiếm sản phẩm..." />
        </div>
        <div class="account">
            <% if (!isLoggedIn) { %>
                <a href="login.jsp">ĐĂNG NHẬP</a> <span style="color:#ccc">|</span> <a href="register.jsp">ĐĂNG KÍ</a>
            <% } else { %>
                <div class="user-info">
                    <span>Hi, <%= displayName %></span> 
                    <a href="order-history" title="Lịch sử mua hàng" style="margin-left: 5px;"><i class="fa-solid fa-clock-rotate-left"></i></a>
                    <a href="profile.jsp" title="Trang cá nhân"><img src="img/images.jpg" alt="User" class="user-avatar"></a>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></a>
                </div>
            <% } %>
        </div>
        <a href="cart" class="cart-icon"><i class="fa-solid fa-cart-shopping"></i></a>
    </div>
</header>