SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema GoodReadsDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `GoodReadsDB` ;

-- -----------------------------------------------------
-- Schema GoodReadsDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `GoodReadsDB` DEFAULT CHARACTER SET utf8 ;
USE `GoodReadsDB` ;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`users` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `is_admin` TINYINT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` NVARCHAR(150) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NULL,
  `photo_url` VARCHAR(150) NULL,
  `gender` VARCHAR(1) NULL,
  `username` VARCHAR(45) NULL,
  `date_of_birth` DATE NULL,
  `books_preferences` TINYTEXT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `unique_email` (`email` ASC),
  UNIQUE INDEX `unique_user_id` (`user_id` ASC),
  UNIQUE INDEX `unique_username` (`username` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`genres` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`genres` (
  `genre_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `genre_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE INDEX `unique_genre_id` (`genre_id` ASC),
  UNIQUE INDEX `unique_genre_name` (`genre_name` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`languages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`languages` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`languages` (
  `language_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `language` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE INDEX `unique_language_id` (`language_id` ASC),
  UNIQUE INDEX `unique_language` (`language` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`books`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`books` ;

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
  UNIQUE INDEX `unique_book_id` (`book_id` ASC),
  UNIQUE INDEX `unique_ISBN` (`ISBN` ASC),
  INDEX `genre_id_idx` (`genre_id` ASC),
  INDEX `language_id_idx` (`language_id` ASC),
  CONSTRAINT `fk_genre_id_book`
    FOREIGN KEY (`genre_id`)
    REFERENCES `GoodReadsDB`.`genres` (`genre_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_language_id_book`
    FOREIGN KEY (`language_id`)
    REFERENCES `GoodReadsDB`.`languages` (`language_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`authors` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`authors` (
  `author_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `author_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`author_id`),
  UNIQUE INDEX `unique_author_id` (`author_id` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`books_have_authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`books_have_authors` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`books_have_authors` (
  `book_id` INT UNSIGNED NOT NULL,
  `author_id` INT UNSIGNED NOT NULL,
  INDEX `book_id_idx` (`book_id` ASC),
  INDEX `author_id_idx` (`author_id` ASC),
  PRIMARY KEY (`book_id`, `author_id`),
  CONSTRAINT `fk_book_id_books_have_authors`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_author_id_books_have_authors`
    FOREIGN KEY (`author_id`)
    REFERENCES `GoodReadsDB`.`authors` (`author_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`reviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`reviews` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`reviews` (
  `review_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `review` MEDIUMTEXT NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `review_date` DATE NOT NULL,
  PRIMARY KEY (`review_id`),
  UNIQUE INDEX `unique_review_id` (`review_id` ASC),
  INDEX `user_id_idx` (`user_id` ASC),
  INDEX `book_id_idx` (`book_id` ASC),
  CONSTRAINT `fk_user_id_reviews`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_book_id_reviews`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`ratings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`ratings` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`ratings` (
  `rating_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rating` INT NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`rating_id`),
  UNIQUE INDEX `unique_rating_id` (`rating_id` ASC),
  INDEX `user_id_idx` (`user_id` ASC),
  INDEX `book_id_idx` (`book_id` ASC),
  CONSTRAINT `fk_user_id_ratings`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_book_id_ratings`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`bookshelves`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`bookshelves` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`bookshelves` (
  `bookshelf_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bookshelf_id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_have_books`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`users_have_books` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_have_books` (
  `user_id` INT UNSIGNED NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `bookshelf_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC),
  INDEX `book_id_idx` (`book_id` ASC),
  INDEX `bookshelf_id_idx` (`bookshelf_id` ASC),
  PRIMARY KEY (`user_id`, `book_id`),
  CONSTRAINT `fk_user_id_users_have_books`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_book_id_users_have_books`
    FOREIGN KEY (`book_id`)
    REFERENCES `GoodReadsDB`.`books` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bookshelf_id_users_have_books`
    FOREIGN KEY (`bookshelf_id`)
    REFERENCES `GoodReadsDB`.`bookshelves` (`bookshelf_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`quotes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`quotes` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`quotes` (
  `quote_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quote` TEXT(50) NOT NULL,
  `author_id` INT UNSIGNED NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `tags` TEXT(10) NULL,
  PRIMARY KEY (`quote_id`),
  INDEX `user_id_idx` (`user_id` ASC),
  INDEX `author_id_idx` (`author_id` ASC),
  CONSTRAINT `fk_user_id_quotes`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_author_id_quotes`
    FOREIGN KEY (`author_id`)
    REFERENCES `GoodReadsDB`.`authors` (`author_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_like_quotes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`users_like_quotes` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_like_quotes` (
  `quote_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC),
  INDEX `quote_id_idx` (`quote_id` ASC),
  PRIMARY KEY (`user_id`, `quote_id`),
  CONSTRAINT `fk_user_id_users_like_quotes`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quote_id_users_like_quotes`
    FOREIGN KEY (`quote_id`)
    REFERENCES `GoodReadsDB`.`quotes` (`quote_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `GoodReadsDB`.`users_like_genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GoodReadsDB`.`users_like_genres` ;

CREATE TABLE IF NOT EXISTS `GoodReadsDB`.`users_like_genres` (
  `user_id` INT UNSIGNED NOT NULL,
  `genre_id` INT UNSIGNED NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC),
  INDEX `genre_id_idx` (`genre_id` ASC),
  PRIMARY KEY (`user_id`, `genre_id`),
  CONSTRAINT `fk_user_id_users_like_genres`
    FOREIGN KEY (`user_id`)
    REFERENCES `GoodReadsDB`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_genre_id_users_like_genres`
    FOREIGN KEY (`genre_id`)
    REFERENCES `GoodReadsDB`.`genres` (`genre_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
