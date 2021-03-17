-- ******************************************************************************************************
-- MySQL script to clean out data from the RetailPOC database
-- Author: John Tucker
-- Date  : 17-03-2021
-- Usage  : This code is freely available to use and modify by any interested party
-- *******************************************************************************************************
DELETE FROM tbproduct;
DELETE FROM tbproductsupplier;
DELETE FROM tbpurchaseorder;
DELETE FROM tbreportsetting;
TRUNCATE TABLE tbsale;
TRUNCATE TABLE tbsale_reporting;
TRUNCATE TABLE tbsaleline;
TRUNCATE TABLE tbsaleline_reporting;
DELETE FROM tbstocksilo;
DELETE FROM tbstore;
DELETE FROM tbsupplierinvoice;
DELETE FROM tbunknownprodsup;