package src.services;

import ballerina.io;
import ballerina.net.http;
import src.serviceImpl as impl;

string tableName = "EVENTS";
// table: CREATE TABLE events(ID INT AUTO_INCREMENT, NAME VARCHAR(255), START_TIME  VARCHAR(255), VENUE VARCHAR(255), ORGANIZER_NAME VARCHAR(255), PRIMARY KEY (ID));
// sql:ClientConnector dbConnector = create sql:ClientConnector(sql:DB.MYSQL, "localhost", 3306,
//             "events_db", "root", "root", {maximumPoolSize:5});

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
        io:println(jsonPayload);
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

