package com.techelevator.dao;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.techelevator.model.Badge;
import com.techelevator.model.CheckIn;

@Component
public class BadgeSqlDAO implements BadgeDAO {
	
	JdbcTemplate jdbcTemplate;
		
		public BadgeSqlDAO(DataSource datasource) {
			this.jdbcTemplate = new JdbcTemplate(datasource);
		}
		
		
		//test method, not available on front end
		
		//get all unearned badges method
		//iterate through list of badges to see if conditions are met
		//get list of all checkins by user id method (this exists in userSqlDao)
		@Override
		public List<Badge> addNewBadgeToUser(long userId, long badgeId) {

			String sqlInsert = "INSERT INTO user_badge(user_id, badge_id, date_earned) "
					+ "VALUES (?, ?, ?::date)";
			try {
				jdbcTemplate.update(sqlInsert, userId, badgeId, LocalDate.now());
			} catch(DataAccessException e) {
				System.err.println("Issue adding badge");
			}
			return getBadgesEarnedByUserId(userId);			
		}
		
		@Override
		public int findNumberOfCheckinsByCategory(List<CheckIn> listCheckins, long categoryId) {
			int count = 0;
			for(CheckIn temp: listCheckins) {
				for(int i=0; i < temp.getLocation().getCategories().size(); i++) {
					if(temp.getLocation().getCategories().get(i).getCategoryId() == categoryId) {
						count++;
						break;
					}					
				}
			}
			return count;
		}
		
		@Override
		public int findNumberOfCheckinsByLocation(List<CheckIn> listCheckins, long locationId) {
			int count = 0;
			for(CheckIn temp: listCheckins) {
				if(temp.getLocation().getLocationId() == locationId) {
					count++;
				}
			}
			return count;
		}
		
		
		
		
		@Override
		public List<Badge> getAllBadgesByUserId(long userId){
			List<Badge> badgesList = new ArrayList<>();
			String sql = "SELECT b.*, ub.date_earned, ub.user_id FROM badge AS b "
					+ "LEFT OUTER JOIN user_badge AS ub "
					+ "ON b.badge_id = ub.badge_id "
					+ "AND ub.user_id = ? "
					+ "ORDER BY ub.date_earned, b.name";
			
			SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
			badgesList = mapResultsToBadges(results);
			return badgesList;
		}
			
		
		@Override
		public List<Badge> getBadgesEarnedByUserId(long userId){
			List<Badge> badgesEarnedList = new ArrayList<>();
			String sql = "SELECT b.*, ub.date_earned FROM badge AS b "
					+ "INNER JOIN user_badge AS ub "
					+ "ON b.badge_id = ub.badge_id "
					+ "INNER JOIN users AS u "
					+ "ON ub.user_id = u.user_id "
					+ "WHERE u.user_id = ? "
					+ "ORDER BY ub.date_earned DESC";
			
			SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
			badgesEarnedList = mapResultsToBadges(results);
			return badgesEarnedList;
		}
		
		@Override
		public List<Badge> getUnearnedBadgesList(long userId){
			List<Badge> unearnedBadgeList = new ArrayList<>();
			String sql = "SELECT b.*, ub.date_earned FROM badge AS b "
					+ "LEFT OUTER JOIN user_badge AS ub "
					+ "ON b.badge_id != ub.badge_id "
					+ "AND ub.user_id = ?";
			
			SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
			unearnedBadgeList = mapResultsToBadges(results);
			return unearnedBadgeList;
		}
		
		
		private Badge mapRowToBadge(SqlRowSet row) {
			Badge badge = new Badge();
			badge.setBadgeId(row.getLong("badge_id"));
			badge.setName(row.getString("name"));
			badge.setBadgeImgURL(row.getString("badge_img_url"));
			badge.setDescription(row.getString("description"));
			badge.setDateEarned((row.getDate("date_earned") != null) ? row.getDate("date_earned").toLocalDate() : null);
			badge.setNumOfCheckins(row.getInt("num_checkins"));
			badge.setSingleLocation(row.getBoolean("single_location"));
			badge.setCategoryId(row.getLong("category_id"));
			return badge;
		}
	
	
		private List<Badge> mapResultsToBadges(SqlRowSet results){
		List<Badge> badgeList = new ArrayList<>();
		while (results.next()) {
			Badge currentBadge = mapRowToBadge(results);
			badgeList.add(currentBadge);
			}
			return badgeList;
		}
	

	
	
	
}
