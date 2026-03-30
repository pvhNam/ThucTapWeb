package controller;

import dao.ProductDAO;
import dao.VoucherDAO;
import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.product;
import model.Voucher;
import model.user;
import model.cartItem;

import java.io.IOException;
import java.util.*;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
// chuyển toan bộ xử lý về home tránh vi phạm MVC: truy cập /home trước -> gửi giữ liệu về jsp -> xuất html 
// bỏ truy cập jsp trực tiếp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO pdao = new ProductDAO();
        VoucherDAO vdao = new VoucherDAO();
        CartDAO cdao = new CartDAO();

        // Lấy dữ liệu
        List<product> products = pdao.getAllProducts();
        List<Voucher> vouchers = vdao.getAllVouchers();

        // Lấy user
        HttpSession session = request.getSession();
        user currentUser = (user) session.getAttribute("user");

        Map<Integer, Integer> mapCart = new HashMap<>();

        // Lấy giỏ hàng
        if (currentUser != null) {
            List<cartItem> cartList = cdao.getCartByUid(currentUser.getUid());
            if (cartList != null) {
                for (cartItem item : cartList) {
                    mapCart.put(item.getProduct().getPid(), item.getQuantity());
                }
            }
        } else {
            List<cartItem> cartList = (List<cartItem>) session.getAttribute("cart");
            if (cartList != null) {
                for (cartItem item : cartList) {
                    mapCart.put(item.getProduct().getPid(), item.getQuantity());
                }
            }
        }

        // Set attribute cho JSP
        request.setAttribute("products", products);
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("mapCart", mapCart);

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}