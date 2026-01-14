package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import dao.CartDAO;
import dao.ProductDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cartItem;
import model.product;
import model.user;
import model.Voucher;

@WebServlet("/cart")
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		user currentUser = (user) session.getAttribute("user");
		String action = request.getParameter("action");

		// xử lý xóa sp
		if ("remove".equals(action)) {
			// kiểm tra đăng nhập
			if (currentUser == null) {
		        response.sendRedirect("login.jsp");
		        return; 
		    }
			int pid = 0;
			try {
				pid = Integer.parseInt(request.getParameter("pid"));
			} catch (Exception e) {}

			if (currentUser != null) {
				// Xóa trong DB nếu đã đăng nhập
				CartDAO dao = new CartDAO();
				dao.removeItem(currentUser.getUid(), pid);
			} else {
				// Xóa trong Session nếu chưa đăng nhập
				List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
				if (cart != null) {
					// Dùng Iterator để xóa an toàn trong vòng lặp
					Iterator<cartItem> iterator = cart.iterator();
					while (iterator.hasNext()) {
						cartItem item = iterator.next();
						if (item.getProduct().getPid() == pid) {
							iterator.remove();
							break;
						}
					}
					session.setAttribute("cart", cart);
				}
			}
			// Load lại trang để cập nhật
			response.sendRedirect("cart");
			return;
		}

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
		// kiểm  tra đăng nhập
		if (currentUser == null) {
	        response.sendRedirect("login.jsp");
	        return;
	    }
		// xử lý áp dụng voucher
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

		// xử lý gỡ mã voucher
		if ("remove_voucher".equals(action)) {
			session.removeAttribute("appliedVoucher");
			session.setAttribute("voucherMsg", "Đã gỡ bỏ mã giảm giá.");
			session.setAttribute("msgType", "info");
			response.sendRedirect("cart");
			return;
		}

		// thêm, cập nhật giỏ hàng
		int pid = 0;
		try {
			if (request.getParameter("pid") != null)
				pid = Integer.parseInt(request.getParameter("pid"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		ProductDAO productDAO = new ProductDAO();
		
		if (currentUser != null) {
			// đã đăng nhập
			CartDAO dao = new CartDAO();
			int uid = currentUser.getUid();
			
			if ("add".equals(action)) {
				String qParam = request.getParameter("quantity");
				int quantity = 1; 

				if (qParam != null && !qParam.isEmpty()) {
					quantity = Integer.parseInt(qParam);
				}
				
				// CHECK KHO
				product p = productDAO.getProductById(pid);
				if (p != null && quantity > p.getStockquantyti()) {
					session.setAttribute("voucherMsg", "Không thể thêm! Kho chỉ còn " + p.getStockquantyti() + " sản phẩm.");
					session.setAttribute("msgType", "error");
					response.sendRedirect("cart");
					return;
				}
				dao.addToCart(uid, pid, quantity);

			} 
			else if ("update_quantity".equals(action)) { 
				
				int currentQty = 1;
				try {
					currentQty = Integer.parseInt(request.getParameter("quantity"));
				} catch (Exception e) {}
				
				String mod = request.getParameter("mod");
				int newQty = currentQty;
				
				if ("increase".equals(mod)) newQty++;
				else if ("decrease".equals(mod)) newQty--;
				
				// CHECK KHO KHI TĂNG SỐ LƯỢNG
				product p = productDAO.getProductById(pid);
				if (p != null && newQty > p.getStockquantyti()) {
					session.setAttribute("voucherMsg", "Số lượng tối đa là " + p.getStockquantyti());
					session.setAttribute("msgType", "error");
					newQty = p.getStockquantyti();
				}

				if (newQty > 0) {
					dao.updateQuantity(uid, pid, newQty);
				} else {
					dao.removeItem(uid, pid);
				}
			}
		} else {
			// --- CHƯA ĐĂNG NHẬP (SESSION) ---
			List<cartItem> cart = (List<cartItem>) session.getAttribute("cart");
			if (cart == null) cart = new ArrayList<>();
			
			if ("add".equals(action)) {
				// Logic thêm vào session cart (cần tự viết thêm nếu muốn check kho ở đây)
			}
			session.setAttribute("cart", cart);
		}
		response.sendRedirect("cart");
	}
}