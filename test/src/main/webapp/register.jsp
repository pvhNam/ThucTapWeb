<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng Ký Tài Khoản</title>
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
        <div class="login-wrapper register-wrapper"> <h2>ĐĂNG KÝ</h2>
            <p class="login-subtitle">Tạo tài khoản để nhận nhiều ưu đãi!</p>
            
            <form action="register" method="post" class="login-form">

                <% String mess = (String) request.getAttribute("mess"); 
                   if (mess != null) { %>
                    <div class="alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> <%= mess %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="fullname">Họ và tên</label>
                    <div class="input-field">
                        <i class="fa-solid fa-user-tag"></i>
                        <input type="text" id="fullname" name="fullname" placeholder="Nhập họ tên đầy đủ" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="user">Tên đăng nhập</label>
                    <div class="input-field">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="user" name="user" placeholder="Chọn tên đăng nhập" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="email">Email</label>
                    <div class="input-field">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="phone">Số điện thoại</label>
                    <div class="input-field">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="pass">Mật khẩu</label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="pass" name="pass" placeholder="Tạo mật khẩu" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="re_pass">Xác nhận mật khẩu</label>
                    <div class="input-field">
                        <i class="fa-solid fa-check-double"></i>
                        <input type="password" id="re_pass" name="re_pass" placeholder="Nhập lại mật khẩu" required>
                    </div>
                </div>

                <button type="submit" class="btn-login btn-register">ĐĂNG KÝ NGAY</button>

                <div class="register-link">
                    <p>Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập tại đây</a></p>
                </div>
            </form>
        </div>
    </div>

   <footer >
 <jsp:include page="footer.jsp" />
	</footer>
</body>
</html>