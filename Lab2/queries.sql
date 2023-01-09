/*
* Alfredo Renteria
* Filename: queries.sql
* Lab2: 4.1-.5 Queries 
*/

/* 
For each offer that is current, give the name of the offerer, the address of 
the house, and the mostRecentSaleDate (which is an attribute of Houses) for 
that house. Order your result in alphabetical order based on name of the 
offerer. If there are two tuples in your result that have the same offerer 
name, the tuple with the later value for most recent sales date should come 1st.
No duplicates should appear in your result.
*/

/*
DISTINCT is needed because there can be multiple offers from the same offerer for the same house.
*/

SELECT DISTINCT p.personName, h.address, h.mostRecentSaleDate
FROM Persons p, Houses h, Offers o
WHERE o.isACurrentOffer = 'TRUE' 
    AND p.personID = o.offererID 
    AND h.houseID = o.houseID
ORDER BY p.personName ASC, h.mostRecentSaleDate DESC;

/*
For each person who has the string ‘son’ appearing anywhere in their name (lowercase letters), 
give the name of the person, the address of their house, & the name of the owner of that house.
No duplicates should appear in your result.
*/

/*
DISTINCT is not needed(!) since (personName, housedID) is UNIQUE, & neither personName nor houseID can be NULL.
(Why can't personName be NULL? Because NULL would not satisfy "personName LIKE '%son%'") 
And for a particular houseID, there can only be one owner.
*/

SELECT p1.personName, h.address, p2.personName AS homeOwnerName
FROM Persons p1, Persons p2, Houses h 
WHERE p1.personName LIKE '%son%' 
    AND p1.houseID = h.houseID 
    AND h.ownerID = p2.personID;
    
/*
Find the ID and name of each broker whose company is ‘Weathervane Group Realty'
and who had at least one house for sale before October 1, 2020 that
is not still for sale, and where their “for sale house” sold for one million or more 
No duplicates should appear in your result.
(Careful; the same house could be put up for sale more than once, perhaps with different brokers.)
*/

SELECT DISTINCT b.brokerid, p.personName AS brokerName
FROM Brokers b, Persons p, ForSaleHouses f, SoldHouses s
WHERE b.companyNAme = 'Weathervane Group Realty' 
    AND b.brokerID = p.personID
    AND b.brokerID = f.brokerID
    AND f.forSaleDate < '2020-10-01'
    AND f.houseID = s.houseID
    AND f.forSaleDate = s.forSaleDate 
    AND f.isStillForSale = 'FALSE' 
    AND s.soldPrice >= 1000000;

/*
Because there can be only one broker with a given brokerID, 
& that brokerID can match the personID of only one person.
*/

/*
-- Alternative: Without DISTINCT

SELECT b.brokerID, p.personName
FROM Brokers b, Persons p
WHERE b.brokerID = p.personID 
    AND b.companyName = 'Weathervane Group Realty'       
    AND EXISTS (SELECT *
                FROM   ForSaleHouses f,SoldHouses s
                WHERE  b.brokerID = f.brokerID
                    AND  f.forSaleDate < DATE '2020-10-01'
                    AND  f.houseID = s.houseID
                    AND  f.forSaleDate = s.forSaleDate
                    AND  NOT f.isStillForSale
                    AND  s.soldPrice >= 1000000 );

*/

/*
For each house that has at least one offer, find the highest offer price for 
that house. Your output should include the houseID, its address and the 
highest offer price for that house. The attributes in your result should be
houseID, address and highOffer. 
No duplicates should appear in your result.
*/

/*
DISTINCT is not needed in the SELECT because there can only be one tuple for each GROUP BY group.
*/

SELECT h.houseID, h.address, MAX(o.offerPrice) AS highOffer
FROM Houses h, Offers o
WHERE o.houseID = h.houseID
GROUP BY h.houseID, h.address;

/*
-- Alternative: We can write the query without h.address in GROUP BY, because h.houseID, 
--              which is the complete primary key of Houses, is a GROUP BY attribute.

SELECT h.houseID AS houseID, h.address AS address, MAX(o.offerPrice) AS highOffer 
FROM   Offers o, Houses h 
WHERE  o.houseID = h.houseID 
GROUP  BY h.houseID;

-- Alternative2: DISTINCT is needed for this version because there could be multiple offers 
--               for a house that have the same highest offerPrice.

SELECT DISTINCT o.houseID AS houseID, h.address AS address, o.offerPrice AS highOffer 
FROM Offers o, Houses h 
WHERE o.houseID = h.houseID 
    AND o.offerPrice >= ALL (SELECT offerPrice 
                            FROM Offers ofr 
                            WHERE ofr.houseID = o.houseID);

-- Alternative3:

SELECT DISTINCT o.houseID AS houseID, h.address AS address, o.offerPrice AS highOffer 
FROM Offers o, Houses h 
WHERE o.houseID = h.houseID 
    AND NOT EXISTS (SELECT offerPrice 
                    FROM Offers ofr 
                    WHERE ofr.houseID = o.houseID 
                        AND ofr.offerPrice > o.offerPrice); 
*/

/*
* For each sold house for which the following are all true:
*   a) The buyer’s name starts with the letter ‘S’ (uppercase), and
*   b) the sold date was between February 10, 2020 and April 29, 2020 
*      (including those dates), and
*   c) the price for which the house was sold was greater than its for
*      sale price, and
*   d) there is at least one different house that is still for sale 
*      (isStillForSale) that has the same broker who put this house up for sale
* Output the houseID, ownerID, buyerID, soldPrice, forSalePrice, brokerID and 
* the companyName of the broker. The 7 attributes in your result should appear 
* as theHouselD, theOwnerID, theBuyerID, soldPrice, forSalePrice, theBrokerID 
* and theCompany. 
* No duplicates should appear in your result
*/

/*
DISTINCT is needed in the solution as the same house might have been sold multiple times.
*/

SELECT DISTINCT h.houseID AS theHouseID, h.ownerID AS theOwnerID, s.buyerID AS theBuyerID, s.soldPrice, 
                f1.forSalePrice, b.brokerID AS theBrokerID, b.companyName AS theCompany 
FROM SoldHouses s, Persons p, ForSaleHouses f1, Houses h, Brokers b, ForSaleHouses f2 
WHERE s.buyerID = p.personid 
    AND  p.personName ^@ 'S'
    AND  h.houseID = s.houseID 
    AND  b.brokerID = f1.brokerID 
    AND  s.houseID = f1.houseID 
    AND  s.forSaleDate = f1.forSaleDate 
    AND  s.soldDate BETWEEN '2020-02-10' AND '2020-04-29' 
    AND  s.soldPrice > f1.forSalePrice 
    AND  f1.houseID <> f2.houseID 
    AND  f1.brokerID = f2.brokerID 
    AND  f2.isStillForSale = 'TRUE';

/*
-- Alternative:

SELECT DISTINCT h.houseID AS theHouseID, h.ownerID AS theOwnerID, s.buyerID AS theBuyerID, 
                s.soldPrice AS soldPrice, f1.forSalePrice AS forSalePrice, 
                b.brokerID AS theBrokerID, b.companyName AS theCompany 
FROM SoldHouses s, Persons p, ForSaleHouses f1, Houses h, Brokers b 
WHERE s.buyerID = p.personid 
    AND p.personName LIKE 'S%' 
    AND h.houseID = s.houseID 
    AND b.brokerID = f1.brokerID 
    AND s.houseID = f1.houseID 
    AND s.forSaleDate = f1.forSaleDate 
    AND s.soldDate BETWEEN '2020-02-10' AND '2020-04-29' 
    AND s.soldPrice > f1.forSalePrice 
    AND EXISTS (SELECT brokerID 
                FROM   ForSaleHouses f2 
                WHERE  f2.houseID <> f1.houseID 
                    AND  f2.brokerID = f1.brokerID 
                    AND  f2.isStillForSale); 
*/