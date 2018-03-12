package portal.services;

import ballerina.net.http;
import portal.serviceImpl as impl;


endpoint<http:Service> portalEP {
             port: 9090
         }

@http:serviceConfig {
    endpoints:[portalEP], basePath: "/portal"
}
service<http:Service> PortalService {

    @http:resourceConfig {
        methods:["GET"],
        path:"events"
    }

    resource getEvents (http:ServerConnector conn, http:Request req) {
        _ = conn -> respond(impl:hadleGetEvents());
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"events"
    }
    resource addTickets (http:ServerConnector conn, http:Request req) {

        var jsonPayload, _ = req.getJsonPayload();
        _ = conn -> respond(impl:handleAddTickets(jsonPayload));
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"tickets/{eventId}"
    }
    resource getTickets (http:ServerConnector conn, http:Request req, string eventId) {

        _ = conn -> respond(impl:handleGetTickets(eventId));
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"purchase"
    }
    resource buyTickets (http:ServerConnector conn, http:Request req) {

        var jsonPayload, _ = req.getJsonPayload();
        var a = impl:handlePurchaseTickets(jsonPayload);
        // json jsonRes = ops:addTicketCountByEventId();
        // res.setJsonPayload(jsonRes);
        _ = conn -> respond(a);
    }
}