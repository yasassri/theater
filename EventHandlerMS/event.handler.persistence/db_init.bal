package event.handler.persistence;

import ballerina.data.sql;
import ballerina.io;

const string h2DbLocation = "./";
const int h2Port = 3306;
const string h2Database = "EVENTS";
const string h2UserName = "root";
const string h2Password = "root";
// Above will be replaced from the config API as below
// string mysqlHostName = config:getGlobalValue("database.host");

public endpoint sql:Client dbEP { database: sql:DB.H2_FILE, host: h2DbLocation,port: 0,name: h2Database,username: h2UserName,password: h2Password};

// Done as a workaround to init the Database                                                                                                                                        //
string c = initializeDB();

function initializeDB ()(string a) {
    endpoint sql:Client dbEP2 { database: sql:DB.H2_FILE, host: h2DbLocation,port: 0,name: h2Database,username: h2UserName,password: h2Password};
    string query2 = "CREATE TABLE IF NOT EXISTS EVENTS(ID INT AUTO_INCREMENT, NAME VARCHAR(255) UNIQUE, START_TIME
    VARCHAR(255) NOT NULL, VENUE VARCHAR(10) NOT NULL, ORGANIZER_NAME VARCHAR(255) NOT NULL, PRIMARY KEY (ID))";
    int ret = dbEP2 -> update(query2, null);
    io:println("Initializing DB");
    a = "Yes";
    if (ret != 0) {
        error e = {message: "Error occured while initializing the DB"};
        //throw e;
    }
    return;
}