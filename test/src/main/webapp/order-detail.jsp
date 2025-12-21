<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List, dao.OrderDAO, model.OrderDetail, model.Order, java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi Tiết Đơn Hàng</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css" />
<style>
body {
	background: #f4f6f9;
	font-family: sans-serif;
}

.detail-container {
	max-width: 900px;
	margin: 40px auto;
	background: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

.head-title {
	font-size: 22px;
	font-weight: bold;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 2px solid #eee;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

/* Box thông tin khách hàng */
.customer-info {
	background: #f8f9fa;
	padding: 15px;
	border-radius: 6px;
	margin-bottom: 20px;
	border: 1px solid #e9ecef;
}

.info-row {
	margin-bottom: 8px;
	font-size: 15px;
	color: #333;
}

.info-row strong {
	width: 100px;
	display: inline-block;
	color: #555;
}

/* Bảng sản phẩm */
.detail-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

.detail-table th {
	background: #343a40;
	color: white;
	padding: 12px;
	text-align: left;
	font-size: 14px;
}

.detail-table td {
	padding: 12px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
}

.img-thumb {
	width: 50px;
	height: 60px;
	object-fit: cover;
	border-radius: 4px;
	border: 1px solid #ddd;
	margin-right: 15px;
}

.total-row {
	font-size: 18px;
	font-weight: bold;
	color: #d00000;
	text-align: right;
	padding-top: 20px;
}

.btn-back {
	display: inline-block;
	margin-top: 20px;
	text-decoration: none;
	color: #666;
	font-weight: 600;
	padding: 8px 15px;
	border: 1px solid #ddd;
	border-radius: 4px;
	transition: 0.2s;
}

.btn-back:hover {
	background: #333;
	color: white;
}
</style>
</head>
<body>

	<div class="detail-container">
		<%
		String idParam = request.getParameter("id");
		if (idParam != null) {
			int orderId = Integer.parseInt(idParam);
			OrderDAO dao = new OrderDAO();

			// 1. Lấy thông tin Header đơn hàng (Khách, SĐT, Địa chỉ)
			Order order = dao.getOrderById(orderId);

			// 2. Lấy danh sách sản phẩm
			List<OrderDetail> list = dao.getDetails(orderId);

			if (order != null) {
		%>

		<div class="head-title">
			<span><i class="fa-solid fa-file-invoice"></i> Đơn Hàng #<%=order.getId()%></span>
			<span
				style="font-size: 14px; background: #e2e6ea; padding: 5px 10px; border-radius: 4px;">
				<%=order.getStatus()%>
			</span>
		</div>

		<div class="customer-info">
			<div class="info-row">
				<strong>Người đặt:</strong>
				<%=order.getUserName()%></div>
			<div class="info-row">
				<strong>SĐT:</strong> <span
					style="color: #d00000; font-weight: bold;"><%=order.getPhoneNumber()%></span>
			</div>
			<div class="info-row">
				<strong>Địa chỉ:</strong>
				<%=order.getAddress()%></div>
			<div class="info-row">
				<strong>Ngày đặt:</strong>
				<%=order.getCreatedAt()%></div>
		</div>

		<h3 style="font-size: 16px; margin-bottom: 10px;">Danh Sách Sản
			Phẩm</h3>
		<table class="detail-table">
			<thead>
				<tr>
					<th>Sản phẩm</th>
					<th>Đơn giá</th>
					<th>Số lượng</th>
					<th>Thành tiền</th>
				</tr>
			</thead>
			<tbody>
				<%
				DecimalFormat df = new DecimalFormat("#,### VNĐ");
				double grandTotal = 0;

				for (OrderDetail item : list) {
					double total = item.getPrice() * item.getQuantity();
					grandTotal += total;
				%>
				<tr>
					<td style="display: flex; align-items: center;"><img
						src="<%=item.getProduct().getImage()%>" class="img-thumb">
						<div>
							<div style="font-weight: 600;"><%=item.getProduct().getPdescription()%></div>
							<small style="color: #777;">Size: <%=item.getProduct().getSize()%>
								| Màu: <%=item.getProduct().getColor()%></small>
						</div></td>
					<td><%=df.format(item.getPrice())%></td>
					<td>x <%=item.getQuantity()%></td>
					<td style="font-weight: bold;"><%=df.format(total)%></td>
				</tr>
				<%
				}
				%>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="4" class="total-row">Tổng Tiền: <%=df.format(grandTotal)%>
					</td>
				</tr>
			</tfoot>
		</table>

		<%
		} else {
		%>
		<p style="text-align: center; padding: 20px;">Không tìm thấy thông
			tin đơn hàng.</p>
		<%
		}
		} else {
		%>
		<p style="text-align: center; padding: 20px;">Mã đơn hàng không
			hợp lệ.</p>
		<%
		}
		%>

		<a href="javascript:history.back()" class="btn-back"><i
			class="fa-solid fa-arrow-left"></i> Quay lại</a>
	</div>

</body>
</html>
