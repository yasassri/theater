package src.services;

import ballerina.net.http;
import ballerina.io;

import src.serviceImpl as impl;

@http:configuration {
    basePath:"/portal"
}
    service<http> PortalService {
 @http:resourceConfig {
        methods:["GET"],
        path:"getEvents"
    }

    resource getEvents (http:Connection conn,http:InRequest req, string eventID) {      
        var id, _ = <int> eventID;
        _ = conn.respond(impl:hadleGetEvents());
        }

    @http:resourceConfig {
        methods:["POST"],
        path:"addEvents"
    }

    resource addTickets (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
       
        json jsonRes = impl:addTicketCountByEventId(id, ticketNumber);
        res.setJsonPayload(jsonRes);
            _ = conn.respond(res);
        }

        @http:resourceConfig {
        methods:["POST"],
        path:"purchase"
    }

    resource buyTickets (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
       
        var id, _ = <int> eventID;
        var ticketNumber, _ = <int> ticketNo;
        json jsonRes = ops:addTicketCountByEventId(id, ticketNumber);
        res.setJsonPayload(jsonRes);
            _ = conn.respond(res);
        }
    }