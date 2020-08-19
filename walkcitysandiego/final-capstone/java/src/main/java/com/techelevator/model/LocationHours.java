package com.techelevator.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

public class LocationHours {
	private long locationHoursId;
	private LocalTime openTime;
	private LocalTime closeTime;
	private String dayOfWeekName;
	private int validFrom;
	private int validTo;
	
	public long getLocationHoursId() {
		return locationHoursId;
	}
	public void setLocationHoursId(long locationHoursId) {
		this.locationHoursId = locationHoursId;
	}
	public String getOpenTime() {
		return openTime.format(DateTimeFormatter.ofPattern("h:mm a"));
	}
	public void setOpenTime(LocalTime openTime) {
		this.openTime = openTime;
	}
	public String getCloseTime() {
		return closeTime.format(DateTimeFormatter.ofPattern("h:mm a"));
	}
	public void setCloseTime(LocalTime closeTime) {
		this.closeTime = closeTime;
	}
	public String getDayOfWeekName() {
		return dayOfWeekName;
	}
	public void setDayOfWeekName(String dayOfWeekName) {
		this.dayOfWeekName = dayOfWeekName;
	}
	public int getValidFrom() {
		return validFrom;
	}
	public void setValidFrom(int validFrom) {
		this.validFrom = validFrom;
	}
	public int getValidTo() {
		return validTo;
	}
	public void setValidTo(int validTo) {
		this.validTo = validTo;
	}
}
