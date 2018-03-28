package ticketing.persistence;

import ballerina/data.sql;

string dbLocation = "./";
string h2Database = "TICKETS";

public endpoint sql:Client dbEP { database: sql:DB.H2_FILE, host: dbLocation,name: h2Database };

int b = initializeDB();

function initializeDB () returns int {
endpoint sql:Client dbEP2 { database: sql:DB.H2_FILE, host: dbLocation,name: h2Database };

  string query2 = "CREATE TABLE IF NOT EXISTS TICKETS(ID INT AUTO_INCREMENT, EVENT_ID INT, TOTAL INT, BOOKED INT,
    TICKET_TYPE VARCHAR(255), PRICE DECIMAL(6,2), PRIMARY KEY (ID))";
    int ret =? dbEP2 -> update(query2, null);
    if (ret != 0) {
        error e = {message:"Error occured while initializing the DB"};
        throw e;
    }
  return ret;
}