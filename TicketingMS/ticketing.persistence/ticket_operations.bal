package ticketing.persistence;

import ballerina/io;

import ticketing.model as mod;

const string TABLE_NAME = "tickets";

const string getTicketByID = "SELECT * FROM " + TABLE_NAME + " where EVENT_ID = ?";
const string addTicketByID = "INSERT INTO " + TABLE_NAME + " (EVENT_ID, TOTAL, TICKET_TYPE , PRICE, BOOKED) VALUES (?, ?, ?, ?, 0)";

public function getTicketCountByEventId (int eventId) returns json | error {

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:eventId};
    params = [ para1 ];
    table dt =? dbEP -> select(getTicketByID, params, typeof mod:Ticket);
    //TODO improve this code
    var jsonRes =? <json>dt;
    // Check for errors
    return jsonRes;
}


public function addTicketCountByEventId (mod:Ticket tick) returns json | error {

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:tick.event_id};
    sql:Parameter para2 = {sqlType:sql:Type.VARCHAR, value:tick.total};
    sql:Parameter para3 = {sqlType:sql:Type.VARCHAR, value:tick.ticket_type};
    sql:Parameter para4 = {sqlType:sql:Type.DECIMAL, value:tick.price};
    params = [ para1, para2, para3, para4 ];
    int ret =? dbEP -> update(addTicketByID, params);
    
     if (ret == 1) {
            json jsonRes = {"Success" : tick.event_id + " added tickets successfully"};
            return jsonRes;
        } else {
            error err = { message:"Ticket for " + tick.event_id + " Couldn't be added" };
            return err;
        }
}

// Update ticket table
public function updateTicketCount (int ticketId, int count) returns json | error {

    // Update the existing ticket count
    string updateTicketByID = "UPDATE " + TABLE_NAME + " SET BOOKED = BOOKED + ? WHERE id = ?";

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.DOUBLE, value:count};
    sql:Parameter para2 = {sqlType:sql:Type.DOUBLE, value:ticketId};
    
    params = [ para1, para2 ];
    int ret =? dbEP -> update(updateTicketByID, params);
    
    if (ret == 1) {
            json jsonRes = {"Success" : ticketId + " updated successfully"};
            return jsonRes;
        } else {
            error err = { message:"Ticket for " + ticketId + " Couldn't be added" };
            return err;
        }
}
