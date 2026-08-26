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
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin-export-revenue")
public class ExportRevenueReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request.getSession())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xuất báo cáo.");
            return;
        }

        ReportPeriod period = ReportPeriod.fromParameters(
                request.getParameter("period"), request.getParameter("month"), request.getParameter("year"));
        String scope = normalizeScope(request.getParameter("scope"));
        ReportDAO dao = new ReportDAO();

        try {
            List<ReportDAO.ProductRevenueItem> allItems = dao.getProductRevenueReport(
                    period.getStartDate(), period.getEndDateExclusive());
            ReportDAO.RevenueReportSummary summary = dao.getRevenueSummary(
                    period.getStartDate(), period.getEndDateExclusive(), allItems);
            List<ReportDAO.ProductRevenueItem> exportItems = selectItems(allItems, scope);

            response.reset();
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=BaoCao_DoanhThu_"
                    + period.getFileLabel() + "_" + scope + ".xlsx");
            response.setHeader("Cache-Control", "no-store");

            try (Workbook workbook = createWorkbook(period, scope, summary, exportItems);
                 OutputStream output = response.getOutputStream()) {
                workbook.write(output);
            }
        } catch (Exception error) {
            getServletContext().log("Revenue report export failed", error);
            if (!response.isCommitted()) {
                response.reset();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Không thể tạo file báo cáo. Vui lòng thử lại.");
            }
        }
    }

    private Workbook createWorkbook(ReportPeriod period, String scope,
                                    ReportDAO.RevenueReportSummary summary,
                                    List<ReportDAO.ProductRevenueItem> items) {
        Workbook workbook = new XSSFWorkbook();
        CellStyle titleStyle = createTitleStyle(workbook);
        CellStyle sectionStyle = createSectionStyle(workbook);
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle moneyStyle = createMoneyStyle(workbook);
        CellStyle integerStyle = createIntegerStyle(workbook);
        CellStyle positiveStyle = createStatusStyle(workbook, IndexedColors.LIGHT_GREEN, IndexedColors.DARK_GREEN);
        CellStyle mutedStyle = createStatusStyle(workbook, IndexedColors.GREY_25_PERCENT, IndexedColors.GREY_80_PERCENT);

        Sheet overview = workbook.createSheet("Tổng quan");
        overview.setDisplayGridlines(false);
        overview.setColumnWidth(0, 30 * 256);
        overview.setColumnWidth(1, 24 * 256);
        overview.setColumnWidth(2, 5 * 256);
        overview.setColumnWidth(3, 30 * 256);
        overview.setColumnWidth(4, 24 * 256);
        overview.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));
        Row title = overview.createRow(0);
        title.setHeightInPoints(34);
        Cell titleCell = title.createCell(0);
        titleCell.setCellValue("BÁO CÁO DOANH THU & TỒN KHO");
        titleCell.setCellStyle(titleStyle);

        writeLabelValue(overview, 2, 0, "Kỳ báo cáo", period.getDisplayLabel(), sectionStyle, null);
        writeLabelValue(overview, 3, 0, "Từ ngày", period.getStartDate().toString(), sectionStyle, null);
        writeLabelValue(overview, 4, 0, "Đến ngày", period.getEndDateInclusive().toString(), sectionStyle, null);
        writeLabelValue(overview, 2, 3, "Phạm vi xuất", scopeLabel(scope), sectionStyle, null);
        writeLabelValue(overview, 3, 3, "Số mặt hàng trong file", items.size(), sectionStyle, integerStyle);
        writeLabelValue(overview, 4, 3, "Tạo lúc", LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")), sectionStyle, null);

        int row = 7;
        Row revenueSection = overview.createRow(row++);
        revenueSection.createCell(0).setCellValue("KẾT QUẢ KINH DOANH");
        revenueSection.getCell(0).setCellStyle(sectionStyle);
        overview.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 0, 1));
        writeLabelValue(overview, row++, 0, "Đơn hoàn tất", summary.getCompletedOrders(), null, integerStyle);
        writeLabelValue(overview, row++, 0, "Sản phẩm đã bán", summary.getUnitsSold(), null, integerStyle);
        writeLabelValue(overview, row++, 0, "Doanh thu", summary.getTotalRevenue(), null, moneyStyle);
        writeLabelValue(overview, row++, 0, "Giá vốn hàng bán", summary.getTotalCost(), null, moneyStyle);
        writeLabelValue(overview, row++, 0, "Lợi nhuận ước tính", summary.getTotalProfit(), null, moneyStyle);

        row = 7;
        Row stockSection = overview.getRow(row++);
        if (stockSection == null) stockSection = overview.createRow(row - 1);
        stockSection.createCell(3).setCellValue("TÌNH HÌNH KHO");
        stockSection.getCell(3).setCellStyle(sectionStyle);
        overview.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 3, 4));
        writeLabelValue(overview, row++, 3, "Mặt hàng đã bán", summary.getSoldProducts(), null, integerStyle);
        writeLabelValue(overview, row++, 3, "Mặt hàng chưa bán", summary.getUnsoldProducts(), null, integerStyle);
        writeLabelValue(overview, row++, 3, "Tổng sản phẩm còn kho", summary.getUnitsInStock(), null, integerStyle);
        writeLabelValue(overview, row++, 3, "Mặt hàng sắp hết", summary.getLowStockProducts(), null, integerStyle);
        writeLabelValue(overview, row++, 3, "Giá trị tồn theo giá vốn", summary.getInventoryValue(), null, moneyStyle);

        Sheet details = workbook.createSheet("Chi tiết mặt hàng");
        details.setDisplayGridlines(false);
        details.createFreezePane(0, 2);
        String[] columns = {"Mã SP", "Tên mặt hàng", "Danh mục", "Trạng thái kỳ", "Đã bán",
                "Tồn hiện tại", "Giá bán", "Giá vốn", "Doanh thu", "Vốn hàng bán", "Lợi nhuận ước tính", "Giá trị tồn"};
        Row detailTitle = details.createRow(0);
        detailTitle.setHeightInPoints(30);
        Cell detailTitleCell = detailTitle.createCell(0);
        detailTitleCell.setCellValue("CHI TIẾT MẶT HÀNG — " + period.getDisplayLabel().toUpperCase());
        detailTitleCell.setCellStyle(titleStyle);
        details.addMergedRegion(new CellRangeAddress(0, 0, 0, columns.length - 1));

        Row headers = details.createRow(1);
        headers.setHeightInPoints(28);
        for (int index = 0; index < columns.length; index++) {
            Cell cell = headers.createCell(index);
            cell.setCellValue(columns[index]);
            cell.setCellStyle(headerStyle);
        }

        int detailRowIndex = 2;
        for (ReportDAO.ProductRevenueItem item : items) {
            Row detailRow = details.createRow(detailRowIndex++);
            detailRow.createCell(0).setCellValue(item.getProductId());
            detailRow.createCell(1).setCellValue(item.getProductName());
            detailRow.createCell(2).setCellValue(item.getCategoryName());
            Cell status = detailRow.createCell(3);
            status.setCellValue(item.isSold() ? "Đã bán trong kỳ" : "Chưa bán trong kỳ");
            status.setCellStyle(item.isSold() ? positiveStyle : mutedStyle);
            setNumericCell(detailRow, 4, item.getQuantitySold(), integerStyle);
            setNumericCell(detailRow, 5, item.getStockRemaining(), integerStyle);
            setNumericCell(detailRow, 6, item.getSellingPrice(), moneyStyle);
            setNumericCell(detailRow, 7, item.getCostPrice(), moneyStyle);
            setNumericCell(detailRow, 8, item.getRevenue(), moneyStyle);
            setNumericCell(detailRow, 9, item.getCostOfGoodsSold(), moneyStyle);
            setNumericCell(detailRow, 10, item.getProfit(), moneyStyle);
            setNumericCell(detailRow, 11, item.getInventoryValue(), moneyStyle);
        }

        details.setAutoFilter(new CellRangeAddress(1, Math.max(1, detailRowIndex - 1), 0, columns.length - 1));
        int[] widths = {11, 34, 20, 20, 12, 14, 16, 16, 18, 18, 18, 18};
        for (int index = 0; index < widths.length; index++) details.setColumnWidth(index, widths[index] * 256);
        details.getPrintSetup().setLandscape(true);
        details.setFitToPage(true);
        details.getPrintSetup().setFitWidth((short) 1);
        details.getPrintSetup().setFitHeight((short) 0);
        return workbook;
    }

    private void writeLabelValue(Sheet sheet, int rowIndex, int columnIndex, String label, Object value,
                                 CellStyle labelStyle, CellStyle valueStyle) {
        Row row = sheet.getRow(rowIndex);
        if (row == null) row = sheet.createRow(rowIndex);
        Cell labelCell = row.createCell(columnIndex);
        labelCell.setCellValue(label);
        if (labelStyle != null) labelCell.setCellStyle(labelStyle);
        Cell valueCell = row.createCell(columnIndex + 1);
        if (value instanceof Number number) valueCell.setCellValue(number.doubleValue());
        else valueCell.setCellValue(String.valueOf(value));
        if (valueStyle != null) valueCell.setCellStyle(valueStyle);
    }

    private void setNumericCell(Row row, int column, double value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 16);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        return style;
    }

    private CellStyle createSectionStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFont(font);
        return style;
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        return style;
    }

    private CellStyle createMoneyStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setDataFormat(workbook.createDataFormat().getFormat("#,##0 \"VND\""));
        return style;
    }

    private CellStyle createIntegerStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));
        style.setAlignment(HorizontalAlignment.RIGHT);
        return style;
    }

    private CellStyle createStatusStyle(Workbook workbook, IndexedColors fill, IndexedColors text) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(fill.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(text.getIndex());
        style.setFont(font);
        return style;
    }

    private String normalizeScope(String value) {
        if ("sold".equals(value) || "inventory".equals(value) || "unsold".equals(value)) return value;
        return "all";
    }

    private List<ReportDAO.ProductRevenueItem> selectItems(List<ReportDAO.ProductRevenueItem> source, String scope) {
        List<ReportDAO.ProductRevenueItem> selected = new ArrayList<>();
        for (ReportDAO.ProductRevenueItem item : source) {
            if ("sold".equals(scope) && item.getQuantitySold() <= 0) continue;
            if ("inventory".equals(scope) && item.getStockRemaining() <= 0) continue;
            if ("unsold".equals(scope) && item.getQuantitySold() > 0) continue;
            selected.add(item);
        }
        return selected;
    }

    private String scopeLabel(String scope) {
        return switch (scope) {
            case "sold" -> "Mặt hàng đã bán trong kỳ";
            case "inventory" -> "Mặt hàng còn tồn kho";
            case "unsold" -> "Mặt hàng chưa bán trong kỳ";
            default -> "Toàn bộ mặt hàng";
        };
    }

    private boolean isAdminOrStaff(HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        Boolean hardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        return (currentUser != null && currentUser.getIsAdmin() > 0)
                || Boolean.TRUE.equals(hardcodedAdmin);
    }
}
