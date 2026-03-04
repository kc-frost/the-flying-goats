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
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,1,'TP1001',101),(2,2,'TP1002',103),(3,1,'TP1003',105),(4,2,'TP1004',101),(5,1,'TP1005',103),(6,2,'TP1006',105);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES ('TP1001','Goated67Plane','A1','Austin'),('TP1002','SkyRam900','A2','Dallas'),('TP1003','HornetJet11','B1','Houston'),('TP1004','Nimbus220','B2','San Antonio'),('TP1005','CrownCruiser','C1','Denver'),('TP1006','AtlasSprint','C2','Chicago');
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `flightclass`
--

LOCK TABLES `flightclass` WRITE;
/*!40000 ALTER TABLE `flightclass` DISABLE KEYS */;
INSERT INTO `flightclass` VALUES (1,'Economy',100),(2,'First Class',200),(3,'Goat Class',10000);
/*!40000 ALTER TABLE `flightclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,10),(2,25),(3,3),(4,2),(5,1),(6,18);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `transportAndEquipmentInsert` AFTER INSERT ON `item` FOR EACH ROW begin
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
-- Dumping data for table `miscellaneousitem`
--

LOCK TABLES `miscellaneousitem` WRITE;
/*!40000 ALTER TABLE `miscellaneousitem` DISABLE KEYS */;
INSERT INTO `miscellaneousitem` VALUES (5,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.'),(6,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.');
/*!40000 ALTER TABLE `miscellaneousitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `parkinglot`
--

LOCK TABLES `parkinglot` WRITE;
/*!40000 ALTER TABLE `parkinglot` DISABLE KEYS */;
INSERT INTO `parkinglot` VALUES ('A',100),('B',120),('C',80),('D',60),('E',150),('F',90);
/*!40000 ALTER TABLE `parkinglot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `plane`
--

LOCK TABLES `plane` WRITE;
/*!40000 ALTER TABLE `plane` DISABLE KEYS */;
INSERT INTO `plane` VALUES ('A676',1),('B212',2),('C909',3),('D404',4),('E777',5),('F101',6);
/*!40000 ALTER TABLE `plane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `planeseat`
--

LOCK TABLES `planeseat` WRITE;
/*!40000 ALTER TABLE `planeseat` DISABLE KEYS */;
INSERT INTO `planeseat` VALUES (101,'TP1001','Economy'),(102,'TP1001','First Class'),(103,'TP1002','Economy'),(104,'TP1002','First Class'),(105,'TP1003','Economy'),(106,'TP1003','Goat Class');
/*!40000 ALTER TABLE `planeseat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `planestatusenums`
--

LOCK TABLES `planestatusenums` WRITE;
/*!40000 ALTER TABLE `planestatusenums` DISABLE KEYS */;
INSERT INTO `planestatusenums` VALUES (1,'On Time',NULL),(2,'Delayed',NULL),(3,'Boarding',NULL),(4,'Taxiing',NULL),(5,'Airborne',NULL),(6,'Landing',NULL);
/*!40000 ALTER TABLE `planestatusenums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `positionenums`
--

LOCK TABLES `positionenums` WRITE;
/*!40000 ALTER TABLE `positionenums` DISABLE KEYS */;
INSERT INTO `positionenums` VALUES (1,'Flight Attendent'),(2,'Pilot'),(3,'Co-Pilot'),(4,'Security'),(5,'Unassigned'),(6,'Unassigned');
/*!40000 ALTER TABLE `positionenums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES ('TP1001','2026-03-10 10:06:07','2026-03-10 12:00:00'),('TP1002','2026-03-10 13:30:00','2026-03-10 15:05:00'),('TP1003','2026-03-11 09:15:00','2026-03-11 10:25:00'),('TP1004','2026-03-11 16:40:00','2026-03-11 18:10:00'),('TP1005','2026-03-12 07:00:00','2026-03-12 09:55:00'),('TP1006','2026-03-12 19:20:00','2026-03-12 22:35:00');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (2,'mariavalentine@gmail.com',1),(3,'kaicairo@tfg.com',2),(4,'richardwalker@tfg.com',3),(5,'erin.choi@tfg.com',4);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `transportation`
--

LOCK TABLES `transportation` WRITE;
/*!40000 ALTER TABLE `transportation` DISABLE KEYS */;
INSERT INTO `transportation` VALUES (3,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.'),(4,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.');
/*!40000 ALTER TABLE `transportation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'5127997308','Alan','Gascon','McTails','alangascon@gmail.com','password123',0),(2,'5123005252','Maria','Valentine','ValesMom','mariavalentine@gmail.com','password234',1),(3,'5125550101','Kai','Cairo','kcfrost','kaicairo@tfg.com','password345',1),(4,'5125550102','Richard','Walker','rich93147','richardwalker@tfg.com','password456',1),(5,'5125550103','Erin','Choi','ErinCo','erin.choi@tfg.com','password567',1),(6,'5125550104','Omar','Singh','OmarSec','omar.singh@tfg.com','password678',0),(7,'5125550105','Tess','Nguyen','TessFA','tess.nguyen@tfg.com','password789',0),(8,'5125550106','Luis','Martinez','LuisOps','luis.martinez@tfg.com','password890',0);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `createStaff` AFTER INSERT ON `users` FOR EACH ROW begin
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
-- Dumping events for database 'tfg'
--

--
-- Dumping routines for database 'tfg'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-04 17:19:29
