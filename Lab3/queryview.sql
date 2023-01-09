/*
* Alfredo Renteria
* Filename: queryview.sql
* Lab3: 2.6.2 Query a View
*/

-- Did you get a different answer?
-- Yes, the first delete removes a soldHouse from a correct computation, now making it invalid
-- The second delete corrects a computation to reflect that of soldCount

SELECT DISTINCT b.brokerID, p.personName, b.soldCount, v.computedSoldCount
FROM Brokers AS b, Persons AS p, viewComputedSoldCount AS v
WHERE b.brokerID = v.brokerID 
    AND b.brokerID = p.personID
    AND v.brokerID = p.personID
    AND b.soldCount != v.computedSoldCount;

/*
DISTINCT is not necessary because there can only be at most 
one tuples per brokerID in the table & in the view.
*/

/*
--Alternative:

SELECT b.brokerID,
       p.personName,
       b.soldCount,
       vw.computedSoldCount
FROM   brokers b,
       viewComputedSoldCount vw,
       persons p
WHERE  b.brokerID = vw.brokerID
       AND b.brokerID = p.personID
       AND b.soldCount <> vw.computedSoldCount; 
*/


/*
            ----- Misreported Brokers -----
 brokerid |  personname   | soldcount | computedsoldcount 
----------+---------------+-----------+-------------------
       17 | Kassulke Feil |         1 |                 2
       18 | Sonia Roy     |         4 |                 2 
*/

/*
The SQL statements that delete the tuples
*/

DELETE FROM SoldHouses sh
    WHERE sh.houseID = 444
    AND sh.forSaleDate = '2016-08-16';

 DELETE FROM SoldHouses sh
    WHERE sh.houseID = 222
    AND sh.forSaleDate = '2020-05-08';

/*  
            ----- Misreported Brokers -----
 brokerid |  personname   | soldcount | computedsoldcount 
----------+---------------+-----------+-------------------
       18 | Sonia Roy     |         4 |                 2
       20 | Alex Robinson |         3 |                 2
*/

SELECT DISTINCT b.brokerID, p.personName, b.soldCount, v.computedSoldCount
FROM Brokers AS b, Persons AS p, viewComputedSoldCount AS v
WHERE b.brokerID = v.brokerID 
    AND b.brokerID = p.personID
    AND v.brokerID = p.personID
    AND b.soldCount != v.computedSoldCount;