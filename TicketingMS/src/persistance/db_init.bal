package src.persistance;

import ballerina.data.sql;

public sql:ClientConnector sqlCon = initDb();

function initDb () (sql:ClientConnector connInit) {
    string dbLocation = "./";
    int h2Port = 0;
    string h2Database = "TICKETS";
    string h2UserName = "root";
    string h2Password = "root";
    // Above will be replaced from the config API as below
    // string mysqlHostName = config:getGlobalValue("database.host");
    // var mysqlPort, _ = <int>config:getGlobalValue("database.port");
    sql:ConnectionProperties propertiesInit = {maximumPoolSize:5, connectionTimeout:300000, datasourceProperties:null};
    connInit = create sql:ClientConnector(sql:DB.H2_FILE, dbLocation, h2Port, h2Database, h2UserName, h2Password, propertiesInit);
    initializeDB(connInit);
    return;
}

function initializeDB (sql:ClientConnector connInit) {
    endpoint<sql:ClientConnector> ep {}
    bind connInit with ep;
    string query = "CREATE TABLE IF NOT EXISTS TICKETS(ID INT AUTO_INCREMENT, EVENT_ID INT, TOTAL INT, BOOKED INT,
    TICKET_TYPE VARCHAR(255), PRICE DECIMAL(6,2), PRIMARY KEY (ID))";
    int ret = ep.update(query, null);

    if (ret != 0) {
        error e = {message:"Error occured while initializing the DB"};
        throw e;
    }
}