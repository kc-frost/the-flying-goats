-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: tfg
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airports` (
  `airportID` int NOT NULL AUTO_INCREMENT,
  `regionID` int DEFAULT NULL,
  `place` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `IATA` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`airportID`),
  KEY `fk_airports_region` (`regionID`),
  CONSTRAINT `fk_airports_region` FOREIGN KEY (`regionID`) REFERENCES `regions` (`regionID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES (1,1,'Austin','Austin-Bergstrom International Airport','AUS'),(2,1,'Dallas','Dallas Love Field','DAL'),(3,1,'Houston','George Bush Intercontinental Airport','IAH'),(4,1,'San Antonio','San Antonio International Airport','SAT'),(5,2,'Denver','Denver International Airport','DEN'),(6,3,'Chicago','O\'Hare International Airport','ORD'),(7,4,'Phoenix','Phoenix Sky Harbor International Airport','PHX'),(8,5,'Atlanta','Hartsfield-Jackson Atlanta International Airport','ATL'),(9,1,'Austin, TX','Austin-Bergstrom Intl','AUS'),(10,1,'New York, NYC','John F Kennedy Intl','JFK'),(11,1,'San Francisco, CA','San Francisco Intl.','SFO'),(12,2,'São Paulo, Brazil','Guarulhos Intl','GRU'),(13,2,'Buenos Aires, Argentina','Ministro Pistarini Intl','EZE'),(14,2,'Bogotá, Colombia','El Dorado Intl','BOG'),(15,3,'Tokyo, Japan','Haneda Intl','HND'),(16,3,'Dubai, UAE','Dubai Intl','DXB'),(17,3,'Singapore, Singapore','Changi Intl','SIN'),(18,4,'London, UK','Heathrow Intl','LHR'),(19,4,'Paris, France','Charles de Gaulle Intl','CDG'),(20,4,'Frankfurt, Germany','Frankfurt am Main Intl','FRA'),(21,5,'Johannesburg, South Africa','O.R. Tambo Intl','JNB'),(22,5,'Cairo, Egypt','Cairo Intl','CAI'),(23,5,'Nairobi, Kenya','Jomo Kenyatta Intl','NBO');
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `bookingNumber` int NOT NULL AUTO_INCREMENT,
  `bookingDate` datetime DEFAULT NULL,
  `userID` int DEFAULT NULL,
  `departSeat` varchar(3) DEFAULT NULL,
  `returnSeat` varchar(3) DEFAULT NULL,
  `departDate` date DEFAULT NULL,
  `departSchedule` int NOT NULL,
  `returnDate` date DEFAULT NULL,
  `returnSchedule` int NOT NULL,
  PRIMARY KEY (`bookingNumber`),
  KEY `fk_booking_user` (`userID`),
  KEY `fk_depart_schedule` (`departSchedule`),
  KEY `fk_return_schedule` (`returnSchedule`),
  KEY `fk_departDetails` (`departSeat`,`departSchedule`),
  KEY `fk_returnDetails` (`returnSeat`,`returnSchedule`),
  CONSTRAINT `fk_booking_user` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`),
  CONSTRAINT `fk_depart_schedule` FOREIGN KEY (`departSchedule`) REFERENCES `schedule` (`scheduleID`),
  CONSTRAINT `fk_departDetails` FOREIGN KEY (`departSeat`, `departSchedule`) REFERENCES `planeseat` (`seatNumber`, `scheduleID`),
  CONSTRAINT `fk_return_schedule` FOREIGN KEY (`returnSchedule`) REFERENCES `schedule` (`scheduleID`),
  CONSTRAINT `fk_returnDetails` FOREIGN KEY (`returnSeat`, `returnSchedule`) REFERENCES `planeseat` (`seatNumber`, `scheduleID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,'2026-03-01 12:00:00',1,'101','103','2026-03-10',1,'2026-03-10',2),(2,'2026-03-01 12:10:00',2,'102','104','2026-03-10',1,'2026-03-10',2),(3,'2026-03-01 12:20:00',1,'105','107','2026-03-11',3,'2026-03-11',4),(4,'2026-03-01 12:30:00',2,'106','108','2026-03-11',3,'2026-03-11',4),(5,'2026-03-01 12:40:00',1,'109','111','2026-03-12',5,'2026-03-12',6),(6,'2026-03-01 12:50:00',2,'110','112','2026-03-12',5,'2026-03-12',6);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookinghistory`
--

DROP TABLE IF EXISTS `bookinghistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookinghistory` (
  `bookingNumber` int NOT NULL,
  `userID` int DEFAULT NULL,
  `flightID` varchar(7) DEFAULT NULL,
  `seat` varchar(3) DEFAULT NULL,
  `bookingDate` datetime DEFAULT NULL,
  `bookingStatus` enum('Cancelled','Completed') DEFAULT NULL,
  `assignedPilot` int DEFAULT NULL,
  PRIMARY KEY (`bookingNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookinghistory`
--

LOCK TABLES `bookinghistory` WRITE;
/*!40000 ALTER TABLE `bookinghistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookinghistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deletedusers`
--

DROP TABLE IF EXISTS `deletedusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deletedusers` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `phoneNumber` char(10) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `isStaff` tinyint(1) DEFAULT '0',
  `bio` text,
  `registeredDate` datetime DEFAULT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deletedusers`
--

LOCK TABLES `deletedusers` WRITE;
/*!40000 ALTER TABLE `deletedusers` DISABLE KEYS */;
/*!40000 ALTER TABLE `deletedusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment` (
  `itemID` int NOT NULL,
  `equipmentName` varchar(255) DEFAULT NULL,
  `equipmentDescription` text,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `fk_equipment_item` FOREIGN KEY (`itemID`) REFERENCES `item` (`itemID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.'),(3,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight` (
  `flightID` int NOT NULL AUTO_INCREMENT,
  `IATA` varchar(7) NOT NULL,
  `ICAO` varchar(4) DEFAULT NULL,
  `planeName` varchar(255) DEFAULT NULL,
  `gate` varchar(2) DEFAULT NULL,
  `origin` int DEFAULT NULL,
  `destination` int DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `assignedPilot` int DEFAULT NULL,
  PRIMARY KEY (`IATA`),
  UNIQUE KEY `flightID` (`flightID`),
  UNIQUE KEY `IATA` (`IATA`,`origin`,`destination`),
  KEY `fk_staffID` (`assignedPilot`),
  KEY `fk_planeICAO` (`ICAO`),
  KEY `fk_flight_origin` (`origin`),
  KEY `fk_flight_destination` (`destination`),
  CONSTRAINT `fk_flight_destination` FOREIGN KEY (`destination`) REFERENCES `airports` (`airportID`),
  CONSTRAINT `fk_flight_origin` FOREIGN KEY (`origin`) REFERENCES `airports` (`airportID`),
  CONSTRAINT `fk_planeICAO` FOREIGN KEY (`ICAO`) REFERENCES `plane` (`ICAO`),
  CONSTRAINT `fk_staffID` FOREIGN KEY (`assignedPilot`) REFERENCES `staff` (`staffID`),
  CONSTRAINT `chk_capacity` CHECK (((`capacity` <= 36) and (`capacity` >= 0) and ((`capacity` % 4) = 0)))
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES (1,'TP1001','A676','Goated67Plane','A1',1,2,20,3),(2,'TP1002','B212','SkyRam900','A2',1,3,24,3),(3,'TP1003','C909','HornetJet11','B1',1,4,16,4),(4,'TP1004','D404','Nimbus220','B2',1,5,20,5),(5,'TP1005','E777','CrownCruiser','C1',1,6,24,10),(6,'TP1006','F101','AtlasSprint','C2',1,7,28,12),(7,'TP1007',NULL,'GoatedFlight','A1',1,2,20,3),(8,'TP1009',NULL,'GoatPlane','D3',1,3,24,4),(9,'TP1011',NULL,'StormRider','C3',1,4,16,5),(10,'TP1013',NULL,'NovaStar','A1',2,3,4,10),(11,'TP1015',NULL,'ArcticBreeze','D1',2,1,20,12),(12,'TP1017',NULL,'CoastalAce','B2',2,5,8,17),(13,'TP1019',NULL,'ApexGlider','A3',3,1,12,3),(14,'TP1021',NULL,'MidnightRun','B3',3,2,28,4),(15,'TP1023',NULL,'CloudPiercer','B2',3,4,16,5),(16,'TP1025',NULL,'EclipseJet','B2',4,1,28,10),(17,'TP1027',NULL,'SwiftArrow','A1',4,2,28,12),(18,'TP1029',NULL,'CycloneX','B3',4,5,32,17),(19,'TP1031',NULL,'TwilightAce','C2',5,3,32,3),(20,'TP1033',NULL,'SkyLancer','A2',5,1,16,4),(21,'TP1035',NULL,'NorthStar','C3',5,4,16,5),(22,'TP1037',NULL,'TurboCondor','A1',1,3,12,10),(23,'TP1039',NULL,'HighRoller','B1',1,5,32,12),(24,'TP1041',NULL,'MachRacer','D3',2,4,8,17),(25,'TP1043',NULL,'CobaltJet','D2',2,3,8,3),(26,'TP1045',NULL,'HorizonX','C1',3,5,20,4),(27,'TP1047',NULL,'AltitudePro','A3',3,1,4,5),(28,'TP1049',NULL,'BlackKite','B1',4,3,28,10),(29,'TP1051',NULL,'MercuryWing','A1',4,2,12,12),(30,'TP1053',NULL,'CrimsonAce','D3',5,3,28,17),(31,'TP1055',NULL,'BronzeArrow','B3',5,1,28,3),(32,'TP1057',NULL,'DiamondAir','D2',1,4,28,4),(33,'TP1059',NULL,'SapphireGlide','C2',2,5,20,5),(34,'TP1061',NULL,'AmethystWing','D1',3,4,32,10),(35,'TP1063',NULL,'OpalSky','D3',4,1,32,12),(36,'TP1065',NULL,'PeridotFlight','C2',5,2,8,17),(37,'TP1067',NULL,'QuartzSprint','B3',1,5,32,3),(38,'TP1069',NULL,'MarbleAce','B2',2,3,32,4),(39,'TP1071',NULL,'SlateHawk','D1',3,1,32,5),(40,'TP1073',NULL,'CanyonRunner','B2',4,2,32,10),(41,'TP1075',NULL,'DeltaGlide','A3',5,3,24,12),(42,'TP1077',NULL,'ZetaWing','B3',1,4,28,17),(43,'TP1079',NULL,'ThetaStar','A1',2,1,8,3),(44,'TP1081',NULL,'KappaAir','A2',3,5,4,4),(45,'TP1083',NULL,'MuWing','C3',4,3,24,5),(46,'TP1085',NULL,'XiGlide','C2',5,1,24,10),(47,'TP1087',NULL,'PiAce','D3',1,2,24,12),(48,'TP1089',NULL,'SigmaFlight','B2',2,4,24,17),(49,'TP1091',NULL,'UpsilonJet','D2',3,1,20,3),(50,'TP1093',NULL,'ChiHawk','C3',4,2,16,4),(51,'TP1095',NULL,'OmegaAce','D1',5,3,16,5);
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flightclass`
--

DROP TABLE IF EXISTS `flightclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flightclass` (
  `classID` int NOT NULL AUTO_INCREMENT,
  `className` varchar(255) NOT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`classID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flightclass`
--

LOCK TABLES `flightclass` WRITE;
/*!40000 ALTER TABLE `flightclass` DISABLE KEYS */;
INSERT INTO `flightclass` VALUES (1,'Economy',100),(2,'First Class',200),(3,'Goat Class',10000);
/*!40000 ALTER TABLE `flightclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hanger`
--

DROP TABLE IF EXISTS `hanger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hanger` (
  `hangerID` int NOT NULL AUTO_INCREMENT,
  `ICAO` varchar(4) DEFAULT NULL,
  `planeStatus` enum('In use','Available') NOT NULL DEFAULT (_utf8mb4'Available'),
  PRIMARY KEY (`hangerID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hanger`
--

LOCK TABLES `hanger` WRITE;
/*!40000 ALTER TABLE `hanger` DISABLE KEYS */;
INSERT INTO `hanger` VALUES (1,'A676','In use'),(2,'B212','In use'),(3,'C909','In use'),(4,'D404','In use'),(5,'E777','In use'),(6,'F101','In use');
/*!40000 ALTER TABLE `hanger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `itemID` int NOT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `fk_inventory_item` FOREIGN KEY (`itemID`) REFERENCES `item` (`itemID`) ON DELETE CASCADE,
  CONSTRAINT `inventory_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,10),(2,25),(3,3),(4,2),(5,1),(6,18),(7,12);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `inventorynames`
--

DROP TABLE IF EXISTS `inventorynames`;
/*!50001 DROP VIEW IF EXISTS `inventorynames`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `inventorynames` AS SELECT 
 1 AS `itemID`,
 1 AS `quantity`,
 1 AS `isAvailable`,
 1 AS `type`,
 1 AS `itemName`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `itemID` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(255) NOT NULL,
  `itemDescription` text,
  `type` enum('equipment','transportation','misc') NOT NULL,
  PRIMARY KEY (`itemID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.','equipment'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.','equipment'),(3,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.','equipment'),(4,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.','transportation'),(5,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.','transportation'),(6,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.','misc'),(7,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.','misc');
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `miscellaneousitem`
--

DROP TABLE IF EXISTS `miscellaneousitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `miscellaneousitem` (
  `itemID` int NOT NULL,
  `itemName` varchar(255) DEFAULT NULL,
  `itemDescription` text,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `fk_miscellaneous_item` FOREIGN KEY (`itemID`) REFERENCES `item` (`itemID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `miscellaneousitem`
--

LOCK TABLES `miscellaneousitem` WRITE;
/*!40000 ALTER TABLE `miscellaneousitem` DISABLE KEYS */;
INSERT INTO `miscellaneousitem` VALUES (6,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.'),(7,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.');
/*!40000 ALTER TABLE `miscellaneousitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parkinglot`
--

DROP TABLE IF EXISTS `parkinglot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parkinglot` (
  `lot` char(1) NOT NULL,
  `lotSpace` int DEFAULT NULL,
  PRIMARY KEY (`lot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parkinglot`
--

LOCK TABLES `parkinglot` WRITE;
/*!40000 ALTER TABLE `parkinglot` DISABLE KEYS */;
INSERT INTO `parkinglot` VALUES ('A',100),('B',120),('C',80),('D',60),('E',150),('F',90);
/*!40000 ALTER TABLE `parkinglot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `pilotscheduleinfo`
--

DROP TABLE IF EXISTS `pilotscheduleinfo`;
/*!50001 DROP VIEW IF EXISTS `pilotscheduleinfo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pilotscheduleinfo` AS SELECT 
 1 AS `fname`,
 1 AS `lname`,
 1 AS `staffID`,
 1 AS `flight`,
 1 AS `liftOff`,
 1 AS `landing`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `plane`
--

DROP TABLE IF EXISTS `plane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plane` (
  `ICAO` varchar(4) NOT NULL,
  PRIMARY KEY (`ICAO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plane`
--

LOCK TABLES `plane` WRITE;
/*!40000 ALTER TABLE `plane` DISABLE KEYS */;
INSERT INTO `plane` VALUES ('A676'),('B212'),('C909'),('D404'),('E777'),('F101');
/*!40000 ALTER TABLE `plane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planeseat`
--

DROP TABLE IF EXISTS `planeseat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planeseat` (
  `seatNumber` varchar(3) NOT NULL,
  `scheduleID` int NOT NULL,
  `classID` int DEFAULT NULL,
  PRIMARY KEY (`seatNumber`,`scheduleID`),
  KEY `fk_planeseat_schedule` (`scheduleID`),
  KEY `fk_class_id` (`classID`),
  CONSTRAINT `fk_class_id` FOREIGN KEY (`classID`) REFERENCES `flightclass` (`classID`),
  CONSTRAINT `fk_planeseat_schedule` FOREIGN KEY (`scheduleID`) REFERENCES `schedule` (`scheduleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planeseat`
--

LOCK TABLES `planeseat` WRITE;
/*!40000 ALTER TABLE `planeseat` DISABLE KEYS */;
INSERT INTO `planeseat` VALUES ('101',1,1),('103',2,1),('105',3,1),('107',4,1),('109',5,1),('111',6,1),('102',1,2),('104',2,2),('108',4,2),('110',5,2),('106',3,3),('112',6,3);
/*!40000 ALTER TABLE `planeseat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `planestatus`
--

DROP TABLE IF EXISTS `planestatus`;
/*!50001 DROP VIEW IF EXISTS `planestatus`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `planestatus` AS SELECT 
 1 AS `ICAO`,
 1 AS `planeStatus`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `positionenums`
--

DROP TABLE IF EXISTS `positionenums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `positionenums` (
  `positionID` int NOT NULL AUTO_INCREMENT,
  `position` enum('Flight Attendent','Pilot','Co-Pilot','Security','Unassigned') DEFAULT 'Unassigned',
  PRIMARY KEY (`positionID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positionenums`
--

LOCK TABLES `positionenums` WRITE;
/*!40000 ALTER TABLE `positionenums` DISABLE KEYS */;
INSERT INTO `positionenums` VALUES (1,'Flight Attendent'),(2,'Pilot'),(3,'Co-Pilot'),(4,'Security'),(5,'Unassigned');
/*!40000 ALTER TABLE `positionenums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `regionID` int NOT NULL,
  `region` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`regionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,'Texas'),(2,'Colorado'),(3,'Illinois'),(4,'Arizona'),(5,'Georgia');
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `reservationticket`
--

DROP TABLE IF EXISTS `reservationticket`;
/*!50001 DROP VIEW IF EXISTS `reservationticket`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reservationticket` AS SELECT 
 1 AS `bookingNumber`,
 1 AS `userID`,
 1 AS `reservationDate`,
 1 AS `departSeatNumber`,
 1 AS `returnSeatNumber`,
 1 AS `departDate`,
 1 AS `returnDate`,
 1 AS `departScheduleID`,
 1 AS `returnScheduleID`,
 1 AS `username`,
 1 AS `departLiftOffDate`,
 1 AS `departArrivingDate`,
 1 AS `departFlightID`,
 1 AS `departFlight`,
 1 AS `departOrigin`,
 1 AS `departDestination`,
 1 AS `returnLiftOffDate`,
 1 AS `returnArrivingDate`,
 1 AS `returnFlightID`,
 1 AS `returnFlight`,
 1 AS `returnOrigin`,
 1 AS `returnDestination`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `scheduleID` int NOT NULL AUTO_INCREMENT,
  `flightID` varchar(7) DEFAULT NULL,
  `liftOff` time DEFAULT NULL,
  `landing` time DEFAULT NULL,
  `status` enum('On Time','Delayed','Boarding','Taxiing','Airborne','Landing','Grounded') DEFAULT NULL,
  PRIMARY KEY (`scheduleID`),
  KEY `fk_schedule_flight` (`flightID`),
  CONSTRAINT `fk_schedule_flight` FOREIGN KEY (`flightID`) REFERENCES `flight` (`IATA`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,'TP1001','10:06:07','12:00:00','Grounded'),(2,'TP1002','13:30:00','15:05:00','Grounded'),(3,'TP1003','09:15:00','10:25:00','Grounded'),(4,'TP1004','16:40:00','18:10:00','Grounded'),(5,'TP1005','07:00:00','09:55:00','Grounded'),(6,'TP1006','19:20:00','22:35:00','Airborne');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staffID` int NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `positionID` int DEFAULT '5',
  PRIMARY KEY (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (2,'mariavalentine@gmail.com',1),(3,'kaicairo@gmail.com',2),(4,'richardwalker@gmail.com',2),(5,'erinchoi@gmail.com',2),(9,'bongogigglefart@gmail.com',1),(10,'crunchgiggler@gmail.com',2),(11,'toastergiggleblast@gmail.com',5),(12,'toegigglesnort@gmail.com',2),(17,'rexgigglefart@gmail.com',2),(18,'nadiagiggler@gmail.com',2),(19,'coltgiggleblast@gmail.com',2),(20,'inezgigglesnort@gmail.com',2);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `staffcountperposition`
--

DROP TABLE IF EXISTS `staffcountperposition`;
/*!50001 DROP VIEW IF EXISTS `staffcountperposition`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `staffcountperposition` AS SELECT 
 1 AS `position`,
 1 AS `positionCount`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `transportation`
--

DROP TABLE IF EXISTS `transportation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transportation` (
  `itemID` int NOT NULL,
  `transportName` varchar(255) DEFAULT NULL,
  `transportDescription` text,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `fk_transportation_item` FOREIGN KEY (`itemID`) REFERENCES `item` (`itemID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transportation`
--

LOCK TABLES `transportation` WRITE;
/*!40000 ALTER TABLE `transportation` DISABLE KEYS */;
INSERT INTO `transportation` VALUES (4,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.'),(5,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.');
/*!40000 ALTER TABLE `transportation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `userreservationsummary`
--

DROP TABLE IF EXISTS `userreservationsummary`;
/*!50001 DROP VIEW IF EXISTS `userreservationsummary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `userreservationsummary` AS SELECT 
 1 AS `userID`,
 1 AS `email`,
 1 AS `username`,
 1 AS `registerLengthDays`,
 1 AS `totalReservations`,
 1 AS `totalPastReservations`,
 1 AS `totalFutureReservations`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `phoneNumber` char(10) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `isStaff` tinyint(1) DEFAULT '0',
  `profilePicture` text,
  `bio` text,
  `registeredDate` datetime DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'5127997308','Alan','Gascon','McTails','alangascon@gmail.com','3d45597256050bb1e93bd9c10aee4c8716f8774f5a48c995bf0cf860',0,NULL,NULL,'2026-03-01 09:00:00'),(2,'5123005252','Maria','Valentine','ValesMom','mariavalentine@gmail.com','8e012a7c9d83ad6d0a8c4623bccf2f208985d847cf8de8257111037e',1,NULL,NULL,'2026-03-01 09:15:00'),(3,'5125550101','Kai','Cairo','kcfrost','kaicairo@gmail.com','e04c3fcc21706ccaf4dac43d0e2530de2b5075963b50d6fc71b75306',1,NULL,NULL,'2026-03-01 09:30:00'),(4,'5125550102','Richard','Walker','rich93147','richardwalker@gmail.com','b9b3bbe5850b2e006260ce9e7575af2135381fc2387d141adbae4ed9',1,NULL,NULL,'2026-03-01 09:45:00'),(5,'5125550103','Erin','Choi','ErinCo','erinchoi@gmail.com','6c09ee70bba90aa92e604850300911d13ec0f793f142f1d751436a28',1,NULL,NULL,'2026-03-01 10:00:00'),(6,'5125550104','Omar','Singh','OmarSec','omarsingh@gmail.com','9da84c9b32f7ed60b153942887bee79fd607c02761697cf3da75c467',0,NULL,NULL,'2026-03-01 10:15:00'),(7,'5125550105','Tess','Nguyen','TessFA','tessnguyen@gmail.com','abf520e115e79883efd11fc1c2ecb835f84aedebbcae9243a59a51de',0,NULL,NULL,'2026-03-01 10:30:00'),(8,'5125550106','Luis','Martinez','LuisOps','luismartinez@gmail.com','37cd094b9932c2b6145a891f070fc3d0529643c7fd0945e80290c7db',0,NULL,NULL,'2026-03-01 10:45:00'),(9,'5125550201','Bongo','Gigglefart','bongojet','bongogigglefart@gmail.com','e3264e3441f7771da59005bc31b21e28976df50536942aae6780c9e1',1,NULL,NULL,'2026-03-01 11:00:00'),(10,'5125550202','Crunch','Giggler','crunchpilot','crunchgiggler@gmail.com','1113d702884878bbbc5f4102973be7e8fca7a73643a653f1c0094aa9',1,NULL,NULL,'2026-03-01 11:15:00'),(11,'5125550203','Toaster','Giggleblast','toastgob','toastergiggleblast@gmail.com','89b1a7ff725054065f3f0b17c6bbe0d1021ef36ae9561add61241064',1,NULL,NULL,'2026-03-01 11:30:00'),(12,'5125550204','Toe','Gigglesnort','toeLiker','toegigglesnort@gmail.com','5d85e39972dda93ad56a7c4697c25e52c481667d42ec3da1831a8323',1,NULL,NULL,'2026-03-01 11:45:00'),(13,'5125550205','Soggy','Gigglenoodle','sogwaff','soggygigglenoodle@gmail.com','1ea30687f3f2b94bbb7ec553c4b9d6fd0c0c0accffda7e6ce70d0ae4',0,NULL,NULL,'2026-03-01 12:00:00'),(14,'5125550206','Grease','Gigglechunk','greasemc','greasegigglechunk@gmail.com','eb4b19792f4aeb780bc5a0f98d31e510b3479d7c0e566a330d4fec49',0,NULL,NULL,'2026-03-01 12:15:00'),(15,'5125550207','Wiggles','Gigglepants','wigglefunk','wigglesgigglepants@gmail.com','f6890f6e78029659e9f65d1c41faccba06b96c8818e2553e0fa7f425',0,NULL,NULL,'2026-03-01 12:30:00'),(16,'5125550208','Cheddar','Gigglecheese','chedblast','cheddargigglecheese@gmail.com','6c95d9fba357468220b1305a5593e78da8eabecbf5039fb9214b06aa',0,NULL,NULL,'2026-03-01 12:45:00'),(17,'5125551000','Rex','Gigglefart','rexhar','rexgigglefart@gmail.com','915ff5a2d51fe69d6c948bb6b2a77835b29c30dc00aad8e2c8a372e9',1,NULL,NULL,'2026-03-15 08:00:00'),(18,'5125551001','Nadia','Giggler','nadiavos','nadiagiggler@gmail.com','2045d6530c48dadf94cf7ffc785cede6b680b602f376ac483e402253',1,NULL,NULL,'2026-03-15 08:00:00'),(19,'5125551002','Colt','Giggleblast','coltbla','coltgiggleblast@gmail.com','adac97622b6281379ce628e0f4d4c31c482a1c4074c5ac1b2c413c7e',1,NULL,NULL,'2026-03-15 08:00:00'),(20,'5125551003','Inez','Gigglesnort','inezfer','inezgigglesnort@gmail.com','93d83c88cd84efbebf28f15f185ab4c909e75bf52560740bf3f8423d',1,NULL,NULL,'2026-03-15 08:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `inventorynames`
--

/*!50001 DROP VIEW IF EXISTS `inventorynames`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `inventorynames` AS select `i`.`itemID` AS `itemID`,`i`.`quantity` AS `quantity`,(`i`.`quantity` > 0) AS `isAvailable`,`it`.`type` AS `type`,`it`.`itemName` AS `itemName` from (`inventory` `i` join `item` `it` on((`it`.`itemID` = `i`.`itemID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pilotscheduleinfo`
--

/*!50001 DROP VIEW IF EXISTS `pilotscheduleinfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pilotscheduleinfo` AS select `u`.`fname` AS `fname`,`u`.`lname` AS `lname`,`s`.`staffID` AS `staffID`,`f`.`IATA` AS `flight`,`sc`.`liftOff` AS `liftOff`,`sc`.`landing` AS `landing`,`sc`.`status` AS `status` from (((`staff` `s` join `users` `u` on((`u`.`userID` = `s`.`staffID`))) join `flight` `f` on((`f`.`assignedPilot` = `s`.`staffID`))) join `schedule` `sc` on((`sc`.`flightID` = `f`.`IATA`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `planestatus`
--

/*!50001 DROP VIEW IF EXISTS `planestatus`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `planestatus` AS select `h`.`ICAO` AS `ICAO`,`h`.`planeStatus` AS `planeStatus` from `hanger` `h` where `h`.`ICAO` in (select `plane`.`ICAO` from `plane`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `reservationticket`
--

/*!50001 DROP VIEW IF EXISTS `reservationticket`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `reservationticket` AS select `b`.`bookingNumber` AS `bookingNumber`,`b`.`userID` AS `userID`,`b`.`bookingDate` AS `reservationDate`,`b`.`departSeat` AS `departSeatNumber`,`b`.`returnSeat` AS `returnSeatNumber`,`b`.`departDate` AS `departDate`,`b`.`returnDate` AS `returnDate`,`b`.`departSchedule` AS `departScheduleID`,`b`.`returnSchedule` AS `returnScheduleID`,`u`.`username` AS `username`,`ds`.`liftOff` AS `departLiftOffDate`,`ds`.`landing` AS `departArrivingDate`,`df`.`flightID` AS `departFlightID`,`df`.`IATA` AS `departFlight`,`df`.`origin` AS `departOrigin`,`df`.`destination` AS `departDestination`,`rs`.`liftOff` AS `returnLiftOffDate`,`rs`.`landing` AS `returnArrivingDate`,`rf`.`flightID` AS `returnFlightID`,`rf`.`IATA` AS `returnFlight`,`rf`.`origin` AS `returnOrigin`,`rf`.`destination` AS `returnDestination` from (((((`booking` `b` left join `users` `u` on((`b`.`userID` = `u`.`userID`))) left join `schedule` `ds` on((`ds`.`scheduleID` = `b`.`departSchedule`))) left join `flight` `df` on((`df`.`IATA` = `ds`.`flightID`))) left join `schedule` `rs` on((`rs`.`scheduleID` = `b`.`returnSchedule`))) left join `flight` `rf` on((`rf`.`IATA` = `rs`.`flightID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `staffcountperposition`
--

/*!50001 DROP VIEW IF EXISTS `staffcountperposition`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `staffcountperposition` AS select `pe`.`position` AS `position`,count(`s`.`staffID`) AS `positionCount` from (`positionenums` `pe` left join `staff` `s` on((`pe`.`positionID` = `s`.`positionID`))) group by `pe`.`positionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `userreservationsummary`
--

/*!50001 DROP VIEW IF EXISTS `userreservationsummary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `userreservationsummary` AS select `u`.`userID` AS `userID`,`u`.`email` AS `email`,`u`.`username` AS `username`,(to_days(curdate()) - to_days(cast(`u`.`registeredDate` as date))) AS `registerLengthDays`,count(`b`.`bookingNumber`) AS `totalReservations`,sum((case when ((`ds`.`liftOff` < now()) and ((`rs`.`liftOff` is null) or (`rs`.`liftOff` < now()))) then 1 else 0 end)) AS `totalPastReservations`,sum((case when ((`ds`.`liftOff` >= now()) or ((`rs`.`liftOff` is not null) and (`rs`.`liftOff` >= now()))) then 1 else 0 end)) AS `totalFutureReservations` from (((`users` `u` left join `booking` `b` on((`u`.`userID` = `b`.`userID`))) left join `schedule` `ds` on((`b`.`departSchedule` = `ds`.`scheduleID`))) left join `schedule` `rs` on((`b`.`returnSchedule` = `rs`.`scheduleID`))) group by `u`.`userID`,`u`.`email`,`u`.`username`,`u`.`registeredDate` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-31 19:24:23
