package com.techelevator.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Service;

import com.techelevator.model.Category;
import com.techelevator.model.Location;

@Service
public class LocationSqlDAO implements LocationDAO {

	private JdbcTemplate jdbcTemplate;

	public LocationSqlDAO(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	// Everything to do with just the locations table
	
	@Override
	public List<Location> getAllLocations() {
		List<Location> locations = new ArrayList<>();
		// TODO: Update with hours later
		String sqlFindAll = "SELECT * FROM location";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlFindAll);
		locations = mapResultsToLocations(results);
		return locations;
	}
	
	@Override
	public Location getLocationById(long locationId) {
		Location retrievedLocation = new Location();
		String sqlLocation = "SELECT * FROM location WHERE location_id = ?";
		SqlRowSet result = jdbcTemplate.queryForRowSet(sqlLocation, locationId);
		if (result.next()) {
			retrievedLocation = mapRowToLocation(result);
		}
		return retrievedLocation;
	}
	
	@Override
	public Location addNewLocation(Location newLoc) {
		String sql = "INSERT INTO location(name, description, banner_img_url, small_img_url, "
				+ "latitude_y_coord, longitude_x_coord) "
				+ "VALUES(?, ?, ?, ?, ?, ?)";
		
		jdbcTemplate.update(sql, newLoc.getName(), newLoc.getDescription(), newLoc.getBannerImgURL(), 
				newLoc.getSmallImgURL(), newLoc.getLatitudeY(), newLoc.getLongitudeX());
		
		return newLoc;
	}
	
	@Override
	public int countLocations() {
		int count = 0;
		String sql = "SELECT COUNT (location_id) FROM location";
		
		SqlRowSet result = jdbcTemplate.queryForRowSet(sql);
		if(result.next()) {
			count = result.getInt(1);
		}
		return count;
	}
	
	

	/**
	 * Maps columns from just the location table to a Location object Affected
	 * properties: locationId, name, description, bannerImgURL, smallImgURL,
	 * longitudeX, and latitudeY
	 * 
	 * @param row SQL result
	 * @return Location object without the Lists for categories and hours
	 */
	private Location mapRowToLocation(SqlRowSet row) {
		Location currentLocation = new Location();
		currentLocation.setLocationId(row.getLong("location_id"));
		currentLocation.setName(row.getString("name"));
		currentLocation.setDescription(row.getString("description"));

		// In case banner image url is null
		String bigImgURL = (row.getString("banner_img_url") == null) ? "" : row.getString("banner_img_url");
		currentLocation.setBannerImgURL(bigImgURL);

		// In case small image url is null
		String smallImgURL = (row.getString("small_img_url") == null) ? "" : row.getString("small_img_url");
		currentLocation.setSmallImgURL(smallImgURL);

		currentLocation.setLongitudeX(row.getDouble("longitude_x_coord"));
		currentLocation.setLatitudeY(row.getDouble("latitude_y_coord"));
		
		//For scalability, these queries should all be combined into a single SQL query. 
		// Otherwise, larger results sets would cause a large amount of network traffic.
		currentLocation.setCategories(getCategoriesByLocationId(currentLocation.getLocationId()));
		
		LocationHoursDAO locHoursDAO = new LocationHoursSQLDAO(this.jdbcTemplate.getDataSource());
		currentLocation.setLocationHours(locHoursDAO.getLocationHoursByLocationId(currentLocation.getLocationId()));
		
		return currentLocation;
	}

	/**
	 * As of now, only maps location table columns to object
	 * 
	 * @param results SqlRowSet from querying the entire location table
	 * @return Location object without categories or hours
	 */
	private List<Location> mapResultsToLocations(SqlRowSet results) {
		// TODO: include categories and hours
		List<Location> output = new ArrayList<>();
		while (results.next()) {
			Location currentLocation = mapRowToLocation(results);
			output.add(currentLocation);
		}
		return output;
	}

	// Everything to do with just the category table
	
	@Override
	public List<Category> getAllCategories() {
		List<Category> allCategories = new ArrayList<>();
		String sqlAllCategories = "SELECT * FROM category";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlAllCategories);
		allCategories = mapResultsToCategories(results);
		return allCategories;
	}
	
	@Override
	public List<Category> getCategoriesByLocationId(long locationId) {
		List<Category> locationCategories = new ArrayList<>();
		String sqlCategories = "SELECT c.* FROM category AS c "
				+ "INNER JOIN category_location AS cl " 
				+ "ON c.category_id = cl.category_id "
				+ "INNER JOIN location AS l ON cl.location_id = l.location_id "
				+ "WHERE l.location_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlCategories, locationId);
		locationCategories = mapResultsToCategories(results);
		return locationCategories;
	}
	
	private Category mapRowToCategory(SqlRowSet row) {
		Category category = new Category();
		category.setCategoryId(row.getLong("category_id"));
		category.setName(row.getString("name"));
		category.setIconImgURL(row.getString("icon_img_url"));
		return category;
	}
	
	private List<Category> mapResultsToCategories(SqlRowSet results) {
		List<Category> categoryList = new ArrayList<>();
		while (results.next()) {
			Category currentCategory = mapRowToCategory(results);
			categoryList.add(currentCategory);
		}
		return categoryList;
	}
	
}
