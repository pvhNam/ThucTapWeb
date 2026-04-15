<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
<meta charset="UTF-8">
<title><fmt:message key="register.page_title" /></title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/login.css" /> 
</head>
<body>
    <header>
        <jsp:include page="header.jsp"><jsp:param name="page" value="#"/></jsp:include>
    </header>

    <div class="login-container">
        <div class="login-wrapper register-wrapper"> 
            <h2><fmt:message key="register.heading" /></h2>
            <p class="login-subtitle"><fmt:message key="register.subtitle" /></p>
            
            <form action="register" method="post" class="login-form">

                <% String mess = (String) request.getAttribute("mess");
                   if (mess != null) { %>
                    <div class="alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> <%= mess %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="fullname"><fmt:message key="register.fullname" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-user-tag"></i>
                        <input type="text" id="fullname" name="fullname" placeholder="<fmt:message key='register.fullname_placeholder'/>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="user"><fmt:message key="register.username" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="user" name="user" placeholder="<fmt:message key='register.username_placeholder'/>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="email"><fmt:message key="register.email" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="phone"><fmt:message key="register.phone" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" id="phone" name="phone" placeholder="<fmt:message key='register.phone_placeholder'/>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="pass"><fmt:message key="register.password" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="pass" name="pass" placeholder="<fmt:message key='register.password_placeholder'/>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="re_pass"><fmt:message key="register.confirm_password" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-check-double"></i>
                        <input type="password" id="re_pass" name="re_pass" placeholder="<fmt:message key='register.confirm_password_placeholder'/>" required>
                    </div>
                </div>

                <button type="submit" class="btn-login btn-register"><fmt:message key="register.btn_submit" /></button>

                <div class="register-link">
                    <p><fmt:message key="register.have_account" /> <a href="login.jsp"><fmt:message key="register.login_link" /></a></p>
                </div>
            </form>
        </div>
    </div>

   <footer>
        <jsp:include page="footer.jsp" />
   </footer>
</body>
</html>