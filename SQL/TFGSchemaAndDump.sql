use tfg;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES (1,1,'Austin, TX','Austin-Bergstrom Intl','AUS'),(2,1,'New York, NYC','John F Kennedy Intl','JFK'),(3,1,'San Francisco, CA','San Francisco Intl','SFO'),(4,2,'São Paulo, Brazil','Guarulhos Intl','GRU'),(5,2,'Buenos Aires, Argentina','Ministro Pistarini Intl','EZE'),(6,2,'Bogotá, Colombia','El Dorado Intl','BOG'),(7,3,'Tokyo, Japan','Haneda Intl','HND'),(8,3,'Dubai, UAE','Dubai Intl','DXB'),(9,3,'Singapore, Singapore','Changi Intl','SIN'),(10,4,'London, UK','Heathrow Intl','LHR'),(11,4,'Paris, France','Charles de Gaulle Intl','CDG'),(12,4,'Frankfurt, Germany','Frankfurt am Main Intl','FRA'),(13,5,'Johannesburg, South Africa','O.R. Tambo Intl','JNB'),(14,5,'Cairo, Egypt','Cairo Intl','CAI'),(15,5,'Nairobi, Kenya','Jomo Kenyatta Intl','NBO');
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `available_flights`
--

DROP TABLE IF EXISTS `available_flights`;
/*!50001 DROP VIEW IF EXISTS `available_flights`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `available_flights` AS SELECT 
 1 AS `scheduleID`,
 1 AS `origin_IATA`,
 1 AS `destination_IATA`,
 1 AS `IATA`,
 1 AS `capacity`,
 1 AS `liftOff`,
 1 AS `landing`,
 1 AS `duration`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (2,'2026-04-02 01:13:29',3,'1B','2A','2026-04-01',1,'2026-04-02',11);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validReservationChange` BEFORE UPDATE ON `booking` FOR EACH ROW BEGIN
    IF NEW.departDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "Cannot edit a reservation for a past flight";
    END IF;

    IF EXISTS (
        SELECT 1
        FROM booking b
        WHERE b.bookingNumber <> OLD.bookingNumber
        AND ((b.departSchedule = NEW.departSchedule AND b.departSeat = NEW.departSeat)
        OR (b.returnSchedule = NEW.returnSchedule AND b.returnSeat = NEW.returnSeat))
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This seat is already taken";
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rememberBookingBeforeDelete` BEFORE DELETE ON `booking` FOR EACH ROW BEGIN
    INSERT INTO bookinghistory(
        bookingNumber, userID, departFlightID, returnFlightID,
        departSeat, returnSeat, departDate, returnDate,
        bookingDate, bookingStatus, assignedPilot
    )
    SELECT
        old.bookingNumber, old.userID,
        ds.flightID, rs.flightID,
        old.departSeat, old.returnSeat,
        old.departDate, old.returnDate,
        old.bookingDate, 'Cancelled',
        df.assignedPilot
    FROM schedule ds
    JOIN flight df ON df.IATA = ds.flightID
    JOIN schedule rs ON rs.scheduleID = old.returnSchedule
    WHERE ds.scheduleID = old.departSchedule;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bookinghistory`
--

DROP TABLE IF EXISTS `bookinghistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookinghistory` (
  `bookingNumber` int NOT NULL,
  `userID` int DEFAULT NULL,
  `departFlightID` varchar(7) DEFAULT NULL,
  `returnFlightID` varchar(7) DEFAULT NULL,
  `departSeat` varchar(3) DEFAULT NULL,
  `returnSeat` varchar(3) DEFAULT NULL,
  `departDate` date DEFAULT NULL,
  `returnDate` date DEFAULT NULL,
  `departFlightID` varchar(7) DEFAULT NULL,
  `returnFlightID` varchar(7) DEFAULT NULL,
  `departSeat` varchar(3) DEFAULT NULL,
  `returnSeat` varchar(3) DEFAULT NULL,
  `departDate` date DEFAULT NULL,
  `returnDate` date DEFAULT NULL,
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
  `IATA` varchar(7) NOT NULL,
  `ICAO` varchar(4) DEFAULT NULL,
  `planeName` varchar(255) DEFAULT NULL,
  `gate` varchar(2) DEFAULT NULL,
  `origin` int DEFAULT NULL,
  `destination` int DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `assignedPilot` int DEFAULT NULL,
  PRIMARY KEY (`IATA`),
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES ('TP1001','A676','Goated67Plane','A1',1,2,20,3),('TP1002','B212','SkyRam900','A2',1,3,24,3),('TP1003','C909','HornetJet11','B1',1,4,16,4),('TP1004','D404','Nimbus220','B2',1,5,20,5),('TP1005','E777','CrownCruiser','C1',1,6,24,10),('TP1006','F101','AtlasSprint','C2',1,7,28,12),('TP1007','G303','GoatedFlight','A1',1,2,20,3),('TP1009','H404','GoatPlane','D3',1,3,24,4),('TP1011','I505','StormRider','C3',1,4,16,5),('TP1013','J606','NovaStar','A1',2,3,4,10),('TP1015','K707','ArcticBreeze','D1',2,1,20,12),('TP1017','L808','CoastalAce','B2',2,5,8,17),('TP1019','M909','ApexGlider','A3',3,1,12,3),('TP1021','N010','MidnightRun','B3',3,2,28,4),('TP1023','O111','CloudPiercer','B2',3,4,16,5),('TP1025','P212','EclipseJet','B2',4,1,28,10),('TP1027','Q313','SwiftArrow','A1',4,2,28,12),('TP1029','R414','CycloneX','B3',4,5,32,17),('TP1031','S515','TwilightAce','C2',5,3,32,3),('TP1033','T616','SkyLancer','A2',5,1,16,4),('TP1035','U717','NorthStar','C3',5,4,16,5),('TP1037','V818','TurboCondor','A1',6,3,12,10),('TP1039','W919','HighRoller','B1',6,5,32,12),('TP1041','X020','MachRacer','D3',7,4,8,17),('TP1043','Y121','CobaltJet','D2',7,8,8,3),('TP1045','Z222','HorizonX','C1',8,9,20,4),('TP1047','AA23','AltitudePro','A3',9,1,4,5),('TP1049','AB24','BlackKite','B1',10,3,28,10),('TP1051','AC25','MercuryWing','A1',10,2,12,12),('TP1053','AD26','CrimsonAce','D3',11,3,28,17),('TP1055','AE27','BronzeArrow','B3',11,1,28,3),('TP1057','AF28','DiamondAir','D2',12,4,28,4),('TP1059','AG29','SapphireGlide','C2',12,5,20,5),('TP1061','AH30','AmethystWing','D1',13,4,32,10),('TP1063','AI31','OpalSky','D3',13,1,32,12),('TP1065','AJ32','PeridotFlight','C2',14,2,8,17),('TP1067','AK33','QuartzSprint','B3',14,5,32,3),('TP1069','AL34','MarbleAce','B2',15,3,32,4),('TP1071','AM35','SlateHawk','D1',15,1,32,5),('TP1073','AN36','CanyonRunner','B2',1,2,32,10),('TP1075','AO37','DeltaGlide','A3',2,3,24,12),('TP1077','AP38','ZetaWing','B3',3,4,28,17),('TP1079','AQ39','ThetaStar','A1',4,1,8,3),('TP1081','AR40','KappaAir','A2',5,9,4,4),('TP1083','AS41','MuWing','C3',6,3,24,5),('TP1085','AT42','XiGlide','C2',7,1,24,10),('TP1087','AU43','PiAce','D3',8,2,24,12),('TP1089','AV44','SigmaFlight','B2',9,4,24,17),('TP1091','AW45','UpsilonJet','D2',10,1,20,3),('TP1093','AX46','ChiHawk','C3',11,2,16,4),('TP1095','AY47','OmegaAce','D1',12,3,16,5);
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `enforceAvailablePilot` BEFORE INSERT ON `flight` FOR EACH ROW BEGIN
    IF new.assignedPilot IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A flight must have an assigned pilot";
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM staff s
        JOIN positionenums p ON p.positionID = s.positionID
        WHERE s.staffID = new.assignedPilot
          AND p.position = "Pilot"
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET message_text = "The staff attempting to take control of the plane is NOT a pilot";
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updatePlaneAvailability` AFTER INSERT ON `flight` FOR EACH ROW UPDATE hanger h SET planeStatus = "In use" WHERE new.ICAO = h.ICAO */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rememberBookingsBeforeClearProcedureCall` BEFORE UPDATE ON `flight` FOR EACH ROW BEGIN
    IF old.assignedPilot IS NOT NULL
       AND new.assignedPilot IS NULL
       AND NOT EXISTS (
            SELECT 1 FROM bookinghistory WHERE departFlightID = old.IATA
       )
    THEN
        INSERT INTO bookinghistory (
            bookingNumber, userID, departFlightID, returnFlightID,
            departSeat, returnSeat, departDate, returnDate,
            bookingDate, assignedPilot, bookingStatus
        )
        SELECT
            b.bookingNumber, b.userID,
            ds.flightID, rs.flightID,
            b.departSeat, b.returnSeat,
            b.departDate, b.returnDate,
            b.bookingDate, old.assignedPilot,
            IF(ds.landing IS NOT NULL AND now() >= ds.landing, 'Completed', 'Cancelled')
        FROM booking b
        JOIN schedule ds ON ds.scheduleID = b.departSchedule
        JOIN schedule rs ON rs.scheduleID = b.returnSchedule
        WHERE ds.flightID = old.IATA;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hanger`
--

LOCK TABLES `hanger` WRITE;
/*!40000 ALTER TABLE `hanger` DISABLE KEYS */;
INSERT INTO `hanger` VALUES (1,'A676','In use'),(2,'B212','In use'),(3,'C909','In use'),(4,'D404','In use'),(5,'E777','In use'),(6,'F101','In use'),(7,'H404','In use'),(8,'I505','In use'),(9,'J606','In use'),(10,'K707','In use'),(11,'L808','In use'),(12,'M909','In use'),(13,'O111','In use'),(14,'P212','In use'),(15,'N010','In use'),(16,'Q313','In use'),(17,'R414','In use'),(18,'S515','In use'),(19,'U717','In use'),(20,'V818','In use'),(21,'W919','In use'),(22,'X020','In use'),(23,'Y121','In use'),(24,'T616','In use'),(25,'AA23','In use'),(26,'AB24','In use'),(27,'AC25','In use'),(28,'AD26','In use'),(29,'AE27','In use'),(30,'G303','In use'),(31,'AF28','In use'),(32,'AG29','In use'),(33,'AH30','In use'),(34,'AI31','In use'),(35,'AJ32','In use'),(36,'AK33','In use'),(37,'AP38','In use'),(38,'AQ39','In use'),(39,'AR40','In use'),(40,'AS41','In use'),(41,'AT42','In use'),(42,'AL34','In use'),(43,'AU43','In use'),(44,'AV44','In use'),(45,'AW45','In use'),(46,'AX46','In use'),(47,'AY47','In use'),(48,'AM35','In use'),(49,'AN36','In use'),(50,'AO37','In use'),(51,'Z222','In use'),(52,'Y676','Available');
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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `transportandequipmentinsert` AFTER INSERT ON `item` FOR EACH ROW BEGIN
    IF (new.type = "equipment") THEN
        INSERT INTO equipment(itemID, equipmentName, equipmentDescription) VALUES 
        (new.itemID, new.itemName, new.itemDescription);
    ELSEIF (new.type = "transportation") THEN 
        INSERT INTO transportation(itemID, transportName, transportDescription) VALUES
        (new.itemID, new.itemName, new.itemDescription);
    ELSEIF (new.type = "misc") THEN
        INSERT INTO miscellaneousitem(itemID, itemName, itemDescription) VALUES
        (new.itemID, new.itemName, new.itemDescription);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
INSERT INTO `plane` VALUES ('A676'),('AA23'),('AB24'),('AC25'),('AD26'),('AE27'),('AF28'),('AG29'),('AH30'),('AI31'),('AJ32'),('AK33'),('AL34'),('AM35'),('AN36'),('AO37'),('AP38'),('AQ39'),('AR40'),('AS41'),('AT42'),('AU43'),('AV44'),('AW45'),('AX46'),('AY47'),('B212'),('C909'),('D404'),('E777'),('F101'),('G303'),('H404'),('I505'),('J606'),('K707'),('L808'),('M909'),('N010'),('O111'),('P212'),('Q313'),('R414'),('S515'),('T616'),('U717'),('V818'),('W919'),('X020'),('Y121'),('Y676'),('Z222');
/*!40000 ALTER TABLE `plane` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `storePlaneInHanger` AFTER INSERT ON `plane` FOR EACH ROW INSERT INTO hanger(ICAO, planestatus) VALUES (new.ICAO, "Available") */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `editingPlaneInUse` BEFORE UPDATE ON `plane` FOR EACH ROW BEGIN
    IF old.ICAO <> new.ICAO THEN
        IF EXISTS (SELECT 1 FROM flight f WHERE f.ICAO = old.ICAO) THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = 'This plane is in use, editing the name is probably not the right call right now.';
        END IF;

        IF EXISTS (SELECT 1 FROM plane p WHERE p.ICAO = new.ICAO) THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = 'That ICAO already exists in the system.';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
INSERT INTO `planeseat` VALUES ('1A',1,1),('1B',1,1),('1B',11,1),('2A',11,1);
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
-- Table structure for table `planestatusenums`
--

DROP TABLE IF EXISTS `planestatusenums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planestatusenums` (
  `psEnumID` int NOT NULL,
  `status` enum('On Time','Delayed','Boarding','Taxiing','Airborne','Landing','Grounded') DEFAULT NULL,
  `ICAO` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`psEnumID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planestatusenums`
--

LOCK TABLES `planestatusenums` WRITE;
/*!40000 ALTER TABLE `planestatusenums` DISABLE KEYS */;
INSERT INTO `planestatusenums` VALUES (1,'On Time',NULL),(2,'Delayed',NULL),(3,'Boarding',NULL),(4,'Taxiing',NULL),(5,'Airborne',NULL),(6,'Landing',NULL),(7,'Grounded',NULL);
/*!40000 ALTER TABLE `planestatusenums` ENABLE KEYS */;
UNLOCK TABLES;

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
 1 AS `departFlight`,
 1 AS `departOrigin`,
 1 AS `departDestination`,
 1 AS `returnLiftOffDate`,
 1 AS `returnArrivingDate`,
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,'TP1001','10:06:07','12:00:00','Grounded'),(2,'TP1002','13:30:00','15:05:00','Grounded'),(3,'TP1003','09:15:00','10:25:00','Grounded'),(4,'TP1004','16:40:00','18:10:00','Grounded'),(5,'TP1005','07:00:00','09:55:00','Grounded'),(6,'TP1006','19:20:00','22:35:00','Airborne'),(7,'TP1007','08:00:00','10:10:00','Grounded'),(8,'TP1009','11:15:00','13:05:00','Grounded'),(9,'TP1011','14:20:00','16:00:00','Grounded'),(10,'TP1013','06:45:00','08:00:00','Grounded'),(11,'TP1015','17:30:00','19:10:00','Grounded'),(12,'TP1017','12:10:00','13:30:00','Grounded'),(13,'TP1019','09:50:00','11:20:00','Grounded'),(14,'TP1021','15:00:00','17:40:00','Grounded'),(15,'TP1023','18:10:00','19:45:00','Grounded'),(16,'TP1025','07:30:00','10:00:00','Grounded'),(17,'TP1027','13:00:00','15:20:00','Grounded'),(18,'TP1029','16:00:00','18:30:00','Grounded'),(19,'TP1031','10:30:00','13:00:00','Grounded'),(20,'TP1033','08:20:00','10:00:00','Grounded'),(21,'TP1035','19:00:00','20:30:00','Grounded'),(22,'TP1037','06:30:00','08:00:00','Grounded'),(23,'TP1039','11:40:00','14:20:00','Grounded'),(24,'TP1041','14:10:00','15:20:00','Grounded'),(25,'TP1043','09:00:00','10:30:00','Grounded'),(26,'TP1045','12:30:00','14:50:00','Grounded'),(27,'TP1047','17:10:00','18:00:00','Grounded'),(28,'TP1049','15:30:00','18:10:00','Grounded'),(29,'TP1051','07:50:00','09:10:00','Grounded'),(30,'TP1053','13:40:00','16:20:00','Grounded'),(31,'TP1055','10:10:00','12:40:00','Grounded'),(32,'TP1057','18:20:00','20:50:00','Grounded'),(33,'TP1059','11:00:00','13:10:00','Grounded'),(34,'TP1061','14:50:00','17:30:00','Grounded'),(35,'TP1063','16:30:00','19:10:00','Grounded'),(36,'TP1065','08:40:00','10:00:00','Grounded'),(37,'TP1067','12:20:00','15:00:00','Grounded'),(38,'TP1069','09:30:00','12:10:00','Grounded'),(39,'TP1071','13:10:00','15:50:00','Grounded'),(40,'TP1073','07:10:00','09:40:00','Grounded'),(41,'TP1075','11:50:00','14:00:00','Grounded'),(42,'TP1077','15:20:00','18:00:00','Grounded'),(43,'TP1079','06:00:00','07:10:00','Grounded'),(44,'TP1081','17:50:00','18:40:00','Grounded'),(45,'TP1083','10:50:00','13:10:00','Grounded'),(46,'TP1085','08:10:00','10:30:00','Grounded'),(47,'TP1087','14:00:00','16:20:00','Grounded'),(48,'TP1089','16:10:00','18:30:00','Grounded'),(49,'TP1091','07:40:00','09:30:00','Grounded'),(50,'TP1093','12:00:00','13:40:00','Grounded'),(51,'TP1095','18:40:00','20:10:00','Grounded');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validFlightInsertPrevention` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1
        FROM flight f
        JOIN schedule s ON f.IATA = s.flightID
        WHERE f.assignedPilot = (
            SELECT assignedPilot FROM flight WHERE IATA = new.flightID
        )
        AND f.IATA <> new.flightID
        AND new.liftOff < s.landing
        AND new.landing > s.liftOff
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = 'Pilot is already assigned to another active flight during that time.';
    END IF;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `setScheduleStatusBeforeInsert` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
    IF now() < date_sub(new.liftOff, INTERVAL 1 HOUR) THEN
        SET new.status = 'Grounded';
    ELSEIF now() >= date_sub(new.liftOff, INTERVAL 1 HOUR)
       AND now() < date_sub(new.liftOff, INTERVAL 30 MINUTE) THEN
        SET new.status = 'On Time';
    ELSEIF now() >= date_sub(new.liftOff, INTERVAL 30 MINUTE)
       AND now() < new.liftOff THEN
        SET new.status = 'Boarding';
    ELSEIF now() >= new.liftOff
       AND now() < new.landing THEN
        SET new.status = 'Airborne';
    ELSEIF now() >= new.landing
       AND now() < date_add(new.landing, INTERVAL 10 MINUTE) THEN
        SET new.status = 'Landing';
    ELSEIF now() >= date_add(new.landing, INTERVAL 10 MINUTE)
       AND now() < date_add(new.landing, INTERVAL 30 MINUTE) THEN
        SET new.status = 'Grounded';
    ELSE
        SET new.status = 'Grounded';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validFlightUpdatePrevention` BEFORE UPDATE ON `schedule` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1
        FROM flight f
        JOIN schedule s ON f.IATA = s.flightID
        WHERE f.assignedPilot = (
            SELECT assignedPilot FROM flight WHERE IATA = new.flightID
        )
        AND f.IATA <> old.flightID
        AND new.liftOff < s.landing
        AND new.landing > s.liftOff
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = 'Pilot is already assigned to another active flight during that time.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `setScheduleStatusBeforeUpdate` BEFORE UPDATE ON `schedule` FOR EACH ROW BEGIN
    IF now() < date_sub(new.liftOff, INTERVAL 1 HOUR) THEN
        SET new.status = 'Grounded';
    ELSEIF now() >= date_sub(new.liftOff, INTERVAL 1 HOUR)
       AND now() < date_sub(new.liftOff, INTERVAL 30 MINUTE) THEN
        SET new.status = 'On Time';
    ELSEIF now() >= date_sub(new.liftOff, INTERVAL 30 MINUTE)
       AND now() < new.liftOff THEN
        SET new.status = 'Boarding';
    ELSEIF now() >= new.liftOff
       AND now() < new.landing THEN
        SET new.status = 'Airborne';
    ELSEIF now() >= new.landing
       AND now() < date_add(new.landing, INTERVAL 10 MINUTE) THEN
        SET new.status = 'Landing';
    ELSEIF now() >= date_add(new.landing, INTERVAL 10 MINUTE)
       AND now() < date_add(new.landing, INTERVAL 30 MINUTE) THEN
        SET new.status = 'Grounded';
    ELSE
        SET new.status = 'Grounded';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
INSERT INTO `staff` VALUES (2,'mariavalentine@gmail.com',1),(3,'kaicairo@gmail.com',2),(4,'richardwalker@gmail.com',2),(5,'erinchoi@gmail.com',2),(9,'bongogigglefart@gmail.com',1),(10,'crunchgiggler@gmail.com',2),(11,'toastergiggleblast@gmail.com',5),(12,'toegigglesnort@gmail.com',2),(17,'rexgigglefart@gmail.com',2),(18,'nadiagiggler@gmail.com',2),(19,'coltgiggleblast@gmail.com',2),(20,'inezgigglesnort@gmail.com',2),(22,'admin@admin.com',1),(23,'staff1@staff.com',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'5127997308','Alan','Gascon','McTails','alangascon@gmail.com','3d45597256050bb1e93bd9c10aee4c8716f8774f5a48c995bf0cf860',0,NULL,NULL,'2026-03-01 09:00:00'),(2,'5123005252','Maria','Valentine','ValesMom','mariavalentine@gmail.com','8e012a7c9d83ad6d0a8c4623bccf2f208985d847cf8de8257111037e',1,NULL,NULL,'2026-03-01 09:15:00'),(3,'5125550101','Kai','Cairo','kcfrost','kaicairo@gmail.com','e04c3fcc21706ccaf4dac43d0e2530de2b5075963b50d6fc71b75306',1,NULL,NULL,'2026-03-01 09:30:00'),(4,'5125550102','Richard','Walker','rich93147','richardwalker@gmail.com','b9b3bbe5850b2e006260ce9e7575af2135381fc2387d141adbae4ed9',1,NULL,NULL,'2026-03-01 09:45:00'),(5,'5125550103','Erin','Choi','ErinCo','erinchoi@gmail.com','6c09ee70bba90aa92e604850300911d13ec0f793f142f1d751436a28',1,NULL,NULL,'2026-03-01 10:00:00'),(6,'5125550104','Omar','Singh','OmarSec','omarsingh@gmail.com','9da84c9b32f7ed60b153942887bee79fd607c02761697cf3da75c467',0,NULL,NULL,'2026-03-01 10:15:00'),(7,'5125550105','Tess','Nguyen','TessFA','tessnguyen@gmail.com','abf520e115e79883efd11fc1c2ecb835f84aedebbcae9243a59a51de',0,NULL,NULL,'2026-03-01 10:30:00'),(8,'5125550106','Luis','Martinez','LuisOps','luismartinez@gmail.com','37cd094b9932c2b6145a891f070fc3d0529643c7fd0945e80290c7db',0,NULL,NULL,'2026-03-01 10:45:00'),(9,'5125550201','Bongo','Gigglefart','bongojet','bongogigglefart@gmail.com','e3264e3441f7771da59005bc31b21e28976df50536942aae6780c9e1',1,NULL,NULL,'2026-03-01 11:00:00'),(10,'5125550202','Crunch','Giggler','crunchpilot','crunchgiggler@gmail.com','1113d702884878bbbc5f4102973be7e8fca7a73643a653f1c0094aa9',1,NULL,NULL,'2026-03-01 11:15:00'),(11,'5125550203','Toaster','Giggleblast','toastgob','toastergiggleblast@gmail.com','89b1a7ff725054065f3f0b17c6bbe0d1021ef36ae9561add61241064',1,NULL,NULL,'2026-03-01 11:30:00'),(12,'5125550204','Toe','Gigglesnort','toeLiker','toegigglesnort@gmail.com','5d85e39972dda93ad56a7c4697c25e52c481667d42ec3da1831a8323',1,NULL,NULL,'2026-03-01 11:45:00'),(13,'5125550205','Soggy','Gigglenoodle','sogwaff','soggygigglenoodle@gmail.com','1ea30687f3f2b94bbb7ec553c4b9d6fd0c0c0accffda7e6ce70d0ae4',0,NULL,NULL,'2026-03-01 12:00:00'),(14,'5125550206','Grease','Gigglechunk','greasemc','greasegigglechunk@gmail.com','eb4b19792f4aeb780bc5a0f98d31e510b3479d7c0e566a330d4fec49',0,NULL,NULL,'2026-03-01 12:15:00'),(15,'5125550207','Wiggles','Gigglepants','wigglefunk','wigglesgigglepants@gmail.com','f6890f6e78029659e9f65d1c41faccba06b96c8818e2553e0fa7f425',0,NULL,NULL,'2026-03-01 12:30:00'),(16,'5125550208','Cheddar','Gigglecheese','chedblast','cheddargigglecheese@gmail.com','6c95d9fba357468220b1305a5593e78da8eabecbf5039fb9214b06aa',0,NULL,NULL,'2026-03-01 12:45:00'),(17,'5125551000','Rex','Gigglefart','rexhar','rexgigglefart@gmail.com','915ff5a2d51fe69d6c948bb6b2a77835b29c30dc00aad8e2c8a372e9',1,NULL,NULL,'2026-03-15 08:00:00'),(18,'5125551001','Nadia','Giggler','nadiavos','nadiagiggler@gmail.com','2045d6530c48dadf94cf7ffc785cede6b680b602f376ac483e402253',1,NULL,NULL,'2026-03-15 08:00:00'),(19,'5125551002','Colt','Giggleblast','coltbla','coltgiggleblast@gmail.com','adac97622b6281379ce628e0f4d4c31c482a1c4074c5ac1b2c413c7e',1,NULL,NULL,'2026-03-15 08:00:00'),(20,'5125551003','Inez','Gigglesnort','inezfer','inezgigglesnort@gmail.com','93d83c88cd84efbebf28f15f185ab4c909e75bf52560740bf3f8423d',1,NULL,NULL,'2026-03-15 08:00:00'),(22,'123','admin','admin','iamanadmin','admin@admin.com','641bde2781319a338d8b5970db8bd1950cc952a79420597b0c241c72',0,NULL,NULL,'2026-04-01 15:10:39'),(23,'123213','staff','staff','SATFF!!','staff1@staff.com','7c68303949eb4127f8c36bf8247c3951c3a19dd04c5419c3d4aae500',1,NULL,NULL,'2026-04-01 15:12:38'),(24,'3434','AAAAA','AAAAA','Meoww123?','Meoww123?@gmail.com','86cdbca762d6e4f8260aa7a078a4c9fabd68c26cb3e7bd1289ee7e28',0,NULL,NULL,'2026-04-01 15:14:27');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `createstaff` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    IF new.isStaff = true THEN
        INSERT INTO staff(staffID, email) VALUES (new.userID, new.email);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `createstaffAfterUpdate` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    IF new.isStaff = true THEN
        INSERT INTO staff(staffID, email) VALUES (new.userID, new.email);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rememberDeletedUser` BEFORE DELETE ON `users` FOR EACH ROW BEGIN
    INSERT INTO deletedUsers VALUES(
        old.userID, old.phoneNumber, old.fname, old.lname,
        old.username, old.email, old.password, old.isStaff,
        old.bio, old.registeredDate
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'tfg'
--

--
-- Dumping routines for database 'tfg'
--

--
-- Final view structure for view `available_flights`
--

/*!50001 DROP VIEW IF EXISTS `available_flights`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `available_flights` AS select `s`.`scheduleID` AS `scheduleID`,`ao`.`IATA` AS `origin_IATA`,`ad`.`IATA` AS `destination_IATA`,`f`.`IATA` AS `IATA`,`f`.`capacity` AS `capacity`,time_format(`s`.`liftOff`,'%H:%i') AS `liftOff`,time_format(`s`.`landing`,'%H:%i') AS `landing`,concat(timestampdiff(HOUR,`s`.`liftOff`,`s`.`landing`),'h ',(timestampdiff(MINUTE,`s`.`liftOff`,`s`.`landing`) % 60),'m') AS `duration` from (((`flight` `f` join `airports` `ao` on((`f`.`origin` = `ao`.`airportID`))) join `airports` `ad` on((`f`.`destination` = `ad`.`airportID`))) join `schedule` `s` on((`f`.`IATA` = `s`.`flightID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

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
/*!50001 VIEW `reservationticket` AS select `b`.`bookingNumber` AS `bookingNumber`,`b`.`userID` AS `userID`,`b`.`bookingDate` AS `reservationDate`,`b`.`departSeat` AS `departSeatNumber`,`b`.`returnSeat` AS `returnSeatNumber`,`b`.`departDate` AS `departDate`,`b`.`returnDate` AS `returnDate`,`b`.`departSchedule` AS `departScheduleID`,`b`.`returnSchedule` AS `returnScheduleID`,`u`.`username` AS `username`,`ds`.`liftOff` AS `departLiftOffDate`,`ds`.`landing` AS `departArrivingDate`,`df`.`IATA` AS `departFlight`,`dfao`.`name` AS `departOrigin`,`dfad`.`name` AS `departDestination`,`rs`.`liftOff` AS `returnLiftOffDate`,`rs`.`landing` AS `returnArrivingDate`,`rf`.`IATA` AS `returnFlight`,`rfao`.`name` AS `returnOrigin`,`rfad`.`name` AS `returnDestination` from (((((((((`booking` `b` left join `users` `u` on((`b`.`userID` = `u`.`userID`))) left join `schedule` `ds` on((`ds`.`scheduleID` = `b`.`departSchedule`))) left join `flight` `df` on((`df`.`IATA` = `ds`.`flightID`))) left join `airports` `dfao` on((`dfao`.`airportID` = `df`.`origin`))) left join `airports` `dfad` on((`dfad`.`airportID` = `df`.`destination`))) left join `schedule` `rs` on((`rs`.`scheduleID` = `b`.`returnSchedule`))) left join `flight` `rf` on((`rf`.`IATA` = `rs`.`flightID`))) left join `airports` `rfao` on((`rfao`.`airportID` = `rf`.`origin`))) left join `airports` `rfad` on((`rfad`.`airportID` = `rf`.`destination`))) */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-01 20:58:37
