package ticketing.services;
import ballerina.net.http;
import ticketing.serviceImpl as impl;
@http:configuration {
    basePath:"/tickets",
    port:9092
}
service<http> TicketDataService {
    @http:resourceConfig {
        methods:["GET"],
        path:"get/{eventID}"
    }
    resource getTickets (http:Connection conn, http:InRequest req, string eventID) {
        var id, _ = <int>eventID;
        _ = conn.respond(impl:hadleGetTicketsByEventId(id));
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"add"
    }
    resource addTickets (http:Connection conn, http:InRequest req) {
        var jsonPayload, _ = req.getJsonPayload();
        _ = conn.respond(impl:handleAddTickets(jsonPayload));
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"update/{ticketID}/{count}"
    }
    resource updateTickets (http:Connection conn, http:InRequest req, string ticketID, string count) {
        _ = conn.respond(impl:handleUpdateTickets(ticketID, count));
    }
}