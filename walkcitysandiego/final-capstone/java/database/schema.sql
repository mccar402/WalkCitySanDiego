BEGIN TRANSACTION;

DROP TABLE IF EXISTS category_location;
DROP TABLE IF EXISTS checkin;
DROP TABLE IF EXISTS user_badge;
DROP TABLE IF EXISTS badge;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS location_hours;
DROP TABLE IF EXISTS day_of_week;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS users;

DROP TYPE IF EXISTS user_role;

--CREATE TYPE user_role AS ENUM (
--        'Administrator',
--        'User'
--);

CREATE TABLE users (
	user_id SERIAL NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	username varchar(50) NOT NULL,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL CHECK (role IN ('ROLE_ADMIN', 'ROLE_USER')),
	-- How to default it to false?
	deleted boolean DEFAULT false NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

-- To be added later: Coordinates, hours_open, days_open
CREATE TABLE location (
        location_id SERIAL NOT NULL,
        name varchar(50) NOT NULL,
        description varchar(500) NOT NULL,
        banner_img_url varchar(400),
        small_img_url varchar(400),
        latitude_y_coord numeric NOT NULL,
        longitude_x_coord numeric NOT NULL,
        CONSTRAINT PK_location PRIMARY KEY (location_id)
);

CREATE TABLE day_of_week (
        day_id int NOT NULL,
        day_name varchar(15) NOT NULL,
        CONSTRAINT PK_day_of_week PRIMARY KEY (day_id)
);

CREATE TABLE location_hours (
        location_hours_id SERIAL NOT NULL,
        location_id int NOT NULL,
        opens time NOT NULL,
        closes time NOT NULL,
        day_id int NOT NULL,
        valid_from int NOT NULL,
        valid_to int NOT NULL,
        CONSTRAINT PK_location_hours PRIMARY KEY (location_hours_id),
        CONSTRAINT FK_location_hours_day_id FOREIGN KEY (day_id) REFERENCES day_of_week (day_id),
        CONSTRAINT FK_location_hours_location_id FOREIGN KEY (location_id) REFERENCES location (location_id)
);

CREATE TABLE category (
        category_id SERIAL NOT NULL,
        name varchar(50) NOT NULL,
        icon_img_url varchar(200),
        CONSTRAINT PK_category PRIMARY KEY (category_id)
);

CREATE TABLE badge (
        badge_id SERIAL NOT NULL,
        name varchar(50) NOT NULL,
        badge_img_url varchar(200),
        description varchar(155) NOT NULL,
        category_id int,
        num_checkins int,
        single_location boolean,
        CONSTRAINT PK_badge PRIMARY KEY (badge_id),
        CONSTRAINT FK_badge_category_id FOREIGN KEY (category_id) REFERENCES category (category_id)
);

CREATE TABLE user_badge (
        user_id int NOT NULL,
        badge_id int NOT NULL,
        date_earned date NOT NULL,
        CONSTRAINT PK_user_badge PRIMARY KEY (user_id, badge_id),
        CONSTRAINT FK_user_badge_user_id FOREIGN KEY (user_id) REFERENCES users (user_id),
        CONSTRAINT FK_user_badge_badge_id FOREIGN KEY (badge_id) REFERENCES badge (badge_id)
);

CREATE TABLE checkin (
        user_id int NOT NULL,
        location_id int NOT NULL,
        date_checkin date NOT NULL,
        CONSTRAINT PK_checkin PRIMARY KEY (date_checkin, user_id, location_id),
        CONSTRAINT FK_checkin_user_id FOREIGN KEY (user_id) REFERENCES users (user_id),
        CONSTRAINT FK_checkin_location_id FOREIGN KEY (location_id) REFERENCES location (location_id)
);

CREATE TABLE category_location (
        location_id SERIAL NOT NULL,
        category_id SERIAL NOT NULL,
        CONSTRAINT PK_category_location PRIMARY KEY (location_id, category_id),
        CONSTRAINT FK_category_location_category_id FOREIGN KEY (category_id) REFERENCES category (category_id),
        CONSTRAINT FK_category_location_location_id FOREIGN KEY (location_id) REFERENCES location (location_id)
);

INSERT INTO users (username,password_hash,role, first_name, last_name, deleted) VALUES ('user','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER', 'Test', 'User', false);
INSERT INTO users (username,password_hash,role, first_name, last_name, deleted) VALUES ('admin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_ADMIN', 'Test', 'Administrator', false);

INSERT INTO category (name, icon_img_url) VALUES ('Beach', 'https://image.flaticon.com/icons/svg/2918/2918660.svg');
INSERT INTO category (name, icon_img_url) VALUES ('Park', 'https://image.flaticon.com/icons/svg/941/941543.svg');
INSERT INTO category (name, icon_img_url) VALUES ('Museum', 'https://image.flaticon.com/icons/svg/3068/3068691.svg');
INSERT INTO category (name, icon_img_url) VALUES ('Restaurant', 'https://image.flaticon.com/icons/svg/2217/2217350.svg');
INSERT INTO category (name, icon_img_url) VALUES ('Sports Stadium', 'https://image.flaticon.com/icons/svg/821/821357.svg');

INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('San Diego Zoo', 'Great Zoo. Has a panda.', -117.149048, 32.735317, 'https://i.pinimg.com/150x150/57/90/fb/5790fb9e62e90402677d648ff5364d51.jpg', 'https://www.planetware.com/photos-large/USCA/san-diego-with-kids-san-diego-zoo.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('La Jolla Cove', 'Ecologically protected calm waters with a famous dive site.', -117.272940, 32.850190, 'https://www.lajolla.com/wp-content/uploads/2016/11/Screen-Shot-2018-07-30-at-12.09.57-PM.png', 'https://www.californiabeaches.com/wp-content/uploads/2014/09/La-Jolla-Cove-Beach-BryceApr16-6-1000x540.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Coronado Beach', 'Sheltered sands amidst backdrop of beachfront mansions.', -117.187565, 32.684737, 'https://img1.coastalliving.timeinc.net/sites/default/files/styles/150x150/public/image/2016/07/main/coronado-beach-chiara-salvadori-gettyimages-561754257.jpg?itok=lhSmSELB', 'https://hoteldel.com/wp-content/uploads/2014/01/Best-U.S.-Beach-2012_high-rez.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Mission Beach', 'Beach with plenty of options. Visit Belmont Park for its classic rollercoasters. Escape to South Mission Beach for more tranquility.', -117.253093, 32.769943, 'https://i.pinimg.com/originals/ee/fa/e9/eefae9dba4a6a86ef45a29c7ea1f6044.jpg', 'https://u.realgeeks.media/sandiegorealestatehunter/mission-beach-san-diego-real-estate.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('USS Midway Museum', 'The first U.S. aircraft carrier too big for the Panama Canal, now a floating museum.', -117.17315, 32.71445, 'https://www.theworldisabook.com/wp-content/uploads/2012/05/USSMidway-150x150.jpg', 'http://blog.sandiego.org/wp-content/uploads/2010/06/Midway-Docked-with-Skyline1.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('North Park Breakfast Company', 'Cozy breakfast and lunch place with urban industrial decor.', -117.126512, 32.748391, 'https://breakfast-company.com/wp-content/uploads/2019/10/npbc-about-2.jpg', 'https://cdn.vox-cdn.com/thumbor/ha3pjPV8RqAXj0e3kDxHT2j3Ns0=/0x0:1022x591/1200x0/filters:focal(0x0:1022x591):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/16297923/NPBC_290.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Petco Park', 'Home of the San Diego Padres.', -117.1566, 32.7073, 'https://www.rateyourseats.com/assets/images/venues/petco-park-mlb.jpg', 'https://cdn.trolleytours.com/wp-content/uploads/2016/06/san-diego-petco-park.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Original 40 Brewing Co.', 'Located on University Ave., The Original 40 has a uniquely vintage design with a fresh, modern touch. Upon walking in you will feel the light fresh and comfortable atmosphere that makes this brewery easily home to North Park locals. The distinct look and feel was created in collaboration with Tijuana-based firm Duhagon Design.', -117.126624, 32.748349, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRBLEeKK8aOePZbmSBvRS_AuAcJcXzckyZHpBUw2LSdZw&usqp=CAU&ec=45690269', 'https://bloximages.newyork1.vip.townnews.com/sandiegomagazine.com/content/tncms/assets/v3/editorial/1/7c/17cb9f93-7ad6-5c8d-bbd1-d5a7cc0927b6/5e15066b20b92.image.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('San Diego Natural History Museum', 'The San Diego Natural History Museum is a museum located in Balboa Park in San Diego, California. It was founded in 1874 as the San Diego Society of Natural History. It is the second oldest scientific institution west of the Mississippi and the oldest in Southern California. The present location of the museum was dedicated on January 14, 1933.', -117.147495, 32.732373, 'https://fastly.4sqi.net/img/general/600x600/_Ayt29VAgDGxmRfwUOaZpH27mH6o8h1SyQbXvEnZf58.jpg', 'https://ewscripps.brightspotcdn.com/dims4/default/6d40bc2/2147483647/strip/true/crop/4683x2634+0+60/resize/1280x720!/quality/90/?url=http%3A%2F%2Fewscripps-brightspot.s3.amazonaws.com%2Fd4%2Fc2%2Fc9b3417447ab9f970de4ba46335d%2Fnatural-history-museum-douglas-museum-exterior-1-h.jpg.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('San Diego Museum of Art', 'The San Diego Museum of Art is a fine arts museum located at 1450 El Prado in Balboa Park in San Diego, California that houses a broad collection with particular strength in Spanish art. The San Diego Museum of Art opened as The Fine Arts Gallery of San Diego on February 28, 1926, and changed its name to the San Diego Museum of Art in 1978. Nearly half a million people visit the museum each year.', -117.150417, 32.731995, 'https://fastly.4sqi.net/img/general/600x600/24861975_6gQoHVuGAHwOn4TONnNqx6QvyrTGQtpuEqkzFjlEONo.jpg', 'https://steinsworth.com/wp-content/uploads/2019/08/san-diego-museum-of-art-1200x640.png');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('San Diego Air and Space Museum', 'San Diego Air & Space Museum is an aviation and space exploration museum in San Diego, California, United States. The museum is located in Balboa Park. Do ya like planes n'' stuff? Well shoot. Whatrya waitin'' for!', -117.154855, 32.725887, 'https://sandiego.kidsoutandabout.com/sites/default/files/styles/activity_image/public/air.jpg?itok=G_x-QaPE', 'https://www.balboapark.org/sites/default/files/2017-01/SDASM_Entrance_Peter%20Carney%20Header.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Balboa Park', 'Balboa Park is a 1,200-acre historic urban cultural park in San Diego, California, United States. In addition to open space areas, natural vegetation zones, green belts, gardens, and walking paths, it contains museums, several theaters, and the world-famous San Diego Zoo. There are also many recreational facilities and restaurants within the boundaries of the park. Placed in reserve in 1835, the park''s site is one of the oldest in the United States dedicated to public recreational use.', -117.144574, 32.733715, 'https://www.moon.com/wp-content/uploads/2019/01/CA_SanDiego_BalboaPark_Dreamstime.jpg?fit=1080%2C1080&w=640', 'https://bloximages.newyork1.vip.townnews.com/sandiegomagazine.com/content/tncms/assets/v3/editorial/0/06/006ba86b-03fd-5fa0-9fe9-2c467eb5f9c0/5e18904fa975b.image.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Embarcadero Waterfront', 'The Embarcadero in San Diego, California is the area along the San Diego harbor on the east side of San Diego Bay. "Embarcadero" is a Spanish word meaning "boarding place". The Embarcadero is home to the San Diego cruise ship terminal, the museum ships USS Midway at Navy Pier and Star of India, seven other historic vessels belonging to the San Diego Maritime Museum, and various restaurants and shops from the North Embarcadero down through Seaport Village.', -117.164015, 32.704221, 'https://d1marr3m5x4iac.cloudfront.net/images/block250/I0-001/013/846/778-1.jpeg_/embarcadero-marine-park-north-south-78.jpeg', 'https://cdn.thecrazytourist.com/wp-content/uploads/2018/07/ccimage-shutterstock_95925931.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Point Loma', 'The west side of San Diego Bay is embraced by a long rocky peninsula that merits a visit for jagged topography, thrilling history and views you won''t soon forget. In 1542, this was the landing point for the first European expedition to what is now the West Coast of America. Given the peninsula''s setting, protecting the west flank of the harbor, Point Loma has a military presence going back to the 19th century.', -117.242694, 32.674837, 'https://ec2-im-1.msw.ms/md/image.php?id=350733&type=PHOTOLAB&resize_type=STREAM_MEDIUM_SQUARE&fromS3', 'https://cdn.thecrazytourist.com/wp-content/uploads/2018/07/ccimage-shutterstock_71757622.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Il Dandy', 'It''s a restaurant man.', -117.160323, 32.731967, 'https://process.filestackapi.com/AR25vb1M6Ria5RcK6MyhVz/resize=width:500,height:500,fit:crop,align:top/rotate=deg:exif/https://process.filestackapi.com/AR25vb1M6Ria5RcK6MyhVz/rotate=deg:exif/https://cdn.indst.co/logos/production-1551991914431dandy.png', 'https://ca-times.brightspotcdn.com/dims4/default/0ff242e/2147483647/strip/true/crop/6122x4083+0+0/resize/840x560!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2Fed%2F81%2Ff5677e514ca9a26a2950edac5a8b%2Fil-dandy-bar-night.jpeg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('The Presley', 'Liberty Station''s newest outdoor dining spot for all American noshes and boozy slushies. The Presley makes the most of its nearly 2,100 square feet of dedicated outdoor dining area. Executive Chef Todd Nash''s menu features classic American fare including lobster roll sliders, horseradish crusted salmon, grilled pork prime rib, and a variety of flatbreads, sandwiches and salads. The playful beverage menu incorporates twists on classic cocktails, including a Dole Whip Mimosa and Frozen Gin Fizz.', -117.210941, 32.741205, 'https://images.otstatic.com/prod1/31247171/3/large.jpg', 'https://cdn.vox-cdn.com/thumbor/xc40rZwHDHCSfIVtzPCDNbjJQug=/0x0:3936x2624/1400x1050/filters:focal(1654x998:2282x1626):no_upscale()/cdn.vox-cdn.com/uploads/chorus_image/image/67097323/Img_318.0.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Huntress', 'Big, brawny steaks are the stars here, of course, but Executive Chef James Montejano shows a deft hand with seafood as well, sugar spicing a hefty prime rib of salmon or finessing Chilean sea bass with delicate dashi consomme and truffle prawn wontons. Don''t miss the desserts, especially the Insta-worthy Magic Mushroom: a peanut butter mousse, whiskey caramel, chocolate crumb, peanut butter micro sponge and ice cream marvel that wouldn''t look out of place on the forest floor.', -117.160233, 32.709293, 'https://www.gaslamp.org/wp-content/uploads/2018/11/Huntress-Rendering-300x300.jpg', 'https://cdn.vox-cdn.com/thumbor/3132yq2_jTp-mEA2Fg-CUa2DYpY=/0x0:3600x2400/1200x0/filters:focal(0x0:3600x2400):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13358585/5thAndJ_1stfloor_View2_10_07_2018.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('SDCCU Stadium', 'Home of the San Diego Chargers...NOT! lolz.', -117.119680, 32.783059, 'https://secureservercdn.net/166.62.115.136/620.35e.myftpupload.com/wp-content/uploads/2017/10/6vhb4K8W_400x400.jpg', 'https://www.delawarenorth.com/~/media/delawarenorth/images/venue%20images/sportservice/sdccu-stadium_t1.jpg?h=350&la=en&w=804');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Jenny Craig Pavilion', 'Jenny Craig Pavilion is a 5,100 seat, multi-purpose arena, built in 2000 in San Diego, California, on the campus of the University of San Diego. It was named for weight-loss entrepreneur Jenny Craig. The Pavilion is sometimes affectionately known as the "Slim Gym", a punny reference to the weight-loss program founded by its namesake. It is the home of the University of San Diego Toreros men''s and women''s basketball and volleyball teams.', -117.183771, 32.773924, 'https://content.sportslogos.net/logos/34/825/full/smgecw5seeb2a282cs79z64oo.png', 'https://usdtoreros.com/common/controls/image_handler.aspx?thumb_id=0&image_path=/images/2018/10/2/7439909.jpeg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Sunset Cliffs Natural Park', 'On the west flank of Point Loma is a glorious 68-acre park protecting rough-hewn ocean bluffs, caves, natural arches and tidepools. There’s no mystery to the name, as you may not find a better spot within easy reach of downtown San Diego to watch the sunset. And as with many high vantage points on the Southern Californian coast, there’s a good chance of spotting gray whales between December and April. The scenery is sensational on the Sunset Cliffs Blvd between Adair Street and Ladera Street.', -117.255008, 32.717936, 'https://i.pinimg.com/originals/c6/25/20/c62520ba26b2ec6371969f5407a5e895.jpg', 'https://cdn.thecrazytourist.com/wp-content/uploads/2018/07/ccimage-shutterstock_114985828.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Pechanga Arena', 'Pechanga Arena San Diego is San Diego’s leading destination for sporting events, family shows and live entertainment. Home to the San Diego Gulls, San Diego Sockers, San Diego Seals and San Diego Strike Force.', -117.212357, 32.754750, 'https://s3-media3.fl.yelpcdn.com/bphoto/Fbtwcnll7PmglTQE7Eb44Q/168s.jpg', 'https://www.aegworldwide.com/sites/default/files/styles/medium/public/facility/2019-03/PASD_EXTERIOR_2019.jpg?itok=jHs--9lq'); 
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Morning Glory', 'Amazing breakfast. Don''t stare too long at their website front page.', -117.168201, 32.723126, 'https://morningglorybreakfast.com/wp-content/uploads/2018/12/logo.png', 'https://cdn.vox-cdn.com/thumbor/eSIRD6Jm9lR-JbyE4WAi4pygfRg=/0x0:5984x3989/1200x800/filters:focal(2514x1517:3470x2473)/cdn.vox-cdn.com/uploads/chorus_image/image/63658816/MorningGlory_29.0.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('SeaWorld', 'A Top 10 Theme Park that continues animal rescue work up and down the San Diego coastline.', -117.227275, 32.765751, 'https://1b053f053cbb0b58a2c1-0c725c907c2d637068751776aeee5fbf.ssl.cf1.rackcdn.com/678d68c26a3f4021be0785e1c6b90861_successful_breeding_programs-185x155.jpg', 'https://lajollamom.com/wp-content/uploads/2017/10/seaworld-san-diego-discounted-tickets.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Hodad''s: Ocean Beach', 'Best burgers in San Diego since 1969.', -117.251314, 32.747094, 'https://s3-media3.fl.yelpcdn.com/bphoto/u2ZGMHI2Yj_Gw_NkJGgcPQ/168s.jpg', 'https://cdn0.vox-cdn.com/thumbor/S8jQunhKqU8_Ww1zYnT7LrmoAU8=/0x180:2000x1305/1600x900/cdn0.vox-cdn.com/uploads/chorus_image/image/46129390/hodads-2.0.0.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Las Cuatro Milpas', 'Michelin 2019. Every menu item you get will be worth the wait.', -117.145053, 32.701884, 'https://s3-media1.fl.yelpcdn.com/bphoto/PACWa0nLAl-DGdwyXDFJhg/168s.jpg', 'https://media.sandiegoreader.com/img/blogs/entry_img/2013/Jan/14/IMG_1109.JPG');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Hodad''s: Downtown', 'Best burgers in San Diego. This 2nd location opened 2011.', -117.155870, 32.715639, 'https://s3-media3.fl.yelpcdn.com/bphoto/N2GIAN4Hj_5ePGdXwtlMjA/168s.jpg', 'https://lajollamom.com/wp-content/uploads/2019/01/best-downtown-san-diego-restaurants-hodads.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('The Waffle Spot', 'Breakfast with the King (because it''s at The Kings Inn, get it?)', -117.175208, 32.758892, 'http://kingsinnsandiego.com/wp-content/uploads/2017/08/Waffle-Spot-San-Diego_0002_WaffleSpot-chicken-and-waffle.jpg-150x150.jpg', 'https://i0.wp.com/wafflespotsandiego.com/wp-content/uploads/2017/09/WaffleSpot-11.jpg?fit=1575%2C1050&ssl=1');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Landini''s Pizzeria: Little Italy', 'Nestled in the heart of San Diego''s historic Little Italy, you''ll find Landini''s Pizzeria original location. We are the first and only New York style “pizza by the slice” in the neighborhood since 2009. Landini''s also offers up warm Paninis layered with imported meats and cheeses, Florentine inspired pastas, and a fine selection of beers and wines.', -117.168408, 32.724022, 'https://s3-media3.fl.yelpcdn.com/bphoto/tmK-mfZUP2R-DsGo_OZjVw/168s.jpg', 'https://i.pinimg.com/originals/7d/ef/b3/7defb3c00bfb1aad4a2ec4a196b82769.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Landini''s Pizzeria: Liberty Public Market', 'We use only the freshest produce, and hand selected meats from trusted butchers to produce a pizza with a truly local taste that will have you coming back for more!', -117.210824, 32.740133, 'https://s3-media2.fl.yelpcdn.com/bphoto/FKB0-0NrInHgnQUcCf1d3w/180s.jpg', 'https://bluebridgehospitality.com/libertypublicmarket/wp-content/uploads/sites/2/2019/04/14517605_10154489815813363_4793914753368918189_n.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Perry''s Cafe', 'This diner-style restaurant spot offers ample portions in a comfortable atmosphere. Perry''s Cafe and food is known as a San Diego County landmark!', -117.201405, 32.756211, 'https://b.zmtcdn.com/data/reviews_photos/773/4e44af799ccb2a12f8073dbb94074773.jpg?fit=around%7C160%3A160&crop=160%3A160%3B%2A%2C%2A', 'https://roadarch.com/16/7/perrys.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Pizza Port Ocean Beach', 'Good food and good beer bring good cheer!', -117.250435, 32.747861, 'https://s3-media4.fl.yelpcdn.com/bphoto/njjZe47nqfXk-rbESKSytA/168s.jpg', 'https://s3-media1.fl.yelpcdn.com/bphoto/SAYL7SpNdB7uMwkCl-kZKw/o.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Lucha Libre Taco Shop: Mission Hills', 'A unique twist to high quality Mexican cuisine.', -117.181604, 32.743194, 'https://s3-media3.fl.yelpcdn.com/bphoto/o684J51Vt_Sx1BqDIwYfSQ/168s.jpg', 'http://ocmomdining.com/wp-content/uploads/2015/09/LuchaLibre6.jpg');
INSERT INTO location (name, description, longitude_x_coord, latitude_y_coord, small_img_url, banner_img_url) VALUES ('Lucha Libre Taco Shop: North Park', 'Unique theme to fit with vibrant and exciting menu ideas.', -117.129843, 32.748517, 'https://s3-media1.fl.yelpcdn.com/bphoto/vsUqe973xmQW2ubwQ_38lw/348s.jpg', 'https://s3-media1.fl.yelpcdn.com/bphoto/CYh47ZVv17jY0spxzHHmfA/o.jpg');

INSERT INTO day_of_week (day_id, day_name) VALUES (1, 'Monday');
INSERT INTO day_of_week (day_id, day_name) VALUES (2, 'Tuesday');
INSERT INTO day_of_week (day_id, day_name) VALUES (3, 'Wednesday');
INSERT INTO day_of_week (day_id, day_name) VALUES (4, 'Thursday');
INSERT INTO day_of_week (day_id, day_name) VALUES (5, 'Friday');
INSERT INTO day_of_week (day_id, day_name) VALUES (6, 'Saturday');
INSERT INTO day_of_week (day_id, day_name) VALUES (7, 'Sunday');
INSERT INTO day_of_week (day_id, day_name) VALUES (8, 'Every day');

INSERT INTO badge (name, badge_img_url, description, category_id, num_checkins, single_location) VALUES ('Sports Enthusiast', 'SportsEnthusiast.png', 'Checked in at 3 different locations with category "Sports Stadium"', 5, 3, false);
INSERT INTO badge (name, badge_img_url, description, category_id, num_checkins, single_location) VALUES ('Defender of the Land', 'Defender.png', 'Checked in at every location!', null, null, false);
INSERT INTO badge (name, badge_img_url, description, category_id, num_checkins, single_location) VALUES ('Tree Hugger', 'Tree-Hugger.png', 'Checked in at 3 different locations with category "Park"', 2, 3, false);
INSERT INTO badge (name, badge_img_url, description, category_id, num_checkins, single_location) VALUES ('Mayor of the Place', 'MayorOfThePlace.png', 'Checked in at one location on 10 different days', null, 10, true);
INSERT INTO badge (name, badge_img_url, description, category_id, num_checkins, single_location) VALUES ('Beach Bum', 'BeachBum.png', 'Checked in at 3 different locations with category "Beach"', 1, 3, false);

-- Wikipedia says "zoo (also called an animal park or menagerie)" so park for now?
INSERT INTO category_location (category_id, location_id) VALUES (2, 1);
INSERT INTO category_location (category_id, location_id) VALUES (1, 2);
INSERT INTO category_location (category_id, location_id) VALUES (2, 2);
INSERT INTO category_location (category_id, location_id) VALUES (1, 3);
INSERT INTO category_location (category_id, location_id) VALUES (2, 3);
INSERT INTO category_location (category_id, location_id) VALUES (1, 4);
INSERT INTO category_location (category_id, location_id) VALUES (2, 4);
INSERT INTO category_location (category_id, location_id) VALUES (3, 5);
INSERT INTO category_location (category_id, location_id) VALUES (4, 6);
INSERT INTO category_location (category_id, location_id) VALUES (5, 7);
INSERT INTO category_location (category_id, location_id) VALUES (4, 8);
INSERT INTO category_location (category_id, location_id) VALUES (3, 9);
INSERT INTO category_location (category_id, location_id) VALUES (3, 10);
INSERT INTO category_location (category_id, location_id) VALUES (3, 11);
INSERT INTO category_location (category_id, location_id) VALUES (2, 12);
INSERT INTO category_location (category_id, location_id) VALUES (2, 13);
INSERT INTO category_location (category_id, location_id) VALUES (2, 14);
INSERT INTO category_location (category_id, location_id) VALUES (4, 15);
INSERT INTO category_location (category_id, location_id) VALUES (4, 16);
INSERT INTO category_location (category_id, location_id) VALUES (4, 17);
INSERT INTO category_location (category_id, location_id) VALUES (5, 18);
INSERT INTO category_location (category_id, location_id) VALUES (5, 19);
INSERT INTO category_location (category_id, location_id) VALUES (1, 20);
INSERT INTO category_location (category_id, location_id) VALUES (2, 20);
INSERT INTO category_location (category_id, location_id) VALUES (5, 21);
INSERT INTO category_location (category_id, location_id) VALUES (4, 22);
INSERT INTO category_location (category_id, location_id) VALUES (2, 23);
INSERT INTO category_location (category_id, location_id) VALUES (4, 24);
INSERT INTO category_location (category_id, location_id) VALUES (4, 25);
INSERT INTO category_location (category_id, location_id) VALUES (4, 26);
INSERT INTO category_location (category_id, location_id) VALUES (4, 27);
INSERT INTO category_location (category_id, location_id) VALUES (4, 28);
INSERT INTO category_location (category_id, location_id) VALUES (4, 29);
INSERT INTO category_location (category_id, location_id) VALUES (4, 30);
INSERT INTO category_location (category_id, location_id) VALUES (4, 31);
INSERT INTO category_location (category_id, location_id) VALUES (4, 32);
INSERT INTO category_location (category_id, location_id) VALUES (4, 33);

-- Now for some location hours
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '06:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '06:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '06:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '06:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '06:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '07:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (1, '09:00 AM', '07:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (2, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (3, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (4, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '06:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '06:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '06:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '06:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '06:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '07:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (5, '08:00 AM', '07:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '08:00 AM', '03:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '08:00 AM', '03:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '08:00 AM', '03:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '08:00 AM', '03:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '08:00 AM', '03:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '06:00 AM', '03:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (6, '06:00 AM', '03:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (7, '08:00 AM', '03:00 PM', 8, 3, 10);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (8, '11:00 AM', '12:00 AM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '5:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '5:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '5:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '5:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '5:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '7:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (9, '11:00 AM', '7:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '5:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '5:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '5:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '5:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '5:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '7:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (10, '11:00 AM', '7:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '5:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '5:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '5:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '5:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '5:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '7:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (11, '11:00 AM', '7:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (12, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (13, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (14, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (15, '11:00 AM', '12:00 AM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (16, '11:00 AM', '12:00 AM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (17, '11:00 AM', '1:00 AM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (18, '08:00 AM', '03:00 PM', 8, 3, 10);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (19, '08:00 AM', '03:00 PM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (20, '12:00 AM', '12:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (21, '11:00 AM', '5:30 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (21, '11:00 AM', '5:30 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (21, '11:00 AM', '5:30 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (21, '11:00 AM', '5:30 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (21, '11:00 AM', '5:30 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '3:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '3:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '3:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '3:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '8:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '8:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (22, '8:00 AM', '8:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:30 AM', '5:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:30 AM', '5:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:30 AM', '5:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:30 AM', '5:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:30 AM', '5:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:00 AM', '7:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (23, '10:00 AM', '7:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (24, '11:00 AM', '9:00 PM', 8, 2, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (25, '8:30 AM', '3:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (25, '8:30 AM', '3:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (25, '8:30 AM', '3:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (25, '8:30 AM', '3:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (25, '8:30 AM', '3:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (25, '6:00 AM', '3:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (26, '11:00 AM', '9:00 PM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (27, '7:30 AM', '2:00 PM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '11:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '11:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '11:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '11:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '1:00 AM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '2:00 AM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (28, '11:00 AM', '2:00 AM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (29, '11:00 AM', '8:00 PM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (30, '7:00 AM', '11:00 AM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (31, '11:00 AM', '9:00 PM', 8, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '10:00 PM', 7, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '10:00 PM', 1, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '10:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '10:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '10:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '11:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (32, '11:00 AM', '11:00 PM', 6, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (33, '4:00 PM', '9:00 PM', 2, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (33, '4:00 PM', '9:00 PM', 3, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (33, '4:00 PM', '9:00 PM', 4, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (33, '4:00 PM', '10:00 PM', 5, 1, 12);
INSERT INTO location_hours (location_id, opens, closes, day_id, valid_from, valid_to) VALUES (33, '4:00 PM', '10:00 PM', 6, 1, 12);

INSERT INTO checkin (user_id, location_id, date_checkin) VALUES (1, 1, '08-01-2019');
INSERT INTO checkin (user_id, location_id, date_checkin) VALUES (1, 2, '08-02-2019');

COMMIT TRANSACTION;
