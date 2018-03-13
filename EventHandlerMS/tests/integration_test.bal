package tests;

import ballerina.test;
import ballerina.net.http;
import ballerina.io;
import ballerina.data.sql;


const string h2DbLocation = "./";
const string h2Database = "EVENTS";
string eventServiceEp;
string addedEventID;

public endpoint<sql:Client> dbEP2 { database: sql:DB.H2_FILE, host: h2DbLocation,port: 0,name: h2Database,username: "root",password: "root"}

@Description {value: "Before function to start the service"}
@test:beforeSuite
function startaEventService() {
    // Starting the EventDataService
    eventServiceEp = test:startService("eventsDataService");
    // Starting the service will initialize the DB in this sample app.
    eventServiceEp= "http://localhost:9093/events";
    io:println(eventServiceEp);
}

function truncateTable () {
    io:println("Truncating the table");
    // Truncate the table to make sure data doesn't exist.
    var a = dbEP2 -> update("TRUNCATE TABLE EVENTS", null);
}


@test:config {
    before: "truncateTable"
}
function testAddEventWithValidPayload () {
    // HTTP endpoint to call event service
    endpoint<http:Client> httpEndpoint { serviceUri: eventServiceEp }


    json addEventPl = {
                          "name": "Ballerina",
                          "start_time": "5.25",
                          "venue": "WSO2",
                          "organizer_name": "Tyler",
                          "event_type": "Ballet"
                      };
    http:Request req = {};
    req.setJsonPayload(addEventPl);
    var resp, err1 = httpEndpoint -> post("/add", req);
    var p, err2 = resp.getJsonPayload();
    test:assertEquals(err2, null, "Error while getting the Json payload");
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
  endpoint<http:Client> httpEndpoint {
        serviceUri: eventServiceEp
    }

    http:Request req = {};
    var resp, ex = httpEndpoint -> get("/get", req);
    var p, err = resp.getJsonPayload();

    if (p[0].ID != null) {
        test:assertEquals(p[0].ID.toString(), addedEventID, "Event IDs didn't match" );
    }
}

@Description {value: "Stop the service"}
@test:afterSuite
function stopEventService() {
    // Starting the service will initialize the DB in this sample app.
    io:println("Stopping the service!");
}
