package portal.connectors;

import ballerina.config;
import ballerina.net.http;


const string eventServiceEP = "http://localhost:9093";
const string eventServiceEPC = config:getGlobalValue("event.endpoint");

public function addEvent (json payload) (json, int) {

    endpoint<http:HttpClient> httpEndpoint {create http:HttpClient(eventServiceEP, {});
    }
    http:OutRequest req = {};
    req.setJsonPayload(payload);
    var resp, e = httpEndpoint.post("/events/add", req);
    var jsonPayload, _ = resp.getJsonPayload();
    return jsonPayload, resp.statusCode;
}

public function getEvents () (json resPl) {

    endpoint<http:HttpClient> httpEndpoint {create http:HttpClient(eventServiceEP, {});
    }
    http:OutRequest req = {};
    http:InResponse resp = {};
    resp, _ = httpEndpoint.get("/events/get", req);
    resPl, _ = resp.getJsonPayload();
    return;
}