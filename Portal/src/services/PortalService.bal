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

    resource getEvents (http:Connection conn,http:InRequest req) {      
        _ = conn.respond(impl:hadleGetEvents());
        }

    @http:resourceConfig {
        methods:["POST"],
        path:"addEvents"
    }

    resource addTickets (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
   
        _ = conn.respond(impl:handleAddTickets(req.getJsonPayload()));
        }

        @http:resourceConfig {
        methods:["POST"],
        path:"purchase"
    }

    resource buyTickets (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
       
        // json jsonRes = ops:addTicketCountByEventId();
        // res.setJsonPayload(jsonRes);
        //     _ = conn.respond(res);
        }
    }