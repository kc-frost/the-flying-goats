use TFG;

-- plane status enums inserts
insert into planestatusenums (psEnumID, status, ICAO) values
(1, "On Time", null),
(2, "Delayed", null),
(3, "Boarding", null),
(4, "Taxiing", null),
(5, "Airborne", null),
(6, "Landing", null),
(7, "Grounded", null);

-- plane inserts
insert into plane (ICAO, statusID) values
("A676", 1),
("B212", 2),
("C909", 3),
("D404", 4),
("E777", 5),
("F101", 6);

-- flight inserts
insert into flight (IATA, planeName, gate, origin, destination) values
("TP1001", "Goated67Plane", "A1", "Austin", "Dallas"),
("TP1002", "SkyRam900", "A2", "Austin", "Houston"),
("TP1003", "HornetJet11", "B1", "Austin", "San Antonio"),
("TP1004", "Nimbus220", "B2", "Austin", "Denver"),
("TP1005", "CrownCruiser", "C1", "Austin", "Chicago"),
("TP1006", "AtlasSprint", "C2", "Austin", "Phoenix");

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
("5125550103", "Erin", "Choi", "ErinCo", "erin.choi@tfg.com", "password567", 1, "2026-03-01 10:00:00"),
("5125550104", "Omar", "Singh", "OmarSec", "omar.singh@tfg.com", "password678", 0, "2026-03-01 10:15:00"),
("5125550105", "Tess", "Nguyen", "TessFA", "tess.nguyen@tfg.com", "password789", 0, "2026-03-01 10:30:00"),
("5125550106", "Luis", "Martinez", "LuisOps", "luis.martinez@tfg.com", "password890", 0, "2026-03-01 10:45:00");

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
update staff set positionID = 3 where staffID = 4;
update staff set positionID = 4 where staffID = 5;

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