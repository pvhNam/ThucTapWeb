package dao;

import java.sql.*;
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
                "SUM(CASE WHEN payment_method = 'BANKING' OR payment_method = 'BANK' THEN total_money ELSE 0 END) as bank " +
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
}