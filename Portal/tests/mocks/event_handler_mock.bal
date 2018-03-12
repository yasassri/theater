package tests;

import ballerina.net.http;

@http:configuration {
    basePath:"/events",
    port:9093
}
service<http> EventMSMock {

    @http:resourceConfig {
        methods:["POST"],
        path:"/add"
    }
    resource addEvent (http:Connection conn, http:InRequest req) {
        var jsonPayload, _ = req.getJsonPayload();


        http:OutResponse res = {};
        json pl = {};

        if (jsonPayload.name.toString() == "negative") {
            pl = {"There was a Error":"Event Already Exists"};
            res.setJsonPayload(pl);
            res.statusCode = 500;
            _ = conn.respond(res);
            return;
        }

        pl = {"Success":"Ballerina2 event is Created", "id":"2" };
        res.setJsonPayload(pl);
        res.statusCode = 200;
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/get"
    }
    resource getAllEvent (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        json pl = [{"ID":1, "NAME":"Ballerina", "START_TIME":"5.25", "VENUE":"WSO2", "ORGANIZER_NAME":"Tyler"}];
        res.setJsonPayload(pl);
        res.statusCode = 200;

        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/delete/{name}"
    }
    resource deleteEvent (http:Connection conn, http:InRequest req, string name) {
        // Need to implement
    }
}




