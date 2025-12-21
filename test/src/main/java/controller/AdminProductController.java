package controller;

import java.io.IOException;
import java.util.List;
import dao.ProductDAO;
import model.product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-products")
public class AdminProductController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	//  HIỂN THỊ DANH SÁCH HOẶC FORM SỬA
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String type = request.getParameter("type");
		ProductDAO dao = new ProductDAO();

		if ("edit".equals(type)) {
			// Lấy thông tin sản phẩm để sửa
			try {
				int pid = Integer.parseInt(request.getParameter("pid"));
				product p = dao.getProductById(pid);
				request.setAttribute("p", p);
				request.getRequestDispatcher("admin-edit-product.jsp").forward(request, response);
			} catch (Exception e) {
				response.sendRedirect("admin-products");
			}
		} else if ("delete".equals(type)) {
			// Xóa sản phẩm
			try {
				int pid = Integer.parseInt(request.getParameter("pid"));
				dao.deleteProduct(pid);
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.sendRedirect("admin-products");
		} else {
			//HIỂN THỊ DANH SÁCH
			List<product> list = dao.getAllProducts();
			request.setAttribute("listP", list);
			request.getRequestDispatcher("admin-products.jsp").forward(request, response);
		}
	}

	//  XỬ LÝ CẬP NHẬT (SỬA) SẢN PHẨM
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		try {
			int pid = Integer.parseInt(request.getParameter("pid"));
			String name = request.getParameter("name");
			double price = Double.parseDouble(request.getParameter("price"));
			int cateId = Integer.parseInt(request.getParameter("cateId"));
			String color = request.getParameter("color");
			String size = request.getParameter("size");
			int stock = Integer.parseInt(request.getParameter("stock"));
			String image = request.getParameter("image");

			product p = new product(pid, name, price, cateId, color, size, stock, image);

			ProductDAO dao = new ProductDAO();
			dao.updateProduct(p); 

			response.sendRedirect("admin-products");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("admin-products");
		}
	}
}