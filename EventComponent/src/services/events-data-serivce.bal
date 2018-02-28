package src.services;

import ballerina.net.http;
import ballerina.time;
import ballerina.io;

import src.persistance as ops;

string tableName = "EVENTS";
// table: CREATE TABLE events(ID INT AUTO_INCREMENT, NAME VARCHAR(255), START_TIME  VARCHAR(255), VENUE VARCHAR(255), ORGANIZER_NAME VARCHAR(255), PRIMARY KEY (ID));
// sql:ClientConnector dbConnector = create sql:ClientConnector(sql:DB.MYSQL, "localhost", 3306,
//             "events_db", "root", "root", {maximumPoolSize:5});

@http:configuration {
    basePath:"/events"
}
service<http> eventsDataService {
    // endpoint<sql:ClientConnector> testDB {
    //       dbConnector;
    //     }

    @http:resourceConfig {
        methods:["POST"],
        path:"/"
    }
    resource addEvent (http:Connection conn,http:InRequest req) {
        http:OutResponse res = {};
        json jsonPayload = req.getJsonPayload();
        var event, e = <Event> jsonPayload;
        if (e != null) {
            _ = conn.respond(errorToJson(e, res));
            return;
        }

      var payload, status = ops:addNewEvent(event.name, event.start_time, event.venue, event.organizer_name);
       
      res.setJsonPayload(payload);
      res.statusCode = status;
      _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/{name}"
    }
    resource getEvent (http:Connection conn,http:InRequest req, string name) {
        http:OutResponse res = {};
        map params = req.getQueryParams();

        sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:name};
        table dt;
        var jsonRes, e = <json>dt;
        if (e != null) {
            _ = conn.respond(errorToJson(e, res));
            return;
        } else {
            if (jsonRes.toString().equalsIgnoreCase("[]")) {
                jsonRes = {"error" : name + " event does not exist."};
                res.statusCode = 400;
            }
            res.setJsonPayload(jsonRes);
            _ = conn.respond(res);
        }
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/{name}"
    }
    resource deleEvent (http:Connection conn,http:InRequest req, string name) {
        http:OutResponse res = {};
        map params = req.getQueryParams();

        sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:name};
        //table dt = selectEventByName(para1);
        // //var jsonRes, e = <json>dt;
        // if (e != null) {
        //     _ = conn.respond(errorToJson(e, res));
        //     return;
        // } else {
        //     json jsonResponse;
        //     if (jsonRes.toString().equalsIgnoreCase("[]")) {
        //         jsonResponse = {"error" : name + " event does not exist."};
        //         res.statusCode = 400;
        //     } else {
                // int ret = testDB.update("DELETE FROM "+tableName+" WHERE NAME = ?", [para1]);
                // if (ret == 1) {
                //     jsonResponse = {"success" : name + " event deleted successfully."};
                //     res.statusCode = 200;
                // } else {
                //     jsonResponse = {"error" : name + " event could not be deleted."};
                //     res.statusCode = 400;
                // }
                
            // }
            json jsonResponse = "";
            res.setJsonPayload(jsonResponse);
            _ = conn.respond(res);
        // }
    }
    
}

// function selectEventByName (sql:Parameter para1)(table) {
//     // endpoint<sql:ClientConnector> testDB {
//     //       dbConnector;
//     //     }

//     return testDB.select("SELECT * FROM "+tableName+" WHERE NAME = ?", [para1], null);
// }

function errorToJson (error e, http:OutResponse res) (http:OutResponse) {
            var jsonError, _ = <json> e;
            res.setJsonPayload(jsonError);
            res.statusCode = 400;
            return res;
}

// Represents a single event
struct Event {
    // name of the event
    string name;
    // start time of the event
    string start_time;
    // venue
    string venue;
    // string organizer name
    string organizer_name;
}
