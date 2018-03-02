package src.connectors;

import ballerina.net.http;
import  ballerina.config;
import ballerina.io;

const string ticketServiceEP = "http://localhost:9092";
const string ticketServiceEPC = config:getGlobalValue("ticket.endpoint");

public function addTicket (json payload)(json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(ticketServiceEP, {});
    }
    
    http:OutRequest req = {};
    http:InResponse resp = {};
    io:println("XXXXXXXXXXXXXX1111111111111111111111");
    io:println(payload);
    req.setJsonPayload(payload);
    resp, _ = httpEndpoint.post("/tickets/add", req);
    resPl = resp.getJsonPayload();
    io:println("XXXXXXXXXXXXXX");
    io:println(resPl);
return;
}