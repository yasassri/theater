package portal.connectors;

import ballerina/config;
import ballerina/io;
import ballerina/net.http;

const string ticketServiceEP = "http://localhost:9092";
//const string ticketServiceEPC = config:getGlobalValue("ticket.endpoint");

endpoint http:ClientEndpoint ticketClientEP { targets: [{uri:ticketServiceEP}] };

public function addTicket (json payload) returns json | error {

    http:Request req = {};
    req.setJsonPayload(payload);
    var response = ticketClientEP -> post("/tickets/add", req);
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

public function getTicket (string id) returns json | error {

    http:Request req = {};
    var response = ticketClientEP -> get("/tickets/get/" + id, req);
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

//updateTicket
public function updateTicket (int id, int count) returns json | error {

    http:Request req = {};
    var response = ticketClientEP -> post("/tickets/update/" + id + "/" + count, req);
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
