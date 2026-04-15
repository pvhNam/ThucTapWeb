package model;

public class CartItemDTO {
	private product product; 
	private int quantity; // Số lượng mua
	private boolean isSelected; 

	public CartItemDTO(model.product product, int quantity) {
		this.product = product;
		this.quantity = quantity;
		this.isSelected = true; 
	}

	public double getTotalPrice() {
		return product.getPrice() * quantity;
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

	public boolean isSelected() {
		return isSelected;
	}

	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}
}