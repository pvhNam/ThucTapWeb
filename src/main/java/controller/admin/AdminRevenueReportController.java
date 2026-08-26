package controller.admin;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ReportPeriod;
import model.User;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet("/admin-revenue-report")
public class AdminRevenueReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdminOrStaff(request.getSession())) {
            response.sendRedirect("login");
            return;
        }

        ReportPeriod period = ReportPeriod.fromParameters(
                request.getParameter("period"), request.getParameter("month"), request.getParameter("year"));
        String filter = normalizeFilter(request.getParameter("filter"));
        String keyword = request.getParameter("q") == null ? "" : request.getParameter("q").trim();

        ReportDAO dao = new ReportDAO();
        List<ReportDAO.ProductRevenueItem> allItems = new ArrayList<>();
        ReportDAO.RevenueReportSummary summary = new ReportDAO.RevenueReportSummary();
        String errorMessage = null;
        try {
            allItems = dao.getProductRevenueReport(period.getStartDate(), period.getEndDateExclusive());
            summary = dao.getRevenueSummary(period.getStartDate(), period.getEndDateExclusive(), allItems);
        } catch (IllegalStateException error) {
            getServletContext().log("Revenue report could not be loaded", error);
            errorMessage = "Không thể tải báo cáo lúc này. Vui lòng kiểm tra kết nối dữ liệu và thử lại.";
        }

        List<ReportDAO.ProductRevenueItem> displayedItems = filterItems(allItems, filter, keyword);
        List<ReportDAO.ProductRevenueItem> topItems = new ArrayList<>();
        for (ReportDAO.ProductRevenueItem item : allItems) {
            if (item.getQuantitySold() > 0 && topItems.size() < 6) topItems.add(item);
        }

        double maxRevenue = topItems.stream()
                .mapToDouble(ReportDAO.ProductRevenueItem::getRevenue)
                .max().orElse(0);

        request.setAttribute("period", period);
        request.setAttribute("summary", summary);
        request.setAttribute("allItems", allItems);
        request.setAttribute("items", displayedItems);
        request.setAttribute("topItems", topItems);
        request.setAttribute("maxRevenue", maxRevenue);
        request.setAttribute("filter", filter);
        request.setAttribute("keyword", keyword);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("generatedAt", LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        request.getRequestDispatcher("/admin-revenue-report.jsp").forward(request, response);
    }

    private boolean isAdminOrStaff(HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        Boolean hardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        return (currentUser != null && currentUser.getIsAdmin() > 0)
                || Boolean.TRUE.equals(hardcodedAdmin);
    }

    private String normalizeFilter(String value) {
        if ("sold".equals(value) || "unsold".equals(value)
                || "inventory".equals(value) || "low_stock".equals(value)) return value;
        return "all";
    }

    private List<ReportDAO.ProductRevenueItem> filterItems(List<ReportDAO.ProductRevenueItem> source,
                                                           String filter, String keyword) {
        List<ReportDAO.ProductRevenueItem> result = new ArrayList<>();
        String normalizedKeyword = keyword.toLowerCase(Locale.ROOT);
        for (ReportDAO.ProductRevenueItem item : source) {
            boolean matchesFilter = switch (filter) {
                case "sold" -> item.getQuantitySold() > 0;
                case "unsold" -> item.getQuantitySold() == 0;
                case "inventory" -> item.getStockRemaining() > 0;
                case "low_stock" -> item.getStockRemaining() > 0 && item.getStockRemaining() <= 5;
                default -> true;
            };
            String productName = item.getProductName() == null ? "" : item.getProductName();
            String categoryName = item.getCategoryName() == null ? "" : item.getCategoryName();
            boolean matchesKeyword = normalizedKeyword.isEmpty()
                    || productName.toLowerCase(Locale.ROOT).contains(normalizedKeyword)
                    || categoryName.toLowerCase(Locale.ROOT).contains(normalizedKeyword)
                    || String.valueOf(item.getProductId()).contains(normalizedKeyword);
            if (matchesFilter && matchesKeyword) result.add(item);
        }
        return result;
    }
}
