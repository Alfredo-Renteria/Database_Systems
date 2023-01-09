/*
* Alfredo Renteria
* Filename: general.sql
* Lab3: 2.4 Add General Constraints 
*/

/*
In SoldHouses, soldPrice must be greater than zero. Please give a name to this constraint when you create it.
*/
ALTER TABLE SoldHouses
    ADD CONSTRAINT positive_soldPrice
        CHECK(soldPrice > 0);

/*
In Brokers, the value of brokerLevel must be either ‘A’, ‘B’, ‘C’, ‘D’ or NULL.
*/
ALTER TABLE Brokers
    ADD CONSTRAINT certified_brokerLevel 
        CHECK(brokerLevel = 'A' 
            OR brokerLevel = 'B' 
            OR brokerLevel = 'C' 
            OR brokerLevel = 'D'
            OR brokerLevel IS NULL);

/*
-- Alternative: IN

ALTER TABLE Brokers 
    ADD CONSTRAINT certified_brokerLevel 
        CHECK(brokerLevel IN ('A','B','C','D') 
            OR brokerLevel IS NULL);


-- Alternative2: BETWEEN

ALTER TABLE Brokers 
ADD CONSTRAINT certified_brokerLevel 
  CHECK(brokerLevel BETWEEN 'A' AND 'D' 
    OR brokerLevel IS NULL);
*/

/*
In Offers, if offerPrice is NULL, then isACurrentOffer must also be NULL
IF A THEN B logically correspond to (NOT A) OR B
*/
ALTER TABLE Offers
        ADD CONSTRAINT if_then
            CHECK ((offerPrice IS NOT NULL) 
                OR (isACurrentOffer IS NULL));

/*
-- Alternative: NOT(A AND B) OR B

ALTER TABLE Offers 
    ADD CHECK((offerPrice IS NOT NULL AND isACurrentOffer IS NOT NULL) 
        OR (isACurrentOffer IS NULL));
*/