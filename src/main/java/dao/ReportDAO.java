package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class ReportDAO {
    
    //  Dữ liệu báo cáo NGÀY
    public static class DailyReportItem {
        public String productName;
        public int quantitySold;
        public double price;
        public double totalMoney;
        public String paymentMethod;
    }

    // Thống kê tổng quan THÁNG
    public static class MonthlyStats {
        public double totalRevenue;
        public double totalImportCost;
        public double totalCash;
        public double totalBank;
        public double totalTax;
    }

    // Class Chi tiết sản phẩm bán
    public static class MonthlyProductReport {
        public String productName;
        public int totalQuantity;
        public double totalRevenue;
        public double totalProfit;
    }

    // Class Dữ liệu NHẬP HÀNG
    public static class ImportReportItem {
        public String productName;
        public int quantity;
        public double importPrice;
        public double totalCost;
        public Timestamp importDate;
    }

    public static class ProductRevenueItem {
        private int productId;
        private String productName;
        private String categoryName;
        private String image;
        private double sellingPrice;
        private double costPrice;
        private int quantitySold;
        private int stockRemaining;
        private double revenue;
        private double costOfGoodsSold;
        private double profit;
        private double inventoryValue;

        public int getProductId() { return productId; }
        public String getProductName() { return productName; }
        public String getCategoryName() { return categoryName; }
        public String getImage() { return image; }
        public double getSellingPrice() { return sellingPrice; }
        public double getCostPrice() { return costPrice; }
        public int getQuantitySold() { return quantitySold; }
        public int getStockRemaining() { return stockRemaining; }
        public double getRevenue() { return revenue; }
        public double getCostOfGoodsSold() { return costOfGoodsSold; }
        public double getProfit() { return profit; }
        public double getInventoryValue() { return inventoryValue; }
        public boolean isSold() { return quantitySold > 0; }
        public boolean isInStock() { return stockRemaining > 0; }
    }

    public static class RevenueReportSummary {
        private double totalRevenue;
        private double totalCost;
        private double totalProfit;
        private double inventoryValue;
        private int completedOrders;
        private int unitsSold;
        private int unitsInStock;
        private int soldProducts;
        private int unsoldProducts;
        private int lowStockProducts;

        public double getTotalRevenue() { return totalRevenue; }
        public double getTotalCost() { return totalCost; }
        public double getTotalProfit() { return totalProfit; }
        public double getInventoryValue() { return inventoryValue; }
        public int getCompletedOrders() { return completedOrders; }
        public int getUnitsSold() { return unitsSold; }
        public int getUnitsInStock() { return unitsInStock; }
        public int getSoldProducts() { return soldProducts; }
        public int getUnsoldProducts() { return unsoldProducts; }
        public int getLowStockProducts() { return lowStockProducts; }
    }

    private static final String COMPLETED_ORDER_CONDITION =
            "(LOWER(COALESCE(o.status, '')) LIKE '%thanh cong%' " +
            "OR LOWER(COALESCE(o.status, '')) LIKE '%thành công%' " +
            "OR LOWER(COALESCE(o.status, '')) LIKE '%success%' " +
            "OR LOWER(COALESCE(o.status, '')) LIKE '%completed%')";

    // BÁO CÁO NGÀY 
    public List<DailyReportItem> getDailyReport(String date) {
        List<DailyReportItem> list = new ArrayList<>();
        String sql = "SELECT p.name, d.quantity, d.price, o.payment_method " +
                     "FROM order_details d " +
                     "JOIN orders o ON d.order_id = o.id " +
                     "JOIN product p ON d.product_id = p.pid " +
                     "WHERE DATE(o.created_at) = ?"; 
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DailyReportItem item = new DailyReportItem();
                item.productName = rs.getString("name");
                item.quantitySold = rs.getInt("quantity");
                item.price = rs.getDouble("price");
                item.totalMoney = item.quantitySold * item.price;
                item.paymentMethod = rs.getString("payment_method");
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    //THỐNG KÊ TỔNG QUAN THÁNG
    public MonthlyStats getMonthlyStats(int month, int year) {
        MonthlyStats stats = new MonthlyStats();
        String sqlRev = "SELECT " +
                "SUM(total_money) as revenue, " +
                "SUM(CASE WHEN payment_method = 'COD' OR payment_method = 'CASH' THEN total_money ELSE 0 END) as cash, " +
                "SUM(CASE WHEN payment_method = 'BANKING' OR payment_method = 'BANK' OR payment_method = 'MOMO' THEN total_money ELSE 0 END) as bank " +
                "FROM orders WHERE MONTH(created_at) = ? AND YEAR(created_at) = ?";
        
        // Vốn tính dựa trên sản phẩm đã bán ra
        String sqlCost = "SELECT SUM(p.cost_price * d.quantity) as total_cost " +
                         "FROM order_details d " +
                         "JOIN product p ON d.product_id = p.pid " +
                         "JOIN orders o ON d.order_id = o.id " +
                         "WHERE MONTH(o.created_at) = ? AND YEAR(o.created_at) = ?";

        try (Connection conn = DBConnect.getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement(sqlRev);
            ps1.setInt(1, month);
            ps1.setInt(2, year);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                stats.totalRevenue = rs1.getDouble("revenue");
                stats.totalCash = rs1.getDouble("cash");
                stats.totalBank = rs1.getDouble("bank");
                stats.totalTax = stats.totalRevenue * 0.1; 
            }
            PreparedStatement ps2 = conn.prepareStatement(sqlCost);
            ps2.setInt(1, month);
            ps2.setInt(2, year);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                stats.totalImportCost = rs2.getDouble("total_cost");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    // CHI TIẾT SẢN PHẨM BÁN
    public List<MonthlyProductReport> getMonthlyProductDetails(int month, int year) {
        List<MonthlyProductReport> list = new ArrayList<>();
        String sql = "SELECT p.name, " +
                     "SUM(d.quantity) as qty, " +
                     "SUM(d.price * d.quantity) as revenue, " +
                     "SUM((d.price - p.cost_price) * d.quantity) as profit " +
                     "FROM order_details d " +
                     "JOIN orders o ON d.order_id = o.id " +
                     "JOIN product p ON d.product_id = p.pid " +
                     "WHERE MONTH(o.created_at) = ? AND YEAR(o.created_at) = ? " +
                     "GROUP BY p.pid, p.name " +
                     "ORDER BY revenue DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MonthlyProductReport item = new MonthlyProductReport();
                item.productName = rs.getString("name");
                item.totalQuantity = rs.getInt("qty");
                item.totalRevenue = rs.getDouble("revenue");
                item.totalProfit = rs.getDouble("profit");
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    //LẤY LỊCH SỬ NHẬP HÀNG 
    public List<ImportReportItem> getImportHistory(int month, int year) {
        List<ImportReportItem> list = new ArrayList<>();
        // tạo bảng import_history trong database
        String sql = "SELECT p.name, h.quantity, h.import_price, h.created_at " +
                     "FROM import_history h " +
                     "JOIN product p ON h.product_id = p.pid " +
                     "WHERE MONTH(h.created_at) = ? AND YEAR(h.created_at) = ? " +
                     "ORDER BY h.created_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ImportReportItem item = new ImportReportItem();
                item.productName = rs.getString("name");
                item.quantity = rs.getInt("quantity");
                item.importPrice = rs.getDouble("import_price");
                item.totalCost = item.quantity * item.importPrice;
                item.importDate = rs.getTimestamp("created_at");
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<ProductRevenueItem> getProductRevenueReport(LocalDate startDate, LocalDate endDateExclusive) {
        List<ProductRevenueItem> items = new ArrayList<>();
        String sql = "SELECT p.pid, p.name, p.img, p.price, COALESCE(p.cost_price, 0) AS cost_price, " +
                "COALESCE(c.name, 'Chưa phân loại') AS category_name, " +
                "CASE WHEN EXISTS (SELECT 1 FROM product_variants pv0 WHERE pv0.product_id = p.pid) " +
                "THEN COALESCE((SELECT SUM(pv.stock_quantity) FROM product_variants pv WHERE pv.product_id = p.pid), 0) " +
                "ELSE COALESCE(p.amount, 0) END AS stock_remaining, " +
                "COALESCE(s.quantity_sold, 0) AS quantity_sold, " +
                "COALESCE(s.revenue, 0) AS revenue " +
                "FROM product p " +
                "LEFT JOIN category c ON c.id = p.cateID " +
                "LEFT JOIN (" +
                "  SELECT d.product_id, SUM(d.quantity) AS quantity_sold, " +
                "         SUM(d.price * d.quantity) AS revenue " +
                "  FROM order_details d JOIN orders o ON o.id = d.order_id " +
                "  WHERE o.created_at >= ? AND o.created_at < ? AND " + COMPLETED_ORDER_CONDITION +
                "  GROUP BY d.product_id" +
                ") s ON s.product_id = p.pid " +
                "ORDER BY revenue DESC, p.name ASC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(startDate.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(endDateExclusive.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductRevenueItem item = new ProductRevenueItem();
                    item.productId = rs.getInt("pid");
                    item.productName = rs.getString("name");
                    item.categoryName = rs.getString("category_name");
                    item.image = rs.getString("img");
                    item.sellingPrice = rs.getDouble("price");
                    item.costPrice = rs.getDouble("cost_price");
                    item.quantitySold = rs.getInt("quantity_sold");
                    item.stockRemaining = rs.getInt("stock_remaining");
                    item.revenue = rs.getDouble("revenue");
                    item.costOfGoodsSold = item.costPrice * item.quantitySold;
                    item.profit = item.revenue - item.costOfGoodsSold;
                    item.inventoryValue = item.costPrice * item.stockRemaining;
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Không thể tải dữ liệu báo cáo doanh thu.", e);
        }
        return items;
    }

    public RevenueReportSummary getRevenueSummary(LocalDate startDate, LocalDate endDateExclusive,
                                                  List<ProductRevenueItem> items) {
        RevenueReportSummary summary = new RevenueReportSummary();
        for (ProductRevenueItem item : items) {
            summary.totalRevenue += item.revenue;
            summary.totalCost += item.costOfGoodsSold;
            summary.inventoryValue += item.inventoryValue;
            summary.unitsSold += item.quantitySold;
            summary.unitsInStock += item.stockRemaining;
            if (item.quantitySold > 0) summary.soldProducts++;
            else summary.unsoldProducts++;
            if (item.stockRemaining > 0 && item.stockRemaining <= 5) summary.lowStockProducts++;
        }
        summary.totalProfit = summary.totalRevenue - summary.totalCost;

        String sql = "SELECT COUNT(*) FROM orders o WHERE o.created_at >= ? AND o.created_at < ? AND "
                + COMPLETED_ORDER_CONDITION;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(startDate.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(endDateExclusive.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) summary.completedOrders = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Không thể tổng hợp số đơn hoàn tất.", e);
        }
        return summary;
    }
}
