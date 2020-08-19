package com.techelevator.model;

import java.util.List;

import javax.validation.constraints.Positive;

public class Location {
	@Positive
	private long locationId;
	private String name;
	private String description;
	private String bannerImgURL;
	private String smallImgURL;
	private double longitudeX;
	private double latitudeY;
	private List<Category> categories;
	private List<LocationHours> locationHours;
	
	public long getLocationId() {
		return locationId;
	}
	public void setLocationId(long locationId) {
		this.locationId = locationId;
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
	public String getBannerImgURL() {
		return bannerImgURL;
	}
	public void setBannerImgURL(String bannerImgURL) {
		this.bannerImgURL = bannerImgURL;
	}
	public String getSmallImgURL() {
		return smallImgURL;
	}
	public void setSmallImgURL(String smallImgURL) {
		this.smallImgURL = smallImgURL;
	}
	public double getLongitudeX() {
		return longitudeX;
	}
	public void setLongitudeX(double longitudeX) {
		this.longitudeX = longitudeX;
	}
	public double getLatitudeY() {
		return latitudeY;
	}
	public void setLatitudeY(double latitudeY) {
		this.latitudeY = latitudeY;
	}
	public List<Category> getCategories() {
		return categories;
	}
	public void setCategories(List<Category> categories) {
		this.categories = categories;
	}
	public List<LocationHours> getLocationHours() {
		return locationHours;
	}
	public void setLocationHours(List<LocationHours> locationHours) {
		this.locationHours = locationHours;
	}
}
