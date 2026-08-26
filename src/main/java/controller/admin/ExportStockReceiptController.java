package controller.admin;

import java.io.IOException;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;

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

import dao.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.StockImportRecord;
import model.StockReceipt;
import model.User;

@WebServlet("/admin-stock-import/export")
public class ExportStockReceiptController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xuất phiếu nhập kho.");
            return;
        }

        int receiptId;
        try {
            receiptId = Integer.parseInt(request.getParameter("receiptId"));
        } catch (Exception exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã phiếu nhập không hợp lệ.");
            return;
        }

        InventoryDAO dao = new InventoryDAO();
        StockReceipt receipt = dao.getReceiptById(receiptId);
        List<StockImportRecord> items = dao.getReceiptItems(receiptId);
        if (receipt == null || items.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu nhập kho.");
            return;
        }

        String safeCode = receipt.getReceiptCode().replaceAll("[^A-Za-z0-9_-]", "_");
        response.reset();
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=PhieuNhapKho_" + safeCode + ".xlsx");
        response.setHeader("Cache-Control", "no-store");

        try (Workbook workbook = createWorkbook(receipt, items);
             OutputStream output = response.getOutputStream()) {
            workbook.write(output);
        } catch (Exception exception) {
            getServletContext().log("Stock receipt export failed", exception);
            if (!response.isCommitted()) {
                response.reset();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Không thể xuất phiếu nhập kho lúc này.");
            }
        }
    }

    private Workbook createWorkbook(StockReceipt receipt, List<StockImportRecord> items) {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Phiếu nhập kho");
        sheet.setDisplayGridlines(false);
        sheet.createFreezePane(0, 7);

        CellStyle titleStyle = createTitleStyle(workbook);
        CellStyle labelStyle = createLabelStyle(workbook);
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle borderStyle = createBorderStyle(workbook);
        CellStyle integerStyle = createNumericStyle(workbook, "#,##0");
        CellStyle moneyStyle = createNumericStyle(workbook, "#,##0 \"VND\"");
        CellStyle totalLabelStyle = createTotalStyle(workbook, null);
        CellStyle totalIntegerStyle = createTotalStyle(workbook, "#,##0");
        CellStyle totalMoneyStyle = createTotalStyle(workbook, "#,##0 \"VND\"");

        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 7));
        Row titleRow = sheet.createRow(0);
        titleRow.setHeightInPoints(36);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("PHIẾU NHẬP KHO");
        titleCell.setCellStyle(titleStyle);

        writeLabelValue(sheet, 2, 0, "Mã phiếu", receipt.getReceiptCode(), labelStyle);
        writeLabelValue(sheet, 3, 0, "Ngày nhập", receipt.getImportDate() == null ? ""
                : receipt.getImportDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")), labelStyle);
        writeLabelValue(sheet, 2, 4, "Nhà cung cấp", valueOrDash(receipt.getSupplier()), labelStyle);
        writeLabelValue(sheet, 3, 4, "Ghi chú", valueOrDash(receipt.getNote()), labelStyle);
        writeLabelValue(sheet, 4, 0, "Số sản phẩm", receipt.getProductCount(), labelStyle);
        writeLabelValue(sheet, 4, 4, "Tổng số lượng", receipt.getTotalQuantity(), labelStyle);

        String[] headers = {"STT", "Mã SP", "Tên sản phẩm", "Màu sắc", "Kích thước",
                "Số lượng", "Đơn giá nhập", "Thành tiền"};
        Row headerRow = sheet.createRow(6);
        headerRow.setHeightInPoints(28);
        for (int column = 0; column < headers.length; column++) {
            Cell cell = headerRow.createCell(column);
            cell.setCellValue(headers[column]);
            cell.setCellStyle(headerStyle);
        }

        int rowIndex = 7;
        int sequence = 1;
        for (StockImportRecord item : items) {
            Row row = sheet.createRow(rowIndex++);
            setCell(row, 0, sequence++, integerStyle);
            setCell(row, 1, item.getProductId(), integerStyle);
            setCell(row, 2, valueOrDash(item.getProductName()), borderStyle);
            setCell(row, 3, valueOrDash(item.getColor()), borderStyle);
            setCell(row, 4, valueOrDash(item.getSize()), borderStyle);
            setCell(row, 5, item.getQuantity(), integerStyle);
            setCell(row, 6, item.getUnitCost(), moneyStyle);
            setCell(row, 7, item.getTotalCost(), moneyStyle);
        }

        Row totalRow = sheet.createRow(rowIndex + 1);
        sheet.addMergedRegion(new CellRangeAddress(rowIndex + 1, rowIndex + 1, 0, 4));
        Cell totalLabel = totalRow.createCell(0);
        totalLabel.setCellValue("TỔNG CỘNG");
        totalLabel.setCellStyle(totalLabelStyle);
        Cell totalQuantity = totalRow.createCell(5);
        totalQuantity.setCellValue(receipt.getTotalQuantity());
        totalQuantity.setCellStyle(totalIntegerStyle);
        Cell emptyUnitCost = totalRow.createCell(6);
        emptyUnitCost.setCellStyle(totalLabelStyle);
        Cell totalAmount = totalRow.createCell(7);
        totalAmount.setCellValue(receipt.getTotalAmount());
        totalAmount.setCellStyle(totalMoneyStyle);

        int signatureRowIndex = rowIndex + 4;
        Row signatureRow = sheet.createRow(signatureRowIndex);
        String[] signatures = {"Người lập phiếu", "Nhà cung cấp", "Thủ kho"};
        int[] signatureColumns = {1, 4, 7};
        for (int index = 0; index < signatures.length; index++) {
            Cell cell = signatureRow.createCell(signatureColumns[index]);
            cell.setCellValue(signatures[index]);
            CellStyle signatureStyle = workbook.createCellStyle();
            signatureStyle.setAlignment(HorizontalAlignment.CENTER);
            Font font = workbook.createFont();
            font.setBold(true);
            signatureStyle.setFont(font);
            cell.setCellStyle(signatureStyle);
        }

        int[] widths = {7, 10, 36, 20, 16, 13, 18, 20};
        for (int column = 0; column < widths.length; column++) {
            sheet.setColumnWidth(column, widths[column] * 256);
        }
        sheet.setAutoFilter(new CellRangeAddress(6, Math.max(6, rowIndex - 1), 0, 7));
        sheet.getPrintSetup().setLandscape(true);
        sheet.setFitToPage(true);
        sheet.getPrintSetup().setFitWidth((short) 1);
        sheet.getPrintSetup().setFitHeight((short) 0);
        return workbook;
    }

    private void writeLabelValue(Sheet sheet, int rowIndex, int columnIndex,
            String label, Object value, CellStyle labelStyle) {
        Row row = sheet.getRow(rowIndex);
        if (row == null) {
            row = sheet.createRow(rowIndex);
        }
        Cell labelCell = row.createCell(columnIndex);
        labelCell.setCellValue(label);
        labelCell.setCellStyle(labelStyle);
        Cell valueCell = row.createCell(columnIndex + 1);
        if (value instanceof Number number) {
            valueCell.setCellValue(number.doubleValue());
        } else {
            valueCell.setCellValue(String.valueOf(value));
        }
    }

    private void setCell(Row row, int column, Object value, CellStyle style) {
        Cell cell = row.createCell(column);
        if (value instanceof Number number) {
            cell.setCellValue(number.doubleValue());
        } else {
            cell.setCellValue(String.valueOf(value));
        }
        cell.setCellStyle(style);
    }

    private CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(IndexedColors.DARK_GREEN.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 18);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        return style;
    }

    private CellStyle createLabelStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.DARK_GREEN.getIndex());
        style.setFont(font);
        return style;
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = createBorderStyle(workbook);
        style.setFillForegroundColor(IndexedColors.DARK_GREEN.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        return style;
    }

    private CellStyle createBorderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        return style;
    }

    private CellStyle createNumericStyle(Workbook workbook, String format) {
        CellStyle style = createBorderStyle(workbook);
        style.setDataFormat(workbook.createDataFormat().getFormat(format));
        style.setAlignment(HorizontalAlignment.RIGHT);
        return style;
    }

    private CellStyle createTotalStyle(Workbook workbook, String format) {
        CellStyle style = createBorderStyle(workbook);
        style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        if (format != null) {
            style.setDataFormat(workbook.createDataFormat().getFormat(format));
        }
        style.setAlignment(HorizontalAlignment.RIGHT);
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    private String valueOrDash(String value) {
        return value == null || value.isBlank() ? "—" : value;
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        User currentUser = (User) session.getAttribute("user");
        Boolean hardcodedAdmin = (Boolean) session.getAttribute("isAdmin");
        return (currentUser != null && currentUser.getIsAdmin() == 1)
                || Boolean.TRUE.equals(hardcodedAdmin);
    }
}
