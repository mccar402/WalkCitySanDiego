package com.techelevator.dao;

import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.techelevator.model.Badge;
import com.techelevator.model.CheckIn;
import com.techelevator.model.Location;
import com.techelevator.model.User;

@Service
public class UserSqlDAO implements UserDAO {

    private JdbcTemplate jdbcTemplate;

    public UserSqlDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public long findIdByUsername(String username) {
        return jdbcTemplate.queryForObject("select user_id from users where username = ?", long.class, username);
    }

	@Override
	public User getUserById(Long userId) {
		String sql = "SELECT * FROM users WHERE user_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
		if(results.next()) {
			return mapRowToUser(results);
		} else {
			throw new RuntimeException("userId "+userId+" was not found.");
		}
	}

    @Override
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "select * from users";

        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
        while(results.next()) {
            User user = mapRowToUser(results);
            users.add(user);
        }

        return users;
    }

    @Override
    public User findByUsername(String username) throws UsernameNotFoundException {
        for (User user : this.findAll()) {
            if( user.getUsername().toLowerCase().equals(username.toLowerCase())) {
                return user;
            }
        }
        throw new UsernameNotFoundException("User " + username + " was not found.");
    }

    @Override
    public boolean create(String username, String password, String role, String firstName, String lastName) {
        boolean userCreated = false;

        // create user
        String insertUser = "insert into users (username,password_hash,role, first_name, last_name) values(?,?,?,?,?)";
        String password_hash = new BCryptPasswordEncoder().encode(password);
        String ssRole = "ROLE_" + role.toUpperCase();

        GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();
        String id_column = "user_id";
        userCreated = jdbcTemplate.update(con -> {
                    PreparedStatement ps = con.prepareStatement(insertUser, new String[]{id_column});
                    ps.setString(1, username);
                    ps.setString(2, password_hash);
                    ps.setString(3, ssRole);
                    ps.setString(4,  firstName);
                    ps.setString(5,  lastName);
                    return ps;
                }
                , keyHolder) == 1;
        int newUserId = (int) keyHolder.getKeys().get(id_column);

        return userCreated;
    }

    private User mapRowToUser(SqlRowSet rs) {
        User user = new User();
        user.setId(rs.getLong("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password_hash"));
        user.setAuthorities(rs.getString("role"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        // Is this the same as the delete column in the database table?
        // TODO If yes, have this take into account the deleted boolean
        user.setActivated(true);        
        BadgeDAO bDao = new BadgeSqlDAO(jdbcTemplate.getDataSource());
        user.setBadgesEarned(bDao.getAllBadgesByUserId(user.getId()));
        user.setListOfCheckins(getCheckInByUserId(user.getId()));
       
        return user;
    }
    
    
    // CheckIn Methods

    	public List<CheckIn> getCheckInByUserId(long userId){
    		List<CheckIn> UserCheckIns = new ArrayList<>();
    		String sqlCheckins = "SELECT ch.*, l.* FROM checkin AS ch "
    				+ "INNER JOIN location AS l "
    				+ "ON ch.location_id = l.location_id "
    				+ "WHERE ch.user_id = ?";
    		
    		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlCheckins, userId);
    		UserCheckIns = mapResultsToCheckIn(results);   		
    		return UserCheckIns;   		
    	}
    	
    	private List<CheckIn> mapResultsToCheckIn(SqlRowSet results) {
		List<CheckIn> checkinList = new ArrayList<>();
		while (results.next()) {
			CheckIn currentCheckIn = mapRowToCheckIn(results);
			checkinList.add(currentCheckIn);
		}
		return checkinList;
	}
    	
    	private CheckIn mapRowToCheckIn(SqlRowSet row) {
		CheckIn checkIn = new CheckIn();	
		checkIn.setCheckInDate(row.getDate("date_checkin").toLocalDate());
		LocationDAO lDao = new LocationSqlDAO(jdbcTemplate);
		checkIn.setLocation(lDao.getLocationById(row.getLong("location_id")));
		return checkIn;
	}
    	
    	public CheckIn getSingleCheckInByUserId(long userId){
    		CheckIn checkIn = new CheckIn();
    		String sqlCheckin = "SELECT ch.*, l.* FROM checkin AS ch "
    				+ "INNER JOIN location AS l "
    				+ "ON ch.location_id = l.location_id "
    				+ "WHERE ch.user_id = ?";
    		
    		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlCheckin, userId);
    		while (results.next()) {
    			checkIn = mapRowToCheckIn(results);
    		}
    		return checkIn;
    		
    	}
    	

    	
    	
		@Override
		public List<CheckIn> addNewCheckInToUser(long userId, long locationId) {
			String sqlInsert = "INSERT INTO checkin(user_id, location_id, date_checkin) "
					+ "VALUES (?, ?, ?::date)";
			
			jdbcTemplate.update(sqlInsert, userId, locationId, LocalDate.now());	

			LocationDAO lDao = new LocationSqlDAO(jdbcTemplate);
			BadgeDAO bDao = new BadgeSqlDAO(jdbcTemplate.getDataSource());
			List<Badge> unearnedBadges = bDao.getUnearnedBadgesList(userId);
			System.out.println(unearnedBadges);
			List<CheckIn> listOfUserCheckins = getCheckInByUserId(userId);
			System.out.println(listOfUserCheckins);
			
			for(int i = 0; i < unearnedBadges.size(); i++) {
				Badge theBadge = unearnedBadges.get(i);
				
				//this is for the treehugger, beachbum, and sports enthusiast
				if(!theBadge.isSingleLocation() && bDao.findNumberOfCheckinsByCategory(listOfUserCheckins, theBadge.getCategoryId()) >= theBadge.getNumOfCheckins() && theBadge.getNumOfCheckins() != 0) {
					bDao.addNewBadgeToUser(userId, theBadge.getBadgeId());
					System.out.println("test 1");
				//For mayor
				} else if(theBadge.isSingleLocation() && bDao.findNumberOfCheckinsByLocation(listOfUserCheckins, locationId) >= theBadge.getNumOfCheckins() ) {
					bDao.addNewBadgeToUser(userId, theBadge.getBadgeId());
					System.out.println("test 2");
				} else if (theBadge.isSingleLocation() && lDao.countLocations() == theBadge.getNumOfCheckins()) {
					
				}
			
			}		
			return getCheckInByUserId(userId);
		}






}

