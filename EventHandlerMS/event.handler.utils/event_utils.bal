package event.handler.utils;

import ballerina/io;

import event.handler.model as mod;

public function generateJsonFromError (error err) returns json {
   json jErr = { "There was a Error" : err.message };
   return jErr;
}

public function validateEventRequest (json jsonObj) returns null |error {
    error err = {message : "Invalid payload!"};
    try {
        if (jsonObj.name.toString() == "") {
             err.message = "Name is a mandatory field, please specify the name";
             return err;
            }
        if (jsonObj.start_time.toString() == "") {
            err.message = "start_time is a mandatory field, please specify the time";
            return err;
            }
        if (jsonObj.venue.toString() == "") {
            err.message = "Vanue is a mandatory field, please specify the venue";
            return err;
            }
        } catch (error e) {
            return e;
        }
    return null;
}
