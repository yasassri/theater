package src.services;

import ballerina.net.http;
import ballerina.time;
import ballerina.io;
import ballerina.data.sql;

import src.persistance as ops;

@http:configuration {
    basePath:"/tickets"
}
    service<http> eventsDataService {
 @http:resourceConfig {
        methods:["GET"],
        path:"get/{eventID}"
    }

    resource getTickets (http:Connection conn,http:InRequest req, string eventID) {
        http:OutResponse res = {};
       
        var id, _ = <int> eventID;
        json jsonRes = ops:getTicketCountByEventId(id);
        res.setJsonPayload(jsonRes);
            _ = conn.respond(res);
        }

    @http:resourceConfig {
        methods:["POST"],
        path:"add/{eventID}/{ticketNo}"
    }

//     resource addTickets (http:Connection conn,http:InRequest req, string eventID, string ticketNo) {
//         http:OutResponse res = {};
       
//         var id, _ = <int> eventID;
//         var ticketNumber, _ = <int> ticketNo;
//         json jsonRes = ops:addTicketCountByEventId(id, ticketNumber);
//         res.setJsonPayload(jsonRes);
//             _ = conn.respond(res);
//         }

//         @http:resourceConfig {
//         methods:["POST"],
//         path:"buy/{eventID}/{ticletNo}"
//     }

//     resource buyTickets (http:Connection conn,http:InRequest req, string eventID, string ticketNo) {
//         http:OutResponse res = {};
       
//         var id, _ = <int> eventID;
//         var ticketNumber, _ = <int> ticketNo;
//         json jsonRes = ops:addTicketCountByEventId(id, ticketNumber);
//         res.setJsonPayload(jsonRes);
//             _ = conn.respond(res);
//         }
//     }