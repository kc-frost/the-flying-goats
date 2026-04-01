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
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES (1,1,'Austin, TX','Austin-Bergstrom Intl','AUS'),(2,1,'New York, NYC','John F Kennedy Intl','JFK'),(3,1,'San Francisco, CA','San Francisco Intl','SFO'),(4,2,'São Paulo, Brazil','Guarulhos Intl','GRU'),(5,2,'Buenos Aires, Argentina','Ministro Pistarini Intl','EZE'),(6,2,'Bogotá, Colombia','El Dorado Intl','BOG'),(7,3,'Tokyo, Japan','Haneda Intl','HND'),(8,3,'Dubai, UAE','Dubai Intl','DXB'),(9,3,'Singapore, Singapore','Changi Intl','SIN'),(10,4,'London, UK','Heathrow Intl','LHR'),(11,4,'Paris, France','Charles de Gaulle Intl','CDG'),(12,4,'Frankfurt, Germany','Frankfurt am Main Intl','FRA'),(13,5,'Johannesburg, South Africa','O.R. Tambo Intl','JNB'),(14,5,'Cairo, Egypt','Cairo Intl','CAI'),(15,5,'Nairobi, Kenya','Jomo Kenyatta Intl','NBO');
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,'2026-03-01 12:00:00',1,'101','103','2026-03-10',1,'2026-03-10',2),(2,'2026-03-01 12:10:00',2,'102','104','2026-03-10',1,'2026-03-10',2),(3,'2026-03-01 12:20:00',1,'105','107','2026-03-11',3,'2026-03-11',4),(4,'2026-03-01 12:30:00',2,'106','108','2026-03-11',3,'2026-03-11',4),(5,'2026-03-01 12:40:00',1,'109','111','2026-03-12',5,'2026-03-12',6),(6,'2026-03-01 12:50:00',2,'110','112','2026-03-12',5,'2026-03-12',6);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `bookinghistory`
--

LOCK TABLES `bookinghistory` WRITE;
/*!40000 ALTER TABLE `bookinghistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookinghistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `deletedusers`
--

LOCK TABLES `deletedusers` WRITE;
/*!40000 ALTER TABLE `deletedusers` DISABLE KEYS */;
/*!40000 ALTER TABLE `deletedusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.'),(3,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES ('TP1001','A676','Goated67Plane','A1',1,2,20,3),('TP1002','B212','SkyRam900','A2',1,3,24,3),('TP1003','C909','HornetJet11','B1',1,4,16,4),('TP1004','D404','Nimbus220','B2',1,5,20,5),('TP1005','E777','CrownCruiser','C1',1,6,24,10),('TP1006','F101','AtlasSprint','C2',1,7,28,12),('TP1007','G303','GoatedFlight','A1',1,2,20,3),('TP1009','H404','GoatPlane','D3',1,3,24,4),('TP1011','I505','StormRider','C3',1,4,16,5),('TP1013','J606','NovaStar','A1',2,3,4,10),('TP1015','K707','ArcticBreeze','D1',2,1,20,12),('TP1017','L808','CoastalAce','B2',2,5,8,17),('TP1019','M909','ApexGlider','A3',3,1,12,3),('TP1021','N010','MidnightRun','B3',3,2,28,4),('TP1023','O111','CloudPiercer','B2',3,4,16,5),('TP1025','P212','EclipseJet','B2',4,1,28,10),('TP1027','Q313','SwiftArrow','A1',4,2,28,12),('TP1029','R414','CycloneX','B3',4,5,32,17),('TP1031','S515','TwilightAce','C2',5,3,32,3),('TP1033','T616','SkyLancer','A2',5,1,16,4),('TP1035','U717','NorthStar','C3',5,4,16,5),('TP1037','V818','TurboCondor','A1',6,3,12,10),('TP1039','W919','HighRoller','B1',6,5,32,12),('TP1041','X020','MachRacer','D3',7,4,8,17),('TP1043','Y121','CobaltJet','D2',7,8,8,3),('TP1045','Z222','HorizonX','C1',8,9,20,4),('TP1047','AA23','AltitudePro','A3',9,1,4,5),('TP1049','AB24','BlackKite','B1',10,3,28,10),('TP1051','AC25','MercuryWing','A1',10,2,12,12),('TP1053','AD26','CrimsonAce','D3',11,3,28,17),('TP1055','AE27','BronzeArrow','B3',11,1,28,3),('TP1057','AF28','DiamondAir','D2',12,4,28,4),('TP1059','AG29','SapphireGlide','C2',12,5,20,5),('TP1061','AH30','AmethystWing','D1',13,4,32,10),('TP1063','AI31','OpalSky','D3',13,1,32,12),('TP1065','AJ32','PeridotFlight','C2',14,2,8,17),('TP1067','AK33','QuartzSprint','B3',14,5,32,3),('TP1069','AL34','MarbleAce','B2',15,3,32,4),('TP1071','AM35','SlateHawk','D1',15,1,32,5),('TP1073','AN36','CanyonRunner','B2',1,2,32,10),('TP1075','AO37','DeltaGlide','A3',2,3,24,12),('TP1077','AP38','ZetaWing','B3',3,4,28,17),('TP1079','AQ39','ThetaStar','A1',4,1,8,3),('TP1081','AR40','KappaAir','A2',5,9,4,4),('TP1083','AS41','MuWing','C3',6,3,24,5),('TP1085','AT42','XiGlide','C2',7,1,24,10),('TP1087','AU43','PiAce','D3',8,2,24,12),('TP1089','AV44','SigmaFlight','B2',9,4,24,17),('TP1091','AW45','UpsilonJet','D2',10,1,20,3),('TP1093','AX46','ChiHawk','C3',11,2,16,4),('TP1095','AY47','OmegaAce','D1',12,3,16,5);
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
-- Dumping data for table `hanger`
--

LOCK TABLES `hanger` WRITE;
/*!40000 ALTER TABLE `hanger` DISABLE KEYS */;
INSERT INTO `hanger` VALUES (1,'A676','In use'),(2,'B212','In use'),(3,'C909','In use'),(4,'D404','In use'),(5,'E777','In use'),(6,'F101','In use'),(7,'H404','In use'),(8,'I505','In use'),(9,'J606','In use'),(10,'K707','In use'),(11,'L808','In use'),(12,'M909','In use'),(13,'O111','In use'),(14,'P212','In use'),(15,'N010','In use'),(16,'Q313','In use'),(17,'R414','In use'),(18,'S515','In use'),(19,'U717','In use'),(20,'V818','In use'),(21,'W919','In use'),(22,'X020','In use'),(23,'Y121','In use'),(24,'T616','In use'),(25,'AA23','In use'),(26,'AB24','In use'),(27,'AC25','In use'),(28,'AD26','In use'),(29,'AE27','In use'),(30,'G303','In use'),(31,'AF28','In use'),(32,'AG29','In use'),(33,'AH30','In use'),(34,'AI31','In use'),(35,'AJ32','In use'),(36,'AK33','In use'),(37,'AP38','In use'),(38,'AQ39','In use'),(39,'AR40','In use'),(40,'AS41','In use'),(41,'AT42','In use'),(42,'AL34','In use'),(43,'AU43','In use'),(44,'AV44','In use'),(45,'AW45','In use'),(46,'AX46','In use'),(47,'AY47','In use'),(48,'AM35','In use'),(49,'AN36','In use'),(50,'AO37','In use'),(51,'Z222','In use'),(52,'Y676','Available');
/*!40000 ALTER TABLE `hanger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,10),(2,25),(3,3),(4,2),(5,1),(6,18),(7,12);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'Metal Detector','Primary security screening device used at entry checkpoints.','equipment'),(2,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.','equipment'),(3,'First Aid Kit','Emergency medical kit stored for handling minor injuries and health incidents.','equipment'),(4,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.','transportation'),(5,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.','transportation'),(6,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.','misc'),(7,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.','misc');
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `miscellaneousitem`
--

LOCK TABLES `miscellaneousitem` WRITE;
/*!40000 ALTER TABLE `miscellaneousitem` DISABLE KEYS */;
INSERT INTO `miscellaneousitem` VALUES (6,'Lost & Found Bin','Storage container used for temporarily holding lost passenger items.'),(7,'Cleaning Supplies','General cleaning materials used by maintenance staff throughout the airport.');
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
INSERT INTO `plane` VALUES ('A676'),('AA23'),('AB24'),('AC25'),('AD26'),('AE27'),('AF28'),('AG29'),('AH30'),('AI31'),('AJ32'),('AK33'),('AL34'),('AM35'),('AN36'),('AO37'),('AP38'),('AQ39'),('AR40'),('AS41'),('AT42'),('AU43'),('AV44'),('AW45'),('AX46'),('AY47'),('B212'),('C909'),('D404'),('E777'),('F101'),('G303'),('H404'),('I505'),('J606'),('K707'),('L808'),('M909'),('N010'),('O111'),('P212'),('Q313'),('R414'),('S515'),('T616'),('U717'),('V818'),('W919'),('X020'),('Y121'),('Y676'),('Z222');
/*!40000 ALTER TABLE `plane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `planeseat`
--

LOCK TABLES `planeseat` WRITE;
/*!40000 ALTER TABLE `planeseat` DISABLE KEYS */;
INSERT INTO `planeseat` VALUES ('101',1,1),('103',2,1),('105',3,1),('107',4,1),('109',5,1),('111',6,1),('102',1,2),('104',2,2),('108',4,2),('110',5,2),('106',3,3),('112',6,3);
/*!40000 ALTER TABLE `planeseat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `positionenums`
--

LOCK TABLES `positionenums` WRITE;
/*!40000 ALTER TABLE `positionenums` DISABLE KEYS */;
INSERT INTO `positionenums` VALUES (1,'Flight Attendent'),(2,'Pilot'),(3,'Co-Pilot'),(4,'Security'),(5,'Unassigned');
/*!40000 ALTER TABLE `positionenums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,'Texas'),(2,'Colorado'),(3,'Illinois'),(4,'Arizona'),(5,'Georgia');
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,'TP1001','10:06:07','12:00:00','Grounded'),(2,'TP1002','13:30:00','15:05:00','Grounded'),(3,'TP1003','09:15:00','10:25:00','Grounded'),(4,'TP1004','16:40:00','18:10:00','Grounded'),(5,'TP1005','07:00:00','09:55:00','Grounded'),(6,'TP1006','19:20:00','22:35:00','Airborne');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (2,'mariavalentine@gmail.com',1),(3,'kaicairo@gmail.com',2),(4,'richardwalker@gmail.com',2),(5,'erinchoi@gmail.com',2),(9,'bongogigglefart@gmail.com',1),(10,'crunchgiggler@gmail.com',2),(11,'toastergiggleblast@gmail.com',5),(12,'toegigglesnort@gmail.com',2),(17,'rexgigglefart@gmail.com',2),(18,'nadiagiggler@gmail.com',2),(19,'coltgiggleblast@gmail.com',2),(20,'inezgigglesnort@gmail.com',2);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `transportation`
--

LOCK TABLES `transportation` WRITE;
/*!40000 ALTER TABLE `transportation` DISABLE KEYS */;
INSERT INTO `transportation` VALUES (4,'Baggage Tug','Vehicle used to transport luggage carts between terminals and aircraft.'),(5,'Passenger Shuttle','Ground shuttle used to move passengers between terminals and gates.');
/*!40000 ALTER TABLE `transportation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'5127997308','Alan','Gascon','McTails','alangascon@gmail.com','3d45597256050bb1e93bd9c10aee4c8716f8774f5a48c995bf0cf860',0,NULL,NULL,'2026-03-01 09:00:00'),(2,'5123005252','Maria','Valentine','ValesMom','mariavalentine@gmail.com','8e012a7c9d83ad6d0a8c4623bccf2f208985d847cf8de8257111037e',1,NULL,NULL,'2026-03-01 09:15:00'),(3,'5125550101','Kai','Cairo','kcfrost','kaicairo@gmail.com','e04c3fcc21706ccaf4dac43d0e2530de2b5075963b50d6fc71b75306',1,NULL,NULL,'2026-03-01 09:30:00'),(4,'5125550102','Richard','Walker','rich93147','richardwalker@gmail.com','b9b3bbe5850b2e006260ce9e7575af2135381fc2387d141adbae4ed9',1,NULL,NULL,'2026-03-01 09:45:00'),(5,'5125550103','Erin','Choi','ErinCo','erinchoi@gmail.com','6c09ee70bba90aa92e604850300911d13ec0f793f142f1d751436a28',1,NULL,NULL,'2026-03-01 10:00:00'),(6,'5125550104','Omar','Singh','OmarSec','omarsingh@gmail.com','9da84c9b32f7ed60b153942887bee79fd607c02761697cf3da75c467',0,NULL,NULL,'2026-03-01 10:15:00'),(7,'5125550105','Tess','Nguyen','TessFA','tessnguyen@gmail.com','abf520e115e79883efd11fc1c2ecb835f84aedebbcae9243a59a51de',0,NULL,NULL,'2026-03-01 10:30:00'),(8,'5125550106','Luis','Martinez','LuisOps','luismartinez@gmail.com','37cd094b9932c2b6145a891f070fc3d0529643c7fd0945e80290c7db',0,NULL,NULL,'2026-03-01 10:45:00'),(9,'5125550201','Bongo','Gigglefart','bongojet','bongogigglefart@gmail.com','e3264e3441f7771da59005bc31b21e28976df50536942aae6780c9e1',1,NULL,NULL,'2026-03-01 11:00:00'),(10,'5125550202','Crunch','Giggler','crunchpilot','crunchgiggler@gmail.com','1113d702884878bbbc5f4102973be7e8fca7a73643a653f1c0094aa9',1,NULL,NULL,'2026-03-01 11:15:00'),(11,'5125550203','Toaster','Giggleblast','toastgob','toastergiggleblast@gmail.com','89b1a7ff725054065f3f0b17c6bbe0d1021ef36ae9561add61241064',1,NULL,NULL,'2026-03-01 11:30:00'),(12,'5125550204','Toe','Gigglesnort','toeLiker','toegigglesnort@gmail.com','5d85e39972dda93ad56a7c4697c25e52c481667d42ec3da1831a8323',1,NULL,NULL,'2026-03-01 11:45:00'),(13,'5125550205','Soggy','Gigglenoodle','sogwaff','soggygigglenoodle@gmail.com','1ea30687f3f2b94bbb7ec553c4b9d6fd0c0c0accffda7e6ce70d0ae4',0,NULL,NULL,'2026-03-01 12:00:00'),(14,'5125550206','Grease','Gigglechunk','greasemc','greasegigglechunk@gmail.com','eb4b19792f4aeb780bc5a0f98d31e510b3479d7c0e566a330d4fec49',0,NULL,NULL,'2026-03-01 12:15:00'),(15,'5125550207','Wiggles','Gigglepants','wigglefunk','wigglesgigglepants@gmail.com','f6890f6e78029659e9f65d1c41faccba06b96c8818e2553e0fa7f425',0,NULL,NULL,'2026-03-01 12:30:00'),(16,'5125550208','Cheddar','Gigglecheese','chedblast','cheddargigglecheese@gmail.com','6c95d9fba357468220b1305a5593e78da8eabecbf5039fb9214b06aa',0,NULL,NULL,'2026-03-01 12:45:00'),(17,'5125551000','Rex','Gigglefart','rexhar','rexgigglefart@gmail.com','915ff5a2d51fe69d6c948bb6b2a77835b29c30dc00aad8e2c8a372e9',1,NULL,NULL,'2026-03-15 08:00:00'),(18,'5125551001','Nadia','Giggler','nadiavos','nadiagiggler@gmail.com','2045d6530c48dadf94cf7ffc785cede6b680b602f376ac483e402253',1,NULL,NULL,'2026-03-15 08:00:00'),(19,'5125551002','Colt','Giggleblast','coltbla','coltgiggleblast@gmail.com','adac97622b6281379ce628e0f4d4c31c482a1c4074c5ac1b2c413c7e',1,NULL,NULL,'2026-03-15 08:00:00'),(20,'5125551003','Inez','Gigglesnort','inezfer','inezgigglesnort@gmail.com','93d83c88cd84efbebf28f15f185ab4c909e75bf52560740bf3f8423d',1,NULL,NULL,'2026-03-15 08:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-31 22:09:46
