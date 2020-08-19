package com.techelevator.dao;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;

import com.techelevator.model.Location;

public class LocationSqlDAOTest extends DAOIntegrationTest {
	
	private JdbcTemplate jdbcTemplate;
	private LocationDAO locationDAO;
	private List<Location> results;

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		setupDataSource();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		closeDataSource();
	}

	@Before
	public void setUp() throws Exception {
		jdbcTemplate = new JdbcTemplate(getDataSource());
		locationDAO = new LocationSqlDAO(jdbcTemplate);
		results = new ArrayList<Location>();
	}

	@After
	public void tearDown() throws Exception {
		rollback();
	}

	@Test
	public void test_GetAllLocations_returns_correct_number_of_elements() {
		String sqlCount = "SELECT COUNT(*) AS count FROM location";
		SqlRowSet countResult = jdbcTemplate.queryForRowSet(sqlCount);
		int locationTableRowCount = 0;
		if (countResult.next()) {
			locationTableRowCount = countResult.getInt("count");
		}
		
		results = locationDAO.getAllLocations();
		assertEquals(locationTableRowCount, results.size());
	}
	
	@Test
	public void test_sample_database_1_returns_location() {
		// TODO: make this robust to any database later
		Location actual = locationDAO.getLocationById(1);
		assertEquals("San Diego Zoo", actual.getName());
	}

}
