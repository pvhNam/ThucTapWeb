package controller;

import java.io.IOException;
import java.util.List;

import dao.CartDAO;
import dao.ProductDAO;
import dao.VoucherDAO;
import dao.OrderDAO; // Nhớ import cái này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cartItem;
import model.user;
import model.Voucher;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendRedirect("cart");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		user currentUser = (user) session.getAttribute("user");

		// Kiểm tra đăng nhập
		if (currentUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// Lấy giỏ hàng hiện tại
		CartDAO cartDao = new CartDAO();
		List<cartItem> cart = cartDao.getCartByUid(currentUser.getUid());

		if (cart.isEmpty()) {
			response.sendRedirect("cart");
			return;
		}
		// Tính tổng tiền
		double totalMoney = 0;
		for (cartItem item : cart) {
			totalMoney += item.getTotalPrice();
		}

		// Xử lý giảm giá nếu có Voucher
		Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
		if (appliedVoucher != null) {
			// Ví dụ giảm theo số tiền trực tiếp (hoặc % tùy logic bạn muốn)
			if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
				totalMoney = totalMoney * (1 - appliedVoucher.getDiscountAmount() / 100);
			} else {
				totalMoney = totalMoney - appliedVoucher.getDiscountAmount();
			}
			if (totalMoney < 0)
				totalMoney = 0;
		}

		// Lấy địa chỉ
		String address = request.getParameter("address");
		if (address == null || address.trim().isEmpty())
			address = "Địa chỉ mặc định";

		OrderDAO orderDao = new OrderDAO();
		int newOrderId = orderDao.createOrder(currentUser.getUid(), totalMoney, address, cart);
		// Trừ kho sản phẩm
		ProductDAO pDao = new ProductDAO();
		for (cartItem item : cart) {
			pDao.decreaseStock(item.getProduct().getPid(), item.getQuantity());
		}
		// Đánh dấu Voucher đã dùng
		if (appliedVoucher != null) {
			VoucherDAO vDao = new VoucherDAO();
			vDao.markVoucherUsed(currentUser.getUid(), appliedVoucher.getId());
			session.removeAttribute("appliedVoucher");
		}
		// Xóa sạch giỏ hàng
		cartDao.clearCart(currentUser.getUid());
		response.sendRedirect("order-success.jsp?id=" + newOrderId);
	}
}