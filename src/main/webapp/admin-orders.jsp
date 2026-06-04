<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Đơn Hàng | Admin</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css">
<link rel="stylesheet" href="CSS/admin/AdminOrder.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="orders" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Quản Lý Đơn Hàng</h1>
        </div>

        <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-check-circle"></i>
            <span>Thao tác thành công!</span>
        </div>
        <% } %>

        <%
            String filterParam = (String) request.getAttribute("filter");
            String filterName = null;
            String filterColor = "#4e73df";

            if ("processing".equals(filterParam)) {
                filterName = "Đang xử lý";
                filterColor = "#f6c23e";
            } else if ("shipping".equals(filterParam)) {
                filterName = "Đang giao hàng";
                filterColor = "#36b9cc";
            } else if ("cancel".equals(filterParam)) {
                filterName = "Đã hủy / thất bại";
                filterColor = "#e74a3b";
            } else if ("success".equals(filterParam)) {
                filterName = "Giao thành công";
                filterColor = "#1cc88a";
            }
        %>
        <% if (filterName != null) { %>
        <div class="filter-bar">
            <span class="filter-tag" style="border-color: <%=filterColor%>; color: <%=filterColor%>;">
                <i class="fa-solid fa-filter"></i>
                Lọc: <strong><%=filterName%></strong>
                &nbsp;|&nbsp; <%=((java.util.List)request.getAttribute("listOrders")).size()%> don
            </span>
            <a href="admin-orders" class="btn-clear-filter">
                <i class="fa-solid fa-xmark"></i> Xem tất cả
            </a>
        </div>
        <% } %>

        <div class="card-box">
            <table class="admin-table">
                <thead>
                    <tr>
						<th>Mã Đơn</th>
						<th>Khách Hàng</th>
						<th>Ngày Đặt</th>
						<th>Địa Chỉ</th>
						<th>Tổng Tiền</th>
						<th>Trạng Thái</th>
						<th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Order> list = (List<Order>) request.getAttribute("listOrders");
                    DecimalFormat df = new DecimalFormat("#,### VND");

                    if (list != null && !list.isEmpty()) {
                        for (Order order : list) {
                    %>
                    <tr>
                        <td><strong>#<%=order.getId()%></strong></td>

                        <td>
                            <div style="font-weight: 500;"><%=order.getUserName()%></div>
                            <small style="color: #888;"><%=order.getPhoneNumber()%></small>
                        </td>

                        <td><%=order.getCreatedAt()%></td>

                        <td style="max-width: 220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="<%=order.getAddress()%>">
                            <%=order.getAddress()%>
                        </td>

                        <td class="money"><%=df.format(order.getTotalMoney())%></td>
                        <td><%=order.getPaymentMethod()%></td>
                        <td><span class="badge <%=order.getAdminBadgeClass()%>"><%=order.getDisplayStatus()%></span></td>

                        <td>
                            <div class="action-group">
                                <a href="order-detail?id=<%=order.getId()%>" class="btn-action btn-view" title="Xem chi tiet">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <% if (order.isShippableStatus()) { %>
                                <form action="update-order" method="post" style="margin: 0;">
                                    <input type="hidden" name="id" value="<%=order.getId()%>">
                                    <input type="hidden" name="action" value="ship">
                                    <button type="submit" class="btn-action btn-ship" title="Chuyen sang dang giao hang">
                                        <i class="fa-solid fa-truck"></i>
                                    </button>
                                </form>
                                <% } %>

                                <% if (order.isAdminCancelableStatus()) { %>
                                <form action="update-order" method="post" style="margin: 0;">
                                    <input type="hidden" name="id" value="<%=order.getId()%>">
                                    <input type="hidden" name="action" value="cancel">
                                    <button type="submit" class="btn-action btn-cancel" title="Huy don hang"
                                            onclick="return confirm('Ban co chac chan muon huy don hang nay?')">
                                        <i class="fa-solid fa-xmark"></i>
                                    </button>
                                </form>
                                <% } %>

                                <% if (order.isShippingStatus()) { %>
                                <form action="update-order" method="post" style="margin: 0;">
                                    <input type="hidden" name="id" value="<%=order.getId()%>">
                                    <input type="hidden" name="action" value="success">
                                    <button type="submit" class="btn-action btn-success" title="Xac nhan giao thanh cong">
                                        <i class="fa-solid fa-check"></i>
                                    </button>
                                </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #888;">
                            <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
                            Chưa có đơn hàng nào trong hệ thống.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
