package event.handler.services;

import ballerina.io;
import ballerina.net.http;

import event.handler.serviceImpl as impl;

endpoint<http:Service> eventServiceEP {
             port:9093
              }

@http:serviceConfig { endpoints:[eventServiceEP], basePath:"/events" }

service<http:Service> eventsDataService {

    @http:resourceConfig {
        methods:["POST"],
        path:"/add"
    }
    resource addEvent (http:ServerConnector conn, http:Request req) {
        var jsonPayload, _ = req.getJsonPayload();

        _ = conn -> respond(impl:handleAddEvent(jsonPayload));

    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/get"
    }
    resource getAllEvent (http:ServerConnector conn,http:Request req) {
        _ = conn -> respond(impl:handleGetAllEventRequest(req));
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/delete/{name}"
    }
    resource deleteEvent (http:ServerConnector conn,http:Request req, string name) {
        // Need to implement
    }

}
