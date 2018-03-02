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

    res = {};
    var payLoad, err2 = <mod:AddEvent>jsonPayload;
    
    // Now we need to extract event part from the Payload.
   json event = util:generateEventRequest(payLoad);

    // Extact ticket information
    var tickets = payLoad.tickets;
    
    // Add the event first
    var resp, status = con:addEvent(event);

    if(status > 400) {
       res.setJsonPayload(resp);
       res.statusCode = status;
       return;
    }
    // Now add the tickets.   
    foreach ticket in tickets) {
        var i, err = <int>resp.id.toString();
        ticket.eventId = i;
        var js, err = <json>ticket;
        // IF error we need to revert the process
        var addTicketres = con:addTicket(js);
    }
    // To-DO: If ticket adding fails the event should be rolled back
    io:println(resp);
    res.setJsonPayload(resp);
    return;
}

public function handlePurchaseTickets (json jsonPayload)(http:OutResponse res) {
 // Need to implement
    return;
}