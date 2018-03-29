package portal.utils;

import ballerina/io;

import portal.model as mod;

// Generates a Json error message from a provided error
public function generateJsonFromError (error err) returns json {
    json jErr = {"Error":err.message};
    return jErr;
}

// Generaates the Event Add request with the provided struct
public function generateEventRequest (mod:AddEvent event) returns json {
    json js = {"name":event.name, "start_time":event.start_time, "venue":event.venue, "organizer_name":event
                                                                           .organizer_name, "event_type":event.event_type};
    return js;
}

// Get Ticket struct for a given Type
public function getTicketByType (json js, string tType) returns (mod:Ticket, int) | null {

    foreach ticket in js {
        if (ticket.ticket_type.toString() == tType) {
            io:println(ticket);
            var ticketStruct =? <mod:Ticket>ticket;
            var id = <int>ticket.id.toString();
            return (ticketStruct, id);
        }
    }
    return null;
}