package event.handler.persistence;


import ballerina/io;
import event.handler.model as mod;
const string tableName = "events";
const string getAllEventsQuery = "SELECT * from " + tableName;

public function addNewEvent(mod:Event event) returns json | error {

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR,value:event.name};
    sql:Parameter para2 = {sqlType:sql:Type.VARCHAR,value:event.start_time};
    sql:Parameter para3 = {sqlType:sql:Type.VARCHAR,value:event.venue};
    sql:Parameter para4 = {sqlType:sql:Type.VARCHAR,value:event.organizer_name};

    // First Check if existing event is present.
    var existingID =? getEventIDByName(event.name);
    if (!existingID.equalsIgnoreCase("")) {
        error err = {message:"Event Already Exists"};
        return err;
    }

    params = [para1,para2,para3,para4];
    var ret = dbEP -> update("INSERT INTO " + tableName + " (NAME,START_TIME,VENUE,ORGANIZER_NAME) VALUES (?,?,?,?)",
                           params);
    match ret {
        error err => {
            return err;
        }
        int res => {
            existingID =? getEventIDByName(event.name);
            json jsonResponse = {"Success":event.name + " event is Created", "id" : existingID };
            return jsonResponse;
        }
    }
}

 //Get the event ID by Name
public function getEventIDByName (string name) returns (string) | sql:SQLConnectorError {

//endpoint<sql:Client> ep{}
//bind sqlCon with ep;

sql:Parameter[] params = [];
sql:Parameter para1 = {sqlType:sql:Type.VARCHAR,value:name};
params = [para1];
var dt2 = dbEP -> select("SELECT ID FROM " + tableName + " WHERE NAME = ?", params, null);
match dt2 {
    table tbl => {
        var jsonRes =? <json>tbl;
        string id;
        if (lengthof jsonRes > 0) {
            id = jsonRes[0].ID.toString();
        }
        return id;
    }
    sql:SQLConnectorError err => {
        io:println("Error Occured");
        return err;
    }
}
}

// Get all events
public function getAllEvents() returns json | error {

    var dt = dbEP -> select(getAllEventsQuery, null, null);
    match dt {
        error err => {
            return err;
        }
        table tbl => {
            var res = <json>tbl;
            match res {
                json js => {
                    return js;
                }
                error err => {
                    return err;
                }
            }
        }
    }
}
