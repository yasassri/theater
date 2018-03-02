package src.connectors;

import ballerina.net.http;
import  ballerina.config;
import ballerina.io;

const string eventServiceEP = "http://localhost:9093";
const string eventServiceEPC = config:getGlobalValue("event.endpoint");

public function addEvent (json payload)(json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(eventServiceEP, {});
    }
    
    http:OutRequest req = {};
    http:InResponse resp = {};
    
    req.setJsonPayload(payload);
    resp, _ = httpEndpoint.post("/events/add", req);
    io:println(resp.getJsonPayload());
return;
}

// Get Events from the event service
public function getEvents ()(json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(eventServiceEP, {});
    }
    
    http:OutRequest req = {};
    http:InResponse resp = {};
 
    resp, _ = httpEndpoint.get("/events/get", req);
    resPl = resp.getJsonPayload();
return;
}