package src.serviceImpl;

import ballerina.net.http;
import ballerina.io;
import src.persistance as persist;
import src.model as mod;

// Service implementation to handle get service request
public function handleGetAllEventRequest (http:InRequest req)(http:OutResponse res) {
res = {};
var pl, err = persist:getAllEvents();
if (err != null) {    
    res.setJsonPayload(err.message);
    res.statusCode = 500;
    return;
}
res.setJsonPayload(pl);
res.statusCode = 200;
return;   
}


// Service implementation to handle get service request
public function handleAddEvent (json jsonPayload, function (mod:Event event)(json jsonResponse, error err) persistFunction)
                               (http:OutResponse res) {
res = {};


var event1, err = <mod:Event> jsonPayload;
io:println("xxxxxxxxxxxxxxxxx");
io:println(event1);
io:println(err);
io:println("xxxxxxxxxxxxxxxxx");
        if (err != null) {
            // The payload is not what we expected
            res.setJsonPayload(err.message);
            res.statusCode = 500;
            return;
        }

    //var payload, err = persist:addNewEvent(event1);

    // if (err != null) {    
    //     res.setJsonPayload(err.message);
    //     res.statusCode = 500;
    //     return;
    //    }
    // res.setJsonPayload(payload);
    // res.statusCode = 200;
    return;   
}

// public struct Event {
//     // name of the event
//     string name;
//     // start time of the event
//     string start_time;
//     // venue
//     string venue;
//     // string organizer name
//     string organizer_name;
// }