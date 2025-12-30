<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user" %>

<%
    user currentUser = (user) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông Tin Cá Nhân</title>
     <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/style.css" />
    <link rel="stylesheet" href="CSS/login.css" /> 
        <link rel="stylesheet" href="CSS/profile.css" /> 
    
  
</head>
<body>
    <header >
          <jsp:include page="header.jsp"><jsp:param name="page" value="#"/></jsp:include>

    </header>

    <div class="profile-container">
        
        <div class="profile-box">
            <h3 class="profile-title"><i class="fa-solid fa-id-card"></i> Thông tin cá nhân</h3>
            
            <% String msgInfo = (String) request.getAttribute("msgInfo"); 
               if(msgInfo != null) { %>
                <div class="alert-success"><i class="fa-solid fa-check-circle"></i> <%= msgInfo %></div>
            <% } %>

            <form action="profile" method="post" class="login-form">
                <input type="hidden" name="action" value="update-info">
                
                <div class="input-group">
                    <label>Tên đăng nhập</label>
                    <div class="input-field readonly-field">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" name="username" value="<%= currentUser.getUsername() %>" readonly>
                    </div>
                </div>

                <div class="input-group">
                    <label>Họ và tên</label>
                    <div class="input-field">
                        <i class="fa-solid fa-user-pen"></i>
                        <input type="text" name="fullname" value="<%= currentUser.getFullname() %>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Email</label>
                    <div class="input-field">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" value="<%= currentUser.getEmail() %>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Số điện thoại</label>
                    <div class="input-field">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" name="phone" value="<%= currentUser.getPhonenumber() %>" required>
                    </div>
                </div> 

                <button type="submit" class="btn-login">CẬP NHẬT THÔNG TIN</button>
            </form>
        </div>

        <div class="profile-box">
            <h3 class="profile-title"><i class="fa-solid fa-key"></i> Đổi mật khẩu</h3>
            
            <% String msgPass = (String) request.getAttribute("msgPass");
               String errPass = (String) request.getAttribute("errPass");
               
               if(msgPass != null) { %>
                <div class="alert-success"><i class="fa-solid fa-check-circle"></i> <%= msgPass %></div>
            <% } 
               if(errPass != null) { %>
                <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i> <%= errPass %></div>
            <% } %>

            <form action="profile" method="post" class="login-form">
                <input type="hidden" name="action" value="change-pass">

                <div class="input-group">
                    <label>Mật khẩu hiện tại</label>
                    <div class="input-field">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="old_pass" placeholder="Nhập mật khẩu cũ" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Mật khẩu mới</label>
                    <div class="input-field">
                        <i class="fa-solid fa-key"></i>
                        <input type="password" name="new_pass" placeholder="Nhập mật khẩu mới" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <div class="input-field">
                        <i class="fa-solid fa-check-double"></i>
                        <input type="password" name="confirm_pass" placeholder="Nhập lại mật khẩu mới" required>
                    </div>
                </div>

                <button type="submit" class="btn-login" style="background-color: #555;">ĐỔI MẬT KHẨU</button>
            </form>
        </div>
    </div>
 <jsp:include page="footer.jsp" />
    </body>
</html>