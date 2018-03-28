package ticketing.serviceImpl;

import ballerina/io;
import ballerina/net.http;

import ticketing.model as mod;
import ticketing.persistence as db;
import ticketing.utils as util;

public function hadleGetTicketsByEventId (int eventId) returns http:Response {

    http:Response res = {};
    var pl = db:getTicketCountByEventId(eventId);
    match pl {
        json js => {
            res.setJsonPayload(js);
            res.statusCode = 200;
            return res;
        }
        error err => {
            res.setJsonPayload(err.message);
            res.statusCode = 500;
            return res;
        }
    }

}

// Handle Ticket adding flow.
public function handleAddTickets (json jsonPayload) returns http:Response {

    http:Response res = {};
    var ticket =? <mod:Ticket>jsonPayload;

    var pl = db:addTicketCountByEventId(ticket);
    match pl {
          json js => {
            res.setJsonPayload(js);
            res.statusCode = 200;
            return res;
          }
          error err => {
            res.setJsonPayload(err.message);
            res.statusCode = 500;
            return res;
          }
    }
}


public function handlePurchaseTickets (json jsonPayload) returns http:Response {

    http:Response res = {};
    var ticket =? <mod:Ticket>jsonPayload;
    //if (err != null) {
    //    // The payload is not what we expected
    //    res.setJsonPayload(util:generateJsonFromError(err));
    //    res.statusCode = 500;
    //    return;
    //}

    var pl = db:addTicketCountByEventId(ticket);
    match pl {
        json js => {
            res.setJsonPayload(js);
            res.statusCode = 200;
            return res;
        }
            error err => {
            res.setJsonPayload(err.message);
            res.statusCode = 500;
            return res;
        }
    }

}

// Handle Update ticket
public function handleUpdateTickets (string id, string count) returns http:Response {
    http:Response res = {};
    var i  =? <int>id;
    var c =? <int>count;

    var pl = db:updateTicketCount(i, c);
    match pl {
        json js => {
            res.setJsonPayload(js);
            res.statusCode = 200;
            return res;
        }
        error err => {
            res.setJsonPayload(err.message);
            res.statusCode = 500;
            return res;
        }
    }
}