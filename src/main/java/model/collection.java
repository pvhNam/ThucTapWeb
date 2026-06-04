package model;


public class collection {
	public int cid;
	public String title;
	public String description;
	public String imgPath;
	public double price;

	public collection(int cid, String title, String description, String imgPath, double price) {
		super();
		this.cid = cid;
		this.title = title;
		this.description = description;
		this.imgPath = imgPath;
		this.price = price;
	}

	public int getCid() {
		return cid;
	}

	public void setCid(int cid) {
		this.cid = cid;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImgPath() {
		return imgPath;
	}

	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

}
