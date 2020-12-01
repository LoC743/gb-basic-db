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
