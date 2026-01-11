-- ==========================================================
-- PROJET : GESTION ACADÉMIQUE - BASE DE DONNÉES UNIVERSITÉ
-- GÉNÉRÉ LE : 2026-01-11
-- VERSION DU SCHÉMA : 2.0_SECURE
-- ==========================================================

/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

-- ------------------------------------------------------
-- 1. STRUCTURE DES ENTITÉS INDÉPENDANTES
-- ------------------------------------------------------

-- Structure : Table des Étudiants
DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE `etudiant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Structure : Table des Enseignants
DROP TABLE IF EXISTS `professeur`;
CREATE TABLE `professeur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `departement` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_prof_mail` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Structure : Catalogue des Matières
DROP TABLE IF EXISTS `cours`;
CREATE TABLE `cours` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(200) NOT NULL,
  `code` varchar(20) NOT NULL,
  `credits` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_code_matiere` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 2. STRUCTURE DES ENTITÉS DE LIAISON
-- ------------------------------------------------------

-- Structure : Planification des enseignements
DROP TABLE IF EXISTS `enseignement`;
CREATE TABLE `enseignement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cours_id` int NOT NULL,
  `professeur_id` int DEFAULT NULL,
  `semestre` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_module` FOREIGN KEY (`cours_id`) REFERENCES `cours` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_intervenant` FOREIGN KEY (`professeur_id`) REFERENCES `professeur` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Structure : Registre des Inscriptions
DROP TABLE IF EXISTS `inscription`;
CREATE TABLE `inscription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `etudiant_id` int NOT NULL,
  `enseignement_id` int NOT NULL,
  `date_inscription` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`etudiant_id`,`enseignement_id`),
  CONSTRAINT `fk_user` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiant` (`id`),
  CONSTRAINT `fk_session` FOREIGN KEY (`enseignement_id`) REFERENCES `enseignement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------
-- 3. INSERTION DES DONNÉES DE RÉFÉRENCE
-- ------------------------------------------------------

-- Data: COURS
INSERT INTO `cours` (`id`, `titre`, `code`, `credits`) VALUES 
(1,'Oracle','mfbk9350',5),
(2,'uml','classe',7),
(3,'Programmation avec Python','PY-INIT',3);

-- Data: PROFESSEUR
INSERT INTO `professeur` (`id`, `nom`, `email`, `departement`) VALUES 
(1,'Mohammed','mohammed@gmail.com','IA'),
(2,'Abdelaali','abdelaali@gmail.com','Web');

-- Data: ETUDIANT
INSERT INTO `etudiant` (`id`, `nom`, `email`) VALUES 
(1,'ayman','ayman@gmail.com'),
(2,'ali','ali@gmail.com');

-- Data: ENSEIGNEMENT
INSERT INTO `enseignement` (`id`, `cours_id`, `professeur_id`, `semestre`) VALUES 
(1,1,1,'S1'),
(2,2,2,'S2');

-- Data: INSCRIPTION
INSERT INTO `inscription` (`id`, `etudiant_id`, `enseignement_id`, `date_inscription`) VALUES 
(5,1,1,'2026-01-07'),
(6,2,2,'2026-07-07');

-- ------------------------------------------------------
-- 4. COUCHE LOGIQUE (VUES)
-- ------------------------------------------------------

-- Vue : Monitoring des charges de travail
CREATE OR REPLACE VIEW `vu_etudiant_charge` AS 
SELECT t1.nom, COUNT(t2.id) AS nb_inscriptions, SUM(t4.credits) AS somme_credits
FROM etudiant t1
LEFT JOIN inscription t2 ON t1.id = t2.etudiant_id
LEFT JOIN enseignement t3 ON t2.enseignement_id = t3.id
LEFT JOIN cours t4 ON t3.cours_id = t4.id
GROUP BY t1.id, t1.nom;

/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
-- FIN DU DUMP