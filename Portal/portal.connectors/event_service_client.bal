package portal.connectors;

import ballerina.config;
import ballerina.net.http;


const string eventServiceEP = "http://localhost:9093";
const string eventServiceEPC = config:getGlobalValue("event.endpoint");

public function addEvent (json payload) (json, int) {

    endpoint http:ClientEndpoint clientEP {
        targets: [{uri:eventServiceEP}]
        };

    http:Request req = {};
    req.setJsonPayload(payload);
    var resp, e = clientEP -> post("/events/add", req);
    var jsonPayload, _ = resp.getJsonPayload();
    return jsonPayload, resp.statusCode;
}

public function getEvents () (json resPl) {

    endpoint http:ClientEndpoint clientEP {
targets: [{uri:eventServiceEP}]
           };
    http:Request req = {};
    http:Response resp = {};
    resp, _ = clientEP -> get("/events/get", req);
    resPl, _ = resp.getJsonPayload();
    return;
}