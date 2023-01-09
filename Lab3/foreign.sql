/*
* Alfredo Renteria
* Filename: foreign.sql
* Lab3: 2.3 Add Foreign Key Constraints
*/

ALTER TABLE Brokers
    ADD FOREIGN KEY(brokerID) 
    REFERENCES Persons(personID); -- default reject delete & update

/*
-- Alternative:

ALTER TABLE Brokers 
ADD FOREIGN KEY(brokerID) 
REFERENCES Persons(personID)
	ON DELETE RESTRICT 
	ON UPDATE RESTRICT;

-- Alternative2:

ALTER TABLE Brokers 
ADD CONSTRAINT broker_constraint FOREIGN KEY(brokerID) 
REFERENCES Persons(personID)
	ON DELETE RESTRICT 
	ON UPDATE RESTRICT;

*/

ALTER TABLE Offers
    ADD FOREIGN KEY(offererID) 
    REFERENCES Persons(personID)
        ON DELETE CASCADE -- deleted same way
        ON UPDATE CASCADE; -- updated ' '
/*
--Alternative:

ALTER TABLE Offers 
ADD CONSTRAINT offerer_constraint FOREIGN KEY(offererID) 
REFERENCES Persons(personID)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
*/

ALTER TABLE SoldHouses
    ADD FOREIGN KEY(buyerID)
    REFERENCES Persons(personID)
        ON DELETE SET NULL -- if deleted, set to NULL
        ON UPDATE CASCADE; -- updated same way

/*

--Alternative:

ALTER TABLE SoldHouses 
ADD CONSTRAINT buyer_constraint FOREIGN KEY(buyerID) 
REFERENCES Persons(personID)
	ON DELETE SET NULL
	ON UPDATE CASCADE;
*/
