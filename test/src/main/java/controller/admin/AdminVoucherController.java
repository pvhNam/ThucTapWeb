package controller.admin;

import dao.VoucherDAO;
import model.Voucher;
import model.User;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-vouchers")
public class AdminVoucherController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User currUser = (User) session.getAttribute("user");
        Boolean isHardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        int role = (currUser != null) ? currUser.getIsAdmin() : ((isHardcodedAdmin != null && isHardcodedAdmin) ? 1 : 0);

        if (role != 1) {
            response.sendRedirect("admin");
            return false;
        }
        return true;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminPermission(request, response)) return;

        String action = request.getParameter("action");
        VoucherDAO vDao = new VoucherDAO();

        if (action == null) {
            List<Voucher> list = vDao.getAllVouchers();
            request.setAttribute("listVouchers", list);
            request.getRequestDispatcher("/views/admin/vouchers.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            vDao.deleteVoucher(id);
            response.sendRedirect("admin-vouchers?msg=deleted");
        } else if (action.equals("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Voucher v = vDao.getVoucherById(id);
            request.setAttribute("voucher", v);
            request.getRequestDispatcher("/views/admin/voucher-form.jsp").forward(request, response);
        } else if (action.equals("add")) {
            request.getRequestDispatcher("/views/admin/voucher-form.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminPermission(request, response)) return;

        String action = request.getParameter("action");
        VoucherDAO vDao = new VoucherDAO();

        String code = request.getParameter("code");
        String desc = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("discountAmount"));
        String type = request.getParameter("discountType");
        double minOrder = Double.parseDouble(request.getParameter("minOrder"));
        Date expiry = Date.valueOf(request.getParameter("expiryDate"));

        if ("insert".equals(action)) {
            Voucher v = new Voucher(0, code, desc, amount, type, minOrder, expiry);
            vDao.insertVoucher(v);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Voucher v = new Voucher(id, code, desc, amount, type, minOrder, expiry);
            vDao.updateVoucher(v);
        }
        response.sendRedirect("admin-vouchers?msg=success");
    }
}
