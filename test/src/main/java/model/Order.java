package model;

import java.sql.Date;

public class Order {
	private int id;
	private int userId;
	private double totalMoney;
	private String address;
	private String status;
	private Date createdAt;

	public Order() {
	}

	public Order(int id, int userId, double totalMoney, String address, String status, Date createdAt) {
		this.id = id;
		this.userId = userId;
		this.totalMoney = totalMoney;
		this.address = address;
		this.status = status;
		this.createdAt = createdAt;
	}

	// Getter và Setter cho tất cả các thuộc tính (bắt buộc phải có để JSP đọc được)
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public double getTotalMoney() {
		return totalMoney;
	}

	public void setTotalMoney(double totalMoney) {
		this.totalMoney = totalMoney;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
}