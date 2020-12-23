-- ---------------------------- Задание 1 ---------------------------------------- 
-- Создание бд
CREATE DATABASE interview;

-- Создание таблицы пользователей
CREATE TABLE `interview`.`_user` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone` VARCHAR(15) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `first_name` VARCHAR(150) NOT NULL,
    `last_name` VARCHAR(150) NOT NULL,
    `birthday` DATETIME NOT NULL,
    `gender` TINYINT NOT NULL,
    `description` TEXT NOT NULL,
    `last_location` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`)
);

-- Создание таблицы лайков
CREATE TABLE `interview`.`likes` (
    `id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `target_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `target_id_idx` (`target_id` ASC) VISIBLE,
    INDEX `fk_user_id_idx` (`user_id` ASC) VISIBLE,
    CONSTRAINT `fk_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `interview`.`_user` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_target_id`
        FOREIGN KEY (`target_id`)
        REFERENCES `interview`.`_user` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION);

-- Создание таблицы взаимных лайков(совпадений)
CREATE TABLE `interview`.`matches` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_user_id` INT NOT NULL,
    `second_user_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_first_user_id_idx` (`first_user_id` ASC) VISIBLE,
    INDEX `fk_second_user_id_idx` (`second_user_id` ASC) VISIBLE,
    CONSTRAINT `fk_first_user_id`
        FOREIGN KEY (`first_user_id`)
        REFERENCES `interview`.`_user` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_second_user_id`
        FOREIGN KEY (`second_user_id`)
        REFERENCES `interview`.`_user` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION);

-- ---------------------------- Задание 3 ---------------------------------------- 
-- Создание таблицы изображений
CREATE TABLE `interview`.`photo` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `owner_id` INT NOT NULL,
    `url` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_owner_id_idx` (`owner_id` ASC) VISIBLE,
    CONSTRAINT `fk_owner_id`
        FOREIGN KEY (`owner_id`)
        REFERENCES `interview`.`_user` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION);

-- Создание таблицы комментариев
CREATE TABLE `interview`.`comments` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `target_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `text` TEXT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_target_id_idx` (`target_id` ASC) VISIBLE,
    INDEX `fk_user_id_idx` (`user_id` ASC) VISIBLE,
    CONSTRAINT `fk_comments_target_id`
        FOREIGN KEY (`target_id`)
        REFERENCES `interview`.`photo` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_comments_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `interview`.`_user` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION);

-- Изменения таблицы Likes для изображений и комментариев
ALTER TABLE `interview`.`likes` 
DROP FOREIGN KEY `fk_target_id`;
ALTER TABLE `interview`.`likes` 
ADD COLUMN `photo_target_id` INT NULL AFTER `target_id`,
ADD COLUMN `comment_target_id` INT NULL AFTER `photo_target_id`,
ADD COLUMN `type` VARCHAR(20) NOT NULL AFTER `comment_target_id`,
CHANGE COLUMN `target_id` `target_id` INT NULL ,
ADD INDEX `fk_likes_photo_target_id_idx` (`photo_target_id` ASC) VISIBLE,
ADD INDEX `fk_likes_comments_target_id_idx` (`comment_target_id` ASC) VISIBLE;
;
ALTER TABLE `interview`.`likes` 
ADD CONSTRAINT `fk_target_id`
  FOREIGN KEY (`target_id`)
  REFERENCES `interview`.`_user` (`id`),
ADD CONSTRAINT `fk_likes_photo_target_id`
  FOREIGN KEY (`photo_target_id`)
  REFERENCES `interview`.`photo` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_likes_comment_target_id`
  FOREIGN KEY (`comment_target_id`)
  REFERENCES `interview`.`comments` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


-- Триггер, чтоб не создавалось 2 записи под 1 лайк
DROP TRIGGER IF EXISTS `interview`.`likes_BEFORE_INSERT`;

DELIMITER $$
USE `interview`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `likes_BEFORE_INSERT` BEFORE INSERT ON `likes` FOR EACH ROW BEGIN
IF EXISTS (
    SELECT 1 FROM interview.likes
    where (type = "photo" and target_id = NEW.photo_target_id and user_id = NEW.user_id)
    OR (type = "comment" and target_id = NEW.comment_target_id and user_id = NEW.user_id)
    OR (type = "user" and target_id = NEW.target_id and user_id = NEW.user_id)
    ) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Error: You can't like this item twice.";
end if;
END$$
DELIMITER ;


-- Для добавления в таблицы
-- insert into _user (id, first_name, last_name) VALUES (1, "Jon", "Sandman");
-- insert into _user (id, first_name, last_name) VALUES (2, "Sam", "Madman");
-- insert into _user (id, first_name, last_name) VALUES (3, "Test", "Anykey");
-- insert into _user (id, first_name, last_name) VALUES (4, "Brute", "Force");
-- insert into _user (id, first_name, last_name) VALUES (5, "Ken", "Block");
-- insert into _user (id, first_name, last_name) VALUES (6, "Box", "Kojima");

-- insert into likes values (1, 1, 2);
-- insert into likes (id, user_id, target_id, type) values (8, 4, 5, "user");
-- DELETE FROM likes WHERE user_id = 4 AND target_id = 5 AND type = "user";
-- insert into likes values (3, 4, 2);
-- insert into likes values (4, 4, 3); 
-- insert into likes values (5, 6, 2);
-- insert into likes values (6, 6, 3);