package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product;

import java.io.IOException;

import dao.ProductDAO;

@WebServlet("/product-detail")
public class ProductDetailController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ProductDetailController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Lấy tham số pid từ URL
		String pidParam = request.getParameter("pid");
		if (pidParam == null || pidParam.isEmpty()) {
			response.sendRedirect("product-detail.jsp");
			return;
		}

		try {
			int pid = Integer.parseInt(pidParam);

			// Gọi DAO để lấy dữ liệu
			ProductDAO pDao = new ProductDAO();
			product p = pDao.getProductById(pid);

			// Kiểm tra sản phẩm có tồn tại không
			if (p == null) {
				response.sendRedirect("index.jsp");
			} else {
				// Đẩy dữ liệu sang JSP
				request.setAttribute("p", p);
				request.getRequestDispatcher("product-detail.jsp").forward(request, response);
			}

		} catch (NumberFormatException e) {
			response.sendRedirect("index.jsp");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		doGet(request, response);
	}
}