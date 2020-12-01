CREATE TABLE `Country` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `capital` varchar(45) DEFAULT NULL,
  `currency` varchar(45) DEFAULT NULL,
  `native` varchar(45) DEFAULT NULL,
  `region` varchar(45) DEFAULT NULL,
  `subregion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `State` (
  `id` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `country_id` int NOT NULL,
  `country_code` varchar(45) DEFAULT NULL,
  `state_code` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_state_country_id_idx` (`country_id`),
  CONSTRAINT `fk_state_country_id` FOREIGN KEY (`country_id`) REFERENCES `Country` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
