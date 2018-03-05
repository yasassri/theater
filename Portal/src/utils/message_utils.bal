package src.utils;

import ballerina.io;
import src.model as mod;

// Generates a Json error message from a provided error
public function generateJsonFromError (error err) (json jErr) {
    jErr = {"There was a Error":err.message};
    return;
}

// Generaates the Event Add reqest with the provided struct
public function generateEventRequest (mod:AddEvent event) (json js) {
    js = {"name":event.name, "start_time":event.start_time, "venue":event.venue, "organizer_name":event.organizer_name, "event_type":event.event_type};
    return;
}

// Get Ticket struct for a given Type
public function getTicketByType (json js, string tType) (mod:Ticket ticketStruct, int id) {

    ticketStruct = null;
    error err;
    foreach ticket in js {
        if (ticket.ticket_type.toString() == tType) {
            io:println(ticket);
            ticketStruct, err = <mod:Ticket>ticket;
            id, _ = (int)ticket.id;
            return;
        }
    }
    return;
}