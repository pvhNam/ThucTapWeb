<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Dashboard Admin | Fashion Store</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/Admin.css">

<style>
    /* CSS cho 4 thẻ thống kê */
    .stats-cards { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
    .card-stat { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .stat-info h3 { font-size: 28px; margin: 0; color: #333; }
    .stat-info p { margin: 5px 0 0; color: #777; font-size: 14px; }
    .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    .icon-blue { background: #e3f2fd; color: #2196f3; }
    .icon-green { background: #e8f5e9; color: #4caf50; }
    .icon-orange { background: #fff3e0; color: #ff9800; }
    .icon-red { background: #ffebee; color: #f44336; }
</style>
</head>
<body>

	<jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="dashboard" />
    </jsp:include>

	<main class="main-content">
		<div class="content-header">
			<h1 class="page-title">Dashboard & Thống Kê</h1>
			<div class="user-info">
				<i class="fa-regular fa-circle-user"></i> Xin chào, Administrator
			</div>
		</div>

        <%
            // Lấy các biến Attribute
            int totalOrders = (int) request.getAttribute("totalOrders");
            double totalRevenue = (double) request.getAttribute("totalRevenue");
            int countProcessing = (int) request.getAttribute("countProcessing");
            int countCancel = (int) request.getAttribute("countCancel");
            
            // Format tiền tệ
            DecimalFormat df = new DecimalFormat("#,### VNĐ");
        %>

		<div class="stats-cards">
			<div class="card-stat">
				<div class="stat-info">
					<h3><%= totalOrders %></h3>
					<p>Tổng đơn hàng</p>
				</div>
				<div class="stat-icon icon-blue"><i class="fa-solid fa-cart-shopping"></i></div>
			</div>
			
			<div class="card-stat">
				<div class="stat-info">
					<h3 style="color: #28a745;"><%= df.format(totalRevenue) %></h3>
					<p>Doanh thu thực</p>
				</div>
				<div class="stat-icon icon-green"><i class="fa-solid fa-sack-dollar"></i></div>
			</div>
			
			<div class="card-stat">
				<div class="stat-info">
					<h3><%= countProcessing %></h3>
					<p>Đang chờ xử lý</p>
				</div>
				<div class="stat-icon icon-orange"><i class="fa-solid fa-clock"></i></div>
			</div>
			
			<div class="card-stat">
				<div class="stat-info">
					<h3><%= countCancel %></h3>
					<p>Đơn bị hủy</p>
				</div>
				<div class="stat-icon icon-red"><i class="fa-solid fa-ban"></i></div>
			</div>
		</div>

        <% if (request.getParameter("msg") != null) { %>
		<div class="alert alert-success" style="padding: 15px; background: #d4edda; color: #155724; border-radius: 4px; margin-bottom: 20px;">
			<i class="fa-solid fa-check-circle"></i> Thao tác thành công!
		</div>
		<% } %>

        <div class="card-box">
			<div class="chart-title" style="margin-bottom: 20px; font-weight: bold; color: #444;">
                Danh sách đơn hàng gần đây
            </div>
			<table class="admin-table">
				<thead>
					<tr>
						<th>ID</th>
						<th>Khách Hàng</th>
						<th>Ngày Đặt</th>
						<th>Địa Chỉ</th>
						<th>Tổng Tiền</th>
						<th>Trạng Thái</th>
						<th>Thao Tác</th>
					</tr>
				</thead>
				<tbody>
					<%
                    // Lấy lại list để vẽ bảng
                    List<Order> list = (List<Order>) request.getAttribute("listOrders");
                    
					if (list != null && !list.isEmpty()) {
						for (Order o : list) {
							String st = o.getStatus();
							String badgeClass = "bg-process";
							if (st.contains("giao")) badgeClass = "bg-shipping";
							if (st.contains("thành công")) badgeClass = "bg-success";
							if (st.contains("hủy")) badgeClass = "bg-cancel";
					%>
					<tr>
						<td><strong>#<%=o.getId()%></strong></td>
						<td><%=o.getUserName()%></td>
						<td><%=o.getCreatedAt()%></td>
						<td><%=o.getAddress()%></td>
						<td class="money"><%=df.format(o.getTotalMoney())%></td>
						<td><span class="badge <%=badgeClass%>"><%=st%></span></td>
						<td>
							<div class="action-group">
								<a href="order-detail.jsp?id=<%=o.getId()%>" class="btn-action btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
								<% if (st.equals("Đang xử lý")) { %>
									<form action="update-order" method="post" style="margin: 0;">
										<input type="hidden" name="id" value="<%=o.getId()%>"> 
										<input type="hidden" name="action" value="ship">
										<button class="btn-action btn-ship" title="Giao hàng"><i class="fa-solid fa-truck"></i></button>
									</form>
								<% } %>
							</div>
						</td>
					</tr>
					<% } } else { %>
					<tr><td colspan="7" style="text-align: center; padding: 30px;">Chưa có đơn hàng nào.</td></tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</main>
</body>
</html>