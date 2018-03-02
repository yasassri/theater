package src.serviceImpl;

import ballerina.net.http;
import src.persistance as db;
import src.model as mod;
import src.utils as util;

public function hadleGetEvents ()(http:OutResponse res) {

// Here we need to call the Event Service
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

public function handleAddTickets (json jsonPayload)(http:OutResponse res) {

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