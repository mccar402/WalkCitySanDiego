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

import com.techelevator.model.User;

public class UserSqlDaoIntegrationTest extends DAOIntegrationTest {

	private JdbcTemplate jdbcTemplate;
    private UserDAO userDAO;
    private List<User> allUsers;
    private User user;

    @BeforeClass
	public static void setUpBeforeClass() throws Exception {
		setupDataSource();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		closeDataSource();
	}
	
    @Before
    public void setup() {
        jdbcTemplate = new JdbcTemplate(getDataSource());
        userDAO = new UserSqlDAO(jdbcTemplate);
        allUsers = new ArrayList<User>();
    }
    
	@After
	public void tearDown() throws Exception {
		rollback();
	}

	@Test
	public void test_getAll_returns_correct_number_of_users() {
		String sqlCount = "SELECT COUNT(*) AS count FROM users";
		SqlRowSet countResult = jdbcTemplate.queryForRowSet(sqlCount);
		int usersTableRowCount = 0;
		if (countResult.next()) {
			usersTableRowCount = countResult.getInt("count");
		}
		
		allUsers = userDAO.findAll();
		assertEquals(usersTableRowCount, allUsers.size());
	}
	
	@Test
	public void test_sample_database_1_returns_user() {
		// TODO make this robust to any database later
		user = userDAO.getUserById(1L);
		assertEquals("user", user.getUsername());
	}
	
	// TODO come back to this later
//    @Test
//    public void createNewUser() {
//        boolean userCreated = userSqlDAO.create("TEST_USER","test_password","user");
//        Assert.assertTrue(userCreated);
//        User user = userSqlDAO.findByUsername("TEST_USER");
//        Assert.assertEquals("TEST_USER", user.getUsername());
//    }

}
