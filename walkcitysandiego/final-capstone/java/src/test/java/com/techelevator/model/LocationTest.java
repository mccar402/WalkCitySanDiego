package com.techelevator.model;

import static org.junit.Assert.fail;

import java.util.List;

import org.junit.Before;
import org.junit.Test;

public class LocationTest {
	private Location testLocation;
	private long testId = (long)(Math.random() * 1000);
	private String testName = "Fake Location";
	private String testDescription = "Fake Location is fake!";
	private String bannerImgURL = "https://fakeurl.jpg";
	private String smallImgURL = "https://fakeurlbutsmall.jpg";
	private double longitudeX = -117.0;
	private double latitudeY = 32.0;
	private List<Category> testCategories;
	private List<LocationHours> locationHours;

	@Before
	public void setUp() throws Exception {
		testLocation = new Location();
	}

	@Test
	public void test() {
		fail("Not yet implemented"); // TODO
	}

}
