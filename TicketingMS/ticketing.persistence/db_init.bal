package ticketing.persistence;

import ballerina.data.sql;

string dbLocation = "./";
int h2Port = 0;
string h2Database = "TICKETS";
string h2UserName = "root";
string h2Password = "root";

public endpoint sql:Client dbEP { database: sql:DB.H2_FILE, host: dbLocation,port: 0,name: h2Database,username: h2UserName,password: h2Password};


function initializeDB ()(string a) {
endpoint sql:Client dbEP2 { database: sql:DB.H2_FILE, host: dbLocation,port: 0,name: h2Database,username: h2UserName,password: h2Password};

  string query2 = "CREATE TABLE IF NOT EXISTS TICKETS(ID INT AUTO_INCREMENT, EVENT_ID INT, TOTAL INT, BOOKED INT,
    TICKET_TYPE VARCHAR(255), PRICE DECIMAL(6,2), PRIMARY KEY (ID))";
    int ret = dbEP2 -> update(query2, null);
    a = "";
    if (ret != 0) {
        error e = {message:"Error occured while initializing the DB"};
        throw e;
    }
  return;
}