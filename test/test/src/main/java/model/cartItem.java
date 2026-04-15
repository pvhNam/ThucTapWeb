package model;

public class cartItem {
    private product product; // Chứa thông tin sản phẩm
    private int quantity;    // Số lượng mua

    public cartItem() {
    }

    public cartItem(product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public product getProduct() {
        return product;
    }

    public void setProduct(product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    // Tính tổng tiền của riêng item  = giá * số lượng
    public double getTotalPrice() {
        return product.getPrice() * quantity;
    }
}