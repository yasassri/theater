package src.services;

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

    resource creditOperations (http:Connection conn,http:InRequest req, string eventID) {
        // Expects an API Token
        http:OutResponse res = {};

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

        json jsonRes = {"Payment" : "Sucess!"};
        res.statusCode = 200;
        res.setJsonPayload(jsonRes);
            _ = conn.respond(res);
        }
    }