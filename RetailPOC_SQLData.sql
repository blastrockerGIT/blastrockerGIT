-- ******************************************************************************************************
-- MySQL script to load sample test data into the RetailPOC database
-- Author: John Tucker
-- Date  : 17-03-2021
-- Usage  : This code is freely available to use and modify by any interested party
-- *******************************************************************************************************
/*
tbproduct table
*/
INSERT INTO tbproduct (ProductCode,ProductName,ProductSelling,ProductCost,MinStockLevel,OrderQuantity) 
 VALUES (1,'Beans Small',0.30,0.16,50,500),
		(2,'Beans Large',0.45,0.22,50,500),
		(3,'Bread White',1.10,0.45,50,500),
		(4,'Bread Brown',1.20,0.57,50,500),
		(5,'Spaghetti',0.90,0.32,50,500),
		(6,'Cappuccino Pods',4.10,2.00,50,500),
		(7,'Packed Bananas',1.45,0.51,50,500),
		(8,'Pork Sausages',2.50,1.10,50,500),
		(9,'Shampoo',1.25,0.43,50,500),
		(10,'Electric Drill',15.50,4.30,50,500),
		(11,'Tinned Tomatoes',0.38,0.09,50,500),
		(12,'Orange Juice',2.45,1.22,50,500);
		
/*
 tbsupplier
*/
INSERT INTO tbsupplier (SupplierKey,SupplierName,SupplierEMail) 
 VALUES (1,'General Grocers Ltd','blastrocker@googlemail.com'),
		(2,'Universal Canned Products Ltd','blastrocker@googlemail.com'),
		(3,'Crusty Baker Group','blastrocker@googlemail.com'),
		(4,'Italian Coffee and Pasta Company','blastrocker@googlemail.com'),
		(5,'Meaty Butchers Ltd','blastrocker@googlemail.com'),
		(6,'Powerco Tools Corporation','blastrocker@googlemail.com');
		
/*
tbproductsupplier
*/
INSERT INTO tbproductsupplier (ProductCode,SupplierCode) 
	 VALUES (1,1),
			(2,1),
			(7,1),
			(9,1),
			(12,1),
			(1,2),
			(11,2),
			(3,3),
			(4,3),
			(5,4),
			(6,4),
			(8,5),
			(10,6);

/*

tbreportsetting

*/
INSERT INTO tbreportsetting (ReceiptStoreCode,StartReceiptNo,CurrentReceiptNo) 
 VALUES (1,0,0),
		(2,0,0),
		(3,0,0),
		(4,0,0),
		(5,0,0),
		(6,0,0),
		(7,0,0),
		(8,0,0);

/*
 tbstocksilo
*/
INSERT INTO tbstocksilo
	(SiloKey,
	 SiloProductCode,
	 SiloPONumber,
	 SiloFulfillmentDate,
	 SiloInitialQuantity,
	 SiloCurrentQuantity,
	 SiloCost)
 VALUES (1,1,1,NOW(),50,50,0.15 ),
		(2,2,2,NOW(),50,50,0.22 ),
		(3,3,3,NOW(),50,50,0.46 ),
		(4,4,4,NOW(),50,50,0.58 ),
		(5,5,5,NOW(),50,50,0.35 ),
		(6,6,6,NOW(),50,50,1.98 ),
		(7,7,7,NOW(),50,50,0.54 ),
		(8,8,8,NOW(),50,50,1.11 ),
		(9,9,9,NOW(),50,50,0.43 ),
		(10,10,10,NOW(),50,50,4.28 ),
		(11,11,11,NOW(),50,50,0.09 ),
		(12,12,12,NOW(),50,50,1.85 );
		
/*
tbstore`
*/
INSERT INTO tbstore (StoreCode,StoreName,StoreRegion,StoreLastReceiptNo,StoreLocationPoint) 
 VALUES (1,'London','South',30703,POINT(51.523004586611194,-0.11945864098895387)),
		(2,'Cardiff','West',30593,POINT(51.48576102294992,-3.1786159677282275)),
		(3,'Belfast','West',30027,POINT(54.60142314006526,-5.926290684701445)),
		(4,'Norwich','East',29945,POINT(52.63512198136631,1.299207340255876)),
		(5,'Dover','South',29868,POINT(51.13026522104116,1.3131767969231143)),
		(6,'Manchester','North',29787,POINT(53.48550564581351,-2.241317381030202)),
		(7,'Edinburgh','North',29078,POINT(55.95675969059072,-3.1892042385372417)),
		(8,'Lincoln','East',28752,POINT(53.231548,-0.540648));


/*
tbunknownprodsup
*/
INSERT INTO tbunknownprodsup (CodeValue,NameValue,SupplierValue) VALUES (0,'No Product','No Supplier');

