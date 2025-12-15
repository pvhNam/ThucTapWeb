<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.user" %>

<%
    // KIỂM TRA ĐĂNG NHẬP: Nếu chưa đăng nhập thì đá về trang login
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
    
    <style>
        .profile-container {
            display: flex;
            justify-content: center;
            gap: 30px;
            padding: 50px 20px;
            background-color: #f5f5f5;
            flex-wrap: wrap;
        }
        .profile-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            width: 450px;
        }
        .profile-title {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
            padding-bottom: 10px;
        }
        .readonly-field {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <header class="header">
        <img src="img/logover2_5.png" alt="Logo" class="logo" width="80">
   <nav class="menu">
            <a href="index.jsp" class="active">TRANG CHỦ</a> 
            <a href="collection.jsp">BỘ SƯU TẬP</a> 
            <a href="about.jsp">GIỚI THIỆU</a> 
            <a href="news.jsp">TIN TỨC</a>
        </nav>
        <div class="actions">
            <div class="account">
                <span>Xin chào, <b><%= currentUser.getFullname() %></b></span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></a>
            </div>
        </div>
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

    </body>
</html>