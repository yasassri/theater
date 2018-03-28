package event.handler.serviceImpl;

import ballerina/net.http;
import ballerina/io;

import event.handler.persistence as persist;
import event.handler.model as mod;
import event.handler.utils as util;

// Service implementation to handle get service request
public function handleGetAllEventRequest (http:Request req) returns http:Response {

    http:Response res = {};
    var events = persist:getAllEvents();
    match events {
        json payload => {
            res.setJsonPayload(payload);
            res.statusCode = 200;
            return res;
        }
        error err => {
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return res;
        }
    }
}

// Service implementation to handle get service request
// Parsing a function pointer to make it testable
public function handleAddEvent (json jsonPayload) returns http:Response {

    http:Response res = {};
    mod:Event evt = {};
    error|null validateError = util:validateEventRequest(jsonPayload);
    match validateError {
    error vErr => {
        res.setJsonPayload(util:generateJsonFromError(vErr));
        res.statusCode = 500;
        return res;
    }
    null => {
    io:println("Message was validated successfully");
    }
}

    var event = <mod:Event> jsonPayload;
    match event {
        mod:Event evnt => {
            io:println("No Issue when converting");
            evt = evnt;
        }
        error err => {
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return res;
        }
    }

    var persistResult = persist:addNewEvent(evt);
    match persistResult {
        json payload => {
            res.setJsonPayload(payload);
            res.statusCode = 200;
            return res;
        }
        error err => {
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            return res;
        }
    }
}
