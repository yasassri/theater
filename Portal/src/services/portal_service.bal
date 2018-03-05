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
        path:"events"
    }

    resource getEvents (http:Connection conn,http:InRequest req) {      
        _ = conn.respond(impl:hadleGetEvents());
        }

    @http:resourceConfig {
        methods:["POST"],
        path:"events"
    }
    resource addTickets (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
        _ = conn.respond(impl:handleAddTickets(req.getJsonPayload()));
        }

        @http:resourceConfig {
        methods:["GET"],
        path:"tickets/{eventId}"
    }
    resource getTickets (http:Connection conn,http:InRequest req, string eventId) {
       
               _ = conn.respond(impl:handleGetTickets(eventId));
        }


    @http:resourceConfig {
        methods:["POST"],
        path:"purchase"
    }
    resource buyTickets (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
       
       var a = impl:handlePurchaseTickets(req.getJsonPayload());
        // json jsonRes = ops:addTicketCountByEventId();
        // res.setJsonPayload(jsonRes);
         _ = conn.respond(a);
        }
    }