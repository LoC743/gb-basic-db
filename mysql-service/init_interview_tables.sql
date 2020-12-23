CREATE DATABASE interview;


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
