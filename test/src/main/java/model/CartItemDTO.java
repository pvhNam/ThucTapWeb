package model;

public class CartItemDTO {
    private product product; // Chứa thông tin chi tiết sp (tên, giá, ảnh)
    private int quantity;    // Số lượng mua
    private boolean isSelected; // Trạng thái tích chọn (để tính tổng tiền)

    public CartItemDTO(model.product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.isSelected = true; // Mặc định khi thêm vào là được chọn
    }

    public double getTotalPrice() {
        return product.getPrice() * quantity;
    }

    // Getters and Setters
    public product getProduct() { return product; }
    public void setProduct(product product) { this.product = product; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public boolean isSelected() { return isSelected; }
    public void setSelected(boolean isSelected) { this.isSelected = isSelected; }
}