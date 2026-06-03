package model;

import java.sql.Date;

public class News {
	private int id;
	private String title;
	private String shortDesc;
	private String content;
	private String image;
	private Date createdAt;

	public News() {
	}

	public News(int id, String title, String shortDesc, String content, String image, Date createdAt) {
		this.id = id;
		this.title = title;
		this.shortDesc = shortDesc;
		this.content = content;
		this.image = image;
		this.createdAt = createdAt;
	}

	// Getters and Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getShortDesc() {
		return shortDesc;
	}

	public void setShortDesc(String shortDesc) {
		this.shortDesc = shortDesc;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
}