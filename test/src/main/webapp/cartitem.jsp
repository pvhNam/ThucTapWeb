<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List, model.cartItem, model.Voucher, java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Giỏ Hàng | Fashion Store</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="CSS/style.css">
<link rel="stylesheet" href="CSS/cart.css">

</head>
<body>
	<jsp:include page="header.jsp" />

	<%
	DecimalFormat df = new DecimalFormat("#,### VNĐ");
	List<cartItem> cartList = (List<cartItem>) request.getAttribute("cartList");
	// Lấy danh sách voucher từ ví người dùng được gửi từ Controller
	List<Voucher> myVouchers = (List<Voucher>) request.getAttribute("myVouchers");
	%>

	<div class="cart-wrapper">
		<h1 class="page-title">GIỎ HÀNG CỦA BẠN</h1>

		<div class="cart-layout">
			<div class="cart-items-section">
				<%
				if (cartList != null && !cartList.isEmpty()) {
					for (cartItem item : cartList) {
				%>
				<div class="cart-card">
					<div class="card-img">
						<img src="<%=item.getProduct().getImage()%>">
					</div>
					<div class="card-details">
						<h3><%=item.getProduct().getPdescription()%></h3>
						<p><%=df.format(item.getProduct().getPrice())%></p>
						<div class="card-actions">
							<span>Số lượng: <%=item.getQuantity()%></span> <span
								class="item-total"><%=df.format(item.getTotalPrice())%></span>
						</div>
					</div>
				</div>
				<%
				}
				} else {
				%>
				<div class="empty-cart">
					<p>Giỏ hàng trống.</p>
					<a href="index.jsp" class="btn-shop-now">MUA SẮM NGAY</a>
				</div>
				<%
				}
				%>
			</div>

			<div class="cart-summary-section">
				<div class="summary-box" style="margin-bottom: 20px;">
					<h3>MÃ GIẢM GIÁ</h3>

					<form action="cart" method="post" style="display: flex; gap: 10px;">
						<input type="hidden" name="action" value="apply_voucher">
						<input type="text" name="voucherCode" id="voucherInput"
							placeholder="Nhập mã..." required
							style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
						<button type="submit" class="btn-add-cart"
							style="width: auto; padding: 0 15px; margin: 0;">ÁP DỤNG</button>
					</form>

					<%-- PHẦN HIỂN THỊ VOUCHER ĐÃ LƯU --%>
					<%-- PHẦN HIỂN THỊ VÍ VOUCHER THIẾT KẾ MỚI --%>
					<%
					if (myVouchers != null && !myVouchers.isEmpty()) {
					%>
					<div class="voucher-wallet-container">
						<span class="wallet-header"> <i class="fa-solid fa-ticket"></i>
							Voucher của bạn
						</span>
						<div class="voucher-scroll-list">
							<%
							for (Voucher v : myVouchers) {
							%>
							<div class="mini-voucher-card">
								<div class="v-tag">
									<span class="v-amount"> <%="PERCENT".equals(v.getDiscountType()) ? (int) v.getDiscountAmount() + "%"
		: (int) (v.getDiscountAmount() / 1000) + "K"%>
									</span>
								</div>
								<div class="v-details">
									<strong class="v-code"><%=v.getCode()%></strong>
									<p class="v-condition">
										Đơn từ
										<%=df.format(v.getMinOrder())%></p>
								</div>
								<form action="cart" method="post" class="v-action">
									<input type="hidden" name="action" value="apply_voucher">
									<input type="hidden" name="voucherCode"
										value="<%=v.getCode()%>">
									<button type="submit" class="btn-use-now">Dùng</button>
								</form>
							</div>
							<%
							}
							%>
						</div>
					</div>
					<%
					}
					%>


					<%
					if (session.getAttribute("voucherMsg") != null) {
					%>
					<p style="color: red; font-size: 13px; margin-top: 10px;"><%=session.getAttribute("voucherMsg")%></p>
					<%
					session.removeAttribute("voucherMsg");
					%>
					<%
					}
					%>
				</div>

				<div class="summary-box">
					<h3>TỔNG ĐƠN HÀNG</h3>
					<form action="checkout" method="post">
						<div class="summary-row">
							<span>Tạm tính:</span> <span><%=request.getAttribute("subtotal") != null ? df.format(request.getAttribute("subtotal")) : "0 VNĐ"%></span>
						</div>

						<%
						if (request.getAttribute("discountAmount") != null && (Double) request.getAttribute("discountAmount") > 0) {
						%>
						<div class="summary-row" style="color: #27ae60;">
							<span>Giảm giá:</span> <span>- <%=df.format(request.getAttribute("discountAmount"))%></span>
						</div>
						<%
						}
						%>

						<div class="summary-row total-final">
							<span>Tổng cộng:</span> <span><%=request.getAttribute("finalTotal") != null ? df.format(request.getAttribute("finalTotal")) : "0 VNĐ"%></span>
						</div>

						<div class="address-box">
							<label>Địa chỉ nhận hàng:</label>
							<textarea name="address" required
								placeholder="Số nhà, tên đường..."></textarea>
						</div>

						<button type="submit" class="btn-checkout">XÁC NHẬN THANH
							TOÁN</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp" />
</body>
</html>