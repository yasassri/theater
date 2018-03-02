package src.services;

import ballerina.net.http;
import ballerina.time;
import ballerina.io;

import src.persistance as persist;
import src.serviceImpl as impl;
import src.model as mod;

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
    resource addEvent (http:Connection conn,http:InRequest req) {
        io:println(req.getJsonPayload());
      _ = conn.respond(impl:handleAddEvent(req.getJsonPayload(), persist:addNewEvent));

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

