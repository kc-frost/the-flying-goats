use TFG;
-- plane status enums inserts
insert into planestatusenums (psenumID, status, icao) values
(1, "On Time", null),
(2, "Delayed", null),
(3, "Boarding", null),
(4, "Taxiing", null),
(5, "Airborne", null),
(6, "Landing", null);

-- plane inserts
insert into plane(ICAO, statusID) values
("A676", 1),
("B212", 2),
("C909", 3),
("D404", 4),
("E777", 5),
("F101", 6);

-- flight inserts
insert into flight(IATA, planeName, gate, destination) values
("TP1001", "Goated67Plane", "A1", "Austin"),
("TP1002", "SkyRam900", "A2", "Dallas"),
("TP1003", "HornetJet11", "B1", "Houston"),
("TP1004", "Nimbus220", "B2", "San Antonio"),
("TP1005", "CrownCruiser", "C1", "Denver"),
("TP1006", "AtlasSprint", "C2", "Chicago");

-- schedule inserts
insert into schedule(flight, liftOff, landing) values
("TP1001", "2026-03-10 10:06:07", "2026-03-10 12:00:00"),
("TP1002", "2026-03-10 13:30:00", "2026-03-10 15:05:00"),
("TP1003", "2026-03-11 09:15:00", "2026-03-11 10:25:00"),
("TP1004", "2026-03-11 16:40:00", "2026-03-11 18:10:00"),
("TP1005", "2026-03-12 07:00:00", "2026-03-12 09:55:00"),
("TP1006", "2026-03-12 19:20:00", "2026-03-12 22:35:00");

-- users inserts
insert into users(phoneNumber, fname, lname, username, email, password, isStaff) values
("5127997308", "Alan", "Gascon", "McTails", "alangascon@gmail.com", "password123", false),
("5123005252", "Maria", "Valentine", "ValesMom", "mariavalentine@gmail.com", "password234", true),
("5125550101", "Kai", "Cairo", "kcfrost", "kaicairo@tfg.com", "password345", true),
("5125550102", "Richard", "Walker", "rich93147", "richardwalker@tfg.com", "password456", true),
("5125550103", "Erin", "Choi", "ErinCo", "erin.choi@tfg.com", "password567", true),
("5125550104", "Omar", "Singh", "OmarSec", "omar.singh@tfg.com", "password678", false),
("5125550105", "Tess", "Nguyen", "TessFA", "tess.nguyen@tfg.com", "password789", false),
("5125550106", "Luis", "Martinez", "LuisOps", "luis.martinez@tfg.com", "password890", false);

select * from users;
select * from staff;

-- position enums inserts
insert into positionenums(position) values
("Flight Attendent"), 
("Pilot"), 
("Co-Pilot"), 
("Security"), 
("Unassigned"),
("Unassigned");

-- staff UPDATES, staff won't have inserts, but updates instead. Everything in staff is dependent on other tables, and inserts conflict with user inserts. Instead, we're just gunna update their positionIDS.
update staff set positionID = 1 where staffID = 2;
update staff set positionID = 2 where staffID = 3;
update staff set positionID = 3 where staffID = 4;
update staff set positionID = 4 where staffID = 5;

-- flight class
insert into flightclass(classname, price) values
("Economy", 100.00),
("First Class", 200.00),
("Goat Class", 10000);

-- plane seat inserts
insert into planeseat(seatNumber,flightID, class) values
(101, "TP1001", "Economy"),
(102, "TP1001", "First Class"),
(103, "TP1002", "Economy"),
(104, "TP1002", "First Class"),
(105, "TP1003", "Economy"),
(106, "TP1003", "Goat Class");

-- booking inserts
insert into booking (userID, flightID, seat) values
(1,  "TP1001", 101),
(2,  "TP1002", 103),
(1,  "TP1003", 105),
(2,  "TP1004", 101),
(1,  "TP1005", 103),
(2,  "TP1006", 105);

-- parking lot inserts
insert into parkinglot (lot, lotSpace) values
("A", 100),
("B", 120),
("C", 80),
("D", 60),
("E", 150),
("F", 90);

-- item inserts
insert into item (itemName, itemDescription, type) values
("Metal Detector", "Primary security screening device used at entry checkpoints.", "equipment"),
("First Aid Kit", "Emergency medical kit stored for handling minor injuries and health incidents.", "equipment"),
("Baggage Tug", "Vehicle used to transport luggage carts between terminals and aircraft.", "transportation"),
("Passenger Shuttle", "Ground shuttle used to move passengers between terminals and gates.", "transportation"),
("Lost & Found Bin", "Storage container used for temporarily holding lost passenger items.", "misc"),
("Cleaning Supplies", "General cleaning materials used by maintenance staff throughout the airport.", "misc");

-- inventory inserts
insert into inventory (itemID, quantity) values
(1, 10),
(2, 25),
(3, 3),
(4, 2),
(5, 1),
(6, 18);

-- there are NO equipment, transportation, or miscellaneous inserts. Same with staff, it's unnecessary and just creates conflicts. All inserts should go into item either way.

-- uncomment what you wanna look at, then recomment to avoid clutter.

-- select * from planestatusenums;
-- select * from plane;
-- select * from flight;
-- select * from schedule;
-- select * from users;
-- select * from staff;
-- select * from positionenums;
-- select * from flightclass;
-- select * from planeseat;
-- select * from booking;
-- select * from equipment;
-- select * from transportation;
-- select * from miscellaneousItem;
-- select * from parkinglot;
-- select * from item;
-- select * from inventory;
-- select * from staffCountPerPosition;
-- select * from inventoryNames;