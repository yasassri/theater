package event.handler.services;

import ballerina/test;
import ballerina/net.http;

import event.handler.model as mod;
import ballerina/io;

// We will mock the DB function and test the services here
// This uses following features of testerina
// before test functions, After test functions, service start capability

string eventServiceEp;

@Description {value:"This is a mock function to mock DB operations"}
@test:Mock {
    packageName:"event.handler.persistence",
    functionName:"addNewEvent"
}
function mockAddNewEvent (mod:Event evnt)  returns json | error {

    if (evnt.name == "negative") {
        error err = {message:"Error"};
        return err;
    }
    json jsonResponse = {
                       "Success":"Ballerina event is Created",
                       "id":"2"
                   };
    return jsonResponse;
}

@Description {value: "Before function to start the service"}
@test:BeforeSuite
function startEventService() {
    _ = test:startServices("event.handler.services");
    // Setting this temporarily till the endpoint is available
    eventServiceEp = "http://localhost:9093/events";
}

@test:Config
function testAddEventServiceWithValidPayload () {
    // HTTP endpoint to call event service
    endpoint http:ClientEndpoint httpEndpoint {
       targets: [{uri:eventServiceEp}]
    };

    json addEventPl = {
                          "name": "Ballerina",
                          "start_time": "5.25",
                          "venue": "WSO2",
                          "organizer_name": "Tyler"
                      };
    json expectedResponse = {"Success":"Ballerina event is Created","id":"2"};
    http:Request req = {};
    req.setJsonPayload(addEventPl);

    http:Response resp = {};
    resp =? httpEndpoint -> post("/add", req);
    var p = resp.getJsonPayload();

    //test:assertEquals(err, null, msg = "Error while getting the Json payload");
    test:assertEquals(p, expectedResponse, msg = "Payload didn't match");
}
