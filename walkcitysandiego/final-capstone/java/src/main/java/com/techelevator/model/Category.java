package com.techelevator.model;

public class Category {
	private long categoryId;
	private String name;
	private String iconImgURL;
	
	public long getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(long categoryId) {
		this.categoryId = categoryId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIconImgURL() {
		return iconImgURL;
	}
	public void setIconImgURL(String iconImgURL) {
		this.iconImgURL = iconImgURL;
	}
	@Override
	public boolean equals(Object o) {
		if (this == o) {
			return true;
		} else if (o == null || this.getClass() != o.getClass()) {
			return false;
		} else {
			Category category = (Category)o;
			return (this.categoryId == category.getCategoryId() &&
					this.name.equals(category.getName()) &&
					this.iconImgURL.equalsIgnoreCase(category.getIconImgURL()));
		}
	}
	
}
