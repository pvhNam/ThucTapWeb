<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order, model.user"%>
<%@ page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Lịch Sử Mua Hàng | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<link rel="stylesheet" href="CSS/oder-history.css" />


</head>
<body>
	<header>
		<jsp:include page="header.jsp"><jsp:param name="page"
			value="#" /></jsp:include>
	</header>

	<div class="history-container">
		<h1 class="page-title" style="text-align: left; font-size: 24px;">LỊCH
			SỬ ĐƠN HÀNG</h1>

		<%
		List<Order> list = (List<Order>) request.getAttribute("listOrders");
		DecimalFormat df = new DecimalFormat("#,### VNĐ");

		if (list == null || list.isEmpty()) {
		%>
		<div class="empty-cart" style="text-align: center; padding: 50px;">
			<i class="fa-solid fa-box-open" style="font-size: 40px; color: #ccc;"></i>
			<p>Bạn chưa có đơn hàng nào.</p>
			<a href="index.jsp" class="btn-shop-now">MUA SẮM NGAY</a>
		</div>
		<%
		} else {
		%>

		<table class="order-table">
			<thead>
				<tr>
					<th>Mã đơn (#ID)</th>
					<th>Ngày đặt</th>
					<th>Địa chỉ nhận</th>
					<th>Tổng tiền</th>
					<th>Trạng thái</th>
					<th>Hành động</th>
				</tr>
			</thead>
			<tbody>
				<%
				for (Order o : list) {
					// Xử lý class màu sắc cho trạng thái
					String statusClass = "status-processing";
					if (o.getStatus().contains("hủy") || o.getStatus().contains("Hủy"))
						statusClass = "status-cancelled";
					else if (o.getStatus().contains("Giao") || o.getStatus().contains("Thành công"))
						statusClass = "status-shipped";
				%>
				<tr>
					<td>#<%=o.getId()%></td>
					<td><%=o.getCreatedAt()%></td>
					<td><%=o.getAddress()%></td>
					<td style="font-weight: bold; color: #d00;"><%=df.format(o.getTotalMoney())%></td>
					<td><span class="status-tag <%=statusClass%>"><%=o.getStatus()%></span></td>
					<td><a href="order-detail?id=<%=o.getId()%>"
						class="btn-view-detail">Xem chi tiết</a></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
		<%
		}
		%>
	</div>

	<footer >
	<jsp:include page="footer.jsp" />

	</footer>
</body>
</html>