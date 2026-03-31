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
update staff set positionID = 1 where staffID = 2;
update staff set positionID = 2 where staffID = 3;
update staff set positionID = 2 where staffID = 4;
update staff set positionID = 2 where staffID = 5;
update staff set positionID = 1 where staffID = 9;
update staff set positionID = 2 where staffID = 10;
update staff set positionID = 5 where staffID = 11;
update staff set positionID = 2 where staffID = 12;

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
insert into flight (IATA, ICAO, planeName, gate, origin, destination, assignedPilot) values
("TP1001", "A676", "Goated67Plane", "A1", 1, 2, 3),
("TP1002", "B212", "SkyRam900", "A2", 1, 3, 3),
("TP1003", "C909", "HornetJet11", "B1", 1, 4, 4),
("TP1004", "D404", "Nimbus220", "B2", 1, 5, 5),
("TP1005", "E777", "CrownCruiser", "C1", 1, 6, 10),
("TP1006", "F101", "AtlasSprint", "C2", 1, 7, 12);

-- schedule inserts
insert into schedule (flightID, liftOff, landing, status) values
("TP1001", "2026-03-10 10:06:07", "2026-03-10 12:00:00", "On Time"),
("TP1002", "2026-03-10 13:30:00", "2026-03-10 15:05:00", "On Time"),
("TP1003", "2026-03-11 09:15:00", "2026-03-11 10:25:00", "On Time"),
("TP1004", "2026-03-11 16:40:00", "2026-03-11 18:10:00", "On Time"),
("TP1005", "2026-03-12 07:00:00", "2026-03-12 09:55:00", "On Time"),
("TP1006", "2026-03-12 19:20:00", "2026-03-12 22:35:00", "On Time");

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
(6, 18);

select * from staff;
select * from positionenums;

-- Test flight inserts for testing pilot schedule
-- April 1st test flight
insert into flight (IATA, planeName, gate, origin, destination, assignedPilot)
values ("TX101", "Boeing 737", "A1", 1, 2, 3);

insert into schedule (flightID, liftOff, landing, status)
values (
    "TX101",
    "2026-04-01 10:00:00",
    "2026-04-01 11:30:00",
    "On Time"
);

-- April 3rd (pilot 3)
insert into flight (IATA, planeName, gate, origin, destination, assignedPilot)
values ("TX203", "Boeing 777", "D4", 1, 6, 3);

insert into schedule (flightID, liftOff, landing, status)
values (
    "TX203",
    "2026-04-03 14:00:00",
    "2026-04-03 17:30:00",
    "On Time"
);

-- Today (pilot 3)
insert into flight (IATA, planeName, gate, origin, destination, assignedPilot)
values ("TX204", "Embraer 175", "E5", 1, 8, 3);

insert into schedule (flightID, liftOff, landing, status)
values (
    "TX204",
    CONCAT(CURDATE(), " 12:00:00"),
    CONCAT(CURDATE(), " 14:30:00"),
    "On Time"
);

-- April 1st flight for pilot 4
insert into flight (IATA, planeName, gate, origin, destination, assignedPilot)
values ("TX205", "Boeing 737", "F6", 1, 7, 4);

insert into schedule (flightID, liftOff, landing, status)
values (
    "TX205",
    "2026-04-01 15:00:00",
    "2026-04-01 17:15:00",
    "On Time"
);

select * from users;
select * from staff;