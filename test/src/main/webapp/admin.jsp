<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Dashboard Admin | Fashion Store</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"  href="CSS/Admin.css">
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
		// --- 1. JAVA LOGIC: TÍNH TOÁN SỐ LIỆU TỪ LIST ---
		List<Order> list = (List<Order>) request.getAttribute("listOrders");
		DecimalFormat df = new DecimalFormat("#,### VNĐ");
		
		double totalRevenue = 0;
		int totalOrders = 0;
		
		// Biến đếm cho biểu đồ tròn (Pie Chart)
		int countSuccess = 0;
		int countShipping = 0;
		int countProcessing = 0;
		int countCancel = 0;

		if (list != null && !list.isEmpty()) {
			totalOrders = list.size();
			for (Order o : list) {
				String s = o.getStatus();
				
				if (s.contains("thành công")) {
					totalRevenue += o.getTotalMoney();
					countSuccess++;
				} else if (s.contains("giao")) {
					countShipping++;
				} else if (s.contains("hủy")) {
					countCancel++;
				} else {
					countProcessing++;
				}
			}
		}
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

		<div class="charts-section">
			<div class="chart-container">
				<div class="chart-title">Biểu đồ doanh thu 6 tháng gần đây</div>
				<canvas id="revenueChart"></canvas>
			</div>
			
			<div class="chart-container">
				<div class="chart-title">Tỉ lệ trạng thái đơn hàng</div>
				<canvas id="statusChart"></canvas>
			</div>
		</div>

		<% if (request.getParameter("msg") != null) { %>
		<div class="alert alert-success">
			<i class="fa-solid fa-check-circle"></i> Thao tác thành công!
		</div>
		<% } %>

		<div class="card-box">
			<div class="chart-title" style="margin-bottom: 20px;">Danh sách đơn hàng mới nhất</div>
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
								<a href="order-detail.jsp?id=<%=o.getId()%>" class="btn-action btn-view"><i class="fa-solid fa-eye"></i></a>
								<% if (st.equals("Đang xử lý")) { %>
									<form action="update-order" method="post" style="margin: 0;">
										<input type="hidden" name="id" value="<%=o.getId()%>"> 
										<input type="hidden" name="action" value="ship">
										<button class="btn-action btn-ship"><i class="fa-solid fa-truck"></i></button>
									</form>
								<% } %>
							</div>
						</td>
					</tr>
					<% } } else { %>
					<tr><td colspan="7" style="text-align: center;">Chưa có dữ liệu.</td></tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</main>

	<script>
		// --- Biểu đồ Tròn (Dữ liệu THẬT lấy từ biến Java) ---
		const ctxPie = document.getElementById('statusChart');
		
		new Chart(ctxPie, {
			type: 'doughnut',
			data: {
				labels: ['Thành công', 'Đang giao', 'Đang xử lý', 'Đã hủy'],
				datasets: [{
					label: 'Số lượng đơn',
					// Sử dụng Expression Tag của JSP để in giá trị Java vào JavaScript
					data: [<%=countSuccess%>, <%=countShipping%>, <%=countProcessing%>, <%=countCancel%>],
					backgroundColor: [
						'#28a745', // Xanh lá
						'#17a2b8', // Xanh dương nhạt
						'#ffc107', // Vàng
						'#dc3545'  // Đỏ
					],
					borderWidth: 1
				}]
			},
			options: {
				responsive: true,
				plugins: {
					legend: { position: 'bottom' }
				}
			}
		});

		// --- Biểu đồ Cột (Dữ liệu TĨNH - Mock Data) ---
		const ctxBar = document.getElementById('revenueChart');

		new Chart(ctxBar, {
			type: 'bar',
			data: {
				labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
				datasets: [{
					label: 'Doanh thu (Triệu VNĐ)',
					data: [12, 19, 15, 25, 22, 30], // Số liệu giả định
					backgroundColor: '#3498db',
					borderRadius: 5
				}]
			},
			options: {
				scales: { y: { beginAtZero: true } }
			}
		});
	</script>

</body>
</html>