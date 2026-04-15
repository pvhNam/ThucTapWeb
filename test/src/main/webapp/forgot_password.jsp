<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/login.css" />
</head>
<body>
    <header>
        <jsp:include page="header.jsp" />
    </header>

    <div class="login-container">
        <div class="login-wrapper">
            <h2>Quên mật khẩu</h2>
            <p class="login-subtitle">Nhập email của bạn để nhận mã xác thực</p>

            <form action="forgotPassword" method="post" class="login-form">
                
                <% String message = (String) request.getAttribute("message");
                   if (message != null) { %>
                    <div class="alert-error" style="background-color: #e8f0fe; color: #1967d2; border: 1px solid #1967d2;">
                        <i class="fa-solid fa-circle-info"></i> <%= message %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="email">Email đăng ký</label>
                    <div class="input-field">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
                    </div>
                </div>

                <button type="submit" class="btn-login">Gửi OTP</button>

                <div class="register-link">
                    <p>Quay lại trang <a href="login.jsp">Đăng nhập</a></p>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <jsp:include page="footer.jsp" />
    </footer>
</body>
</html>