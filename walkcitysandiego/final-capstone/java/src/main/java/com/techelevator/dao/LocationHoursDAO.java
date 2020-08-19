package com.techelevator.dao;

import java.util.List;

import com.techelevator.model.LocationHours;

public interface LocationHoursDAO {
	
	public List<LocationHours> getLocationHoursByLocationId(long locationId);
}
