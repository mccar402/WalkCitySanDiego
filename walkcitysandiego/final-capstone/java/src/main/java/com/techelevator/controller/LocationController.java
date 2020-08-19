package com.techelevator.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.techelevator.dao.LocationDAO;
import com.techelevator.model.Category;
import com.techelevator.model.Location;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class LocationController {
	
	@Autowired
	LocationDAO locationDAO;
	
	@RequestMapping ( path = "/locations" )
	public List<Location> listAllLocations() {
		List<Location> allLocations = locationDAO.getAllLocations();
		return allLocations;
	}
	
	@RequestMapping ( path = "/locations/{id}" )
	public Location getLocation(@PathVariable("id") long locationId) {
		Location currentLocation = locationDAO.getLocationById(locationId);
		return currentLocation;
	}
	
	@RequestMapping ( path = "/categories" )
	public List<Category> listAllCategories() {
		List<Category> allCategories = locationDAO.getAllCategories();
		return allCategories;
	}
	
	@RequestMapping (path = "/locations", method = RequestMethod.POST)
	public Location addLocation(@RequestBody Location location) {
		return locationDAO.addNewLocation(location);
	}

}
