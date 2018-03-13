package event.handler.services;

import ballerina.test;
import ballerina.net.http;

import event.handler.model as mod;
import ballerina.io;

// We will mock the DB function and test the services here
// This uses following features of testerina
// before test functions, After test functions, service start capability

string eventServiceEp;

@Description {value:"This is a mock function to mock DB operations"}
@test:mock {
    packageName:"src.persistence",
    functionName:"addNewEvent"
}
function mockAddNewEvent (mod:Event evnt) (json jsonResponse, error err) {

    if (evnt.name == "negative") {
        err = {message:"Error"};
        return;
    }
    jsonResponse = {
                       "Success":"Ballerina event is Created",
                       "id":"2"
                   };
    return;
}

@Description {value: "Before function to start the service"}
@test:beforeSuite {}
function startaEventService() {
    eventServiceEp = test:startService("eventsDataService");
}

@test:config {}
function testAddEventServiceWithValidPayload () {
    // HTTP endpoint to call event service
    endpoint<http:Client> httpEndpoint {
       serviceUri: eventServiceEp
    }

    json addEventPl = {
                          "name": "Ballerina",
                          "start_time": "5.25",
                          "venue": "WSO2",
                          "organizer_name": "Tyler",
                          "event_type": "Ballet"
                      };
    json expectedResponse = {"Success":"Ballerina event is Created","id":"2"};
    http:Request req = {};
    req.setJsonPayload(addEventPl);

    http:Response resp = {};
    resp, _ = httpEndpoint.post("/add", req);
    var p, err = resp.getJsonPayload();

    test:assertEquals(err, null, "Error while getting the Json payload");
    test:assertEquals(p, expectedResponse, "Payload didn't match");
}
