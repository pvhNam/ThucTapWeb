package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class StockImportRecord {
    private final int id;
    private final int productId;
    private final int variantId;
    private final String productName;
    private final String productImage;
    private final String color;
    private final String size;
    private final int quantity;
    private final double unitCost;
    private final LocalDate importDate;
    private final String supplier;
    private final String note;
    private final LocalDateTime createdAt;

    public StockImportRecord(int id, int productId, int variantId, String productName, String productImage,
            String color, String size, int quantity, double unitCost, LocalDate importDate,
            String supplier, String note, LocalDateTime createdAt) {
        this.id = id;
        this.productId = productId;
        this.variantId = variantId;
        this.productName = productName;
        this.productImage = productImage;
        this.color = color;
        this.size = size;
        this.quantity = quantity;
        this.unitCost = unitCost;
        this.importDate = importDate;
        this.supplier = supplier;
        this.note = note;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public int getProductId() { return productId; }
    public int getVariantId() { return variantId; }
    public String getProductName() { return productName; }
    public String getProductImage() { return productImage; }
    public String getColor() { return color; }
    public String getSize() { return size; }
    public int getQuantity() { return quantity; }
    public double getUnitCost() { return unitCost; }
    public double getTotalCost() { return unitCost * quantity; }
    public LocalDate getImportDate() { return importDate; }
    public String getSupplier() { return supplier; }
    public String getNote() { return note; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
