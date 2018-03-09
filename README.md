# event-manager

A ballerina Theatre manager which handles events and issuance of tickets.


This sample is intended to  demonstrate testerina capabilities.


# How to get the sample up and Running

Download the tools distribution and ballerina website.
Setup ballerina runtime by adding ballerina executable to runtime execution path.
Navigate tp EventHandlerMS and execute and execute
````shell
ballerina run event.handler.services
````
Now navigate to TicketingMS and execute and execute

````shell
ballerina run ticketing.services
````
Now start the composite portal service by navigating to Portal and executing      
````shell
ballerina run portal.services
````

Now you can perform following operation os the applications

### Add Events

Send a POST request to portal endpoint with the following payload.
````json
{
  "name": "Ballerina",
  "start_time": "5.25",
  "venue": "WSO2",
  "organizer_name": "Tyler",
  "event_type": "Ballet",
  "tickets": [
    {
      "ticket_type": "BALCONY",
      "total": 10,
      "booked": 0,
      "price": 250.00
    },
    {
      "ticket_type": "BOX",
      "total": 50,
      "booked": 0,
      "price": 1000.00
    }
  ]
}
````

### Get Existing Events

