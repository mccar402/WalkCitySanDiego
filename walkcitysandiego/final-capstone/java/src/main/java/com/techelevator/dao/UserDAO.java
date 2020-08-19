package com.techelevator.dao;

import com.techelevator.model.CheckIn;
import com.techelevator.model.User;

import java.util.List;

public interface UserDAO {

	/**
	 * Queries database for information on all users. We may wish to 
	 * write a separate method for retrieving all users with undeleted
	 * accounts later. This is the general-purpose one for admin use.
	 * @return list of all users
	 */
    List<User> findAll();

    /**
     * Queries database for details on one specific user. Used in 
     * navigating to profile page once the user logs in.
     * @param userId (Long) unique ID number
     * @return User object with all info
     */
    User getUserById(Long userId);

    /**
     * Queries database for details on one specific user. Admin only.
     * @param username (String) unique username
     * @return User object with all info
     */
    User findByUsername(String username);

    /**
     * Queries database for just the user ID number. Used in finding 
     * endpoint to navigate to when a user logs in.
     * @param username (String) unique username
     * @return User ID number (long)
     */
    long findIdByUsername(String username);

    /**
     * Creates new user upon successful registration
     * @param username (String)
     * @param password (String)
     * @param role (String) "User" by default; can also be "Administrator"
     * @return
     */
    boolean create(String username, String password, String role, String firstName, String lastName);
    
    public List<CheckIn> getCheckInByUserId(long userId);
    
    public List<CheckIn> addNewCheckInToUser(long userId, long locationId);
}
