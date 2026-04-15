<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User, model.Order, java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi Tiết Khách Hàng | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/admin-user-detail.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="users" />
    </jsp:include>

    <main class="main-content">
        <a href="admin-users" class="btn-back"><i class="fa-solid fa-arrow-left"></i> &nbsp; Quay lại danh sách</a>

        <%
            User u = (User) request.getAttribute("userInfo");
            List<Order> orders = (List<Order>) request.getAttribute("userOrders");
            DecimalFormat df = new DecimalFormat("#,### VNĐ");
            if(u != null) {
        %>

        <h2 class="page-title" style="margin-bottom: 20px;">Hồ Sơ: <%=u.getFullname()%></h2>

        <div class="detail-card">
            <h3 style="color: #3498db; margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                <i class="fa-solid fa-id-card"></i> Thông Tin Cá Nhân
            </h3>
            <div class="info-row"><span class="info-label">Họ tên:</span> <span><%=u.getFullname()%></span></div>
            <div class="info-row"><span class="info-label">Username:</span> <span><%=u.getUsername()%></span></div>
            <div class="info-row"><span class="info-label">Email:</span> <span><%=u.getEmail()%></span></div>
            <div class="info-row"><span class="info-label">Số điện thoại:</span> <span><%=u.getPhonenumber()%></span></div>
        </div>

        <div class="card-box">
            <h3 style="color: #28a745; margin-top: 0; margin-bottom: 15px;">
                <i class="fa-solid fa-clock-rotate-left"></i> Lịch Sử Đơn Hàng (<%=orders != null ? orders.size() : 0%>)
            </h3>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Ngày Đặt</th>
                        <th>Địa Chỉ</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Chi Tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders != null && !orders.isEmpty()) {
                        for (Order o : orders) {
                            String st = o.getStatus();
                            String badge = "bg-process";
                            if(st!=null && st.contains("giao")) badge="bg-shipping";
                            if(st!=null && st.contains("thành công")) badge="bg-success";
                            if(st!=null && st.contains("hủy")) badge="bg-cancel";
                    %>
                    <tr>
                        <td><strong>#<%=o.getId()%></strong></td>
                        <td><%=o.getCreatedAt()%></td>
                        <td><%=o.getAddress()%></td>
                        <td class="money"><%=df.format(o.getTotalMoney())%></td>
                        <td><span class="badge <%=badge%>"><%=st%></span></td>
                        <td>
                            <a href="order-detail?id=<%=o.getId()%>" class="btn-action btn-view" title="Xem chi tiết">
                                <i class="fa-solid fa-eye"></i>
                            </a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" style="text-align: center; color: #999;">Khách hàng chưa có đơn hàng nào.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% } else { %>
            <div class="alert alert-danger">Không tìm thấy thông tin khách hàng!</div>
        <% } %>
    </main>
</body>
</html>
