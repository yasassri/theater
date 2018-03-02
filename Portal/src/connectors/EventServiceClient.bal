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
    
    req.setJsonPayload("POST: Hello World");
    resp, _ = httpEndpoint.post("/events/add", req);
    io:println("\nPOST request:");
    io:println(resp.getJsonPayload());
return;
}


public function getEvents ()(json resPl) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(eventServiceEP, {});
    }
    
    http:OutRequest req = {};
    http:InResponse resp = {};
    
    req.setJsonPayload("POST: Hello World");
    resp, _ = httpEndpoint.get("/events/get", req);
    resPl = resp.getJsonPayload();
return;
}