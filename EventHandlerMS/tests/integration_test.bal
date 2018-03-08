package tests;

import ballerina.test;
import ballerina.net.http;
import ballerina.io;

string eventServiceEp;

@Description {value: "Before function to start the service"}
@test:beforeSuite {}
function startaEventService() {
    //svc:dummy();
    io:println("In Before Suite");
    eventServiceEp = test:startService("eventsDataService");

    // Starting the service will initialize the DB in this sample app.

    io:println("dddddddddddddddd");
    io:println(eventServiceEp);
}

@test:config {}
function testAddEventWithValidPayload () {
    // HTTP endpoint to call event service
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(eventServiceEp, {});
    }
    eventServiceEp = test:startService("eventsDataService");

    json addEventPl = {
                          "name": "Ballerina",
                          "start_time": "5.25",
                          "venue": "WSO2",
                          "organizer_name": "Tyler",
                          "event_type": "Ballet"
                      };
    json expectedResponse = {"Success":"Ballerina event is Created","id":"2"};
    http:OutRequest req = {};
    req.setJsonPayload(addEventPl);

    http:InResponse resp = {};
    resp, _ = httpEndpoint.post("/add", req);
    var p, err = resp.getJsonPayload();

    test:assertEquals(err, null, "Error while getting the Json payload");
    test:assertEquals(p, expectedResponse, "Payload didn't match");
}




