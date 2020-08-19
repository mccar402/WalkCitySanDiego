package com.techelevator.model;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class CategoryTest {
	private static final long TEST_ID = (long)(Math.random() * 50);
	private static final String TEST_NAME = "fake category";
	private static final String TEST_IMG_URL = "https://fakeiconimage.jpg";
	private Category expected;

	@Before
	public void setUp() throws Exception {
		expected = new Category();
		expected.setCategoryId(TEST_ID);
		expected.setName(TEST_NAME);
		expected.setIconImgURL(TEST_IMG_URL);
	}

	@Test
	public void null_category_returns_not_equal() {
		Category nullCategory = null;
		assertNotEquals(expected, nullCategory);
	}
	
	@Test
	public void different_class_object_returns_not_equal() {
		String notACategory = TEST_NAME;
		assertNotEquals(expected, notACategory);
	}
	
	@Test
	public void same_object_returns_equal() {
		Category duplicate = expected;
		assertEquals(expected, duplicate);
	}
	
	@Test
	public void one_property_mismatch_returns_not_equal() {
		Category imperfectDupe = new Category();
		imperfectDupe.setCategoryId(expected.getCategoryId());
		imperfectDupe.setName(expected.getName());
		imperfectDupe.setIconImgURL("random.png");
		assertNotEquals(expected, imperfectDupe);
	}
	
	@Test
	public void same_data_properties_return_categories_equal() {
		Category duplicate = new Category();
		duplicate.setCategoryId(expected.getCategoryId());
		duplicate.setName(expected.getName());
		duplicate.setIconImgURL(expected.getIconImgURL());
		assertEquals(expected, duplicate);
	}

}
