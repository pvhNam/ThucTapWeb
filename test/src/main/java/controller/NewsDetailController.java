package controller;

import java.io.IOException;
import dao.NewsDAO;
import model.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Đường dẫn này sẽ được gọi khi bấm vào tin tức
@WebServlet("/news-detail")
public class NewsDetailController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		
		// 1. Lấy tham số ID từ URL (ví dụ: news-detail?id=5)
		String idStr = request.getParameter("id");
		
		try {
			if (idStr != null && !idStr.isEmpty()) {
				int id = Integer.parseInt(idStr);
				
				// 2. Gọi DAO lấy dữ liệu
				NewsDAO dao = new NewsDAO();
				News n = dao.getNewsById(id);
				
				// 3. Kiểm tra kết quả
				if (n != null) {
					// Tìm thấy: Đẩy đối tượng "n" sang trang JSP
					request.setAttribute("newsObj", n);
					request.getRequestDispatcher("news-detail.jsp").forward(request, response);
				} else {
					// Không tìm thấy ID này trong DB: Về trang danh sách
					response.sendRedirect("news.jsp");
				}
			} else {
				// Không có tham số ID: Về trang danh sách
				response.sendRedirect("news.jsp");
			}
		} catch (NumberFormatException e) {
			// ID không phải số: Về trang danh sách
			response.sendRedirect("news.jsp");
		}
	}
}