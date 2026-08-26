package model;

public class OrderDetail {
	private int id;
	private int orderId;
	private int productId;
	private double price;
	private int quantity;
	private String color;
	private String size;
	private Product product;

	public OrderDetail(int id, int orderId, int productId, double price, int quantity, Product product) {
		this(id, orderId, productId, price, quantity, "", "", product);
	}

	public OrderDetail(int id, int orderId, int productId, double price, int quantity,
			String color, String size, Product product) {
		this.id = id;
		this.orderId = orderId;
		this.productId = productId;
		this.price = price;
		this.quantity = quantity;
		this.color = color;
		this.size = size;
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

	public String getColor() {
		return color;
	}

	public String getSize() {
		return size;
	}

	public Product getProduct() {
		return product;
	}
}
