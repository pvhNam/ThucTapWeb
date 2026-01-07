package controller;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.text.DecimalFormat;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-export-report")
public class ExportReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String type = request.getParameter("type"); // "daily" hoặc "monthly"
        ReportDAO dao = new ReportDAO();
        
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Báo Cáo");
            
            // --- STYLE ĐỊNH DẠNG ---
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            font.setFontHeightInPoints((short) 11);
            headerStyle.setFont(font);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            
            CellStyle moneyStyle = workbook.createCellStyle();
            moneyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));
            
            CellStyle dateStyle = workbook.createCellStyle();
            dateStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/mm/yyyy HH:mm"));

            int rowIdx = 0;

            // ================= TRƯỜNG HỢP 1: BÁO CÁO NGÀY =================
            if ("daily".equals(type)) {
                String date = request.getParameter("date");
                List<ReportDAO.DailyReportItem> list = dao.getDailyReport(date);

                Row titleRow = sheet.createRow(rowIdx++);
                titleRow.createCell(0).setCellValue("BÁO CÁO DOANH THU NGÀY " + date);
                titleRow.getCell(0).setCellStyle(headerStyle);
                
                rowIdx++; // Dòng trống

                Row header = sheet.createRow(rowIdx++);
                String[] columns = {"Tên Sản Phẩm", "Số Lượng", "Đơn Giá", "Thành Tiền", "HT Thanh Toán"};
                for(int i=0; i<columns.length; i++) {
                    Cell c = header.createCell(i);
                    c.setCellValue(columns[i]);
                    c.setCellStyle(headerStyle);
                }

                double totalDay = 0;
                if (list != null) {
                    for (ReportDAO.DailyReportItem item : list) {
                        Row row = sheet.createRow(rowIdx++);
                        row.createCell(0).setCellValue(item.productName);
                        row.createCell(1).setCellValue(item.quantitySold);
                        
                        Cell c2 = row.createCell(2); c2.setCellValue(item.price); c2.setCellStyle(moneyStyle);
                        Cell c3 = row.createCell(3); c3.setCellValue(item.totalMoney); c3.setCellStyle(moneyStyle);
                        
                        // Chuẩn hóa tên thanh toán
                        String payMethod = "Tiền mặt";
                        if(item.paymentMethod != null && item.paymentMethod.toUpperCase().contains("BANK")) {
                            payMethod = "Chuyển khoản";
                        }
                        row.createCell(4).setCellValue(payMethod);
                        
                        totalDay += item.totalMoney;
                    }
                }
                
                rowIdx++;
                Row sumRow = sheet.createRow(rowIdx++);
                sumRow.createCell(2).setCellValue("TỔNG CỘNG:");
                Cell sumCell = sumRow.createCell(3);
                sumCell.setCellValue(totalDay);
                sumCell.setCellStyle(moneyStyle);
                sumCell.getCellStyle().setFont(font);

            } 
            // ================= TRƯỜNG HỢP 2: BÁO CÁO THÁNG =================
            else if ("monthly".equals(type)) {
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));
                
                // Lấy dữ liệu 3 phần từ DAO
                ReportDAO.MonthlyStats stats = dao.getMonthlyStats(month, year);
                List<ReportDAO.MonthlyProductReport> soldDetails = dao.getMonthlyProductDetails(month, year);
                List<ReportDAO.ImportReportItem> importDetails = dao.getImportHistory(month, year);

                // --- PHẦN 1: TỔNG QUAN ---
                Row title = sheet.createRow(rowIdx++);
                title.createCell(0).setCellValue("BÁO CÁO TỔNG QUAN THÁNG " + month + "/" + year);
                title.getCell(0).setCellStyle(headerStyle);
                
                // Xử lý null cho stats
                double rev = (stats != null) ? stats.totalRevenue : 0;
                double impCost = (stats != null) ? stats.totalImportCost : 0;
                double tax = (stats != null) ? stats.totalTax : 0;
                
                String[][] summaryData = {
                    {"Tổng Doanh Thu", String.valueOf(rev)},
                    {"Tổng Vốn Nhập (Theo đơn bán)", String.valueOf(impCost)},
                    {"Lợi Nhuận Gộp", String.valueOf(rev - impCost)},
                    {"Thuế (Dự kiến 10%)", String.valueOf(tax)}
                };

                for(String[] line : summaryData) {
                    Row row = sheet.createRow(rowIdx++);
                    row.createCell(0).setCellValue(line[0]);
                    Cell val = row.createCell(1); 
                    val.setCellValue(Double.parseDouble(line[1]));
                    val.setCellStyle(moneyStyle);
                }

                // --- PHẦN 2: CHI TIẾT BÁN HÀNG ---
                rowIdx += 2;
                Row soldHeaderTitle = sheet.createRow(rowIdx++);
                soldHeaderTitle.createCell(0).setCellValue("I. CHI TIẾT SẢN PHẨM ĐÃ BÁN");
                soldHeaderTitle.getCell(0).setCellStyle(headerStyle);
                
                Row soldHeader = sheet.createRow(rowIdx++);
                String[] cols = {"Tên Sản Phẩm", "Số Lượng Bán", "Doanh Thu", "Lợi Nhuận"};
                for(int i=0; i<cols.length; i++) {
                    Cell c = soldHeader.createCell(i);
                    c.setCellValue(cols[i]);
                    c.setCellStyle(headerStyle);
                }
                
                if (soldDetails != null) {
                    for(ReportDAO.MonthlyProductReport p : soldDetails) {
                        Row r = sheet.createRow(rowIdx++);
                        r.createCell(0).setCellValue(p.productName);
                        r.createCell(1).setCellValue(p.totalQuantity);
                        
                        Cell c2 = r.createCell(2); c2.setCellValue(p.totalRevenue); c2.setCellStyle(moneyStyle);
                        Cell c3 = r.createCell(3); c3.setCellValue(p.totalProfit); c3.setCellStyle(moneyStyle);
                    }
                }

                // --- PHẦN 3: LỊCH SỬ NHẬP HÀNG ---
                rowIdx += 2;
                Row impHeaderTitle = sheet.createRow(rowIdx++);
                impHeaderTitle.createCell(0).setCellValue("II. LỊCH SỬ NHẬP KHO (NHẬP HÀNG)");
                impHeaderTitle.getCell(0).setCellStyle(headerStyle);

                Row impHeader = sheet.createRow(rowIdx++);
                String[] impCols = {"Ngày Nhập", "Tên Sản Phẩm", "Số Lượng", "Giá Vốn/SP", "Tổng Chi Phí"};
                for(int i=0; i<impCols.length; i++) {
                    Cell c = impHeader.createCell(i);
                    c.setCellValue(impCols[i]);
                    c.setCellStyle(headerStyle);
                }

                double totalImportMonth = 0;
                if (importDetails != null) {
                    for(ReportDAO.ImportReportItem imp : importDetails) {
                        Row r = sheet.createRow(rowIdx++);
                        
                        Cell cDate = r.createCell(0); 
                        cDate.setCellValue(imp.importDate);
                        cDate.setCellStyle(dateStyle);
                        
                        r.createCell(1).setCellValue(imp.productName);
                        r.createCell(2).setCellValue(imp.quantity);
                        
                        Cell cPrice = r.createCell(3); cPrice.setCellValue(imp.importPrice); cPrice.setCellStyle(moneyStyle);
                        Cell cTotal = r.createCell(4); cTotal.setCellValue(imp.totalCost); cTotal.setCellStyle(moneyStyle);
                        
                        totalImportMonth += imp.totalCost;
                    }
                }

                // Tổng kết chi phí nhập
                Row sumImpRow = sheet.createRow(rowIdx++);
                sumImpRow.createCell(3).setCellValue("TỔNG TIỀN NHẬP HÀNG:");
                sumImpRow.getCell(3).setCellStyle(headerStyle);
                Cell cSumImp = sumImpRow.createCell(4);
                cSumImp.setCellValue(totalImportMonth);
                cSumImp.setCellStyle(moneyStyle);
            }

            for(int i=0; i<5; i++) sheet.autoSizeColumn(i);

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=BaoCao_" + type + ".xlsx");
            
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi xuất báo cáo: " + e.getMessage());
        }
    }
}