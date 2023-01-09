/*
* Alfredo Renteria
* Filename: create.sql
* CREATE SCHEMA & TABLES Lab3
*/

/* TESTING */

-- Start fresh
DROP SCHEMA Lab3 CASCADE; 
CREATE SCHEMA Lab3; 

/* CREATE TABLES */

-- Houses(houseID, address, ownerID, mostRecentSaleDate)
CREATE TABLE Houses (
	houseID INTEGER, 
	address VARCHAR(50), 
	ownerID INTEGER, 
	mostRecentSaleDate DATE,
	PRIMARY KEY(houseID)
);

-- Persons(personID, personName, houseID)
CREATE TABLE Persons (
	personID INTEGER, 
	personName VARCHAR(30), 
	houseID INTEGER,
	PRIMARY KEY(personID),
	FOREIGN KEY(houseID) REFERENCES Houses
);

-- Brokers(brokerID, brokerLevel, companyName, soldCount)
CREATE TABLE Brokers (
	brokerID INTEGER,
	brokerLevel CHAR(1),
	companyName VARCHAR(30),
	soldCount INTEGER,
	PRIMARY KEY(brokerID)
);

-- Offers(houseID, offererID, offerDate, offerPrice, isACurrentOffer)
CREATE TABLE Offers (
	houseID INTEGER,
	offererID INTEGER,
	offerDate DATE,
	offerPrice NUMERIC(10,2),
	isACurrentOffer BOOLEAN,
	PRIMARY KEY(houseID,offererID,offerDate),
	FOREIGN KEY(houseID) REFERENCES Houses
);

-- ForSaleHouses(houseID, forSaleDate, brokerID, forSalePrice, isStillForSale)
CREATE TABLE ForSaleHouses (
	houseID INTEGER,
	forSaleDate DATE,
	brokerID INTEGER,
	forSalePrice NUMERIC(10,2),
	isStillForSale BOOLEAN,
	PRIMARY KEY(houseID,forSaleDate),
	FOREIGN KEY(houseID) REFERENCES Houses
);

-- SoldHouses(houseID, forSaleDate, soldDate, buyerID, soldPrice)
CREATE TABLE SoldHouses (
	houseID INTEGER,
	forSaleDate DATE,
	soldDate DATE,
	buyerID INTEGER,
	soldPrice NUMERIC(10,2),
	PRIMARY KEY(houseID,forSaleDate),
	FOREIGN KEY(houseID,forSaleDate) REFERENCES ForSaleHouses
);

-- SoldHouseChanges(houseID, forSaleDate, buyerID, soldPrice)
CREATE TABLE SoldHouseChanges (
	houseID INTEGER,
	forSaleDate DATE,
	buyerID INTEGER,
	soldPrice NUMERIC(10,2),
	PRIMARY KEY(houseID,forSaleDate),
	FOREIGN KEY(houseID) REFERENCES Houses
);