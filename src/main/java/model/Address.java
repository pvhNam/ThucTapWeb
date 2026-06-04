package model;

public class Address {
    private int id;
    private int userId;
    private String receiverName;
    private String phone;
    private String specificAddress;
    private String ward;
    private String district;
    private String city;
    private boolean isDefault;

    public Address() {
    }

    public Address(int id, int userId, String receiverName, String phone, String specificAddress, String ward, String district, String city, boolean isDefault) {
        this.id = id;
        this.userId = userId;
        this.receiverName = receiverName;
        this.phone = phone;
        this.specificAddress = specificAddress;
        this.ward = ward;
        this.district = district;
        this.city = city;
        this.isDefault = isDefault;
    }

    // --- GETTERS & SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getSpecificAddress() { return specificAddress; }
    public void setSpecificAddress(String specificAddress) { this.specificAddress = specificAddress; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }
}