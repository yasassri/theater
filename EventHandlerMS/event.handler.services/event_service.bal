package event.handler.services;

import ballerina/io;
import ballerina/net.http;

import event.handler.serviceImpl as impl;

endpoint http:ServiceEndpoint eventServiceEP {
             port:9093
              };

@http:ServiceConfig { basePath:"/events" }
service<http:Service> eventsDataService bind eventServiceEP {

    @http:ResourceConfig {
        methods:["POST"],
        path:"/add"
    }
     addEvent (endpoint conn, http:Request req) {

        http:Response res = {};
        var pl = req.getJsonPayload();
        match pl {
            error err => {
                res.setJsonPayload(err.message);
                res.statusCode = 500;
            }
            json jsonPayload => {
                res = impl:handleAddEvent(jsonPayload);
            }
        }
     _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/get"
    }
     getAllEvent (endpoint conn,http:Request req) {
        _ = conn -> respond(impl:handleGetAllEventRequest(req));
    }

    @http:ResourceConfig {
        methods:["DELETE"],
        path:"/delete/{name}"
    }
     deleteEvent (endpoint conn,http:Request req, string name) {
        // Need to implement
    }

}
