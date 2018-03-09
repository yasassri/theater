package tests;

import ballerina.test;
import ballerina.net.http;
import ballerina.io;
import ballerina.data.sql;


const string h2DbLocation = "./";
const string h2Database = "EVENTS";
string eventServiceEp;


@Description {value: "Before function to start the service"}
@test:beforeSuite {}
function startaEventService() {
    // Starting the EventDataService
    eventServiceEp = test:startService("eventsDataService");
    // Starting the service will initialize the DB in this sample app.
    io:println(eventServiceEp);
}


function truncateTable () {
    endpoint<sql:ClientConnector> ep {
        create sql:ClientConnector(sql:DB.H2_FILE, h2DbLocation, 0, h2Database, "root", "root", null);
    }
    io:println("Truncating the table");
    // Truncate the table to make sure data doesn't exist.
    var a = ep.update("TRUNCATE TABLE EVENTS", null);
}


@test:config {
    before: "truncateTable"
}
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
    io:println("DDDDDDDDD");
    io:println(p);

    test:assertEquals(err, null, "Error while getting the Json payload");
    test:assertEquals(p, expectedResponse, "Payload didn't match");
}

@Description {value: "Test Get events"}
@test:config {
    dependsOn: ["testAddEventWithValidPayload"]
}
function testAGetEventService () {
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

    http:OutRequest req = {};
    http:InResponse resp = {};

    resp, _ = httpEndpoint.get("/get", req);
    var p, err = resp.getJsonPayload();
    io:println("XXXXXX=========+XXXXXXXXXXXX");
    io:println(p);
    //test:assertEquals(err, null, "Error while getting the Json payload");
    //test:assertEquals(p, expectedResponse, "Payload didn't match");
}


