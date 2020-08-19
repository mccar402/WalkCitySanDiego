package com.techelevator.model;

import java.time.LocalDate;

public class Badge {
	private long badgeId;
	private String badgeImgURL;
	private String name;
	private String description;
	//dateEarned needs to be nullable
	private LocalDate dateEarned;
	private long categoryId;
	private int numOfCheckins;
	private boolean singleLocation = false;
	
	public long getBadgeId() {
		return badgeId;
	}
	public void setBadgeId(long badgeId) {
		this.badgeId = badgeId;
	}
	public String getBadgeImgURL() {
		return badgeImgURL;
	}
	public void setBadgeImgURL(String badgeImgURL) {
		this.badgeImgURL = badgeImgURL;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public LocalDate getDateEarned() {
		return dateEarned;
	}
	public void setDateEarned(LocalDate dateEarned) {
		this.dateEarned = dateEarned;
	}
	public boolean isSingleLocation() {
		return singleLocation;
	}
	public void setSingleLocation(boolean singleLocation) {
		this.singleLocation = singleLocation;
	}
	public int getNumOfCheckins() {
		return numOfCheckins;
	}
	public void setNumOfCheckins(int numOfCheckins) {
		this.numOfCheckins = numOfCheckins;
	}
	public long getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(long categoryId) {
		this.categoryId = categoryId;
	}
}
