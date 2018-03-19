package event.handler.serviceImpl;

import ballerina.io;
import ballerina.net.http;
import ballerina.test;
import event.handler.model as mod;

@Description {value:"This is a mock function"}
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
    json actualResponse = {"Success":"Ballerina50 event is Created", "id":"2"};

    http:Response res = {};
    //
    res = handleAddEvent(addEventPayLoad);

    var jsonPayload, err = res.getJsonPayload();

    // Check whether there is an Error when getting the payload
    test:assertEquals(err, null, msg = "There was an error when getting the JsonPayload");
    // Assert the payload
    test:assertEquals(jsonPayload, actualResponse, msg = "Response Didn't match");

    // assert the response code
    test:assertEquals(res.statusCode, 200, msg = "Response Didn't match");
}


@Description {value:"Tests invalid Payload for Event add request"}
@test:config {}
function testInvalidPayload () {

    json addEventPayLoad = {
                               "name":"Ballerina55",
                               "start_time":"5.25"
                           };

    json actualResponse = {"There was a Error":"cannot convert 'json' to type 'src.model:Event': error while mapping 'venue': no such field found in json"};

    http:Response res = {};
    res = handleAddEvent(addEventPayLoad);
    var jsonPayload, err = res.getJsonPayload();

    // Check whether there is an Error when getting the payload
    test:assertEquals(err, null, msg = "There was an error when getting the JsonPayload");
    // Assert the response code
    test:assertEquals(res.statusCode, 500, msg = "Response Didn't match");
    test:assertTrue(jsonPayload.toString().contains("There was a Error"),msg = "Response didn't match");
}


@Description {value:"Tests error returned from addNewEvent"}
@test:config {}
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
    var jsonPayload, err = res.getJsonPayload();
    test:assertEquals(err, null, msg = "There was an error when getting the JsonPayload");
    // Assert the payload
    test:assertEquals(jsonPayload, actualResponse, msg = "Response Didn't match");
    // Assert the response code
    test:assertEquals(res.statusCode, 500, msg = "Response Didn't match");
}
