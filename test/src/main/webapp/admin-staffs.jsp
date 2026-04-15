<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.user" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Danh Sách Nhân Viên | Admin Panel</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/Admin.css">

<style>
/* Bổ sung một chút CSS cho bảng danh sách đẹp hơn */
.user-info-cell {
	display: flex;
	align-items: center;
	gap: 15px;
}

.user-avatar-sm {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
	border: 1px solid #ddd;
}

.user-fullname {
	font-weight: 600;
	color: #333;
}

.user-username {
	font-size: 12px;
	color: #888;
}

.status-tag {
	padding: 5px 12px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: bold;
}

.status-active {
	background-color: #d4edda;
	color: #155724;
}

.action-group {
	display: flex;
	gap: 8px;
	align-items: center;
}

.btn-icon {
	border: none;
	cursor: pointer;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	transition: 0.2s;
}

.btn-icon:hover {
	opacity: 0.8;
}
</style>
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="staffs" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Danh Sách Tài Khoản Nhân Viên</h1>
            
            <%-- KIỂM TRA QUYỀN: CHỈ ADMIN (ROLE = 1) MỚI THẤY NÚT THÊM NHÂN VIÊN NÀY --%>
            <% 
                user curr = (user) session.getAttribute("user");
                Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
                int role = (curr != null) ? curr.getIsAdmin() : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);
                
                if (role == 1) { 
            %>
                <a href="admin-add-staff" class="btn-add-new" style="background: #1cc88a; color: white; padding: 10px 15px; border-radius: 5px; text-decoration: none; font-weight: bold;">
                    <i class="fa-solid fa-user-plus"></i> Cấp thêm tài khoản
                </a>
            <% } %>
        </div>

        <div class="card-box">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Thông tin nhân viên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Thao tác</th> </tr>
                </thead>
                <tbody>
                    <% 
                        // Lấy danh sách từ AdminStaffController truyền sang
                        List<user> list = (List<user>) request.getAttribute("listStaffs");
                        if (list != null && !list.isEmpty()) {
                            for (user u : list) {
                    %>
                    <tr>
                        <td style="font-weight: bold; color: #555;">#<%=u.getUid()%></td>
                        <td>
                            <div class="user-info-cell">
                                <%-- Avatar mặc định nếu nhân viên chưa cập nhật ảnh --%>
                                <img src="img/avatars/<%= (u.getAvatar()!=null && !u.getAvatar().isEmpty()) ? u.getAvatar() : "default.png" %>" class="user-avatar-sm" onerror="this.src='img/images.jpg'">
                                <div>
                                    <div class="user-fullname"><%=u.getFullname() != null ? u.getFullname() : "Chưa cập nhật"%></div>
                                    <div class="user-username">@<%=u.getUsername()%></div>
                                </div>
                            </div>
                        </td>
                        <td><%=u.getEmail()%></td>
                        <td><%= (u.getPhonenumber() != null && !u.getPhonenumber().isEmpty()) ? u.getPhonenumber() : "<span style='color: #ccc; font-style: italic;'>Chưa cập nhật</span>" %></td>
                        <td>
                            <div class="action-group">
                                <% if (role == 1) { // CHỈ ADMIN MỚI ĐƯỢC XÓA VÀ ĐỔI PASS %>
                                    
                                    <button class="btn-icon btn-edit" title="Cấp lại mật khẩu" 
                                            onclick="changePassStaff('<%=u.getUsername()%>')" 
                                            style="background: #f6c23e; color: white; padding: 6px 10px; border-radius: 4px;">
                                        <i class="fa-solid fa-key"></i>
                                    </button>
                                    
                                    <a href="admin-staffs?type=delete&uid=<%=u.getUid()%>" 
                                       class="btn-icon btn-del" title="Xóa nhân viên"
                                       style="background:#e74a3b; color:white; padding: 6px 10px; border-radius:4px; text-decoration: none;"
                                       onclick="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa nhân viên <%=u.getUsername()%> ra khỏi hệ thống không?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>

                                <% } else { // Nhân viên xem danh sách nhau thì chỉ hiện trạng thái %>
                                    <span class="status-tag status-active">Đang hoạt động</span>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%      } 
                        } else { 
                    %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 50px; color: #999;">
                            <i class="fa-solid fa-users-slash" style="font-size: 40px; margin-bottom: 15px; display: block;"></i>
                            Chưa có dữ liệu nhân viên nào trong hệ thống.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <script>
    function changePassStaff(username) {
        let newPass = prompt("Nhập mật khẩu mới cho nhân viên @" + username + ":\n(Lưu ý: Mật khẩu mới phải có ít nhất 6 ký tự)");
        
        if (newPass !== null) { // Nếu không bấm Hủy
            if (newPass.length >= 6) {
               
                window.location.href = "admin-staffs?type=changepass&uname=" + username + "&newpass=" + encodeURIComponent(newPass);
            } else {
                alert("Lỗi: Mật khẩu quá ngắn. Vui lòng nhập từ 6 ký tự trở lên!");
            }
        }
    }
    </script>
</body>
</html>