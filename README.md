# Theatre

A ballerina based Theatre manager which handles events and issuance of tickets.


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

````
End Point :

http://localhost:9090/portal/events
`````
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

Send a get request to portal endpoint
 
 ````
 End Point :
 
 http://localhost:9090/portal/events
 ````
 
 Response
 
 ````
 [
   {
 "ID": 3,
 "NAME": "Ballerina54",
 "START_TIME": "5.25",
 "VENUE": "WSO2",
 "ORGANIZER_NAME": "Tyler"
 }
 ],
 ````

### Get Ticket info by Event ID

````
Endpoint : 

http://localhost:9090/portal/tickets/{Event_ID}
````

Response

````json
[
  {
"id": 3,
"event_id": 3,
"total": 10,
"booked": 0,
"ticket_type": "BALCONY",
"price": 250
},
  {
"id": 4,
"event_id": 3,
"total": 50,
"booked": 0,
"ticket_type": "BOX",
"price": 1000
}
]
````

### Purchasing Tickets

