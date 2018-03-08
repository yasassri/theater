package event.handler.services;

import ballerina.io;
import ballerina.net.http;
import event.handler.serviceImpl as impl;

public function dummy ()(int a) {
    io:println("test");
    // This is added as a workaround to make services visible from different packages
    return;
}

@http:configuration {
    basePath:"/events",
    port:9093
}
service<http> eventsDataService {

    @http:resourceConfig {
        methods:["POST"],
        path:"/add"
    }
    resource addEvent (http:Connection conn, http:InRequest req) {
        var jsonPayload, _ = req.getJsonPayload();

        _ = conn.respond(impl:handleAddEvent(jsonPayload));

    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/get"
    }
    resource getAllEvent (http:Connection conn,http:InRequest req) {
        _ = conn.respond(impl:handleGetAllEventRequest(req));
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/delete/{name}"
    }
    resource deleteEvent (http:Connection conn,http:InRequest req, string name) {
        // Need to implement
    }
    
}



