package model;

import java.sql.Date;

public class Order {
	private int id;
	private int userId;
	private double totalMoney;
	private String address;
	private String status;
	private Date createdAt;
	private String userName;
	private String phoneNumber;

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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	// --- Các Getter/Setter cũ (Giữ nguyên) ---
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
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