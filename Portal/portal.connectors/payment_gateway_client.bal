package portal.connectors;


import ballerina.config;
import ballerina.net.http;

const string paymentGWServiceEP = "http://localhost:9094";
const string paymentGWServiceEPC = config:getGlobalValue("payment.endpoint");

public function makePayment (json payload) (json resPl, int status) {


    endpoint http:ClientEndpoint paymentGWClientEP {
            targets: [{uri:paymentGWServiceEP}]
           };

    http:Request req = {};
    http:Response resp = {};
    req.setJsonPayload(payload);
    resp, _ = paymentGWClientEP -> post("/boc/payment", req);
    resPl, _ = resp.getJsonPayload();
    status = resp.statusCode;
    return;
}
