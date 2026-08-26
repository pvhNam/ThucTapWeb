package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.UUID;

import model.StockImportLine;
import model.StockImportRecord;
import model.StockReceipt;

public class InventoryDAO {
    private static final int MAX_FORM_LINES = 30;
    private static final int MAX_GENERATED_VARIANTS = 120;

    public int receiveStockBatch(List<StockImportLine> sourceLines, LocalDate importDate,
            String supplier, String note) {
        Connection connection = null;
        try {
            List<AggregatedLine> lines = expandAndAggregate(sourceLines);
            if (importDate == null || importDate.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Ngày nhập kho không hợp lệ");
            }
            String normalizedSupplier = normalizeOptional(supplier, 150, "Nhà cung cấp");
            String normalizedNote = normalizeOptional(note, 500, "Ghi chú");

            connection = DBConnect.getConnection();
            if (connection == null) {
                return 0;
            }
            connection.setAutoCommit(false);

            Set<Integer> productIds = new TreeSet<>();
            for (AggregatedLine line : lines) {
                productIds.add(line.productId);
            }
            lockProducts(connection, productIds);

            Map<Integer, ProductState> productStates = new LinkedHashMap<>();
            for (int productId : productIds) {
                productStates.put(productId, loadProductState(connection, productId));
            }

            double receiptTotal = 0;
            for (AggregatedLine line : lines) {
                ProductState state = productStates.get(line.productId);
                state.incomingQuantity = Math.addExact(state.incomingQuantity, line.quantity);
                state.incomingCost += line.quantity * line.unitCost;
                receiptTotal += line.quantity * line.unitCost;
            }
            if (!Double.isFinite(receiptTotal) || receiptTotal <= 0) {
                throw new IllegalArgumentException("Tổng tiền phiếu nhập không hợp lệ");
            }

            int receiptId = insertReceipt(connection, importDate, normalizedSupplier, normalizedNote, receiptTotal);
            for (AggregatedLine line : lines) {
                ProductState state = productStates.get(line.productId);
                VariantResult variant = addVariantStock(connection, state, line);
                insertReceiptItem(connection, receiptId, importDate, normalizedSupplier, normalizedNote, line, variant);
            }
            syncProductTotals(connection, productStates);

            connection.commit();
            return receiptId;
        } catch (Exception exception) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception rollbackException) {
                    rollbackException.printStackTrace();
                }
            }
            exception.printStackTrace();
            return 0;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (Exception closeException) {
                    closeException.printStackTrace();
                }
            }
        }
    }

    public List<StockReceipt> getRecentReceipts(int requestedLimit) {
        int limit = Math.max(1, Math.min(requestedLimit, 100));
        String sql = receiptSelectSql() + " ORDER BY r.id DESC LIMIT ?";
        List<StockReceipt> receipts = new ArrayList<>();
        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, limit);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    receipts.add(mapReceipt(result));
                }
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return receipts;
    }

    public StockReceipt getReceiptById(int receiptId) {
        String sql = receiptSelectSql() + " HAVING r.id = ?";
        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, receiptId);
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return mapReceipt(result);
                }
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return null;
    }

    public List<StockImportRecord> getReceiptItems(int receiptId) {
        List<StockImportRecord> items = new ArrayList<>();
        String sql = "SELECT h.id, h.product_id, h.variant_id, h.color, h.size, h.quantity, "
                + "h.import_price, h.import_date, h.supplier, h.note, h.created_at, "
                + "p.name AS product_name, p.img AS product_image "
                + "FROM import_history h LEFT JOIN product p ON p.pid = h.product_id "
                + "WHERE h.receipt_id = ? ORDER BY p.name, h.color, h.size, h.id";
        try (Connection connection = DBConnect.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, receiptId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    items.add(mapReceiptItem(result));
                }
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return items;
    }

    private List<AggregatedLine> expandAndAggregate(List<StockImportLine> sourceLines) {
        if (sourceLines == null || sourceLines.isEmpty() || sourceLines.size() > MAX_FORM_LINES) {
            throw new IllegalArgumentException("Số dòng sản phẩm không hợp lệ");
        }

        Map<VariantKey, AggregatedLine> aggregated = new LinkedHashMap<>();
        int generatedCount = 0;
        for (StockImportLine source : sourceLines) {
            if (source == null || source.getProductId() <= 0 || source.getQuantityPerVariant() <= 0
                    || source.getQuantityPerVariant() > 1_000_000
                    || !Double.isFinite(source.getUnitCost()) || source.getUnitCost() <= 0) {
                throw new IllegalArgumentException("Dòng sản phẩm không hợp lệ");
            }
            List<String> colors = normalizeTokens(source.getColors(), 50, "Màu sắc");
            List<String> sizes = normalizeTokens(source.getSizes(), 20, "Kích thước");
            generatedCount = Math.addExact(generatedCount, Math.multiplyExact(colors.size(), sizes.size()));
            if (generatedCount > MAX_GENERATED_VARIANTS) {
                throw new IllegalArgumentException("Phiếu nhập có quá nhiều phân loại");
            }

            for (String color : colors) {
                for (String size : sizes) {
                    VariantKey key = new VariantKey(source.getProductId(),
                            color.toLowerCase(Locale.ROOT), size.toLowerCase(Locale.ROOT));
                    AggregatedLine existing = aggregated.get(key);
                    if (existing == null) {
                        aggregated.put(key, new AggregatedLine(source.getProductId(), color, size,
                                source.getQuantityPerVariant(), source.getUnitCost()));
                    } else {
                        double combinedCost = existing.quantity * existing.unitCost
                                + source.getQuantityPerVariant() * source.getUnitCost();
                        existing.quantity = Math.addExact(existing.quantity, source.getQuantityPerVariant());
                        existing.unitCost = combinedCost / existing.quantity;
                    }
                }
            }
        }
        if (aggregated.isEmpty()) {
            throw new IllegalArgumentException("Phiếu nhập chưa có phân loại");
        }
        return new ArrayList<>(aggregated.values());
    }

    private List<String> normalizeTokens(List<String> values, int maxLength, String fieldName) {
        if (values == null || values.isEmpty()) {
            throw new IllegalArgumentException(fieldName + " không được để trống");
        }
        Map<String, String> unique = new LinkedHashMap<>();
        for (String value : values) {
            String normalized = value == null ? "" : value.trim();
            if (normalized.isEmpty() || normalized.length() > maxLength) {
                throw new IllegalArgumentException(fieldName + " không hợp lệ");
            }
            unique.putIfAbsent(normalized.toLowerCase(Locale.ROOT), normalized);
        }
        return new ArrayList<>(unique.values());
    }

    private void lockProducts(Connection connection, Set<Integer> productIds) throws Exception {
        String placeholders = String.join(",", Collections.nCopies(productIds.size(), "?"));
        String sql = "SELECT pid FROM product WHERE pid IN (" + placeholders + ") ORDER BY pid FOR UPDATE";
        int found = 0;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            int parameter = 1;
            for (int productId : productIds) {
                statement.setInt(parameter++, productId);
            }
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    found++;
                }
            }
        }
        if (found != productIds.size()) {
            throw new IllegalArgumentException("Có sản phẩm không tồn tại");
        }
    }

    private ProductState loadProductState(Connection connection, int productId) throws Exception {
        String sql = "SELECT p.amount, p.cost_price, COUNT(v.id) AS variant_count, "
                + "COALESCE(SUM(v.stock_quantity), 0) AS variant_stock "
                + "FROM product p LEFT JOIN product_variants v ON v.product_id = p.pid "
                + "WHERE p.pid = ? GROUP BY p.pid, p.amount, p.cost_price";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    throw new IllegalArgumentException("Sản phẩm không tồn tại");
                }
                int variantCount = result.getInt("variant_count");
                int legacyStock = Math.max(result.getInt("amount"), 0);
                int variantStock = Math.max(result.getInt("variant_stock"), 0);
                return new ProductState(productId,
                        variantCount > 0 ? variantStock : legacyStock,
                        Math.max(result.getDouble("cost_price"), 0),
                        variantCount > 0);
            }
        }
    }

    private int insertReceipt(Connection connection, LocalDate importDate, String supplier,
            String note, double totalAmount) throws Exception {
        String temporaryCode = "TMP-" + UUID.randomUUID();
        String sql = "INSERT INTO stock_receipts "
                + "(receipt_code, import_date, supplier, note, total_amount, created_at) "
                + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        int receiptId;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, temporaryCode);
            statement.setDate(2, Date.valueOf(importDate));
            statement.setString(3, supplier);
            statement.setString(4, note);
            statement.setDouble(5, totalAmount);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new IllegalStateException("Không lấy được mã phiếu nhập");
                }
                receiptId = keys.getInt(1);
            }
        }

        String receiptCode = "PNK-" + importDate.format(DateTimeFormatter.BASIC_ISO_DATE)
                + "-" + String.format(Locale.ROOT, "%06d", receiptId);
        try (PreparedStatement statement = connection.prepareStatement(
                "UPDATE stock_receipts SET receipt_code = ? WHERE id = ?")) {
            statement.setString(1, receiptCode);
            statement.setInt(2, receiptId);
            statement.executeUpdate();
        }
        return receiptId;
    }

    private VariantResult addVariantStock(Connection connection, ProductState state,
            AggregatedLine line) throws Exception {
        int variantId = 0;
        String actualColor = line.color;
        String actualSize = line.size;
        String findSql = "SELECT id, color, size FROM product_variants "
                + "WHERE product_id = ? AND color = ? AND size = ? ORDER BY id LIMIT 1 FOR UPDATE";
        try (PreparedStatement statement = connection.prepareStatement(findSql)) {
            statement.setInt(1, line.productId);
            statement.setString(2, line.color);
            statement.setString(3, line.size);
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    variantId = result.getInt("id");
                    actualColor = result.getString("color");
                    actualSize = result.getString("size");
                }
            }
        }

        if (variantId > 0) {
            try (PreparedStatement statement = connection.prepareStatement(
                    "UPDATE product_variants SET stock_quantity = stock_quantity + ? WHERE id = ?")) {
                statement.setInt(1, line.quantity);
                statement.setInt(2, variantId);
                if (statement.executeUpdate() != 1) {
                    throw new IllegalStateException("Không thể cập nhật tồn kho phân loại");
                }
            }
        } else {
            int initialStock = state.hasVariants ? line.quantity : state.oldStock + line.quantity;
            String insertSql = "INSERT INTO product_variants "
                    + "(product_id, color, size, stock_quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(
                    insertSql, Statement.RETURN_GENERATED_KEYS)) {
                statement.setInt(1, line.productId);
                statement.setString(2, line.color);
                statement.setString(3, line.size);
                statement.setInt(4, initialStock);
                statement.executeUpdate();
                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new IllegalStateException("Không lấy được mã phân loại vừa tạo");
                    }
                    variantId = keys.getInt(1);
                }
            }
            state.hasVariants = true;
        }
        return new VariantResult(variantId, actualColor, actualSize);
    }

    private void insertReceiptItem(Connection connection, int receiptId, LocalDate importDate,
            String supplier, String note, AggregatedLine line, VariantResult variant) throws Exception {
        String sql = "INSERT INTO import_history "
                + "(receipt_id, product_id, quantity, import_price, variant_id, color, size, "
                + "import_date, supplier, note, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, receiptId);
            statement.setInt(2, line.productId);
            statement.setInt(3, line.quantity);
            statement.setDouble(4, line.unitCost);
            statement.setInt(5, variant.id);
            statement.setString(6, variant.color);
            statement.setString(7, variant.size);
            statement.setDate(8, Date.valueOf(importDate));
            statement.setString(9, supplier);
            statement.setString(10, note);
            statement.executeUpdate();
        }
    }

    private void syncProductTotals(Connection connection, Map<Integer, ProductState> states) throws Exception {
        String sql = "UPDATE product SET amount = ?, cost_price = ? WHERE pid = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (ProductState state : states.values()) {
                int newTotal = Math.addExact(state.oldStock, state.incomingQuantity);
                double newCost = state.oldStock <= 0 || state.oldCost <= 0
                        ? state.incomingCost / state.incomingQuantity
                        : (state.oldCost * state.oldStock + state.incomingCost) / newTotal;
                statement.setInt(1, newTotal);
                statement.setDouble(2, newCost);
                statement.setInt(3, state.productId);
                statement.addBatch();
            }
            statement.executeBatch();
        }
    }

    private String receiptSelectSql() {
        return "SELECT r.id, r.receipt_code, r.import_date, r.supplier, r.note, r.total_amount, r.created_at, "
                + "COALESCE(SUM(h.quantity), 0) AS total_quantity, COUNT(h.id) AS item_count, "
                + "COUNT(DISTINCT h.product_id) AS product_count "
                + "FROM stock_receipts r LEFT JOIN import_history h ON h.receipt_id = r.id "
                + "GROUP BY r.id, r.receipt_code, r.import_date, r.supplier, r.note, r.total_amount, r.created_at";
    }

    private StockReceipt mapReceipt(ResultSet result) throws Exception {
        Date importDate = result.getDate("import_date");
        Timestamp createdAt = result.getTimestamp("created_at");
        return new StockReceipt(
                result.getInt("id"),
                result.getString("receipt_code"),
                importDate == null ? null : importDate.toLocalDate(),
                result.getString("supplier"),
                result.getString("note"),
                result.getDouble("total_amount"),
                result.getInt("total_quantity"),
                result.getInt("item_count"),
                result.getInt("product_count"),
                createdAt == null ? null : createdAt.toLocalDateTime());
    }

    private StockImportRecord mapReceiptItem(ResultSet result) throws Exception {
        Date date = result.getDate("import_date");
        Timestamp timestamp = result.getTimestamp("created_at");
        LocalDateTime createdAt = timestamp == null ? null : timestamp.toLocalDateTime();
        LocalDate importDate = date == null
                ? (createdAt == null ? null : createdAt.toLocalDate())
                : date.toLocalDate();
        return new StockImportRecord(
                result.getInt("id"),
                result.getInt("product_id"),
                result.getInt("variant_id"),
                result.getString("product_name"),
                result.getString("product_image"),
                result.getString("color"),
                result.getString("size"),
                result.getInt("quantity"),
                result.getDouble("import_price"),
                importDate,
                result.getString("supplier"),
                result.getString("note"),
                createdAt);
    }

    private String normalizeOptional(String value, int maxLength, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        String normalized = value.trim();
        if (normalized.length() > maxLength) {
            throw new IllegalArgumentException(fieldName + " quá dài");
        }
        return normalized;
    }

    private record VariantKey(int productId, String color, String size) {}

    private static class AggregatedLine {
        private final int productId;
        private final String color;
        private final String size;
        private int quantity;
        private double unitCost;

        private AggregatedLine(int productId, String color, String size, int quantity, double unitCost) {
            this.productId = productId;
            this.color = color;
            this.size = size;
            this.quantity = quantity;
            this.unitCost = unitCost;
        }
    }

    private static class ProductState {
        private final int productId;
        private final int oldStock;
        private final double oldCost;
        private boolean hasVariants;
        private int incomingQuantity;
        private double incomingCost;

        private ProductState(int productId, int oldStock, double oldCost, boolean hasVariants) {
            this.productId = productId;
            this.oldStock = oldStock;
            this.oldCost = oldCost;
            this.hasVariants = hasVariants;
        }
    }

    private record VariantResult(int id, String color, String size) {}
}
