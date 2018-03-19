package portal.services;

import ballerina.net.http;
import portal.serviceImpl as impl;


endpoint http:ServiceEndpoint portalEP {
             port: 9090
         };

@http:ServiceConfig {
     basePath: "/portal"
}
service<http:Service> PortalService bind portalEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"events"
    }

     getEvents (endpoint conn, http:Request req) {
        _ = conn -> forward(impl:hadleGetEvents());
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"events"
    }
     addTickets (endpoint conn, http:Request req) {

        var jsonPayload, _ = req.getJsonPayload();
        _ = conn -> forward(impl:handleAddTickets(jsonPayload));
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"tickets/{eventId}"
    }
     getTickets (endpoint conn, http:Request req, string eventId) {

        _ = conn -> forward(impl:handleGetTickets(eventId));
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"purchase"
    }
     buyTickets (endpoint conn, http:Request req) {

        var jsonPayload, _ = req.getJsonPayload();
        var a = impl:handlePurchaseTickets(jsonPayload);
        // json jsonRes = ops:addTicketCountByEventId();
        // res.setJsonPayload(jsonRes);
        _ = conn -> forward(a);
    }
}