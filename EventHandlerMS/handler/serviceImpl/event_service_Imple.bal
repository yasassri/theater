package src.serviceImpl;

import ballerina.net.http;
import ballerina.io;
import src.persistance as persist;
import src.model as mod;
import src.utils as util;

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
// Parsing a function pointer to make it testable
public function handleAddEvent (json jsonPayload)
                               (http:OutResponse res) {
    res = {};
    var event, err = <mod:Event> jsonPayload;
        if (err != null) {
            // The payload is not what we expected
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return;
        }
    
    var payload, err = persist:addNewEvent(event);

    if (err != null) {    
        res.setJsonPayload(util:generateJsonFromError(err));
        res.statusCode = 500;
        return;
       }
    res.setJsonPayload(payload);
    res.statusCode = 200;
    return;   
}