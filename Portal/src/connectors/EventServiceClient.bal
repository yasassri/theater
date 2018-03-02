package src.connectors;
import ballerina.net.http;
import ballerina.config;
import ballerina.io;
const string eventServiceEP = "http://localhost:9093";
const string eventServiceEPC = config:getGlobalValue("event.endpoint");


public function addEvent(json payload) (json,int) {
    
    endpoint<http:HttpClient> httpEndpoint{create http:HttpClient(eventServiceEP,{});
    }
    http:OutRequest req = {};
    req.setJsonPayload(payload);
    var resp,e = httpEndpoint.post("/events/add",req);
    return resp.getJsonPayload() ,resp.statusCode;
}

public function getEvents() (json resPl) {
    
    endpoint<http:HttpClient> httpEndpoint{create http:HttpClient(eventServiceEP,{});
    }
    http:OutRequest req = {};
    http:InResponse resp = {};
    resp,_ = httpEndpoint.get("/events/get",req);
    resPl = resp.getJsonPayload();
    return ;
}