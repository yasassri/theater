package event.handler.serviceImpl;

import ballerina/io;
import ballerina/net.http;
import ballerina/test;
import event.handler.model as mod;

@Description {value:"This is a mock function"}
@test:Mock {
    packageName:"event.handler.persistence",
    functionName:"addNewEvent"
}
function mockAddNewEvent (mod:Event evnt) returns json | error {

    if (evnt.name == "negative") {
        error err = {message:"Error"};
        return err;
    }
    json jsonResponse = {
                       "Success":"Ballerina50 event is Created",
                       "id":"2"
                   };
    return jsonResponse;
}

@Description {value:"Tests valid Payload for Event add request"}
@test:Config
function testValidPayload () {

    json addEventPayLoad = {
                               "name":"Ballerina55",
                               "start_time":"5.25",
                               "venue":"WSO2",
                               "organizer_name":"Tyler",
                               "event_type":"Ballet"
                           };
    json actualResponse = {"Success":"Ballerina50 event is Created", "id":"2"};

    http:Response res = handleAddEvent(addEventPayLoad);

    // If a error occurs while getting the Json payload a error will be thrown and it will fail the test
    var jsonPayload =? res.getJsonPayload();

    // Assert the payload
    test:assertEquals(jsonPayload, actualResponse, msg = "Response Didn't match");

    // assert the response code
    test:assertEquals(res.statusCode, 200, msg = "Response Didn't match");
}


@Description {value:"Tests invalid Payload for Event add request"}
@test:Config {}
function testInvalidPayload () {

    json addEventPayLoad = {
                               "name":"Ballerina55",
                               "start_time":"5.25"
                           };

    json actualResponse = {"There was a Error":"cannot convert 'json' to type 'src.model:Event': error while mapping 'venue': no such field found in json"};

    http:Response res = {};
    res = handleAddEvent(addEventPayLoad);
    var jsonPayload =? res.getJsonPayload();
    io:println("xxxxxxmmmmm-----------");
    io:println(jsonPayload);

    // Assert the response code
    test:assertEquals(res.statusCode, 500, msg = "Response Didn't match");
    test:assertTrue(jsonPayload.toString().contains("There was a Error"),msg = "Response didn't match");
}


@Description {value:"Tests error returned from addNewEvent"}
@test:Config {}
function testErrorReturnedFromDb () {

    json addEventPayLoad = {
                               "name":"negative",
                               "start_time":"5.25",
                               "venue":"WSO2",
                               "organizer_name":"Tyler",
                               "event_type":"Ballet"
                           };
    json actualResponse = {"There was a Error":"Error"};

    http:Response res = {};
    res = handleAddEvent(addEventPayLoad);
    var jsonPayload =? res.getJsonPayload();

    // Assert the payload
    test:assertEquals(jsonPayload, actualResponse, msg = "Response Didn't match");
    // Assert the response code
    test:assertEquals(res.statusCode, 500, msg = "Response Didn't match");
}
