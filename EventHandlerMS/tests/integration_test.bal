package tests;

import ballerina.test;
import ballerina.net.http;
import ballerina.io;
import ballerina.data.sql;


const string h2DbLocation = "./";
const string h2Database = "EVENTS";
string eventServiceEp;
string addedEventID;


@Description {value: "Before function to start the service"}
@test:beforeSuite {}
function startaEventService() {
    // Starting the EventDataService
    eventServiceEp = test:startService("eventsDataService");
    // Starting the service will initialize the DB in this sample app.
    io:println(eventServiceEp);
}

function truncateTable () {
    endpoint<sql:ClientConnector> ep { database: sql:DB.H2_FILE, host: dbLocation,port: 0,name: h2Database,username: "root",password: "root"}
    io:println("Truncating the table");
    // Truncate the table to make sure data doesn't exist.
    var a = ep -> update("TRUNCATE TABLE EVENTS", null);
}


@test:config {
    before: "truncateTable"
}
function testAddEventWithValidPayload () {
    // HTTP endpoint to call event service
    endpoint<http:Client> httpEndpoint { serviceUri: eventServiceEp }

    eventServiceEp = test:startService("eventsDataService");

    json addEventPl = {
                          "name": "Ballerina",
                          "start_time": "5.25",
                          "venue": "WSO2",
                          "organizer_name": "Tyler",
                          "event_type": "Ballet"
                      };
    http:Request req = {};
    req.setJsonPayload(addEventPl);

    http:Response resp = {};
    resp, _ = httpEndpoint -> post("/add", req);
    var p, err = resp.getJsonPayload();

    test:assertEquals(err, null, "Error while getting the Json payload");

    addedEventID = p.id.toString();
    test:assertTrue(p.toString().contains("\"Success\":\"Ballerina event is Created\""), "Payload didn't match");
}

// If you want to guarantee that a particular test should be executed before this test we can use dependsOn attribute
@Description {value: "Test Get events"}
@test:config {
    dependsOn: ["testAddEventWithValidPayload"]
}
function testGetEventService () {
    // HTTP endpoint to call event service
  endpoint<http:Client> clientEP {
        serviceUri: eventServiceEp
    }
    eventServiceEp = test:startService("eventsDataService");

    http:OutRequest req = {};
    http:InResponse resp = {};

    resp, _ = httpEndpoint.get("/get", req);
    var p, err = resp.getJsonPayload();
    test:assertEquals(p[0].ID.toString(), addedEventID, "Event IDs didn't match" );
}

@Description {value: "Stop the service"}
@test:beforeSuite {}
function stopEventService() {
    // Starting the service will initialize the DB in this sample app.
    io:println("Stopping the service!");
}
