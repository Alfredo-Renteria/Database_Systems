/*
* Alfredo Renteria
* Filename: unittests.sql
* Lab3: 2.5 Write Unit Tests
*/

/* -------------Foreign key constraints-----------------*/

-- One unit test for each 3 foreign key constraints specificied in foreign.sql 

/* 
Violates Foreign key constraint #1  
There is no such personID in Persons which would map to broker 50
*/

INSERT INTO Brokers 
    VALUES(50, 'A', 'foo bar', 50);

/* 
Violates Foreign key constraint #2  
There is no such personID in Persons which would map to offererID 50
*/

INSERT INTO Offers 
    VALUES(111, 50, '2020-10-25', 550000.00, TRUE);

/* 
Violates Foreign key constraint #3
There is no such personID in Persons which would map to buyerID 46
*/

INSERT INTO soldHouses 
    VALUES(111, '2020-10-25', '2020-10-26', 50, 550000.00);

/* --------------General constraints-------------------*/

-- 2 unit tests for each 3 general constraints specified in general.sql

/* 
soldPrice greater than 0 check 
*/

UPDATE soldHouses 
SET soldPrice = 1000 
WHERE buyerID = 5 
  AND houseID = 111 
  AND forSaleDate = '2019-06-24';

/* 
soldPrice less than 0, violation 
*/

UPDATE soldHouses 
SET soldPrice = -1 
WHERE buyerID = 5;

/* 
Simple brokerLevel check 
*/

UPDATE Brokers
SET brokerLevel = 'A'
WHERE brokerID = 1;

/* 
brokerLevel not amongst A,B,C,D or NULL, violation 
*/

UPDATE Brokers
SET brokerLevel = 'G'
WHERE brokerID = 1;;

/* 
isACurrentOffer is NULL when offerPrice is NULL 
*/

UPDATE Offers 
SET offerPrice = NULL,
    isACurrentOffer = NULL
WHERE offererID = 2;
    AND houseID = 111;

/* 
UPDATE statement doesn't modify isACurrentOffer to NULL 
when we are setting the offerPrice to NULL, violation 
*/

UPDATE offers 
SET offerPrice=NULL 
WHERE houseID=111 
  AND offererID=13;