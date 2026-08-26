package controller.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import dao.InventoryDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.StockImportLine;
import model.User;

@WebServlet("/admin-stock-import")
public class AdminStockImportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (!requireAdmin(request, response)) {
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        InventoryDAO inventoryDAO = new InventoryDAO();
        List<Product> products = productDAO.getAllProducts();

        int selectedProductId = parsePositiveInt(request.getParameter("pid"));
        if (selectedProductId <= 0 && !products.isEmpty()) {
            selectedProductId = products.get(0).getPid();
        }

        request.setAttribute("products", products);
        request.setAttribute("recentReceipts", inventoryDAO.getRecentReceipts(30));
        request.setAttribute("selectedProductId", selectedProductId);
        request.setAttribute("today", LocalDate.now());
        request.getRequestDispatcher("/admin-stock-import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (!requireAdmin(request, response)) {
            return;
        }

        String redirectBase = request.getContextPath() + "/admin-stock-import";
        try {
            LocalDate importDate = LocalDate.parse(request.getParameter("importDate"));
            if (importDate.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Dữ liệu phiếu nhập không hợp lệ");
            }
            List<StockImportLine> lines = parseLines(request);
            InventoryDAO inventoryDAO = new InventoryDAO();
            int receiptId = inventoryDAO.receiveStockBatch(
                    lines,
                    importDate,
                    request.getParameter("supplier"),
                    request.getParameter("note"));

            if (receiptId > 0) {
                response.sendRedirect(redirectBase + "?msg=success&receiptId=" + receiptId);
            } else {
                response.sendRedirect(redirectBase + "?msg=error");
            }
        } catch (Exception exception) {
            response.sendRedirect(redirectBase + "?msg=invalid");
        }
    }

    private List<StockImportLine> parseLines(HttpServletRequest request) {
        String[] productIds = request.getParameterValues("productId");
        String[] sizes = request.getParameterValues("sizes");
        String[] colors = request.getParameterValues("colors");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitCosts = request.getParameterValues("unitCost");
        int lineCount = productIds == null ? 0 : productIds.length;
        if (lineCount == 0 || lineCount > 30 || sizes == null || colors == null
                || quantities == null || unitCosts == null
                || sizes.length != lineCount || colors.length != lineCount
                || quantities.length != lineCount || unitCosts.length != lineCount) {
            throw new IllegalArgumentException("Danh sách sản phẩm không hợp lệ");
        }

        List<StockImportLine> lines = new ArrayList<>();
        for (int index = 0; index < lineCount; index++) {
            int productId = parsePositiveInt(productIds[index]);
            int quantity = Integer.parseInt(quantities[index]);
            double unitCost = Double.parseDouble(unitCosts[index]);
            if (productId <= 0 || quantity <= 0 || !Double.isFinite(unitCost) || unitCost <= 0) {
                throw new IllegalArgumentException("Dòng sản phẩm không hợp lệ");
            }
            lines.add(new StockImportLine(productId, parseColors(colors[index]), parseSizes(sizes[index]),
                    quantity, unitCost));
        }
        return lines;
    }

    private List<String> parseColors(String rawValue) {
        return splitAndDeduplicate(rawValue, "[,;|\\r\\n]+");
    }

    private List<String> parseSizes(String rawValue) {
        List<String> parsed = new ArrayList<>();
        for (String chunk : splitAndDeduplicate(rawValue, "[,;|\\r\\n]+")) {
            String[] whitespaceParts = chunk.trim().split("\\s+");
            boolean compactSizeList = whitespaceParts.length > 1;
            for (String part : whitespaceParts) {
                if (!isCompactSizeToken(part)) {
                    compactSizeList = false;
                    break;
                }
            }
            if (compactSizeList) {
                for (String part : whitespaceParts) {
                    parsed.add(part);
                }
            } else {
                parsed.add(chunk);
            }
        }
        return deduplicate(parsed);
    }

    private List<String> splitAndDeduplicate(String rawValue, String separatorRegex) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            throw new IllegalArgumentException("Danh sách phân loại đang trống");
        }
        List<String> values = new ArrayList<>();
        for (String value : rawValue.split(separatorRegex)) {
            if (!value.trim().isEmpty()) {
                values.add(value.trim());
            }
        }
        return deduplicate(values);
    }

    private List<String> deduplicate(List<String> values) {
        Map<String, String> unique = new LinkedHashMap<>();
        for (String value : values) {
            unique.putIfAbsent(value.toLowerCase(Locale.ROOT), value);
        }
        if (unique.isEmpty()) {
            throw new IllegalArgumentException("Danh sách phân loại đang trống");
        }
        return new ArrayList<>(unique.values());
    }

    private boolean isCompactSizeToken(String value) {
        String normalized = value.toUpperCase(Locale.ROOT);
        Set<String> commonSizes = Set.of("3XS", "XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL",
                "2XL", "3XL", "4XL", "5XL");
        return commonSizes.contains(normalized) || normalized.matches("\\d+(?:\\.\\d+)?");
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        Boolean hardcodedAdmin = session == null ? null : (Boolean) session.getAttribute("isAdmin");
        int role = currentUser != null
                ? currentUser.getIsAdmin()
                : (Boolean.TRUE.equals(hardcodedAdmin) ? 1 : 0);

        if (role == 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (role != 1) {
            response.sendRedirect(request.getContextPath() + "/admin-products?msg=error_permission");
            return false;
        }
        return true;
    }

    private int parsePositiveInt(String rawValue) {
        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : 0;
        } catch (Exception exception) {
            return 0;
        }
    }
}
