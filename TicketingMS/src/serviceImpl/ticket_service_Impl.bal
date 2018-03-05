package src.serviceImpl;

import ballerina.net.http;
import ballerina.io;
import src.persistance as db;
import src.model as mod;
import src.utils as util;

public function hadleGetTicketsByEventId (int eventId)(http:OutResponse res) {

    res = {};
    var pl, err = db:getTicketCountByEventId(eventId);
    if (err != null) {    
        res.setJsonPayload(err.message);
        res.statusCode = 500;
        return;
        }
    res.setJsonPayload(pl);
    res.statusCode = 200;
    return;
}

// Handle Ticket adding flow.
public function handleAddTickets (json jsonPayload)(http:OutResponse res) {

    res = {};
    var ticket, err = <mod:Ticket> jsonPayload;
    io:println(ticket);
        if (err != null) {
            // The payload is not what we expected
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return;
        }

    var pl, err = db:addTicketCountByEventId(ticket);
    if (err != null) {    
        res.setJsonPayload(err.message);
        res.statusCode = 500;
        return;
        }
    res.setJsonPayload(pl);
    res.statusCode = 200;
    return;
}


public function handlePurchaseTickets (json jsonPayload)(http:OutResponse res) {

    res = {};
    var ticket, err = <mod:Ticket> jsonPayload;
        if (err != null) {
            // The payload is not what we expected
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return;
        }

    var pl, err = db:addTicketCountByEventId(ticket);
    if (err != null) {    
        res.setJsonPayload(err.message);
        res.statusCode = 500;
        return;
        }
    res.setJsonPayload(pl);
    res.statusCode = 200;
    return;
}


// Handle Update ticket
public function handleUpdateTickets(string id, string count)(http:OutResponse res) {
    res = {};
    var i, _ = <int>id;
    var c, _ = <int>count;
    var pl, err = db:updateTicketCount(i, c);    
      if (err != null) {
            // The payload is not what we expected
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return;
        }
    res.setJsonPayload(pl);
    res.statusCode = 200;
    return;
}