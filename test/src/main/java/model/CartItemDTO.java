package model;

public class CartItemDTO {
	private Product product;
	private int quantity; // Số lượng mua
	private boolean isSelected;

	public CartItemDTO(Product product, int quantity) {
		this.product = product;
		this.quantity = quantity;
		this.isSelected = true;
	}

	public double getTotalPrice() {
		return product.getPrice() * quantity;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public boolean isSelected() {
		return isSelected;
	}

	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}
}