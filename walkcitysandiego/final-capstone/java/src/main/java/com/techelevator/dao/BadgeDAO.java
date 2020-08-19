package com.techelevator.dao;

import java.util.List;

import com.techelevator.model.Badge;
import com.techelevator.model.CheckIn;

public interface BadgeDAO {

	public List<Badge> addNewBadgeToUser(long userId, long badgeId);
	
	public List<Badge> getBadgesEarnedByUserId(long userId);
	
	public List<Badge> getAllBadgesByUserId(long userId);
	
	public List<Badge> getUnearnedBadgesList(long userId);
	
	public int findNumberOfCheckinsByCategory(List<CheckIn> listCheckins, long categoryId);
	
	public int findNumberOfCheckinsByLocation(List<CheckIn> listCheckins, long locationId);
	
}
