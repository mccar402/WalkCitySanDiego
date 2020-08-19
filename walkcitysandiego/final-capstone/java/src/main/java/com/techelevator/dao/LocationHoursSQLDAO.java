package com.techelevator.dao;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;

import com.techelevator.model.LocationHours;

public class LocationHoursSQLDAO implements LocationHoursDAO {

	JdbcTemplate jdbcTemplate;
	
	public LocationHoursSQLDAO(DataSource datasource) {
		this.jdbcTemplate = new JdbcTemplate(datasource);
	}
	
	@Override
	public List<LocationHours> getLocationHoursByLocationId(long locationId) {
		
		List<LocationHours> locationHoursList = new ArrayList<>(0);
		
		String sqlGetLocationHoursByLocationId = "SELECT location_hours.*, day_of_week.day_name "
												+ "FROM location_hours "
													+ "INNER JOIN day_of_week "
													+ "ON location_hours.day_id = day_of_week.day_id "
												+ "WHERE location_id = ? "
												+ "ORDER BY day_id";
		
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlGetLocationHoursByLocationId, locationId);
		
		while(results.next()) {
			locationHoursList.add(mapRowToLocationHours(results));
		}
		
		return locationHoursList;
	}

	private LocationHours mapRowToLocationHours(SqlRowSet results) {
		LocationHours locationHours = new LocationHours();
		locationHours.setLocationHoursId(results.getLong("location_hours_id"));
		//Need to add in Open Time and Close time once I figure out how to store times in java.
		locationHours.setOpenTime((results.getTime("opens") != null) ? results.getTime("opens").toLocalTime() : null);
		locationHours.setCloseTime((results.getTime("closes") != null) ? results.getTime("closes").toLocalTime() : null);
		locationHours.setDayOfWeekName(results.getString("day_name"));
		locationHours.setValidFrom(results.getInt("valid_from"));
		locationHours.setValidTo(results.getInt("valid_to"));
		
		return locationHours;
	}

}
