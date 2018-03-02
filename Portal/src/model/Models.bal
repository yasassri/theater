package src.model;

// Model struct Add Event Request
public struct AddEvent {

    string ticketType;
    int eventId;
    int total_tickets;
    int booked_tickets;
    float price;

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