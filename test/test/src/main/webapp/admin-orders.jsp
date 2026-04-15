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
<link rel="stylesheet"  href="CSS/AdminOrder.css">
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="orders" />
    </jsp:include>

    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Quản Lý Đơn Hàng</h1>
        </div>

        <%-- Hiển thị thông báo nếu có tham số msg trên URL --%>
        <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-check-circle"></i> 
            <span>Thao tác thành công!</span>
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
                    // Lấy danh sách đơn hàng từ Controller truyền sang
                    List<Order> list = (List<Order>) request.getAttribute("listOrders");
                    DecimalFormat df = new DecimalFormat("#,### VNĐ");

                    if (list != null && !list.isEmpty()) {
                        for (Order o : list) {
                            // Xử lý màu badge trạng thái
                            String st = o.getStatus();
                            String badgeClass = "bg-process"; // Mặc định là chờ xử lý
                            if (st.contains("giao")) badgeClass = "bg-shipping";
                            if (st.contains("thành công")) badgeClass = "bg-success";
                            if (st.contains("hủy")) badgeClass = "bg-cancel";
                    %>
                    <tr>
                        <td><strong>#<%=o.getId()%></strong></td>
                        
                        <td>
                            <div style="font-weight: 500;"><%=o.getUserName()%></div>
                        </td>
                        
                        <td><%=o.getCreatedAt()%></td>
                        
                        <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="<%=o.getAddress()%>">
                            <%=o.getAddress()%>
                        </td>
                        
                        <td class="money"><%=df.format(o.getTotalMoney())%></td>
                        
                        <td><span class="badge <%=badgeClass%>"><%=st%></span></td>

                        <td>
                            <div class="action-group">
                                <a href="order-detail.jsp?id=<%=o.getId()%>" class="btn-action btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <%-- Nút xử lý: Chỉ hiện khi Đang xử lý --%>
                                <% if (st.equals("Đang xử lý")) { %>
                                    <form action="update-order" method="post" style="margin: 0;">
                                        <input type="hidden" name="id" value="<%=o.getId()%>"> 
                                        <input type="hidden" name="action" value="ship">
                                        <button type="submit" class="btn-action btn-ship" title="Xác nhận giao hàng">
                                            <i class="fa-solid fa-truck"></i>
                                        </button>
                                    </form>
                                    
                                    <form action="update-order" method="post" style="margin: 0;">
                                        <input type="hidden" name="id" value="<%=o.getId()%>"> 
                                        <input type="hidden" name="action" value="cancel">
                                        <button type="submit" class="btn-action btn-cancel" title="Hủy đơn hàng" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </form>
                                <% } %>

                                <%-- Nút xử lý: Chỉ hiện khi Đang giao hàng --%>
                                <% if (st.equals("Đang giao hàng")) { %>
                                    <form action="update-order" method="post" style="margin: 0;">
                                        <input type="hidden" name="id" value="<%=o.getId()%>"> 
                                        <input type="hidden" name="action" value="success">
                                        <button type="submit" class="btn-action btn-success" title="Xác nhận giao thành công">
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
                        <td colspan="7" style="text-align: center; padding: 40px; color: #888;">
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