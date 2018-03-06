package src.persistance;

import ballerina.io;
import src.model as mod;

const string TABLE_NAME = "tickets";

const string getTicketByID = "SELECT * FROM " + TABLE_NAME + " where EVENT_ID = ?";
const string addTicketByID = "INSERT INTO " + TABLE_NAME + " (EVENT_ID, TOTAL, TICKET_TYPE , PRICE, BOOKED) VALUES (?, ?, ?, ?, 0)";

public function getTicketCountByEventId (int eventId)(json, error) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:eventId};
    params = [ para1 ];
    table dt = ep.select(getTicketByID, params, typeof mod:Ticket);
    var jsonRes, err = <json>dt;
    // Check for errors
    return jsonRes, err;
}


public function addTicketCountByEventId (mod:Ticket tick)(json jsonRes, error err) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:tick.event_id};
    sql:Parameter para2 = {sqlType:sql:Type.VARCHAR, value:tick.total};
    sql:Parameter para3 = {sqlType:sql:Type.VARCHAR, value:tick.ticket_type};
    sql:Parameter para4 = {sqlType:sql:Type.DECIMAL, value:tick.price};
    params = [ para1, para2, para3, para4 ];
    int ret = ep.update(addTicketByID, params);
    
     if (ret == 1) {
            jsonRes = {"Success" : tick.event_id + " added tickets successfully"};
        } else {
            err = {message:"Ticket for " + tick.event_id + " Couldn't be added"};
        }
    return;
}

// Update ticket table
public function updateTicketCount (int ticketId, int count)(json jsonRes, error err) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    // Update the existing ticket count
    string updateTicketByID = "UPDATE " + TABLE_NAME + " SET BOOKED = BOOKED + ? WHERE id = ?";

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.DOUBLE, value:count};
    sql:Parameter para2 = {sqlType:sql:Type.DOUBLE, value:ticketId};
    
    params = [ para1, para2 ];
    int ret = ep.update(updateTicketByID, params);
    
    if (ret == 1) {
            jsonRes = {"Success" : ticketId + " updated successfully"};
        } else {
            err = {message:"Ticket for " + ticketId + " Couldn't be added"};
        }
    // Check for errors
    return jsonRes, err;
}

public struct Ticket3 {

    string ticket_type;
    int id;
    int event_id;
    int total;
    int booked;
    float price;

}