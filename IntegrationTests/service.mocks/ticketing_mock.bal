package service.mocks;


import ballerina.net.http;

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

        http:OutResponse res = {};
        json pl = [
                  {
                      "id":1,
                      "event_id":1,
                      "total":10,
                      "booked":0,
                      "ticket_type":"BALCONY",
                      "price":250
                  }
                  ];
        res.setJsonPayload(pl);
        res.statusCode = 200;
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"add"
    }
    resource addTickets (http:Connection conn, http:InRequest req) {
        var jsonPayload, _ = req.getJsonPayload();

        http:OutResponse res = {};
        json pl = {"Success":"1 added tickets successfully"};
        res.setJsonPayload(pl);
        res.statusCode = 200;
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"update/{ticketID}/{count}"
    }
    resource updateTickets (http:Connection conn, http:InRequest req, string ticketID, string count) {

        http:OutResponse res = {};
        json pl = { "Success": "1 updated successfully" };
        res.setJsonPayload(pl);
        res.statusCode = 200;
        _ = conn.respond(res);
    }
}