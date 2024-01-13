-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema GoodReadsDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema GoodReadsDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `GoodReadsDB` DEFAULT CHARACTER SET utf8 ;
USE `GoodReadsDB` ;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`address` (
  `adress_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `town_name` VARCHAR(45) NULL,
  `region_code` INT NULL,
  `zip_code` CHAR(45) NULL,
  `country_name` VARCHAR(45) NULL,
  PRIMARY KEY (`adress_id`),
  UNIQUE INDEX `town_id_UNIQUE` (`adress_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`privacy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`privacy` (
  `privacy_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `view_profile` CHAR(1) NOT NULL,
  `can_non_friends_follow` TINYINT NOT NULL,
  `can_non_friends_comment` TINYINT NOT NULL,
  `can_display_reviews` TINYINT NOT NULL,
  `private_messages` TINYINT NOT NULL,
  `is_email_visible` TINYINT NOT NULL,
  `allow_search_by_email` TINYINT NOT NULL,
  `challenge_question` TINYTEXT NULL,
  `prompt_to_recommend_books` TINYINT NOT NULL,
  UNIQUE INDEX `user_id_UNIQUE` (`privacy_id` ASC) VISIBLE,
  PRIMARY KEY (`privacy_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `is_admin` TINYINT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` NVARCHAR(150) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `photo_url` VARCHAR(150) NULL,
  `gender` VARCHAR(1) NULL,
  `username` VARCHAR(45) NULL,
  `show_last_name` TINYINT NOT NULL DEFAULT 0,
  `is_reverse_name_order` TINYINT NOT NULL DEFAULT 0,
  `gender_viewable_by` CHAR(1) NOT NULL,
  `location_viewable_by` CHAR(1) NOT NULL,
  `date_of_birth` DATE NULL,
  `web_site` VARCHAR(200) NULL,
  `interests` TINYTEXT NULL,
  `books_preferences` TINYTEXT NULL,
  `about_me` TINYTEXT NULL,
  `adress_id` INT UNSIGNED NOT NULL,
  `privacy_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  INDEX `town_id_idx` (`adress_id` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  INDEX `privacy_id_fk_idx` (`privacy_id` ASC) VISIBLE,
  UNIQUE INDEX `privacy_id_UNIQUE` (`privacy_id` ASC) VISIBLE,
  CONSTRAINT `u_adress_id_fk_cnstr`
    FOREIGN KEY (`adress_id`)
    REFERENCES `GoodReadsDB`.`address` (`adress_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `u_privacy_id_fk_cnstr`
    FOREIGN KEY (`privacy_id`)
    REFERENCES `GoodReadsDB`.`privacy` (`privacy_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_have_friends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_have_friends` (
  `user_id` INT UNSIGNED NOT NULL,
  `friend_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx1` (`user_id` ASC) VISIBLE,
  INDEX `friend_id_idx` (`friend_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`, `friend_id`),
  CONSTRAINT `uhf_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `uhf_friend_id_cnstr`
    FOREIGN KEY (`friend_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`genres` (
  `genre_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `genre_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE INDEX `genre_id_UNIQUE` (`genre_id` ASC) VISIBLE,
  UNIQUE INDEX `genre_name_UNIQUE` (`genre_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`languages` (
  `language_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `language` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE INDEX `language_id_UNIQUE` (`language_id` ASC) VISIBLE,
  UNIQUE INDEX `languag_UNIQUE` (`language` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`books` (
  `book_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `genre_id` INT UNSIGNED NOT NULL,
  `description` MEDIUMTEXT NOT NULL,
  `pages` INT UNSIGNED NOT NULL,
  `ISBN` VARCHAR(15) NOT NULL,
  `original_title` VARCHAR(100) NOT NULL,
  `language_id` INT UNSIGNED NOT NULL,
  `publish_date` DATE NOT NULL,
  `publisher` TEXT(100) NOT NULL,
  `cover_url` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE INDEX `book_id_UNIQUE` (`book_id` ASC) VISIBLE,
  UNIQUE INDEX `ISBN_UNIQUE` (`ISBN` ASC) VISIBLE,
  INDEX `genre_id_idx` (`genre_id` ASC) VISIBLE,
  INDEX `language_id_idx` (`language_id` ASC) VISIBLE,
  CONSTRAINT `b_genre_id_cnstr`
    FOREIGN KEY (`genre_id`)
    REFERENCES `GoodReadsDB`.`genres` (`genre_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `b_language_id_cnstr`
    FOREIGN KEY (`language_id`)
    REFERENCES `GoodReadsDB`.`languages` (`language_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`authors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`authors` (
  `author_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `author_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`author_id`),
  UNIQUE INDEX `author_id_UNIQUE` (`author_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`books_have_authors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`books_have_authors` (
  `book_id` INT UNSIGNED NOT NULL,
  `author_id` INT UNSIGNED NOT NULL,
  INDEX `book_id_idx` (`book_id` ASC) VISIBLE,
  INDEX `author_id_idx` (`author_id` ASC) VISIBLE,
  PRIMARY KEY (`book_id`, `author_id`),
  CONSTRAINT `bha_book_id_cnstr`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `bha_author_id_cnstr`
    FOREIGN KEY (`author_id`)
    REFERENCES `GoodReadsDB`.`authors` (`author_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`books_have_editions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`books_have_editions` (
  `book_id` INT UNSIGNED NOT NULL,
  `edition_id` INT UNSIGNED NOT NULL,
  INDEX `book_id_idx` (`book_id` ASC) VISIBLE,
  INDEX `edition_id_idx` (`edition_id` ASC) VISIBLE,
  PRIMARY KEY (`book_id`, `edition_id`),
  CONSTRAINT `bhe_book_id_cnstr`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `bhe_edition_id_cnstr`
    FOREIGN KEY (`edition_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`reviews` (
  `review_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `review` MEDIUMTEXT NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `review_date` DATE NOT NULL,
  PRIMARY KEY (`review_id`),
  UNIQUE INDEX `review_id_UNIQUE` (`review_id` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `book_id_idx` (`book_id` ASC) VISIBLE,
  CONSTRAINT `r_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `r_book_id_cnstr`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`ratings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`ratings` (
  `rating_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rating` INT NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`rating_id`),
  UNIQUE INDEX `rating_id_UNIQUE` (`rating_id` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `book_id_idx` (`book_id` ASC) VISIBLE,
  CONSTRAINT `rat_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `rat_book_id_cnstr`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`bookshelves`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`bookshelves` (
  `bookshelf_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bookshelf_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_have_books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_have_books` (
  `user_id` INT UNSIGNED NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `bookshelf_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `book_id_idx` (`book_id` ASC) VISIBLE,
  INDEX `bookshelf_id_idx` (`bookshelf_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`, `book_id`),
  CONSTRAINT `uhb_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `uhb_book_id_cnstr`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `uhb_bookshelf_id_cnstr`
    FOREIGN KEY (`bookshelf_id`)
    REFERENCES `GoodReadsDB`.`bookshelves` (`bookshelf_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`messages` (
  `message_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_id` INT UNSIGNED NOT NULL,
  `receiver_id` INT UNSIGNED NOT NULL,
  `sent_at` DATE NOT NULL,
  `is_read` TINYINT NOT NULL,
  `receiver_folder` CHAR(5) NOT NULL,
  PRIMARY KEY (`message_id`),
  INDEX `sender_id_idx` (`sender_id` ASC) VISIBLE,
  INDEX `receiver_id_idx` (`receiver_id` ASC) VISIBLE,
  CONSTRAINT `m_sender_id_cnstr`
    FOREIGN KEY (`sender_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `m_receiver_id_cnstr`
    FOREIGN KEY (`receiver_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`quotes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`quotes` (
  `quote_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quote` TEXT(50) NOT NULL,
  `author_id` INT UNSIGNED NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `tags` TEXT(10) NULL,
  PRIMARY KEY (`quote_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `author_id_idx` (`author_id` ASC) VISIBLE,
  CONSTRAINT `q_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `q_author_id_cnstr`
    FOREIGN KEY (`author_id`)
    REFERENCES `GoodReadsDB`.`authors` (`author_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_like_quotes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_like_quotes` (
  `quote_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `quote_id_idx` (`quote_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`, `quote_id`),
  CONSTRAINT `ulq_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ulq_quote_id_cnstr`
    FOREIGN KEY (`quote_id`)
    REFERENCES `GoodReadsDB`.`quotes` (`quote_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_like_genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_like_genres` (
  `user_id` INT UNSIGNED NOT NULL,
  `genre_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `genre_id_idx` (`genre_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`, `genre_id`),
  CONSTRAINT `ulg_user_id_cnstr`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ulg_genre_id_cnstr`
    FOREIGN KEY (`genre_id`)
    REFERENCES `GoodReadsDB`.`genres` (`genre_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GoodReadsDB`.`reading_challenge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`reading_challenge` (
  `participant_id` INT UNSIGNED NOT NULL,
  `books_goal` INT UNSIGNED NOT NULL,
  INDEX `participant_id_idx` (`participant_id` ASC) VISIBLE,
  PRIMARY KEY (`participant_id`),
  CONSTRAINT `rch_participant_id_cnstr`
    FOREIGN KEY (`participant_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
