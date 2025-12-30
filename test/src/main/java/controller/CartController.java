package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CartDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cartItem;
import model.user;
import model.Voucher;

@WebServlet("/cart")
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		user currentUser = (user) session.getAttribute("user");
		List<cartItem> cart = new ArrayList<>();
		List<Voucher> myVouchers = new ArrayList<>();

		// LẤY GIỎ HÀNG
		if (currentUser != null) {
			CartDAO dao = new CartDAO();
			cart = dao.getCartByUid(currentUser.getUid());

			VoucherDAO vDao = new VoucherDAO();
			myVouchers = vDao.getVouchersByUid(currentUser.getUid());
		} else {
			cart = (List<cartItem>) session.getAttribute("cart");
			if (cart == null)
				cart = new ArrayList<>();
		}

		// TÍNH TỔNG TIỀN
		double subtotal = 0;
		for (cartItem item : cart) {
			subtotal += item.getTotalPrice();
		}

		// TÍNH GIẢM GIÁ
		double discountAmount = 0;
		Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");

		// Kiểm tra lại điều kiện mã
		if (appliedVoucher != null) {
			if (cart.isEmpty()) {
				session.removeAttribute("appliedVoucher");
				session.removeAttribute("voucherMsg");
			} else if (subtotal < appliedVoucher.getMinOrder()) {
				session.removeAttribute("appliedVoucher");
				session.setAttribute("voucherMsg", "Mã " + appliedVoucher.getCode() + " đã bị hủy do đơn hàng chưa đủ "
						+ (long) appliedVoucher.getMinOrder() + "đ");
				session.setAttribute("msgType", "error");
			} else {
				if ("PERCENT".equals(appliedVoucher.getDiscountType())) {
					discountAmount = subtotal * (appliedVoucher.getDiscountAmount() / 100.0);
				} else {
					discountAmount = appliedVoucher.getDiscountAmount();
				}
			}
		}

		if (discountAmount > subtotal)
			discountAmount = subtotal;
		double finalTotal = subtotal - discountAmount;

		// ĐẨY DỮ LIỆU
		request.setAttribute("cartList", cart);
		request.setAttribute("subtotal", subtotal);
		request.setAttribute("discountAmount", discountAmount);
		request.setAttribute("finalTotal", finalTotal);
		request.setAttribute("totalCount", cart.size());
		request.setAttribute("myVouchers", myVouchers);
		request.setAttribute("walletCount", myVouchers.size());

		request.getRequestDispatcher("cartitem.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		user currentUser = (user) session.getAttribute("user");
		String action = request.getParameter("action");

		// XỬ LÝ ÁP DỤNG MÃ
		if ("apply_voucher".equals(action)) {
			if (currentUser == null) {
				response.sendRedirect("login.jsp");
				return;
			}

			String code = request.getParameter("voucherCode");
			if (code != null)
				code = code.trim().toUpperCase();

			VoucherDAO vDao = new VoucherDAO();
			Voucher v = vDao.getVoucherByCode(code);

			if (v == null) {
				session.setAttribute("voucherMsg", "Mã giảm giá không tồn tại!");
				session.setAttribute("msgType", "error");
				session.removeAttribute("appliedVoucher");
			} else {
				boolean hasVoucher = vDao.checkUserHasVoucher(currentUser.getUid(), v.getId());

				if (hasVoucher) {
					session.setAttribute("appliedVoucher", v);
					session.setAttribute("voucherMsg", "Áp dụng mã " + code + " thành công!");
					session.setAttribute("msgType", "success");
				} else {
					session.setAttribute("voucherMsg", "Bạn chưa lưu mã này trong ví! Hãy lưu trước khi dùng.");
					session.setAttribute("msgType", "error");
					session.removeAttribute("appliedVoucher");
				}
			}
			response.sendRedirect("cart");
			return;
		}

		// XỬ LÝ GỠ MÃ
		if ("remove_voucher".equals(action)) {
			session.removeAttribute("appliedVoucher");
			session.setAttribute("voucherMsg", "Đã gỡ bỏ mã giảm giá.");
			session.setAttribute("msgType", "info");
			response.sendRedirect("cart");
			return;
		}

		// ADD/REMOVE/UPDATE GIỎ HÀNG
		int pid = 0;
		try {
			if (request.getParameter("pid") != null)
				pid = Integer.parseInt(request.getParameter("pid"));
		} catch (Exception e) {
		}

		if (currentUser != null) {
			CartDAO dao = new CartDAO();
			int uid = currentUser.getUid();
			if ("add".equals(action)) {
				String qParam = request.getParameter("quantity");
				int quantity = 1; // Mặc định là 1 nếu không tìm thấy tham số

				if (qParam != null && !qParam.isEmpty()) {
					quantity = Integer.parseInt(qParam);
				}

				dao.addToCart(uid, pid, quantity);

			} else if ("remove".equals(action)) {
				dao.removeItem(uid, pid);
			} else if ("update".equals(action)) {
				int quantity = Integer.parseInt(request.getParameter("quantity"));
				if (quantity > 0)
					dao.updateQuantity(uid, pid, quantity);
				else
					dao.removeItem(uid, pid);
			}
		} else {
			List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
			if (cart == null)
				cart = new ArrayList<>();
			if ("add".equals(action)) {

			}
			session.setAttribute("cart", cart);
		}
		response.sendRedirect("cart");
	}
}