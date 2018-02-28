package src.persistance;

const string getTicketByID = "SELECT * FROM tickets where EVENT_ID = ?";
const string addTicketByID = "INSERT INTO tickets (EVENT_ID, TOTAL, BOOKED) VALUES (?, ?, 0)";

// tickets table
// CREATE TABLE tickets(ID INT AUTO_INCREMENT, EVENT_ID INT, TOTAL INT, BOOKED INT, PRIMARY KEY (ID));

public function getTicketCountByEventId (int eventId)(json) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:eventId};
    params = [ para1 ];
    table dt = ep.select(getTicketByID, params, null);
    
    var jsonRes, err = <json>dt;
    // Check for errors

    return jsonRes;
}


public function addTicketCountByEventId (int ticketNumber, int eventId)(json) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:ticketNumber};
    sql:Parameter para2 = {sqlType:sql:Type.VARCHAR, value:eventId};
    params = [ para1, para2 ];
    int dt = ep.update(addTicketByID, params);
    
    var jsonRes = "success " + dt;
    // Check for errors

    return jsonRes;
}
