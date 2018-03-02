package src.serviceImpl;

import ballerina.net.http;
import ballerina.io;
import src.model as mod;
import src.utils as util;
import src.connectors as con;

public function hadleGetEvents ()(http:OutResponse res) {

// Here we need to call the Event Service
    res = {};
    // Need to improve to handle error case
    json j = con:getEvents();
    res.setJsonPayload(j);
    return;
}

public function handleAddTickets (json jsonPayload)(http:OutResponse res) {

    
    var payLoad, err2 = <mod:AddEvent>jsonPayload;

    io:println("errXXXXXXXXXXXXXX");
        io:println(err2);
    
    // Now we need to extract event part from the Payload.
   json event = {
        "name": payLoad.name,
        "start_time": payLoad.start_time,
        "venue": payLoad.venue,
        "organizer_name": payLoad.organizer_name,
        "event_type": payLoad.event_type
         };

    // Extact ticket information
    var tickets = payLoad.tickets;
    
    // Add the event first
    var resp = con:addEvent(event);
    // Now add the tickets.   
    foreach ticket in tickets) {
        var js, err = <json>ticket;

        io:println("err");
        io:println(err);
        io:println(con:addTicket(js));
    }
    // To-DO: If ticket adding fails the event should be removed
    return;
}


public function handlePurchaseTickets (json jsonPayload)(http:OutResponse res) {
 // Need to implement
    return;
}