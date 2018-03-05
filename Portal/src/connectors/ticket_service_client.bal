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
    req.setJsonPayload(payload);
    resp, _ = httpEndpoint.post("/tickets/add", req);
    resPl = resp.getJsonPayload();
return;
}

public function getTicket (string id)(json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(ticketServiceEP, {});
    }
    
    http:OutRequest req = {};
    http:InResponse resp = {};
    resp, _ = httpEndpoint.get("/tickets/get/" + id, req);
    resPl = resp.getJsonPayload();
return;
}

//updateTicket
public function updateTicket (int id, int count)(json resPl) {
     endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(ticketServiceEP, {});
    }
    
    http:OutRequest req = {};
    http:InResponse resp = {};
    resp, _ = httpEndpoint.post("/tickets/update/"+id+"/"+count, req);
    resPl = resp.getJsonPayload();
return; 
    }




