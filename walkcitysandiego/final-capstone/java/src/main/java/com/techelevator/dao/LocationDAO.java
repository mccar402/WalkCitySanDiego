package com.techelevator.dao;

import java.util.List;

import com.techelevator.model.Category;
import com.techelevator.model.Location;

public interface LocationDAO {
	
	/**
	 * Queries underlying data storage for a list of all locations of interest.
	 * @return List of all locations
	 */
	List<Location> getAllLocations();
	
	/**
	 * Returns information for one specific location of interest.
	 * @param locationId (int) Unique ID for the requested location
	 * @return Location object
	 */
	Location getLocationById(long locationId);
	
	/**
	 * Queries underlying data storage for a list of all categories
	 * @return List of categories
	 */
	List<Category> getAllCategories();
	
	/**
	 * Given a location or its ID number, generate a list of all categories
	 * it belongs to. For example, if the San Diego Zoo has an ID of 1, 
	 * getCategoriesByLocationId(1) should return { "Park" }
	 * @param locationId (int) Unique ID number of a location
	 * @return list of categories
	 */
	List<Category> getCategoriesByLocationId(long locationId);
	
	public Location addNewLocation(Location newLoc);
	
	public int countLocations();

}
