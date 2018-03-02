package src.model;

// Model struct Add Event Request
public struct AddEvent {

    string name;
    string start_time;
    string venue;
    string organizer_name;
    string event_type;
    Ticket [] tickets; 
}

// Model struct Add Ticket request
public struct AddTicket {
    Ticket [] ticket;
}

struct Ticket {
    string ticketType;
    int eventId;
    int total_tickets;
    int booked_tickets;
    float price;

}