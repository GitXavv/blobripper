-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 10 juil. 2025 à 23:33
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `blobsweeper`
--

-- --------------------------------------------------------

--
-- Structure de la table `scores`
--

DROP TABLE IF EXISTS `scores`;
CREATE TABLE IF NOT EXISTS `scores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `score` int NOT NULL,
  `frequency` varchar(50) NOT NULL,
  `turns` varchar(50) NOT NULL,
  `lives` int NOT NULL,
  `mods` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'None',
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_elapsed` int NOT NULL DEFAULT '0',
  `pf_dodges` int NOT NULL DEFAULT '0',
  `tot_moves` int NOT NULL DEFAULT '0',
  `die_halt` int NOT NULL DEFAULT '0',
  `survival_halt` int NOT NULL DEFAULT '0',
  `lost_score` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Password is crypted',
  `q_confirm` varchar(255) NOT NULL COMMENT 'When logging in to this account, this question is asked to confirm the ownership.',
  `a_confirm` varchar(255) NOT NULL COMMENT 'Answer the question successfully and you will log to the account successfully.',
  `q1` varchar(255) NOT NULL COMMENT 'A "Forgot your password?" question.',
  `a1` varchar(255) NOT NULL COMMENT 'The question must be answered correctly to gain access to the account. etc for the other two questions. Answers are crypted.',
  `q2` varchar(255) NOT NULL,
  `a2` varchar(255) NOT NULL,
  `q3` varchar(255) NOT NULL,
  `a3` varchar(255) NOT NULL,
  `logins` int NOT NULL DEFAULT '1',
  `date_creation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
