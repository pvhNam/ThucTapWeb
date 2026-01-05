<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="login.page_title" /></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/login.css" />
</head>
<body>
     <jsp:include page="header.jsp" /> 
    

    <div class="login-container">
        <div class="login-wrapper">
            <h2><fmt:message key="login.heading" /></h2>
            <p class="login-subtitle"><fmt:message key="login.subtitle" /></p>

            <form action="login" method="post" class="login-form">
                <input type="hidden" name="origin" value="<%=request.getParameter("origin") == null ? "" : request.getParameter("origin")%>">

                <% String error = (String) request.getAttribute("error");
                   if (error != null) { %>
                    <div class="alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <%=error%>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="username"><fmt:message key="login.username" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-user"></i> 
                        <input type="text" id="username" name="username" placeholder="<fmt:message key='login.username_placeholder'/>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password"><fmt:message key="login.password" /></label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i> 
                        <input type="password" id="password" name="password" placeholder="<fmt:message key='login.password_placeholder'/>" required>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me"> 
                        <input type="checkbox" name="remember"> <fmt:message key="login.remember_me" />
                    </label> 
                    <a href="#" class="forgot-password"><fmt:message key="login.forgot_password" /></a>
                </div>

                <button type="submit" class="btn-login"><fmt:message key="login.btn_login" /></button>

                <div class="register-link">
                    <p>
                        <fmt:message key="login.no_account" />
                        <a href="register.jsp"><fmt:message key="login.register_now" /></a>
                    </p>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>