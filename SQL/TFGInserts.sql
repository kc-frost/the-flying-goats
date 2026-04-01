use TFG;

-- plane inserts
insert into plane (ICAO) values
("A676"),
("B212"),
("C909"),
("D404"),
("E777"),
("F101");


-- users inserts
insert into users (phoneNumber, fname, lname, username, email, password, isStaff, registeredDate) values
("5127997308", "Alan", "Gascon", "McTails", "alangascon@gmail.com", sha2("password123", 224), 0, "2026-03-01 09:00:00"),
("5123005252", "Maria", "Valentine", "ValesMom", "mariavalentine@gmail.com", sha2("password234", 224), 1, "2026-03-01 09:15:00"),
("5125550101", "Kai", "Cairo", "kcfrost", "kaicairo@gmail.com", sha2("password345",224), 1, "2026-03-01 09:30:00"),
("5125550102", "Richard", "Walker", "rich93147", "richardwalker@gmail.com", sha2("password456",224), 1, "2026-03-01 09:45:00"),
("5125550103", "Erin", "Choi", "ErinCo", "erinchoi@gmail.com", sha2("password567",224), 1, "2026-03-01 10:00:00"),
("5125550104", "Omar", "Singh", "OmarSec", "omarsingh@gmail.com", sha2("password678",224), 0, "2026-03-01 10:15:00"),
("5125550105", "Tess", "Nguyen", "TessFA", "tessnguyen@gmail.com", sha2("password789",224), 0, "2026-03-01 10:30:00"),
("5125550106", "Luis", "Martinez", "LuisOps", "luismartinez@gmail.com", sha2("password890",224), 0, "2026-03-01 10:45:00"),
("5125550201", "Bongo", "Gigglefart", "bongojet", "bongogigglefart@gmail.com", sha2("password901",224), 1, "2026-03-01 11:00:00"),
("5125550202", "Crunch", "Giggler", "crunchpilot", "crunchgiggler@gmail.com", sha2("password902",224), 1, "2026-03-01 11:15:00"),
("5125550203", "Toaster", "Giggleblast", "toastgob", "toastergiggleblast@gmail.com", sha2("password903",224), 1, "2026-03-01 11:30:00"),
("5125550204", "Toe", "Gigglesnort", "toeLiker", "toegigglesnort@gmail.com", sha2("password904",224), 1, "2026-03-01 11:45:00"),
("5125550205", "Soggy", "Gigglenoodle", "sogwaff", "soggygigglenoodle@gmail.com", sha2("password905",224), 0, "2026-03-01 12:00:00"),
("5125550206", "Grease", "Gigglechunk", "greasemc", "greasegigglechunk@gmail.com", sha2("password906",224), 0, "2026-03-01 12:15:00"),
("5125550207", "Wiggles", "Gigglepants", "wigglefunk", "wigglesgigglepants@gmail.com", sha2("password907",224), 0, "2026-03-01 12:30:00"),
("5125550208", "Cheddar", "Gigglecheese", "chedblast", "cheddargigglecheese@gmail.com", sha2("password908",224), 0, "2026-03-01 12:45:00"),
("5125551000", "Rex", "Gigglefart", "rexhar", "rexgigglefart@gmail.com", sha2("password1000",224), 1, "2026-03-15 08:00:00"),
("5125551001", "Nadia", "Giggler", "nadiavos", "nadiagiggler@gmail.com", sha2("password1001",224), 1, "2026-03-15 08:00:00"),
("5125551002", "Colt", "Giggleblast", "coltbla", "coltgiggleblast@gmail.com", sha2("password1002",224), 1, "2026-03-15 08:00:00"),
("5125551003", "Inez", "Gigglesnort", "inezfer", "inezgigglesnort@gmail.com", sha2("password1003",224), 1, "2026-03-15 08:00:00");


-- position enums inserts
insert into positionenums (position) values
("Flight Attendent"),
("Pilot"),
("Co-Pilot"),
("Security"),
("Unassigned");

-- staff updates
update staff set positionID = 1 where staffID = 2;
update staff set positionID = 2 where staffID = 3;
update staff set positionID = 2 where staffID = 4;
update staff set positionID = 2 where staffID = 5;
update staff set positionID = 1 where staffID = 9;
update staff set positionID = 2 where staffID = 10;
update staff set positionID = 5 where staffID = 11;
update staff set positionID = 2 where staffID = 12;
update staff set positionID = 2 where staffID = 17;
update staff set positionID = 2 where staffID = 18;
update staff set positionID = 2 where staffID = 19;
update staff set positionID = 2 where staffID = 20;

select * from users;

-- regions inserts
insert into regions (regionID, region) values
(1, "Texas"),
(2, "Colorado"),
(3, "Illinois"),
(4, "Arizona"),
(5, "Georgia");

-- airports inserts
insert into airports (regionID, place, name, IATA) values
(1, "Austin", "Austin-Bergstrom International Airport", "AUS"),
(1, "Dallas", "Dallas Love Field", "DAL"),
(1, "Houston", "George Bush Intercontinental Airport", "IAH"),
(1, "San Antonio", "San Antonio International Airport", "SAT"),
(2, "Denver", "Denver International Airport", "DEN"),
(3, "Chicago", "O'Hare International Airport", "ORD"),
(4, "Phoenix", "Phoenix Sky Harbor International Airport", "PHX"),
(5, "Atlanta", "Hartsfield-Jackson Atlanta International Airport", "ATL");

-- flight inserts
insert into flight (IATA, ICAO, planeName, gate, origin, destination, capacity, assignedPilot) values
("TP1001", "A676", "Goated67Plane", "A1", 1, 2, 20, 3),
("TP1002", "B212", "SkyRam900", "A2", 1, 3, 24, 3),
("TP1003", "C909", "HornetJet11", "B1", 1, 4, 16, 4),
("TP1004", "D404", "Nimbus220", "B2", 1, 5, 20, 5),
("TP1005", "E777", "CrownCruiser", "C1", 1, 6, 24, 10),
("TP1006", "F101", "AtlasSprint", "C2", 1, 7, 28, 12);

-- schedule inserts
insert into schedule (flightID, liftOff, landing, status) values
("TP1001", "10:06:07", "12:00:00", "On Time"),
("TP1002", "13:30:00", "15:05:00", "On Time"),
("TP1003", "09:15:00", "10:25:00", "On Time"),
("TP1004", "16:40:00", "18:10:00", "On Time"),
("TP1005", "07:00:00", "09:55:00", "On Time"),
("TP1006", "19:20:00", "22:35:00", "On Time");

-- flight class inserts
insert into flightclass (className, price) values
("Economy", 100.00),
("First Class", 200.00),
("Goat Class", 10000.00);

-- plane seat inserts
-- classID: 1 = Economy, 2 = First Class, 3 = Goat Class
insert into planeseat (seatNumber, scheduleID, classID) values
("101", 1, 1),
("102", 1, 2),
("103", 2, 1),
("104", 2, 2),
("105", 3, 1),
("106", 3, 3),
("107", 4, 1),
("108", 4, 2),
("109", 5, 1),
("110", 5, 2),
("111", 6, 1),
("112", 6, 3);

-- booking inserts
insert into booking (bookingDate, userID, departSeat, returnSeat, departDate, departSchedule, returnDate, returnSchedule) values
("2026-03-01 12:00:00", 1, "101", "103", "2026-03-10", 1, "2026-03-10", 2),
("2026-03-01 12:10:00", 2, "102", "104", "2026-03-10", 1, "2026-03-10", 2),
("2026-03-01 12:20:00", 1, "105", "107", "2026-03-11", 3, "2026-03-11", 4),
("2026-03-01 12:30:00", 2, "106", "108", "2026-03-11", 3, "2026-03-11", 4),
("2026-03-01 12:40:00", 1, "109", "111", "2026-03-12", 5, "2026-03-12", 6),
("2026-03-01 12:50:00", 2, "110", "112", "2026-03-12", 5, "2026-03-12", 6);

-- parking lot inserts (lowk unneeded right now though.
insert into parkinglot(lot, lotSpace) values
("A", 100),
("B", 120),
("C", 80),
("D", 60),
("E", 150),
("F", 90);

-- item inserts
insert into item(itemName, itemDescription, type) values
("Metal Detector", "Primary security screening device used at entry checkpoints.", "equipment"),
("First Aid Kit", "Emergency medical kit stored for handling minor injuries and health incidents.", "equipment"),
("First Aid Kit", "Emergency medical kit stored for handling minor injuries and health incidents.", "equipment"),
("Baggage Tug", "Vehicle used to transport luggage carts between terminals and aircraft.", "transportation"),
("Passenger Shuttle", "Ground shuttle used to move passengers between terminals and gates.", "transportation"),
("Lost & Found Bin", "Storage container used for temporarily holding lost passenger items.", "misc"),
("Cleaning Supplies", "General cleaning materials used by maintenance staff throughout the airport.", "misc");

-- inventory inserts
insert into inventory(itemID, quantity) values
(1, 10),
(2, 25),
(3, 3),
(4, 2),
(5, 1),
(6, 18),
(7, 12);

select * from staff;
select * from positionenums;