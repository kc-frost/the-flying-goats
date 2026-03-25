use TFG;

-- regions
insert into regions() values
(1, "North America"),
(2, "South America"),
(3, "Asia"),
(4, "Europe"),
(5, "Africa");

-- plane status enums inserts
insert into planestatusenums (psEnumID, status, ICAO) values
(1, "On Time", null),
(2, "Delayed", null),
(3, "Boarding", null),
(4, "Taxiing", null),
(5, "Airborne", null),
(6, "Landing", null),
(7, "Grounded", null);

-- airports
insert into airports(regionID, place, name, IATA) values
-- North America
(1, "Austin, TX", "Austin-Bergstrom Intl", "AUS"),
(1, "New York, NYC", "John F Kennedy Intl", "JFK"),
(1, "San Francisco, CA", "San Francisco Intl.", "SFO"),
(1, "Atlanta, GA", "Hartsfield-Jackson Int", "ATL"),
(1, "Toronto, ON", "Lester B. Pearson Intl", "YYZ"),
(1, "Mexico City, Mexico", "Benito Juarez Intl", "MEX"),
-- South America
(2, "São Paulo, Brazil", "Guarulhos Intl", "GRU"),
(2, "Buenos Aires, Argentina", "Ministro Pistarini Intl", "EZE"),
(2, "Bogotá, Colombia", "El Dorado Intl", "BOG"),
(2, "Lima, Peru", "Jorge Chávez Intl", "LIM"),
(2, "Santiago, Chile", "Arturo Merino Benítez Intl", "SCL"),
-- Asia
(3, "Manila, Philippines", "Ninoy Aquino Intl", "MNL"),
(3, "Tokyo, Japan", "Haneda Intl", "HND"),
(3, "Dubai, UAE", "Dubai Intl", "DXB"),
(3, "Singapore, Singapore", "Changi Intl", "SIN"),
(3, "Beijing, China", "Capital Intl", "PEK"),
-- Europe
(4, "London, UK", "Heathrow Intl", "LHR"),
(4, "Paris, France", "Charles de Gaulle Intl", "CDG"),
(4, "Frankfurt, Germany", "Frankfurt am Main Intl", "FRA"),
(4, "Madrid, Spain", "Adolfo Suárez Madrid-Barajas Intl", "MAD"),
(4, "Sofia, Bulgaria", "Sofia Airport", "SOF"),
-- Africa
(5, "Johannesburg, South Africa", "O.R. Tambo Intl", "JNB"),
(5, "Cairo, Egypt", "Cairo Intl", "CAI"),
(5, "Nairobi, Kenya", "Jomo Kenyatta Intl", "NBO"),
(5, "Lagos, Nigeria", "Murtala Muhammed Intl", "LOS"),
(5, "Casablanca, Morocco", "Mohammed V Intl", "CMN");

-- plane inserts
insert into plane (ICAO, statusID) values
("A676", 1),
("B212", 2),
("C909", 3),
("D404", 4),
("E777", 5),
("F101", 6);

-- flight inserts
insert into flight (IATA, planeName, gate, origin, destination, capacity) values
("TP1001", "Goated67Plane", "A1", 1, 2, 4), -- AUS -> NYC
("TP1002", "SkyRam900", "A2", 1, 3, 18), 	-- AUS -> SFO
("TP1003", "HornetJet11", "B1", 1, 23, 8),	-- AUS -> CAI
("TP1004", "Nimbus220", "B2", 1, 13, 12),	-- AUS -> HND
("TP1005", "CrownCruiser", "C1", 1, 16, 32),	-- AUS -> PEK
("TP1006", "AtlasSprint", "C2", 1, 21, 20);		-- AUS -> SOF

-- schedule inserts
insert into schedule (flight, liftOff, landing) values
("TP1001", "2026-03-10 10:06:07", "2026-03-10 12:00:00"),
("TP1002", "2026-03-10 13:30:00", "2026-03-10 15:05:00"),
("TP1003", "2026-03-11 09:15:00", "2026-03-11 10:25:00"),
("TP1004", "2026-03-11 16:40:00", "2026-03-11 18:10:00"),
("TP1005", "2026-03-12 07:00:00", "2026-03-12 09:55:00"),
("TP1006", "2026-03-12 19:20:00", "2026-03-12 22:35:00");

-- users inserts
insert into users (phoneNumber, fname, lname, username, email, password, isStaff, registeredDate) values
("5127997308", "Alan", "Gascon", "McTails", "alangascon@gmail.com", "password123", 0, "2026-03-01 09:00:00"),
("5123005252", "Maria", "Valentine", "ValesMom", "mariavalentine@gmail.com", "password234", 1, "2026-03-01 09:15:00"),
("5125550101", "Kai", "Cairo", "kcfrost", "kaicairo@tfg.com", "password345", 1, "2026-03-01 09:30:00"),
("5125550102", "Richard", "Walker", "rich93147", "richardwalker@tfg.com", "password456", 1, "2026-03-01 09:45:00"),
("5125550103", "Erin", "Choi", "ErinCo", "erinchoi@tfg.com", "password567", 1, "2026-03-01 10:00:00"),
("5125550104", "Omar", "Singh", "OmarSec", "omarsingh@tfg.com", "password678", 0, "2026-03-01 10:15:00"),
("5125550105", "Tess", "Nguyen", "TessFA", "tessnguyen@tfg.com", "password789", 0, "2026-03-01 10:30:00"),
("5125550106", "Luis", "Martinez", "LuisOps", "luis.martinez@tfg.com", "password890", 0, "2026-03-01 10:45:00"),
("5125550201", "Bongo", "Meatwagon", "bongojet", "bongomeatwagon@tfg.com", "password901", 1, "2026-03-01 11:00:00"),
("5125550202", "Crunch", "Spaghetti", "crunchpilot", "crunchspaghetti@tfg.com", "password902", 1, "2026-03-01 11:15:00"),
("5125550203", "Toaster", "Goblin", "toastgob", "toastergoblin@tfg.com", "password903", 1, "2026-03-01 11:30:00"),
("5125550204", "Toe", "Enjoyer", "toeLiker", "toelover@tfg.com", "password904", 1, "2026-03-01 11:45:00"),
("5125550205", "Soggy", "Waffle", "sogwaff", "soggywaffle@tfg.com", "password905", 0, "2026-03-01 12:00:00"),
("5125550206", "Grease", "McChicken", "greasemc", "greasemcchicken@tfg.com", "password906", 0, "2026-03-01 12:15:00"),
("5125550207", "Wiggles", "Funk", "wigglefunk", "wigglesfunk@tfg.com", "password907", 0, "2026-03-01 12:30:00"),
("5125550208", "Cheddar", "Blaster", "chedblast", "cheddarblaster@tfg.com", "password908", 0, "2026-03-01 12:45:00");

select * from users;
select * from staff;

-- position enums inserts
insert into positionenums (position) values
("Flight Attendent"),
("Pilot"),
("Co-Pilot"),
("Security"),
("Unassigned");

-- staff updates
update staff set positionID = 1 where staffID = 24;
update staff set positionID = 2 where staffID = 25;
update staff set positionID = 3 where staffID = 26;
update staff set positionID = 4 where staffID = 27;
update staff set positionID = 1 where staffID = 28;
update staff set positionID = 4 where staffID = 29;
update staff set positionID = 5 where staffID = 30;
update staff set positionID = 5 where staffID = 31;

-- flight class inserts
insert into flightclass (className, price) values
("Economy", 100.00),
("First Class", 200.00),
("Goat Class", 10000.00);

-- plane seat inserts
-- classID: 1 = Economy, 2 = First Class, 3 = Goat Class
insert into planeseat (seatNumber, flightID, classID) values
(101, "TP1001", 1),
(102, "TP1001", 2),
(103, "TP1002", 1),
(104, "TP1002", 2),
(105, "TP1003", 1),
(106, "TP1003", 3),
(107, "TP1004", 1),
(108, "TP1004", 2),
(109, "TP1005", 1),
(110, "TP1005", 2),
(111, "TP1006", 1),
(112, "TP1006", 3);

-- booking inserts
insert into booking (userID, flightID, seat, bookingDate) values
(1, "TP1001", 101, "2026-03-01 12:00:00"),
(2, "TP1002", 103, "2026-03-01 12:10:00"),
(1, "TP1003", 105, "2026-03-01 12:20:00"),
(2, "TP1004", 107, "2026-03-01 12:30:00"),
(1, "TP1005", 109, "2026-03-01 12:40:00"),
(2, "TP1006", 111, "2026-03-01 12:50:00");

insert into parkingLot(lot, lotSpace) values
("A", 100),
("B", 120),
("C", 80),
("D", 60),
("E", 150),
("F", 90);

insert into item(itemName, itemDescription, type) values
("Metal Detector", "Primary security screening device used at entry checkpoints.", "equipment"),
("First Aid Kit", "Emergency medical kit stored for handling minor injuries and health incidents.", "equipment"),
("Baggage Tug", "Vehicle used to transport luggage carts between terminals and aircraft.", "transportation"),
("Passenger Shuttle", "Ground shuttle used to move passengers between terminals and gates.", "transportation"),
("Lost & Found Bin", "Storage container used for temporarily holding lost passenger items.", "misc"),
("Cleaning Supplies", "General cleaning materials used by maintenance staff throughout the airport.", "misc");

insert into inventory(itemID, quantity) values
(1, 10),
(2, 25),
(3, 3),
(4, 2),
(5, 1),
(6, 18);

select * from item;