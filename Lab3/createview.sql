/*
* Alfredo Renteria
* Filename: createview.sql
* Lab3: 2.6.1 Create a View
*/

/*
DISTINCT is not needed in the SELECT because there can only be one tuple for each GROUP BY group.
JOIN with Brokers table is not needed as we have the brokerID in forSaleHouses table.
*/

CREATE VIEW viewComputedSoldCount AS
  SELECT f.brokerID, COUNT(f.houseID) AS computedSoldCount
  FROM   ForSaleHouses f, SoldHouses s
  WHERE  f.houseID = s.houseID
    AND  f.forSaleDate = s.forSaleDate
  GROUP  BY f.brokerID
  HAVING COUNT(f.houseID) >= 2; 

/*
-- Alternative: Joining with Brokers table

CREATE VIEW viewComputedSoldCount2(brokerID, computedSoldCount) AS
    SELECT b.brokerID, COUNT(fsh.brokerID)
    FROM Brokers b, ForSaleHouses fsh
    WHERE b.brokerID = fsh.brokerID 
        AND EXISTS (SELECT * 
                    FROM SoldHouses sh 
                    WHERE fsh.houseID = sh.houseID 
                    AND fsh.forSaleDate = sh.forSaleDate)
    GROUP BY b.brokerID
    HAVING COUNT(fsh.brokerID) >= 2;
*/