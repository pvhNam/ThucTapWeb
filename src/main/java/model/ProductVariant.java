package model;

public class ProductVariant {
    private int id;
    private int productId;
    private String color;
    private String size;
    private int stockQuantity;

    public ProductVariant() {}

    public ProductVariant(int id, int productId, String color, String size, int stockQuantity) {
        this.id = id;
        this.productId = productId;
        this.color = color;
        this.size = size;
        this.stockQuantity = stockQuantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
}