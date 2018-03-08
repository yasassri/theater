package src.serviceImpl;

import ballerina.io;
import ballerina.net.http;
import ballerina.test;
import src.model as mod;

@Description {value:"This is a mock function"}
@test:mock {
    packageName:"src.persistance",
    functionName:"addNewEvent"
}
function mockAddNewEvent (mod:Event evnt) (json jsonResponse, error err) {
    io:println("I'm the mockIntAdd!");
    // Getting different
    if (evnt.name == "negative") {
        jsonResponse = {
                           "Success":"Ballerina50 event is Created",
                           "id":"2"
                       };
    }
    jsonResponse = {
                       "Success":"Ballerina50 event is Created",
                       "id":"2"
                   };
    return;
}

@Description {value:"Tests valid Payload for Event add request"}
@test:config {}
function testValidPayload () {

    json addEventPayLoad = {
                               "name":"Ballerina55",
                               "start_time":"5.25",
                               "venue":"WSO2",
                               "organizer_name":"Tyler",
                               "event_type":"Ballet"
                           };

    http:OutResponse res = {};
    res = handleAddEvent(addEventPayLoad);

    json assertResponse = {
                              "Success":"Ballerina50 event is Created",
                              "id":"2"
                          };

    var jsonPayload, _ = req.getJsonPayload();
    // Assert the payload
    test:assertEquals(jsonPayload, assertResponse, "Response Didn't match");

    // assert the response code
    test:assertEquals(res.statusCode, 200, "Response Didn't match");
}


@Description {value:"Tests invalid Payload for Event add request"}
@test:config {}
function testInvalidPayload () {

    json addEventPayLoad = {
                               "name":"Ballerina55",
                               "start_time":"5.25"
                           };

    http:OutResponse res = {};
    res = handleAddEvent(addEventPayLoad);

    json assertResponse = {"There was a Error":"cannot convert 'json' to type 'src.model:Event': error while mapping 'venue': no such field found in json"};
    test:assertEquals(res.getJsonPayload(), assertResponse, "Response Didn't match");
    test:assertEquals(res.statusCode, 500, "Response Didn't match");
}


