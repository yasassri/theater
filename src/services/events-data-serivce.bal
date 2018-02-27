import ballerina.net.http;
import ballerina.time;
import ballerina.io;
import ballerina.data.sql;

string tableName = "EVENTS";
// table: CREATE TABLE events(ID INT AUTO_INCREMENT, NAME VARCHAR(255), START_TIME  VARCHAR(255), VENUE VARCHAR(255), ORGANIZER_NAME VARCHAR(255), PRIMARY KEY (ID));
sql:ClientConnector dbConnector = create sql:ClientConnector(sql:DB.MYSQL, "localhost", 3306,
            "events_db", "root", "root", {maximumPoolSize:5});

@http:configuration {
    basePath:"/events"
}
service<http> eventsDataService {
    endpoint<sql:ClientConnector> testDB {
          dbConnector;
        }

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

        sql:Parameter[] params = [];
        sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:event.name};
        sql:Parameter para2 = {sqlType:sql:Type.VARCHAR, value:event.start_time};
        sql:Parameter para3 = {sqlType:sql:Type.VARCHAR, value:event.venue};
        sql:Parameter para4 = {sqlType:sql:Type.VARCHAR, value:event.organizer_name};


        table dt = testDB.select("SELECT * FROM "+tableName+" WHERE NAME = ?", [para1], null);
        var jsonRes, err = <json>dt;
        json jsonResponse;
        if (jsonRes != null && !jsonRes.toString().equalsIgnoreCase("[]")) {
            jsonResponse = {"error" : event.name + " event is already added."};
            res.statusCode = 400;
            res.setJsonPayload(jsonResponse);
                _ = conn.respond(res);
            return;
        }

        params = [para1, para2, para3, para4];
        int ret = testDB.update("INSERT INTO "+tableName+" (NAME,START_TIME,VENUE,ORGANIZER_NAME) VALUES (?,?,?,?)", params);
        
        if (ret == 1) {
            jsonResponse, _ = <json>event;
        } else {
            jsonResponse = {"error" : event.name + " event could not be added."};
            res.statusCode = 400;
        }

            res.setJsonPayload(jsonResponse);
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
        table dt = selectEventByName(para1);
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
        table dt = selectEventByName(para1);
        var jsonRes, e = <json>dt;
        if (e != null) {
            _ = conn.respond(errorToJson(e, res));
            return;
        } else {
            json jsonResponse;
            if (jsonRes.toString().equalsIgnoreCase("[]")) {
                jsonResponse = {"error" : name + " event does not exist."};
                res.statusCode = 400;
            } else {
                int ret = testDB.update("DELETE FROM "+tableName+" WHERE NAME = ?", [para1]);
                if (ret == 1) {
                    jsonResponse = {"success" : name + " event deleted successfully."};
                    res.statusCode = 200;
                } else {
                    jsonResponse = {"error" : name + " event could not be deleted."};
                    res.statusCode = 400;
                }
                
            }
            res.setJsonPayload(jsonResponse);
            _ = conn.respond(res);
        }
    }
    
}

function selectEventByName (sql:Parameter para1)(table) {
    endpoint<sql:ClientConnector> testDB {
          dbConnector;
        }

    return testDB.select("SELECT * FROM "+tableName+" WHERE NAME = ?", [para1], null);
}

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
