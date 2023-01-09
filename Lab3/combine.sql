/*
* Alfredo Renteria
* Filename: combine.sql
* Lab3: 2.2 Combine Data
*/

/*
Its' Okay to write BEGIN TRANSACTION (or BEGIN WORK) instead of START
It's important to have ISOLATION LEVEL SERIALIZABLE irrespective of the alternative chosen 
*/

START TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT * -- used to observe transaction
FROM SoldHouses;

UPDATE SoldHouses -- first, update SoldHouses from SoldHouseChanges
    SET soldDate = (SELECT CURRENT_DATE), 
        buyerID = sHChange2.buyerID, 
        soldPrice = sHChange2.soldPrice 
    FROM SoldHouseChanges AS sHChange2 
    WHERE SoldHouses.houseID = sHChange2.houseID 
        AND SoldHouses.forSaleDate = sHChange2.forSaleDate;

SELECT * -- used to observe transaction
FROM SoldHouses;

INSERT INTO SoldHouses(houseID, forSaleDate, buyerID, soldPrice) -- exclude [SoldHouses]-soldPrice
SELECT *
FROM SoldHouseChanges AS shc
WHERE NOT EXISTS (SELECT 1 
                  FROM SoldHouses sh 
                  WHERE sh.houseID = shc.houseID 
                      AND sh.forSaleDate = shc.forSaleDate);

SELECT * -- used to observe transaction
FROM SoldHouses; 

COMMIT;