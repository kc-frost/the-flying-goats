CREATE DATABASE  IF NOT EXISTS `tfg` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `tfg`;
-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: TFG
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `bookingNumber` int NOT NULL AUTO_INCREMENT,
  `userID` int DEFAULT NULL,
  `flightID` varchar(7) DEFAULT NULL,
  `seat` int DEFAULT NULL,
  `bookingDate` datetime DEFAULT NULL,
  PRIMARY KEY (`bookingNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,1,'TP1001',101,'2026-03-01 12:00:00'),(2,2,'TP1002',103,'2026-03-01 12:10:00'),(3,1,'TP1003',105,'2026-03-01 12:20:00'),(4,2,'TP1004',107,'2026-03-01 12:30:00'),(5,1,'TP1005',109,'2026-03-01 12:40:00'),(6,2,'TP1006',111,'2026-03-01 12:50:00'),(7,18,'TP1001',110,'2026-03-07 00:00:00'),(8,18,'TP1001',110,'2026-03-07 00:00:00'),(9,18,'TP1002',110,'2026-03-07 00:00:00'),(10,18,'TP1002',110,'2026-03-07 00:00:00'),(11,18,'TP1002',110,'2026-03-07 00:00:00');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
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
INSERT INTO `equipment` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.');
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
  `planeName` varchar(255) DEFAULT NULL,
  `gate` varchar(2) DEFAULT NULL,
  `origin` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`IATA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES ('TP1001','Goated67Plane','A1','Austin','Dallas'),('TP1002','SkyRam900','A2','Austin','Houston'),('TP1003','HornetJet11','B1','Austin','San Antonio'),('TP1004','Nimbus220','B2','Austin','Denver'),('TP1005','CrownCruiser','C1','Austin','Chicago'),('TP1006','AtlasSprint','C2','Austin','Phoenix');
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
INSERT INTO `inventory` VALUES (1,10),(2,25),(3,3),(4,2),(5,1),(6,18);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.','equipment'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.','equipment'),(3,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.','transportation'),(4,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.','transportation'),(5,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.','misc'),(6,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.','misc');
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `transportandequipmentinsert` AFTER INSERT ON `item` FOR EACH ROW begin
	if (new.type = "equipment")
		then
			insert into equipment(itemID, equipmentName, equipmentDescription) values 
            (new.itemID, new.itemName, new.itemDescription);
	elseif (new.type = "transportation")
		then 
			insert into transportation(itemID, transportName, transportDescription) values
            (new.itemID, new.itemName, new.itemDescription);
	elseif (new.type="misc")
		then
			insert into miscellaneousItem(itemID, itemName, itemDescription) values
            (new.itemID, new.itemName, new.itemDescription);
	end if;
end */;;
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
INSERT INTO `miscellaneousitem` VALUES (5,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.'),(6,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.');
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
-- Table structure for table `plane`
--

DROP TABLE IF EXISTS `plane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plane` (
  `ICAO` varchar(4) NOT NULL,
  `statusID` int DEFAULT NULL,
  PRIMARY KEY (`ICAO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plane`
--

LOCK TABLES `plane` WRITE;
/*!40000 ALTER TABLE `plane` DISABLE KEYS */;
INSERT INTO `plane` VALUES ('A676',1),('B212',2),('C909',3),('D404',4),('E777',5),('F101',6);
/*!40000 ALTER TABLE `plane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planeseat`
--

DROP TABLE IF EXISTS `planeseat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planeseat` (
  `seatNumber` int NOT NULL,
  `flightID` varchar(7) NOT NULL,
  `classID` int DEFAULT NULL,
  PRIMARY KEY (`seatNumber`,`flightID`),
  KEY `fk_class_id` (`classID`),
  CONSTRAINT `fk_class_id` FOREIGN KEY (`classID`) REFERENCES `flightclass` (`classID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planeseat`
--

LOCK TABLES `planeseat` WRITE;
/*!40000 ALTER TABLE `planeseat` DISABLE KEYS */;
INSERT INTO `planeseat` VALUES (101,'TP1001',1),(103,'TP1002',1),(105,'TP1003',1),(107,'TP1004',1),(109,'TP1005',1),(111,'TP1006',1),(102,'TP1001',2),(104,'TP1002',2),(108,'TP1004',2),(110,'TP1005',2),(106,'TP1003',3),(112,'TP1006',3);
/*!40000 ALTER TABLE `planeseat` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Temporary view structure for view `reservationticket`
--

DROP TABLE IF EXISTS `reservationticket`;
/*!50001 DROP VIEW IF EXISTS `reservationticket`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reservationticket` AS SELECT 
 1 AS `bookingNumber`,
 1 AS `userID`,
 1 AS `flightID`,
 1 AS `seatNumber`,
 1 AS `reservationDate`,
 1 AS `classID`,
 1 AS `seatClass`,
 1 AS `username`,
 1 AS `liftOffDate`,
 1 AS `arrivingDate`,
 1 AS `origin`,
 1 AS `destination`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `flight` varchar(7) NOT NULL,
  `liftOff` datetime DEFAULT NULL,
  `landing` datetime DEFAULT NULL,
  PRIMARY KEY (`flight`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES ('TP1001','2026-03-10 10:06:07','2026-03-10 12:00:00'),('TP1002','2026-03-10 13:30:00','2026-03-10 15:05:00'),('TP1003','2026-03-11 09:15:00','2026-03-11 10:25:00'),('TP1004','2026-03-11 16:40:00','2026-03-11 18:10:00'),('TP1005','2026-03-12 07:00:00','2026-03-12 09:55:00'),('TP1006','2026-03-12 19:20:00','2026-03-12 22:35:00');
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
INSERT INTO `staff` VALUES (2,'mariavalentine@gmail.com',1),(3,'kaicairo@tfg.com',2),(4,'richardwalker@tfg.com',3),(5,'erin.choi@tfg.com',4);
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
INSERT INTO `transportation` VALUES (3,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.'),(4,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.');
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
  `bio` text,
  `registeredDate` datetime DEFAULT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'5127997308','Alan','Gascon','McTails','alangascon@gmail.com','password123',0,NULL,'2026-03-01 09:00:00'),(2,'5123005252','Maria','Valentine','ValesMom','mariavalentine@gmail.com','password234',1,NULL,'2026-03-01 09:15:00'),(3,'5125550101','Kai','Cairo','kcfrost','kaicairo@tfg.com','password345',1,NULL,'2026-03-01 09:30:00'),(4,'5125550102','Richard','Walker','rich93147','richardwalker@tfg.com','password456',1,NULL,'2026-03-01 09:45:00'),(5,'5125550103','Erin','Choi','ErinCo','erin.choi@tfg.com','password567',1,NULL,'2026-03-01 10:00:00'),(6,'5125550104','Omar','Singh','OmarSec','omar.singh@tfg.com','password678',0,NULL,'2026-03-01 10:15:00'),(7,'5125550105','Tess','Nguyen','TessFA','tess.nguyen@tfg.com','password789',0,NULL,'2026-03-01 10:30:00'),(8,'5125550106','Luis','Martinez','LuisOps','luis.martinez@tfg.com','password890',0,NULL,'2026-03-01 10:45:00'),(9,'5129999999','another','user','testtest','testtesttesttest@gmail.com','707c025380546f5b0db4fe50910a0730e330cec289771a6d064c12b6',0,NULL,NULL),(10,'1111111111','Kai','Richard','KaiAndRichard','KaiRichard@admin.com','e41fc16d04c7972f2f5a48e511d7aa60a046238f37720a304d59d70c',0,NULL,NULL),(11,'2222222222','I\'mRunning','OutofNames','RICHHHH','RichardKai@gmail.com','e41fc16d04c7972f2f5a48e511d7aa60a046238f37720a304d59d70c',0,NULL,NULL),(12,'8888888888','RICHARD','WALKER','asdfadsfasdf','runningoutofemailideas@gmail.com','f3e7ecba1482486acdaaa3fadc41710febbdd8832529af435311dde6',0,NULL,NULL),(13,'5555555555','LAST','ONE','lastonelastone','LASTONE@gmail.com','7470eb72e2fcb1363b209a523babc68e9455dccbdb83de4a6b27de7e',0,NULL,NULL),(14,'512890','APU','a','kai','kpo2@gmail.com','255de87b404ce62c3c1b8b96b0ea79b6a28cccb6a1fd428d9d1f4267',0,NULL,NULL),(15,'98','ka','ca','Kcairo','Kcairo123@gmail.com','e3e208e859c3bd685e146283cb7f08605ee2c3d2e066a0c5735bb403',0,NULL,NULL),(16,'123','admin','admin','admin','admin@gmail.com','21dc4bde52eeb40f9a3182906f05c2a071839d37c132004144481bb3',0,'A new bio!',NULL),(17,'123123','a','a','User1@gmail.com','User1@gmail.com','8428448df54362cff9c4b56bf83a4b12fa2cef6bacd0b7a86bc28915',0,NULL,NULL),(18,'123','User2@gmail.com','User2@gmail.com','User2@gmail.com','User2@gmail.com','7f31936227c4474704f3028a3b09d125aac1f100688dd96a849f6a51',0,NULL,NULL),(19,'3333333333','Lauren','LastName','LaurenSucks','Lauren@admin.com','e41fc16d04c7972f2f5a48e511d7aa60a046238f37720a304d59d70c',0,NULL,NULL),(20,'1231232','a','a','User3@gmail.com','User3@gmail.com','e37aded4ba979c1d5c4840a1e6dff8a8191f1e892bb2f4b6081408df',0,NULL,NULL),(21,'123123','a','a','User4@gmail.com','User4@gmail.com','0d4156c00c703757ff14d416b2b0865712514f3acc27d12ed9ba0f19',0,NULL,NULL),(22,'123','firstname','me','User5@gmail.com','User5@gmail.com','16fb0aa1c72daec190f9578b852e8af602914fdf7a8a11a84f1d0bb4',0,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;

/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `defaultUserValsUponNull`
BEFORE INSERT ON `users`
FOR EACH ROW
begin
	if new.bio is null then
		set new.bio = 'No bio';
	end if;
	set new.registeredDate = curdate();
end */;;
DELIMITER ;;

DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `createstaff` AFTER INSERT ON `users` FOR EACH ROW begin
    if new.isStaff = true 
		then
			insert into staff(staffID, email) values
            (new.userID, new.email);
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
/*!50001 VIEW `reservationticket` AS select `b`.`bookingNumber` AS `bookingNumber`,`b`.`userID` AS `userID`,`b`.`flightID` AS `flightID`,`b`.`seat` AS `seatNumber`,`b`.`bookingDate` AS `reservationDate`,`ps`.`classID` AS `classID`,`fc`.`className` AS `seatClass`,`u`.`username` AS `username`,`s`.`liftOff` AS `liftOffDate`,`s`.`landing` AS `arrivingDate`,`f`.`origin` AS `origin`,`f`.`destination` AS `destination` from (((((`booking` `b` left join `planeseat` `ps` on((`ps`.`seatNumber` = `b`.`seat`))) join `flightclass` `fc` on((`fc`.`classID` = `ps`.`classID`))) left join `users` `u` on((`b`.`userID` = `u`.`userID`))) left join `schedule` `s` on((`s`.`flight` = `b`.`flightID`))) left join `flight` `f` on((`f`.`IATA` = `s`.`flight`))) */;
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
/*!50001 VIEW `userreservationsummary` AS select `u`.`userID` AS `userID`,`u`.`email` AS `email`,(to_days(curdate()) - to_days(cast(`u`.`registeredDate` as date))) AS `registerLengthDays`,count(`b`.`bookingNumber`) AS `totalReservations`,sum((case when (`s`.`liftOff` < now()) then 1 else 0 end)) AS `totalPastReservations`,sum((case when (`s`.`liftOff` >= now()) then 1 else 0 end)) AS `totalFutureReservations` from ((`users` `u` left join `booking` `b` on((`u`.`userID` = `b`.`userID`))) left join `schedule` `s` on((`b`.`flightID` = `s`.`flight`))) group by `u`.`userID`,`u`.`email`,`u`.`registeredDate` */;
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

-- Dump completed on 2026-03-11  2:22:41
