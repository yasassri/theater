package src.persistance;

import ballerina.io;
import src.model as mod;

const string TABLE_NAME = "tickets";

const string getTicketByID = "SELECT * FROM " + TABLE_NAME + " where EVENT_ID = ?";
const string addTicketByID = "INSERT INTO " + TABLE_NAME + " (EVENT_ID, TOTAL, TYPE , PRICE, BOOKED) VALUES (?, ?, ?, ?, 0)";

// tickets table
// CREATE TABLE tickets(ID INT AUTO_INCREMENT, EVENT_ID INT, TOTAL INT, BOOKED INT, TYPE VARCHAR(255), PRICE DECIMAL(6,2), PRIMARY KEY (ID));

public function getTicketCountByEventId (int eventId)(json, error) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:eventId};
    params = [ para1 ];
    table dt = ep.select(getTicketByID, params, null);
    
    var jsonRes, err = <json>dt;
    // Check for errors

    return jsonRes, err;
}


public function addTicketCountByEventId (mod:Ticket tick)(json jsonRes, error err) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    io:println(tick.price);
    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:tick.eventId};
    sql:Parameter para2 = {sqlType:sql:Type.VARCHAR, value:tick.total_tickets};
    sql:Parameter para3 = {sqlType:sql:Type.VARCHAR, value:tick.ticketType};
    sql:Parameter para4 = {sqlType:sql:Type.DECIMAL, value:tick.price};
    params = [ para1, para2, para3, para4 ];
    int ret = ep.update(addTicketByID, params);
    
     if (ret == 1) {
            jsonRes = {"Success" : tick.eventId + " added tickets successfully"};
        } else {
            err = {message:"Ticket for " + tick.eventId + " Couldn't be added"};
        }
    return;
}
