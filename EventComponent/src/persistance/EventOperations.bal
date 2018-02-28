package src.persistance;

import ballerina.io;

string tableName = "events";

public function addNewEvent (string event, string time, string venue, string organizerName)(json jsonResponse, int status) {

    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] params = [];
        sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:event};
        sql:Parameter para2 = {sqlType:sql:Type.VARCHAR, value:time};
        sql:Parameter para3 = {sqlType:sql:Type.VARCHAR, value:venue};
        sql:Parameter para4 = {sqlType:sql:Type.VARCHAR, value:organizerName};


        table dt = ep.select("SELECT * FROM "+tableName+" WHERE NAME = ?", [para1], null);
        var jsonRes, err = <json>dt;
        
        if (jsonRes != null && !jsonRes.toString().equalsIgnoreCase("[]")) {
            jsonResponse = {"error" : event + " event is already added."};
            status = 400;
            return jsonResponse, status;
        }

        params = [para1, para2, para3, para4];
        int ret = ep.update("INSERT INTO "+tableName+" (NAME,START_TIME,VENUE,ORGANIZER_NAME) VALUES (?,?,?,?)", params);
        
        if (ret == 1) {
            jsonResponse = {"Success" : event + " event is Created"};
            io:println(jsonRes);
            status = 200;
        } else {
            jsonResponse = {"error" : event + " event could not be added."};
            status = 400;
        }
        io:println(jsonResponse);
    return jsonResponse, status;
}
