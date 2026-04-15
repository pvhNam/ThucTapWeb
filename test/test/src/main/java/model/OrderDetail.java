package model;

public class OrderDetail {
	private int id;
	private int orderId;
	private int productId;
	private double price;
	private int quantity;
	private product product; 

	public OrderDetail(int id, int orderId, int productId, double price, int quantity, product product) {
		this.id = id;
		this.orderId = orderId;
		this.productId = productId;
		this.price = price;
		this.quantity = quantity;
		this.product = product;
	}

	public int getProductId() {
		return productId;
	}

	public double getPrice() {
		return price;
	}

	public int getQuantity() {
		return quantity;
	}

	public product getProduct() {
		return product;
	}
}