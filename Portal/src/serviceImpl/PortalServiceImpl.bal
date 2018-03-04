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
    io:println("XXXXXX");
    io:println(payLoad);
    io:println(err2);
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
    foreach ticket in tickets {
        
        var i, err = <int>resp.id.toString();
        
        // Constrct the request JSon
        json js = {
                "ticket_type": ticket.ticket_type,
                "eventId": i,
                "total_tickets": ticket.total_tickets,
                "booked_tickets": ticket.booked_tickets,
                "price": ticket.price
                };
        // ticket.event_id = i;
        // var js, err = <json>ticket;
        // IF error we need to revert the process
        var addTicketres = con:addTicket(js);
    }
    // To-DO: If ticket adding fails the event should be rolled back
    res.setJsonPayload(resp);
    return;
}

public function handleGetTickets (string id)(http:OutResponse res) {
    res = {};
    var a = con:getTicket(id);
    io:println(a);
    res.setJsonPayload(a);
    return;
}


public function handlePurchaseTickets (json jsonPayload)(http:OutResponse res) {
    res = {};

    var c, err  = <mod:PurchaseTicket>jsonPayload;
    if (err != null) {
        res.setJsonPayload(err.message);
        return;
    }

    // Get the ticket information // Improve the string conversion
    var b = con:getTicket(c.eventId + "");
    var tick = util:getTicketByType (b, c.ticket_type);
    if (tick == null) {
        // There is no matching type, Lets throw a error
        error er = {message: "No Matching Ticket Type found"};
        res.statusCode = 500;
        res.setJsonPayload(util:generateJsonFromError(er));
        return;
    }
    io:println("gateWayResXXXXXXXXX");
    //Check whether we have enough tickets
    if ( c.noOfTickets >  tick.TOTAL - tick.BOOKED) {
        // Not enough tickets
        error er = {message: "The ammount you requested not available."};
        res.statusCode = 500;
        res.setJsonPayload(util:generateJsonFromError(er));
        return;
    }

    var gateWayRes, gwStatus = con:makePayment(jsonPayload);

     if(gwStatus != 200) {
       res.setJsonPayload(gateWayRes);
       res.statusCode = gwStatus;
       return;
    }

    // If reached Payment is successfull. Deduct the ticket count
    var tickUpdateRes = con:updateTicket(tick.ID, c.noOfTickets);

    res.setJsonPayload(tickUpdateRes);
    res.statusCode = 200;
    return;
}