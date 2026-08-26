package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class StockReceipt {
    private final int id;
    private final String receiptCode;
    private final LocalDate importDate;
    private final String supplier;
    private final String note;
    private final double totalAmount;
    private final int totalQuantity;
    private final int itemCount;
    private final int productCount;
    private final LocalDateTime createdAt;

    public StockReceipt(int id, String receiptCode, LocalDate importDate, String supplier, String note,
            double totalAmount, int totalQuantity, int itemCount, int productCount, LocalDateTime createdAt) {
        this.id = id;
        this.receiptCode = receiptCode;
        this.importDate = importDate;
        this.supplier = supplier;
        this.note = note;
        this.totalAmount = totalAmount;
        this.totalQuantity = totalQuantity;
        this.itemCount = itemCount;
        this.productCount = productCount;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public String getReceiptCode() { return receiptCode; }
    public LocalDate getImportDate() { return importDate; }
    public String getSupplier() { return supplier; }
    public String getNote() { return note; }
    public double getTotalAmount() { return totalAmount; }
    public int getTotalQuantity() { return totalQuantity; }
    public int getItemCount() { return itemCount; }
    public int getProductCount() { return productCount; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
