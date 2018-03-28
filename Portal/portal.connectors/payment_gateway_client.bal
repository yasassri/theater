package portal.connectors;


import ballerina/config;
import ballerina/net.http;

const string paymentGWServiceEP = "http://localhost:9094";
//const string paymentGWServiceEPC = config:getGlobalValue("payment.endpoint");

public function makePayment (json payload) returns  error | null {


    endpoint http:ClientEndpoint paymentGWClientEP { targets: [{uri:paymentGWServiceEP}] };

    http:Request req = {};
    req.setJsonPayload(payload);
    var response = paymentGWClientEP -> post("/boc/payment", req);
    match response {
        http:Response resp =>  {
            if (resp.statusCode != 200) {
                error err = {message : "Couldn't complete the transaction to payment GW"};
                return err;
                  }
            return null;
        }
        http:HttpConnectorError er => {
            error err = { message : er.message };
            return err;
        }
    }
}
