package ticketing.services;

import ballerina/net.http;

endpoint http:ServiceEndpoint paymentGWEP {
port:9094
};

@http:ServiceConfig {
      endpoints:[paymentGWEP], basePath:"/boc"
}
service<http:Service> PaymentService bind paymentGWEP {
    @http:ResourceConfig {
        methods:["POST"],
        path:"/payment"
    }

     creditOperations (endpoint conn, http:Request req, string eventID) {
        // Expects an API Token
        http:Response res = {};

        json jsonRes = {"Payment":"Sucess!"};
        res.statusCode = 200;
        res.setJsonPayload(jsonRes);
        _ = conn -> respond(res);
    }
}