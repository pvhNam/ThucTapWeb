package controller;

import dao.VoucherDAO;
import model.Voucher;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-vouchers")
public class AdminVoucherController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        VoucherDAO vDao = new VoucherDAO();

        if (action == null) {
            // Liệt kê danh sách
            List<Voucher> list = vDao.getAllVouchers(); // Hàm này đã có sẵn trong DAO cũ
            request.setAttribute("listVouchers", list);
            request.getRequestDispatcher("admin-vouchers.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            // Xóa voucher
            int id = Integer.parseInt(request.getParameter("id"));
            vDao.deleteVoucher(id);
            response.sendRedirect("admin-vouchers?msg=deleted");
        } else if (action.equals("edit")) {
            // Chuyển sang trang sửa
            int id = Integer.parseInt(request.getParameter("id"));
            Voucher v = vDao.getVoucherById(id);
            request.setAttribute("voucher", v);
            request.getRequestDispatcher("admin-voucher-form.jsp").forward(request, response);
        } else if (action.equals("add")) {
            // Chuyển sang trang thêm mới
            request.getRequestDispatcher("admin-voucher-form.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        VoucherDAO vDao = new VoucherDAO();
        
        // Lấy dữ liệu từ form
        String code = request.getParameter("code");
        String desc = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("discountAmount"));
        String type = request.getParameter("discountType"); // "PERCENT" hoặc "FIXED"
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