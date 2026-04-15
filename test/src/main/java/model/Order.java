package model;

import java.sql.Date;

public class Order {
	public static final String STATUS_PROCESSING = "Dang xu ly";
	public static final String STATUS_PENDING_MOMO = "Cho thanh toan MoMo";
	public static final String STATUS_PAID_PROCESSING = "Da thanh toan - Dang xu ly";
	public static final String STATUS_SHIPPING = "Dang giao hang";
	public static final String STATUS_SUCCESS = "Giao thanh cong";
	public static final String STATUS_MOMO_FAILED = "Thanh toan MoMo that bai";
	public static final String STATUS_CANCELLED = "Da huy";

	private int id;
	private int userId;
	private double totalMoney;
	private String address;
	private String status;
	private Date createdAt;
	private String userName;
	private String phoneNumber;
	private String paymentMethod;

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

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
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

	public String getNormalizedStatus() {
		String rawStatus = status == null ? "" : status.trim();
		String lowerStatus = rawStatus.toLowerCase();

		if (lowerStatus.contains("momo") && lowerStatus.contains("thất bại")) {
			return STATUS_MOMO_FAILED;
		}
		if (lowerStatus.contains("chờ thanh toán momo")) {
			return STATUS_PENDING_MOMO;
		}
		if (lowerStatus.contains("đã thanh toán") && lowerStatus.contains("xử lý")) {
			return STATUS_PAID_PROCESSING;
		}
		if (lowerStatus.contains("giao thành công") || lowerStatus.contains("success")
				|| lowerStatus.contains("thành công")) {
			return STATUS_SUCCESS;
		}
		if (lowerStatus.contains("đang giao hàng")
				|| (lowerStatus.contains("giao") && !lowerStatus.contains("thành công"))) {
			return STATUS_SHIPPING;
		}
		if (lowerStatus.contains("đã hủy") || lowerStatus.contains("cancel") || lowerStatus.contains("huy")) {
			return STATUS_CANCELLED;
		}
		if (lowerStatus.contains("đang xử lý") || lowerStatus.contains("processing") || lowerStatus.contains("xu ly")) {
			return STATUS_PROCESSING;
		}
		return rawStatus;
	}

	public String getDisplayStatus() {
		switch (getNormalizedStatus()) {
		case STATUS_PROCESSING:
			return "Đang xử lý";
		case STATUS_PENDING_MOMO:
			return "Chờ thanh toán";
		case STATUS_PAID_PROCESSING:
			return "Đã thanh toán - đang xử lý";
		case STATUS_SHIPPING:
			return "Đang giao hàng";
		case STATUS_SUCCESS:
			return "Giao thành công";
		case STATUS_MOMO_FAILED:
			return "Thanh toán MoMo thất bại";
		case STATUS_CANCELLED:
			return "Đã hủy";
		default:
			return status == null || status.isBlank() ? "Không xác định" : status;
		}
	}

	public boolean isProcessingStatus() {
		String normalizedStatus = getNormalizedStatus();
		return STATUS_PROCESSING.equals(normalizedStatus)
				|| STATUS_PENDING_MOMO.equals(normalizedStatus)
				|| STATUS_PAID_PROCESSING.equals(normalizedStatus);
	}

	public boolean isShippableStatus() {
		String normalizedStatus = getNormalizedStatus();
		return STATUS_PROCESSING.equals(normalizedStatus) || STATUS_PAID_PROCESSING.equals(normalizedStatus);
	}

	public boolean isShippingStatus() {
		return STATUS_SHIPPING.equals(getNormalizedStatus());
	}

	public boolean isSuccessStatus() {
		return STATUS_SUCCESS.equals(getNormalizedStatus());
	}

	public boolean isCancelledStatus() {
		return STATUS_CANCELLED.equals(getNormalizedStatus()) || STATUS_MOMO_FAILED.equals(getNormalizedStatus());
	}

	public boolean isAdminCancelableStatus() {
		String normalizedStatus = getNormalizedStatus();
		return STATUS_PROCESSING.equals(normalizedStatus)
				|| STATUS_PENDING_MOMO.equals(normalizedStatus)
				|| STATUS_PAID_PROCESSING.equals(normalizedStatus);
	}

	public String getAdminBadgeClass() {
		if (isSuccessStatus()) {
			return "bg-success";
		}
		if (isShippingStatus()) {
			return "bg-shipping";
		}
		if (isCancelledStatus()) {
			return "bg-cancel";
		}
		return "bg-process";
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
}
