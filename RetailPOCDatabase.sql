-- *****************************************************************************************************
-- Database for use in RetailPOC proof of concept scenario demonstrating use of Talend DI and ESB
-- Author : John Tucker
-- Date   : 17/03/2021
-- Usage  : This code is freely available to use and modify by any interested party
-- *****************************************************************************************************

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema retailpoc
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema retailpoc
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `retailpoc` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `retailpoc` ;

-- -----------------------------------------------------
-- Table `retailpoc`.`tbproduct`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbproduct` (
  `ProductCode` INT NOT NULL,
  `ProductName` VARCHAR(45) NULL DEFAULT NULL,
  `ProductSelling` DECIMAL(10,2) NULL DEFAULT NULL,
  `ProductCost` DECIMAL(10,2) NULL DEFAULT NULL,
  `MinStockLevel` INT NULL DEFAULT NULL,
  `OrderQuantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ProductCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbsupplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbsupplier` (
  `SupplierKey` INT NOT NULL,
  `SupplierName` VARCHAR(45) NOT NULL,
  `SupplierEMail` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`SupplierKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbproductsupplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbproductsupplier` (
  `ProductCode` INT NOT NULL,
  `SupplierCode` INT NOT NULL,
  PRIMARY KEY (`ProductCode`, `SupplierCode`),
  INDEX `fkSupplier_idx` (`SupplierCode` ASC) VISIBLE,
  CONSTRAINT `fkProductSupllierProduct`
    FOREIGN KEY (`ProductCode`)
    REFERENCES `retailpoc`.`tbproduct` (`ProductCode`),
  CONSTRAINT `fkProductSupplierSupplier`
    FOREIGN KEY (`SupplierCode`)
    REFERENCES `retailpoc`.`tbsupplier` (`SupplierKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbpurchaseorder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbpurchaseorder` (
  `PONumber` INT NOT NULL,
  `POSupplierCode` INT NULL DEFAULT NULL,
  `POSupplierName` VARCHAR(45) NULL DEFAULT NULL,
  `POProductCode` INT NULL DEFAULT NULL,
  `POProductName` VARCHAR(45) NULL DEFAULT NULL,
  `POQuantity` INT NULL DEFAULT NULL,
  `POSupplierEMail` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`PONumber`),
  INDEX `fkPOSupplier_idx` (`POSupplierCode` ASC) VISIBLE,
  INDEX `fkPOProduct_idx` (`POProductCode` ASC) VISIBLE,
  CONSTRAINT `fkPOProduct`
    FOREIGN KEY (`POProductCode`)
    REFERENCES `retailpoc`.`tbproduct` (`ProductCode`),
  CONSTRAINT `fkPOSupplier`
    FOREIGN KEY (`POSupplierCode`)
    REFERENCES `retailpoc`.`tbsupplier` (`SupplierKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbreportsetting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbreportsetting` (
  `ReceiptStoreCode` INT NOT NULL,
  `StartReceiptNo` INT NULL DEFAULT NULL,
  `CurrentReceiptNo` INT NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbstore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbstore` (
  `StoreCode` INT NOT NULL,
  `StoreName` VARCHAR(45) NULL DEFAULT NULL,
  `StoreRegion` VARCHAR(45) NULL DEFAULT NULL,
  `StoreLastReceiptNo` INT NULL DEFAULT '0',
  `StoreLocationPoint` POINT NULL DEFAULT NULL,
  PRIMARY KEY (`StoreCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbsale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbsale` (
  `ReceiptNo` INT NOT NULL,
  `ReceiptStoreCode` INT NOT NULL,
  `ReceiptDateTime` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`ReceiptNo`, `ReceiptStoreCode`),
  INDEX `fkStoreCode_idx` (`ReceiptStoreCode` ASC) VISIBLE,
  CONSTRAINT `fkStoreCode`
    FOREIGN KEY (`ReceiptStoreCode`)
    REFERENCES `retailpoc`.`tbstore` (`StoreCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbsale_reporting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbsale_reporting` (
  `ReceiptNo` INT NOT NULL,
  `ReceiptStoreCode` INT NOT NULL,
  `ReceiptDateTime` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`ReceiptNo`, `ReceiptStoreCode`),
  INDEX `fkStoreCodeReporting_idx` (`ReceiptStoreCode` ASC) VISIBLE,
  CONSTRAINT `fkStoreCodeReporting`
    FOREIGN KEY (`ReceiptStoreCode`)
    REFERENCES `retailpoc`.`tbstore` (`StoreCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbsaleline`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbsaleline` (
  `ReceiptNo` INT NOT NULL,
  `ReceiptStoreCode` INT NOT NULL,
  `ReceiptLineNo` INT NOT NULL,
  `ReceiptLineProductCode` INT NULL DEFAULT NULL,
  `ReceiptLineQuantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ReceiptNo`, `ReceiptStoreCode`, `ReceiptLineNo`),
  INDEX `fkProduct_idx` (`ReceiptLineProductCode` ASC) VISIBLE,
  INDEX `fkReceipt_idx` (`ReceiptNo` ASC, `ReceiptStoreCode` ASC) VISIBLE,
  CONSTRAINT `fkProduct`
    FOREIGN KEY (`ReceiptLineProductCode`)
    REFERENCES `retailpoc`.`tbproduct` (`ProductCode`),
  CONSTRAINT `fkReceipt`
    FOREIGN KEY (`ReceiptNo` , `ReceiptStoreCode`)
    REFERENCES `retailpoc`.`tbsale` (`ReceiptNo` , `ReceiptStoreCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbsaleline_reporting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbsaleline_reporting` (
  `ReceiptNo` INT NOT NULL,
  `ReceiptStoreCode` INT NOT NULL,
  `ReceiptLineNo` INT NOT NULL,
  `ReceiptLineProductCode` INT NULL DEFAULT NULL,
  `ReceiptLineQuantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ReceiptNo`, `ReceiptStoreCode`, `ReceiptLineNo`),
  INDEX `fkProductreporting_idx` (`ReceiptLineProductCode` ASC) VISIBLE,
  INDEX `fkReceiptreporting_idx` (`ReceiptNo` ASC, `ReceiptStoreCode` ASC) VISIBLE,
  CONSTRAINT `fkProductreporting`
    FOREIGN KEY (`ReceiptLineProductCode`)
    REFERENCES `retailpoc`.`tbproduct` (`ProductCode`),
  CONSTRAINT `fkReceiptreporting`
    FOREIGN KEY (`ReceiptNo` , `ReceiptStoreCode`)
    REFERENCES `retailpoc`.`tbsale` (`ReceiptNo` , `ReceiptStoreCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbstocksilo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbstocksilo` (
  `SiloKey` INT NOT NULL,
  `SiloProductCode` INT NOT NULL,
  `SiloPONumber` VARCHAR(45) NULL DEFAULT NULL,
  `SiloFulfillmentDate` DATETIME NULL DEFAULT NULL,
  `SiloInitialQuantity` INT NULL DEFAULT NULL,
  `SiloCurrentQuantity` INT NULL DEFAULT NULL,
  `SiloCost` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`SiloKey`, `SiloProductCode`),
  INDEX `fkSiloProduct_idx` (`SiloProductCode` ASC) VISIBLE,
  CONSTRAINT `fkSiloProduct`
    FOREIGN KEY (`SiloProductCode`)
    REFERENCES `retailpoc`.`tbproduct` (`ProductCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbsupplierinvoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbsupplierinvoice` (
  `InvoiceNo` INT NOT NULL,
  `PONumber` INT NULL DEFAULT NULL,
  `InvoiceValue` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`InvoiceNo`),
  UNIQUE INDEX `InvoiceNo_UNIQUE` (`InvoiceNo` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retailpoc`.`tbunknownprodsup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retailpoc`.`tbunknownprodsup` (
  `CodeValue` INT NULL DEFAULT NULL,
  `NameValue` VARCHAR(45) NULL DEFAULT NULL,
  `SupplierValue` VARCHAR(45) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `retailpoc` ;

-- -----------------------------------------------------
-- procedure AllSalesByRegion
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AllSalesByRegion`()
BEGIN
SELECT 
	sto.StoreRegion Region,
    sto.StoreName,
	ST_X(sto.StoreLocationPoint) Latitude,
    ST_Y(sto.StoreLocationPoint) Longtitude,
    Sum(lin.ReceiptLineQuantity * prod.ProductSelling) Selling
FROM retailpoc.tbsale_reporting hdr, retailpoc.tbsaleline_reporting lin, retailpoc.tbstore sto, retailpoc.tbproduct prod
WHERE hdr.ReceiptNo = lin.ReceiptNo
AND hdr.ReceiptStoreCode = lin.ReceiptStoreCode
AND sto.StoreCode = hdr.ReceiptStoreCode
AND prod.ProductCode = lin.ReceiptLineProductCode
GROUP BY sto.StoreRegion,sto.StoreName
ORDER BY sto.StoreRegion ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckAssignedSupplier
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckAssignedSupplier`(
	IN parmProductCode INT,
    IN parmSupplierCode INT,
    OUT result INT
)
BEGIN
SELECT 1 AS Result
WHERE EXISTS (SELECT * FROM tbproductsupplier WHERE ProductCode = parmProductCode
											 AND SupplierCode = parmSupplierCode)
UNION
SELECT 0
WHERE NOT EXISTS (SELECT * FROM tbproductsupplier WHERE ProductCode = parmProductCode
											 AND SupplierCode = parmSupplierCode)
INTO result;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckProductSupplierValues
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckProductSupplierValues`(
	IN parmProductCode INT,
    IN parmSupplierCode INT,
    OUT result INT
)
BEGIN
SELECT 1 AS Result
WHERE EXISTS (SELECT * FROM tbproduct WHERE ProductCode = parmProductCode)
AND EXISTS(SELECT * FROM tbsupplier WHERE SupplierKey = parmSupplierCode)
UNION
SELECT 0
WHERE NOT EXISTS (SELECT * FROM tbproduct WHERE ProductCode = parmProductCode)
OR NOT EXISTS(SELECT * FROM tbsupplier WHERE SupplierKey = parmSupplierCode)
INTO result;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CreateProductSilo
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateProductSilo`(
	IN parmProductCode INTEGER,
    IN parmPONumber INTEGER,
    IN parmQuantity INTEGER
)
BEGIN

DECLARE exit handler for SQLEXCEPTION
 BEGIN
  GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
   @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
  SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
  SELECT @full_error As Result;
 END;
 
/* insert new record into the silo table  for the order
** silo key calculated from max in table plus 1
** cost is looked up from product table then rounded up or down by a random percentage
** between -10 and 10 to simulate price variance */

 INSERT INTO `retailpoc`.`tbstocksilo`
(`SiloKey`,
`SiloProductCode`,
`SiloPONumber`,
`SiloFulfillmentDate`,
`SiloInitialQuantity`,
`SiloCurrentQuantity`,
`SiloCost`)
SELECT COALESCE(MAX(SiloKey),0) + 1 SiloKey,
parmProductCode ProductCode,
parmPONumber PONumber,
NOW() FulfilmentDate,
parmQuantity InitialQuantity,
parmQuantity CurrentQuantity,
(SELECT ROUND((1 + FLOOR(-10 + 20*RAND())/100) * ProductCost,2) 
 FROM retailpoc.tbproduct
 WHERE ProductCode = parmProductCode) Cost
FROM tbStockSilo silo;

SELECT 1 As Result;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetProductSupplier
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductSupplier`(
	IN parmProductCode INT
)
BEGIN
	 SELECT prod.ProductCode,
			prod.ProductName,
			COALESCE(sup.SupplierName,'No Suppliers') AS SupplierName
	FROM  tbproduct prod 
		LEFT JOIN tbproductsupplier prodsup
		ON prod.ProductCode = prodsup.ProductCode LEFT JOIN tbsupplier sup
		ON prodsup.SupplierCode = sup.SupplierKey  
	WHERE prod.ProductCode = parmProductCode
    UNION
    Select CodeValue,NameValue,SupplierValue 
    FROM tbunknownprodsup
    WHERE NOT EXISTS
    (SELECT ProductCode FROM  tbproduct prod
    WHERE prod.ProductCode = parmProductCode );
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetSalesByRegion
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSalesByRegion`(
	IN parmRegionCode VARCHAR(45)
)
BEGIN
SELECT 
	hdr.ReceiptStoreCode StoreCode,
    sto.StoreName,
    sto.StoreRegion,
	lin.ReceiptLineProductCode ProductCode,
    prod.ProductName,
	Sum(lin.ReceiptLineQuantity * prod.ProductCost) Cost,
    Sum(lin.ReceiptLineQuantity * prod.ProductSelling) Selling
FROM retailpoc.tbsale_reporting hdr, retailpoc.tbsaleline_reporting lin, retailpoc.tbstore sto, retailpoc.tbproduct prod
WHERE hdr.ReceiptNo = lin.ReceiptNo
AND hdr.ReceiptStoreCode = lin.ReceiptStoreCode
AND sto.StoreCode = hdr.ReceiptStoreCode
AND prod.ProductCode = lin.ReceiptLineProductCode
AND sto.StoreRegion = parmRegionCode
GROUP BY sto.StoreName, prod.ProductCode
ORDER BY sto.StoreName,prod.ProductCode ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ProcessSales
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessSales`(
	IN parmProductCode INTEGER,
    OUT vsilocost DECIMAL(10,2),
    OUT vreorder VARCHAR(10)
)
BEGIN
/*First get the cost from the currently active silo*/
/*if silos are all full take the default product cost instead */
SELECT ((SELECT SiloCost FROM tbstocksilo
WHERE SiloProductCode = parmProductCode
AND SiloCurrentQuantity > 0
ORDER BY SiloKey
LIMIT 1)
UNION
SELECT ProductCost FROM tbproduct
WHERE ProductCode =  parmProductCode
AND NOT EXISTS (SELECT SiloCost FROM tbstocksilo
					WHERE SiloProductCode = parmProductCode
					AND SiloCurrentQuantity > 0))
INTO vsilocost ;

/*decrement the active silo quantity*/
/*next silo becomes active automatically when zero is reached*/

UPDATE tbstocksilo
SET SiloCurrentQuantity = SiloCurrentQuantity - 1
WHERE SiloProductCode = parmProductCode
AND SiloCurrentQuantity > 0
ORDER BY SiloKey
LIMIT 1;


/*check if supplier reorder required by reaching min stock level*/
SELECT 'Yes' StockLevelReached
FROM tbstocksilo silo, tbproduct prod
WHERE prod.ProductCode = parmProductCode
AND SiloProductCode = prod.ProductCode
AND SiloCurrentQuantity = prod.MinStockLevel
UNION
SELECT 'No'
WHERE NOT EXISTS (
SELECT 'Yes' StockLevelReached
FROM tbstocksilo silo, tbproduct prod
WHERE prod.ProductCode = parmProductCode
AND SiloProductCode = prod.ProductCode
AND SiloCurrentQuantity = prod.MinStockLevel)
INTO vreorder;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RaisePurchaseOrder
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RaisePurchaseOrder`(
	IN parmProductCode INTEGER
)
BEGIN
/* gets product and supplier data based on product parameter and writes to purche order table */
INSERT INTO tbPurchaseOrder
SELECT 
		(SELECT COALESCE(MAX(PONumber),0) + 1 FROM tbPurchaseOrder) PONumber,
        sup.SupplierKey,
        sup.SupplierName,
        prod.ProductCode,
        prod.ProductName,
		prod.OrderQuantity,
        sup.SupplierEMail
FROM tbSupplier sup, tbproductsupplier prodsup, tbProduct prod
WHERE prodsup.SupplierCode = sup.SupplierKey
AND prodsup.ProductCode = prod.ProductCode
AND prodsup.ProductCode = parmProductCode
ORDER BY RAND()
LIMIT 1;

/* Retrieve details of the record created as output result set*/
SELECT *
FROM tbPurchaseOrder
WHERE PONumber = (SELECT MAX(PONumber) FROM tbPurchaseOrder);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SupplierInvoice
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SupplierInvoice`(
IN parmPONumber INTEGER)
BEGIN
DECLARE invVal DECIMAL(10,2);
DECLARE exit handler for SQLEXCEPTION
 BEGIN
  GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
   @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
  SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
  SELECT @full_error As Result;
 END;
 
/* insert new record into the supplier invoice table  for the purchase order
** invoice number calculated from max in table plus 1
*/

SELECT SiloInitialQuantity * SiloCost
INTO invVal
FROM tbstocksilo
WHERE SiloPONumber = parmPONumber;



INSERT INTO tbsupplierinvoice
(InvoiceNo,
PONumber,
InvoiceValue)
SELECT COALESCE(MAX(InvoiceNo),0) + 1 InvoiceNo,
parmPONumber PONumber,
invVal InvoiceValue 
FROM tbSupplierInvoice;

SELECT 1 As Result;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateReportSetting
-- -----------------------------------------------------

DELIMITER $$
USE `retailpoc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateReportSetting`(
IN parmFullOrDelta VARCHAR(10))
BEGIN
DECLARE vFullOrDelta VARCHAR(10);
IF parmFullOrDelta = 'Full' THEN
	SET vFullOrDelta =  'Full';
ELSE
	SET vFullOrDelta = (SELECT IF(CURDATE() > DATE(Min(ReceiptDateTime)),'Full','Delta') FROM tbsale_reporting) ;
END IF;

IF vFullOrDelta = 'Full' THEN
/*Reinitialise settings table with todays values*/
DELETE FROM tbreportsetting;
INSERT INTO tbreportsetting
SELECT ReceiptStoreCode, MIN(ReceiptNo) StartReceiptNo, MIN(ReceiptNo) CurrentReceiptNo
FROM tbsale
WHERE ReceiptDateTime >= CURDATE()
AND ReceiptDateTime < CURDATE() + INTERVAL 1 DAY
GROUP BY ReceiptStoreCode ;
/*Clear reporting tables - only for full load*/
TRUNCATE TABLE tbsale_reporting ;
TRUNCATE TABLE tbsaleline_reporting ;
ELSE
/*Update setting with latest value parameters*/
UPDATE tbreportsetting AS repset,(SELECT
ReceiptStoreCode, MAX(ReceiptNo) CurrentReceiptNo
FROM tbsale_reporting salrep
GROUP BY ReceiptStoreCode) AS salrep
SET repset.CurrentReceiptNo =  salrep.CurrentReceiptNo
WHERE repset.ReceiptStoreCode = salrep.ReceiptStoreCode;
END IF;

/*Now load reporting data based on report settings*/
INSERT INTO tbsale_reporting 
SELECT sal.* FROM
tbreportsetting rep, tbsale sal
WHERE sal.ReceiptStoreCode = rep.ReceiptStoreCode
AND sal.ReceiptNo > rep.CurrentReceiptNo
ON DUPLICATE KEY UPDATE
ReceiptNo = sal.ReceiptNo, 
ReceiptStoreCode = sal.ReceiptStoreCode,
ReceiptDateTime = sal.ReceiptDateTime ;

INSERT INTO tbsaleline_reporting 
Select salin.* FROM
tbreportsetting rep, tbsaleline salin
WHERE salin.ReceiptStoreCode = rep.ReceiptStoreCode
AND salin.ReceiptNo >= rep.CurrentReceiptNo 
ON DUPLICATE KEY UPDATE
ReceiptNo = salin.ReceiptNo, 
ReceiptStoreCode = salin.ReceiptStoreCode,
ReceiptLineNo = salin.ReceiptLineNo,
ReceiptLineProductCode = salin.ReceiptLineProductCode,
ReceiptLineQuantity = salin.ReceiptLineQuantity ;

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
