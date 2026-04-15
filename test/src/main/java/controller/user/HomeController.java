package controller.user;

import dao.ProductDAO;
import dao.VoucherDAO;
import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Product;
import model.Voucher;
import model.User;
import model.CartItem;

import java.io.IOException;
import java.util.*;

@WebServlet("/home")
public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO pdao = new ProductDAO();
        VoucherDAO vdao = new VoucherDAO();
        CartDAO cdao = new CartDAO();

        List<Product> products = pdao.getAllProducts();
        List<Voucher> vouchers = vdao.getAllVouchers();

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        Map<Integer, Integer> mapCart = new HashMap<>();

        if (currentUser != null) {
            List<CartItem> cartList = cdao.getCartByUid(currentUser.getUid());
            if (cartList != null) {
                for (CartItem item : cartList) {
                    mapCart.put(item.getProduct().getPid(), item.getQuantity());
                }
            }
        } else {
            List<CartItem> cartList = (List<CartItem>) session.getAttribute("cart");
            if (cartList != null) {
                for (CartItem item : cartList) {
                    mapCart.put(item.getProduct().getPid(), item.getQuantity());
                }
            }
        }

        request.setAttribute("products", products);
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("mapCart", mapCart);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
