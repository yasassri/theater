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

public struct Ticket {
    string ticket_type;
    int total;
    int booked;
    float price;

}

// Struct to represent purchase request
public struct PurchaseTicket {
    int eventId;
    string ticket_type;
    int noOfTickets;

    CredCardInfo cardInfo;
}

// Represent credit Card info
public struct CredCardInfo {
    
    int cardNo;
    int cvcNo;
    string expireDate;
    string cardHolderName;
}
