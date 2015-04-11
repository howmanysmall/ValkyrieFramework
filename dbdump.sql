-- MySQL dump 10.13  Distrib 5.5.41, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: valkyrie_engine
-- ------------------------------------------------------
-- Server version	5.5.41-0ubuntu1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `achievements_template`
--

DROP TABLE IF EXISTS `achievements_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `achievements_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `achv_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `reward` int(11) NOT NULL,
  `icon` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achievements_template`
--

LOCK TABLES `achievements_template` WRITE;
/*!40000 ALTER TABLE `achievements_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `achievements_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `achievements_test`
--

DROP TABLE IF EXISTS `achievements_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `achievements_test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `achv_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `reward` int(11) NOT NULL,
  `icon` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achievements_test`
--

LOCK TABLES `achievements_test` WRITE;
/*!40000 ALTER TABLE `achievements_test` DISABLE KEYS */;
INSERT INTO `achievements_test` VALUES (1,'basic_bronze','Basic Bronze Achievement','This achievement is awarded to you once you complete the first quest.\n\n    Should not be challenging at all!',1,231496690),(2,'basic_bronze_master','Epic Bronze Achievement','The super duper achievement!!',2,186253727);
/*!40000 ALTER TABLE `achievements_test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bans`
--

DROP TABLE IF EXISTS `bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `from_gid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bans`
--

LOCK TABLES `bans` WRITE;
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
INSERT INTO `bans` VALUES (1,123456,'king u suk','test');
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friends_template`
--

DROP TABLE IF EXISTS `friends_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friends_template` (
  `id` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `verified` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends_template`
--

LOCK TABLES `friends_template` WRITE;
/*!40000 ALTER TABLE `friends_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `friends_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_ids`
--

DROP TABLE IF EXISTS `game_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_ids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gid` varchar(255) NOT NULL,
  `cokey` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_ids`
--

LOCK TABLES `game_ids` WRITE;
/*!40000 ALTER TABLE `game_ids` DISABLE KEYS */;
INSERT INTO `game_ids` VALUES (1,'test','testKey');
/*!40000 ALTER TABLE `game_ids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sent` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `gid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (2,1425405860,'261','Good morning, world, and all who inhabit it!','');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meta_template`
--

DROP TABLE IF EXISTS `meta_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta_template`
--

LOCK TABLES `meta_template` WRITE;
/*!40000 ALTER TABLE `meta_template` DISABLE KEYS */;
INSERT INTO `meta_template` VALUES (1,'usedReward','0');
/*!40000 ALTER TABLE `meta_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meta_test`
--

DROP TABLE IF EXISTS `meta_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta_test`
--

LOCK TABLES `meta_test` WRITE;
/*!40000 ALTER TABLE `meta_test` DISABLE KEYS */;
INSERT INTO `meta_test` VALUES (1,'usedReward','3'),(3,'usedSpace','22'),(4,'name','Testing Game');
/*!40000 ALTER TABLE `meta_test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_achv_36537369`
--

DROP TABLE IF EXISTS `player_achv_36537369`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_achv_36537369` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `achvid` varchar(255) NOT NULL,
  `gid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_achv_36537369`
--

LOCK TABLES `player_achv_36537369` WRITE;
/*!40000 ALTER TABLE `player_achv_36537369` DISABLE KEYS */;
INSERT INTO `player_achv_36537369` VALUES (1,'basic_bronze','test'),(2,'basic_bronze_master','test');
/*!40000 ALTER TABLE `player_achv_36537369` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_achv_999`
--

DROP TABLE IF EXISTS `player_achv_999`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_achv_999` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `achvid` varchar(255) NOT NULL,
  `gid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_achv_999`
--

LOCK TABLES `player_achv_999` WRITE;
/*!40000 ALTER TABLE `player_achv_999` DISABLE KEYS */;
INSERT INTO `player_achv_999` VALUES (1,'basic_bronze','test');
/*!40000 ALTER TABLE `player_achv_999` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_achv_template`
--

DROP TABLE IF EXISTS `player_achv_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_achv_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `achvid` varchar(255) NOT NULL,
  `gid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_achv_template`
--

LOCK TABLES `player_achv_template` WRITE;
/*!40000 ALTER TABLE `player_achv_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_achv_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_info`
--

DROP TABLE IF EXISTS `player_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `time_ingame` int(11) NOT NULL,
  `joined` int(11) NOT NULL,
  `last_online` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_info`
--

LOCK TABLES `player_info` WRITE;
/*!40000 ALTER TABLE `player_info` DISABLE KEYS */;
INSERT INTO `player_info` VALUES (1,36537369,999,1427639731,1427639752),(2,27578143,0,1427649824,0);
/*!40000 ALTER TABLE `player_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_ingame`
--

DROP TABLE IF EXISTS `player_ingame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_ingame` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `gid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_ingame`
--

LOCK TABLES `player_ingame` WRITE;
/*!40000 ALTER TABLE `player_ingame` DISABLE KEYS */;
INSERT INTO `player_ingame` VALUES (4,27578143,'test');
/*!40000 ALTER TABLE `player_ingame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trusted_users_template`
--

DROP TABLE IF EXISTS `trusted_users_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trusted_users_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `connection_key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trusted_users_template`
--

LOCK TABLES `trusted_users_template` WRITE;
/*!40000 ALTER TABLE `trusted_users_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `trusted_users_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trusted_users_test`
--

DROP TABLE IF EXISTS `trusted_users_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trusted_users_test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `connection_key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trusted_users_test`
--

LOCK TABLES `trusted_users_test` WRITE;
/*!40000 ALTER TABLE `trusted_users_test` DISABLE KEYS */;
INSERT INTO `trusted_users_test` VALUES (1,999,'testKey'),(2,36537369,'test'),(3,65765854,'test');
/*!40000 ALTER TABLE `trusted_users_test` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-12  0:16:35
