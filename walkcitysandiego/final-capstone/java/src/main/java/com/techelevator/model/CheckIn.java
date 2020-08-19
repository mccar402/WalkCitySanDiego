package com.techelevator.model;

import java.time.LocalDate;

public class CheckIn {
	private Location location;
	private LocalDate checkInDate;
	
	public Location getLocation() {
		return location;
	}
	public void setLocation(Location location) {
		this.location = location;
	}
	
	public LocalDate getCheckInDate() {
		return checkInDate;
	}
	public void setCheckInDate(LocalDate checkInDate) {
		this.checkInDate = checkInDate;
	}
}
