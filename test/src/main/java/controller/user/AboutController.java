package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import dao.ProductDAO;
import model.Product;

@WebServlet("/about")
public class AboutController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String txtSearch = request.getParameter("txt");
		String priceFilter = request.getParameter("price");
		String sortType = request.getParameter("sort");
		int pageCurrent = 1;
		try {
			String p = request.getParameter("page");
			if (p != null) pageCurrent = Integer.parseInt(p);
		} catch (Exception e) {  }

		ProductDAO pdao = new ProductDAO();
		List<Product> allProducts = new ArrayList<>();

		// ưu tiên listP nếu controller khác đã set, nếu không thì search hoặc lấy tất cả
		Object attrList = request.getAttribute("listP");
		if (attrList != null && attrList instanceof List) {
			allProducts = (List<Product>) attrList;
		} else if (txtSearch != null && !txtSearch.trim().isEmpty()) {
			allProducts = pdao.searchProduct(txtSearch);
		} else {
			allProducts = pdao.getAllProducts();
		}

		// sắp xếp với giá 
		List<Product> filteredProducts = new ArrayList<>();
		if (allProducts != null) {
			for (Product p : allProducts) {
				double price = p.getPrice();
				if (priceFilter == null || "all".equals(priceFilter)) {
					filteredProducts.add(p);
				} else if ("under500".equals(priceFilter) && price < 500000) {
					filteredProducts.add(p);
				} else if ("500to1000".equals(priceFilter) && price >= 500000 && price <= 1000000) {
					filteredProducts.add(p);
				} else if ("above1000".equals(priceFilter) && price > 1000000) {
					filteredProducts.add(p);
				}
			}
		}

		// Sorting
		if ("price_asc".equals(sortType)) {
			Collections.sort(filteredProducts, Comparator.comparingDouble(Product::getPrice));
		} else if ("price_desc".equals(sortType)) {
			Collections.sort(filteredProducts, Comparator.comparingDouble(Product::getPrice).reversed());
		} else if ("name_asc".equals(sortType)) {
			Collections.sort(filteredProducts, Comparator.comparing(Product::getPdescription));
		}

		// phân trang 
		int productsPerPage = 9;
		int totalProducts = filteredProducts.size();
		int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
		if (pageCurrent > totalPages && totalPages > 0) pageCurrent = totalPages;
		if (pageCurrent < 1) pageCurrent = 1;

		int start = (pageCurrent - 1) * productsPerPage;
		int end = Math.min(start + productsPerPage, totalProducts);

		List<Product> pageProducts = new ArrayList<>();
		if (start < totalProducts && start >= 0) {
			pageProducts = filteredProducts.subList(start, end);
		}

		// xây dựng baseParams và pageParams để giữ nguyên các tham số tìm kiếm, lọc, sắp xếp khi chuyển trang
		String baseParams = "";
		if (txtSearch != null && !txtSearch.isEmpty()) {
			baseParams += "&txt=" + URLEncoder.encode(txtSearch, "UTF-8");
		}

		String pageParams = baseParams;
		if (priceFilter != null) pageParams += "&price=" + priceFilter;
		if (sortType != null) pageParams += "&sort=" + sortType;

		// Set attributes cho JSP
		request.setAttribute("pageProducts", pageProducts);
		request.setAttribute("totalProducts", totalProducts);
		request.setAttribute("start", start);
		request.setAttribute("end", end);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("pageCurrent", pageCurrent);
		request.setAttribute("priceFilter", priceFilter);
		request.setAttribute("sortType", sortType);
		request.setAttribute("baseParams", baseParams);
		request.setAttribute("pageParams", pageParams);
		request.setAttribute("txtSearch", txtSearch);

		request.getRequestDispatcher("/about.jsp").forward(request, response);
	}
}
