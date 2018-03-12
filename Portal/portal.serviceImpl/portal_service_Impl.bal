package portal.serviceImpl;

import ballerina.net.http;
import portal.connectors as con;
import portal.model as mod;
import portal.utils as util;
import ballerina.io;

public function hadleGetEvents () (http:Response res) {

    // Here we need to call the Event Service
    res = {};
    // Need to improve to handle error case
    json j = con:getEvents();
    res.setJsonPayload(j);
    return;
}

public function handleAddTickets (json jsonPayload) (http:Response res) {

    res = {};
    var payLoad, err2 = <mod:AddEvent>jsonPayload;

    // Now we need to extract event part from the Payload.
    json event = util:generateEventRequest(payLoad);

    // Extact ticket information
    var tickets = payLoad.tickets;

    // Add the event first
    var resp, status = con:addEvent(event);

    if (status > 400) {
        res.setJsonPayload(resp);
        res.statusCode = status;
        return;
    }
    // Now add the tickets.   
    foreach ticket in tickets {

        var i, err = <int>resp.id.toString();

        // Constrct the request JSon
        json js = {
                      "id":0,
                      "ticket_type":ticket.ticket_type,
                      "event_id":i,
                      "total":ticket.total,
                      "booked":ticket.booked,
                      "price":ticket.price
                  };
        var addTicketres = con:addTicket(js);
    }
    // To-DO: If ticket adding fails the event should be rolled back
    res.setJsonPayload(resp);
    return;
}

public function handleGetTickets (string id) (http:Response res) {
    res = {};
    var a = con:getTicket(id);
    res.setJsonPayload(a);
    return;
}


public function handlePurchaseTickets (json jsonPayload) (http:Response res) {
    res = {};
    var c, err = <mod:PurchaseTicket>jsonPayload;
    if (err != null) {
        res.setJsonPayload(err.message);
        return;
    }
    // Get the ticket information // Improve the string conversion
    var b = con:getTicket(c.eventId + "");

    var tick, ticketId = util:getTicketByType(b, c.ticket_type);

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

    var gateWayRes, gwStatus = con:makePayment(jsonPayload);

    if (gwStatus != 200) {
        res.setJsonPayload(gateWayRes);
        res.statusCode = gwStatus;
        return;
    }

    // If reached Payment is successfull. Deduct the ticket count
    var tickUpdateRes = con:updateTicket(ticketId, c.noOfTickets);

    res.setJsonPayload(tickUpdateRes);
    res.statusCode = 200;
    return;
}