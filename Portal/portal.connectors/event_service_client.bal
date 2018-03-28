package portal.connectors;

import ballerina/config;
import ballerina/net.http;


const string eventServiceEP = "http://localhost:9093";
//const string eventServiceEPC = config:getGlobalValue("event.endpoint");

public function addEvent (json payload) returns json | error {

    endpoint http:ClientEndpoint clientEP { targets: [{uri:eventServiceEP}] };

    http:Request req = {};
    req.setJsonPayload(payload);
    var response = clientEP -> post("/events/add", req);
    match response {
        http:Response resp =>  {
            if (resp.statusCode != 200) {
                error err = {message : resp.statusCode };
                return err;
                  }
            var js = resp.getJsonPayload();
            match js {
                error err => return err;
                json j => return j;
            }
        }
        http:HttpConnectorError er => {
            error err = { message : er.message };
            return err;
        }
    }
}

public function getEvents () returns json | error {

    endpoint http:ClientEndpoint clientEP { targets: [{uri:eventServiceEP}] };
    http:Request req = {};
    var response = clientEP -> get("/events/get", req);
    match response {
        http:Response resp =>  {
            var js = resp.getJsonPayload();
            match js {
               error err => return err;
                json j => return j;
            }
        }
        http:HttpConnectorError er => {
            error err = { message : er.message };
            return err;
       }
    }
}