-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ProductOrders
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ProductOrders
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ProductOrders` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema my_guitar_shop
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema my_guitar_shop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `my_guitar_shop` DEFAULT CHARACTER SET latin1 ;
USE `ProductOrders` ;

-- -----------------------------------------------------
-- Table `ProductOrders`.`Territories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ProductOrders`.`Territories` (
  `TerritoryID` INT NOT NULL AUTO_INCREMENT,
  `territory` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`TerritoryID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ProductOrders`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ProductOrders`.`Countries` (
  `CountryID` INT NOT NULL AUTO_INCREMENT,
  `Country` CHAR(2) NOT NULL,
  `TerritoryID` INT NOT NULL,
  PRIMARY KEY (`CountryID`),
  INDEX `TerritoryID_idx` (`TerritoryID` ASC) VISIBLE,
  CONSTRAINT `TerritoryID`
    FOREIGN KEY (`TerritoryID`)
    REFERENCES `ProductOrders`.`Territories` (`TerritoryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ProductOrders`.`Cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ProductOrders`.`Cities` (
  `CityID` INT NOT NULL AUTO_INCREMENT,
  `City` VARCHAR(50) NOT NULL,
  `State` CHAR(2) NOT NULL,
  `CountryID` INT NOT NULL,
  PRIMARY KEY (`CityID`),
  INDEX `CountryID_idx` (`CountryID` ASC) VISIBLE,
  CONSTRAINT `CountryID`
    FOREIGN KEY (`CountryID`)
    REFERENCES `ProductOrders`.`Countries` (`CountryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ProductOrders`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ProductOrders`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `CustomerName` VARCHAR(50) NOT NULL,
  `CustomerLastName` VARCHAR(50) NOT NULL,
  `Phone` CHAR(10) NOT NULL,
  `AddressLine1` VARCHAR(150) NOT NULL,
  `AddressLine2` VARCHAR(150) NULL,
  `PostalCode` CHAR(10) NOT NULL,
  `CityID` INT NULL,
  PRIMARY KEY (`CustomerID`),
  INDEX `CityID_idx` (`CityID` ASC) VISIBLE,
  CONSTRAINT `CityID`
    FOREIGN KEY (`CityID`)
    REFERENCES `ProductOrders`.`Cities` (`CityID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `my_guitar_shop` ;

-- -----------------------------------------------------
-- Table `my_guitar_shop`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`customers` (
  `customer_id` INT(11) NOT NULL AUTO_INCREMENT,
  `email_address` VARCHAR(255) NOT NULL,
  `password` VARCHAR(60) NOT NULL,
  `first_name` VARCHAR(60) NOT NULL,
  `last_name` VARCHAR(60) NOT NULL,
  `shipping_address_id` INT(11) NULL DEFAULT NULL,
  `billing_address_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email_address` (`email_address` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `my_guitar_shop`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`addresses` (
  `address_id` INT(11) NOT NULL AUTO_INCREMENT,
  `customer_id` INT(11) NOT NULL,
  `line1` VARCHAR(60) NOT NULL,
  `line2` VARCHAR(60) NULL DEFAULT NULL,
  `city` VARCHAR(40) NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `zip_code` VARCHAR(10) NOT NULL,
  `phone` VARCHAR(12) NOT NULL,
  `disabled` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`address_id`),
  INDEX `addresses_fk_customers` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `addresses_fk_customers`
    FOREIGN KEY (`customer_id`)
    REFERENCES `my_guitar_shop`.`customers` (`customer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `my_guitar_shop`.`administrators`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`administrators` (
  `admin_id` INT(11) NOT NULL AUTO_INCREMENT,
  `email_address` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`admin_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `my_guitar_shop`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`categories` (
  `category_id` INT(11) NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE INDEX `category_name` (`category_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `my_guitar_shop`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`orders` (
  `order_id` INT(11) NOT NULL AUTO_INCREMENT,
  `customer_id` INT(11) NOT NULL,
  `order_date` DATETIME NOT NULL,
  `ship_amount` DECIMAL(10,2) NOT NULL,
  `tax_amount` DECIMAL(10,2) NOT NULL,
  `ship_date` DATETIME NULL DEFAULT NULL,
  `ship_address_id` INT(11) NOT NULL,
  `card_type` VARCHAR(50) NOT NULL,
  `card_number` CHAR(16) NOT NULL,
  `card_expires` CHAR(7) NOT NULL,
  `billing_address_id` INT(11) NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `orders_fk_customers` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `orders_fk_customers`
    FOREIGN KEY (`customer_id`)
    REFERENCES `my_guitar_shop`.`customers` (`customer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `my_guitar_shop`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`products` (
  `product_id` INT(11) NOT NULL AUTO_INCREMENT,
  `category_id` INT(11) NOT NULL,
  `product_code` VARCHAR(10) NOT NULL,
  `product_name` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `list_price` DECIMAL(10,2) NOT NULL,
  `discount_percent` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `date_added` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE INDEX `product_code` (`product_code` ASC) VISIBLE,
  INDEX `products_fk_categories` (`category_id` ASC) VISIBLE,
  CONSTRAINT `products_fk_categories`
    FOREIGN KEY (`category_id`)
    REFERENCES `my_guitar_shop`.`categories` (`category_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `my_guitar_shop`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `my_guitar_shop`.`order_items` (
  `item_id` INT(11) NOT NULL AUTO_INCREMENT,
  `order_id` INT(11) NOT NULL,
  `product_id` INT(11) NOT NULL,
  `item_price` DECIMAL(10,2) NOT NULL,
  `discount_amount` DECIMAL(10,2) NOT NULL,
  `quantity` INT(11) NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `items_fk_orders` (`order_id` ASC) VISIBLE,
  INDEX `items_fk_products` (`product_id` ASC) VISIBLE,
  CONSTRAINT `items_fk_orders`
    FOREIGN KEY (`order_id`)
    REFERENCES `my_guitar_shop`.`orders` (`order_id`),
  CONSTRAINT `items_fk_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `my_guitar_shop`.`products` (`product_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = latin1;

USE `my_guitar_shop` ;

-- -----------------------------------------------------
-- procedure sp_AddProducts
-- -----------------------------------------------------

DELIMITER $$
USE `my_guitar_shop`$$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_AddProducts`(

    category_id_param INT,
    product_code_param varchar(10),
    product_name_param varchar(255),
    description_param varchar(500),
    list_price_param decimal(10,2)
)
BEGIN
	
    INSERT INTO my_guitar_shop.products
    (category_id, product_code, product_name, description, list_price)
    SELECT
      category_id_param, product_code_param, product_name_param, description_param, list_price_param;
      
    

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_UpdateProducts
-- -----------------------------------------------------

DELIMITER $$
USE `my_guitar_shop`$$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_UpdateProducts`(
	product_id_param INT,
    category_id_param INT,
    product_code_param varchar(10),
    product_name_param varchar(255),
    description_param varchar(500),
    list_price_param decimal(10,2)
)
BEGIN
	    
    UPDATE my_guitar_shop.products
    SET 
        product_id = product_id_param,
        category_id = category_id_param,
		product_code = product_code_param,
        product_name = product_name_param,
        description = description_param,
        list_price = list_price_param;
    

END$$

DELIMITER ;
USE `my_guitar_shop`;

DELIMITER $$
USE `my_guitar_shop`$$
CREATE
DEFINER=`root`@`%`
TRIGGER `my_guitar_shop`.`tr_insert_addresses`
BEFORE INSERT ON `my_guitar_shop`.`addresses`
FOR EACH ROW
SET NEW.city = UPPER(NEW.city)$$

USE `my_guitar_shop`$$
CREATE
DEFINER=`root`@`%`
TRIGGER `my_guitar_shop`.`tr_update_addresses`
BEFORE UPDATE ON `my_guitar_shop`.`addresses`
FOR EACH ROW
SET NEW.city = LOWER(NEW.city)$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
