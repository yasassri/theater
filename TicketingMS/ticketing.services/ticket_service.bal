package ticketing.services;
import ballerina.net.http;
import ticketing.serviceImpl as impl;


endpoint<http:Service> ticketServiceEP {
port:9092
}

@http:serviceConfig {
      endpoints:[ticketServiceEP], basePath:"/tickets"
}
service<http:Service> TicketDataService {
    @http:resourceConfig {
        methods:["GET"],
        path:"get/{eventID}"
    }
    resource getTickets (http:ServerConnector conn, http:Request req, string eventID) {
        var id, _ = <int>eventID;
        _ = conn -> respond(impl:hadleGetTicketsByEventId(id));
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"add"
    }
    resource addTickets (http:ServerConnector conn, http:Request req) {
        var jsonPayload, _ = req.getJsonPayload();
        _ = conn -> respond(impl:handleAddTickets(jsonPayload));
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"update/{ticketID}/{count}"
    }
    resource updateTickets (http:ServerConnector conn, http:Request req, string ticketID, string count) {
        _ = conn -> respond(impl:handleUpdateTickets(ticketID, count));
    }
}