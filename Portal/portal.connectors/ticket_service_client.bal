package portal.connectors;

import ballerina.config;
import ballerina.io;
import ballerina.net.http;

const string ticketServiceEP = "http://localhost:9092";
const string ticketServiceEPC = config:getGlobalValue("ticket.endpoint");

public function addTicket (json payload) (json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(ticketServiceEP, {});
    }

    http:OutRequest req = {};
    http:InResponse resp = {};
    req.setJsonPayload(payload);
    resp, _ = httpEndpoint.post("/tickets/add", req);
    error e;
    resPl, e = resp.getJsonPayload();
    io:println("DDDDDDDDDDDDDDDDDDDDd");
    io:println(resPl);
    io:println(e);

    return;
}

public function getTicket (string id) (json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(ticketServiceEP, {});
    }

    http:OutRequest req = {};
    http:InResponse resp = {};
    resp, _ = httpEndpoint.get("/tickets/get/" + id, req);
    resPl, _ = resp.getJsonPayload();
    io:println(resPl);
    return;
}

//updateTicket
public function updateTicket (int id, int count) (json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(ticketServiceEP, {});
    }

    http:OutRequest req = {};
    http:InResponse resp = {};
    resp, _ = httpEndpoint.post("/tickets/update/" + id + "/" + count, req);
    resPl, _ = resp.getJsonPayload();
    return;
}




