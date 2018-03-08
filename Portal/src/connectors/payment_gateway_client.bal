package src.connectors;


import ballerina.config;
import ballerina.net.http;

const string paymentGWServiceEP = "http://localhost:9094";
const string paymentGWServiceEPC = config:getGlobalValue("payment.endpoint");

public function makePayment (json payload) (json resPl, int status) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(paymentGWServiceEP, {});
    }

    http:OutRequest req = {};
    http:InResponse resp = {};
    req.setJsonPayload(payload);
    resp, _ = httpEndpoint.post("/boc/payment", req);
    resPl, _ = resp.getJsonPayload();
    status = resp.statusCode;
    return;
}
