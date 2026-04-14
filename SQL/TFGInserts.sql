use TFG;
select * from staff;
select f.*, s.liftOff from flight f join schedule s on f.IATA = s.flightID where f.assignedPilot = 3;



-- plane inserts
insert into plane (ICAO) values
("A676"), ("B212"), ("C909"), ("D404"), ("E777"), ("F101"),
("H404"), ("I505"), ("J606"), ("K707"), ("L808"), ("M909"),
("O111"), ("P212"), ("N010"), ("Q313"), ("R414"), ("S515"), 
("U717"), ("V818"), ("W919"), ("X020"), ("Y121"), ("T616"), 
("AA23"), ("AB24"), ("AC25"), ("AD26"), ("AE27"), ("G303"), 
("AF28"), ("AG29"), ("AH30"), ("AI31"), ("AJ32"), ("AK33"), 
("AP38"), ("AQ39"), ("AR40"), ("AS41"), ("AT42"), ("AL34"), 
("AU43"), ("AV44"), ("AW45"), ("AX46"), ("AY47"), ("AM35"), 
("AN36"), ("AO37"), ("Z222"), ("Y676");


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

-- region inserts
insert into regions (regionID, region) values
(1, "Texas"),
(2, "Colorado"),
(3, "Illinois"),
(4, "Arizona"),
(5, "Georgia");

-- flight class inserts
insert into flightclass (className, price) values
("Economy", 100.00),
("First Class", 200.00),
("Goat Class", 10000.00);

-- airports 
insert into airports (regionID, place, name, IATA) values
(1, "Austin, TX", "Austin-Bergstrom Intl", "AUS"),
(1, "New York, NYC", "John F Kennedy Intl", "JFK"),
(1, "San Francisco, CA", "San Francisco Intl", "SFO"),
(2, "São Paulo, Brazil", "Guarulhos Intl", "GRU"),
(2, "Buenos Aires, Argentina", "Ministro Pistarini Intl", "EZE"),
(2, "Bogotá, Colombia", "El Dorado Intl", "BOG"),
(3, "Tokyo, Japan", "Haneda Intl", "HND"),
(3, "Dubai, UAE", "Dubai Intl", "DXB"),
(3, "Singapore, Singapore", "Changi Intl", "SIN"),
(4, "London, UK", "Heathrow Intl", "LHR"),
(4, "Paris, France", "Charles de Gaulle Intl", "CDG"),
(4, "Frankfurt, Germany", "Frankfurt am Main Intl", "FRA"),
(5, "Johannesburg, South Africa", "O.R. Tambo Intl", "JNB"),
(5, "Cairo, Egypt", "Cairo Intl", "CAI"),
(5, "Nairobi, Kenya", "Jomo Kenyatta Intl", "NBO");

select  * from staff;
select * from positionenums;

-- flight inserts
insert into flight (IATA, ICAO, planeName, gate, origin, destination, capacity, assignedPilot) values
("TP1001", "A676", "Goated67Plane", "A1", 1, 2, 20, 3),
("TP1002", "B212", "SkyRam900", "A2", 1, 3, 24, 3),
("TP1003", "C909", "HornetJet11", "B1", 1, 4, 16, 4),
("TP1004", "D404", "Nimbus220", "B2", 1, 5, 20, 5),
("TP1005", "E777", "CrownCruiser", "C1", 1, 6, 24, 10),
("TP1006", "F101", "AtlasSprint", "C2", 1, 7, 28, 12),
("TP1007", "G303", "GoatedFlight", "A1", 1, 2, 20, 3),
("TP1009", "H404", "GoatPlane", "D3", 1, 3, 24, 4),
("TP1011", "I505", "StormRider", "C3", 1, 4, 16, 5),
("TP1013", "J606", "NovaStar", "A1", 2, 3, 4, 10),
("TP1015", "K707", "ArcticBreeze", "D1", 2, 1, 20, 12),
("TP1017", "L808", "CoastalAce", "B2", 2, 5, 8, 17),
("TP1019", "M909", "ApexGlider", "A3", 3, 1, 12, 3),
("TP1021", "N010", "MidnightRun", "B3", 3, 2, 28, 4),
("TP1023", "O111", "CloudPiercer", "B2", 3, 4, 16, 5),
("TP1025", "P212", "EclipseJet", "B2", 4, 1, 28, 10),
("TP1027", "Q313", "SwiftArrow", "A1", 4, 2, 28, 12),
("TP1029", "R414", "CycloneX", "B3", 4, 5, 32, 17),
("TP1031", "S515", "TwilightAce", "C2", 5, 3, 32, 3),
("TP1033", "T616", "SkyLancer", "A2", 5, 1, 16, 4),
("TP1035", "U717", "NorthStar", "C3", 5, 4, 16, 5),
("TP1037", "V818", "TurboCondor", "A1", 6, 3, 12, 10),
("TP1039", "W919", "HighRoller", "B1", 6, 5, 32, 12),
("TP1041", "X020", "MachRacer", "D3", 7, 4, 8, 17),
("TP1043", "Y121", "CobaltJet", "D2", 7, 8, 8, 3),
("TP1045", "Z222", "HorizonX", "C1", 8, 9, 20, 4),
("TP1047", "AA23", "AltitudePro", "A3", 9, 1, 4, 5),
("TP1049", "AB24", "BlackKite", "B1", 10, 3, 28, 10),
("TP1051", "AC25", "MercuryWing", "A1", 10, 2, 12, 12),
("TP1053", "AD26", "CrimsonAce", "D3", 11, 3, 28, 17),
("TP1055", "AE27", "BronzeArrow", "B3", 11, 1, 28, 3),
("TP1057", "AF28", "DiamondAir", "D2", 12, 4, 28, 4),
("TP1059", "AG29", "SapphireGlide", "C2", 12, 5, 20, 5),
("TP1061", "AH30", "AmethystWing", "D1", 13, 4, 32, 10),
("TP1063", "AI31", "OpalSky", "D3", 13, 1, 32, 12),
("TP1065", "AJ32", "PeridotFlight", "C2", 14, 2, 8, 17),
("TP1067", "AK33", "QuartzSprint", "B3", 14, 5, 32, 3),
("TP1069", "AL34", "MarbleAce", "B2", 15, 3, 32, 4),
("TP1071", "AM35", "SlateHawk", "D1", 15, 1, 32, 5),
("TP1073", "AN36", "CanyonRunner", "B2", 1, 2, 32, 10),
("TP1075", "AO37", "DeltaGlide", "A3", 2, 3, 24, 12),
("TP1077", "AP38", "ZetaWing", "B3", 3, 4, 28, 17),
("TP1079", "AQ39", "ThetaStar", "A1", 4, 1, 8, 3),
("TP1081", "AR40", "KappaAir", "A2", 5, 9, 4, 4),
("TP1083", "AS41", "MuWing", "C3", 6, 3, 24, 5),
("TP1085", "AT42", "XiGlide", "C2", 7, 1, 24, 10),
("TP1087", "AU43", "PiAce", "D3", 8, 2, 24, 12),
("TP1089", "AV44", "SigmaFlight", "B2", 9, 4, 24, 17),
("TP1091", "AW45", "UpsilonJet", "D2", 10, 1, 20, 3),
("TP1093", "AX46", "ChiHawk", "C3", 11, 2, 16, 4),
("TP1095", "AY47", "OmegaAce", "D1", 12, 3, 16, 5),
-- added return routes (swapped origin/destination)
("TP1006", "F101", "AtlasSprint", "C2", 6, 1, 28, 12),  -- was 1,6 now 6,1
("TP1017", "L808", "CoastalAce", "B2", 5, 2, 8, 17),    -- was 2,5 now 5,2
("TP1027", "Q313", "SwiftArrow", "A1", 2, 4, 28, 12),   -- was 4,2 now 2,4
("TP1031", "S515", "TwilightAce", "C2", 3, 5, 32, 3),   -- was 5,3 now 3,5
("TP1081", "AR40", "KappaAir", "A2", 9, 5, 4, 4),       -- was 5,9 now 9,5
("TP1041", "X020", "MachRacer", "D3", 4, 7, 8, 17),     -- was 7,4 now 4,7
("TP1043", "Y121", "CobaltJet", "D2", 8, 7, 8, 3),      -- was 7,8 now 8,7
("TP1045", "Z222", "HorizonX", "C1", 9, 8, 20, 4),      -- was 8,9 now 9,8
("TP1047", "AA23", "AltitudePro", "A3", 1, 9, 4, 5),    -- was 9,1 now 1,9
("TP1049", "AB24", "BlackKite", "B1", 3, 10, 28, 10),   -- was 10,3 now 3,10
("TP1051", "AC25", "MercuryWing", "A1", 2, 10, 12, 12), -- was 10,2 now 2,10
("TP1053", "AD26", "CrimsonAce", "D3", 3, 11, 28, 17),  -- was 11,3 now 3,11
("TP1055", "AE27", "BronzeArrow", "B3", 1, 11, 28, 3),  -- was 11,1 now 1,11
("TP1057", "AF28", "DiamondAir", "D2", 4, 12, 28, 4),   -- was 12,4 now 4,12
("TP1059", "AG29", "SapphireGlide", "C2", 5, 12, 20, 5),-- was 12,5 now 5,12
("TP1061", "AH30", "AmethystWing", "D1", 4, 13, 32, 10),-- was 13,4 now 4,13
("TP1063", "AI31", "OpalSky", "D3", 1, 13, 32, 12),     -- was 13,1 now 1,13
("TP1065", "AJ32", "PeridotFlight", "C2", 2, 14, 8, 17),-- was 14,2 now 2,14
("TP1067", "AK33", "QuartzSprint", "B3", 5, 14, 32, 3), -- was 14,5 now 5,14
("TP1069", "AL34", "MarbleAce", "B2", 3, 15, 32, 4),    -- was 15,3 now 3,15
("TP1071", "AM35", "SlateHawk", "D1", 1, 15, 32, 5); 

select * from pilotscheduleinfo;

-- schedule inserts
insert into schedule (flightID, liftOff, landing) values
("TP1001", "10:06:07", "23:00:00"),
("TP1002", "13:30:00", "15:05:00"),
("TP1003", "09:15:00", "10:25:00"),
("TP1004", "16:40:00", "18:10:00"),
("TP1005", "07:00:00", "09:55:00"),
("TP1006", "19:20:00", "22:35:00");

-- flight class inserts
-- classID: 1 = Economy, 2 = First Class, 3 = Goat Class
insert into planeseat (seatNumber, scheduleID, classID) values
("1A", 1, 1),
("1B", 1, 2),
("1A", 2, 1),
("1B", 2, 2),
("1C", 3, 1),
("1D", 3, 3),
("1C", 4, 1),
("1D", 4, 2),
("1B", 5, 1),
("1C", 5, 2),
("1A", 6, 1),
("1D", 6, 3);

-- booking inserts
insert into booking (bookingDate, userID, departSeat, returnSeat, departDate, departSchedule, returnDate, returnSchedule) values
("2026-03-01 12:00:00", 1, "1A", "1A", "2026-03-10", 1, "2026-03-10", 2),
("2026-03-01 12:10:00", 2, "1B", "1B", "2026-03-10", 1, "2026-03-10", 2),
("2026-03-01 12:20:00", 1, "1C", "1C", "2026-03-11", 3, "2026-03-11", 4),
("2026-03-01 12:30:00", 2, "1D", "1D", "2026-03-11", 3, "2026-03-11", 4),
("2026-03-01 12:40:00", 1, "1B", "1A", "2026-03-12", 5, "2026-03-12", 6),
("2026-03-01 12:50:00", 2, "1C", "1D", "2026-03-12", 5, "2026-03-12", 6);

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

select * from reservationticket;
