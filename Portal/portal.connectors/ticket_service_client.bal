package portal.connectors;

import ballerina.config;
import ballerina.io;
import ballerina.net.http;

const string ticketServiceEP = "http://localhost:9092";
const string ticketServiceEPC = config:getGlobalValue("ticket.endpoint");

                                       endpoint http:ClientEndpoint ticketClientEP {
targets: [{uri:ticketServiceEP}]
           };

public function addTicket (json payload) (json resPl) {

    http:Request req = {};
    http:Response resp = {};
    req.setJsonPayload(payload);
    resp, _ = ticketClientEP -> post("/tickets/add", req);
    error e;
    resPl, e = resp.getJsonPayload();

    return;
}

public function getTicket (string id) (json resPl) {

    http:Request req = {};
    http:Response resp = {};
    resp, _ = ticketClientEP -> get("/tickets/get/" + id, req);
    resPl, _ = resp.getJsonPayload();
    io:println(resPl);
    return;
}

//updateTicket
public function updateTicket (int id, int count) (json resPl) {

    http:Request req = {};
    http:Response resp = {};
    resp, _ = ticketClientEP -> post("/tickets/update/" + id + "/" + count, req);
    resPl, _ = resp.getJsonPayload();
    return;
}




