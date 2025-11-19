package model;

public class product {
	public int pid;
	public String pdescription;
	public double price;
	public int cid;
	public String color;
	public String size;
	public int stockquantyti;

	public product(int pid, String pdescription, double price, int cid, String color, String size, int stockquantyti) {
		super();
		this.pid = pid;
		this.pdescription = pdescription;
		this.price = price;
		this.cid = cid;
		this.color = color;
		this.size = size;
		this.stockquantyti = stockquantyti;
	}

	public int getPid() {
		return pid;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}

	public String getPdescription() {
		return pdescription;
	}

	public void setPdescription(String pdescription) {
		this.pdescription = pdescription;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getCid() {
		return cid;
	}

	public void setCid(int cid) {
		this.cid = cid;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public int getStockquantyti() {
		return stockquantyti;
	}

	public void setStockquantyti(int stockquantyti) {
		this.stockquantyti = stockquantyti;
	}

}
