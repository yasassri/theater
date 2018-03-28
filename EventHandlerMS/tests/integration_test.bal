package tests;

import ballerina/test;
import ballerina/net.http;
import ballerina/io;
import ballerina/data.sql;


const string h2DbLocation = "./";
const string h2Database = "EVENTS";
string eventServiceEp;
string addedEventID;

public endpoint sql:Client dbEP2 { database: sql:DB.H2_FILE, host: h2DbLocation,name: h2Database};

@Description {value: "Before function to start the service"}
@test:BeforeSuite
function startaEventService() {
    // Starting the EventDataService
    boolean x = test:startServices("event.handler.services");
    io:println("=========");
    io:println(x);
    // Starting the service will initialize the DB in this sample app.
    eventServiceEp = "http://localhost:9093/events";
    io:println(eventServiceEp);
}

function truncateTable () {
    io:println("Truncating the table");
    // Truncate the table to make sure data doesn't exist.
    var a = dbEP2 -> update("TRUNCATE TABLE EVENTS", null);
}

@test:Config {
    before: "truncateTable"
}
function testAddEventWithValidPayload () {
    // HTTP endpoint to call event service
    endpoint http:ClientEndpoint httpEndpoint {
        targets: [{uri:eventServiceEp}]
    };

    json addEventPl = {
                          "name": "Ballerina",
                          "start_time": "5.25",
                          "venue": "WSO2",
                          "organizer_name": "Tyler",
                          "event_type": "Ballet"
                      };
    http:Request req = {};
    req.setJsonPayload(addEventPl);
    var resp =? httpEndpoint -> post("/add", req);
    var p =? resp.getJsonPayload();
    //test:assertEquals(err2, null, msg = "Error while getting the Json payload");
    addedEventID = p.id.toString();
    test:assertTrue(p.toString().contains("\"Success\":\"Ballerina event is Created\""), msg = "Payload didn't match");
}

// If you want to guarantee that a particular test should be executed before this test we can use dependsOn attribute
@Description {value: "Test Get events"}
@test:Config {
    dependsOn: ["testAddEventWithValidPayload"]
}
function testGetEventService () {
    // HTTP endpoint to call event service
    endpoint http:ClientEndpoint httpEndpoint {
        targets: [{uri:eventServiceEp}]
    };

    http:Request req = {};
    var resp =? httpEndpoint -> get("/get", req);
    var p =? resp.getJsonPayload();

    if (p[0].ID != null) {
        test:assertEquals(p[0].ID.toString(), addedEventID, msg = "Event IDs didn't match" );
    }
}

@Description {value: "Stop the service"}
@test:AfterSuite
function stopEventService() {
    // Starting the service will initialize the DB in this sample app.
    test:stopServices("event.handler.services");
    io:println("Stopping the service!");
}
