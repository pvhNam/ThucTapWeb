<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<%
    user currentUser = (user) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String avatarUrl = "img/images.jpg";
    if (currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) {
        avatarUrl = "img/avatars/" + currentUser.getAvatar();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="profile.page_title" /></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/login.css" /> 
    <link rel="stylesheet" href="CSS/profile.css" /> 
</head>
<body>
    <header>
        <jsp:include page="header.jsp"><jsp:param name="page" value="#"/></jsp:include>
    </header>

    <div class="profile-container">
        <div class="profile-box" style="text-align: center;">
            <h3 class="profile-title"><i class="fa-solid fa-camera"></i> <fmt:message key="profile.avatar_title" /></h3>
            <img src="<%= avatarUrl %>" alt="Avatar" style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 3px solid #d4af37; margin-bottom: 20px;">
            <form action="profile" method="post" enctype="multipart/form-data" style="display: flex; flex-direction: column; align-items: center; gap: 10px;">
                <input type="hidden" name="action" value="upload-avatar">
                <input type="file" name="avatarFile" accept="image/*" required style="border: 1px solid #ccc; padding: 5px; border-radius: 5px; width: 80%;">
                <button type="submit" class="btn-login" style="width: auto; padding: 8px 20px; font-size: 0.9rem;">
                    <i class="fa-solid fa-cloud-arrow-up"></i> <fmt:message key="profile.upload_btn" />
                </button>
            </form>
        </div>

        <div class="profile-box">
            <h3 class="profile-title"><i class="fa-solid fa-id-card"></i> <fmt:message key="profile.info_title" /></h3>
            <% String msgInfo = (String) request.getAttribute("msgInfo");
               if(msgInfo != null) { %>
                <div class="alert-success"><i class="fa-solid fa-check-circle"></i> <%= msgInfo %></div>
            <% } %>
            <form action="profile" method="post" class="login-form">
                <input type="hidden" name="action" value="update-info">
                <div class="input-group">
                    <label><fmt:message key="profile.username" /></label>
                    <div class="input-field readonly-field">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" name="username" value="<%= currentUser.getUsername() %>" readonly>
                    </div>
                </div>
                <div class="input-group">
                    <label><fmt:message key="profile.fullname" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-user-pen"></i>
                        <input type="text" name="fullname" value="<%= currentUser.getFullname() %>" required>
                    </div>
                </div>
                <div class="input-group">
                    <label><fmt:message key="profile.email" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" value="<%= currentUser.getEmail() %>" required>
                    </div>
                </div>
                <div class="input-group">
                    <label><fmt:message key="profile.phone" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" name="phone" value="<%= currentUser.getPhonenumber() %>" required>
                    </div>
                </div> 
                <button type="submit" class="btn-login"><fmt:message key="profile.update_btn" /></button>
            </form>
        </div>

        <div class="profile-box">
            <h3 class="profile-title"><i class="fa-solid fa-key"></i> <fmt:message key="profile.password_title" /></h3>
            <% String msgPass = (String) request.getAttribute("msgPass");
               String errPass = (String) request.getAttribute("errPass");
               if(msgPass != null) { %>
                <div class="alert-success"><i class="fa-solid fa-check-circle"></i> <%= msgPass %></div>
            <% } 
               if(errPass != null) { %>
                <div class="alert-error" style="color: red; background: #ffe6e6; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= errPass %>
                </div>
            <% } %>
            <form action="profile" method="post" class="login-form">
                <input type="hidden" name="action" value="change-pass">
                <div class="input-group">
                    <label><fmt:message key="profile.old_pass" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="old_pass" placeholder="***" required>
                    </div>
                </div>
                <div class="input-group">
                    <label><fmt:message key="profile.new_pass" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-key"></i>
                        <input type="password" name="new_pass" placeholder="***" required>
                    </div>
                </div>
                <div class="input-group">
                    <label><fmt:message key="profile.confirm_pass" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-check-double"></i>
                        <input type="password" name="confirm_pass" placeholder="***" required>
                    </div>
                </div>
                <button type="submit" class="btn-login" style="background-color: #555;"><fmt:message key="profile.change_pass_btn" /></button>
            </form>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>