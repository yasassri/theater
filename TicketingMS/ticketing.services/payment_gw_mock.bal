package ticketing.services;

import ballerina.net.http;

endpoint<http:Service> paymentGWEP {
port:9094
}

@http:serviceConfig {
      endpoints:[paymentGWEP], basePath:"/boc"
}
service<http:Service> PaymentService {
    @http:resourceConfig {
        methods:["POST"],
        path:"/payment"
    }

    resource creditOperations (http:ServerConnector conn, http:Request req, string eventID) {
        // Expects an API Token
        http:Response res = {};

        // Service expects following Json
        //{
        //    "cardNo": 123456789,
        //    "cvc": 225,
        //    "ExpireDate": "2018/11",
        //    "ammount": 525,
        //    "currency": "LKR",
        //    "mechantID": 55452254,
        //    "remarks": "From Paul"
        // }

        json jsonRes = {"Payment":"Sucess!"};
        res.statusCode = 200;
        res.setJsonPayload(jsonRes);
        _ = conn -> respond(res);
    }
}