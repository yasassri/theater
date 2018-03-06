package src.serviceImpl;

import ballerina.test;
import ballerina.net.http;
import ballerina.io;

import src.model as mod;

@Description {value:"This is a mock function"}
@test:mock {
    packageName : "src.persistance" ,
    functionName : "addNewEvent"
}
function mockAddNewEvent (mod:Event a) (json jsonResponse,error err) {
    io:println("I'm the mockIntAdd!");
    jsonResponse = {
                       "Success": "Ballerina50 event is Created",
                       "id": "2"
                   };
    return;
}

@Description {value:"Tests valid Payload for Event add request"}
@test:config{}
function testValidPayload () {

    json addEventPayLoad = {
                               "name": "Ballerina55",
                               "start_time": "5.25",
                               "venue": "WSO2",
                               "organizer_name": "Tyler",
                               "event_type": "Ballet"
                           };

    http:OutResponse res = {};
    res = handleAddEvent(addEventPayLoad);

    json assertResponse = {
                           "Success": "Ballerina50 event is Created",
                           "id": "2"
                          };

    test:assertEquals(res.getJsonPayload(), assertResponse, "Response Didn't match");
}

