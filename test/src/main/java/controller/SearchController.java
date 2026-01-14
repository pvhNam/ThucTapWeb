package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product;

import java.io.IOException;
import java.util.List;

import dao.ProductDAO;

/**
 * Servlet implementation class SearchController
 */
@WebServlet("/search")
public class SearchController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/// Thiết lập tiếng Việt
		response.setContentType("text/html;charset=UTF-8");
		
		try {
			//Lấy từ khóa từ ô input (name="txt")
			String txtSearch = request.getParameter("txt");
			
			// Gọi DAO để tìm kiếm
			ProductDAO dao = new ProductDAO();
			List<product> list = dao.searchProduct(txtSearch);
			
			// Đẩy dữ liệu sang trang giao diện (about.jsp)
			request.setAttribute("listP", list);     // Danh sách sản phẩm tìm được
			request.setAttribute("txt", txtSearch);  // Giữ lại từ khóa để hiện ở ô input
			request.setAttribute("tag", "about");    // Đánh dấu menu active 
			
			// Chuyển hướng
			request.getRequestDispatcher("about.jsp").forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
