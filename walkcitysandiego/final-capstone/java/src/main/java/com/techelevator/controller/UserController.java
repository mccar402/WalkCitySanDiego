package com.techelevator.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.techelevator.dao.BadgeDAO;
import com.techelevator.dao.UserDAO;
import com.techelevator.model.Badge;
import com.techelevator.model.CheckIn;
import com.techelevator.model.User;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class UserController {
	
	@Autowired
	UserDAO userDAO;
	@Autowired
	BadgeDAO bDao;
	
	@RequestMapping ( path = "/users" )
	public List<User> listAllUsers() {
		List<User> allUsers = userDAO.findAll();
		return allUsers;
	}
	
	@RequestMapping ( path = "/users/{id}" )
	public User getUser(@PathVariable("id") long userId) {
		User currentUser = userDAO.getUserById(userId);
		return currentUser;
	}
	
	//make inaccessible from front end
	@RequestMapping ( path = "/users/{userId}/badge/{badgeId}", method = RequestMethod.POST)
	public List<Badge> addNewBadgeToUser(@PathVariable long userId, @PathVariable long badgeId) {
		List<Badge> userBadgesEarned = bDao.addNewBadgeToUser(userId, badgeId);
		return userBadgesEarned;
	}
	
	@RequestMapping ( path = "/users/{userId}/location/{locationId}", method = RequestMethod.POST)
	public List<CheckIn> addNewCheckInToUser(@PathVariable long userId, @PathVariable long locationId) {
		List<CheckIn> newCheckinList = userDAO.addNewCheckInToUser(userId, locationId);
		return newCheckinList;
	}
	
	@RequestMapping ( path = "/users/{userId}/badge")
	public List<Badge> getAllBadgesByUserId(@PathVariable long userId) {
		List<Badge> badgeList = bDao.getAllBadgesByUserId(userId);
		return badgeList;
	}
	

}
