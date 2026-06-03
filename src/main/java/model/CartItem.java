package model;

public class CartItem {
    private Product product;
    private int quantity;
    private String color;
    private String size;

    public CartItem() {}

    public CartItem(Product product, int quantity, String color, String size) {
        this.product = product;
        this.quantity = quantity;
        this.color = color;
        this.size = size;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public double getTotalPrice() {
        return product.getPrice() * quantity;
    }
}