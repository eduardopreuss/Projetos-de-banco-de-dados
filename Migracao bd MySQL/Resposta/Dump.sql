CREATE DATABASE  IF NOT EXISTS `teste_selecao` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `teste_selecao`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: teste_selecao
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.10-MariaDB

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
-- Table structure for table `cores`
--

DROP TABLE IF EXISTS `cores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cores` (
  `titulo` varchar(50) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cores`
--

LOCK TABLES `cores` WRITE;
/*!40000 ALTER TABLE `cores` DISABLE KEYS */;
INSERT INTO `cores` VALUES ('Azul',1),('Branco',2),('Preto',3),('Vermelho',4);
/*!40000 ALTER TABLE `cores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dados_antigos`
--

DROP TABLE IF EXISTS `dados_antigos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dados_antigos` (
  `codigo` varchar(100) DEFAULT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `cor` varchar(50) DEFAULT NULL,
  `tamanho` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dados_antigos`
--

LOCK TABLES `dados_antigos` WRITE;
/*!40000 ALTER TABLE `dados_antigos` DISABLE KEYS */;
INSERT INTO `dados_antigos` VALUES ('100','Sapato Verão 2014','Branco','33'),('100','Sapato Verão 2014','Branco','34'),('100','Sapato Verão 2014','Branco','35'),('100','Sapato Verão 2014','Azul','33'),('100','Sapato Verão 2014','Azul','34'),('100','Sapato Verão 2014','Azul','35'),('120','Tênis Nike','Preto','36'),('120','Tênis Nike','Preto','37'),('120','Tênis Nike','Preto','38'),('120','Tênis Nike','Vermelho','36'),('120','Tênis Nike','Vermelho','37'),('120','Tênis Nike','Vermelho','38');
/*!40000 ALTER TABLE `dados_antigos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos` (
  `titulo` varchar(100) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES ('Sapato Verão 2014',1,'100'),('Tênis Nike',2,'120');
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_cores`
--

DROP TABLE IF EXISTS `produtos_cores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos_cores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_cor` int(11) DEFAULT NULL,
  `id_produto` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cor` (`id_cor`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `produtos_cores_ibfk_1` FOREIGN KEY (`id_cor`) REFERENCES `cores` (`id`),
  CONSTRAINT `produtos_cores_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_cores`
--

LOCK TABLES `produtos_cores` WRITE;
/*!40000 ALTER TABLE `produtos_cores` DISABLE KEYS */;
INSERT INTO `produtos_cores` VALUES (1,1,1),(2,2,1),(3,3,2),(4,4,2);
/*!40000 ALTER TABLE `produtos_cores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_tamanhos`
--

DROP TABLE IF EXISTS `produtos_tamanhos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos_tamanhos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_produto_cor` int(11) DEFAULT NULL,
  `id_tamanho` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_produto_cor` (`id_produto_cor`),
  KEY `id_tamanho` (`id_tamanho`),
  CONSTRAINT `produtos_tamanhos_ibfk_1` FOREIGN KEY (`Id_produto_cor`) REFERENCES `produtos_cores` (`Id`),
  CONSTRAINT `produtos_tamanhos_ibfk_2` FOREIGN KEY (`id_tamanho`) REFERENCES `tamanhos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_tamanhos`
--

LOCK TABLES `produtos_tamanhos` WRITE;
/*!40000 ALTER TABLE `produtos_tamanhos` DISABLE KEYS */;
INSERT INTO `produtos_tamanhos` VALUES (1,1,1),(2,2,1),(3,1,2),(4,2,2),(5,1,3),(6,2,3),(7,3,4),(8,4,4),(9,3,5),(10,4,5),(11,3,6),(12,4,6);
/*!40000 ALTER TABLE `produtos_tamanhos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tamanhos`
--

DROP TABLE IF EXISTS `tamanhos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tamanhos` (
  `titulo` varchar(50) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tamanhos`
--

LOCK TABLES `tamanhos` WRITE;
/*!40000 ALTER TABLE `tamanhos` DISABLE KEYS */;
INSERT INTO `tamanhos` VALUES ('33',1),('34',2),('35',3),('36',4),('37',5),('38',6);
/*!40000 ALTER TABLE `tamanhos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-17  3:02:35
