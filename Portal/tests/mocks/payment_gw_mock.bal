package tests;

import ballerina.net.http;

@http:configuration {
    basePath:"/boc",
    port:9094
}
service<http> PaymentService {
    @http:resourceConfig {
        methods:["POST"],
        path:"/payment"
    }

    resource creditOperations (http:Connection conn, http:InRequest req, string eventID) {
        http:OutResponse res = {};

        json jsonRes = {"Payment":"Sucess!"};
        res.statusCode = 200;
        res.setJsonPayload(jsonRes);
        _ = conn.respond(res);
    }
}