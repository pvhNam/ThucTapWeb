package controller.admin;

import java.io.IOException;
import java.util.List;
import dao.OrderDAO;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currUser = (User) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");

        int role = 0;
        if (currUser != null) {
            role = currUser.getIsAdmin();
        } else if (isHardcodedAdmin != null && isHardcodedAdmin) {
            role = 1;
        }

        if (role == 0) {
            response.sendRedirect("login");
            return;
        }

        OrderDAO dao = new OrderDAO();
        List<Order> list = dao.getAllOrders();

        double totalRevenue = 0;
        int countSuccess = 0;
        int countShipping = 0;
        int countProcessing = 0;
        int countCancel = 0;

        if (list != null) {
            for (Order o : list) {
                String s = o.getStatus();
                if (s == null) s = "";
                s = s.toLowerCase();

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

        request.setAttribute("listOrders", list);
        request.setAttribute("totalOrders", (list != null) ? list.size() : 0);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("countSuccess", countSuccess);
        request.setAttribute("countShipping", countShipping);
        request.setAttribute("countProcessing", countProcessing);
        request.setAttribute("countCancel", countCancel);
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
