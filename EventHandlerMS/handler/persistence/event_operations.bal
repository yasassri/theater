package src.persistance;
import ballerina.io;
import src.model as mod;
const string tableName = "events";
const string getAllEventsQuery = "SELECT * from " + tableName;

public function addNewEvent(mod:Event event) (json jsonResponse,error err) {
    endpoint<sql:ClientConnector> ep {
    }
    bind sqlCon with ep;
    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR,value:event.name};
    sql:Parameter para2 = {sqlType:sql:Type.VARCHAR,value:event.start_time};
    sql:Parameter para3 = {sqlType:sql:Type.VARCHAR,value:event.venue};
    sql:Parameter para4 = {sqlType:sql:Type.VARCHAR,value:event.organizer_name};
    
    // First Check if existing event is present.
    var existingID = getEventIDByName(event.name);
    io:println(existingID);
    if (!existingID.equalsIgnoreCase("0")) {
        err = {message:"Event Already Exists"};
        return jsonResponse ,err;
    }

    params = [para1,para2,para3,para4];
    int ret = ep.update("INSERT INTO " + tableName + " (NAME,START_TIME,VENUE,ORGANIZER_NAME) VALUES (?,?,?,?)",params);
    
    if (ret == 1) {
        jsonResponse = {"Success":event.name + " event is Created", "id" : getEventIDByName(event.name)};
    } else {
        err = {message:"Event " + event.name + " Couldn't be added"};
    }
    return jsonResponse ,err;
}

// Get the event ID by Name
public function getEventIDByName (string name)(string id) {

endpoint<sql:ClientConnector> ep{}
bind sqlCon with ep;

sql:Parameter[] params = [];
sql:Parameter para1 = {sqlType:sql:Type.VARCHAR,value:name};
params = [para1];
table dt = ep.select("SELECT ID FROM " + tableName + " WHERE NAME = ?", params, null);

var jsonRes,err = <json>dt;
if (lengthof jsonRes > 0) {
id = jsonRes[0].ID.toString();
} else {
    id = "0";
}
//id = jsonRes.id.toString();
return;    
}

// Get all events
public function getAllEvents() (json,error) {
    endpoint<sql:ClientConnector> ep{
    }
    bind sqlCon with ep;
    table dt = ep.select(getAllEventsQuery,null,null);
    error err;
    var res,err = <json>dt;
    return res ,err;
}
