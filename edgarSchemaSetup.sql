CREATE DATABASE  IF NOT EXISTS `edgar` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `edgar`;
-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: edgar
-- ------------------------------------------------------
-- Server version	5.7.29-log

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
-- Table structure for table `cusip_cik_ref`
--

DROP TABLE IF EXISTS `cusip_cik_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cusip_cik_ref` (
  `cusip` varchar(9) NOT NULL,
  `cik` int(11) NOT NULL,
  `shares` decimal(13,0) DEFAULT NULL,
  PRIMARY KEY (`cusip`,`cik`),
  KEY `pk_cusip` (`cusip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cusip_total`
--

DROP TABLE IF EXISTS `cusip_total`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cusip_total` (
  `cusip` varchar(9) NOT NULL,
  `total` decimal(13,0) DEFAULT NULL,
  `ticker` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`cusip`),
  UNIQUE KEY `cusip_UNIQUE` (`cusip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oscore`
--

DROP TABLE IF EXISTS `oscore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oscore` (
  `cusip_x` varchar(9) NOT NULL,
  `cusip_y` varchar(9) NOT NULL,
  `oscore` decimal(5,3) DEFAULT NULL,
  PRIMARY KEY (`cusip_x`,`cusip_y`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `raw_data`
--

DROP TABLE IF EXISTS `raw_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raw_data` (
  `cik` int(11) DEFAULT NULL,
  `name_of_issuer` varchar(255) DEFAULT NULL,
  `title_of_class` varchar(100) DEFAULT NULL,
  `cusip` varchar(9) DEFAULT NULL,
  `value` decimal(15,2) DEFAULT NULL,
  `shrs_or_prn_amt` decimal(15,2) DEFAULT NULL,
  `shrs_or_prn_amt_type` varchar(20) DEFAULT NULL,
  `put_call` varchar(5) DEFAULT NULL,
  `investment_discretion` varchar(45) DEFAULT NULL,
  `other_manager` varchar(45) DEFAULT NULL,
  `voting_authority_sole` int(11) DEFAULT NULL,
  `voting_authority_shared` int(11) DEFAULT NULL,
  `voting_authority_none` int(11) DEFAULT NULL,
  KEY `pk_cik` (`cik`,`cusip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `raw_data_daily`
--

DROP TABLE IF EXISTS `raw_data_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raw_data_daily` (
  `cik` int(11) DEFAULT NULL,
  `name_of_issuer` varchar(255) DEFAULT NULL,
  `title_of_class` varchar(100) DEFAULT NULL,
  `cusip` varchar(9) DEFAULT NULL,
  `value` decimal(15,2) DEFAULT NULL,
  `shrs_or_prn_amt` decimal(15,2) DEFAULT NULL,
  `shrs_or_prn_amt_type` varchar(20) DEFAULT NULL,
  `put_call` varchar(5) DEFAULT NULL,
  `investment_discretion` varchar(45) DEFAULT NULL,
  `other_manager` varchar(45) DEFAULT NULL,
  `voting_authority_sole` int(11) DEFAULT NULL,
  `voting_authority_shared` int(11) DEFAULT NULL,
  `voting_authority_none` int(11) DEFAULT NULL,
  KEY `pk_cik` (`cik`,`cusip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticker_cusip_ref`
--

DROP TABLE IF EXISTS `ticker_cusip_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticker_cusip_ref` (
  `ticker` varchar(5) NOT NULL,
  `cusip` varchar(9) DEFAULT NULL,
  PRIMARY KEY (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'edgar'
--
/*!50003 DROP PROCEDURE IF EXISTS `daily_reload` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `daily_reload`()
BEGIN
	delete from raw_data where (cik,cusip) in (
		select cik,cusip from raw_data_daily
	);
    
    insert into raw_data select * from raw_data_daily;
    
    
    truncate cusip_cik_ref;
    insert into cusip_cik_ref
	select distinct cusip, cik, SUM(distinct shrs_or_prn_amt)
    from raw_data
    group by 1,2
    order by 1,2;
    
    
	truncate oscore;
    insert into oscore
	select distinct a.cusip, b.cusip, 
		(SELECT sum(d.shares)
							  FROM cusip_cik_ref d, cusip_cik_ref e
                              WHERE d.cusip = a.cusip
                              and d.cik = e.cik
                              and e.cusip = b.cusip
                              ) /
			a.total
	from cusip_total a, cusip_total b
    where a.cusip != b.cusip;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_oscore` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_oscore`(l_cusip_x VARCHAR(9))
BEGIN
	select a.cusip_x, a.cusip_y, a.oscore, 
		b.total AS total_x, c.total AS total_y,
        d.ticker as ticker_x, e.ticker as ticker_y
	from oscore a, cusip_total b, cusip_total c,
    ticker_cusip_ref d, ticker_cusip_ref e
	where a.cusip_x = b.cusip
    and a.cusip_x = d.cusip
	and a.cusip_y = c.cusip
    and a.cusip_y = e.cusip
	and a.cusip_x = l_cusip_x 
	order by a.oscore desc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-16  8:50:15
