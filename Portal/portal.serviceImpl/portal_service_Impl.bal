package portal.serviceImpl;

import ballerina/net.http;
import ballerina/io;

import portal.connectors as con;
import portal.model as mod;
import portal.utils as util;

public function hadleGetEvents () returns (http:Response) {

    // Here we need to call the Event Service
    http:Response res = {};
    // Need to improve to handle error case
    json j =? con:getEvents();
    res.setJsonPayload(j);
    return res;
}

public function handleAddTickets (json jsonPayload) returns (http:Response) {

    http:Response res = {};
    var payLoad =? <mod:AddEvent>jsonPayload;

    // Now we need to extract event part from the Payload.
    json event = util:generateEventRequest(payLoad);

    // Extact ticket information
    var tickets = payLoad.tickets;

    // Add the event first
    var status = con:addEvent(event);
    match status {
        error addEvnterr => {}
        json resp => {

    // Extracting the Event ID from the response
    var i =? <int>resp.id.toString();
    // Now add the tickets.
    foreach ticket in tickets {
        // Constrct the request JSon
        json js2 = {
                      "id":0,
                      "ticket_type":ticket.ticket_type,
                      "event_id":i,
                      "total":ticket.total,
                      "booked":ticket.booked,
                      "price":ticket.price
                  };
        var addTicketres = con:addTicket(js2);
    }

    // To-DO: If ticket adding fails the event should be rolled back
    res.setJsonPayload(resp);
    return res;
    }
}

}

public function handleGetTickets (string id) returns (http:Response) {
    http:Response res = {};
    var a = con:getTicket(id);
    res.setJsonPayload(a);
    return;
}


public function handlePurchaseTickets (json jsonPayload) returns (http:Response) {
    http:Response res = {};
    var c =? <mod:PurchaseTicket>jsonPayload;
    if (err != null) {
        res.setJsonPayload(err.message);
        return;
    }
    // Get the ticket information // Improve the string conversion
    var b = con:getTicket(c.eventId + "");

    var (tick, ticketId) = util:getTicketByType(b, c.ticket_type);

    if (tick == null) {
        // There is no matching type, Lets throw a error
        error er = {message:"No Matching Ticket Type found"};
        res.statusCode = 500;
        res.setJsonPayload(util:generateJsonFromError(er));
        return;
    }

    //Check whether we have enough tickets
    if (c.noOfTickets > tick.total - tick.booked) {
        // Not enough tickets
        error er = {message:"The ammount you requested not available."};
        res.statusCode = 500;
        res.setJsonPayload(util:generateJsonFromError(er));
        return;
    }

    error|null response = con:makePayment(jsonPayload);
    match response {
        error paymentErr => {
            res.setJsonPayload(util:generateJsonFromError(paymentErr));
            res.statusCode = 500;
            return res;
    }
        null => {io:println("Payment success!!");}
}


    // If reached Payment is successfull. Deduct the ticket count
    var tickUpdateRes = con:updateTicket(ticketId, c.noOfTickets);

    res.setJsonPayload(tickUpdateRes);
    res.statusCode = 200;
    return;
}