<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.time.LocalDate"%>

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
    
    /* CSS thêm cho phần báo cáo */
    .export-section { display: flex; gap: 30px; flex-wrap: wrap; }
    .export-group { display: flex; align-items: center; gap: 10px; padding: 10px; background: #f8f9fa; border-radius: 8px; border: 1px dashed #ccc; }
    .btn-excel { padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; color: white; transition: 0.3s; font-weight: 500;}
    .btn-green { background: #28a745; }
    .btn-blue { background: #17a2b8; }
    .btn-excel:hover { opacity: 0.9; transform: translateY(-1px); }
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
            // Lấy dữ liệu thống kê từ Servlet (DashboardController)
            int totalOrders = request.getAttribute("totalOrders") != null ? (int) request.getAttribute("totalOrders") : 0;
            double totalRevenue = request.getAttribute("totalRevenue") != null ? (double) request.getAttribute("totalRevenue") : 0.0;
            int countProcessing = request.getAttribute("countProcessing") != null ? (int) request.getAttribute("countProcessing") : 0;
            int countCancel = request.getAttribute("countCancel") != null ? (int) request.getAttribute("countCancel") : 0;
            
            // Format tiền tệ
            DecimalFormat df = new DecimalFormat("#,### VNĐ");
            int currentYear = LocalDate.now().getYear();
            int currentMonth = LocalDate.now().getMonthValue();
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

        <div class="card-box" style="margin-bottom: 30px;">
            <div class="chart-title" style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                <i class="fa-solid fa-file-excel" style="color: #28a745; margin-right: 8px;"></i> Xuất Báo Cáo Doanh Thu
            </div>
            
            <div class="export-section">
                <div class="export-group">
                    <form action="admin-export-report" method="get" style="display: flex; align-items: center; gap: 10px; margin: 0;">
                        <input type="hidden" name="type" value="daily">
                        <label style="font-weight: 500; font-size: 14px;">📅 Theo ngày:</label>
                        <input type="date" name="date" required style="padding: 6px; border: 1px solid #ddd; border-radius: 5px;">
                        <button type="submit" class="btn-excel btn-green">
                            <i class="fa-solid fa-download"></i> Tải về
                        </button>
                    </form>
                </div>

                <div class="export-group">
                    <form action="admin-export-report" method="get" style="display: flex; align-items: center; gap: 10px; margin: 0;">
                        <input type="hidden" name="type" value="monthly">
                        <label style="font-weight: 500; font-size: 14px;">📊 Theo tháng:</label>
                        
                        <select name="month" style="padding: 6px; border: 1px solid #ddd; border-radius: 5px;">
                            <% for(int i=1; i<=12; i++) { %>
                                <option value="<%=i%>" <%= i == currentMonth ? "selected" : "" %>>Tháng <%=i%></option>
                            <% } %>
                        </select>

                        <input type="number" name="year" value="<%= currentYear %>" style="width: 70px; padding: 6px; border: 1px solid #ddd; border-radius: 5px;">
                        
                        <button type="submit" class="btn-excel btn-blue">
                            <i class="fa-solid fa-download"></i> Tải về
                        </button>
                    </form>
                </div>
            </div>
        </div>

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
                    List<Order> list = (List<Order>) request.getAttribute("listOrders");
					if (list != null && !list.isEmpty()) {
						for (Order o : list) {
							String st = o.getStatus();
							String badgeClass = "bg-process";
							if (st != null) {
								if (st.contains("giao") || st.contains("ship")) badgeClass = "bg-shipping";
								if (st.contains("thành công") || st.contains("HT")) badgeClass = "bg-success";
								if (st.contains("hủy")) badgeClass = "bg-cancel";
							} else { st = "Không xác định"; }
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
								<a href="order-detail?id=<%=o.getId()%>" class="btn-action btn-view" title="Xem chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
								<% if ("Đang xử lý".equals(st)) { %>
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