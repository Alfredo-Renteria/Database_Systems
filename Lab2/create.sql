/*
* Alfredo Renteria
* Filename: create.sql
* CREATE SCHEMA & TABLES Lab2
*/

/* TESTING */

-- Start fresh
DROP SCHEMA Lab2 CASCADE; 
CREATE SCHEMA Lab2;

/* CREATE TABLES */

/*
PRIMARY KEY and UNIQUE can appear directly with the attribute when applied to a single attribute.
It is okay to use DECIMAL(10,2) instead of NUMERIC(10,2)
*/

-- Houses(houseID, address, ownerID, mostRecentSaleDate)  
CREATE TABLE Houses ( 
    houseID INTEGER, 
    address VARCHAR(50) NOT NULL, 
    ownerID INTEGER, 
    mostRecentSaleDate DATE, 
    PRIMARY KEY(houseID), 
    UNIQUE(address) 
); 
-- UNIQUE can appear with NOT NULL for address e.g: adddress VARCHAR(50) UNIQUE NOT NULL  

-- Persons(personID, personName, houseID)  
CREATE TABLE Persons ( 
    personID INTEGER, 
    personName VARCHAR(30), 
    houseID INTEGER, 
    PRIMARY KEY(personID), 
    FOREIGN KEY(houseID) REFERENCES Houses, 
    UNIQUE(personName, houseID) 
); 

-- Brokers(brokerID, brokerLevel, companyName, soldCount)  
CREATE TABLE Brokers ( 
    brokerID INTEGER, 
    brokerLevel CHAR(1), 
    companyName VARCHAR(30), 
    soldCount INTEGER, 
    PRIMARY KEY(brokerid) 
); 

-- Offers(houseID, offererID, offerDate, offerPrice, isACurrentOffer)  
CREATE TABLE Offers ( 
    houseID  INTEGER, 
    offererID INTEGER, 
    offerDate DATE, 
    offerPrice NUMERIC(10, 2) NOT NULL, 
    isACurrentOffer BOOLEAN, 
    PRIMARY KEY(houseID, offererID, offerDate), 
    FOREIGN KEY(houseID) REFERENCES Houses 
); 

-- ForSaleHouses(houseID, forSaleDate, brokerID, forSalePrice, isStillForSale)  
CREATE TABLE ForSaleHouses ( 
    houseID INTEGER, 
    forSaleDate DATE, 
    brokerID INTEGER, 
    forSalePrice NUMERIC(10, 2), 
    isStillForSale BOOLEAN, 
    PRIMARY KEY(houseID, forSaleDate), 
    FOREIGN KEY(houseID) REFERENCES Houses 
); 

-- SoldHouses(houseID, forSaleDate, soldDate, buyerID, soldPrice)  
CREATE TABLE SoldHouses ( 
    houseID INTEGER, 
    forSaleDate DATE, 
    soldDate DATE, 
    buyerID INTEGER, 
    soldPrice NUMERIC(10, 2) NOT NULL, 
    PRIMARY KEY(houseID, forSaleDate), 
    FOREIGN KEY(houseID, forSaleDate) REFERENCES ForSaleHouses, 
    UNIQUE(buyerID, soldDate) 
); 