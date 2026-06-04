<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Nhân Viên | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-staffs.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="staffs" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header" style="justify-content: space-between;">
            <h1 class="page-title">Quản Lý Nhân Viên</h1>
            <div style="display:flex; gap: 10px; align-items: center;">
                <a href="admin-add-staff" class="btn-add-new">
                    <i class="fa-solid fa-user-plus"></i> Thêm Nhân Viên
                </a>
            </div>
        </div>

        <% String msg = request.getParameter("msg"); if (msg != null) { %>
            <% if ("deleted".equals(msg)) { %>
            <div class="alert alert-success" style="padding:12px;background:#d4edda;color:#155724;border-radius:6px;margin-bottom:20px;border-left:4px solid #28a745;">
                <i class="fa-solid fa-check-circle"></i> Đã xóa nhân viên thành công!
            </div>
            <% } else if ("pass_changed".equals(msg)) { %>
            <div class="alert alert-success" style="padding:12px;background:#d4edda;color:#155724;border-radius:6px;margin-bottom:20px;border-left:4px solid #28a745;">
                <i class="fa-solid fa-check-circle"></i> Đổi mật khẩu thành công!
            </div>
            <% } else if ("staff_added".equals(msg)) { %>
            <div class="alert alert-success" style="padding:12px;background:#d4edda;color:#155724;border-radius:6px;margin-bottom:20px;border-left:4px solid #28a745;">
                <i class="fa-solid fa-check-circle"></i> Thêm nhân viên thành công!
            </div>
            <% } else if ("error_permission".equals(msg)) { %>
            <div class="alert alert-danger" style="padding:12px;background:#f8d7da;color:#721c24;border-radius:6px;margin-bottom:20px;border-left:4px solid #dc3545;">
                <i class="fa-solid fa-circle-exclamation"></i> Bạn không có quyền thực hiện thao tác này!
            </div>
            <% } %>
        <% } %>

        <div class="card-box">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width:50px;">ID</th>
                        <th>Thông Tin Nhân Viên</th>
                        <th>Email</th>
                        <th>Số Điện Thoại</th>
                        <th style="width:120px; text-align:center;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<User> list = (List<User>) request.getAttribute("listStaffs");
                    if (list != null && !list.isEmpty()) {
                        for (User u : list) {
                            String avatarUrl = (u.getAvatar() != null && !u.getAvatar().isEmpty()) ? "img/avatars/" + u.getAvatar() : "img/images.jpg";
                    %>
                    <tr>
                        <td><strong>#<%=u.getUid()%></strong></td>
                        <td>
                            <div class="user-info-cell">
                                <img src="<%=avatarUrl%>" class="user-avatar-small" onerror="this.src='img/images.jpg'">
                                <div>
                                    <div class="user-name"><%=u.getFullname() != null ? u.getFullname() : "Chưa cập nhật"%></div>
                                    <div class="user-username">@<%=u.getUsername()%></div>
                                </div>
                            </div>
                        </td>
                        <td style="color:#555;"><%=u.getEmail()%></td>
                        <td>
                            <% if (u.getPhonenumber() != null && !u.getPhonenumber().isEmpty()) { %>
                                <%=u.getPhonenumber()%>
                            <% } else { %>
                                <span style="color:#ccc;font-style:italic;">---</span>
                            <% } %>
                        </td>
                        <td style="text-align:center;">
                            <div style="display:flex;gap:6px;justify-content:center;">
                                <button class="btn-icon btn-edit" title="Đổi mật khẩu"
                                    onclick="openChangePass('<%=u.getUsername()%>', '<%=u.getFullname() != null ? u.getFullname() : u.getUsername()%>')">
                                    <i class="fa-solid fa-key"></i>
                                </button>
                                <a href="admin-staffs?type=delete&uid=<%=u.getUid()%>"
                                   class="btn-icon btn-delete" title="Xóa nhân viên"
                                   onclick="return confirm('Bạn có chắc muốn xóa nhân viên này?')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" style="text-align:center;padding:40px;color:#888;">
                            <i class="fa-solid fa-user-slash" style="font-size:30px;margin-bottom:10px;"></i><br>
                            Chưa có nhân viên nào trong hệ thống.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal đổi mật khẩu -->
    <div class="modal-overlay" id="changePassModal">
        <div class="modal-box">
            <h3><i class="fa-solid fa-key"></i> Đổi Mật Khẩu Nhân Viên</h3>
            <p id="modal-staff-name" style="color:#555; margin-bottom:15px;"></p>
            <form action="admin-staffs" method="get" id="changePassForm">
                <input type="hidden" name="type" value="changepass">
                <input type="hidden" name="uname" id="modal-uname">
                <label style="font-weight:600;color:#333;">Mật khẩu mới:</label>
                <input type="password" name="newpass" id="modal-newpass" placeholder="Nhập mật khẩu mới..." required>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel-modal" onclick="closeChangePass()">Hủy</button>
                    <button type="submit" class="btn-confirm"><i class="fa-solid fa-check"></i> Xác nhận</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openChangePass(username, fullname) {
            document.getElementById('modal-uname').value = username;
            document.getElementById('modal-staff-name').textContent = 'Nhân viên: ' + fullname + ' (@' + username + ')';
            document.getElementById('modal-newpass').value = '';
            document.getElementById('changePassModal').classList.add('active');
        }
        function closeChangePass() {
            document.getElementById('changePassModal').classList.remove('active');
        }
        document.getElementById('changePassModal').addEventListener('click', function(e) {
            if (e.target === this) closeChangePass();
        });
    </script>

</body>
</html>
