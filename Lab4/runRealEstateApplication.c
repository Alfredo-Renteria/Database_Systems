/*
* Alfredo Renteria
* Filename: runRealEstateApplication.c
* Main function and implementation of 3 C functions that interact with the database
* Code Status: Working/Tested
*/

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

//To allow length 1000, with null \0 terminator
#define bufsiz 1001

/**
* do_exit
* 
* Exit after closing connection to the server & frees memory used by PGconn obj
* 
* @param conn PGconn ptr. (DB connection) 
*/
static void do_exit(PGconn *conn);

/**
* getBrokerLevelCount
* 
* Exits on error when theBrokerLevel value is not ‘A’, ‘B’, ‘C’ or ‘D’.
* 
* @param conn PGconn ptr. (DB connection)
* @param theBrokerLevel char value - an atribute in the Brokers table
* @return int value count - the # of Brokers whose brokerLevel equals theBrokerLevel
*/
int getBrokerLevelCount(PGconn *conn, char theBrokerLevel);

/**
 * updateCompanyName
 * 
 * For every broker in the Brokers table (if any) whose companyName = oldCompanyName, 
 * updateCompanyName should update their companyName to be newCompanyName.  
 * (Of course, there might not be any tuples whose companyName matches oldCompanyName.)  
 * updateCompanyName should return the number of tuples that were updated (which might be 0).
 * 
 * @param conn PGconn ptr. (DB connection)
 * @param oldCompanyName char c-string - an attribute in the Brokers table
 * @param newCompanyName char c-string - a new attribute in the Brokers table
 * @return int value nTuplesUpdate - the # of rows that were updated; if any
*/
int updateCompanyName(PGconn *conn, char *oldCompanyName, char *newCompanyName);

/**
 * increaseSomeOfferPrices
 * 
 * This function invokes the Stored Function increaseSomeOfferPricesFunction,
 * which does all of the work, see Lab4/increaseSomeOfferPricesFunction.pgsql
 * Exits on error when the value of numOfferIncreases is not positive
 * 
 * @param conn PGconn ptr. (DB connection)
 * @param theOffererID int - an attribute in the Offers table
 * @param numOffersIncreases int value for # of offer increases
 * @return int value result - the # of rows that were updated
*/
int increaseSomeOfferPrices(PGconn *conn, int theOffererID, int numOfferIncreases);

int main(int argc, char **argv) {   
    PGconn *conn;
    int theResult;
    
    //Get user from cl-argument
    char *userID = argv[1];
    
    //Build conninfo profile
    char conninfo[bufsiz] = "user=";
    strcat(conninfo, userID);
    strcat(conninfo, " dbname=");
    strcat(conninfo, userID);
    
    //Make a connection to the DB
    conn = PQconnectdb(conninfo);
    
    //Check to see that the backend connection was successfully made
    if (PQstatus(conn) != CONNECTION_OK) {
        fprintf(stderr, "Connection to database failed: %s", PQerrorMessage(conn));
        do_exit(conn);
    }
    
    //Perform the cal to getBrokerLevelCount described in Lab4 & print its output
    char ch = 'B';
    theResult = getBrokerLevelCount(conn, ch);
    printf("/*\n * Output of getBrokerLevelCount\n * when the parameter theBrokerLevel is '%c'\n %d\n */\n\n", ch, theResult);

/*
Output of getBrokerLevelCount
when the parameter theBrokerLevel is 'B'
2
*/

    //Perform the call to updateCompanyName described in Lab4 & print its output.
    char oldCompanyName[31];
    char newCompanyName[31];
    
    strcpy(oldCompanyName, "Weathervane Group Realty");
    strcpy(newCompanyName, "Catbird Estates");
    
    theResult = updateCompanyName(conn, oldCompanyName, newCompanyName);
    printf("/*\n * Output of updateCompanyName when oldCompanyName is\n");
    printf(" * '%s' and newCompanyName is '%s'\n", oldCompanyName, newCompanyName);
    printf(" %d\n */\n\n", theResult);

/*
Output of updateCompanyName when oldCompanyName is
'Weathervane Group Realty' and newCompanyName is 'Catbird Estates'
2
*/
   
    strcpy(oldCompanyName, "Intero");
    strcpy(newCompanyName, "Sotheby");
    
    theResult = updateCompanyName(conn, oldCompanyName, newCompanyName);
    printf("/*\n * Output of updateCompanyName when oldCompanyName is\n");
    printf(" * '%s' and newCompanyName is '%s'\n", oldCompanyName, newCompanyName);
    printf(" %d\n */\n\n", theResult);

/*
Output of updateCompanyName when oldCompanyName is
'Intero' and newCompanyName is 'Sotheby'
1
*/    
        
    //Perform the two calls to increaseSomeOfferPrices described in Lab4 & print their outputs
    theResult = increaseSomeOfferPrices(conn,13,4);
    printf("/* \n * Output of increaseSomeOfferPrices when theOffererID  is 13\n * and numOfferIncreases is 4 is \n %d\n */\n\n", theResult);

/* 
Output of increaseSomeOfferPrices when theOffererID  is 13
and numOfferIncreases is 4 is 
3
*/

    theResult = increaseSomeOfferPrices(conn,13,2);
    printf("/* \n * Output of increaseSomeOfferPrices when theOffererID is 13\n * and numOfferIncreases is 2 is \n %d\n */\n\n", theResult);

/* 
Output of increaseSomeOfferPrices when theOffererID is 13
and numOfferIncreases is 2 is 
2
*/

    do_exit(conn);

    return 0;
}

static void do_exit(PGconn *conn) {
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

int getBrokerLevelCount(PGconn *conn, char theBrokerLevel) {
    if ((theBrokerLevel != 'A' && theBrokerLevel != 'B' 
        && theBrokerLevel != 'C' && theBrokerLevel != 'D')) {
        
        printf("getBrokerLevelCount: Error: %c Invalid brokerLevel\n", theBrokerLevel);
		exit(EXIT_FAILURE);
	}

    //To build query
    char query[bufsiz] = "SELECT COUNT(*) FROM Brokers WHERE brokerLevel='";
    
    strncat(query, &theBrokerLevel, 1);
    strcat(query, "'");
    
    //queryResult is a ptr. that points to the query result
    PGresult *queryResult = PQexec(conn, query);
    
    //Check for errors
    if (PQresultStatus(queryResult) != PGRES_TUPLES_OK) {
        fprintf(stderr, "SELECT failed: %s", PQerrorMessage(conn));
        PQclear(queryResult);
        do_exit(conn);
    }
    
    //Convert field value for [0][0] to integer
    int count = atoi(PQgetvalue(queryResult, 0, 0));
    
    PQclear(queryResult);
    
    return count;
}

int updateCompanyName(PGconn *conn, char *oldCompanyName, char *newCompanyName) {
    //To build UPDATE statement
    char stmt[bufsiz] = "UPDATE Brokers SET companyName = '";
    
    strcat(stmt, newCompanyName);
    strcat(stmt, "' WHERE companyName = '");
    strcat(stmt, oldCompanyName);
    strcat(stmt, "'");
    
    // Test print
    //printf("updateCompanyName(): UPDATE Statement: %s\n", updatePrompt);
    
    PGresult *updateResult = PQexec(conn, stmt);
    
    if (PQresultStatus(updateResult) != PGRES_COMMAND_OK) {
        fprintf(stderr, "UPDATE failed: %s", PQerrorMessage(conn));
        PQclear(updateResult);
        do_exit(conn);
    }

    //Convert # of rows affected by UPDATE if any to int
    int nTuplesUpdated = atoi(PQcmdTuples(updateResult));
    
    PQclear(updateResult);
    
    return nTuplesUpdated;
}

int increaseSomeOfferPrices(PGconn *conn, int theOffererID, int numOfferIncreases) {
    if (numOfferIncreases <= 0) {
        printf("increaseSomeOfferPrices: Error: numOfferIncreases %d NOT > 0", numOfferIncreases);
		exit(EXIT_FAILURE);
	}
        
    char query[bufsiz] = "SELECT increaseSomeOfferPricesFunction(";
    char offererIDnumOfferInc[bufsiz];
    
    //Compile offererID from input
    sprintf(offererIDnumOfferInc, "%d", theOffererID);
    strcat(query, offererIDnumOfferInc);
    strcat(query, ",");
    
    //Now number of offer increases
    sprintf(offererIDnumOfferInc, "%d", numOfferIncreases);
    strcat(query, offererIDnumOfferInc);
    strcat(query, ")");
    
    PGresult *queryResult = PQexec(conn, query);
    
    if (PQresultStatus(queryResult) != PGRES_TUPLES_OK) {
        fprintf(stderr, "FUNCTION failed: %s", PQerrorMessage(conn));
        PQclear(queryResult);
        do_exit(conn);
    }
    
    int result = atoi(PQgetvalue(queryResult, 0, 0));
    
    PQclear(queryResult);
    
    return result;
}