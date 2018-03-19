package ticketing.services;
import ballerina.net.http;
import ticketing.serviceImpl as impl;


endpoint http:ServiceEndpoint ticketServiceEP { port:9092 };

@http:ServiceConfig {
      basePath:"/tickets"
}
service <http:Service> TicketDataService bind ticketServiceEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"get/{eventID}"
    }
    getTickets (endpoint conn, http:Request req, string eventID) {
        var id, _ = <int>eventID;
        _ = conn -> respond(impl:hadleGetTicketsByEventId(id));
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"add"
    }
     addTickets (endpoint conn, http:Request req) {
        var jsonPayload, _ = req.getJsonPayload();
        _ = conn -> respond(impl:handleAddTickets(jsonPayload));
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"update/{ticketID}/{count}"
    }
     updateTickets (endpoint conn, http:Request req, string ticketID, string count) {
        _ = conn -> respond(impl:handleUpdateTickets(ticketID, count));
    }
}