<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title>Xác thực OTP</title>
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
            <h2>Xác thực OTP</h2>
            <p class="login-subtitle">Mã OTP đã được gửi đến email của bạn</p>

            <form action="validateOtp" method="post" class="login-form">
                
                <% String message = (String) request.getAttribute("message");
                   if (message != null) { 
                       // Kiểm tra xem là thông báo lỗi hay thông báo gửi thành công
                       boolean isError = message.contains("không") || message.contains("sai") || message.contains("Lỗi");
                %>
                    <div class="alert-error" style="<%= isError ? "" : "background-color: #d4edda; color: #155724; border-color: #c3e6cb;" %>">
                        <i class="fa-solid <%= isError ? "fa-circle-exclamation" : "fa-check-circle" %>"></i> 
                        <%= message %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="otp">Nhập mã OTP (6 số)</label>
                    <div class="input-field">
                        <i class="fa-solid fa-key"></i>
                        <input type="number" id="otp" name="otp" placeholder="123456" required>
                    </div>
                </div>

                <button type="submit" class="btn-login">Xác nhận</button>

                <div class="register-link">
                    <p>Chưa nhận được mã? <a href="forgot_password.jsp">Gửi lại</a></p>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <jsp:include page="footer.jsp" />
    </footer>
</body>
</html>